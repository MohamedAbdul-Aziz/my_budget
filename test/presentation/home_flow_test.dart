import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/utils/app_formats.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

  testWidgets('opens on the current month with an empty state', (tester) async {
    await bootApp(tester);

    final formats = AppFormats(localeName: 'en_US');
    expect(find.text(formats.monthLabel(Month.current())), findsOneWidget);
    expect(find.text('Nothing recorded yet'), findsOneWidget);
    expect(find.widgetWithText(FloatingActionButton, 'Add'), findsOneWidget);
  });

  testWidgets('adds an expense and shows it in the month total', (
    tester,
  ) async {
    await bootApp(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();

    // The category is preselected and the date defaults to today, so an
    // amount is the only required input.
    expect(find.text('New expense'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Today'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '25');
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();

    // Back on the home screen with the expense counted.
    expect(find.text('New expense'), findsNothing);
    expect(find.text(r'$25'), findsOneWidget);
    expect(find.text('1 transaction'), findsOneWidget);
    await scrollHomeTo(tester, find.text('Food'));
    expect(find.text('Food'), findsWidgets);
  });

  testWidgets('records income from the toggle and shows the net balance', (
    tester,
  ) async {
    await bootApp(tester);

    // Spending first: nothing to measure a savings rate against yet.
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '500');
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    expect(find.text('Add income to see your savings rate'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();

    // The form turns into an income form with only income categories.
    expect(find.text('New income'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Salary'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Food'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '2000');
    await tester.tap(find.text('Add income'));
    await tester.pumpAndSettle();

    expect(find.text('Net balance'), findsOneWidget);
    expect(find.text(r'$1,500'), findsOneWidget);
    expect(find.text('Total income'), findsOneWidget);
    expect(find.text(r'$2,000'), findsOneWidget);
    expect(find.text('Total expenses'), findsOneWidget);
    expect(find.text(r'$500'), findsOneWidget);
    expect(find.text('Savings rate'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('2 transactions'), findsOneWidget);
    // Income is listed with a plus.
    await scrollHomeTo(tester, find.text(r'+$2,000.00'));
    expect(find.text(r'+$2,000.00'), findsOneWidget);
  });

  testWidgets('switching back to expense keeps the category picked before', (
    tester,
  ) async {
    await bootApp(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Bills'));
    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense'));
    await tester.pumpAndSettle();

    final bills = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Bills'),
    );
    expect(bills.selected, isTrue);
    expect(find.text('New expense'), findsOneWidget);
  });

  testWidgets('rejects an empty amount', (tester) async {
    await bootApp(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid amount.'), findsOneWidget);
    expect(find.text('New expense'), findsOneWidget);
  });
}
