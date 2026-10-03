import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/theme/status_colors.dart';
import 'package:my_budget/features/budgets/presentation/cubit/budget_cubit.dart';
import 'package:my_budget/features/budgets/presentation/widgets/budget_card.dart';
import 'package:my_budget/features/budgets/presentation/widgets/budget_progress_bar.dart';
import 'package:my_budget/features/expenses/presentation/cubit/home_cubit.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'app_harness.dart';

/// Records an expense through the add screen, as the user would.
Future<void> _addExpense(
  WidgetTester tester,
  String amount, {
  String addLabel = 'Add',
  String submitLabel = 'Add expense',
}) async {
  await tester.tap(find.widgetWithText(FloatingActionButton, addLabel));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).first, amount);
  await tester.tap(find.text(submitLabel));
  await tester.pumpAndSettle();
}

/// Budgets set somewhere else (another screen, a restore) before the test.
Future<void> _setBudgets(
  WidgetTester tester,
  AppHarness harness, {
  double? monthly,
  Map<String, double> byCategory = const {},
}) async {
  harness.budgets.monthly = monthly;
  harness.budgets.byCategory.addAll(byCategory);
  await sl<BudgetCubit>().refresh();
  await tester.pumpAndSettle();
}

Finder get _barFill => find.descendant(
  of: find.byType(BudgetProgressBar),
  matching: find.byType(DecoratedBox),
);

Color _barColor(WidgetTester tester) =>
    (tester.widget<DecoratedBox>(_barFill).decoration as BoxDecoration).color!;

void main() {
  tearDown(() => sl.reset());

  group('setting the monthly budget', () {
    testWidgets('a new user is invited to set one, then sees what is left', (
      tester,
    ) async {
      final harness = await bootApp(tester);
      expect(find.text('Set a monthly budget'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Set'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '500');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(harness.budgets.monthly, 500);
      expect(find.text('Set a monthly budget'), findsNothing);
      expect(find.text(r'$500 left'), findsOneWidget);
      expect(find.text(r'$0 of $500 spent'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('a refused amount keeps the dialog open and says why', (
      tester,
    ) async {
      final harness = await bootApp(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Set'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '0');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Enter an amount greater than zero.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid amount.'), findsOneWidget);
      expect(harness.budgets.monthly, isNull);
    });

    testWidgets('the edit button changes it, and Remove takes it away', (
      tester,
    ) async {
      final harness = await bootApp(tester);
      await _setBudgets(tester, harness, monthly: 200);

      await tester.tap(find.byTooltip('Edit budget'));
      await tester.pumpAndSettle();
      // The current limit is ready to change.
      expect(find.text('200'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '350');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(harness.budgets.monthly, 350);
      expect(find.text(r'$350 left'), findsOneWidget);

      await tester.tap(find.byTooltip('Edit budget'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(harness.budgets.monthly, isNull);
      expect(find.text('Set a monthly budget'), findsOneWidget);
    });
  });

  testWidgets('the bar turns from green to orange to red as spending grows', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    await _setBudgets(tester, harness, monthly: 100);

    await _addExpense(tester, '50');
    expect(_barColor(tester), StatusColors.light.good);

    await _addExpense(tester, '25');
    expect(_barColor(tester), StatusColors.light.caution);

    await _addExpense(tester, '20');
    expect(_barColor(tester), StatusColors.light.danger);
    expect(find.text(r'$5 left'), findsOneWidget);
    expect(find.text('95%'), findsOneWidget);
  });

  group('warnings after logging an expense', () {
    testWidgets('comfortable spending shows no warning', (tester) async {
      final harness = await bootApp(tester);
      await _setBudgets(tester, harness, monthly: 1000);

      await _addExpense(tester, '25');

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('passing 80% warns, and View opens the budgets', (
      tester,
    ) async {
      final harness = await bootApp(tester);
      await _setBudgets(tester, harness, monthly: 100);

      await _addExpense(tester, '85');

      expect(
        find.text("You've used 85% of your monthly budget"),
        findsOneWidget,
      );
      // The warning floats above the Add button instead of covering it, so
      // the next expense can be logged straight away.
      expect(
        tester.getRect(find.byType(SnackBar)).bottom,
        lessThanOrEqualTo(
          tester.getRect(find.byType(FloatingActionButton)).top,
        ),
      );

      await tester.tap(find.text('View'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Budgets ·'), findsOneWidget);
      expect(find.text('Category budgets'), findsOneWidget);
    });

    testWidgets('passing the limit says by how much', (tester) async {
      final harness = await bootApp(tester);
      await _setBudgets(tester, harness, monthly: 100);

      await _addExpense(tester, '85');
      await _addExpense(tester, '30');

      expect(find.text("You're \$15 over your monthly budget"), findsOneWidget);
      expect(find.text("You've used 85% of your monthly budget"), findsNothing);
      expect(find.text(r'$15 over budget'), findsOneWidget);
    });

    testWidgets('a category past its own limit is named and watched', (
      tester,
    ) async {
      final harness = await bootApp(tester);
      // Food is the category the add screen preselects.
      await _setBudgets(tester, harness, byCategory: {'cat_food': 50});

      await _addExpense(tester, '60');

      expect(find.text("You're \$10 over your Food budget"), findsOneWidget);
      // With no monthly budget the card still invites one, and lists the
      // category close to its limit underneath.
      expect(find.text('Set a monthly budget'), findsOneWidget);
      expect(find.text('Close to their limit'), findsOneWidget);
      expect(find.text('120%'), findsOneWidget);
    });
  });

  testWidgets('the budgets page sets and removes a category limit', (
    tester,
  ) async {
    final harness = await bootApp(tester);

    // Tapping the card, not its button, opens every budget.
    await tester.tap(find.text('Set a monthly budget'));
    await tester.pumpAndSettle();
    expect(find.text('Category budgets'), findsOneWidget);
    expect(find.text('Set limit'), findsNWidgets(3));

    await tester.tap(find.text('Bills'));
    await tester.pumpAndSettle();
    expect(find.text('Bills budget'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '80');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(harness.budgets.byCategory, {'cat_bills': 80});
    expect(find.text(r'$0 of $80 spent'), findsOneWidget);
    expect(find.text('Set limit'), findsNWidgets(2));

    await tester.tap(find.text('Bills'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(harness.budgets.byCategory, isEmpty);
    expect(find.text('Set limit'), findsNWidgets(3));
  });

  testWidgets('in Arabic the card and its warning read right to left', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    await sl<SettingsCubit>().setLanguage(AppLanguage.arabic);
    await tester.pumpAndSettle();
    expect(find.text('حدّد ميزانية شهرية'), findsOneWidget);

    await _setBudgets(tester, harness, monthly: 100);
    await _addExpense(
      tester,
      '85',
      addLabel: 'إضافة',
      submitLabel: 'إضافة مصروف',
    );

    final formats = sl<SettingsCubit>().state.formats;
    expect(
      find.text('استخدمت ${formats.percent(0.85)} من ميزانيتك الشهرية'),
      findsOneWidget,
    );
    expect(find.text('تبقّى ${formats.moneyTight(15)}'), findsOneWidget);

    // The bar fills from the right edge, where Arabic starts reading.
    expect(
      Directionality.of(tester.element(find.byType(BudgetCard))),
      TextDirection.rtl,
    );
    final track = find.descendant(
      of: find.byType(BudgetProgressBar),
      matching: find.byType(ColoredBox),
    );
    expect(tester.getTopRight(_barFill).dx, tester.getTopRight(track).dx);
    expect(
      tester.getTopLeft(_barFill).dx,
      greaterThan(tester.getTopLeft(track).dx),
    );
  });

  for (final language in AppLanguage.values.skip(1)) {
    testWidgets('fits a small phone in ${language.name}', (tester) async {
      // 360 × 740 logical pixels. An overflow anywhere fails the test.
      tester.view.physicalSize = const Size(1080, 2220);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final harness = await bootApp(tester);
      await sl<SettingsCubit>().setLanguage(language);
      await tester.pumpAndSettle();
      expect(find.byType(BudgetCard), findsOneWidget);

      // Long amounts, the month far over budget, and every category watched.
      for (final id in ['cat_food', 'cat_bills', 'cat_other']) {
        await harness.expenses.addExpense(
          amount: 123456.78,
          categoryId: id,
          date: DateTime.now(),
        );
      }
      await _setBudgets(
        tester,
        harness,
        monthly: 100000,
        byCategory: {'cat_food': 900, 'cat_bills': 900, 'cat_other': 900},
      );
      await sl<HomeCubit>().refresh();
      await tester.pumpAndSettle();
      expect(find.byType(BudgetProgressBar), findsOneWidget);

      await tester.tap(find.byType(BudgetCard));
      await tester.pumpAndSettle();
      expect(find.byType(BudgetProgressBar), findsNWidgets(4));
    });
  }

  testWidgets('quick add from the widget shows the warning before closing', (
    tester,
  ) async {
    final platformCalls = recordPlatformCalls(tester);
    final harness = await bootQuickAdd(tester, categoryId: 'cat_bills');
    harness.budgets.monthly = 100;

    await tester.enterText(find.byType(TextField), '90');
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();

    expect(harness.expenses.expenses.single.amount, 90);
    expect(find.text('Budget alert'), findsOneWidget);
    expect(find.text("You've used 90% of your monthly budget"), findsOneWidget);
    expect(platformCalls, isNot(contains('SystemNavigator.pop')));

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(platformCalls, contains('SystemNavigator.pop'));
  });
}
