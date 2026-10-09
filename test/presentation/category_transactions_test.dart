import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/analyses/presentation/cubit/analyses_cubit.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/presentation/cubit/home_cubit.dart';
import 'package:my_budget/features/expenses/presentation/pages/search_page.dart';

import 'app_harness.dart';

/// Tapping a category where its total is shown lists the transactions
/// behind that total.
void main() {
  tearDown(() => sl.reset());

  final month = Month.current();

  /// Food twice this month and once the month before; Bills once.
  Future<void> seed(AppHarness harness) async {
    for (final (amount, category, date) in [
      (10.0, 'cat_food', month.start),
      (15.0, 'cat_food', month.start),
      (99.0, 'cat_food', month.previous.start),
      (40.0, 'cat_bills', month.start),
    ]) {
      await harness.expenses.addExpense(
        amount: amount,
        categoryId: category,
        date: date,
      );
    }
  }

  /// The search opened on Food alone, this month only.
  void expectFoodThisMonth(WidgetTester tester) {
    expect(find.byType(SearchPage), findsOneWidget);
    expect(find.textContaining('2 transactions'), findsOneWidget);
    expect(find.text(r'$99.00'), findsNothing);
    expect(find.text(r'$40.00'), findsNothing);
    // Not typing: the keyboard stays down.
    expect(tester.testTextInput.isVisible, isFalse);
  }

  testWidgets('from the analyses category list', (tester) async {
    final harness = await bootApp(tester);
    await seed(harness);
    await sl<AnalysesCubit>().load(month);
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();

    final food = find.widgetWithText(InkWell, 'Food');
    await tester.scrollUntilVisible(
      food,
      200,
      scrollable: find
          .ancestor(
            of: find.text('Spending by category'),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.ensureVisible(food);
    await tester.pumpAndSettle();
    await tester.tap(food);
    await tester.pumpAndSettle();

    expectFoodThisMonth(tester);
  });

  testWidgets('from the home breakdown', (tester) async {
    final harness = await bootApp(tester);
    await seed(harness);
    await sl<HomeCubit>().refresh();
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Food · '));
    await tester.pumpAndSettle();

    expectFoodThisMonth(tester);
  });
}
