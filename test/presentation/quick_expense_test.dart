import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/utils/app_formats.dart';
import 'package:my_budget/features/quick_expense/presentation/quick_add_launch.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

  group('launch route', () {
    test('carries the tapped category through from the widget', () {
      expect(
        QuickAddLaunch.tryParse('/quick-add?category=cat_food')?.categoryId,
        'cat_food',
      );
      expect(
        QuickAddLaunch.tryParse('/quick-add?category=cat_transport')?.categoryId,
        'cat_transport',
      );
    });

    test('handles the Add button, which names no category', () {
      final launch = QuickAddLaunch.tryParse('/quick-add');
      expect(launch, isNotNull);
      expect(launch!.categoryId, isNull);
    });

    test('leaves a normal app launch alone', () {
      expect(QuickAddLaunch.tryParse('/'), isNull);
      expect(QuickAddLaunch.tryParse(null), isNull);
      expect(QuickAddLaunch.tryParse('/settings'), isNull);
    });
  });

  group('quick add from the widget', () {
    testWidgets('opens on the tapped category, not the home screen', (
      tester,
    ) async {
      await bootQuickAdd(tester, categoryId: 'cat_bills');

      // The category the user pressed is already chosen.
      expect(find.text('Quick expense'), findsOneWidget);
      expect(
        tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Bills')).selected,
        isTrue,
      );

      // None of the app's home screen is built.
      expect(find.text('Nothing recorded yet'), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(AppBar), findsNothing);
    });

    testWidgets('saves the amount against that category and closes', (
      tester,
    ) async {
      final platformCalls = recordPlatformCalls(tester);
      final harness = await bootQuickAdd(tester, categoryId: 'cat_bills');

      await tester.enterText(find.byType(TextField), '150');
      await tester.tap(find.text('Add expense'));
      await tester.pumpAndSettle();

      final saved = harness.expenses.expenses.single;
      expect(saved.amount, 150);
      expect(saved.category.id, 'cat_bills');
      expect(saved.description, isNull);
      expect(AppFormats.isSameDay(saved.date, DateTime.now()), isTrue);

      // The widget is redrawn before the dialog goes away.
      expect(harness.widget.latest!.total, r'$150');
      expect(platformCalls, contains('SystemNavigator.pop'));
    });

    testWidgets('falls back to a category when Add was tapped', (tester) async {
      await bootQuickAdd(tester);

      expect(
        tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Food')).selected,
        isTrue,
      );
    });

    testWidgets('lets the user switch category before saving', (tester) async {
      final harness = await bootQuickAdd(tester, categoryId: 'cat_food');

      await tester.tap(find.widgetWithText(ChoiceChip, 'Bills'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '20');
      await tester.tap(find.text('Add expense'));
      await tester.pumpAndSettle();

      expect(harness.expenses.expenses.single.category.id, 'cat_bills');
    });

    testWidgets('rejects an empty amount instead of saving', (tester) async {
      final harness = await bootQuickAdd(tester, categoryId: 'cat_food');

      await tester.tap(find.text('Add expense'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid amount.'), findsOneWidget);
      expect(harness.expenses.expenses, isEmpty);
    });

    testWidgets('closes without saving when dismissed', (tester) async {
      final platformCalls = recordPlatformCalls(tester);
      final harness = await bootQuickAdd(tester, categoryId: 'cat_food');

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(harness.expenses.expenses, isEmpty);
      expect(platformCalls, contains('SystemNavigator.pop'));
    });

    testWidgets('speaks the language the app is set to', (tester) async {
      await bootQuickAdd(tester, localeName: 'ar');

      expect(find.text('مصروف سريع'), findsOneWidget);
      expect(find.text('إضافة مصروف'), findsOneWidget);
    });
  });

  group('home screen widget contents', () {
    testWidgets('are published as soon as the app starts', (tester) async {
      final harness = await bootApp(tester);

      final snapshot = harness.widget.latest;
      expect(snapshot, isNotNull);
      expect(snapshot!.title, 'Quick expense');
      expect(snapshot.addLabel, 'Add expense');
      expect(snapshot.total, r'$0');
      // Nothing recorded yet, so the shortcuts fall back to the first
      // categories plus the catch-all.
      expect(snapshot.categories.map((shortcut) => shortcut.name), [
        'Food',
        'Bills',
        'Other',
      ]);
    });

    testWidgets('are republished when an expense is added', (tester) async {
      final harness = await bootApp(tester);

      await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '40');
      await tester.tap(find.text('Add expense'));
      await tester.pumpAndSettle();

      expect(harness.widget.latest!.total, r'$40');
    });

    testWidgets('follow the language the user picked', (tester) async {
      final harness = await bootApp(tester);

      await sl<SettingsCubit>().setLanguage(AppLanguage.arabic);
      await tester.pumpAndSettle();

      final snapshot = harness.widget.latest!;
      expect(snapshot.title, 'مصروف سريع');
      expect(snapshot.addLabel, 'إضافة مصروف');
      expect(
        snapshot.categories.map((shortcut) => shortcut.name),
        contains('طعام'),
      );
    });
  });
}
