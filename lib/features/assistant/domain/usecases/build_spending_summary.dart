import 'dart:convert';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../analyses/domain/entities/month_analysis.dart';
import '../../../analyses/domain/usecases/get_month_analysis.dart';
import '../../../budgets/domain/entities/budget_status.dart';
import '../../../budgets/domain/usecases/get_budget_status.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../expenses/domain/entities/category_breakdown.dart';
import '../../../expenses/domain/entities/month.dart';
import '../entities/spending_summary.dart';

/// Turns the phone's own figures into the small summary the assistant
/// answers from. It reuses the analyses and budget use cases, so every
/// number matches what the Analyses tab shows.
///
/// Only totals go in: never a description, an id, a person or a single
/// transaction ([MonthAnalysis.largestExpense] is left out for that reason).
class BuildSpendingSummary {
  const BuildSpendingSummary({
    required GetMonthAnalysis getMonthAnalysis,
    required GetBudgetStatus getBudgetStatus,
  }) : _analysis = getMonthAnalysis,
       _budget = getBudgetStatus;

  /// The current month and the two before it.
  static const int monthsIncluded = 3;

  /// The most the summary may weigh once encoded, in bytes. The server
  /// refuses anything larger.
  static const int maxBytes = 8192;

  /// How far category lists are cut, in turn, when the summary is too big.
  static const List<int> categoryCaps = [10, 5];

  /// Stands for the categories merged away by a cut. English, like the rest
  /// of the summary's keys: the model reads it, the user never does.
  static const String othersName = '(others)';

  final GetMonthAnalysis _analysis;
  final GetBudgetStatus _budget;

  /// [labelOf] names a category as the user sees it (built-in categories are
  /// translated in the presentation layer).
  Future<ApiResult<SpendingSummary>> call({
    required String Function(ExpenseCategory) labelOf,
    required String currency,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final current = Month.fromDate(today);

    final analyses = <MonthAnalysis>[];
    var month = current;
    for (var i = 0; i < monthsIncluded; i++) {
      switch (await _analysis(month, now: today)) {
        case Success(:final data):
          analyses.add(data);
        case ResultFailure(:final failure):
          return ResultFailure(failure);
      }
      month = month.previous;
    }

    final BudgetStatus budget;
    switch (await _budget(current)) {
      case Success(:final data):
        budget = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }

    final summary = SpendingSummary(
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
    );
    return fitted(summary);
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
