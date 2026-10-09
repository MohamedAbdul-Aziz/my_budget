import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/expenses/presentation/cubit/home_cubit.dart';

import 'app_harness.dart';

/// The home screen shows a day, a week, a month or a year, and steps
/// between them with the arrows.
void main() {
  tearDown(() => sl.reset());

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day, 9);
  final yesterday = DateTime(now.year, now.month, now.day - 1, 9);
  final lastYear = DateTime(now.year - 1, now.month, 1, 9);

  Future<AppHarness> boot(WidgetTester tester) async {
    final harness = await bootApp(tester);
    for (final (amount, date) in [
      (11.0, today),
      (22.0, yesterday),
      (44.0, lastYear),
    ]) {
      await harness.expenses.addExpense(
        amount: amount,
        categoryId: 'cat_food',
        date: date,
      );
    }
    await sl<HomeCubit>().refresh();
    await tester.pumpAndSettle();
    return harness;
  }

  Future<void> choose(WidgetTester tester, String kind) async {
    await tester.tap(find.text(kind).first);
    await tester.pumpAndSettle();
  }

  Finder arrow(String tooltip) => find.byTooltip(tooltip);

  bool enabled(WidgetTester tester, String tooltip) =>
      tester
          .widget<IconButton>(
            find.ancestor(
              of: arrow(tooltip),
              matching: find.byType(IconButton),
            ),
          )
          .onPressed !=
      null;

  testWidgets('a day shows only that day, and the arrows move it', (
    tester,
  ) async {
    await boot(tester);
    await choose(tester, 'Day');

    expect(find.text('Today'), findsWidgets);
    expect(find.text(r'$11'), findsOneWidget);
    expect(find.text('1 transaction'), findsOneWidget);
    // Nothing after today.
    expect(enabled(tester, 'Next'), isFalse);

    await tester.tap(arrow('Previous'));
    await tester.pumpAndSettle();
    expect(find.text('Yesterday'), findsWidgets);
    expect(find.text(r'$22'), findsOneWidget);
    expect(enabled(tester, 'Next'), isTrue);

    await tester.tap(arrow('Next'));
    await tester.pumpAndSettle();
    expect(find.text(r'$11'), findsOneWidget);
  });

  testWidgets('a year adds up the whole year', (tester) async {
    await boot(tester);
    await choose(tester, 'Year');

    final thisYear = [today, yesterday].where((d) => d.year == now.year);
    expect(find.text('${now.year}'), findsOneWidget);
    expect(
      find.text(thisYear.length == 1 ? '1 transaction' : '2 transactions'),
      findsOneWidget,
    );

    await tester.tap(arrow('Previous'));
    await tester.pumpAndSettle();
    expect(find.text('${now.year - 1}'), findsOneWidget);
    expect(find.text(r'$44'), findsOneWidget);
  });

  testWidgets('a week runs from the first day of the user\'s week', (
    tester,
  ) async {
    await boot(tester);
    await choose(tester, 'Week');

    // English weeks start on Sunday.
    final sunday = DateTime(
      now.year,
      now.month,
      now.day - now.weekday % DateTime.daysPerWeek,
    );
    final cubit = sl<HomeCubit>();
    expect(cubit.period.start, sunday);
    expect(find.byKey(const Key('period_label')), findsOneWidget);
  });
}
