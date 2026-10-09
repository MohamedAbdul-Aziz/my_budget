import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';

import 'app_harness.dart';

/// The add buttons pinned under a form must stay above the on-screen
/// keyboard, or the user cannot reach them while typing.
void main() {
  tearDown(() => sl.reset());

  /// The keyboard as a 300 pixel tall bottom inset, as a phone reports it.
  void openKeyboard(WidgetTester tester) {
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
  }

  void expectAboveKeyboard(WidgetTester tester, String label) {
    // FilledButton.icon is a subclass, which widgetWithText's exact type
    // match would miss.
    final button = tester.getRect(
      find.ancestor(
        of: find.text(label),
        matching: find.byWidgetPredicate((widget) => widget is FilledButton),
      ),
    );
    final keyboardTop =
        tester.view.physicalSize.height / tester.view.devicePixelRatio -
        300 / tester.view.devicePixelRatio;
    expect(button.bottom, lessThanOrEqualTo(keyboardTop));
  }

  testWidgets('the add expense button stays above the keyboard', (
    tester,
  ) async {
    await bootApp(tester);
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();

    openKeyboard(tester);
    await tester.pumpAndSettle();

    expectAboveKeyboard(tester, 'Add expense');
  });

  testWidgets('the add payment button stays above the keyboard', (
    tester,
  ) async {
    await bootApp(tester);
    await tester.tap(find.byTooltip('Recurring payments'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();

    openKeyboard(tester);
    await tester.pumpAndSettle();

    expectAboveKeyboard(tester, 'Add payment');
  });

  testWidgets('tapping outside the fields closes the keyboard', (tester) async {
    await bootApp(tester);
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();

    await tester.showKeyboard(find.byType(TextField).first);
    expect(tester.testTextInput.isVisible, isTrue);

    // A label is not a button: the tap falls through to the page.
    await tester.tap(find.text('Category'));
    await tester.pumpAndSettle();

    expect(tester.testTextInput.isVisible, isFalse);
    expect(
      FocusManager.instance.primaryFocus?.context?.widget,
      isNot(isA<EditableText>()),
    );
  });

  testWidgets('tapping another field keeps the keyboard open', (tester) async {
    await bootApp(tester);
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();

    await tester.showKeyboard(find.byType(TextField).first);
    await tester.ensureVisible(find.byType(TextField).last);
    await tester.tap(find.byType(TextField).last);
    await tester.pumpAndSettle();

    expect(tester.testTextInput.isVisible, isTrue);
  });
}
