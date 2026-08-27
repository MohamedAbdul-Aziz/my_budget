import 'package:equatable/equatable.dart';

import 'category_breakdown.dart';
import 'expense.dart';
import 'month.dart';

/// Everything the home screen shows for one month, assembled by the domain
/// layer so the cubit only has to hold it.
class MonthOverview extends Equatable {
  const MonthOverview({
    required this.month,
    required this.expenses,
    required this.total,
    required this.breakdown,
  });

  const MonthOverview.empty(this.month)
    : expenses = const [],
      total = 0,
      breakdown = const [];

  final Month month;

  /// Newest first.
  final List<Expense> expenses;
  final double total;

  /// Largest share first.
  final List<CategoryBreakdown> breakdown;

  bool get isEmpty => expenses.isEmpty;

  @override
  List<Object?> get props => [month, expenses, total, breakdown];
}
