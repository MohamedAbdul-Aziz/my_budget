import 'package:flutter/material.dart';

import '../../features/categories/domain/entities/transaction_type.dart';

/// The accents that tell money out from money in: warm for spending, green
/// for income.
///
/// Each accent stays readable as text on the app's surfaces (at least 4.5:1)
/// in its theme, and its `on` color is readable on top of it.
@immutable
class TransactionColors extends ThemeExtension<TransactionColors> {
  const TransactionColors({
    required this.expense,
    required this.onExpense,
    required this.expenseContainer,
    required this.income,
    required this.onIncome,
    required this.incomeContainer,
  });

  static const TransactionColors light = TransactionColors(
    expense: Color(0xFFB33900),
    onExpense: Color(0xFFFFFFFF),
    expenseContainer: Color(0xFFFFE3D6),
    income: Color(0xFF2A7430),
    onIncome: Color(0xFFFFFFFF),
    incomeContainer: Color(0xFFD7F0D8),
  );

  static const TransactionColors dark = TransactionColors(
    expense: Color(0xFFFFAB91),
    onExpense: Color(0xFF5B1A00),
    expenseContainer: Color(0xFF4A2418),
    income: Color(0xFF81C784),
    onIncome: Color(0xFF003909),
    incomeContainer: Color(0xFF1B3A1E),
  );

  final Color expense;
  final Color onExpense;
  final Color expenseContainer;
  final Color income;
  final Color onIncome;
  final Color incomeContainer;

  /// The colors registered on the current theme.
  static TransactionColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<TransactionColors>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  Color accent(TransactionType type) => switch (type) {
    TransactionType.expense => expense,
    TransactionType.income => income,
  };

  Color onAccent(TransactionType type) => switch (type) {
    TransactionType.expense => onExpense,
    TransactionType.income => onIncome,
  };

  Color container(TransactionType type) => switch (type) {
    TransactionType.expense => expenseContainer,
    TransactionType.income => incomeContainer,
  };

  @override
  TransactionColors copyWith({
    Color? expense,
    Color? onExpense,
    Color? expenseContainer,
    Color? income,
    Color? onIncome,
    Color? incomeContainer,
  }) => TransactionColors(
    expense: expense ?? this.expense,
    onExpense: onExpense ?? this.onExpense,
    expenseContainer: expenseContainer ?? this.expenseContainer,
    income: income ?? this.income,
    onIncome: onIncome ?? this.onIncome,
    incomeContainer: incomeContainer ?? this.incomeContainer,
  );

  @override
  TransactionColors lerp(TransactionColors? other, double t) {
    if (other == null) return this;
    return TransactionColors(
      expense: Color.lerp(expense, other.expense, t)!,
      onExpense: Color.lerp(onExpense, other.onExpense, t)!,
      expenseContainer: Color.lerp(
        expenseContainer,
        other.expenseContainer,
        t,
      )!,
      income: Color.lerp(income, other.income, t)!,
      onIncome: Color.lerp(onIncome, other.onIncome, t)!,
      incomeContainer: Color.lerp(incomeContainer, other.incomeContainer, t)!,
    );
  }
}
