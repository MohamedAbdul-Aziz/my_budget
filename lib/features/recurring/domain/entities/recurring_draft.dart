import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/expense_category.dart';
import 'recurrence_frequency.dart';
import 'recurring_mode.dart';

/// What the user typed and picked for a recurring payment, before it is
/// checked and stored.
class RecurringDraft extends Equatable {
  const RecurringDraft({
    required this.title,
    required this.amount,
    required this.category,
    required this.frequency,
    required this.dueDay,
    this.dueMonth,
    required this.mode,
  });

  final String title;
  final double amount;
  final ExpenseCategory? category;
  final RecurrenceFrequency frequency;
  final int dueDay;

  /// Used only when [frequency] is yearly.
  final int? dueMonth;
  final RecurringMode mode;

  @override
  List<Object?> get props => [
    title,
    amount,
    category,
    frequency,
    dueDay,
    dueMonth,
    mode,
  ];
}
