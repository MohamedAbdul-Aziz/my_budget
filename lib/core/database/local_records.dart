import 'package:sqflite/sqflite.dart';

import '../../features/categories/domain/entities/expense_category.dart';
import '../error/failures.dart';
import 'app_database.dart';
import 'record_batch.dart';
import 'synced_tables.dart';

/// Moves whole sets of records in and out of the phone's database. The cloud
/// sync and the file backup both go through here, so a record follows the
/// same rules whichever way it travels. Every table in [SyncedTables] is
/// handled the same way, by the rules its entry declares.
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
    return RecordBatch({
      for (final table in SyncedTables.all)
        table.name: await db.query(table.name, orderBy: table.orderBy),
    });
  });

  /// Every record changed on this phone since it was last uploaded.
  Future<RecordBatch> readPending() => _guard('read changes', () async {
    final db = await _appDatabase.database;
    return RecordBatch({
      for (final table in SyncedTables.all)
        table.name: await db.query(table.name, where: 'dirty = 1'),
    });
  });

  /// Marks [uploaded] as seen by the cloud.
  Future<void> markUploaded(RecordBatch uploaded) =>
      _guard('mark changes uploaded', () async {
        final db = await _appDatabase.database;
        final batch = db.batch();
        for (final table in SyncedTables.all) {
          for (final row in uploaded[table]) {
            // A row edited again while the upload ran keeps its new
            // timestamp, stays dirty, and goes up with the next backup.
            batch.update(
              table.name,
              {'dirty': 0},
              where: '${table.key} = ? AND updated_at = ?',
              whereArgs: [row[table.key], row['updated_at']],
            );
          }
        }
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
          final applied = await _writeAll(
            txn,
            incoming,
            (table, row) => _applyIfNewer(txn, table, row, dirty),
          );
          return applied +
              await _rehomeOrphans(txn) +
              await _cascadeDeletes(txn);
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
  Future<int> replaceAll(
    RecordBatch incoming,
  ) => _guard('replace records', () async {
    final db = await _appDatabase.database;
    return db.transaction((txn) async {
      final now = AppDatabase.nowMillis();
      final deleted = {'deleted_at': now, 'updated_at': now, 'dirty': 1};

      // Delete everything that is live, then write the incoming records
      // back over it: whatever the file does not contain stays deleted.
      var removed = 0;
      for (final table in SyncedTables.all) {
        final keep = {for (final row in incoming[table]) row[table.key]};
        if (table.softDelete) {
          final live = await txn.query(
            table.name,
            columns: [table.key],
            where: 'deleted_at IS NULL',
          );
          removed += live
              .map((row) => row[table.key])
              .where((id) => !keep.contains(id) && !table.keepIds.contains(id))
              .length;
          final kept = table.keepIds.toList();
          await txn.update(
            table.name,
            deleted,
            where: kept.isEmpty
                ? 'deleted_at IS NULL'
                : 'deleted_at IS NULL AND ${table.key} NOT IN '
                      '(${List.filled(kept.length, '?').join(', ')})',
            whereArgs: kept,
          );
        } else {
          // No deleted marker: a row the file never changed goes back
          // to its default.
          final all = await txn.query(table.name, columns: [table.key]);
          removed += all.where((row) => !keep.contains(row[table.key])).length;
          await txn.delete(table.name);
        }
      }

      await _writeAll(txn, incoming, (table, row) async {
        await _upsert(txn, table, {...row, 'updated_at': now, 'dirty': 1});
        return true;
      });

      await _rehomeOrphans(txn);
      await _cascadeDeletes(txn);
      return incoming.length + removed;
    });
  });

  /// Removes the deleted markers, which only existed to carry deletes to a
  /// cloud copy that is gone, and queues everything left for whichever
  /// account backs up next. Runs inside the caller's [txn].
  static Future<void> forgetCloudCopy(Transaction txn) async {
    // Children first: a deleted row goes only once nothing points at it any
    // more, since the phone's foreign keys forbid it otherwise.
    for (final table in SyncedTables.all.reversed) {
      if (!table.softDelete) continue;
      await txn.delete(
        table.name,
        where: [
          'deleted_at IS NOT NULL',
          for (final referrer in SyncedTables.referrersOf(table))
            '${table.key} NOT IN '
                '(SELECT ${referrer.column} FROM ${referrer.table})',
        ].join(' AND '),
      );
    }
    for (final table in SyncedTables.all) {
      await txn.update(table.name, {'dirty': 1});
    }
  }

  /// Writes every table's rows with [write], parents first. A row pointing
  /// at a category that exists nowhere moves to Other; a row whose parent
  /// exists nowhere is skipped. Either could only come from a damaged copy,
  /// and neither fails everything else. Returns how many rows [write]
  /// reported as written.
  Future<int> _writeAll(
    Transaction txn,
    RecordBatch incoming,
    Future<bool> Function(SyncedTable table, Map<String, Object?> row) write,
  ) async {
    var written = 0;
    for (final table in SyncedTables.all) {
      final rows = incoming[table];
      if (rows.isEmpty) continue;
      // Read just before the table is written, once what it points at is.
      final categoryColumn = table.categoryColumn;
      final categories = categoryColumn == null
          ? null
          : await _ids(txn, SyncedTables.categories.name);
      final parent = table.parent;
      final parents = parent == null ? null : await _ids(txn, parent.table);

      for (final row in rows) {
        if (parent != null && !parents!.contains(row[parent.column])) continue;
        final safe =
            categoryColumn == null || categories!.contains(row[categoryColumn])
            ? row
            : {...row, categoryColumn: ExpenseCategory.fallbackId};
        if (await write(table, safe)) written++;
      }
    }
    return written;
  }

  /// A parent deleted elsewhere may still have rows that were only ever
  /// recorded here: a person's transactions and settlements, a transaction's
  /// change log. They are deleted too, just as deleting the parent on this
  /// phone would delete them, and are marked for the next upload. Tables go
  /// parents first, so a delete reaches grandchildren too.
  Future<int> _cascadeDeletes(Transaction txn) async {
    final now = AppDatabase.nowMillis();
    final deleted = {'deleted_at': now, 'updated_at': now, 'dirty': 1};
    var count = 0;
    for (final table in SyncedTables.all) {
      final parent = table.parent;
      if (parent == null) continue;
      count += await txn.update(
        table.name,
        deleted,
        where:
            'deleted_at IS NULL AND ${parent.column} IN '
            '(SELECT id FROM ${parent.table} WHERE deleted_at IS NOT NULL)',
      );
    }
    return count;
  }

  Future<bool> _applyIfNewer(
    Transaction txn,
    SyncedTable table,
    Map<String, Object?> row,
    int dirty,
  ) async {
    final existing = await txn.query(
      table.name,
      columns: ['updated_at'],
      where: '${table.key} = ?',
      whereArgs: [row[table.key]],
      limit: 1,
    );
    final incoming = {...row, 'dirty': dirty};

    if (existing.isEmpty) {
      if (row['deleted_at'] != null) return false;
      await txn.insert(table.name, incoming);
      return true;
    }

    final localUpdatedAt = (existing.first['updated_at']! as num).toInt();
    if ((row['updated_at']! as num).toInt() <= localUpdatedAt) return false;

    await txn.update(
      table.name,
      incoming,
      where: '${table.key} = ?',
      whereArgs: [row[table.key]],
    );
    return true;
  }

  /// Update when the record exists, insert otherwise. Not INSERT OR REPLACE:
  /// that deletes the old row first, which the expenses' foreign key forbids
  /// for a category that still has expenses.
  Future<void> _upsert(
    Transaction txn,
    SyncedTable table,
    Map<String, Object?> row,
  ) async {
    final updated = await txn.update(
      table.name,
      row,
      where: '${table.key} = ?',
      whereArgs: [row[table.key]],
    );
    if (updated == 0) await txn.insert(table.name, row);
  }

  /// Every id in [table], deleted rows included: a foreign key only needs
  /// the row to exist.
  Future<Set<String>> _ids(Transaction txn, String table) async => {
    for (final row in await txn.query(table, columns: ['id']))
      row['id']! as String,
  };

  /// A category deleted elsewhere may still hold transactions or recurring
  /// payments that were only ever recorded here. They move to Other, or
  /// Other income, just as a delete made on this phone would move them, and
  /// are marked for the next upload.
  Future<int> _rehomeOrphans(Transaction txn) async {
    var moved = 0;
    for (final table in SyncedTables.all) {
      final column = table.categoryColumn;
      if (column == null) continue;
      moved += await txn.rawUpdate(
        '''
        UPDATE ${table.name}
        SET
          $column = CASE (
            SELECT type FROM categories WHERE id = ${table.name}.$column
          ) WHEN 'income' THEN ? ELSE ? END,
          updated_at = ?,
          dirty = 1
        WHERE deleted_at IS NULL
          AND $column IN (
            SELECT id FROM categories WHERE deleted_at IS NOT NULL
          )
        ''',
        [
          ExpenseCategory.incomeFallbackId,
          ExpenseCategory.fallbackId,
          AppDatabase.nowMillis(),
        ],
      );
    }
    return moved;
  }

  static Future<T> _guard<T>(String action, Future<T> Function() body) async {
    try {
      return await body();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('$action: $error');
    }
  }
}
