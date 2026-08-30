import '../../../../core/error/api_result.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../expenses/domain/entities/category_usage.dart';
import '../../../expenses/domain/entities/month.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../entities/quick_expense_data.dart';

/// Builds what the home screen widget should show: this month's total and the
/// category shortcuts most likely to be wanted next.
class GetQuickExpenseData {
  const GetQuickExpenseData({
    required ExpenseRepository expenseRepository,
    required CategoryRepository categoryRepository,
  }) : _expenses = expenseRepository,
       _categories = categoryRepository;

  /// How many shortcuts fit on the widget.
  static const int shortcutCount = 4;

  final ExpenseRepository _expenses;
  final CategoryRepository _categories;

  Future<ApiResult<QuickExpenseData>> call() async {
    final month = Month.current();

    final List<ExpenseCategory> categories;
    switch (await _categories.getCategories()) {
      case Success(:final data):
        categories = data;
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }

    final double monthTotal;
    switch (await _expenses.getExpensesForMonth(month)) {
      case Success(:final data):
        monthTotal = data.fold(0.0, (total, expense) => total + expense.amount);
      case ResultFailure(:final failure):
        return ResultFailure(failure);
    }

    // A failed usage read only costs the ranking, not the whole widget.
    final usage = (await _expenses.getCategoryUsage()).dataOrNull ?? const [];

    return Success(
      QuickExpenseData(
        month: month,
        monthTotal: monthTotal,
        categories: rank(categories, usage),
      ),
    );
  }

  /// Most-used categories first. Before there is any history, the shortcuts
  /// are the first few categories plus the catch-all, so the widget is useful
  /// on day one instead of empty.
  static List<ExpenseCategory> rank(
    List<ExpenseCategory> categories,
    List<CategoryUsage> usage,
  ) {
    if (categories.isEmpty) return const [];

    final byId = {for (final category in categories) category.id: category};

    if (usage.isEmpty) {
      final fallback = byId[ExpenseCategory.fallbackId];
      final rest = categories
          .where((category) => category.id != ExpenseCategory.fallbackId)
          .take(fallback == null ? shortcutCount : shortcutCount - 1);
      return [...rest, if (fallback != null) fallback];
    }

    final ranked = <ExpenseCategory>[];
    final taken = <String>{};

    void add(ExpenseCategory category) {
      if (taken.add(category.id)) ranked.add(category);
    }

    for (final entry in usage) {
      if (ranked.length == shortcutCount) return ranked;
      final category = byId[entry.categoryId];
      if (category != null) add(category);
    }

    // Pad with unused categories so the widget always shows a full row.
    for (final category in categories) {
      if (ranked.length == shortcutCount) break;
      add(category);
    }
    return ranked;
  }
}
