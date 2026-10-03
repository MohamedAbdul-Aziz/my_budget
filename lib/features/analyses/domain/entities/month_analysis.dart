import 'package:equatable/equatable.dart';

import '../../../expenses/domain/entities/category_breakdown.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../expenses/domain/entities/monthly_summary.dart';

/// The most a single day cost in a month.
class TopDay extends Equatable {
  const TopDay({required this.date, required this.total});

  final DateTime date;
  final double total;

  @override
  List<Object?> get props => [date, total];
}

/// Everything the analyses page shows for one month.
class MonthAnalysis extends Equatable {
  const MonthAnalysis({
    required this.month,
    required this.total,
    required this.breakdown,
    required this.previousTotal,
    required this.dailyAverage,
    required this.trend,
    this.topDay,
  });

  final Month month;
  final double total;

  /// Largest share first.
  final List<CategoryBreakdown> breakdown;

  /// What the month before cost.
  final double previousTotal;

  final double dailyAverage;

  /// Null when nothing was spent this month.
  final TopDay? topDay;

  /// The months up to and including [month], oldest first. Months without
  /// spending are included with a total of 0 so the bars line up.
  final List<MonthlySummary> trend;

  bool get isEmpty => total == 0 && breakdown.isEmpty;

  /// Change from the previous month as a fraction (0.25 = 25% more). Null
  /// when the previous month had no spending to compare with.
  double? get change =>
      previousTotal == 0 ? null : (total - previousTotal) / previousTotal;

  @override
  List<Object?> get props => [
    month,
    total,
    breakdown,
    previousTotal,
    dailyAverage,
    topDay,
    trend,
  ];
}
