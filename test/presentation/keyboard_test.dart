import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';

import 'app_harness.dart';

/// Every form's main button must stay above the on-screen keyboard, or the
/// user cannot reach it while typing. Checked on a small phone, where the
/// keyboard leaves the least room.
void main() {
  tearDown(() => sl.reset());

  /// 360 × 640 logical pixels.
  void smallPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  /// A keyboard 280 logical pixels tall, reported the way a phone does.
  const keyboardHeight = 280.0;

  Future<void> openKeyboard(WidgetTester tester) async {
    tester.view.viewInsets = FakeViewPadding(
      bottom: keyboardHeight * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
  }

  /// [label]'s FilledButton (or one of its `.icon` subclasses) sits wholly
  /// on screen, above the keyboard.
  void expectAboveKeyboard(WidgetTester tester, String label) {
    final button = tester.getRect(
      find
          .ancestor(
            of: find.text(label),
            matching: find.byWidgetPredicate(
              (widget) => widget is FilledButton,
            ),
          )
          .last,
    );
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(button.top, greaterThanOrEqualTo(0));
    expect(button.bottom, lessThanOrEqualTo(screenHeight - keyboardHeight));
  }

  Future<void> tapFab(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(FloatingActionButton, label));
    await tester.pumpAndSettle();
  }

  testWidgets('add expense', (tester) async {
    smallPhone(tester);
    await bootApp(tester);
    await tapFab(tester, 'Add');

    await openKeyboard(tester);

    expectAboveKeyboard(tester, 'Add expense');
  });

  testWidgets('add recurring payment', (tester) async {
    smallPhone(tester);
    await bootApp(tester);
    await tester.tap(find.byTooltip('Recurring payments'));
    await tester.pumpAndSettle();
    await tapFab(tester, 'Add');

    await openKeyboard(tester);

    expectAboveKeyboard(tester, 'Add payment');
  });

  testWidgets('new category', (tester) async {
    smallPhone(tester);
    await bootApp(tester);
    await tester.tap(find.byTooltip('Categories'));
    await tester.pumpAndSettle();
    await tapFab(tester, 'New category');

    await openKeyboard(tester);

    expectAboveKeyboard(tester, 'Add category');
  });

  testWidgets('new person', (tester) async {
    smallPhone(tester);
    await bootApp(tester);
    await tester.tap(find.widgetWithText(NavigationDestination, 'People'));
    await tester.pumpAndSettle();
    await tapFab(tester, 'Add');
    await tester.tap(find.text('Add person'));
    await tester.pumpAndSettle();

    await openKeyboard(tester);

    expectAboveKeyboard(tester, 'Add person');
  });

  testWidgets('debt transaction', (tester) async {
    smallPhone(tester);
    await bootApp(
      tester,
      before: (harness) => harness.people.seedPerson('Sara'),
    );
    await tester.tap(find.widgetWithText(NavigationDestination, 'People'));
    await tester.pumpAndSettle();
    await tapFab(tester, 'Add');
    await tester.tap(find.text('Quick transaction'));
    await tester.pumpAndSettle();

    await openKeyboard(tester);

    expectAboveKeyboard(tester, 'Add');
  });

  testWidgets('quick add from the home screen widget', (tester) async {
    smallPhone(tester);
    await bootQuickAdd(tester, categoryId: 'cat_bills');

    await openKeyboard(tester);

    expectAboveKeyboard(tester, 'Add expense');
  });

  testWidgets('sign in and create account', (tester) async {
    smallPhone(tester);
    await bootApp(tester);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.ancestor(
        of: find.text('Sign in'),
        matching: find.bySubtype<OutlinedButton>(),
      ),
    );
    await tester.pumpAndSettle();

    await openKeyboard(tester);
    expectAboveKeyboard(tester, 'Sign in');

    await tester.tap(find.text('No account yet? Create one'));
    await tester.pumpAndSettle();
    expectAboveKeyboard(tester, 'Create account');
  });

  testWidgets('tapping outside the fields closes the keyboard', (tester) async {
    await bootApp(tester);
    await tapFab(tester, 'Add');

    await tester.showKeyboard(find.byType(TextField).first);
    expect(tester.testTextInput.isVisible, isTrue);

    // A label is not a button: the tap falls through to the page.
    await tester.tap(find.text('Category'));
    await tester.pumpAndSettle();

    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('tapping another field keeps the keyboard open', (tester) async {
    await bootApp(tester);
    await tapFab(tester, 'Add');

    await tester.showKeyboard(find.byType(TextField).first);
    await tester.ensureVisible(find.byType(TextField).last);
    await tester.tap(find.byType(TextField).last);
    await tester.pumpAndSettle();

    expect(tester.testTextInput.isVisible, isTrue);
  });
}
