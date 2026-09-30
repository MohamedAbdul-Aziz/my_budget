import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/error/failures.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
  }

  Future<AppHarness> bootSignedIn(WidgetTester tester) async {
    final harness = await bootApp(tester);
    harness.auth.openConfirmationLink('mohamed@example.com');
    await tester.pumpAndSettle();
    return harness;
  }

  Future<void> tapInSheet(WidgetTester tester, String label) async {
    final button = find.text(label);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('guests see no backup controls', (tester) async {
    await bootApp(tester);
    await openSettings(tester);

    expect(find.text('Back up now'), findsNothing);
    expect(find.text('Restore'), findsNothing);
    expect(
      find.text(
        'Your expenses are stored on this device. Sign in to back them up.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a signed-in user can back up and sees when', (tester) async {
    final harness = await bootSignedIn(tester);
    await openSettings(tester);

    expect(find.text('Not backed up yet'), findsOneWidget);

    await tapInSheet(tester, 'Back up now');

    expect(harness.sync.backUps, 1);
    expect(find.text('Backup complete'), findsOneWidget);
    expect(find.textContaining('Last synced Today'), findsOneWidget);
  });

  testWidgets('a failed backup says why', (tester) async {
    final harness = await bootSignedIn(tester);
    harness.sync.failWith = const NetworkFailure('offline');
    await openSettings(tester);

    await tapInSheet(tester, 'Back up now');

    expect(
      find.text("Couldn't connect. Check your internet and try again."),
      findsOneWidget,
    );
    expect(find.text('Not backed up yet'), findsOneWidget);
  });

  testWidgets('restore reloads what the home screen shows', (tester) async {
    final harness = await bootSignedIn(tester);
    // The cloud copy holds an expense this phone has never seen.
    harness.sync.onRestore = () async {
      await harness.expenses.addExpense(
        amount: 40,
        categoryId: 'cat_food',
        date: DateTime.now(),
      );
    };
    await openSettings(tester);

    await tapInSheet(tester, 'Restore');
    expect(find.text('Restore complete'), findsOneWidget);

    // Close the sheet: the home screen already shows the restored expense.
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
    expect(find.text('1 transaction'), findsOneWidget);
  });

  testWidgets('signing out hides the backup controls', (tester) async {
    await bootSignedIn(tester);
    await openSettings(tester);
    expect(find.text('Back up now'), findsOneWidget);

    await tapInSheet(tester, 'Sign out');

    expect(find.text('Back up now'), findsNothing);
  });
}
