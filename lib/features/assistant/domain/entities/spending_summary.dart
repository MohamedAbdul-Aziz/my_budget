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

/// Totals for a custom range, which need not start or end on a month's
/// edge.
class SummaryRange extends Equatable {
  const SummaryRange({
    required this.from,
    required this.to,
    required this.spent,
    required this.income,
    required this.spendingByCategory,
  });

  /// `yyyy-MM-dd`, both included.
  final String from;
  final String to;
  final double spent;
  final double income;
  final List<SummaryCategory> spendingByCategory;

  Map<String, Object?> toJson() => {
    'from': from,
    'to': to,
    'spent': roundMoney(spent),
    'income': roundMoney(income),
    'net': roundMoney(income - spent),
    'spendingByCategory': [for (final c in spendingByCategory) c.toJson()],
  };

  @override
  List<Object?> get props => [from, to, spent, income, spendingByCategory];
}

/// One transaction, sent only when the user shares transactions. No id; the
/// note only when the user shares notes too.
class SummaryTransaction extends Equatable {
  const SummaryTransaction({
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.category,
    this.note,
  });

  /// `yyyy-MM-dd`.
  final String date;
  final double amount;
  final bool isIncome;
  final String category;
  final String? note;

  Map<String, Object?> toJson() => {
    'date': date,
    'type': isIncome ? 'income' : 'expense',
    'amount': roundMoney(amount),
    'category': category,
    if (note case final note? when note.isNotEmpty) 'note': note,
  };

  @override
  List<Object?> get props => [date, amount, isIncome, category, note];
}

/// A recurring payment or income, sent only when the user shares them.
class SummaryRecurring extends Equatable {
  const SummaryRecurring({
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.frequency,
    required this.status,
    required this.nextDue,
  });

  final String title;
  final double amount;
  final bool isIncome;

  /// `weekly`, `monthly` or `yearly`.
  final String frequency;

  /// `paid`, `upcoming` or `overdue`.
  final String status;

  /// `yyyy-MM-dd`.
  final String nextDue;

  Map<String, Object?> toJson() => {
    'title': title,
    'type': isIncome ? 'income' : 'expense',
    'amount': roundMoney(amount),
    'frequency': frequency,
    'status': status,
    'nextDue': nextDue,
  };

  @override
  List<Object?> get props => [
    title,
    amount,
    isIncome,
    frequency,
    status,
    nextDue,
  ];
}

/// Where the user stands with one person, sent only when the user shares
/// people.
class SummaryPerson extends Equatable {
  const SummaryPerson({
    required this.name,
    required this.balance,
    required this.openCount,
  });

  final String name;

  /// Positive when the person owes the user, negative when the user owes
  /// them.
  final double balance;
  final int openCount;

  Map<String, Object?> toJson() => {
    'name': name,
    'balance': roundMoney(balance),
    'openTransactions': openCount,
  };

  @override
  List<Object?> get props => [name, balance, openCount];
}

/// What the assistant is told about the user's money, rebuilt from the
/// phone's own data before every question.
///
/// By default it is totals only, with no room for descriptions, ids, people
/// or single transactions. The optional parts carry exactly what the user
/// chose to share (see `AssistantSharing`), and are left out otherwise.
class SpendingSummary extends Equatable {
  const SpendingSummary({
    required this.currency,
    required this.generatedOn,
    required this.months,
    required this.budget,
    required this.trend,
    this.range,
    this.transactions,
    this.transactionsLeftOut = 0,
    this.recurring,
    this.people,
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

  /// Only for a custom range.
  final SummaryRange? range;

  /// Only when shared: newest first.
  final List<SummaryTransaction>? transactions;

  /// The oldest transactions left out to keep the request small.
  final int transactionsLeftOut;

  /// Only when shared.
  final List<SummaryRecurring>? recurring;

  /// Only when shared.
  final List<SummaryPerson>? people;

  SpendingSummary withMonths(List<SummaryMonth> months) =>
      _copy(months: months);

  SpendingSummary withTransactions(
    List<SummaryTransaction> transactions, {
    required int leftOut,
  }) => _copy(transactions: transactions, transactionsLeftOut: leftOut);

  SpendingSummary _copy({
    List<SummaryMonth>? months,
    List<SummaryTransaction>? transactions,
    int? transactionsLeftOut,
  }) => SpendingSummary(
    currency: currency,
    generatedOn: generatedOn,
    months: months ?? this.months,
    budget: budget,
    trend: trend,
    range: range,
    transactions: transactions ?? this.transactions,
    transactionsLeftOut: transactionsLeftOut ?? this.transactionsLeftOut,
    recurring: recurring,
    people: people,
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
    if (range case final range?) 'range': range.toJson(),
    if (transactions case final transactions?) ...{
      'transactions': [for (final t in transactions) t.toJson()],
      if (transactionsLeftOut > 0)
        'olderTransactionsLeftOut': transactionsLeftOut,
    },
    if (recurring case final recurring?)
      'recurring': [for (final r in recurring) r.toJson()],
    if (people case final people?)
      'people': [for (final p in people) p.toJson()],
  };

  @override
  List<Object?> get props => [
    currency,
    generatedOn,
    months,
    budget,
    trend,
    range,
    transactions,
    transactionsLeftOut,
    recurring,
    people,
  ];
}

/// Two decimals are all a money figure needs, and they keep the JSON small.
double roundMoney(double value) => (value * 100).roundToDouble() / 100;
