import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/recurring_payment.dart';
import '../models/recurring_expense_model.dart';

abstract interface class RecurringLocalDataSource {
  Future<List<RecurringExpenseModel>> getRecurring();

  Future<RecurringExpenseModel> getRecurringById(String id);

  Future<void> insertRecurring(Map<String, Object?> row);

  Future<void> updateRecurring(String id, Map<String, Object?> row);

  Future<void> deleteRecurring(String id);

  /// Writes [expenseRow] and settles [recurringId] up to [due] in one
  /// transaction. Returns what was settled before.
  Future<DateTime?> recordPayment({
    required String recurringId,
    required DateTime due,
    required Map<String, Object?> expenseRow,
  });

  Future<void> undoPayment(RecurringPayment payment);
}

class RecurringLocalDataSourceImpl implements RecurringLocalDataSource {
  const RecurringLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<RecurringExpenseModel>> getRecurring() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.rawQuery(
        '${RecurringExpenseModel.selectJoin} '
        'WHERE r.deleted_at IS NULL '
        'ORDER BY r.created_at, r.id',
      );
      return rows.map(RecurringExpenseModel.fromJoinedMap).toList();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load recurring: $error');
    }
  }

  @override
  Future<RecurringExpenseModel> getRecurringById(String id) async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.rawQuery(
        '${RecurringExpenseModel.selectJoin} '
        'WHERE r.id = ? AND r.deleted_at IS NULL LIMIT 1',
        [id],
      );
      if (rows.isEmpty) {
        throw const NotFoundFailure('recurring payment missing');
      }
      return RecurringExpenseModel.fromJoinedMap(rows.first);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load recurring payment: $error');
    }
  }

  @override
  Future<void> insertRecurring(Map<String, Object?> row) async {
    try {
      final db = await _appDatabase.database;
      await db.insert('recurring_expenses', AppDatabase.changed(row));
    } on DatabaseException catch (error) {
      throw DatabaseFailure('insert recurring payment: $error');
    }
  }

  @override
  Future<void> updateRecurring(String id, Map<String, Object?> row) async {
    try {
      final db = await _appDatabase.database;
      final count = await db.update(
        'recurring_expenses',
        AppDatabase.changed(row),
        where: 'id = ? AND deleted_at IS NULL',
        whereArgs: [id],
      );
      if (count == 0) {
        throw const NotFoundFailure('recurring payment missing');
      }
    } on DatabaseException catch (error) {
      throw DatabaseFailure('update recurring payment: $error');
    }
  }

  @override
  Future<void> deleteRecurring(String id) async {
    try {
      final db = await _appDatabase.database;
      // Kept as a marked row rather than deleted, so the delete can sync.
      final now = AppDatabase.nowMillis();
      await db.update(
        'recurring_expenses',
        {'deleted_at': now, 'updated_at': now, 'dirty': 1},
        where: 'id = ? AND deleted_at IS NULL',
        whereArgs: [id],
      );
    } on DatabaseException catch (error) {
      throw DatabaseFailure('delete recurring payment: $error');
    }
  }

  @override
  Future<DateTime?> recordPayment({
    required String recurringId,
    required DateTime due,
    required Map<String, Object?> expenseRow,
  }) async {
    try {
      final db = await _appDatabase.database;
      return await db.transaction((txn) async {
        final rows = await txn.query(
          'recurring_expenses',
          columns: ['paid_through'],
          where: 'id = ? AND deleted_at IS NULL',
          whereArgs: [recurringId],
          limit: 1,
        );
        if (rows.isEmpty) {
          throw const NotFoundFailure('recurring payment missing');
        }
        // Read inside the transaction, so of two callers racing for the
        // same payment only the first logs it.
        final previous = rows.first['paid_through'] as String?;
        final dueKey = RecurringExpenseModel.dayKey(due);
        if (previous != null && previous.compareTo(dueKey) >= 0) {
          throw const ValidationFailure(FailureCode.alreadyPaid);
        }

        // A payment that was logged, undone and is now logged again brings
        // its old transaction back rather than tripping over its id.
        final expense = AppDatabase.changed({
          ...expenseRow,
          'deleted_at': null,
        });
        final revived = await txn.update(
          'expenses',
          expense,
          where: 'id = ?',
          whereArgs: [expense['id']],
        );
        if (revived == 0) await txn.insert('expenses', expense);

        await txn.update(
          'recurring_expenses',
          AppDatabase.changed({'paid_through': dueKey}),
          where: 'id = ?',
          whereArgs: [recurringId],
        );
        return previous == null
            ? null
            : RecurringExpenseModel.parseDay(previous);
      });
    } on DatabaseException catch (error) {
      throw DatabaseFailure('record recurring payment: $error');
    }
  }

  @override
  Future<void> undoPayment(RecurringPayment payment) async {
    try {
      final db = await _appDatabase.database;
      await db.transaction((txn) async {
        final now = AppDatabase.nowMillis();
        await txn.update(
          'expenses',
          {'deleted_at': now, 'updated_at': now, 'dirty': 1},
          where: 'id = ? AND deleted_at IS NULL',
          whereArgs: [payment.expenseId],
        );
        final previous = payment.previousPaidThrough;
        // Only while nothing newer was paid since; otherwise the later
        // payments stay settled.
        await txn.update(
          'recurring_expenses',
          AppDatabase.changed({
            'paid_through': previous == null
                ? null
                : RecurringExpenseModel.dayKey(previous),
          }),
          where: 'id = ? AND paid_through = ? AND deleted_at IS NULL',
          whereArgs: [
            payment.recurringId,
            RecurringExpenseModel.dayKey(payment.due),
          ],
        );
      });
    } on DatabaseException catch (error) {
      throw DatabaseFailure('undo recurring payment: $error');
    }
  }
}
