import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/expense_category.dart';
import 'month.dart';

/// A single recorded expense, joined with the category it belongs to.
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
