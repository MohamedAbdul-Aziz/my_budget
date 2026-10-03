import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../expenses/domain/usecases/add_expense.dart';
import '../repositories/budget_repository.dart';

/// Sets or removes the limit on a whole month's spending.
class SetMonthlyBudget {
  const SetMonthlyBudget(this._repository);

  final BudgetRepository _repository;

  /// A null [limit] removes the budget.
  Future<ApiResult<void>> call(double? limit) async {
    if (limit != null) {
      final failure = validate(limit);
      if (failure != null) return ResultFailure(failure);
    }
    return _repository.saveMonthlyLimit(limit);
  }

  /// Shared with [SetCategoryBudget]: a limit follows the same rules as an
  /// expense amount.
  static Failure? validate(double limit) {
    if (limit.isNaN || limit <= 0) {
      return const ValidationFailure(FailureCode.amountRequired);
    }
    if (limit > AddExpense.maxAmount) {
      return const ValidationFailure(FailureCode.amountTooLarge);
    }
    return null;
  }
}
