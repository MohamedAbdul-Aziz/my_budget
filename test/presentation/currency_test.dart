import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';

import 'app_harness.dart';

/// Settings → Currency: a searchable list of currencies, "Other" last for
/// any symbol the list lacks.
void main() {
  tearDown(() => sl.reset());

  final selector = find.byKey(const Key('currency_selector'));
  final options = find.byKey(const Key('currency_options'));

  Future<void> openPicker(
    WidgetTester tester, {
    String settings = 'Settings',
  }) async {
    await tester.tap(find.byTooltip(settings));
    await tester.pumpAndSettle();
    await tester.ensureVisible(selector);
    await tester.pumpAndSettle();
    await tester.tap(selector);
    await tester.pumpAndSettle();
  }

  /// The row for [code] whose symbol is [symbol], scrolled into view.
  Future<Finder> row(WidgetTester tester, String code, String symbol) async {
    final tile = find.ancestor(
      of: find.text(symbol),
      matching: find.widgetWithText(ListTile, code),
    );
    await tester.scrollUntilVisible(
      tile,
      200,
      scrollable: find.descendant(
        of: options,
        matching: find.byType(Scrollable),
      ),
    );
    return tile;
  }

  testWidgets('each currency shows its flag, code, name and symbol', (
    tester,
  ) async {
    final harness = await bootApp(tester);
    // The phone's own currency is shown in Settings.
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(selector);
    expect(
      find.descendant(of: selector, matching: find.text('US Dollar')),
      findsOneWidget,
    );

    await tester.tap(selector);
    await tester.pumpAndSettle();

    final euro = await row(tester, 'EUR', '€');
    expect(
      find.descendant(of: euro, matching: find.text('Euro')),
      findsOneWidget,
    );
    expect(find.descendant(of: euro, matching: find.text('🇪🇺')), findsOne);

    await tester.tap(euro);
    await tester.pumpAndSettle();

    expect(harness.settings.settings.currencySymbol, '€');
    expect(
      find.descendant(of: selector, matching: find.text('Euro')),
      findsOneWidget,
    );
  });

  testWidgets('search finds a currency by name, code or symbol', (
    tester,
  ) async {
    await bootApp(tester);
    await openPicker(tester);

    // The Settings row behind the sheet also names a currency.
    Finder inList(String text) =>
        find.descendant(of: options, matching: find.text(text));

    await tester.enterText(find.byType(TextField), 'pound');
    await tester.pumpAndSettle();
    expect(inList('Egyptian Pound'), findsWidgets);
    expect(inList('British Pound'), findsOneWidget);
    expect(inList('US Dollar'), findsNothing);

    await tester.enterText(find.byType(TextField), 'KWD');
    await tester.pumpAndSettle();
    expect(inList('Kuwaiti Dinar'), findsOneWidget);
    expect(inList('Egyptian Pound'), findsNothing);
  });

  testWidgets('"Other" takes any symbol', (tester) async {
    final harness = await bootApp(tester);
    await openPicker(tester);

    // A search that finds nothing still offers "Other".
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'BTC');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(harness.settings.settings.currencySymbol, 'BTC');
    expect(
      find.descendant(of: selector, matching: find.text('BTC')),
      findsOneWidget,
    );
  });

  testWidgets('the phone\'s default currency is in the list in Arabic', (
    tester,
  ) async {
    await bootApp(tester, localeName: 'ar_EG');
    await tester.tap(find.byTooltip('الإعدادات'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(selector);

    expect(
      find.descendant(of: selector, matching: find.text('جنيه مصري')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: selector, matching: find.text('E£')),
      findsOneWidget,
    );
  });
}
