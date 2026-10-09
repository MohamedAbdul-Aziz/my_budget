import 'package:equatable/equatable.dart';

/// One category's figure in a summary: its name as the user sees it, never
/// its id.
class SummaryCategory extends Equatable {
  const SummaryCategory({
    required this.name,
    required this.total,
    required this.share,
  });

  final String name;
  final double total;

  /// 0.0-1.0 of the month's spending (or income).
  final double share;

  Map<String, Object?> toJson() => {
    'name': name,
    'total': roundMoney(total),
    'share': roundMoney(share),
  };

  @override
  List<Object?> get props => [name, total, share];
}

/// The figures of one month, all aggregated: no single transaction is in it.
class SummaryMonth extends Equatable {
  const SummaryMonth({
    required this.period,
    required this.isCurrent,
    required this.daysCounted,
    required this.spent,
    required this.income,
    required this.expenseCount,
    required this.dailyAverage,
    required this.previousMonthSpent,
    required this.spendingByCategory,
    required this.incomeByCategory,
    this.changeVsPrevious,
    this.projectedMonthEnd,
    this.topDayDate,
    this.topDayTotal,
  });

  /// `yyyy-MM`.
  final String period;
  final bool isCurrent;

  /// The days the daily average is spread over: the days so far for the
  /// current month.
  final int daysCounted;
  final double spent;
  final double income;
  final int expenseCount;
  final double dailyAverage;
  final double previousMonthSpent;

  /// A fraction (0.25 = 25% more); null when the month before had no
  /// spending to compare with.
  final double? changeVsPrevious;

  /// Only for the current month.
  final double? projectedMonthEnd;

  /// `yyyy-MM-dd`; null when nothing was spent.
  final String? topDayDate;
  final double? topDayTotal;

  /// Largest first.
  final List<SummaryCategory> spendingByCategory;
  final List<SummaryCategory> incomeByCategory;

  SummaryMonth withCategories({
    required List<SummaryCategory> spending,
    required List<SummaryCategory> income,
  }) => SummaryMonth(
    period: period,
    isCurrent: isCurrent,
    daysCounted: daysCounted,
    spent: spent,
    income: this.income,
    expenseCount: expenseCount,
    dailyAverage: dailyAverage,
    previousMonthSpent: previousMonthSpent,
    changeVsPrevious: changeVsPrevious,
    projectedMonthEnd: projectedMonthEnd,
    topDayDate: topDayDate,
    topDayTotal: topDayTotal,
    spendingByCategory: spending,
    incomeByCategory: income,
  );

  Map<String, Object?> toJson() => {
    'period': period,
    'isCurrent': isCurrent,
    'daysCounted': daysCounted,
    'spent': roundMoney(spent),
    'income': roundMoney(income),
    'net': roundMoney(income - spent),
    'expenseCount': expenseCount,
    'dailyAverage': roundMoney(dailyAverage),
    'previousMonthSpent': roundMoney(previousMonthSpent),
    if (changeVsPrevious case final change?)
      'changeVsPrevious': roundMoney(change),
    if (projectedMonthEnd case final projected?)
      'projectedMonthEnd': roundMoney(projected),
    if (topDayDate case final date?)
      'topDay': {'date': date, 'total': roundMoney(topDayTotal ?? 0)},
    'spendingByCategory': [for (final c in spendingByCategory) c.toJson()],
    'incomeByCategory': [for (final c in incomeByCategory) c.toJson()],
  };

  @override
  List<Object?> get props => [
    period,
    isCurrent,
    daysCounted,
    spent,
    income,
    expenseCount,
    dailyAverage,
    previousMonthSpent,
    changeVsPrevious,
    projectedMonthEnd,
    topDayDate,
    topDayTotal,
    spendingByCategory,
    incomeByCategory,
  ];
}

/// A category that has a limit this month.
class SummaryBudgetLine extends Equatable {
  const SummaryBudgetLine({
    required this.name,
    required this.spent,
    required this.limit,
  });

  final String name;
  final double spent;
  final double limit;

  Map<String, Object?> toJson() => {
    'name': name,
    'spent': roundMoney(spent),
    'limit': roundMoney(limit),
  };

  @override
  List<Object?> get props => [name, spent, limit];
}

class SummaryBudget extends Equatable {
  const SummaryBudget({
    required this.period,
    required this.spent,
    required this.categories,
    this.monthlyLimit,
  });

  final String period;
  final double spent;
  final double? monthlyLimit;
  final List<SummaryBudgetLine> categories;

  Map<String, Object?> toJson() => {
    'period': period,
    'spent': roundMoney(spent),
    if (monthlyLimit case final limit?) 'monthlyLimit': roundMoney(limit),
    'categories': [for (final line in categories) line.toJson()],
  };

  @override
  List<Object?> get props => [period, spent, monthlyLimit, categories];
}

/// What the assistant is told about the user's money: totals only, rebuilt
/// from the phone's own data before every question. It deliberately has no
/// room for descriptions, ids, people or single transactions, so none can
/// leak into a request.
class SpendingSummary extends Equatable {
  const SpendingSummary({
    required this.currency,
    required this.generatedOn,
    required this.months,
    required this.budget,
    required this.trend,
  });

  /// The symbol the user picked; empty when none was set.
  final String currency;

  /// `yyyy-MM-dd`.
  final String generatedOn;

  /// Newest first.
  final List<SummaryMonth> months;
  final SummaryBudget budget;

  /// Spending per month, oldest first, as `yyyy-MM` → total.
  final List<(String, double)> trend;

  SpendingSummary withMonths(List<SummaryMonth> months) => SpendingSummary(
    currency: currency,
    generatedOn: generatedOn,
    months: months,
    budget: budget,
    trend: trend,
  );

  Map<String, Object?> toJson() => {
    'currency': currency,
    'generatedOn': generatedOn,
    'note': 'Spending excludes income. Amounts are in the currency above.',
    'months': [for (final month in months) month.toJson()],
    'budget': budget.toJson(),
    'trend': [
      for (final (period, total) in trend)
        {'period': period, 'total': roundMoney(total)},
    ],
  };

  @override
  List<Object?> get props => [currency, generatedOn, months, budget, trend];
}

/// Two decimals are all a money figure needs, and they keep the JSON small.
double roundMoney(double value) => (value * 100).roundToDouble() / 100;
