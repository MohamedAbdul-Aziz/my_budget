import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/theme/status_colors.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction_type.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'app_harness.dart';

const _paid = PersonTransactionType.iPaidForThem;
const _theyPaid = PersonTransactionType.theyPaidForMe;

Future<void> _openPeople(WidgetTester tester, {String label = 'People'}) async {
  await tester.tap(find.widgetWithText(NavigationDestination, label));
  await tester.pumpAndSettle();
}

Future<void> _openLedger(WidgetTester tester, String name) async {
  await tester.tap(find.widgetWithText(ListTile, name));
  await tester.pumpAndSettle();
}

Color? _colorOf(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text).last).style?.color;

void main() {
  tearDown(() => sl.reset());

  testWidgets('adds a person, then what I paid for them', (tester) async {
    final harness = await bootApp(tester);
    await _openPeople(tester);
    expect(find.text('No people yet'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add person'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '  Sara ');
    await tester.tap(find.widgetWithText(FilledButton, 'Add person'));
    await tester.pumpAndSettle();

    // Straight into her ledger, ready for the first transaction.
    expect(harness.people.people.single.name, 'Sara');
    expect(find.text('All settled up with Sara'), findsOneWidget);
    expect(find.text('Nothing recorded yet'), findsOneWidget);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '60');
    await tester.enterText(find.byType(TextField).at(1), 'Dinner');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();

    expect(harness.people.transactions.single.type, _paid);
    expect(find.text('Sara owes you'), findsOneWidget);
    expect(find.text('Active transactions'), findsOneWidget);
    expect(find.text('Dinner'), findsOneWidget);
    expect(find.text('Settle up \$60.00'), findsOneWidget);
    final context = tester.element(find.text('Sara owes you'));
    expect(_colorOf(tester, '\$60.00'), StatusColors.of(context).good);

    // Back on the list, her balance is there too.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Sara'), findsOneWidget);
    expect(find.textContaining('Owes you'), findsOneWidget);
  });

  testWidgets('a refused amount keeps the sheet open with the reason', (
    tester,
  ) async {
    final harness = await bootApp(
      tester,
      before: (harness) => harness.people.seedPerson('Sara'),
    );
    await _openPeople(tester);
    await _openLedger(tester, 'Sara');

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid amount.'), findsOneWidget);
    expect(harness.people.transactions, isEmpty);
  });

  testWidgets('settling up clears the balance and can log it as income', (
    tester,
  ) async {
    final harness = await bootApp(
      tester,
      before: (harness) {
        final sara = harness.people.seedPerson('Sara');
        harness.people
          ..seedTransaction(sara, 60, _paid, note: 'Dinner')
          ..seedTransaction(sara, 25, _theyPaid, note: 'Taxi');
      },
    );
    await _openPeople(tester);
    await _openLedger(tester, 'Sara');
    expect(find.text('Sara owes you'), findsOneWidget);

    await tester.tap(find.text('Settle up \$35.00'));
    await tester.pumpAndSettle();
    expect(find.text('Settle up with Sara?'), findsOneWidget);
    expect(find.textContaining('Sara pays you \$35.00'), findsOneWidget);
    expect(
      find.textContaining('2 transactions will move to the settled history.'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Settle'));
    await tester.pumpAndSettle();

    expect(
      find.text('Log this settlement in your monthly budget?'),
      findsOneWidget,
    );
    expect(find.textContaining('as income in Other income'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Yes'));
    await tester.pumpAndSettle();

    final logged = harness.expenses.expenses.single;
    expect(logged.amount, 35);
    expect(logged.category.id, ExpenseCategory.incomeFallbackId);
    expect(logged.description, 'Settlement with Sara');
    expect(harness.people.settlements.single.expenseId, logged.id);

    expect(find.text('All settled up with Sara'), findsOneWidget);
    expect(find.text('Active transactions'), findsNothing);
    expect(find.text('Settled history'), findsOneWidget);
    expect(find.textContaining('In your budget'), findsOneWidget);
    expect(find.text('Added to your budget'), findsOneWidget);

    // The settled group opens to the cleared items.
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    expect(find.text('Dinner'), findsOneWidget);
    expect(find.text('Taxi'), findsOneWidget);
  });

  testWidgets('settling without logging leaves the budget alone', (
    tester,
  ) async {
    final harness = await bootApp(
      tester,
      before: (harness) {
        final omar = harness.people.seedPerson('Omar');
        harness.people.seedTransaction(omar, 40, _theyPaid);
      },
    );
    await _openPeople(tester);
    await _openLedger(tester, 'Omar');
    expect(find.text('You owe Omar'), findsOneWidget);
    final context = tester.element(find.text('You owe Omar'));
    expect(_colorOf(tester, '\$40.00'), StatusColors.of(context).danger);

    await tester.tap(find.text('Settle up \$40.00'));
    await tester.pumpAndSettle();
    expect(find.textContaining('You pay Omar \$40.00'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Settle'));
    await tester.pumpAndSettle();
    expect(find.textContaining('as an expense in Other'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'No'));
    await tester.pumpAndSettle();

    expect(harness.expenses.expenses, isEmpty);
    expect(harness.people.settlements.single.expenseId, isNull);
    expect(find.text('All settled up with Omar'), findsOneWidget);
  });

  testWidgets('filters the list by who owes whom', (tester) async {
    await bootApp(
      tester,
      before: (harness) {
        final people = harness.people;
        people.seedTransaction(people.seedPerson('Sara'), 10, _paid);
        people.seedTransaction(people.seedPerson('Omar'), 10, _theyPaid);
        people.seedPerson('Zeina');
      },
    );
    await _openPeople(tester);
    // Everyone owes or is owed $10, and the totals add it up both ways.
    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.text('\$10.00'), findsNWidgets(4));

    Future<void> filter(String label) async {
      await tester.tap(find.widgetWithText(ChoiceChip, label));
      await tester.pumpAndSettle();
    }

    await filter('Owed to me');
    expect(find.widgetWithText(ListTile, 'Sara'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Omar'), findsNothing);

    await filter('I owe');
    expect(find.widgetWithText(ListTile, 'Omar'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Sara'), findsNothing);

    await filter('Settled');
    expect(find.widgetWithText(ListTile, 'Zeina'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Sara'), findsNothing);

    await filter('All');
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('an edit is kept in the change history; settled items are '
      'locked', (tester) async {
    final harness = await bootApp(
      tester,
      before: (harness) {
        final sara = harness.people.seedPerson('Sara');
        harness.people.seedTransaction(sara, 20, _paid, note: 'Lunch');
      },
    );
    await _openPeople(tester);
    await _openLedger(tester, 'Sara');

    await tester.tap(find.text('Lunch'));
    await tester.pumpAndSettle();
    expect(find.text('Transaction details'), findsOneWidget);
    expect(find.text('Change history'), findsNothing);
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '24');
    await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
    await tester.pumpAndSettle();

    expect(harness.people.transactions.single.amount, 24);
    expect(find.textContaining('Edited'), findsOneWidget);

    await tester.tap(find.text('Lunch'));
    await tester.pumpAndSettle();
    expect(find.text('Change history'), findsOneWidget);
    expect(
      find.textContaining('Was: \$20.00 · I paid for them'),
      findsOneWidget,
    );
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settle up \$24.00'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Settle'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'No'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lunch'));
    await tester.pumpAndSettle();

    expect(
      find.text('Settled, so it can no longer be changed.'),
      findsOneWidget,
    );
    expect(find.text('Edit'), findsNothing);
  });

  testWidgets('a quick transaction from the People tab', (tester) async {
    final harness = await bootApp(
      tester,
      before: (harness) => harness.people.seedPerson('Sara'),
    );
    await _openPeople(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quick transaction'));
    await tester.pumpAndSettle();
    // The only person is already chosen.
    await tester.tap(find.text('They paid for me'));
    await tester.enterText(find.byType(TextField).at(0), '12.5');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();

    final saved = harness.people.transactions.single;
    expect(saved.amount, 12.5);
    expect(saved.type, _theyPaid);
    expect(find.textContaining('You owe'), findsWidgets);
    expect(find.text('\$12.50'), findsWidgets);
  });

  testWidgets('a quick transaction needs someone to record it with', (
    tester,
  ) async {
    await bootApp(tester);
    await _openPeople(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quick transaction'));
    await tester.pumpAndSettle();

    expect(find.text('Add a person first.'), findsOneWidget);
  });

  testWidgets('deleting a person removes them from the list', (tester) async {
    final harness = await bootApp(
      tester,
      before: (harness) {
        final sara = harness.people.seedPerson('Sara');
        harness.people.seedTransaction(sara, 20, _paid);
      },
    );
    await _openPeople(tester);
    await _openLedger(tester, 'Sara');

    await tester.tap(find.byTooltip('Show menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete person'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Sara?'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(harness.people.people, isEmpty);
    expect(harness.people.transactions, isEmpty);
    expect(find.text('No people yet'), findsOneWidget);
    expect(find.text('Sara deleted'), findsOneWidget);
  });

  testWidgets('the People tab speaks Arabic', (tester) async {
    await bootApp(
      tester,
      before: (harness) {
        final sara = harness.people.seedPerson('سارة');
        harness.people.seedTransaction(sara, 20, _paid);
      },
    );
    await sl<SettingsCubit>().setLanguage(AppLanguage.arabic);
    await tester.pumpAndSettle();

    await _openPeople(tester, label: 'الأشخاص');
    expect(find.text('مستحق لي'), findsOneWidget);
    expect(find.textContaining('مدين لك'), findsWidgets);

    await _openLedger(tester, 'سارة');
    expect(find.text('سارة مدين لك'), findsOneWidget);
    expect(find.text('المعاملات الحالية'), findsOneWidget);
  });
}
