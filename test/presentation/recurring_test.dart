import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/recurring/domain/entities/recurrence_frequency.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_expense.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_mode.dart';
import 'package:my_budget/features/recurring/presentation/pages/recurring_page.dart';
import 'package:my_budget/features/recurring/presentation/widgets/recurring_due_card.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'app_harness.dart';

DateTime get _today => RecurringExpense.dayOf(DateTime.now());

DateTime _daysAgo(int days) =>
    DateTime(_today.year, _today.month, _today.day - days);

Future<void> _openRecurring(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Recurring payments'));
  await tester.pumpAndSettle();
}

/// A reminder due today, as if it was set up this morning.
void _seedDueToday(AppHarness harness, {String title = 'Rent'}) => harness
    .recurring
    .seed(title: title, amount: 900, dueDay: _today.day, startsOn: _today);

/// A weekly reminder missed twice: 10 and 3 days ago.
void _seedOverdue(AppHarness harness, {String title = 'Cleaner'}) =>
    harness.recurring.seed(
      title: title,
      amount: 40,
      frequency: RecurrenceFrequency.weekly,
      dueDay: _daysAgo(3).weekday,
      startsOn: _daysAgo(10),
    );

void main() {
  tearDown(() => sl.reset());

  testWidgets('adds a payment, marks it paid, and takes that back', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    await _openRecurring(tester);
    expect(find.text('No recurring payments yet'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    expect(find.text('New recurring payment'), findsOneWidget);
    // Monthly, due on today's date, asking before it logs anything.
    await tester.enterText(find.byType(TextField).at(0), 'Internet');
    await tester.enterText(find.byType(TextField).at(1), '30');
    await tester.tap(find.text('Add payment'));
    await tester.pumpAndSettle();

    final saved = harness.recurring.recurring.single;
    expect(saved.title, 'Internet');
    expect(saved.frequency, RecurrenceFrequency.monthly);
    expect(saved.dueDay, _today.day);
    expect(saved.mode, RecurringMode.reminder);
    expect(find.text('Internet'), findsOneWidget);
    expect(find.text('Upcoming'), findsWidgets);
    expect(find.text('Due today'), findsOneWidget);

    await tester.tap(find.text('Mark as paid'));
    await tester.pumpAndSettle();

    final logged = harness.expenses.expenses.single;
    expect(logged.description, 'Internet');
    expect(logged.amount, 30);
    expect(logged.category.id, 'cat_food');
    expect(find.text('Paid'), findsWidgets);
    expect(find.text('Mark as paid'), findsNothing);
    expect(find.text('Internet marked as paid'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(harness.expenses.expenses, isEmpty);
    expect(find.text('Due today'), findsOneWidget);
    expect(find.text('Payment removed'), findsOneWidget);
  });

  testWidgets('home asks about a reminder due today and logs it this month', (
    tester,
  ) async {
    final harness = await bootApp(tester, before: _seedDueToday);
    expect(find.text('Payments to confirm'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(RecurringDueCard),
        matching: find.text('Mark as paid'),
      ),
    );
    await tester.pumpAndSettle();

    final logged = harness.expenses.expenses.single;
    expect(logged.description, 'Rent');
    expect(logged.month.isCurrent, isTrue);
    // Asked and answered: the card goes, and the transaction is listed.
    expect(find.text('Payments to confirm'), findsNothing);
    expect(find.text('Rent'), findsOneWidget);
    expect(find.text('Rent marked as paid'), findsOneWidget);
  });

  testWidgets('a missed reminder is overdue, oldest payment first', (
    tester,
  ) async {
    final harness = await bootApp(tester, before: _seedOverdue);
    expect(find.text('Payments to confirm'), findsOneWidget);
    expect(find.textContaining('2 payments overdue since'), findsOneWidget);

    await tester.tap(find.text('See all'));
    await tester.pumpAndSettle();
    expect(find.byType(RecurringPage), findsOneWidget);
    expect(find.text('Overdue'), findsWidgets);

    await tester.tap(find.text('Mark as paid'));
    await tester.pumpAndSettle();
    // One of two paid: still late for the other.
    expect(harness.recurring.recurring.single.paidThrough, _daysAgo(10));
    expect(find.text('Was due ${_dayOf(tester, _daysAgo(3))}'), findsOneWidget);
  });

  testWidgets('auto-deduct logs what fell due when the app opens', (
    tester,
  ) async {
    final harness = await bootApp(
      tester,
      before: (harness) => harness.recurring.seed(
        title: 'Netflix',
        amount: 15.99,
        dueDay: _today.day,
        mode: RecurringMode.autoDeduct,
        startsOn: _today,
      ),
    );

    final logged = harness.expenses.expenses.single;
    expect(logged.description, 'Netflix');
    expect(logged.date, _today);
    expect(find.text('Netflix'), findsOneWidget);
    expect(
      find.text('1 recurring payment was logged automatically'),
      findsOneWidget,
    );
    // Nothing to confirm: the app did it.
    expect(find.text('Payments to confirm'), findsNothing);

    await _openRecurring(tester);
    expect(find.text('Paid'), findsWidgets);
    expect(find.textContaining('Auto-deduct'), findsOneWidget);
  });

  testWidgets('edits a payment, then deletes it', (tester) async {
    final harness = await bootApp(tester, before: _seedDueToday);
    await _openRecurring(tester);

    await tester.tap(find.text('Rent'));
    await tester.pumpAndSettle();
    expect(find.text('Edit recurring payment'), findsOneWidget);
    expect(find.text('900'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(1), '950');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(harness.recurring.recurring.single.amount, 950);

    await tester.tap(find.text('Rent'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Rent?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(harness.recurring.recurring, isEmpty);
    expect(find.text('No recurring payments yet'), findsOneWidget);
    expect(find.text('Rent deleted'), findsOneWidget);
  });

  testWidgets('a payment needs a name and an amount', (tester) async {
    final harness = await bootApp(tester);
    await _openRecurring(tester);
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), '30');
    await tester.tap(find.text('Add payment'));
    await tester.pumpAndSettle();
    expect(find.text('Give it a name.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Gym');
    await tester.enterText(find.byType(TextField).at(1), '');
    await tester.tap(find.text('Add payment'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid amount.'), findsOneWidget);
    expect(harness.recurring.recurring, isEmpty);
  });

  testWidgets('a weekly payment is due on a weekday, logged automatically', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    await _openRecurring(tester);
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Gym');
    await tester.enterText(find.byType(TextField).at(1), '12');
    await tester.tap(find.text('Weekly'));
    await tester.pumpAndSettle();
    // The weekday after today, so nothing is logged yet.
    final weekday = _today.weekday % 7 + 1;
    final formats = sl<SettingsCubit>().state.formats;
    await tester.tap(find.text(formats.shortWeekdayName(weekday)));
    await tester.scrollUntilVisible(
      find.text('Auto-deduct'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Auto-deduct'));
    await tester.pumpAndSettle();
    expect(
      find.text('Logged as an expense automatically on the due date.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Add payment'));
    await tester.pumpAndSettle();

    final saved = harness.recurring.recurring.single;
    expect(saved.frequency, RecurrenceFrequency.weekly);
    expect(saved.dueDay, weekday);
    expect(saved.mode, RecurringMode.autoDeduct);
    expect(harness.expenses.expenses, isEmpty);
    expect(
      find.text('Every ${formats.weekdayName(weekday)} · Auto-deduct'),
      findsOneWidget,
    );
  });

  for (final language in AppLanguage.values.skip(1)) {
    testWidgets('fits a small phone in ${language.name}', (tester) async {
      // 360 × 740 logical pixels. An overflow anywhere fails the test.
      tester.view.physicalSize = const Size(1080, 2220);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await bootApp(
        tester,
        before: (harness) {
          _seedDueToday(harness, title: 'A rather long name for the rent');
          _seedOverdue(harness);
          harness.recurring.seed(
            title: 'Insurance',
            amount: 123456.78,
            frequency: RecurrenceFrequency.yearly,
            dueDay: 29,
            dueMonth: 2,
            mode: RecurringMode.autoDeduct,
            startsOn: _today,
          );
        },
      );
      await sl<SettingsCubit>().setLanguage(language);
      await tester.pumpAndSettle();
      expect(find.byType(RecurringDueCard), findsOneWidget);
      if (language == AppLanguage.arabic) {
        expect(find.text('مدفوعات بانتظار التأكيد'), findsOneWidget);
        expect(
          Directionality.of(tester.element(find.byType(RecurringDueCard))),
          TextDirection.rtl,
        );
      }

      await tester.tap(
        find.byTooltip(
          language == AppLanguage.arabic
              ? 'المدفوعات المتكررة'
              : 'Recurring payments',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RecurringPage), findsOneWidget);
      if (language == AppLanguage.arabic) {
        expect(find.text('متأخرة'), findsWidgets);
        expect(find.text('تأكيد الدفع'), findsWidgets);
      }

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text(language == AppLanguage.arabic ? 'سنويًا' : 'Yearly'),
      );
      await tester.pumpAndSettle();
    });
  }
}

/// A date as the recurring page words it.
String _dayOf(WidgetTester tester, DateTime date) =>
    sl<SettingsCubit>().state.formats.dayLabel(date);
