import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/features/analyses/domain/usecases/get_month_analysis.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';

import '../presentation/fakes.dart';

void main() {
  late FakeExpenseRepository expenses;
  late GetMonthAnalysis analyse;

  const august = Month(2026, 8);

  setUp(() {
    expenses = FakeExpenseRepository(FakeCategoryRepository());
    analyse = GetMonthAnalysis(expenses);
  });

  Future<void> spend(
    double amount,
    DateTime date, [
    String category = 'cat_food',
  ]) => expenses.addExpense(amount: amount, categoryId: category, date: date);

  test(
    'splits the month by category and compares with the month before',
    () async {
      await spend(30, DateTime(2026, 8, 3));
      await spend(10, DateTime(2026, 8, 3), 'cat_bills');
      await spend(40, DateTime(2026, 7, 20));

      final analysis = (await analyse(
        august,
        now: DateTime(2026, 9, 1),
      )).dataOrNull!;

      expect(analysis.total, 40);
      expect(analysis.breakdown.first.category.id, 'cat_food');
      expect(analysis.breakdown.first.share, 0.75);
      expect(analysis.previousTotal, 40);
      expect(analysis.change, 0);
    },
  );

  test('has no comparison when last month had no spending', () async {
    await spend(30, DateTime(2026, 8, 3));

    final analysis = (await analyse(
      august,
      now: DateTime(2026, 9, 1),
    )).dataOrNull!;

    expect(analysis.change, isNull);
  });

  test('averages over days so far this month, every day of a past one', () {
    expect(GetMonthAnalysis.daysCounted(august, DateTime(2026, 8, 10)), 10);
    expect(GetMonthAnalysis.daysCounted(august, DateTime(2026, 9, 1)), 31);
    expect(
      GetMonthAnalysis.daysCounted(const Month(2028, 2), DateTime(2028, 3, 1)),
      29,
    );
  });

  test('finds the most expensive day by adding up each day', () async {
    await spend(30, DateTime(2026, 8, 3, 9));
    await spend(25, DateTime(2026, 8, 5));
    await spend(20, DateTime(2026, 8, 5, 18));

    final analysis = (await analyse(
      august,
      now: DateTime(2026, 8, 10),
    )).dataOrNull!;

    expect(analysis.topDay!.date, DateTime(2026, 8, 5));
    expect(analysis.topDay!.total, 45);
    expect(analysis.dailyAverage, 7.5);
  });

  test('the trend always covers six months, empty ones as zero', () async {
    await spend(12, DateTime(2026, 6, 1));
    await spend(30, DateTime(2026, 8, 3));

    final trend = (await analyse(
      august,
      now: DateTime(2026, 9, 1),
    )).dataOrNull!.trend;

    expect(trend.map((m) => m.month), [
      const Month(2026, 3),
      const Month(2026, 4),
      const Month(2026, 5),
      const Month(2026, 6),
      const Month(2026, 7),
      august,
    ]);
    expect(trend.map((m) => m.total), [0, 0, 0, 12, 0, 30]);
  });
}
