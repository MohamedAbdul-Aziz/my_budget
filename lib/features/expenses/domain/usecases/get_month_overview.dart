import '../../../../core/error/api_result.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../entities/category_breakdown.dart';
import '../entities/expense.dart';
import '../entities/month.dart';
import '../entities/month_overview.dart';
import '../repositories/expense_repository.dart';

/// Loads a month's transactions and derives its income, its spending, and
/// where the spending went.
class GetMonthOverview {
  const GetMonthOverview(this._repository);

  final ExpenseRepository _repository;

  Future<ApiResult<MonthOverview>> call(Month month) async {
    final result = await _repository.getTransactionsForMonth(month);
    return result.map((transactions) => _overviewFrom(month, transactions));
  }

  MonthOverview _overviewFrom(Month month, List<Expense> transactions) {
    if (transactions.isEmpty) return MonthOverview.empty(month);
    final (spent, breakdown) = breakdownOf(transactions);
    return MonthOverview(
      month: month,
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
