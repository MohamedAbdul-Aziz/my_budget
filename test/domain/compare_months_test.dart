import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/features/analyses/domain/usecases/compare_months.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';

import '../presentation/fakes.dart';

void main() {
  late FakeExpenseRepository expenses;
  late CompareMonths compare;

  const august = Month(2026, 8);
  const may = Month(2026, 5);

  setUp(() {
    expenses = FakeExpenseRepository(FakeCategoryRepository());
    compare = CompareMonths(expenses);
  });

  Future<void> spend(double amount, DateTime date, String category) =>
      expenses.addExpense(amount: amount, categoryId: category, date: date);

  test('lines up every category spent on in either month', () async {
    await spend(80, DateTime(2026, 8, 3), 'cat_food');
    await spend(5, DateTime(2026, 8, 4), 'cat_other');
    await spend(30, DateTime(2026, 5, 3), 'cat_food');
    await spend(40, DateTime(2026, 5, 9), 'cat_bills');
    await spend(900, DateTime(2026, 8, 1), 'cat_salary');

    final comparison = (await compare(august, may)).dataOrNull!;

    expect(comparison.firstTotal, 85);
    expect(comparison.secondTotal, 70);
    expect(comparison.difference, 15);
    expect(comparison.rows.map((row) => row.category.id), [
      'cat_food',
      'cat_bills',
      'cat_other',
    ]);
    expect(comparison.rows[1].first, 0);
    expect(comparison.rows[1].second, 40);
    expect(comparison.biggestRise!.category.id, 'cat_food');
    expect(comparison.biggestDrop!.category.id, 'cat_bills');
  });

  test('has no change to report against a month with no spending', () async {
    await spend(20, DateTime(2026, 8, 3), 'cat_food');

    final comparison = (await compare(august, may)).dataOrNull!;

    expect(comparison.change, isNull);
    expect(comparison.isEmpty, isFalse);
    expect(comparison.biggestDrop, isNull);
  });
}
