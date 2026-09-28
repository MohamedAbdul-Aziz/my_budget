import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';

import 'app_harness.dart';

void main() {
  tearDown(() => sl.reset());

  // OutlinedButton.icon builds a private subclass, so match by subtype.
  final settingsSignIn = find.ancestor(
    of: find.text('Sign in'),
    matching: find.bySubtype<OutlinedButton>(),
  );

  Future<void> openSignIn(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(settingsSignIn);
    await tester.pumpAndSettle();
  }

  Future<void> submit(
    WidgetTester tester, {
    required String email,
    required String password,
    required String button,
  }) async {
    await tester.enterText(find.widgetWithText(TextField, 'Email'), email);
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      password,
    );
    await tester.tap(find.widgetWithText(FilledButton, button));
    await tester.pumpAndSettle();
  }

  Future<void> createAccount(
    WidgetTester tester, {
    required String email,
    String password = 'secret1',
  }) async {
    await openSignIn(tester);
    await tester.tap(find.text('No account yet? Create one'));
    await tester.pumpAndSettle();
    await submit(
      tester,
      email: email,
      password: password,
      button: 'Create account',
    );
  }

  Future<void> enterCode(WidgetTester tester, String code) async {
    await tester.enterText(find.widgetWithText(TextField, 'Code'), code);
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
    await tester.pumpAndSettle();
  }

  testWidgets('the app works without an account', (tester) async {
    await bootApp(tester);

    // No sign-in wall: the home screen is up and adding is available.
    expect(find.widgetWithText(FloatingActionButton, 'Add'), findsOneWidget);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(settingsSignIn, findsOneWidget);
  });

  testWidgets('signs in and shows the email in settings', (tester) async {
    final harness = await bootApp(tester);
    harness.auth.addConfirmedAccount('mohamed@example.com', 'secret1');

    await openSignIn(tester);
    // Case and spaces do not matter.
    await submit(
      tester,
      email: ' Mohamed@Example.com',
      password: 'secret1',
      button: 'Sign in',
    );

    // The sign-in page closed itself, back on the settings sheet.
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsNothing);
    expect(find.text('mohamed@example.com'), findsOneWidget);
    expect(find.text('Signed in'), findsOneWidget);
  });

  testWidgets('a wrong password keeps the page open with an error', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    harness.auth.addConfirmedAccount('mohamed@example.com', 'secret1');

    await openSignIn(tester);
    await submit(
      tester,
      email: 'mohamed@example.com',
      password: 'wrong-one',
      button: 'Sign in',
    );

    expect(find.text('Wrong email or password.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
    expect(harness.auth.currentUser, isNull);
  });

  testWidgets('sign-up asks for the code from the email', (tester) async {
    final harness = await bootApp(tester);

    await createAccount(tester, email: 'new@example.com');

    expect(harness.auth.passwords, {'new@example.com': 'secret1'});
    expect(harness.auth.currentUser, isNull);
    expect(find.text('Confirm your email'), findsOneWidget);
    expect(find.textContaining('code to new@example.com'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Code'), findsOneWidget);
  });

  testWidgets('the right code confirms the account and signs in', (
    tester,
  ) async {
    await bootApp(tester);

    await createAccount(tester, email: 'new@example.com');
    await enterCode(tester, '123456');

    // The sign-in page closed on its own and settings shows the account.
    expect(find.text('Confirm your email'), findsNothing);
    expect(find.text('new@example.com'), findsOneWidget);
    expect(find.text('Signed in'), findsOneWidget);
  });

  testWidgets('a wrong code keeps asking for the code', (tester) async {
    final harness = await bootApp(tester);

    await createAccount(tester, email: 'new@example.com');
    await enterCode(tester, '000000');

    expect(find.text('That code is wrong or has expired.'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Code'), findsOneWidget);
    expect(harness.auth.currentUser, isNull);
  });

  testWidgets('a new code can be requested', (tester) async {
    final harness = await bootApp(tester);

    await createAccount(tester, email: 'new@example.com');
    await tester.tap(find.text('Send a new code'));
    await tester.pumpAndSettle();

    expect(harness.auth.resends, 1);
    expect(find.text('A new code is on its way'), findsOneWidget);

    // Only the newest code works.
    await enterCode(tester, '654321');
    expect(find.text('Signed in'), findsOneWidget);
  });

  testWidgets('signing in before confirming asks for the code', (tester) async {
    final harness = await bootApp(tester);

    await createAccount(tester, email: 'new@example.com');
    await tester.tap(find.text('Use a different email'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Already have an account? Sign in'));
    await tester.pumpAndSettle();
    await submit(
      tester,
      email: 'new@example.com',
      password: 'secret1',
      button: 'Sign in',
    );

    expect(
      find.text('Confirm your email first with the code we sent you.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(TextField, 'Code'), findsOneWidget);

    await enterCode(tester, harness.auth.codes['new@example.com']!);
    expect(find.text('Signed in'), findsOneWidget);
  });

  testWidgets('a confirmation link opening the app also signs in', (
    tester,
  ) async {
    final harness = await bootApp(tester);

    await createAccount(tester, email: 'new@example.com');
    harness.auth.openConfirmationLink('new@example.com');
    await tester.pumpAndSettle();

    expect(find.text('Confirm your email'), findsNothing);
    expect(find.text('Signed in'), findsOneWidget);
  });

  testWidgets('signs out', (tester) async {
    final harness = await bootApp(tester);
    harness.auth.addConfirmedAccount('mohamed@example.com', 'secret1');

    await openSignIn(tester);
    await submit(
      tester,
      email: 'mohamed@example.com',
      password: 'secret1',
      button: 'Sign in',
    );
    await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(harness.auth.currentUser, isNull);
    expect(settingsSignIn, findsOneWidget);
  });

  testWidgets('rejects a bad email before calling the server', (tester) async {
    final harness = await bootApp(tester);

    await createAccount(tester, email: 'not-an-email');

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(harness.auth.passwords, isEmpty);
  });
}
