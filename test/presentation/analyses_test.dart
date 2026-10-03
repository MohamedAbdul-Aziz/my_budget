import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

  Future<void> openAnalyses(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();
  }

  /// The page itself, not the row of questions that also scrolls.
  Finder page() => find
      .ancestor(
        of: find.byType(ChoiceChip).first,
        matching: find.byType(Scrollable),
      )
      .last;

  testWidgets('the analyses tab shows an empty month plainly', (tester) async {
    await bootApp(tester);
    await openAnalyses(tester);

    expect(find.text('Compared with last month'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Nothing spent this month yet.'),
      200,
      scrollable: page(),
    );
    expect(find.text('Nothing spent this month yet.'), findsOneWidget);
    expect(find.text('No data last month'), findsOneWidget);
  });

  testWidgets('an expense added on Home shows up in Analyses', (tester) async {
    await bootApp(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '25');
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();

    await openAnalyses(tester);
    await tester.scrollUntilVisible(
      find.text('Spending by category'),
      200,
      scrollable: page(),
    );

    expect(find.text('Spending by category'), findsOneWidget);
    expect(find.text('Nothing spent this month yet.'), findsNothing);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('Food'), findsWidgets);
  });

  testWidgets('the tabs and page speak Arabic', (tester) async {
    await bootApp(tester, localeName: 'ar_EG');

    expect(find.text('الرئيسية'), findsOneWidget);
    await openAnalyses(tester);
    expect(find.text('مقارنة بالشهر الماضي'), findsOneWidget);
  });
}
