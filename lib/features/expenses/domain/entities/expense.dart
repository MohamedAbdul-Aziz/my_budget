import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/domain/entities/transaction_type.dart';
import 'month.dart';

/// A single recorded transaction — money spent or money received — joined
/// with the category it belongs to.
///
/// Kept under its original name: nearly all of them are expenses, and the
/// category decides which [type] each one is.
class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    required this.createdAt,
  });

  final String id;
  final double amount;

  /// Optional free text — the add form never requires it.
  final String? description;
  final ExpenseCategory category;
  final DateTime date;
  final DateTime createdAt;

  Month get month => Month.fromDate(date);

  TransactionType get type => category.type;

  bool get isIncome => category.isIncome;

  /// What this adds to the month's spending: the amount for an expense,
  /// nothing for income.
  double get spending => isIncome ? 0 : amount;

  Expense copyWith({
    double? amount,
    String? description,
    ExpenseCategory? category,
    DateTime? date,
  }) => Expense(
    id: id,
    amount: amount ?? this.amount,
    description: description ?? this.description,
    category: category ?? this.category,
    date: date ?? this.date,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [
    id,
    amount,
    description,
    category,
    date,
    createdAt,
  ];
}
