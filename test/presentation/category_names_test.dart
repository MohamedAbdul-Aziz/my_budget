import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';

import 'app_harness.dart';

/// The category sheet refuses a name already in use and stays open, so the
/// user can change it.
void main() {
  tearDown(() => sl.reset());

  const taken = 'You already have a category with this name.';

  Future<void> openCategories(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Categories'));
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester, String label) async {
    await tester.tap(
      find.ancestor(
        of: find.text(label),
        matching: find.byWidgetPredicate((widget) => widget is FilledButton),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a new category cannot take a name already used', (tester) async {
    final harness = await bootApp(tester);
    final before = harness.categories.categories.length;
    await openCategories(tester);
    await tester.tap(find.widgetWithText(FloatingActionButton, 'New category'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '  food ');
    await save(tester, 'Add category');

    expect(find.text(taken), findsOneWidget);
    expect(find.text('New category'), findsWidgets); // still open
    expect(harness.categories.categories, hasLength(before));

    await tester.enterText(find.byType(TextField), 'Coffee');
    await save(tester, 'Add category');

    expect(find.text(taken), findsNothing);
    expect(harness.categories.categories, hasLength(before + 1));
  });

  testWidgets('renaming cannot take another category\'s name', (tester) async {
    await bootApp(tester);
    await openCategories(tester);
    await tester.tap(find.text('Food').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'bills');
    await save(tester, 'Save changes');
    expect(find.text(taken), findsOneWidget);

    // Its own name, in another case, is fine.
    await tester.enterText(find.byType(TextField), 'FOOD');
    await save(tester, 'Save changes');
    expect(find.text(taken), findsNothing);
    expect(find.text('Edit category'), findsNothing);
  });

  testWidgets('a built-in name is taken in the app\'s language too', (
    tester,
  ) async {
    await bootApp(tester, localeName: 'ar_EG');
    await tester.tap(find.byTooltip('الفئات'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'طعام');
    await tester.tap(
      find.byWidgetPredicate((widget) => widget is FilledButton).last,
    );
    await tester.pumpAndSettle();

    expect(find.text('لديك فئة بهذا الاسم بالفعل.'), findsOneWidget);
  });
}
