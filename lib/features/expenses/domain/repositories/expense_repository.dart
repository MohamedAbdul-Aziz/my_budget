import '../../../../core/error/api_result.dart';
import '../entities/expense.dart';
import '../entities/month.dart';
import '../entities/monthly_summary.dart';

abstract interface class ExpenseRepository {
  /// All expenses recorded in [month], newest first.
  Future<ApiResult<List<Expense>>> getExpensesForMonth(Month month);

  /// One row per month that has at least one expense, newest month first.
  Future<ApiResult<List<MonthlySummary>>> getMonthlySummaries();

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
