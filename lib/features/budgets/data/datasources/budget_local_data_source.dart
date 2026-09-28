import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/budget_limits.dart';

abstract interface class BudgetLocalDataSource {
  Future<BudgetLimits> readLimits();

  /// A null [limit] removes the monthly budget.
  Future<void> writeMonthly(double? limit);

  /// A null [limit] removes [categoryId]'s budget.
  Future<void> writeCategory(String categoryId, double? limit);
}

/// Budgets are rows in the `settings` table under their own `budget.` keys.
///
/// That table already travels with the cloud backup and the backup file, the
/// newest change winning, so budgets need no table, column or server change
/// of their own, and an older version of the app simply ignores the rows.
///
/// A removed budget is stored as an empty value rather than deleted. Settings
/// rows carry no deleted marker, so only a newer row can take the removal to
/// the cloud and to the user's other phones.
class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  const BudgetLocalDataSourceImpl(this._appDatabase);

  static const String _monthlyKey = 'budget.monthly';
  static const String _categoryPrefix = 'budget.category.';

  final AppDatabase _appDatabase;

  @override
  Future<BudgetLimits> readLimits() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.query(
        'settings',
        columns: ['key', 'value'],
        where: 'key = ? OR key LIKE ?',
        whereArgs: [_monthlyKey, '$_categoryPrefix%'],
      );

      double? monthly;
      final byCategory = <String, double>{};
      for (final row in rows) {
        final key = row['key']! as String;
        final limit = _decode(row['value']! as String);
        if (limit == null) continue;
        if (key == _monthlyKey) {
          monthly = limit;
        } else if (key.length > _categoryPrefix.length) {
          byCategory[key.substring(_categoryPrefix.length)] = limit;
        }
      }
      return BudgetLimits(monthly: monthly, byCategory: byCategory);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load budgets: $error');
    }
  }

  @override
  Future<void> writeMonthly(double? limit) => _write(_monthlyKey, limit);

  @override
  Future<void> writeCategory(String categoryId, double? limit) =>
      _write('$_categoryPrefix$categoryId', limit);

  Future<void> _write(String key, double? limit) async {
    try {
      final db = await _appDatabase.database;
      await db.insert(
        'settings',
        AppDatabase.changed({
          'key': key,
          'value': limit == null ? '' : '$limit',
        }),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on DatabaseException catch (error) {
      throw DatabaseFailure('save budget: $error');
    }
  }

  /// An empty value is a removed budget. Anything unreadable, which only a
  /// damaged copy could hold, counts as no budget rather than an error.
  static double? _decode(String value) {
    final limit = double.tryParse(value);
    return limit != null && limit.isFinite && limit > 0 ? limit : null;
  }
}
