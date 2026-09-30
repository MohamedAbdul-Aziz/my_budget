import '../../../../core/error/api_result.dart';
import '../entities/recurring_expense.dart';
import '../entities/recurring_payment.dart';
import '../repositories/recurring_repository.dart';

/// The user paid: logs the oldest unsettled payment as a transaction dated
/// [now], so it lands in the current month whenever it was due.
class MarkRecurringPaid {
  const MarkRecurringPaid(this._repository);

  final RecurringRepository _repository;

  Future<ApiResult<RecurringPayment>> call(
    RecurringExpense recurring, {
    required DateTime now,
  }) =>
      _repository.recordPayment(recurring, due: recurring.nextDue, paidAt: now);
}
