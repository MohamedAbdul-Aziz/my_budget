import '../../../../core/error/api_result.dart';
import '../entities/category_usage.dart';
import '../entities/expense.dart';
import '../entities/month.dart';
import '../entities/monthly_summary.dart';

abstract interface class ExpenseRepository {
  /// Everything recorded in [month], spending and income, newest first.
  Future<ApiResult<List<Expense>>> getTransactionsForMonth(Month month);

  /// One row per month that has anything recorded, newest month first. The
  /// totals are spending only.
  Future<ApiResult<List<MonthlySummary>>> getMonthlySummaries();

  /// Categories that have been used at least once, most used first.
  Future<ApiResult<List<CategoryUsage>>> getCategoryUsage();

  Future<ApiResult<Expense>> addExpense({
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  });

  Future<ApiResult<Expense>> updateExpense({
    required String id,
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  });

  Future<ApiResult<void>> deleteExpense(String id);
}
