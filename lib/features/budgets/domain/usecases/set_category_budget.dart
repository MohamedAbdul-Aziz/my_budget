import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../repositories/budget_repository.dart';
import 'set_monthly_budget.dart';

/// Sets or removes the limit on one category's monthly spending.
class SetCategoryBudget {
  const SetCategoryBudget(this._repository);

  final BudgetRepository _repository;

  /// A null [limit] removes the category's budget.
  Future<ApiResult<void>> call(String categoryId, double? limit) async {
    if (categoryId.isEmpty) {
      return const ResultFailure(
        ValidationFailure(FailureCode.categoryRequired),
      );
    }
    if (limit != null) {
      final failure = SetMonthlyBudget.validate(limit);
      if (failure != null) return ResultFailure(failure);
    }
    return _repository.saveCategoryLimit(categoryId, limit);
  }
}
