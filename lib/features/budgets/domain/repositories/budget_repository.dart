import '../../../../core/error/api_result.dart';
import '../entities/budget_limits.dart';

abstract interface class BudgetRepository {
  Future<ApiResult<BudgetLimits>> getLimits();

  /// Sets the monthly budget, or removes it when [limit] is null.
  Future<ApiResult<void>> saveMonthlyLimit(double? limit);

  /// Sets [categoryId]'s budget, or removes it when [limit] is null.
  Future<ApiResult<void>> saveCategoryLimit(String categoryId, double? limit);
}
