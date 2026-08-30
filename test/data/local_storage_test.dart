import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/data/datasources/category_local_data_source.dart';
import 'package:my_budget/features/categories/data/repositories/category_repository_impl.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/repositories/category_repository.dart';
import 'package:my_budget/features/categories/domain/usecases/delete_category.dart';
import 'package:my_budget/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:my_budget/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/domain/repositories/expense_repository.dart';

void main() {
  late AppDatabase database;
  late ExpenseRepository expenses;
  late CategoryRepository categories;

  setUp(() {
    database = AppDatabase(inMemory: true);
    expenses = ExpenseRepositoryImpl(ExpenseLocalDataSourceImpl(database));
    categories = CategoryRepositoryImpl(
      CategoryLocalDataSourceImpl(database),
    );
  });

  tearDown(() => database.close());

  test('seeds the default categories on first open', () async {
    final result = await categories.getCategories();
    final seeded = result.dataOrNull!;

    expect(seeded, hasLength(8));
    expect(
      seeded.map((category) => category.name),
      containsAll(['Food', 'Transportation', 'Bills', 'Other']),
    );
    expect(seeded.every((category) => category.isDefault), isTrue);
  });

  test('stores an expense and reads it back with its category', () async {
    final added = await expenses.addExpense(
      amount: 12.5,
      categoryId: 'cat_food',
      date: DateTime(2026, 8, 4),
      description: 'Lunch',
    );
    expect(added.isSuccess, isTrue);

    final month = await expenses.getExpensesForMonth(const Month(2026, 8));
    final stored = month.dataOrNull!;

    expect(stored, hasLength(1));
    expect(stored.single.amount, 12.5);
    expect(stored.single.description, 'Lunch');
    expect(stored.single.category.name, 'Food');
  });

  test('keeps each month separate and orders newest first', () async {
    await expenses.addExpense(
      amount: 10,
      categoryId: 'cat_food',
      date: DateTime(2026, 7, 20),
    );
    await expenses.addExpense(
      amount: 20,
      categoryId: 'cat_bills',
      date: DateTime(2026, 8, 1),
    );
    await expenses.addExpense(
      amount: 30,
      categoryId: 'cat_food',
      date: DateTime(2026, 8, 15),
    );

    final august = (await expenses.getExpensesForMonth(
      const Month(2026, 8),
    )).dataOrNull!;
    expect(august.map((expense) => expense.amount), [30, 20]);

    final summaries = (await expenses.getMonthlySummaries()).dataOrNull!;
    expect(summaries.map((summary) => summary.month.key), [
      '2026-08',
      '2026-07',
    ]);
    expect(summaries.first.total, 50);
    expect(summaries.first.expenseCount, 2);
    expect(summaries.last.total, 10);
  });

  test('moves an expense between months when its date changes', () async {
    final created = (await expenses.addExpense(
      amount: 40,
      categoryId: 'cat_food',
      date: DateTime(2026, 8, 10),
    )).dataOrNull!;

    await expenses.updateExpense(
      id: created.id,
      amount: 40,
      categoryId: 'cat_food',
      date: DateTime(2026, 9, 2),
    );

    final august = (await expenses.getExpensesForMonth(
      const Month(2026, 8),
    )).dataOrNull!;
    final september = (await expenses.getExpensesForMonth(
      const Month(2026, 9),
    )).dataOrNull!;

    expect(august, isEmpty);
    expect(september, hasLength(1));
  });

  test('deleting a category moves its expenses to Other', () async {
    final custom = (await categories.createCategory(
      name: 'Coffee',
      iconName: 'local_cafe',
      colorValue: 0xFF6D4C41,
    )).dataOrNull!;

    await expenses.addExpense(
      amount: 4,
      categoryId: custom.id,
      date: DateTime(2026, 8, 3),
    );

    final moved = (await categories.deleteCategory(custom.id)).dataOrNull;
    expect(moved, 1);

    final remaining = (await categories.getCategories()).dataOrNull!;
    expect(remaining.any((category) => category.id == custom.id), isFalse);

    // The spending survives — only its label changed.
    final august = (await expenses.getExpensesForMonth(
      const Month(2026, 8),
    )).dataOrNull!;
    expect(august.single.amount, 4);
    expect(august.single.category.id, ExpenseCategory.fallbackId);
  });

  test('refuses to delete the fallback category', () async {
    final other = (await categories.getCategories()).dataOrNull!.firstWhere(
      (category) => category.id == ExpenseCategory.fallbackId,
    );

    final result = await DeleteCategory(categories)(other);

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect((await categories.getCategories()).dataOrNull, hasLength(8));
  });

  test('deleting an expense removes it from its month', () async {
    final created = (await expenses.addExpense(
      amount: 9,
      categoryId: 'cat_work',
      date: DateTime(2026, 8, 6),
    )).dataOrNull!;

    await expenses.deleteExpense(created.id);

    expect(
      (await expenses.getExpensesForMonth(const Month(2026, 8))).dataOrNull,
      isEmpty,
    );
  });

  test('ranks categories by how often they are used', () async {
    for (var i = 0; i < 3; i++) {
      await expenses.addExpense(
        amount: 5,
        categoryId: 'cat_food',
        date: DateTime(2026, 8, 2 + i),
      );
    }
    await expenses.addExpense(
      amount: 5,
      categoryId: 'cat_bills',
      date: DateTime(2026, 8, 9),
    );

    final usage = (await expenses.getCategoryUsage()).dataOrNull!;

    expect(usage.map((row) => row.categoryId), ['cat_food', 'cat_bills']);
    expect(usage.first.count, 3);
    expect(usage.last.count, 1);
  });

  test('reports no usage before anything is recorded', () async {
    expect((await expenses.getCategoryUsage()).dataOrNull, isEmpty);
  });

  test('a renamed built-in category stops being a built-in', () async {
    final food = (await categories.getCategories()).dataOrNull!.firstWhere(
      (category) => category.id == 'cat_food',
    );

    await categories.updateCategory(
      food.copyWith(name: 'Groceries', isDefault: false),
    );

    final stored = (await categories.getCategories()).dataOrNull!.firstWhere(
      (category) => category.id == 'cat_food',
    );
    expect(stored.name, 'Groceries');
    expect(stored.isDefault, isFalse);
  });

  test('reports a failure instead of throwing on a bad category', () async {
    final result = await expenses.addExpense(
      amount: 5,
      categoryId: 'does_not_exist',
      date: DateTime(2026, 8, 6),
    );

    expect(result, isA<ResultFailure<dynamic>>());
    expect(result.failureOrNull, isA<DatabaseFailure>());
  });
}
