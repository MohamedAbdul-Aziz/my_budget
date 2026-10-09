import '../../../../core/error/api_result.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../entities/category_breakdown.dart';
import '../entities/expense.dart';
import '../entities/period.dart';
import '../entities/period_overview.dart';
import '../repositories/expense_repository.dart';

/// Loads a period's transactions and derives its income, its spending, and
/// where the spending went.
class GetPeriodOverview {
  const GetPeriodOverview(this._repository);

  final ExpenseRepository _repository;

  /// A month is read by its stored month, like the budgets and analyses, so
  /// all three agree on what belongs to it; any other period by its dates.
  Future<ApiResult<PeriodOverview>> call(Period period) async {
    final result = period.kind == PeriodKind.month
        ? await _repository.getTransactionsForMonth(period.month)
        : await _repository.getTransactionsBetween(
            period.start,
            period.endExclusive,
          );
    return result.map((transactions) => _overviewFrom(period, transactions));
  }

  PeriodOverview _overviewFrom(Period period, List<Expense> transactions) {
    if (transactions.isEmpty) return PeriodOverview.empty(period);
    final (spent, breakdown) = breakdownOf(transactions);
    return PeriodOverview(
      period: period,
      transactions: transactions,
      income: incomeOf(transactions),
      spent: spent,
      breakdown: breakdown,
    );
  }

  /// Everything that came in among [transactions].
  static double incomeOf(List<Expense> transactions) => transactions.fold(
    0,
    (total, transaction) =>
        transaction.isIncome ? total + transaction.amount : total,
  );

  /// The spending among [transactions] and its split by category, largest
  /// share first. Income is skipped, so any list can be passed in. Shared
  /// with the analyses page and the budgets so every screen agrees.
  static (double, List<CategoryBreakdown>) breakdownOf(
    List<Expense> transactions,
  ) {
    final totals = <String, double>{};
    final categories = <String, ExpenseCategory>{};
    var total = 0.0;

    for (final expense in transactions) {
      if (expense.isIncome) continue;
      total += expense.amount;
      final id = expense.category.id;
      totals[id] = (totals[id] ?? 0) + expense.amount;
      categories[id] = expense.category;
    }

    final breakdown =
        totals.entries
            .map(
              (entry) => CategoryBreakdown(
                category: categories[entry.key]!,
                total: entry.value,
                share: total == 0 ? 0 : entry.value / total,
              ),
            )
            .toList()
          ..sort((a, b) => b.total.compareTo(a.total));
    return (total, breakdown);
  }
}
