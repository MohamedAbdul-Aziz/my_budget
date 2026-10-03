import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../entities/recurring_expense.dart';
import '../repositories/recurring_repository.dart';

/// Auto-deduct: logs every automatic payment that has fallen due by [today],
/// each as a transaction on its own due date, catching up on any the app
/// missed while it was closed.
///
/// Safe to run any number of times: a payment is logged once however often
/// this runs, and on however many phones.
class LogDueRecurring {
  const LogDueRecurring(this._repository);

  final RecurringRepository _repository;

  /// Returns how many transactions it logged.
  Future<ApiResult<int>> call({required DateTime today}) async {
    final List<RecurringExpense> recurring;
    switch (await _repository.getRecurring()) {
      case Success(:final data):
        recurring = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }

    var logged = 0;
    for (final item in recurring) {
      if (!item.isAutomatic) continue;
      for (final due in item.unsettledThrough(today)) {
        final result = await _repository.recordPayment(
          item,
          due: due,
          paidAt: due,
        );
        final failure = result.failureOrNull;
        if (failure == null) {
          logged++;
        } else if (failure.code != FailureCode.alreadyPaid) {
          return ResultFailure(failure);
        }
        // Already paid: another run logged this one first.
      }
    }
    return Success(logged);
  }
}
