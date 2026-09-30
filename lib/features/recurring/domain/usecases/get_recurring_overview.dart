import '../../../../core/error/api_result.dart';
import '../entities/recurring_expense.dart';
import '../entities/recurring_overview.dart';
import '../repositories/recurring_repository.dart';

/// Every recurring payment and where it stands on a given day.
class GetRecurringOverview {
  const GetRecurringOverview(this._repository);

  final RecurringRepository _repository;

  Future<ApiResult<RecurringOverview>> call({required DateTime today}) async =>
      (await _repository.getRecurring()).map(
        (items) => overviewOf(items, today: today),
      );

  /// The arithmetic on its own, so it can be tested without any storage.
  /// Overdue payments come first, then upcoming ones, then paid ones, each
  /// group by its next due date.
  static RecurringOverview overviewOf(
    List<RecurringExpense> items, {
    required DateTime today,
  }) {
    final commitments = [for (final item in items) statusOf(item, today: today)]
      ..sort((a, b) {
        final byStatus = _rank(a.status).compareTo(_rank(b.status));
        if (byStatus != 0) return byStatus;
        final byDate = a.nextDue.compareTo(b.nextDue);
        if (byDate != 0) return byDate;
        return a.recurring.title.toLowerCase().compareTo(
          b.recurring.title.toLowerCase(),
        );
      });
    return RecurringOverview(
      commitments: commitments,
      monthlyTotal: items.fold(0, (sum, item) => sum + item.monthlyCost),
    );
  }

  /// Overdue when a payment is past its due date and unsettled; paid when
  /// the payment belonging to today's period (its week, or its month) is
  /// settled; upcoming otherwise. A yearly payment is only ever paid in the
  /// month it falls due.
  static RecurringCommitment statusOf(
    RecurringExpense recurring, {
    required DateTime today,
  }) {
    final day = RecurringExpense.dayOf(today);
    final nextDue = recurring.nextDue;
    final overdue = recurring.unsettledThrough(
      day.subtract(const Duration(days: 1)),
    );
    final current = recurring.dueInPeriodOf(day);

    final RecurringStatus status;
    if (overdue.isNotEmpty) {
      status = RecurringStatus.overdue;
    } else if (current != null && recurring.isSettled(current)) {
      status = RecurringStatus.paid;
    } else {
      status = RecurringStatus.upcoming;
    }

    return RecurringCommitment(
      recurring: recurring,
      status: status,
      nextDue: nextDue,
      isDueToday: nextDue == day,
      overdueCount: overdue.length,
      isPayableNow:
          status != RecurringStatus.paid &&
          nextDue.isBefore(DateTime(day.year, day.month + 1)),
    );
  }

  static int _rank(RecurringStatus status) => switch (status) {
    RecurringStatus.overdue => 0,
    RecurringStatus.upcoming => 1,
    RecurringStatus.paid => 2,
  };
}
