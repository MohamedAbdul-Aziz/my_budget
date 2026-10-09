import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../budgets/domain/entities/budget_status.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../domain/entities/analysis_question.dart';
import '../../domain/entities/month_analysis.dart';
import '../../domain/entities/month_comparison.dart';

/// The sentences that answer [question] from the month's own figures.
/// [AnalysisQuestion.compareMonths] and [AnalysisQuestion.budgetLeft] need
/// data of their own; see [compareAnswer] and [budgetAnswer].
List<String> answerFor(
  AnalysisQuestion question,
  MonthAnalysis analysis,
  AppStrings strings,
  AppFormats formats, {
  DateTime? now,
}) {
  String money(double amount) => formats.moneyTight(amount);
  final noSpending = [strings.noSpendingThisMonth];

  switch (question) {
    case AnalysisQuestion.compareMonths || AnalysisQuestion.budgetLeft:
      return const [];
    case AnalysisQuestion.topCategory:
      if (analysis.breakdown.isEmpty) return noSpending;
      final top = analysis.breakdown.first;
      return [
        strings.answerTopCategory(
          categoryLabel(strings, top.category),
          money(top.total),
          formats.percent(top.share),
        ),
      ];
    case AnalysisQuestion.vsLastMonth:
      final lines = _difference(
        analysis.month,
        analysis.month.previous,
        analysis.total,
        analysis.previousTotal,
        strings,
        formats,
      );
      final rise = analysis.biggestRise;
      if (rise != null && analysis.previousTotal > 0) {
        lines.add(
          strings.answerRise(
            categoryLabel(strings, rise.breakdown.category),
            money(rise.difference),
          ),
        );
      }
      return lines;
    case AnalysisQuestion.biggestExpense:
      final largest = analysis.largestExpense;
      if (largest == null) return noSpending;
      return [
        strings.answerBiggestExpense(
          money(largest.amount),
          categoryLabel(strings, largest.category),
          formats.fullDate(largest.date),
        ),
        if (largest.description case final note? when note.trim().isNotEmpty)
          '“${note.trim()}”',
      ];
    case AnalysisQuestion.topDay:
      final topDay = analysis.topDay;
      if (topDay == null) return noSpending;
      return [
        strings.answerTopDay(
          strings.dayLabel(topDay.date, formats),
          money(topDay.total),
        ),
      ];
    case AnalysisQuestion.weekday:
      final busiest = analysis.busiestWeekday;
      if (busiest == null) return noSpending;
      return [
        strings.answerWeekday(
          formats.weekdayName(busiest + 1),
          money(analysis.byWeekday[busiest]),
        ),
      ];
    case AnalysisQuestion.monthEnd:
      if (analysis.isEmpty) return noSpending;
      final today = now ?? DateTime.now();
      if (analysis.month != Month.fromDate(today)) {
        return [strings.answerMonthTotal(money(analysis.total))];
      }
      return [
        strings.answerMonthEnd(
          money(analysis.projectedTotal(today)),
          money(analysis.dailyAverage),
        ),
      ];
    case AnalysisQuestion.saved:
      if (analysis.income == 0) return [strings.answerNoIncome];
      final kept = analysis.income - analysis.total;
      return [
        kept >= 0
            ? strings.answerSaved(money(kept), money(analysis.income))
            : strings.answerOverspent(money(-kept)),
      ];
    case AnalysisQuestion.highestLowest:
      final extremes = analysis.highestAndLowest;
      if (extremes == null) return noSpending;
      final (high, low) = extremes;
      return [
        strings.answerHighestLowest(
          formats.monthLabel(high.month),
          money(high.total),
          formats.monthLabel(low.month),
          money(low.total),
        ),
      ];
    case AnalysisQuestion.count:
      if (analysis.expenseCount == 0) return noSpending;
      return [
        strings.answerCount(
          analysis.expenseCount,
          money(analysis.averageExpense),
        ),
      ];
    case AnalysisQuestion.topIncome:
      if (analysis.incomeBreakdown.isEmpty) return [strings.answerNoIncome];
      final top = analysis.incomeBreakdown.first;
      return [
        strings.answerTopIncome(
          categoryLabel(strings, top.category),
          money(top.total),
          formats.percent(top.share),
        ),
      ];
  }
}

/// How [comparison]'s first month went against its second.
List<String> compareAnswer(
  MonthComparison comparison,
  AppStrings strings,
  AppFormats formats,
) {
  final lines = _difference(
    comparison.first,
    comparison.second,
    comparison.firstTotal,
    comparison.secondTotal,
    strings,
    formats,
  );
  if (comparison.firstTotal > 0 && comparison.secondTotal > 0) {
    if (comparison.biggestRise case final rise?) {
      lines.add(
        strings.answerRise(
          categoryLabel(strings, rise.category),
          formats.moneyTight(rise.difference),
        ),
      );
    }
    if (comparison.biggestDrop case final drop?) {
      lines.add(
        strings.answerDrop(
          categoryLabel(strings, drop.category),
          formats.moneyTight(-drop.difference),
        ),
      );
    }
  }
  return lines;
}

/// What is left of the monthly budget and which categories went past theirs.
List<String> budgetAnswer(
  BudgetStatus status,
  AppStrings strings,
  AppFormats formats,
) {
  final total = status.total;
  final over = [
    for (final item in status.categories)
      if (item.line?.isOver ?? false) categoryLabel(strings, item.category),
  ];
  return [
    if (total == null)
      strings.answerNoBudget
    else if (total.isOver)
      strings.answerBudgetOver(formats.moneyTight(-total.remaining))
    else
      strings.answerBudgetLeft(
        formats.moneyTight(total.remaining),
        formats.percent(total.fraction),
      ),
    if (over.isNotEmpty)
      strings.answerOverLimit(over.join(_listSeparator(strings))),
  ];
}

/// Arabic script languages use their own comma.
String _listSeparator(AppStrings strings) =>
    const {'ar', 'fa', 'ur'}.contains(strings.localeName.split('_').first)
    ? '، '
    : ', ';

List<String> _difference(
  Month month,
  Month other,
  double total,
  double otherTotal,
  AppStrings strings,
  AppFormats formats,
) {
  final monthLabel = formats.monthLabel(month);
  final otherLabel = formats.monthLabel(other);
  if (otherTotal == 0 && total == 0) {
    return [strings.answerNothingIn(monthLabel)];
  }
  if (otherTotal == 0) return [strings.answerNothingIn(otherLabel)];
  final difference = total - otherTotal;
  final percent = formats.percent((difference / otherTotal).abs());
  final amount = formats.moneyTight(difference.abs());
  return [
    if ((difference * 100).round() == 0)
      strings.answerSpentSame(monthLabel, otherLabel)
    else if (difference > 0)
      strings.answerSpentMore(monthLabel, otherLabel, amount, percent)
    else
      strings.answerSpentLess(monthLabel, otherLabel, amount, percent),
  ];
}
