import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/error/failures.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

  const email = 'mohamed@example.com';

  Future<AppHarness> bootSignedIn(WidgetTester tester) async {
    final harness = await bootApp(tester);
    harness.auth.addConfirmedAccount(email, 'secret1');
    harness.auth.openConfirmationLink(email);
    await tester.pumpAndSettle();
    return harness;
  }

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
  }

  Future<void> tapDeleteAccount(WidgetTester tester) async {
    final button = find.text('Delete account');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  Finder dialogButton(String label) => find.descendant(
    of: find.byType(AlertDialog),
    matching: find.widgetWithText(TextButton, label),
  );

  testWidgets('guests have no account to delete', (tester) async {
    await bootApp(tester);
    await openSettings(tester);

    expect(find.text('Delete account'), findsNothing);
  });

  testWidgets('asks before deleting, and cancelling keeps the account', (
    tester,
  ) async {
    final harness = await bootSignedIn(tester);
    await openSettings(tester);

    await tapDeleteAccount(tester);
    expect(find.text('Delete your account?'), findsOneWidget);

    await tester.tap(dialogButton('Cancel'));
    await tester.pumpAndSettle();

    expect(harness.auth.deletedAccounts, isEmpty);
    expect(find.text(email), findsOneWidget);
  });

  testWidgets('deleting the account signs out and unlinks the phone', (
    tester,
  ) async {
    final harness = await bootSignedIn(tester);
    await openSettings(tester);

    await tapDeleteAccount(tester);
    await tester.tap(dialogButton('Delete'));
    await tester.pumpAndSettle();

    expect(harness.auth.deletedAccounts, [email]);
    expect(harness.sync.forgottenAccounts, ['user_$email']);
    // The sheet closed so the confirmation is visible on the home screen.
    expect(find.text('Your account was deleted'), findsOneWidget);
    expect(find.text('Delete account'), findsNothing);

    // Signed out: settings offers sign-in again, and the app still works.
    await openSettings(tester);
    expect(
      find.ancestor(
        of: find.text('Sign in'),
        matching: find.bySubtype<OutlinedButton>(),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a failed deletion keeps the account and says why', (
    tester,
  ) async {
    final harness = await bootSignedIn(tester);
    harness.auth.deleteFailure = const NetworkFailure('offline');
    await openSettings(tester);

    await tapDeleteAccount(tester);
    await tester.tap(dialogButton('Delete'));
    await tester.pumpAndSettle();

    expect(harness.auth.deletedAccounts, isEmpty);
    expect(harness.sync.forgottenAccounts, isEmpty);
    expect(
      find.text("Couldn't connect. Check your internet and try again."),
      findsOneWidget,
    );
    expect(find.text(email), findsOneWidget);
  });
}
