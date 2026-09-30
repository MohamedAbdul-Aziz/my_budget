import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/database/local_records.dart';
import '../../../../core/database/record_batch.dart';

abstract interface class SyncLocalDataSource {
  /// The account this phone's data has been synced with, if any.
  Future<String?> owner();

  Future<void> setOwner(String userId);

  Future<DateTime?> lastSyncedAt(String userId);

  Future<void> setLastSyncedAt(String userId, DateTime at);

  /// Every row changed on this phone since it was last uploaded.
  Future<RecordBatch> pendingChanges();

  /// Marks [uploaded] as seen by the cloud.
  Future<void> markUploaded(RecordBatch uploaded);

  /// Applies the cloud's rows wherever they are newer than the phone's.
  /// Returns how many rows changed on the phone.
  Future<int> merge(RecordBatch cloud);

  /// Unlinks the phone's data from the deleted account [userId] and queues
  /// all of it for the next backup, whoever makes it.
  Future<void> forgetAccount(String userId);
}

/// Sync bookkeeping (who the data belongs to, when it last synced) lives
/// here; moving the records themselves is [LocalRecords]' job, shared with
/// the file backup.
class SyncLocalDataSourceImpl implements SyncLocalDataSource {
  const SyncLocalDataSourceImpl(this._appDatabase, this._records);

  static const String _ownerKey = 'owner';

  final AppDatabase _appDatabase;
  final LocalRecords _records;

  @override
  Future<String?> owner() =>
      _guard('read sync owner', () => _readMeta(_ownerKey));

  @override
  Future<void> setOwner(String userId) =>
      _guard('save sync owner', () => _writeMeta(_ownerKey, userId));

  @override
  Future<DateTime?> lastSyncedAt(String userId) =>
      _guard('read last sync', () async {
        final value = await _readMeta(_lastSyncedKey(userId));
        final millis = value == null ? null : int.tryParse(value);
        return millis == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(millis);
      });

  @override
  Future<void> setLastSyncedAt(String userId, DateTime at) => _guard(
    'save last sync',
    () => _writeMeta(_lastSyncedKey(userId), '${at.millisecondsSinceEpoch}'),
  );

  @override
  Future<RecordBatch> pendingChanges() => _records.readPending();

  @override
  Future<void> markUploaded(RecordBatch uploaded) =>
      _records.markUploaded(uploaded);

  @override
  Future<int> merge(RecordBatch cloud) =>
      _records.mergeNewest(cloud, fromCloud: true);

  @override
  Future<void> forgetAccount(String userId) => _guard(
    'forget deleted account',
    () async {
      final db = await _appDatabase.database;
      await db.transaction((txn) async {
        await txn.delete(
          'sync_meta',
          where: 'key = ? OR (key = ? AND value = ?)',
          whereArgs: [_lastSyncedKey(userId), _ownerKey, userId],
        );
        // Deleted rows only existed to carry the delete to that account's
        // cloud copy, which is gone now. Expenses and recurring payments
        // first: a deleted category row cannot go while anything still
        // points at it.
        await txn.delete('expenses', where: 'deleted_at IS NOT NULL');
        await txn.delete('recurring_expenses', where: 'deleted_at IS NOT NULL');
        await txn.delete(
          'categories',
          where:
              'deleted_at IS NOT NULL '
              'AND id NOT IN (SELECT category_id FROM expenses) '
              'AND id NOT IN (SELECT category_id FROM recurring_expenses)',
        );
        // Everything left is news to whichever account backs up next.
        for (final table in [
          'categories',
          'expenses',
          'settings',
          'recurring_expenses',
        ]) {
          await txn.update(table, {'dirty': 1});
        }
      });
    },
  );

  static String _lastSyncedKey(String userId) => 'last_synced_at:$userId';

  Future<String?> _readMeta(String key) async {
    final db = await _appDatabase.database;
    final rows = await db.query(
      'sync_meta',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<void> _writeMeta(String key, String value) async {
    final db = await _appDatabase.database;
    await db.insert('sync_meta', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<T> _guard<T>(String action, Future<T> Function() body) async {
    try {
      return await body();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('$action: $error');
    }
  }
}
