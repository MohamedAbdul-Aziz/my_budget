import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/budget_limits.dart';
import '../models/budget_keys.dart';

abstract interface class BudgetLocalDataSource {
  Future<BudgetLimits> readLimits();

  /// A null [limit] removes the monthly budget.
  Future<void> writeMonthly(double? limit);

  /// A null [limit] removes [categoryId]'s budget.
  Future<void> writeCategory(String categoryId, double? limit);
}

/// Budgets are rows in the `settings` table under their own `budget.` keys
/// ([BudgetKeys]).
///
/// That table already travels with the cloud backup and the backup file, the
/// newest change winning, so budgets need no table, column or server change
/// of their own, and an older version of the app simply ignores the rows.
class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  const BudgetLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<BudgetLimits> readLimits() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.query(
        'settings',
        columns: ['key', 'value'],
        where: 'key = ? OR key LIKE ?',
        whereArgs: [BudgetKeys.monthly, '${BudgetKeys.categoryPrefix}%'],
      );

      return BudgetKeys.fromRows(rows);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load budgets: $error');
    }
  }

  @override
  Future<void> writeMonthly(double? limit) => _write(BudgetKeys.monthly, limit);

  @override
  Future<void> writeCategory(String categoryId, double? limit) =>
      _write(BudgetKeys.category(categoryId), limit);

  Future<void> _write(String key, double? limit) async {
    try {
      final db = await _appDatabase.database;
      await db.insert(
        'settings',
        AppDatabase.changed({'key': key, 'value': BudgetKeys.encode(limit)}),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on DatabaseException catch (error) {
      throw DatabaseFailure('save budget: $error');
    }
  }
}
