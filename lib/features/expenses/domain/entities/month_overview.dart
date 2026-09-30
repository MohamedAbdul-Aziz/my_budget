import 'package:equatable/equatable.dart';

import 'category_breakdown.dart';
import 'expense.dart';
import 'month.dart';

/// Everything the home screen shows for one month, assembled by the domain
/// layer so the cubit only has to hold it.
class MonthOverview extends Equatable {
  const MonthOverview({
    required this.month,
    required this.transactions,
    required this.income,
    required this.spent,
    required this.breakdown,
  });

  const MonthOverview.empty(this.month)
    : transactions = const [],
      income = 0,
      spent = 0,
      breakdown = const [];

  final Month month;

  /// Spending and income together, newest first.
  final List<Expense> transactions;

  /// Everything that came in this month.
  final double income;

  /// Everything that went out this month.
  final double spent;

  /// Where the spending went, largest share first. Income is not in it.
  final List<CategoryBreakdown> breakdown;

  bool get isEmpty => transactions.isEmpty;

  /// Income minus spending. Negative when the month cost more than it
  /// brought in.
  double get net => income - spent;

  /// The share of income kept: `net ÷ income`, so 0.25 means a quarter of
  /// what came in was saved, and a negative rate means more went out than
  /// came in. Null while there is no income, when a rate means nothing.
  double? get savingsRate => income > 0 ? net / income : null;

  @override
  List<Object?> get props => [month, transactions, income, spent, breakdown];
}
