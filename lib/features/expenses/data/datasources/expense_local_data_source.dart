import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/month.dart';
import '../../domain/entities/monthly_summary.dart';
import '../models/expense_model.dart';

abstract interface class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpensesForMonth(Month month);

  Future<List<MonthlySummary>> getMonthlySummaries();

  Future<ExpenseModel> getExpenseById(String id);

  Future<void> insertExpense(Map<String, Object?> row);

  Future<void> updateExpense(String id, Map<String, Object?> row);

  Future<void> deleteExpense(String id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  const ExpenseLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<ExpenseModel>> getExpensesForMonth(Month month) async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.rawQuery(
        '${ExpenseModel.selectJoin} WHERE e.month_key = ? '
        'ORDER BY e.date DESC, e.created_at DESC',
        [month.key],
      );
      return rows.map(ExpenseModel.fromJoinedMap).toList();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load month: $error');
    }
  }

  @override
  Future<List<MonthlySummary>> getMonthlySummaries() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.rawQuery('''
        SELECT month_key, SUM(amount) AS total, COUNT(*) AS entries
        FROM expenses
        GROUP BY month_key
        ORDER BY month_key DESC
      ''');
      return rows
          .map(
            (row) => MonthlySummary(
              month: Month.fromKey(row['month_key']! as String),
              total: (row['total'] as num?)?.toDouble() ?? 0,
              expenseCount: (row['entries'] as num?)?.toInt() ?? 0,
            ),
          )
          .toList();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load summaries: $error');
    }
  }

  @override
  Future<ExpenseModel> getExpenseById(String id) async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.rawQuery(
        '${ExpenseModel.selectJoin} WHERE e.id = ? LIMIT 1',
        [id],
      );
      if (rows.isEmpty) {
        throw const NotFoundFailure('expense missing');
      }
      return ExpenseModel.fromJoinedMap(rows.first);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load expense: $error');
    }
  }

  @override
  Future<void> insertExpense(Map<String, Object?> row) async {
    try {
      final db = await _appDatabase.database;
      await db.insert('expenses', row);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('insert expense: $error');
    }
  }

  @override
  Future<void> updateExpense(String id, Map<String, Object?> row) async {
    try {
      final db = await _appDatabase.database;
      final count = await db.update(
        'expenses',
        row,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (count == 0) {
        throw const NotFoundFailure('expense missing');
      }
    } on DatabaseException catch (error) {
      throw DatabaseFailure('update expense: $error');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      final db = await _appDatabase.database;
      await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('delete expense: $error');
    }
  }
}
