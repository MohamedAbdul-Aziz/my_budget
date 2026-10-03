import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/expense_category.dart';
import 'budget_line.dart';

/// The points at which logging an expense warns the user.
enum BudgetThreshold {
  /// 80% of the limit.
  nearing(0.8),

  /// The whole limit.
  reached(1.0);

  const BudgetThreshold(this.share);

  final double share;
}

/// An expense just pushed spending past [threshold] of a limit.
class BudgetAlert extends Equatable {
  const BudgetAlert({
    required this.threshold,
    required this.line,
    this.category,
  });

  final BudgetThreshold threshold;

  /// The spending as it stands after the expense.
  final BudgetLine line;

  /// The category whose limit was crossed; null for the monthly budget.
  final ExpenseCategory? category;

  @override
  List<Object?> get props => [threshold, line, category];
}
