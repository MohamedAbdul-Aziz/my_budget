import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_budget/app.dart';
import 'package:my_budget/core/config/supabase_config.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/l10n/app_strings.dart';
import 'package:my_budget/features/app_lock/presentation/cubit/app_lock_cubit.dart';
import 'package:my_budget/features/budgets/domain/repositories/budget_repository.dart';
import 'package:my_budget/features/budgets/presentation/cubit/budget_cubit.dart';
import 'package:my_budget/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/domain/repositories/expense_repository.dart';
import 'package:my_budget/features/expenses/presentation/cubit/home_cubit.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction_type.dart';
import 'package:my_budget/features/people/domain/repositories/people_repository.dart';
import 'package:my_budget/features/recurring/domain/entities/recurrence_frequency.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_mode.dart';
import 'package:my_budget/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:my_budget/features/recurring/presentation/cubit/recurring_cubit.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/domain/repositories/settings_repository.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Takes the Play Store screenshots: the real app over an in-memory database
/// filled with a believable few months, in the language of the Play locale
/// passed as `--dart-define=STORE_LOCALE=<code>` (e.g. `ar`, `pt-BR`).
///
/// Run it through `scripts/store_screenshots.sh`, which saves the images into
/// `fastlane/metadata/android/<locale>/images/phoneScreenshots/`.
const _playLocale = String.fromEnvironment(
  'STORE_LOCALE',
  defaultValue: 'en-US',
);

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('store screenshots', (tester) async {
    final demo = _demos[_playLocale];
    if (demo == null) fail('Unknown STORE_LOCALE $_playLocale');

    // A 1080x1920 phone, drawn the Android way even when this runs on a
    // desktop: Play rejects screenshots longer than twice their width.
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    tester.view
      ..physicalSize = const Size(1080, 1920)
      ..devicePixelRatio = _pixelRatio;
    addTearDown(tester.view.reset);

    // The same boot as main.dart, over a fresh in-memory database.
    await initializeDateFormatting();
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
    configureDependencies(database: AppDatabase(inMemory: true));
    await sl<AppDatabase>().database;
    await sl<SettingsRepository>().saveLanguage(demo.language);
    await _seed(demo);

    await sl<SettingsCubit>().load(localeName: demo.localeName);
    await sl<AppLockCubit>().load();
    await sl<RecurringCubit>().load();
    await Future.wait([
      sl<CategoriesCubit>().load(),
      sl<HomeCubit>().load(),
      sl<BudgetCubit>().load(Month.current()),
    ]);

    await tester.pumpWidget(
      RepaintBoundary(key: _screen, child: const MyBudgetApp()),
    );
    await _settle(tester);
    // Early in a month there is little to show yet, so show the last one.
    await sl<HomeCubit>().selectMonth(_shownMonth());
    await _settle(tester);

    final strings = AppStrings.forLanguageCode(demo.language.languageCode);

    await _shoot(binding, tester, '1_home');

    await tester.tap(find.byIcon(Icons.insights_outlined));
    await _settle(tester);
    await _shoot(binding, tester, '2_analyses');

    await tester.tap(find.byIcon(Icons.people_outline_rounded));
    await _settle(tester);
    await _shoot(binding, tester, '3_people');

    await tester.tap(find.byIcon(Icons.receipt_long_outlined));
    await _settle(tester);
    await tester.tap(find.byTooltip(strings.recurringPayments));
    await _settle(tester);
    await _shoot(binding, tester, '4_recurring');

    await tester.pageBack();
    await _settle(tester);
    await sl<SettingsCubit>().setThemeMode(AppThemeMode.dark);
    await _settle(tester);
    await _shoot(binding, tester, '5_home_dark');

    debugDefaultTargetPlatformOverride = null;
  });
}

const _pixelRatio = 2.625;
final _screen = GlobalKey();

/// Captures the app as a PNG and hands it to the driver the same way
/// `takeScreenshot` does, which only works on Android and iOS. Rendering it
/// here works on a desktop too and leaves out the system bars.
Future<void> _shoot(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
  String name,
) async {
  // Notices such as "payments were logged automatically" would cover the
  // screen.
  for (final messenger in tester.stateList<ScaffoldMessengerState>(
    find.byType(ScaffoldMessenger),
  )) {
    messenger.clearSnackBars();
  }
  await _settle(tester);

  final boundary =
      _screen.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: _pixelRatio);
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  final screenshots = (binding.reportData ??= {})['screenshots'] ??= [];
  (screenshots as List<Object?>).add({
    'screenshotName': name,
    'bytes': png!.buffer.asUint8List().toList(),
  });
}

/// Waits for animations to finish, without hanging on one that never does.
Future<void> _settle(WidgetTester tester) async {
  try {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
  } on FlutterError {
    await tester.pump(const Duration(seconds: 1));
  }
}

/// This month once half of it has passed, otherwise last month, so the
/// screenshots always show a month with plenty in it.
Month _shownMonth() {
  final now = DateTime.now();
  return now.day >= 15 ? Month.fromDate(now) : Month.fromDate(now).previous;
}

/// A few months of spending, a budget, recurring payments and people, in
/// amounts that look natural in the locale's currency.
Future<void> _seed(_Demo demo) async {
  final expenses = sl<ExpenseRepository>();
  final now = DateTime.now();
  double money(double amount) => (amount * demo.scale).roundToDouble();

  final shown = _shownMonth();

  // The month on screen, never in the future.
  const shownMonth = [
    (2, 'cat_food', 42.5),
    (3, 'cat_transport', 18.0),
    (5, 'cat_shopping', 64.9),
    (6, 'cat_food', 27.3),
    (8, 'cat_health', 35.0),
    (9, 'cat_food', 56.8),
    (11, 'cat_transport', 12.5),
    (12, 'cat_entertainment', 24.0),
    (14, 'cat_food', 38.2),
    (16, 'cat_shopping', 89.0),
    (18, 'cat_food', 21.4),
    (19, 'cat_transport', 15.0),
    (21, 'cat_work', 29.9),
    (23, 'cat_food', 47.6),
  ];
  final isCurrent = shown == Month.fromDate(now);
  for (final (day, category, amount) in shownMonth) {
    await expenses.addExpense(
      amount: money(amount),
      categoryId: category,
      date: DateTime(
        shown.year,
        shown.month,
        isCurrent ? math.min(day, now.day) : day,
      ),
    );
  }

  // Earlier months, for the six-month trend and the comparison card.
  const earlier = [1.08, 0.92, 1.15, 0.97, 1.03];
  for (var back = 1; back <= earlier.length; back++) {
    final factor = earlier[back - 1];
    for (final (day, category, amount) in const [
      (4, 'cat_food', 180.0),
      (12, 'cat_food', 160.0),
      (7, 'cat_transport', 85.0),
      (15, 'cat_shopping', 140.0),
      (20, 'cat_entertainment', 45.0),
      (24, 'cat_health', 40.0),
    ]) {
      await expenses.addExpense(
        amount: money(amount * factor),
        categoryId: category,
        date: DateTime(shown.year, shown.month - back, day),
      );
    }
  }

  final budgets = sl<BudgetRepository>();
  await budgets.saveMonthlyLimit(money(1800));
  await budgets.saveCategoryLimit('cat_food', money(400));

  // The automatic ones started five months back, so they catch up on load
  // and fill every month with rent, salary and the subscription. The one to
  // confirm started this month and falls due in a few days: upcoming.
  final recurring = sl<RecurringRepository>();
  final longAgo = DateTime(shown.year, shown.month - 5, 1);
  final thisMonth = DateTime(now.year, now.month, 1);
  final soon = math.min(now.day + 5, 28);
  for (final (title, amount, category, day, mode, started) in [
    (demo.rent, 900.0, 'cat_bills', 1, RecurringMode.autoDeduct, longAgo),
    (demo.salary, 3200.0, 'cat_salary', 1, RecurringMode.autoDeduct, longAgo),
    (
      demo.streaming,
      12.0,
      'cat_entertainment',
      1,
      RecurringMode.autoDeduct,
      longAgo,
    ),
    (demo.internet, 40.0, 'cat_bills', soon, RecurringMode.reminder, thisMonth),
  ]) {
    await recurring.createRecurring(
      title: title,
      amount: money(amount),
      categoryId: category,
      frequency: RecurrenceFrequency.monthly,
      dueDay: day,
      mode: mode,
      startsOn: started,
    );
  }

  final people = sl<PeopleRepository>();
  final colors = [0xFF1E88E5, 0xFFD81B60, 0xFF43A047];
  for (var i = 0; i < demo.people.length; i++) {
    final added = await people.addPerson(
      name: demo.people[i],
      colorValue: colors[i],
    );
    final person = switch (added) {
      Success(:final data) => data,
      ResultFailure(:final failure) => fail('$failure'),
    };
    final debts = switch (i) {
      0 => [
        (PersonTransactionType.iPaidForThem, 45.0),
        (PersonTransactionType.theyPaidForMe, 20.0),
      ],
      1 => [(PersonTransactionType.theyPaidForMe, 60.0)],
      _ => [(PersonTransactionType.iPaidForThem, 30.0)],
    };
    for (final (type, amount) in debts) {
      await people.addTransaction(
        personId: person.id,
        amount: money(amount),
        type: type,
        date: now.subtract(Duration(days: 3 + i)),
      );
    }
    // The last one is settled, so all three balance states show.
    if (i == demo.people.length - 1) await people.settleUp(person.id);
  }
}

/// What the demo data is called in each store language: user-typed text,
/// so it is not part of the app's translations.
class _Demo {
  const _Demo(
    this.language,
    this.localeName,
    this.scale, {
    required this.rent,
    required this.internet,
    required this.salary,
    required this.streaming,
    required this.people,
  });

  final AppLanguage language;

  /// Picks the currency symbol and number format, as the phone's locale would.
  final String localeName;

  /// Multiplies the amounts so they look like prices in the local currency.
  final double scale;

  final String rent;
  final String internet;
  final String salary;
  final String streaming;
  final List<String> people;
}

const _demos = <String, _Demo>{
  'en-US': _Demo(
    AppLanguage.english,
    'en_US',
    1,
    rent: 'Rent',
    internet: 'Internet',
    salary: 'Salary',
    streaming: 'Streaming',
    people: ['Sarah', 'Omar', 'Alex'],
  ),
  'ar': _Demo(
    AppLanguage.arabic,
    'ar_EG',
    10,
    rent: 'الإيجار',
    internet: 'الإنترنت',
    salary: 'الراتب',
    streaming: 'اشتراك الأفلام',
    people: ['سارة', 'عمر', 'أحمد'],
  ),
  'zh-CN': _Demo(
    AppLanguage.chinese,
    'zh_CN',
    5,
    rent: '房租',
    internet: '宽带',
    salary: '工资',
    streaming: '视频会员',
    people: ['李娜', '王强', '张伟'],
  ),
  'es-ES': _Demo(
    AppLanguage.spanish,
    'es_ES',
    1,
    rent: 'Alquiler',
    internet: 'Internet',
    salary: 'Sueldo',
    streaming: 'Streaming',
    people: ['Lucía', 'Carlos', 'Marta'],
  ),
  'fr-FR': _Demo(
    AppLanguage.french,
    'fr_FR',
    1,
    rent: 'Loyer',
    internet: 'Internet',
    salary: 'Salaire',
    streaming: 'Streaming',
    people: ['Camille', 'Lucas', 'Julie'],
  ),
  'pt-BR': _Demo(
    AppLanguage.portuguese,
    'pt_BR',
    5,
    rent: 'Aluguel',
    internet: 'Internet',
    salary: 'Salário',
    streaming: 'Streaming',
    people: ['Ana', 'Pedro', 'Lucas'],
  ),
  'ru-RU': _Demo(
    AppLanguage.russian,
    'ru_RU',
    50,
    rent: 'Аренда',
    internet: 'Интернет',
    salary: 'Зарплата',
    streaming: 'Подписка',
    people: ['Анна', 'Иван', 'Олег'],
  ),
  'de-DE': _Demo(
    AppLanguage.german,
    'de_DE',
    1,
    rent: 'Miete',
    internet: 'Internet',
    salary: 'Gehalt',
    streaming: 'Streaming',
    people: ['Anna', 'Lukas', 'Jonas'],
  ),
  'ja-JP': _Demo(
    AppLanguage.japanese,
    'ja_JP',
    100,
    rent: '家賃',
    internet: 'ネット回線',
    salary: '給料',
    streaming: '動画配信',
    people: ['さくら', '健太', '美咲'],
  ),
  'ko-KR': _Demo(
    AppLanguage.korean,
    'ko_KR',
    1000,
    rent: '월세',
    internet: '인터넷',
    salary: '월급',
    streaming: 'OTT 구독',
    people: ['지민', '민수', '서연'],
  ),
  'tr-TR': _Demo(
    AppLanguage.turkish,
    'tr_TR',
    30,
    rent: 'Kira',
    internet: 'İnternet',
    salary: 'Maaş',
    streaming: 'Dizi aboneliği',
    people: ['Elif', 'Mehmet', 'Can'],
  ),
  'id': _Demo(
    AppLanguage.indonesian,
    'id_ID',
    10000,
    rent: 'Sewa',
    internet: 'Internet',
    salary: 'Gaji',
    streaming: 'Streaming',
    people: ['Rina', 'Budi', 'Dewi'],
  ),
  'it-IT': _Demo(
    AppLanguage.italian,
    'it_IT',
    1,
    rent: 'Affitto',
    internet: 'Internet',
    salary: 'Stipendio',
    streaming: 'Streaming',
    people: ['Giulia', 'Marco', 'Luca'],
  ),
  'fa': _Demo(
    AppLanguage.persian,
    'fa_IR',
    10000,
    rent: 'اجاره',
    internet: 'اینترنت',
    salary: 'حقوق',
    streaming: 'اشتراک فیلم',
    people: ['سارا', 'علی', 'مریم'],
  ),
  'ur': _Demo(
    AppLanguage.urdu,
    'ur_PK',
    200,
    rent: 'کرایہ',
    internet: 'انٹرنیٹ',
    salary: 'تنخواہ',
    streaming: 'اسٹریمنگ',
    people: ['عائشہ', 'علی', 'حمزہ'],
  ),
  'vi': _Demo(
    AppLanguage.vietnamese,
    'vi_VN',
    20000,
    rent: 'Tiền nhà',
    internet: 'Internet',
    salary: 'Lương',
    streaming: 'Xem phim',
    people: ['Lan', 'Minh', 'Huy'],
  ),
  'pl-PL': _Demo(
    AppLanguage.polish,
    'pl_PL',
    4,
    rent: 'Czynsz',
    internet: 'Internet',
    salary: 'Pensja',
    streaming: 'Streaming',
    people: ['Anna', 'Piotr', 'Kasia'],
  ),
  'nl-NL': _Demo(
    AppLanguage.dutch,
    'nl_NL',
    1,
    rent: 'Huur',
    internet: 'Internet',
    salary: 'Salaris',
    streaming: 'Streaming',
    people: ['Emma', 'Daan', 'Sanne'],
  ),
  'uk': _Demo(
    AppLanguage.ukrainian,
    'uk_UA',
    40,
    rent: 'Оренда',
    internet: 'Інтернет',
    salary: 'Зарплата',
    streaming: 'Підписка',
    people: ['Олена', 'Тарас', 'Ірина'],
  ),
  'ms': _Demo(
    AppLanguage.malay,
    'ms_MY',
    4,
    rent: 'Sewa',
    internet: 'Internet',
    salary: 'Gaji',
    streaming: 'Penstriman',
    people: ['Aisyah', 'Hafiz', 'Mei Ling'],
  ),
};
