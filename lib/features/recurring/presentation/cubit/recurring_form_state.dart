import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../domain/entities/recurrence_frequency.dart';
import '../../domain/entities/recurring_expense.dart';
import '../../domain/entities/recurring_mode.dart';

enum RecurringFormStatus { editing, submitting, success, failure }

/// The picks that make up a recurring payment's schedule, and the submission
/// status. The name and amount live in `TextEditingController`s owned by the
/// page's `State`.
class RecurringFormState extends Equatable {
  const RecurringFormState({
    this.existing,
    this.category,
    this.frequency = RecurrenceFrequency.monthly,
    this.dueDay = 1,
    this.dueMonth = 1,
    this.mode = RecurringMode.reminder,
    this.status = RecurringFormStatus.editing,
    this.error,
  });

  /// Set when editing.
  final RecurringExpense? existing;
  final ExpenseCategory? category;
  final RecurrenceFrequency frequency;

  /// A weekday (1-7) for a weekly payment, a day of the month otherwise.
  final int dueDay;

  /// Only used by a yearly payment, but kept while another frequency is
  /// picked so switching back restores it.
  final int dueMonth;
  final RecurringMode mode;
  final RecurringFormStatus status;

  /// Why the last submit failed; the UI turns it into a sentence.
  final FailureCode? error;

  bool get isEditing => existing != null;

  bool get isSubmitting => status == RecurringFormStatus.submitting;

  RecurringFormState copyWith({
    ExpenseCategory? category,
    RecurrenceFrequency? frequency,
    int? dueDay,
    int? dueMonth,
    RecurringMode? mode,
    RecurringFormStatus? status,
    FailureCode? error,
  }) => RecurringFormState(
    existing: existing,
    category: category ?? this.category,
    frequency: frequency ?? this.frequency,
    dueDay: dueDay ?? this.dueDay,
    dueMonth: dueMonth ?? this.dueMonth,
    mode: mode ?? this.mode,
    // Any change goes back to editing, and a stale error never sticks.
    status: status ?? RecurringFormStatus.editing,
    error: error,
  );

  @override
  List<Object?> get props => [
    existing,
    category,
    frequency,
    dueDay,
    dueMonth,
    mode,
    status,
    error,
  ];
}
