import '../../../../core/error/api_result.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../../../expenses/domain/usecases/get_month_overview.dart';
import '../entities/budget_limits.dart';
import '../entities/budget_line.dart';
import '../entities/budget_status.dart';
import '../repositories/budget_repository.dart';

/// A month's spending set against the user's limits, category by category.
class GetBudgetStatus {
  const GetBudgetStatus({
    required BudgetRepository budgetRepository,
    required ExpenseRepository expenseRepository,
    required CategoryRepository categoryRepository,
  }) : _budgets = budgetRepository,
       _expenses = expenseRepository,
       _categories = categoryRepository;

  final BudgetRepository _budgets;
  final ExpenseRepository _expenses;
  final CategoryRepository _categories;

  Future<ApiResult<BudgetStatus>> call(Month month) async {
    final BudgetLimits limits;
    switch (await _budgets.getLimits()) {
      case Success(:final data):
        limits = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }

    final List<Expense> expenses;
    switch (await _expenses.getExpensesForMonth(month)) {
      case Success(:final data):
        expenses = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }

    final List<ExpenseCategory> categories;
    switch (await _categories.getCategories()) {
      case Success(:final data):
        categories = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }

    return Success(
      statusOf(
        month: month,
        limits: limits,
        expenses: expenses,
        categories: categories,
      ),
    );
  }

  /// The arithmetic on its own, so it can be tested without any storage.
  ///
  /// A limit on a category that no longer exists is ignored: its expenses
  /// have already moved to Other, which is measured against its own limit.
  static BudgetStatus statusOf({
    required Month month,
    required BudgetLimits limits,
    required List<Expense> expenses,
    required List<ExpenseCategory> categories,
  }) {
    // The same totals the home screen and the analyses show.
    final (spent, breakdown) = GetMonthOverview.breakdownOf(expenses);
    final spentById = {
      for (final slice in breakdown) slice.category.id: slice.total,
    };

    final lines = [
      for (final category in categories)
        CategoryBudget(
          category: category,
          spent: spentById[category.id] ?? 0,
          limit: limits.byCategory[category.id],
        ),
    ];
    final watchList = [
      for (final entry in lines)
        if (entry.line case final line? when line.level != BudgetLevel.safe)
          entry,
    ]..sort((a, b) => b.line!.fraction.compareTo(a.line!.fraction));

    return BudgetStatus(
      month: month,
      spent: spent,
      monthlyLimit: limits.monthly,
      categories: lines,
      watchList: watchList,
    );
  }
}
