import 'package:equatable/equatable.dart';

import '../../../expenses/domain/entities/category_breakdown.dart';
import '../../../expenses/domain/entities/expense.dart';
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

/// One category's change between two months, in money.
class CategoryChange extends Equatable {
  const CategoryChange({required this.breakdown, required this.difference});

  /// The category's share of the later month.
  final CategoryBreakdown breakdown;

  /// Positive when the category cost more than before.
  final double difference;

  @override
  List<Object?> get props => [breakdown, difference];
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
    this.income = 0,
    this.incomeBreakdown = const [],
    this.previousBreakdown = const [],
    this.largestExpense,
    this.expenseCount = 0,
    this.byWeekday = const [0, 0, 0, 0, 0, 0, 0],
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

  /// Everything that came in this month.
  final double income;

  /// Where the income came from, largest first.
  final List<CategoryBreakdown> incomeBreakdown;

  /// The month before, split by category, for spotting what rose.
  final List<CategoryBreakdown> previousBreakdown;

  /// The single costliest expense; null when nothing was spent.
  final Expense? largestExpense;

  /// Expenses only; income is not counted.
  final int expenseCount;

  /// Spending per weekday, Monday first (index `DateTime.weekday - 1`).
  final List<double> byWeekday;

  bool get isEmpty => total == 0 && breakdown.isEmpty;

  /// Change from the previous month as a fraction (0.25 = 25% more). Null
  /// when the previous month had no spending to compare with.
  double? get change =>
      previousTotal == 0 ? null : (total - previousTotal) / previousTotal;

  /// The category that cost the most more than last month; null when none
  /// rose.
  CategoryChange? get biggestRise =>
      biggestRiseBetween(breakdown, previousBreakdown);

  double get averageExpense => expenseCount == 0 ? 0 : total / expenseCount;

  /// Index into [byWeekday] of the costliest weekday; null with no spending.
  int? get busiestWeekday {
    int? best;
    for (var i = 0; i < byWeekday.length; i++) {
      if (byWeekday[i] > 0 &&
          (best == null || byWeekday[i] > byWeekday[best])) {
        best = i;
      }
    }
    return best;
  }

  /// What the whole month will cost if the daily average holds. A past month
  /// is already complete, so this is simply its total.
  double projectedTotal(DateTime now) {
    if (month != Month.fromDate(now)) return total;
    final daysInMonth = month.endExclusive
        .subtract(const Duration(days: 1))
        .day;
    return dailyAverage * daysInMonth;
  }

  /// The costliest and cheapest months in [trend] that had any spending.
  (MonthlySummary, MonthlySummary)? get highestAndLowest {
    final spent = trend.where((summary) => summary.total > 0).toList();
    if (spent.isEmpty) return null;
    var highest = spent.first;
    var lowest = spent.first;
    for (final summary in spent) {
      if (summary.total > highest.total) highest = summary;
      if (summary.total < lowest.total) lowest = summary;
    }
    return (highest, lowest);
  }

  /// Shared with the month comparison so both agree on what "rose" means.
  static CategoryChange? biggestRiseBetween(
    List<CategoryBreakdown> later,
    List<CategoryBreakdown> earlier,
  ) {
    final before = {for (final item in earlier) item.category.id: item.total};
    CategoryChange? best;
    for (final item in later) {
      final difference = item.total - (before[item.category.id] ?? 0);
      if (difference > 0 && (best == null || difference > best.difference)) {
        best = CategoryChange(breakdown: item, difference: difference);
      }
    }
    return best;
  }

  @override
  List<Object?> get props => [
    month,
    total,
    breakdown,
    previousTotal,
    dailyAverage,
    topDay,
    trend,
    income,
    incomeBreakdown,
    previousBreakdown,
    largestExpense,
    expenseCount,
    byWeekday,
  ];
}
