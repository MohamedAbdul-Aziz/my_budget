import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/features/analyses/domain/usecases/compare_months.dart';
import 'package:my_budget/features/analyses/presentation/cubit/compare_months_cubit.dart';
import 'package:my_budget/features/analyses/presentation/cubit/compare_months_state.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/domain/usecases/get_monthly_summaries.dart';

import 'fakes.dart';

void main() {
  late FakeExpenseRepository expenses;
  late CompareMonthsCubit cubit;

  const august = Month(2026, 8);
  const july = Month(2026, 7);
  const may = Month(2026, 5);

  setUp(() async {
    expenses = FakeExpenseRepository(FakeCategoryRepository());
    cubit = CompareMonthsCubit(
      compareMonths: CompareMonths(expenses),
      getMonthlySummaries: GetMonthlySummaries(expenses),
    );
    for (final (amount, month) in [(80.0, august), (50.0, july), (20.0, may)]) {
      await expenses.addExpense(
        amount: amount,
        categoryId: 'cat_food',
        date: month.start,
      );
    }
  });

  tearDown(() => cubit.close());

  (Month, Month) sides() {
    final state = cubit.state as CompareMonthsReady;
    return (state.comparison.first, state.comparison.second);
  }

  test('starts with the page month against the one before', () async {
    await cubit.load(august);

    expect(sides(), (august, july));
    expect((cubit.state as CompareMonthsReady).choices, [august, july, may]);
  });

  test('either side can be picked', () async {
    await cubit.load(august);

    await cubit.pick(first: may);
    expect(sides(), (may, july));

    await cubit.pick(second: august);
    expect(sides(), (may, august));
  });

  test('picking the other side\'s month swaps the two', () async {
    await cubit.load(august);

    await cubit.pick(first: july);
    expect(sides(), (july, august));

    await cubit.pick(second: july);
    expect(sides(), (august, july));
  });

  test('a refresh keeps the picks; a new page month resets them', () async {
    await cubit.load(august);
    await cubit.pick(first: may);

    await cubit.load(august);
    expect(sides(), (may, july));

    await cubit.load(july);
    expect(sides(), (july, const Month(2026, 6)));
  });
}
