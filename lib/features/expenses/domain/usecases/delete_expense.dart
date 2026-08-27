import '../../../../core/error/api_result.dart';
import '../repositories/expense_repository.dart';

class DeleteExpense {
  const DeleteExpense(this._repository);

  final ExpenseRepository _repository;

  Future<ApiResult<void>> call(String id) => _repository.deleteExpense(id);
}
