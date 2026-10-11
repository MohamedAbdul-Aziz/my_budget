import 'dart:convert';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../analyses/domain/entities/month_analysis.dart';
import '../../../analyses/domain/usecases/get_month_analysis.dart';
import '../../../budgets/domain/entities/budget_status.dart';
import '../../../budgets/domain/usecases/get_budget_status.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../expenses/domain/entities/category_breakdown.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../../../expenses/domain/usecases/get_period_overview.dart';
import '../../../people/domain/entities/person_summary.dart';
import '../../../people/domain/usecases/get_people.dart';
import '../../../recurring/domain/entities/recurring_overview.dart';
import '../../../recurring/domain/usecases/get_recurring_overview.dart';
import '../entities/assistant_sharing.dart';
import '../entities/spending_summary.dart';

/// Turns the phone's own figures into the summary the assistant answers
/// from. It reuses the analyses and budget use cases, so every number
/// matches what the Analyses tab shows.
///
/// By default ([AssistantSharing.defaults]) only totals go in: never a
/// description, an id, a person or a single transaction
/// ([MonthAnalysis.largestExpense] is left out for that reason). Anything
/// more is added only when the user turned it on.
class BuildSpendingSummary {
  const BuildSpendingSummary({
    required GetMonthAnalysis getMonthAnalysis,
    required GetBudgetStatus getBudgetStatus,
    required ExpenseRepository expenseRepository,
    required GetRecurringOverview getRecurringOverview,
    required GetPeople getPeople,
  }) : _analysis = getMonthAnalysis,
       _budget = getBudgetStatus,
       _expenses = expenseRepository,
       _recurring = getRecurringOverview,
       _people = getPeople;

  /// The most the totals part may weigh once encoded, in bytes.
  static const int maxBytes = 8192;

  /// The most the whole summary may weigh, shared parts included. The
  /// server refuses anything larger, and the free AI tier only takes a few
  /// thousand tokens a minute.
  static const int maxTotalBytes = 16384;

  /// The most recurring payments or people sent.
  static const int maxListItems = 50;

  /// How far category lists are cut, in turn, when the summary is too big.
  static const List<int> categoryCaps = [10, 5];

  /// Stands for the categories merged away by a cut. English, like the rest
  /// of the summary's keys: the model reads it, the user never does.
  static const String othersName = '(others)';

  final GetMonthAnalysis _analysis;
  final GetBudgetStatus _budget;
  final ExpenseRepository _expenses;
  final GetRecurringOverview _recurring;
  final GetPeople _people;

  /// [labelOf] names a category as the user sees it (built-in categories are
  /// translated in the presentation layer). [sharing] says what goes in
  /// besides the totals.
  Future<ApiResult<SpendingSummary>> call({
    required String Function(ExpenseCategory) labelOf,
    required String currency,
    AssistantSharing sharing = AssistantSharing.defaults,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final current = Month.fromDate(today);
    final resolved = sharing.resolve(today);

    final analyses = <MonthAnalysis>[];
    for (final month in resolved.months) {
      switch (await _analysis(month, now: today)) {
        case Success(:final data):
          analyses.add(data);
        case ResultFailure(:final failure):
          return ResultFailure(failure);
      }
    }

    final BudgetStatus budget;
    switch (await _budget(current)) {
      case Success(:final data):
        budget = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }

    // Whatever the user shares that is read by dates rather than by month.
    List<Expense>? inRange;
    if (sharing.range == AssistantRange.custom || sharing.transactions) {
      switch (await _expenses.getTransactionsBetween(
        resolved.start,
        resolved.endExclusive,
      )) {
        case Success(:final data):
          inRange = [...data]..sort((a, b) => b.date.compareTo(a.date));
        case ResultFailure(:final failure):
          return ResultFailure(failure);
      }
    }

    List<SummaryRecurring>? recurring;
    if (sharing.recurring) {
      switch (await _recurring(today: today)) {
        case Success(:final data):
          recurring = [
            for (final item in data.commitments.take(maxListItems))
              _recurringOf(item, labelOf),
          ];
        case ResultFailure(:final failure):
          return ResultFailure(failure);
      }
    }

    List<SummaryPerson>? people;
    if (sharing.people) {
      switch (await _people()) {
        case Success(:final data):
          people = [
            for (final person in data.take(maxListItems)) _personOf(person),
          ];
        case ResultFailure(:final failure):
          return ResultFailure(failure);
      }
    }

    final totals = fitted(
      SpendingSummary(
        currency: currency,
        generatedOn: _day(today),
        months: [
          for (final analysis in analyses) _month(analysis, labelOf, today),
        ],
        budget: _budgetOf(budget, labelOf),
        trend: [
          for (final summary in analyses.first.trend)
            (summary.month.key, summary.total),
        ],
        range: sharing.range == AssistantRange.custom
            ? _rangeOf(resolved, inRange!, labelOf)
            : null,
        recurring: recurring,
        people: people,
      ),
    );
    if (totals case ResultFailure(:final failure)) {
      return ResultFailure(failure);
    }
    final summary = totals.dataOrNull!;
    if (!sharing.transactions) {
      return sizeOf(summary) <= maxTotalBytes
          ? Success(summary)
          : const ResultFailure(ValidationFailure(FailureCode.summaryTooLarge));
    }
    return withTransactions(summary, [
      for (final expense in inRange!)
        SummaryTransaction(
          date: _day(expense.date),
          amount: expense.amount,
          isIncome: expense.isIncome,
          category: labelOf(expense.category),
          note: sharing.sendsDescriptions ? expense.description?.trim() : null,
        ),
    ]);
  }

  /// [summary] with as many of [transactions] (newest first) as fit in
  /// [maxTotalBytes]; the model is told how many older ones were left out.
  static ApiResult<SpendingSummary> withTransactions(
    SpendingSummary summary,
    List<SummaryTransaction> transactions,
  ) {
    SpendingSummary keeping(int count) => summary.withTransactions(
      transactions.take(count).toList(),
      leftOut: transactions.length - count,
    );

    if (sizeOf(keeping(transactions.length)) <= maxTotalBytes) {
      return Success(keeping(transactions.length));
    }
    if (sizeOf(keeping(0)) > maxTotalBytes) {
      return const ResultFailure(
        ValidationFailure(FailureCode.summaryTooLarge),
      );
    }
    // The most that fit, found by halving.
    var fits = 0;
    var tooMany = transactions.length;
    while (tooMany - fits > 1) {
      final middle = (fits + tooMany) ~/ 2;
      if (sizeOf(keeping(middle)) <= maxTotalBytes) {
        fits = middle;
      } else {
        tooMany = middle;
      }
    }
    return Success(keeping(fits));
  }

  /// [summary] as it is, or with its category lists cut down until it fits
  /// in [maxBytes].
  static ApiResult<SpendingSummary> fitted(SpendingSummary summary) {
    if (sizeOf(summary) <= maxBytes) return Success(summary);
    for (final cap in categoryCaps) {
      final cut = summary.withMonths([
        for (final month in summary.months)
          month.withCategories(
            spending: _capped(month.spendingByCategory, cap),
            income: _capped(month.incomeByCategory, cap),
          ),
      ]);
      if (sizeOf(cut) <= maxBytes) return Success(cut);
    }
    return const ResultFailure(ValidationFailure(FailureCode.summaryTooLarge));
  }

  static int sizeOf(SpendingSummary summary) =>
      utf8.encode(jsonEncode(summary.toJson())).length;

  /// Keeps the [cap] largest and merges the rest into one row, so the month
  /// still adds up.
  static List<SummaryCategory> _capped(List<SummaryCategory> list, int cap) {
    if (list.length <= cap) return list;
    final kept = list.take(cap - 1).toList();
    final rest = list.skip(cap - 1);
    return [
      ...kept,
      SummaryCategory(
        name: othersName,
        total: rest.fold(0, (sum, c) => sum + c.total),
        share: rest.fold(0, (sum, c) => sum + c.share),
      ),
    ];
  }

  static SummaryMonth _month(
    MonthAnalysis analysis,
    String Function(ExpenseCategory) labelOf,
    DateTime now,
  ) {
    final isCurrent = analysis.month == Month.fromDate(now);
    final topDay = analysis.topDay;
    return SummaryMonth(
      period: analysis.month.key,
      isCurrent: isCurrent,
      daysCounted: GetMonthAnalysis.daysCounted(analysis.month, now),
      spent: analysis.total,
      income: analysis.income,
      expenseCount: analysis.expenseCount,
      dailyAverage: analysis.dailyAverage,
      previousMonthSpent: analysis.previousTotal,
      changeVsPrevious: analysis.change,
      projectedMonthEnd: isCurrent ? analysis.projectedTotal(now) : null,
      topDayDate: topDay == null ? null : _day(topDay.date),
      topDayTotal: topDay?.total,
      spendingByCategory: _categories(analysis.breakdown, labelOf),
      incomeByCategory: _categories(analysis.incomeBreakdown, labelOf),
    );
  }

  static List<SummaryCategory> _categories(
    List<CategoryBreakdown> breakdown,
    String Function(ExpenseCategory) labelOf,
  ) => [
    for (final slice in breakdown)
      SummaryCategory(
        name: labelOf(slice.category),
        total: slice.total,
        share: slice.share,
      ),
  ];

  static SummaryRange _rangeOf(
    ResolvedRange range,
    List<Expense> expenses,
    String Function(ExpenseCategory) labelOf,
  ) {
    final (spent, breakdown) = GetPeriodOverview.breakdownOf(expenses);
    return SummaryRange(
      from: _day(range.start),
      to: _day(range.lastDay),
      spent: spent,
      income: GetPeriodOverview.incomeOf(expenses),
      spendingByCategory: _categories(breakdown, labelOf),
    );
  }

  static SummaryRecurring _recurringOf(
    RecurringCommitment item,
    String Function(ExpenseCategory) labelOf,
  ) => SummaryRecurring(
    title: item.recurring.title,
    amount: item.recurring.amount,
    isIncome: item.recurring.isIncome,
    frequency: item.recurring.frequency.storageKey,
    status: item.status.name,
    nextDue: _day(item.nextDue),
  );

  static SummaryPerson _personOf(PersonSummary person) => SummaryPerson(
    name: person.person.name,
    balance: person.balance.amount,
    openCount: person.openCount,
  );

  static SummaryBudget _budgetOf(
    BudgetStatus status,
    String Function(ExpenseCategory) labelOf,
  ) => SummaryBudget(
    period: status.month.key,
    spent: status.spent,
    monthlyLimit: status.monthlyLimit,
    categories: [
      for (final entry in status.categories)
        if (entry.limit case final limit?)
          SummaryBudgetLine(
            name: labelOf(entry.category),
            spent: entry.spent,
            limit: limit,
          ),
    ],
  );

  static String _day(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
