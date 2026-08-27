import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/expense_category.dart';

/// How much of a month's spending went to one category.
class CategoryBreakdown extends Equatable {
  const CategoryBreakdown({
    required this.category,
    required this.total,
    required this.share,
  });

  final ExpenseCategory category;
  final double total;

  /// 0.0-1.0 fraction of the month's total.
  final double share;

  @override
  List<Object?> get props => [category, total, share];
}
