import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/domain/entities/monthly_summary.dart';
import 'package:my_budget/features/expenses/domain/repositories/expense_repository.dart';
import 'package:my_budget/features/expenses/domain/usecases/get_month_overview.dart';

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
  Future<ApiResult<List<Expense>>> getExpensesForMonth(Month month) async =>
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
    final useCase = GetMonthOverview(
      _StubRepository(
        Success([
          _expense(30, _food),
          _expense(10, _food),
          _expense(60, _bills),
        ]),
      ),
    );

    final result = await useCase(month);
    final overview = result.dataOrNull!;

    expect(overview.total, 100);
    expect(overview.expenses, hasLength(3));
    expect(overview.breakdown.first.category, _bills);
    expect(overview.breakdown.first.share, 0.6);
    expect(overview.breakdown.last.category, _food);
    expect(overview.breakdown.last.total, 40);
  });

  test('an empty month has a zero total and no breakdown', () async {
    final useCase = GetMonthOverview(_StubRepository(const Success([])));

    final overview = (await useCase(month)).dataOrNull!;

    expect(overview.isEmpty, isTrue);
    expect(overview.total, 0);
    expect(overview.breakdown, isEmpty);
  });

  test('passes a repository failure straight through', () async {
    final useCase = GetMonthOverview(
      _StubRepository(const ResultFailure(DatabaseFailure('disk full'))),
    );

    final result = await useCase(month);

    expect(result.failureOrNull, isA<DatabaseFailure>());
  });
}
