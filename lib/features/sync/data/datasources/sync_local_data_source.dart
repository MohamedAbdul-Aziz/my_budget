import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../models/sync_batch.dart';

abstract interface class SyncLocalDataSource {
  /// The account this phone's data has been synced with, if any.
  Future<String?> owner();

  Future<void> setOwner(String userId);

  Future<DateTime?> lastSyncedAt(String userId);

  Future<void> setLastSyncedAt(String userId, DateTime at);

  /// Every row changed on this phone since it was last uploaded.
  Future<SyncBatch> pendingChanges();

  /// Marks [uploaded] as seen by the cloud.
  Future<void> markUploaded(SyncBatch uploaded);

  /// Applies the cloud's rows wherever they are newer than the phone's.
  /// Returns how many rows changed on the phone.
  Future<int> merge(SyncBatch cloud);
}

class SyncLocalDataSourceImpl implements SyncLocalDataSource {
  const SyncLocalDataSourceImpl(this._appDatabase);

  static const String _ownerKey = 'owner';

  final AppDatabase _appDatabase;

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
  Future<SyncBatch> pendingChanges() => _guard('read changes', () async {
    final db = await _appDatabase.database;
    return SyncBatch(
      categories: await db.query('categories', where: 'dirty = 1'),
      expenses: await db.query('expenses', where: 'dirty = 1'),
      settings: await db.query('settings', where: 'dirty = 1'),
    );
  });

  @override
  Future<void> markUploaded(SyncBatch uploaded) =>
      _guard('mark changes uploaded', () async {
        final db = await _appDatabase.database;
        final batch = db.batch();
        void clear(String table, String key, List<Map<String, Object?>> rows) {
          for (final row in rows) {
            // A row edited again while the upload ran keeps its new
            // timestamp, stays dirty, and goes up with the next backup.
            batch.update(
              table,
              {'dirty': 0},
              where: '$key = ? AND updated_at = ?',
              whereArgs: [row[key], row['updated_at']],
            );
          }
        }

        clear('categories', 'id', uploaded.categories);
        clear('expenses', 'id', uploaded.expenses);
        clear('settings', 'key', uploaded.settings);
        await batch.commit(noResult: true);
      });

  @override
  Future<int> merge(SyncBatch cloud) => _guard('merge cloud data', () async {
    final db = await _appDatabase.database;
    return db.transaction((txn) async {
      var applied = 0;

      // Categories first: an incoming expense may belong to a category that
      // only now arrives.
      for (final row in cloud.categories) {
        if (await _applyIfNewer(txn, 'categories', 'id', row)) applied++;
      }

      final knownCategories = {
        for (final row in await txn.query('categories', columns: ['id']))
          row['id']! as String,
      };
      for (final row in cloud.expenses) {
        // Only a damaged cloud copy could name a category that does not
        // exist; Other keeps the expense rather than failing the restore.
        final categoryId = row['category_id'];
        final safe = knownCategories.contains(categoryId)
            ? row
            : {...row, 'category_id': ExpenseCategory.fallbackId};
        if (await _applyIfNewer(txn, 'expenses', 'id', safe)) applied++;
      }

      for (final row in cloud.settings) {
        if (await _applyIfNewer(txn, 'settings', 'key', row)) applied++;
      }

      // A category deleted on another phone may still hold expenses that
      // were only ever recorded here. They move to Other, just as a delete
      // made on this phone would move them, and upload with the next backup.
      applied += await txn.rawUpdate(
        '''
        UPDATE expenses
        SET category_id = ?, updated_at = ?, dirty = 1
        WHERE deleted_at IS NULL
          AND category_id IN (
            SELECT id FROM categories WHERE deleted_at IS NOT NULL
          )
        ''',
        [ExpenseCategory.fallbackId, AppDatabase.nowMillis()],
      );

      return applied;
    });
  });

  /// Newest wins: the cloud row replaces the phone's only when its
  /// `updated_at` is later. A row the phone has never seen is added, unless
  /// the cloud copy is already deleted.
  Future<bool> _applyIfNewer(
    Transaction txn,
    String table,
    String key,
    Map<String, Object?> row,
  ) async {
    final existing = await txn.query(
      table,
      columns: ['updated_at'],
      where: '$key = ?',
      whereArgs: [row[key]],
      limit: 1,
    );
    final incoming = {...row, 'dirty': 0};

    if (existing.isEmpty) {
      if (row['deleted_at'] != null) return false;
      await txn.insert(table, incoming);
      return true;
    }

    final localUpdatedAt = (existing.first['updated_at']! as num).toInt();
    if ((row['updated_at']! as num).toInt() <= localUpdatedAt) return false;

    await txn.update(table, incoming, where: '$key = ?', whereArgs: [row[key]]);
    return true;
  }

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
