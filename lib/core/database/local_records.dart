import 'package:sqflite/sqflite.dart';

import '../../features/categories/domain/entities/expense_category.dart';
import '../error/failures.dart';
import 'app_database.dart';
import 'record_batch.dart';

/// Moves whole sets of records in and out of the phone's database. The cloud
/// sync and the file backup both go through here, so a record follows the
/// same rules whichever way it travels.
///
/// Every write happens in one transaction: a failure part way through leaves
/// the database exactly as it was.
class LocalRecords {
  const LocalRecords(this._appDatabase);

  final AppDatabase _appDatabase;

  /// Every record, deleted ones included: they carry the delete to wherever
  /// the records end up.
  Future<RecordBatch> readAll() => _guard('read records', () async {
    final db = await _appDatabase.database;
    return RecordBatch(
      categories: await db.query('categories', orderBy: 'sort_order, id'),
      expenses: await db.query('expenses', orderBy: 'date, created_at, id'),
      settings: await db.query('settings', orderBy: 'key'),
    );
  });

  /// Every record changed on this phone since it was last uploaded.
  Future<RecordBatch> readPending() => _guard('read changes', () async {
    final db = await _appDatabase.database;
    return RecordBatch(
      categories: await db.query('categories', where: 'dirty = 1'),
      expenses: await db.query('expenses', where: 'dirty = 1'),
      settings: await db.query('settings', where: 'dirty = 1'),
    );
  });

  /// Marks [uploaded] as seen by the cloud.
  Future<void> markUploaded(RecordBatch uploaded) =>
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

  /// Newest wins: an incoming record replaces the phone's only when its
  /// `updated_at` is later, deletes included, and a record the phone has
  /// never seen is added unless it is already deleted. Nothing that exists
  /// only on the phone is touched, and applying the same records twice
  /// changes nothing the second time.
  ///
  /// [fromCloud] marks the applied records as already in the cloud. Records
  /// from anywhere else are left for the next cloud backup to upload.
  ///
  /// Returns how many records changed on the phone.
  Future<int> mergeNewest(RecordBatch incoming, {required bool fromCloud}) =>
      _guard('merge records', () async {
        final db = await _appDatabase.database;
        final dirty = fromCloud ? 0 : 1;
        return db.transaction((txn) async {
          var applied = 0;

          // Categories first: an incoming expense may belong to a category
          // that only now arrives.
          for (final row in incoming.categories) {
            if (await _applyIfNewer(txn, 'categories', 'id', row, dirty)) {
              applied++;
            }
          }
          final known = await _categoryIds(txn);
          for (final row in incoming.expenses) {
            final safe = _withKnownCategory(row, known);
            if (await _applyIfNewer(txn, 'expenses', 'id', safe, dirty)) {
              applied++;
            }
          }
          for (final row in incoming.settings) {
            if (await _applyIfNewer(txn, 'settings', 'key', row, dirty)) {
              applied++;
            }
          }

          return applied + await _rehomeOrphans(txn);
        });
      });

  /// Makes the phone hold exactly [incoming]: everything else is deleted and
  /// the incoming version of every record wins, whatever its age.
  ///
  /// Deletes are marked rather than removed, so a signed-in user's next cloud
  /// backup carries them. Every written record is stamped as changed now:
  /// replacing is a deliberate choice, and an older copy in the cloud must
  /// not bring back what it replaced. Dates and creation times are kept.
  ///
  /// Returns how many records were written or deleted.
  Future<int> replaceAll(RecordBatch incoming) => _guard(
    'replace records',
    () async {
      final db = await _appDatabase.database;
      return db.transaction((txn) async {
        final now = AppDatabase.nowMillis();
        final deleted = {'deleted_at': now, 'updated_at': now, 'dirty': 1};

        // Delete everything that is live, then write the incoming records
        // back over it: whatever the file does not contain stays deleted.
        // The fallback category is never deleted.
        final removedExpenses = await _liveIdsMissingFrom(
          txn,
          'expenses',
          incoming.expenses,
        );
        final removedCategories = await _liveIdsMissingFrom(
          txn,
          'categories',
          incoming.categories,
        );
        removedCategories.remove(ExpenseCategory.fallbackId);
        await txn.update('expenses', deleted, where: 'deleted_at IS NULL');
        await txn.update(
          'categories',
          deleted,
          where: 'deleted_at IS NULL AND id != ?',
          whereArgs: [ExpenseCategory.fallbackId],
        );
        // Settings have no deleted marker: one the file never changed goes
        // back to its default.
        final incomingKeys = {for (final row in incoming.settings) row['key']};
        final removedSettings = [
          for (final row in await txn.query('settings', columns: ['key']))
            if (!incomingKeys.contains(row['key'])) row['key'],
        ];
        await txn.delete('settings');

        Map<String, Object?> stamped(Map<String, Object?> row) => {
          ...row,
          'updated_at': now,
          'dirty': 1,
        };
        for (final row in incoming.categories) {
          await _upsert(txn, 'categories', 'id', stamped(row));
        }
        final known = await _categoryIds(txn);
        for (final row in incoming.expenses) {
          await _upsert(
            txn,
            'expenses',
            'id',
            stamped(_withKnownCategory(row, known)),
          );
        }
        for (final row in incoming.settings) {
          await txn.insert('settings', stamped(row));
        }

        await _rehomeOrphans(txn);
        return incoming.length +
            removedExpenses.length +
            removedCategories.length +
            removedSettings.length;
      });
    },
  );

  Future<bool> _applyIfNewer(
    Transaction txn,
    String table,
    String key,
    Map<String, Object?> row,
    int dirty,
  ) async {
    final existing = await txn.query(
      table,
      columns: ['updated_at'],
      where: '$key = ?',
      whereArgs: [row[key]],
      limit: 1,
    );
    final incoming = {...row, 'dirty': dirty};

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

  /// Update when the record exists, insert otherwise. Not INSERT OR REPLACE:
  /// that deletes the old row first, which the expenses' foreign key forbids
  /// for a category that still has expenses.
  Future<void> _upsert(
    Transaction txn,
    String table,
    String key,
    Map<String, Object?> row,
  ) async {
    final updated = await txn.update(
      table,
      row,
      where: '$key = ?',
      whereArgs: [row[key]],
    );
    if (updated == 0) await txn.insert(table, row);
  }

  Future<Set<String>> _categoryIds(Transaction txn) async => {
    for (final row in await txn.query('categories', columns: ['id']))
      row['id']! as String,
  };

  Future<Set<String>> _liveIdsMissingFrom(
    Transaction txn,
    String table,
    List<Map<String, Object?>> incoming,
  ) async {
    final keep = {for (final row in incoming) row['id']};
    final live = await txn.query(
      table,
      columns: ['id'],
      where: 'deleted_at IS NULL',
    );
    return {
      for (final row in live)
        if (!keep.contains(row['id'])) row['id']! as String,
    };
  }

  /// An expense naming a category that exists nowhere could only come from a
  /// damaged copy. Other keeps the expense rather than failing the whole
  /// operation.
  static Map<String, Object?> _withKnownCategory(
    Map<String, Object?> row,
    Set<String> known,
  ) => known.contains(row['category_id'])
      ? row
      : {...row, 'category_id': ExpenseCategory.fallbackId};

  /// A category deleted elsewhere may still hold expenses that were only
  /// ever recorded here. They move to Other, just as a delete made on this
  /// phone would move them, and are marked for the next upload.
  Future<int> _rehomeOrphans(Transaction txn) => txn.rawUpdate(
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

  static Future<T> _guard<T>(String action, Future<T> Function() body) async {
    try {
      return await body();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('$action: $error');
    }
  }
}
