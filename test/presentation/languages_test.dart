import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/l10n/app_strings.dart';
import 'package:my_budget/features/expenses/presentation/cubit/home_cubit.dart';
import 'package:my_budget/features/expenses/presentation/cubit/search_cubit.dart';
import 'package:my_budget/features/reminders/domain/entities/daily_reminder.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:my_budget/features/settings/presentation/widgets/settings_sheet.dart';

import 'app_harness.dart';

/// The labels the settings sheet's language picker offers, in order. Opens
/// the list and closes it again.
Future<List<String>> _languageOptions(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('language_selector')));
  await tester.pumpAndSettle();
  final options = [
    for (final tile in tester.widgetList<ListTile>(
      find.descendant(
        of: find.byKey(const Key('language_options')),
        matching: find.byType(ListTile),
      ),
    ))
      (tile.title! as Text).data!,
  ];
  await _back(tester);
  return options;
}

/// Every translation, led by the system setting, English and [device]'s own
/// language when the app translates it.
List<String> _allLanguages(AppStrings strings, {AppLanguage? device}) {
  final first = [
    AppLanguage.system,
    AppLanguage.english,
    if (device != null && device != AppLanguage.english) device,
  ];
  return [
    for (final language in [
      ...first,
      ...AppLanguage.values.where((language) => !first.contains(language)),
    ])
      language == AppLanguage.system
          ? strings.languageSystem
          : language.nativeName,
  ];
}

Future<void> _openSettings(WidgetTester tester, AppStrings strings) async {
  await tester.tap(find.byTooltip(strings.settings));
  await tester.pumpAndSettle();
  expect(find.byType(SettingsSheet), findsOneWidget);
  await tester.scrollUntilVisible(
    find.byKey(const Key('language_selector')),
    200,
    scrollable: find
        .descendant(
          of: find.byType(SettingsSheet),
          matching: find.byType(Scrollable),
        )
        .first,
  );
}

/// The system back button: closes a sheet or leaves a page.
Future<void> _back(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
}

void main() {
  tearDown(() => sl.reset());

  group('every translation', () {
    for (final language in AppLanguage.translated) {
      final code = language.languageCode!;

      testWidgets('${language.name} reads right on a small phone', (
        tester,
      ) async {
        // 360 × 740 logical pixels. An overflow anywhere fails the test.
        tester.view.physicalSize = const Size(1080, 2220);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        final strings = AppStrings.forLanguageCode(code);
        // Registered in forLanguageCode, not falling back to English.
        expect(strings.localeName.split('_').first, code);

        // A phone set to this language opens in it, in its direction.
        final harness = await bootApp(
          tester,
          localeName: code,
          before: (harness) {
            harness.people.seedPerson('Sara');
            // So the settings sheet lays out the reminder's time row too.
            harness.reminder.reminder = const DailyReminder(enabled: true);
          },
        );
        expect(
          find.widgetWithText(FloatingActionButton, strings.add),
          findsOneWidget,
        );
        expect(
          Directionality.of(tester.element(find.byType(Scaffold).first)),
          language.rightToLeft ? TextDirection.rtl : TextDirection.ltr,
        );

        await harness.expenses.addExpense(
          amount: 123456.78,
          categoryId: 'cat_bills',
          date: DateTime.now(),
          description: 'A rather long note about the evening out',
        );
        await sl<HomeCubit>().refresh();
        await tester.pumpAndSettle();
        // The transaction list sits below the month's cards.
        await tester.scrollUntilVisible(
          find.text('A rather long note about the evening out'),
          200,
          scrollable: find
              .descendant(
                of: find.byType(CustomScrollView),
                matching: find.byType(Scrollable),
              )
              .first,
        );

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(find.text(strings.newExpense), findsOneWidget);
        expect(find.text(strings.addExpense), findsOneWidget);
        await _back(tester);

        await tester.tap(find.byTooltip(strings.categories));
        await tester.pumpAndSettle();
        expect(
          find.text(strings.defaultCategoryName('cat_food')!),
          findsWidgets,
        );
        await _back(tester);

        await tester.tap(find.byTooltip(strings.search));
        await tester.pumpAndSettle();
        expect(find.text(strings.searchPrompt), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, 'rather long');
        await tester.pump(SearchCubit.typingPause);
        await tester.pumpAndSettle();
        expect(
          find.textContaining(strings.transactionCount(1)),
          findsOneWidget,
        );
        await _back(tester);

        await tester.tap(find.byTooltip(strings.recurringPayments));
        await tester.pumpAndSettle();
        expect(find.text(strings.noRecurringYet), findsOneWidget);
        await _back(tester);

        await tester.tap(
          find.widgetWithText(NavigationDestination, strings.analyses),
        );
        await tester.pumpAndSettle();
        expect(find.text(strings.askTitle), findsOneWidget);
        // The questions card comes first, so the charts sit below it.
        await tester.scrollUntilVisible(
          find.text(strings.byCategory),
          200,
          scrollable: find
              .ancestor(
                of: find.text(strings.askTitle),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(find.text(strings.byCategory), findsOneWidget);

        await tester.tap(
          find.widgetWithText(NavigationDestination, strings.people),
        );
        await tester.pumpAndSettle();
        expect(find.text('Sara'), findsOneWidget);

        await tester.tap(
          find.widgetWithText(NavigationDestination, strings.home),
        );
        await tester.pumpAndSettle();
        await _openSettings(tester, strings);
        expect(
          await _languageOptions(tester),
          _allLanguages(strings, device: language),
        );
      });
    }
  });

  group('the language picker', () {
    testWidgets('offers every translation on an English phone, English first', (
      tester,
    ) async {
      await bootApp(tester);
      final strings = AppStrings.forLanguageCode('en');
      await _openSettings(tester, strings);

      final options = await _languageOptions(tester);
      expect(options, _allLanguages(strings));
      expect(options.take(2), ['System', 'English']);
      expect(options, hasLength(AppLanguage.values.length));
    });

    testWidgets('puts the phone\'s own language right after English', (
      tester,
    ) async {
      await bootApp(tester, localeName: 'zh_CN');
      final strings = AppStrings.forLanguageCode('zh');
      await _openSettings(tester, strings);

      final options = await _languageOptions(tester);
      expect(options.take(3), [strings.languageSystem, 'English', '中文']);
      expect(options, _allLanguages(strings, device: AppLanguage.chinese));
    });

    testWidgets('an untranslated phone language falls back to English', (
      tester,
    ) async {
      await bootApp(tester, localeName: 'sw_KE');

      expect(find.text('Nothing recorded yet'), findsOneWidget);
      final strings = AppStrings.forLanguageCode('en');
      await _openSettings(tester, strings);
      expect(await _languageOptions(tester), _allLanguages(strings));
    });

    testWidgets('an English phone in Egypt can switch the app to Arabic', (
      tester,
    ) async {
      await bootApp(tester, localeName: 'en_EG');
      await _openSettings(tester, AppStrings.forLanguageCode('en'));

      await tester.tap(find.byKey(const Key('language_selector')));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('العربية'),
        100,
        scrollable: find
            .descendant(
              of: find.byKey(const Key('language_options')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.text('العربية'));
      await tester.pumpAndSettle();

      expect(sl<SettingsCubit>().state.settings.language, AppLanguage.arabic);
      // The selector now shows Arabic, and the sheet's own labels switched.
      expect(
        find.descendant(
          of: find.byKey(const Key('language_selector')),
          matching: find.text('العربية'),
        ),
        findsOneWidget,
      );
      expect(
        find.text(AppStrings.forLanguageCode('ar').language),
        findsOneWidget,
      );
    });
  });

  group('the settings sheet', () {
    for (final (localeName, code) in [('en_US', 'en'), ('ar_EG', 'ar')]) {
      testWidgets('closes from its back button ($code)', (tester) async {
        await bootApp(tester, localeName: localeName);
        final strings = AppStrings.forLanguageCode(code);
        await tester.tap(find.byTooltip(strings.settings));
        await tester.pumpAndSettle();
        expect(find.byType(SettingsSheet), findsOneWidget);

        await tester.tap(
          find.descendant(
            of: find.byType(SettingsSheet),
            matching: find.byType(BackButton),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SettingsSheet), findsNothing);
      });
    }
  });

  group('number and date formats follow the displayed language', () {
    test('an explicit choice uses its own formats', () {
      expect(
        SettingsCubit.formatsLocaleFor(AppLanguage.english, 'de_DE'),
        'en_US',
      );
      expect(SettingsCubit.formatsLocaleFor(AppLanguage.german, 'en_US'), 'de');
      expect(
        SettingsCubit.formatsLocaleFor(AppLanguage.persian, 'en_US'),
        'fa',
      );
    });

    test('the system setting keeps the phone\'s region when translated', () {
      expect(
        SettingsCubit.formatsLocaleFor(AppLanguage.system, 'pt_BR'),
        'pt_BR',
      );
      expect(
        SettingsCubit.formatsLocaleFor(AppLanguage.system, 'ar_EG'),
        'ar_EG',
      );
    });

    test('an untranslated phone language formats in English', () {
      expect(
        SettingsCubit.formatsLocaleFor(AppLanguage.system, 'sw_KE'),
        'en_US',
      );
    });
  });

  test('counts take each language\'s plural forms', () {
    const ru = AppStringsRu();
    expect(ru.expenseCount(1), '1 расход');
    expect(ru.expenseCount(3), '3 расхода');
    expect(ru.expenseCount(5), '5 расходов');
    expect(ru.expenseCount(21), '21 расход');
    expect(ru.expenseCount(12), '12 расходов');

    const pl = AppStringsPl();
    expect(pl.personCount(1), '1 osoba');
    expect(pl.personCount(2), '2 osoby');
    expect(pl.personCount(5), '5 osób');
    expect(pl.personCount(22), '22 osoby');

    const uk = AppStringsUk();
    expect(uk.paymentCount(4), '4 платежі');
    expect(uk.paymentCount(11), '11 платежів');

    // French treats 0 as singular; English does not.
    expect(const AppStringsFr().expenseCount(0), '0 dépense');
    expect(const AppStringsEn().expenseCount(0), '0 expenses');

    expect(const AppStringsUr().personCount(1), '1 شخص');
    expect(const AppStringsUr().personCount(3), '3 افراد');
    expect(const AppStringsJa().expenseCount(3), '支出 3 件');
  });

  test('language codes resolve with or without a region', () {
    expect(AppLanguage.fromCode('fr'), AppLanguage.french);
    expect(AppLanguage.fromCode('zh_Hans_CN'), AppLanguage.chinese);
    expect(AppLanguage.fromCode('pt-BR'), AppLanguage.portuguese);
    expect(AppLanguage.fromCode('sw'), isNull);
    expect(AppLanguage.fromCode(null), isNull);
    expect(AppLanguage.translated.where((language) => language.rightToLeft), [
      AppLanguage.arabic,
      AppLanguage.persian,
      AppLanguage.urdu,
    ]);
  });
}
