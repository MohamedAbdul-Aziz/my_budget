import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/analyses/domain/usecases/get_month_analysis.dart';
import 'package:my_budget/features/assistant/domain/entities/spending_summary.dart';
import 'package:my_budget/features/assistant/domain/usecases/build_spending_summary.dart';
import 'package:my_budget/features/budgets/domain/usecases/get_budget_status.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';

import '../presentation/fakes.dart';

/// Fails every month read, the way a broken database would.
class _BrokenExpenses extends FakeExpenseRepository {
  _BrokenExpenses(super.categories);

  @override
  Future<ApiResult<List<Expense>>> getTransactionsForMonth(Month month) async =>
      const ResultFailure(DatabaseFailure('disk I/O error'));
}

void main() {
  late FakeCategoryRepository categories;
  late FakeExpenseRepository expenses;
  late FakeBudgetRepository budgets;
  late BuildSpendingSummary build;

  final now = DateTime(2026, 10, 10);
  String labelOf(ExpenseCategory category) => 'L:${category.name}';

  BuildSpendingSummary buildOver(FakeExpenseRepository expenses) =>
      BuildSpendingSummary(
        getMonthAnalysis: GetMonthAnalysis(expenses),
        getBudgetStatus: GetBudgetStatus(
          budgetRepository: budgets,
          expenseRepository: expenses,
          categoryRepository: categories,
        ),
      );

  setUp(() {
    categories = FakeCategoryRepository();
    expenses = FakeExpenseRepository(categories);
    budgets = FakeBudgetRepository();
    build = buildOver(expenses);
  });

  Future<void> add(
    double amount,
    DateTime date, {
    String category = 'cat_food',
    String? description,
  }) => expenses.addExpense(
    amount: amount,
    categoryId: category,
    date: date,
    description: description,
  );

  test('covers three explicit months, newest first, with the analyses '
      'figures', () async {
    await add(30, DateTime(2026, 10, 2));
    await add(10, DateTime(2026, 10, 4), category: 'cat_bills');
    await add(500, DateTime(2026, 10, 1), category: 'cat_salary');
    await add(40, DateTime(2026, 9, 12));
    await add(25, DateTime(2026, 8, 3));
    budgets
      ..monthly = 100
      ..byCategory['cat_food'] = 50;

    final summary = (await build(
      labelOf: labelOf,
      currency: r'$',
      now: now,
    )).dataOrNull!;

    expect(summary.currency, r'$');
    expect(summary.generatedOn, '2026-10-10');
    expect(
      [for (final m in summary.months) m.period],
      ['2026-10', '2026-09', '2026-08'],
    );

    final october = summary.months.first;
    final analysis = (await GetMonthAnalysis(expenses)(
      const Month(2026, 10),
      now: now,
    )).dataOrNull!;
    expect(october.isCurrent, isTrue);
    expect(october.spent, analysis.total);
    expect(october.spent, 40);
    expect(october.income, 500);
    expect(october.expenseCount, 2);
    expect(october.daysCounted, 10);
    expect(october.dailyAverage, analysis.dailyAverage);
    expect(october.previousMonthSpent, 40);
    expect(october.changeVsPrevious, 0);
    expect(october.projectedMonthEnd, analysis.projectedTotal(now));
    expect(october.topDayDate, '2026-10-02');
    expect(october.spendingByCategory.first.name, 'L:Food');
    expect(october.spendingByCategory.first.share, 0.75);
    expect(october.incomeByCategory.single.name, 'L:Salary');

    final september = summary.months[1];
    expect(september.isCurrent, isFalse);
    expect(september.projectedMonthEnd, isNull);
    expect(september.daysCounted, 30);

    expect(summary.budget.period, '2026-10');
    expect(summary.budget.monthlyLimit, 100);
    expect(summary.budget.spent, 40);
    expect(summary.budget.categories.single.name, 'L:Food');
    expect(summary.budget.categories.single.limit, 50);

    expect(summary.trend, hasLength(GetMonthAnalysis.trendLength));
    expect(summary.trend.last, ('2026-10', 40.0));
  });

  test('sends no descriptions, ids or single transactions', () async {
    await add(
      999.99,
      DateTime(2026, 10, 3),
      description: 'Dinner with Sara at Nile Bistro',
    );

    final summary = (await build(
      labelOf: labelOf,
      currency: 'EGP',
      now: now,
    )).dataOrNull!;
    final encoded = jsonEncode(summary.toJson());

    expect(encoded, isNot(contains('Sara')));
    expect(encoded, isNot(contains('Bistro')));
    expect(encoded, isNot(contains('exp_')));
    expect(encoded, isNot(contains('cat_')));
    expect(encoded, isNot(contains('largestExpense')));
    expect(encoded, isNot(contains('description')));
    // The total is there, as an aggregate.
    expect(encoded, contains('999.99'));
  });

  test('a fresh summary reflects data added since the last one', () async {
    await add(10, DateTime(2026, 10, 3));
    final before = (await build(
      labelOf: labelOf,
      currency: '',
      now: now,
    )).dataOrNull!;
    await add(15, DateTime(2026, 10, 4));
    final after = (await build(
      labelOf: labelOf,
      currency: '',
      now: now,
    )).dataOrNull!;

    expect(before.months.first.spent, 10);
    expect(after.months.first.spent, 25);
  });

  test('passes a database failure on', () async {
    build = buildOver(_BrokenExpenses(categories));

    final result = await build(labelOf: labelOf, currency: '', now: now);

    expect(result.failureOrNull, isA<DatabaseFailure>());
  });

  group('size limit', () {
    SpendingSummary withCategories(int count, {int nameLength = 80}) {
      final share = 1 / count;
      return SpendingSummary(
        currency: r'$',
        generatedOn: '2026-10-10',
        months: [
          SummaryMonth(
            period: '2026-10',
            isCurrent: true,
            daysCounted: 10,
            spent: count * 10,
            income: 0,
            expenseCount: count,
            dailyAverage: count.toDouble(),
            previousMonthSpent: 0,
            spendingByCategory: [
              for (var i = 0; i < count; i++)
                SummaryCategory(
                  name: '$i'.padRight(nameLength, 'x'),
                  total: 10,
                  share: share,
                ),
            ],
            incomeByCategory: const [],
          ),
        ],
        budget: const SummaryBudget(
          period: '2026-10',
          spent: 0,
          categories: [],
        ),
        trend: const [],
      );
    }

    test('keeps a small summary as it is', () {
      final small = withCategories(3);
      expect(BuildSpendingSummary.fitted(small).dataOrNull, small);
    });

    test('merges the smaller categories until it fits, keeping the total', () {
      final big = withCategories(120);
      expect(
        BuildSpendingSummary.sizeOf(big),
        greaterThan(BuildSpendingSummary.maxBytes),
      );

      final fitted = BuildSpendingSummary.fitted(big).dataOrNull!;
      final list = fitted.months.single.spendingByCategory;

      expect(
        BuildSpendingSummary.sizeOf(fitted),
        lessThanOrEqualTo(BuildSpendingSummary.maxBytes),
      );
      expect(list, hasLength(BuildSpendingSummary.categoryCaps.first));
      expect(list.last.name, BuildSpendingSummary.othersName);
      expect(list.fold<double>(0, (sum, c) => sum + c.total), 1200);
    });

    test('fails when even the shortest lists do not fit', () {
      final huge = withCategories(6, nameLength: 3000);

      final result = BuildSpendingSummary.fitted(huge);

      expect(result.failureOrNull?.code, FailureCode.summaryTooLarge);
    });
  });
}
