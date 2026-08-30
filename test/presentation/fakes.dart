import 'dart:async';

import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/repositories/category_repository.dart';
import 'package:my_budget/features/expenses/domain/entities/category_usage.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/domain/entities/monthly_summary.dart';
import 'package:my_budget/features/expenses/domain/repositories/expense_repository.dart';
import 'package:my_budget/features/quick_expense/domain/entities/quick_add_request.dart';
import 'package:my_budget/features/quick_expense/domain/entities/quick_expense_snapshot.dart';
import 'package:my_budget/features/quick_expense/domain/repositories/quick_expense_widget_repository.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/domain/repositories/settings_repository.dart';

/// In-memory stand-ins for the sqflite repositories.
///
/// Widget tests run inside a fake-async zone, where the real database's
/// background isolate never completes. The SQL itself is covered by the
/// integration tests in `test/data`.

class FakeCategoryRepository implements CategoryRepository {
  final List<ExpenseCategory> categories = [
    const ExpenseCategory(
      id: 'cat_food',
      name: 'Food',
      iconName: 'restaurant',
      colorValue: 0xFFEF6C00,
      isDefault: true,
    ),
    const ExpenseCategory(
      id: 'cat_bills',
      name: 'Bills',
      iconName: 'receipt_long',
      colorValue: 0xFF6D4C41,
      isDefault: true,
      sortOrder: 1,
    ),
    const ExpenseCategory(
      id: ExpenseCategory.fallbackId,
      name: 'Other',
      iconName: 'category',
      colorValue: 0xFF546E7A,
      isDefault: true,
      sortOrder: 2,
    ),
  ];

  int _nextId = 0;

  @override
  Future<ApiResult<List<ExpenseCategory>>> getCategories() async =>
      Success(List.unmodifiable(categories));

  @override
  Future<ApiResult<ExpenseCategory>> createCategory({
    required String name,
    required String iconName,
    required int colorValue,
  }) async {
    final created = ExpenseCategory(
      id: 'cat_new_${_nextId++}',
      name: name,
      iconName: iconName,
      colorValue: colorValue,
      sortOrder: categories.length,
    );
    categories.add(created);
    return Success(created);
  }

  @override
  Future<ApiResult<ExpenseCategory>> updateCategory(
    ExpenseCategory category,
  ) async {
    final index = categories.indexWhere((item) => item.id == category.id);
    if (index == -1) {
      return const ResultFailure(NotFoundFailure('missing category'));
    }
    categories[index] = category;
    return Success(category);
  }

  @override
  Future<ApiResult<int>> deleteCategory(String categoryId) async {
    categories.removeWhere((category) => category.id == categoryId);
    return const Success(0);
  }
}

class FakeExpenseRepository implements ExpenseRepository {
  FakeExpenseRepository(this._categories);

  final FakeCategoryRepository _categories;
  final List<Expense> expenses = [];

  int _nextId = 0;

  @override
  Future<ApiResult<List<Expense>>> getExpensesForMonth(Month month) async {
    final matching =
        expenses.where((expense) => expense.month == month).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return Success(matching);
  }

  @override
  Future<ApiResult<List<MonthlySummary>>> getMonthlySummaries() async {
    final totals = <Month, (double, int)>{};
    for (final expense in expenses) {
      final current = totals[expense.month] ?? (0.0, 0);
      totals[expense.month] = (
        current.$1 + expense.amount,
        current.$2 + 1,
      );
    }
    final summaries =
        totals.entries
            .map(
              (entry) => MonthlySummary(
                month: entry.key,
                total: entry.value.$1,
                expenseCount: entry.value.$2,
              ),
            )
            .toList()
          ..sort((a, b) => b.month.compareTo(a.month));
    return Success(summaries);
  }

  @override
  Future<ApiResult<List<CategoryUsage>>> getCategoryUsage() async {
    final counts = <String, int>{};
    for (final expense in expenses) {
      counts[expense.category.id] = (counts[expense.category.id] ?? 0) + 1;
    }
    final usage =
        counts.entries
            .map(
              (entry) =>
                  CategoryUsage(categoryId: entry.key, count: entry.value),
            )
            .toList()
          ..sort((a, b) => b.count.compareTo(a.count));
    return Success(usage);
  }

  @override
  Future<ApiResult<Expense>> addExpense({
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) async {
    final category = _categories.categories.firstWhere(
      (item) => item.id == categoryId,
    );
    final created = Expense(
      id: 'exp_${_nextId++}',
      amount: amount,
      category: category,
      date: date,
      description: description,
      createdAt: DateTime.now(),
    );
    expenses.add(created);
    return Success(created);
  }

  @override
  Future<ApiResult<Expense>> updateExpense({
    required String id,
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) async {
    final index = expenses.indexWhere((expense) => expense.id == id);
    if (index == -1) {
      return const ResultFailure(NotFoundFailure('missing expense'));
    }
    final updated = expenses[index].copyWith(
      amount: amount,
      date: date,
      description: description,
      category: _categories.categories.firstWhere(
        (item) => item.id == categoryId,
      ),
    );
    expenses[index] = updated;
    return Success(updated);
  }

  @override
  Future<ApiResult<void>> deleteExpense(String id) async {
    expenses.removeWhere((expense) => expense.id == id);
    return const Success(null);
  }
}

class FakeSettingsRepository implements SettingsRepository {
  AppSettings settings = const AppSettings();

  @override
  Future<ApiResult<AppSettings>> loadSettings() async => Success(settings);

  @override
  Future<ApiResult<AppSettings>> saveThemeMode(AppThemeMode mode) async {
    settings = settings.copyWith(themeMode: mode);
    return Success(settings);
  }

  @override
  Future<ApiResult<AppSettings>> saveLanguage(AppLanguage language) async {
    settings = settings.copyWith(language: language);
    return Success(settings);
  }

  @override
  Future<ApiResult<AppSettings>> saveCurrencySymbol(String symbol) async {
    settings = settings.copyWith(currencySymbol: symbol);
    return Success(settings);
  }
}

/// Stands in for the Android home screen widget: records what the app would
/// have drawn on it, and can play back a tap.
class FakeQuickExpenseWidgetRepository implements QuickExpenseWidgetRepository {
  final List<QuickExpenseSnapshot> published = [];

  /// Primed by a test to simulate the app being cold-started by a widget tap.
  QuickAddRequest? launchRequest;

  final StreamController<QuickAddRequest> _requests =
      StreamController<QuickAddRequest>.broadcast();

  QuickExpenseSnapshot? get latest =>
      published.isEmpty ? null : published.last;

  @override
  Future<ApiResult<void>> publish(QuickExpenseSnapshot snapshot) async {
    published.add(snapshot);
    return const Success(null);
  }

  @override
  Future<QuickAddRequest?> consumeLaunchRequest() async {
    final request = launchRequest;
    launchRequest = null;
    return request;
  }

  @override
  Stream<QuickAddRequest> get requests => _requests.stream;

  /// Simulates a tap while the app is already running.
  void tap(QuickAddRequest request) => _requests.add(request);

  Future<void> dispose() => _requests.close();
}
