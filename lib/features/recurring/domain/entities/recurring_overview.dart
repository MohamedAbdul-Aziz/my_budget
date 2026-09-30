import 'package:equatable/equatable.dart';

import 'recurring_expense.dart';

/// Where a recurring payment stands this month.
enum RecurringStatus {
  /// This period's payment is settled.
  paid,

  /// Nothing is late. The next payment may be later this month, today, or
  /// in a month still to come.
  upcoming,

  /// A payment is past its due date and not settled.
  overdue,
}

/// A recurring payment together with where it stands on a given day.
class RecurringCommitment extends Equatable {
  const RecurringCommitment({
    required this.recurring,
    required this.status,
    required this.nextDue,
    required this.isDueToday,
    required this.overdueCount,
    required this.isPayableNow,
  });

  final RecurringExpense recurring;
  final RecurringStatus status;

  /// The oldest payment not yet settled.
  final DateTime nextDue;

  final bool isDueToday;

  /// Payments past their due date; 0 unless [status] is overdue.
  final int overdueCount;

  /// Whether [nextDue] is this month or earlier. Paying it now belongs to
  /// this month; paying one due months ahead would not.
  final bool isPayableNow;

  /// A reminder the user has to answer now.
  bool get needsConfirmation =>
      !recurring.isAutomatic &&
      (status == RecurringStatus.overdue || isDueToday);

  @override
  List<Object?> get props => [
    recurring,
    status,
    nextDue,
    isDueToday,
    overdueCount,
    isPayableNow,
  ];
}

/// Every recurring payment as it stands today, the ones needing attention
/// first.
class RecurringOverview extends Equatable {
  const RecurringOverview({
    required this.commitments,
    required this.monthlyTotal,
  });

  const RecurringOverview.empty() : commitments = const [], monthlyTotal = 0;

  final List<RecurringCommitment> commitments;

  /// What they all cost in an average month.
  final double monthlyTotal;

  bool get isEmpty => commitments.isEmpty;

  int count(RecurringStatus status) =>
      commitments.where((item) => item.status == status).length;

  /// Reminders due today or overdue, which the home screen asks about.
  List<RecurringCommitment> get awaitingConfirmation => [
    for (final item in commitments)
      if (item.needsConfirmation) item,
  ];

  @override
  List<Object?> get props => [commitments, monthlyTotal];
}
