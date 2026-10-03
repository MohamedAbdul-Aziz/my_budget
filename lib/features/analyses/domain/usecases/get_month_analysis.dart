import '../../../../core/error/api_result.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../expenses/domain/entities/monthly_summary.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../../../expenses/domain/usecases/get_month_overview.dart';
import '../entities/month_analysis.dart';

/// Builds the spending analyses for one month from the transactions already
/// stored; income is left out of every figure. The feature has no storage of
/// its own, so it reads through [ExpenseRepository] and needs no data layer.
class GetMonthAnalysis {
  const GetMonthAnalysis(this._repository);

  /// Months shown in the trend chart, including the selected one.
  static const int trendLength = 6;

  final ExpenseRepository _repository;

  Future<ApiResult<MonthAnalysis>> call(Month month, {DateTime? now}) async {
    final current = await _repository.getTransactionsForMonth(month);
    final previous = await _repository.getTransactionsForMonth(month.previous);
    final summaries = await _repository.getMonthlySummaries();

    for (final result in [current, previous]) {
      if (result case ResultFailure(:final failure)) {
        return ResultFailure(failure);
      }
    }
    if (summaries case ResultFailure(:final failure)) {
      return ResultFailure(failure);
    }

    final expenses = current.dataOrNull!;
    final (total, breakdown) = GetMonthOverview.breakdownOf(expenses);
    final previousTotal = previous.dataOrNull!.fold<double>(
      0,
      (sum, expense) => sum + expense.spending,
    );

    return Success(
      MonthAnalysis(
        month: month,
        total: total,
        breakdown: breakdown,
        previousTotal: previousTotal,
        dailyAverage: total / daysCounted(month, now ?? DateTime.now()),
        topDay: topDayOf(expenses),
        trend: trendEndingAt(month, summaries.dataOrNull!),
      ),
    );
  }

  /// Days the average is spread over: the days so far for the current month,
  /// every day of it for a past one.
  static int daysCounted(Month month, DateTime now) {
    final daysInMonth = month.endExclusive
        .subtract(const Duration(days: 1))
        .day;
    if (month == Month.fromDate(now)) return now.day;
    return daysInMonth;
  }

  static TopDay? topDayOf(List<Expense> expenses) {
    final byDay = <DateTime, double>{};
    for (final expense in expenses) {
      if (expense.isIncome) continue;
      final day = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      byDay[day] = (byDay[day] ?? 0) + expense.amount;
    }
    if (byDay.isEmpty) return null;
    final top = byDay.entries.reduce((a, b) => b.value > a.value ? b : a);
    return TopDay(date: top.key, total: top.value);
  }

  static List<MonthlySummary> trendEndingAt(
    Month month,
    List<MonthlySummary> summaries,
  ) {
    final byMonth = {for (final summary in summaries) summary.month: summary};
    final months = <Month>[month];
    while (months.length < trendLength) {
      months.insert(0, months.first.previous);
    }
    return [
      for (final m in months)
        byMonth[m] ?? MonthlySummary(month: m, total: 0, expenseCount: 0),
    ];
  }
}
