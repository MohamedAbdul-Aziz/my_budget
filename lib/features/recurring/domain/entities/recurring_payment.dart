import 'package:equatable/equatable.dart';

/// One recurring payment, logged as a transaction. Keeps what it replaced,
/// so it can be taken back.
class RecurringPayment extends Equatable {
  const RecurringPayment({
    required this.recurringId,
    required this.expenseId,
    required this.due,
    this.previousPaidThrough,
  });

  final String recurringId;

  /// The transaction it logged.
  final String expenseId;

  /// The due date it settled.
  final DateTime due;

  /// What was settled before it.
  final DateTime? previousPaidThrough;

  @override
  List<Object?> get props => [recurringId, expenseId, due, previousPaidThrough];
}
