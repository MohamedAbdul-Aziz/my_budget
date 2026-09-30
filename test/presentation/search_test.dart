import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/expenses/presentation/cubit/search_cubit.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

  Future<AppHarness> bootWithHistory(WidgetTester tester) => bootApp(
    tester,
    before: (harness) => harness.expenses
      ..addExpense(
        amount: 12.5,
        categoryId: 'cat_food',
        date: DateTime(2026, 6, 3),
        description: 'Lunch with Sara',
      )
      ..addExpense(
        amount: 80,
        categoryId: 'cat_bills',
        date: DateTime(2026, 7, 15),
        description: 'Internet',
      )
      ..addExpense(
        amount: 3000,
        categoryId: 'cat_salary',
        date: DateTime(2026, 7, 28),
        description: 'July salary',
      )
      ..addExpense(
        amount: 9,
        categoryId: 'cat_food',
        date: DateTime(2026, 8, 2),
        description: 'Coffee',
      ),
  );

  Future<void> openSearch(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField).first, text);
    // Searching waits for typing to pause.
    await tester.pump(SearchCubit.typingPause);
    await tester.pumpAndSettle();
  }

  testWidgets('finds a note from any month', (tester) async {
    await bootWithHistory(tester);
    await openSearch(tester);
    expect(
      find.textContaining('Find any transaction by its note'),
      findsOneWidget,
    );

    await type(tester, 'lunch');

    expect(find.text('Lunch with Sara'), findsOneWidget);
    expect(find.textContaining('1 transaction'), findsOneWidget);
    expect(find.text('Internet'), findsNothing);
  });

  testWidgets('says when nothing matches', (tester) async {
    await bootWithHistory(tester);
    await openSearch(tester);

    await type(tester, 'holiday');

    expect(find.text('No transactions match'), findsOneWidget);
  });

  testWidgets('filters by type without any text', (tester) async {
    await bootWithHistory(tester);
    await openSearch(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Income'));
    await tester.pumpAndSettle();

    expect(find.text('July salary'), findsOneWidget);
    expect(find.text('Coffee'), findsNothing);
    expect(find.byTooltip('Clear filters'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('July salary'), findsNothing);
    expect(
      find.textContaining('Find any transaction by its note'),
      findsOneWidget,
    );
  });

  testWidgets('filters by the categories ticked in the sheet', (tester) async {
    await bootWithHistory(tester);
    await openSearch(tester);

    await tester.tap(find.text('Any category'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Food'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    expect(find.text('Coffee'), findsOneWidget);
    expect(find.text('Lunch with Sara'), findsOneWidget);
    expect(find.text('Internet'), findsNothing);
    // The chip names what it filters by.
    expect(find.widgetWithText(InputChip, 'Food'), findsOneWidget);
  });

  testWidgets('opens a result for editing', (tester) async {
    await bootWithHistory(tester);
    await openSearch(tester);
    await type(tester, 'internet');

    await tester.tap(find.text('Internet'));
    await tester.pumpAndSettle();

    expect(find.text('Edit expense'), findsOneWidget);
  });
}
