import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/expense_category.dart';
import '../../../expenses/domain/entities/month.dart';
import 'budget_line.dart';

/// One category's spending in a month, and its limit if it has one.
class CategoryBudget extends Equatable {
  const CategoryBudget({
    required this.category,
    required this.spent,
    this.limit,
  });

  final ExpenseCategory category;
  final double spent;
  final double? limit;

  /// Null when the category has no limit.
  BudgetLine? get line {
    final limit = this.limit;
    return limit == null ? null : BudgetLine(spent: spent, limit: limit);
  }

  @override
  List<Object?> get props => [category, spent, limit];
}

/// A month's spending set against the user's limits, assembled by the domain
/// layer so the widgets only have to draw it.
class BudgetStatus extends Equatable {
  const BudgetStatus({
    required this.month,
    required this.spent,
    this.monthlyLimit,
    this.categories = const [],
    this.watchList = const [],
  });

  final Month month;

  /// Everything spent in [month].
  final double spent;

  final double? monthlyLimit;

  /// Every category, in the user's order, whether it has a limit or not.
  final List<CategoryBudget> categories;

  /// The categories whose spending has reached the warning level or passed
  /// it, the one furthest through its limit first.
  final List<CategoryBudget> watchList;

  /// The month as a whole; null when no monthly budget is set.
  BudgetLine? get total {
    final limit = monthlyLimit;
    return limit == null ? null : BudgetLine(spent: spent, limit: limit);
  }

  @override
  List<Object?> get props => [
    month,
    spent,
    monthlyLimit,
    categories,
    watchList,
  ];
}
