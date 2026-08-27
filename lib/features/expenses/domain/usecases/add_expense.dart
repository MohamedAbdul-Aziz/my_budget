import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Validates then stores a new expense.
class AddExpense {
  const AddExpense(this._repository);

  final ExpenseRepository _repository;

  Future<ApiResult<Expense>> call({
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) async {
    final failure = validate(amount: amount, categoryId: categoryId);
    if (failure != null) return ResultFailure(failure);

    return _repository.addExpense(
      amount: amount,
      categoryId: categoryId,
      date: date,
      description: _normalize(description),
    );
  }

  /// Shared with [UpdateExpense] so both paths enforce the same rules.
  static Failure? validate({
    required double amount,
    required String categoryId,
  }) {
    if (amount <= 0) {
      return const ValidationFailure(FailureCode.amountRequired);
    }
    if (amount > 1000000000) {
      return const ValidationFailure(FailureCode.amountTooLarge);
    }
    if (categoryId.isEmpty) {
      return const ValidationFailure(FailureCode.categoryRequired);
    }
    return null;
  }

  static String? _normalize(String? description) {
    final trimmed = description?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
