import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/utils/app_formats.dart';
import 'package:my_budget/features/quick_expense/domain/entities/quick_add_request.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

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

  group('quick add', () {
    testWidgets('opens preselected when the app is started by a shortcut', (
      tester,
    ) async {
      await bootApp(
        tester,
        launchRequest: const QuickAddRequest(categoryId: 'cat_bills'),
      );

      expect(find.text('Quick expense'), findsOneWidget);
      final chip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Bills'),
      );
      expect(chip.selected, isTrue);
    });

    testWidgets('saves with today\'s date and no description', (tester) async {
      final harness = await bootApp(
        tester,
        launchRequest: const QuickAddRequest(categoryId: 'cat_bills'),
      );

      await tester.enterText(find.byType(TextField).first, '12.50');
      await tester.tap(find.text('Add expense'));
      await tester.pumpAndSettle();

      expect(harness.expenses.expenses, hasLength(1));
      final saved = harness.expenses.expenses.single;
      expect(saved.amount, 12.5);
      expect(saved.category.id, 'cat_bills');
      expect(saved.description, isNull);
      expect(AppFormats.isSameDay(saved.date, DateTime.now()), isTrue);

      // The sheet closes and the new expense shows up on the home screen.
      expect(find.text('Quick expense'), findsNothing);
      expect(find.text('Expense saved'), findsOneWidget);
      expect(find.text('1 expense'), findsOneWidget);
      expect(find.text('Bills'), findsWidgets);
    });

    testWidgets('opens on a tap while the app is already running', (
      tester,
    ) async {
      final harness = await bootApp(tester);
      expect(find.text('Quick expense'), findsNothing);

      harness.widget.tap(const QuickAddRequest(categoryId: 'cat_food'));
      await tester.pumpAndSettle();

      expect(find.text('Quick expense'), findsOneWidget);
      final chip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Food'),
      );
      expect(chip.selected, isTrue);
    });

    testWidgets('falls back to a category when the Add button is used', (
      tester,
    ) async {
      await bootApp(tester, launchRequest: const QuickAddRequest());

      expect(find.text('Quick expense'), findsOneWidget);
      final chip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Food'),
      );
      expect(chip.selected, isTrue);
    });
  });
}
