import '../../../../core/error/api_result.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../entities/category_breakdown.dart';
import '../entities/expense.dart';
import '../entities/month.dart';
import '../entities/month_overview.dart';
import '../repositories/expense_repository.dart';

/// Loads a month's expenses and derives its total and per-category breakdown.
class GetMonthOverview {
  const GetMonthOverview(this._repository);

  final ExpenseRepository _repository;

  Future<ApiResult<MonthOverview>> call(Month month) async {
    final result = await _repository.getExpensesForMonth(month);
    return result.map((expenses) => _overviewFrom(month, expenses));
  }

  MonthOverview _overviewFrom(Month month, List<Expense> expenses) {
    if (expenses.isEmpty) return MonthOverview.empty(month);

    final totals = <String, double>{};
    final categories = <String, ExpenseCategory>{};
    var total = 0.0;

    for (final expense in expenses) {
      total += expense.amount;
      final id = expense.category.id;
      totals[id] = (totals[id] ?? 0) + expense.amount;
      categories[id] = expense.category;
    }

    final breakdown = totals.entries
        .map(
          (entry) => CategoryBreakdown(
            category: categories[entry.key]!,
            total: entry.value,
            share: total == 0 ? 0 : entry.value / total,
          ),
        )
        .toList()
      ..sort((a, b) => b.total.compareTo(a.total));

    return MonthOverview(
      month: month,
      expenses: expenses,
      total: total,
      breakdown: breakdown,
    );
  }
}
