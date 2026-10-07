import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/analyses/presentation/cubit/analyses_cubit.dart';
import 'package:my_budget/features/budgets/presentation/cubit/budget_cubit.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

  final month = Month.current();
  final firstDay = month.start;

  Future<AppHarness> bootWithSpending(WidgetTester tester) async {
    final harness = await bootApp(tester);
    final expenses = harness.expenses;
    await expenses.addExpense(
      amount: 30,
      categoryId: 'cat_food',
      date: firstDay,
    );
    await expenses.addExpense(
      amount: 50,
      categoryId: 'cat_bills',
      date: firstDay,
    );
    await expenses.addExpense(
      amount: 200,
      categoryId: 'cat_salary',
      date: firstDay,
    );
    await expenses.addExpense(
      amount: 20,
      categoryId: 'cat_food',
      date: month.previous.start,
    );
    await sl<AnalysesCubit>().load(month);
    await sl<BudgetCubit>().load(month);
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();
    return harness;
  }

  Future<void> ask(WidgetTester tester, String chip) async {
    final finder = find.widgetWithText(ChoiceChip, chip);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('answers a question when its chip is tapped', (tester) async {
    await bootWithSpending(tester);

    expect(find.text('Ask about your spending'), findsOneWidget);
    expect(find.text('Tap a question to see the answer.'), findsOneWidget);

    await ask(tester, 'Top category');
    expect(
      find.text(r'Most went to Bills: $50 (63% of the month).'),
      findsOneWidget,
    );
    // Each slice of the answer's ring shows its share.
    expect(find.text('63%'), findsWidgets);
    expect(find.text('38%'), findsWidgets);

    await ask(tester, 'Did I save?');
    expect(
      find.text(r'You saved $120 of the $200 you earned.'),
      findsOneWidget,
    );

    await ask(tester, 'How many expenses');
    expect(find.textContaining('You logged 2 expenses'), findsOneWidget);

    await ask(tester, 'Budget left');
    expect(find.text('You have not set a monthly budget yet.'), findsOneWidget);
  });

  testWidgets('compares with last month and draws both', (tester) async {
    await bootWithSpending(tester);

    await ask(tester, 'Compare months');

    expect(find.textContaining(r'You spent $60 more in'), findsOneWidget);
    expect(find.textContaining('Biggest rise: Bills'), findsOneWidget);
    expect(find.byType(DropdownButton<Month>), findsNWidgets(2));
  });

  testWidgets('either month can be changed', (tester) async {
    await bootWithSpending(tester);
    await ask(tester, 'Compare months');

    // Putting last month first swaps the two sides.
    await tester.tap(find.byType(DropdownButton<Month>).first);
    await tester.pumpAndSettle();
    final formats = sl<SettingsCubit>().state.formats;
    await tester.tap(find.text(formats.monthLabel(month.previous)).last);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'You spent \$60 less in ${formats.monthLabel(month.previous)} '
        'than in ${formats.monthLabel(month)} (−75%).',
      ),
      findsOneWidget,
    );
  });

  testWidgets('the questions speak Arabic', (tester) async {
    await bootApp(tester, localeName: 'ar_EG');
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();

    expect(find.text('اسأل عن مصروفاتك'), findsOneWidget);
    await ask(tester, 'أعلى فئة');
    // Once in the answer and once in the empty category card.
    expect(find.text('لا مصروفات في هذا الشهر بعد.'), findsNWidgets(2));
  });
}
