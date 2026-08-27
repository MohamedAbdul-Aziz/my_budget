import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../categories/domain/entities/expense_category.dart';

enum ExpenseFormStatus { editing, submitting, success, failure }

/// Holds only what the form cannot keep in a widget: the chosen category, the
/// date, and the submission status. The amount and description live in
/// `TextEditingController`s owned by the page's `State`.
class ExpenseFormState extends Equatable {
  const ExpenseFormState({
    required this.date,
    this.expenseId,
    this.category,
    this.status = ExpenseFormStatus.editing,
    this.error,
  });

  factory ExpenseFormState.initial() =>
      ExpenseFormState(date: DateTime.now());

  final String? expenseId;
  final ExpenseCategory? category;
  final DateTime date;
  final ExpenseFormStatus status;

  /// Why the last submit failed; the UI turns it into a sentence.
  final FailureCode? error;

  bool get isEditing => expenseId != null;

  bool get isSubmitting => status == ExpenseFormStatus.submitting;

  bool get canSubmit => category != null && !isSubmitting;

  ExpenseFormState copyWith({
    String? expenseId,
    ExpenseCategory? category,
    DateTime? date,
    ExpenseFormStatus? status,
    FailureCode? error,
  }) => ExpenseFormState(
    expenseId: expenseId ?? this.expenseId,
    category: category ?? this.category,
    date: date ?? this.date,
    status: status ?? this.status,
    // Cleared unless explicitly carried over, so a stale error never sticks.
    error: error,
  );

  @override
  List<Object?> get props => [
    expenseId,
    category,
    date,
    status,
    error,
  ];
}
