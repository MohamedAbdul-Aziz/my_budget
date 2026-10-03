import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/amount_input.dart';
import '../../domain/entities/category_usage.dart';
import '../../domain/entities/month.dart';
import '../../domain/entities/monthly_summary.dart';
import '../../domain/entities/transaction_search.dart';
import '../models/expense_model.dart';

abstract interface class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getTransactionsForMonth(Month month);

  Future<List<MonthlySummary>> getMonthlySummaries();

  Future<List<ExpenseModel>> search(TransactionSearch search, {int limit});

  Future<List<CategoryUsage>> getCategoryUsage();

  Future<ExpenseModel> getExpenseById(String id);

  Future<void> insertExpense(Map<String, Object?> row);

  Future<void> updateExpense(String id, Map<String, Object?> row);

  Future<void> deleteExpense(String id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  const ExpenseLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<ExpenseModel>> getTransactionsForMonth(Month month) async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.rawQuery(
        '${ExpenseModel.selectJoin} '
        'WHERE e.month_key = ? AND e.deleted_at IS NULL '
        'ORDER BY e.date DESC, e.created_at DESC',
        [month.key],
      );
      return rows.map(ExpenseModel.fromJoinedMap).toList();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load month: $error');
    }
  }

  /// The filters are SQL; the text is matched in Dart, because SQLite only
  /// ignores the case of English letters and notes are written in any
  /// language.
  @override
  Future<List<ExpenseModel>> search(
    TransactionSearch search, {
    int limit = 200,
  }) async {
    final where = ['e.deleted_at IS NULL'];
    final args = <Object?>[];
    if (search.type case final type?) {
      where.add('c.type = ?');
      args.add(type.storageKey);
    }
    if (search.categoryIds.isNotEmpty) {
      where.add(
        'e.category_id IN (${List.filled(search.categoryIds.length, '?').join(', ')})',
      );
      args.addAll(search.categoryIds);
    }
    if (search.from case final from?) {
      where.add('e.date >= ?');
      args.add(
        DateTime(from.year, from.month, from.day).millisecondsSinceEpoch,
      );
    }
    if (search.to case final to?) {
      where.add('e.date < ?');
      args.add(DateTime(to.year, to.month, to.day + 1).millisecondsSinceEpoch);
    }

    try {
      final db = await _appDatabase.database;
      final rows = await db.rawQuery(
        '${ExpenseModel.selectJoin} '
        'WHERE ${where.join(' AND ')} '
        'ORDER BY e.date DESC, e.created_at DESC',
        args,
      );
      final text = search.text.trim().toLowerCase();
      final amount = AmountInput.parse(text);
      return rows
          .map(ExpenseModel.fromJoinedMap)
          .where(
            (expense) =>
                text.isEmpty ||
                (expense.description?.toLowerCase().contains(text) ?? false) ||
                (amount != null && (expense.amount - amount).abs() < 0.005),
          )
          .take(limit)
          .toList();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('search: $error');
    }
  }

  @override
  Future<List<MonthlySummary>> getMonthlySummaries() async {
    try {
      final db = await _appDatabase.database;
      // Spending only, but a month that so far has only income is still
      // listed, with nothing spent.
      final rows = await db.rawQuery('''
        SELECT
          e.month_key AS month_key,
          SUM(CASE WHEN c.type = 'income' THEN 0 ELSE e.amount END) AS total,
          SUM(CASE WHEN c.type = 'income' THEN 0 ELSE 1 END) AS entries
        FROM expenses e
        INNER JOIN categories c ON c.id = e.category_id
        WHERE e.deleted_at IS NULL
        GROUP BY e.month_key
        ORDER BY e.month_key DESC
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
  Future<List<CategoryUsage>> getCategoryUsage() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.rawQuery('''
        SELECT category_id, COUNT(*) AS uses
        FROM expenses
        WHERE deleted_at IS NULL
        GROUP BY category_id
        ORDER BY uses DESC, category_id ASC
      ''');
      return rows
          .map(
            (row) => CategoryUsage(
              categoryId: row['category_id']! as String,
              count: (row['uses'] as num?)?.toInt() ?? 0,
            ),
          )
          .toList();
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load category usage: $error');
    }
  }

  @override
  Future<ExpenseModel> getExpenseById(String id) async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.rawQuery(
        '${ExpenseModel.selectJoin} '
        'WHERE e.id = ? AND e.deleted_at IS NULL LIMIT 1',
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
      await db.insert('expenses', AppDatabase.changed(row));
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
        AppDatabase.changed(row),
        where: 'id = ? AND deleted_at IS NULL',
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
      // Kept as a marked row rather than deleted, so the delete can sync.
      final now = AppDatabase.nowMillis();
      await db.update(
        'expenses',
        {'deleted_at': now, 'updated_at': now, 'dirty': 1},
        where: 'id = ? AND deleted_at IS NULL',
        whereArgs: [id],
      );
    } on DatabaseException catch (error) {
      throw DatabaseFailure('delete expense: $error');
    }
  }
}
