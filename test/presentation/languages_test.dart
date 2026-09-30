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

/// The labels the settings sheet's language picker offers, in order.
List<String> _languageOptions(WidgetTester tester) {
  final picker = tester.widget<SegmentedButton<AppLanguage>>(
    find.byType(SegmentedButton<AppLanguage>),
  );
  return [
    for (final segment in picker.segments) (segment.label! as Text).data!,
  ];
}

Future<void> _openSettings(WidgetTester tester, AppStrings strings) async {
  await tester.tap(find.byTooltip(strings.settings));
  await tester.pumpAndSettle();
  expect(find.byType(SettingsSheet), findsOneWidget);
  await tester.scrollUntilVisible(
    find.byType(SegmentedButton<AppLanguage>),
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
        expect(_languageOptions(tester), [
          strings.languageSystem,
          'English',
          if (language != AppLanguage.english) language.nativeName,
        ]);
      });
    }
  });

  group('the language picker', () {
    testWidgets('offers only the system setting and English on an English '
        'phone', (tester) async {
      await bootApp(tester);
      final strings = AppStrings.forLanguageCode('en');
      await _openSettings(tester, strings);

      expect(_languageOptions(tester), ['System', 'English']);
    });

    testWidgets('adds the phone\'s own language, named in that language', (
      tester,
    ) async {
      await bootApp(tester, localeName: 'zh_CN');
      final strings = AppStrings.forLanguageCode('zh');
      await _openSettings(tester, strings);

      expect(_languageOptions(tester), [
        strings.languageSystem,
        'English',
        '中文',
      ]);
    });

    testWidgets('an untranslated phone language falls back to English', (
      tester,
    ) async {
      await bootApp(tester, localeName: 'sw_KE');

      expect(find.text('Nothing recorded yet'), findsOneWidget);
      await _openSettings(tester, AppStrings.forLanguageCode('en'));
      expect(_languageOptions(tester), ['System', 'English']);
    });

    testWidgets('keeps an earlier choice listed so it never disappears', (
      tester,
    ) async {
      await bootApp(tester, localeName: 'fr_FR');
      await sl<SettingsCubit>().setLanguage(AppLanguage.arabic);
      await tester.pumpAndSettle();
      final strings = AppStrings.forLanguageCode('ar');
      await _openSettings(tester, strings);

      expect(_languageOptions(tester), [
        strings.languageSystem,
        'English',
        'Français',
        'العربية',
      ]);

      // Picking the phone's language switches the whole app to it.
      await tester.tap(find.text('Français'));
      await tester.pumpAndSettle();
      expect(sl<SettingsCubit>().state.settings.language, AppLanguage.french);
      expect(
        find.text(AppStrings.forLanguageCode('fr').language),
        findsOneWidget,
      );
    });
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
