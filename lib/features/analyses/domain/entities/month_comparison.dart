import 'package:equatable/equatable.dart';

import '../../../categories/domain/entities/expense_category.dart';
import '../../../expenses/domain/entities/month.dart';

/// One category's spending in both compared months.
class ComparisonRow extends Equatable {
  const ComparisonRow({
    required this.category,
    required this.first,
    required this.second,
  });

  final ExpenseCategory category;

  /// Spent in [MonthComparison.first].
  final double first;

  /// Spent in [MonthComparison.second].
  final double second;

  /// Positive when [first] cost more.
  double get difference => first - second;

  @override
  List<Object?> get props => [category, first, second];
}

/// Spending in two months side by side, by category.
class MonthComparison extends Equatable {
  const MonthComparison({
    required this.first,
    required this.second,
    required this.firstTotal,
    required this.secondTotal,
    required this.rows,
  });

  /// The month being looked at.
  final Month first;

  /// The month it is compared with.
  final Month second;

  final double firstTotal;
  final double secondTotal;

  /// Every category spent on in either month, the larger amount first.
  final List<ComparisonRow> rows;

  bool get isEmpty => firstTotal == 0 && secondTotal == 0;

  double get difference => firstTotal - secondTotal;

  /// As a fraction of [secondTotal]; null when [second] had no spending.
  double? get change => secondTotal == 0 ? null : difference / secondTotal;

  /// The category that cost the most more in [first]; null when none did.
  ComparisonRow? get biggestRise => _extreme((row) => row.difference);

  /// The category that cost the most less in [first]; null when none did.
  ComparisonRow? get biggestDrop => _extreme((row) => -row.difference);

  ComparisonRow? _extreme(double Function(ComparisonRow row) score) {
    ComparisonRow? best;
    for (final row in rows) {
      if (score(row) > 0 && (best == null || score(row) > score(best))) {
        best = row;
      }
    }
    return best;
  }

  @override
  List<Object?> get props => [first, second, firstTotal, secondTotal, rows];
}
