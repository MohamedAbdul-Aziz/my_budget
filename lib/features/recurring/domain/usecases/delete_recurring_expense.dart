import '../../../../core/error/api_result.dart';
import '../repositories/recurring_repository.dart';

/// Stops a recurring payment. Transactions it already logged stay.
class DeleteRecurringExpense {
  const DeleteRecurringExpense(this._repository);

  final RecurringRepository _repository;

  Future<ApiResult<void>> call(String id) => _repository.deleteRecurring(id);
}
