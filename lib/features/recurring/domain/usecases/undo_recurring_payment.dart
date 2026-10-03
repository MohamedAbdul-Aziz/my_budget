import '../../../../core/error/api_result.dart';
import '../entities/recurring_payment.dart';
import '../repositories/recurring_repository.dart';

/// Takes back a payment marked by mistake: its transaction goes, and the
/// payment is due again.
class UndoRecurringPayment {
  const UndoRecurringPayment(this._repository);

  final RecurringRepository _repository;

  Future<ApiResult<void>> call(RecurringPayment payment) =>
      _repository.undoPayment(payment);
}
