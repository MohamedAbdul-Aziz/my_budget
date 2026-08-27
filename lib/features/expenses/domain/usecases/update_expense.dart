import '../../../../core/error/api_result.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';
import 'add_expense.dart';

/// Applies edits to an existing expense using the same validation as creation.
class UpdateExpense {
  const UpdateExpense(this._repository);

  final ExpenseRepository _repository;

  Future<ApiResult<Expense>> call({
    required String id,
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) async {
    final failure = AddExpense.validate(amount: amount, categoryId: categoryId);
    if (failure != null) return ResultFailure(failure);

    final trimmed = description?.trim();
    return _repository.updateExpense(
      id: id,
      amount: amount,
      categoryId: categoryId,
      date: date,
      description: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
    );
  }
}
