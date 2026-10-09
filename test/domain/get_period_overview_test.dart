import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/domain/entities/monthly_summary.dart';
import 'package:my_budget/features/expenses/domain/entities/period.dart';
import 'package:my_budget/features/expenses/domain/repositories/expense_repository.dart';
import 'package:my_budget/features/expenses/domain/usecases/get_period_overview.dart';

import '../presentation/fakes.dart';

const _food = ExpenseCategory(
  id: 'cat_food',
  name: 'Food',
  iconName: 'restaurant',
  colorValue: 0xFFEF6C00,
);
const _bills = ExpenseCategory(
  id: 'cat_bills',
  name: 'Bills',
  iconName: 'receipt_long',
  colorValue: 0xFF6D4C41,
);

const _salary = ExpenseCategory(
  id: 'cat_salary',
  name: 'Salary',
  iconName: 'payments',
  colorValue: 0xFF2E7D32,
  type: TransactionType.income,
);

Expense _expense(double amount, ExpenseCategory category) => Expense(
  id: 'exp_$amount${category.id}',
  amount: amount,
  category: category,
  date: DateTime(2026, 8, 4),
  createdAt: DateTime(2026, 8, 4),
);

class _StubRepository implements ExpenseRepository {
  _StubRepository(this.result);

  final ApiResult<List<Expense>> result;

  @override
  Future<ApiResult<List<Expense>>> getTransactionsForMonth(Month month) async =>
      result;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<ApiResult<List<MonthlySummary>>> getMonthlySummaries() async =>
      const Success([]);

  @override
  Future<ApiResult<Expense>> addExpense({
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) => throw UnimplementedError();

  @override
  Future<ApiResult<Expense>> updateExpense({
    required String id,
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) => throw UnimplementedError();

  @override
  Future<ApiResult<void>> deleteExpense(String id) =>
      throw UnimplementedError();
}

void main() {
  const month = Month(2026, 8);

  test('totals the month and ranks categories by spend', () async {
    final useCase = GetPeriodOverview(
      _StubRepository(
        Success([
          _expense(30, _food),
          _expense(10, _food),
          _expense(60, _bills),
        ]),
      ),
    );

    final result = await useCase(Period.ofMonth(month));
    final overview = result.dataOrNull!;

    expect(overview.spent, 100);
    expect(overview.transactions, hasLength(3));
    expect(overview.breakdown.first.category, _bills);
    expect(overview.breakdown.first.share, 0.6);
    expect(overview.breakdown.last.category, _food);
    expect(overview.breakdown.last.total, 40);
  });

  test('an empty month has a zero total and no breakdown', () async {
    final useCase = GetPeriodOverview(_StubRepository(const Success([])));

    final overview = (await useCase(Period.ofMonth(month))).dataOrNull!;

    expect(overview.isEmpty, isTrue);
    expect(overview.spent, 0);
    expect(overview.breakdown, isEmpty);
  });

  test('income is counted apart from spending', () async {
    final useCase = GetPeriodOverview(
      _StubRepository(
        Success([
          _expense(2000, _salary),
          _expense(300, _food),
          _expense(200, _bills),
        ]),
      ),
    );

    final overview = (await useCase(Period.ofMonth(month))).dataOrNull!;

    expect(overview.transactions, hasLength(3));
    expect(overview.income, 2000);
    expect(overview.spent, 500);
    expect(overview.net, 1500);
    expect(overview.savingsRate, 0.75);
    // Income is not somewhere the money went.
    expect(overview.breakdown.map((slice) => slice.category), [_food, _bills]);
    expect(overview.breakdown.first.share, 0.6);
  });

  test('spending more than came in gives a negative savings rate', () async {
    final useCase = GetPeriodOverview(
      _StubRepository(Success([_expense(400, _salary), _expense(500, _food)])),
    );

    final overview = (await useCase(Period.ofMonth(month))).dataOrNull!;

    expect(overview.net, -100);
    expect(overview.savingsRate, -0.25);
  });

  test('there is no savings rate without income', () async {
    final useCase = GetPeriodOverview(
      _StubRepository(Success([_expense(40, _food)])),
    );

    final overview = (await useCase(Period.ofMonth(month))).dataOrNull!;

    expect(overview.income, 0);
    expect(overview.net, -40);
    expect(overview.savingsRate, isNull);
  });

  test('passes a repository failure straight through', () async {
    final useCase = GetPeriodOverview(
      _StubRepository(const ResultFailure(DatabaseFailure('disk full'))),
    );

    final result = await useCase(Period.ofMonth(month));

    expect(result.failureOrNull, isA<DatabaseFailure>());
  });

  group('any period', () {
    test('a day or a week reads its dates; a month its month', () async {
      final expenses = FakeExpenseRepository(FakeCategoryRepository());
      final overview = GetPeriodOverview(expenses);
      for (final day in [3, 9, 10, 31]) {
        await expenses.addExpense(
          amount: day.toDouble(),
          categoryId: 'cat_food',
          date: DateTime(2026, 8, day, 12),
        );
      }

      Future<List<double>> amounts(Period period) async => [
        for (final e in (await overview(period)).dataOrNull!.transactions)
          e.amount,
      ];

      expect(await amounts(Period(PeriodKind.day, DateTime(2026, 8, 9))), [9]);
      // Monday 3 to Sunday 9 August.
      expect(await amounts(Period(PeriodKind.week, DateTime(2026, 8, 5))), [
        9,
        3,
      ]);
      expect(await amounts(Period(PeriodKind.month, DateTime(2026, 8, 20))), [
        31,
        10,
        9,
        3,
      ]);
      final year = (await overview(
        Period(PeriodKind.year, DateTime(2026, 1, 1)),
      )).dataOrNull!;
      expect(year.spent, 53);
      expect(year.period.kind, PeriodKind.year);
    });
  });
}
