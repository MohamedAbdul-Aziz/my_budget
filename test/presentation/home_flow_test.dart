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
    expect(find.text('1 expense'), findsOneWidget);
    expect(find.text('Food'), findsWidgets);
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
