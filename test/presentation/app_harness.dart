import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_budget/app.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/app_lock/domain/repositories/app_lock_repository.dart';
import 'package:my_budget/features/assistant/domain/repositories/assistant_repository.dart';
import 'package:my_budget/features/app_lock/presentation/cubit/app_lock_cubit.dart';
import 'package:my_budget/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_budget/features/budgets/domain/repositories/budget_repository.dart';
import 'package:my_budget/features/budgets/presentation/cubit/budget_cubit.dart';
import 'package:my_budget/features/categories/domain/repositories/category_repository.dart';
import 'package:my_budget/features/data_management/domain/repositories/data_management_repository.dart';
import 'package:my_budget/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/domain/repositories/expense_repository.dart';
import 'package:my_budget/features/expenses/presentation/cubit/home_cubit.dart';
import 'package:my_budget/features/people/domain/repositories/people_repository.dart';
import 'package:my_budget/features/quick_expense/domain/repositories/quick_expense_widget_repository.dart';
import 'package:my_budget/features/quick_expense/presentation/quick_add_app.dart';
import 'package:my_budget/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:my_budget/features/recurring/presentation/cubit/recurring_cubit.dart';
import 'package:my_budget/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:my_budget/features/reminders/presentation/cubit/reminder_cubit.dart';
import 'package:my_budget/features/reminders/presentation/reminder_texts.dart';
import 'package:my_budget/features/settings/domain/repositories/settings_repository.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:my_budget/features/sync/domain/repositories/sync_repository.dart';

import 'fakes.dart';

/// The in-memory doubles behind a booted app, so a test can inspect what the
/// app stored or drew on the home screen widget.
class AppHarness {
  AppHarness({
    required this.categories,
    required this.expenses,
    required this.settings,
    required this.widget,
    required this.auth,
    required this.sync,
    required this.files,
    required this.budgets,
    required this.recurring,
    required this.people,
    required this.reminder,
    required this.appLock,
    required this.assistant,
  });

  final FakeCategoryRepository categories;
  final FakeExpenseRepository expenses;
  final FakeSettingsRepository settings;
  final FakeQuickExpenseWidgetRepository widget;
  final FakeAuthRepository auth;
  final FakeSyncRepository sync;
  final FakeDataManagementRepository files;
  final FakeBudgetRepository budgets;
  final FakeRecurringRepository recurring;
  final FakePeopleRepository people;
  final FakeReminderRepository reminder;
  final FakeAppLockRepository appLock;
  final FakeAssistantRepository assistant;
}

/// Boots the real widget tree and cubits over in-memory repositories.
///
/// Widget tests run inside a fake-async zone where the real database's
/// background isolate never completes; the SQL itself is covered by the
/// integration tests in `test/data`.
///
/// [before] runs once the fakes exist but before anything loads, so a test
/// can set up what the phone already held when the app opened.
Future<AppHarness> bootApp(
  WidgetTester tester, {
  String localeName = 'en_US',
  void Function(AppHarness harness)? before,
}) async {
  final harness = await _bootDependencies(
    tester,
    localeName: localeName,
    before: before,
  );

  await tester.pumpWidget(const MyBudgetApp());
  await tester.pumpAndSettle();

  return harness;
}

/// Registers the in-memory repositories and loads the cubits both entry
/// points need.
Future<AppHarness> _bootDependencies(
  WidgetTester tester, {
  required String localeName,
  void Function(AppHarness harness)? before,
}) async {
  await initializeDateFormatting();
  await sl.reset();

  // Pretend the device is set to this locale, so "system language" resolves
  // the same way it would on a real phone.
  final parts = localeName.split('_');
  tester.platformDispatcher.localesTestValue = [
    Locale(parts.first, parts.length > 1 ? parts[1] : null),
  ];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);

  final categories = FakeCategoryRepository();
  final expenses = FakeExpenseRepository(categories);
  final settings = FakeSettingsRepository();
  final widget = FakeQuickExpenseWidgetRepository();
  final auth = FakeAuthRepository();
  final sync = FakeSyncRepository();
  final files = FakeDataManagementRepository();
  final budgets = FakeBudgetRepository();
  final recurring = FakeRecurringRepository(categories, expenses);
  final people = FakePeopleRepository();
  final reminder = FakeReminderRepository();
  final appLock = FakeAppLockRepository();
  final assistant = FakeAssistantRepository();
  final harness = AppHarness(
    categories: categories,
    expenses: expenses,
    settings: settings,
    widget: widget,
    auth: auth,
    sync: sync,
    files: files,
    budgets: budgets,
    recurring: recurring,
    people: people,
    reminder: reminder,
    appLock: appLock,
    assistant: assistant,
  );
  before?.call(harness);

  sl
    ..registerLazySingleton<CategoryRepository>(() => categories)
    ..registerLazySingleton<ExpenseRepository>(() => expenses)
    ..registerLazySingleton<SettingsRepository>(() => settings)
    ..registerLazySingleton<QuickExpenseWidgetRepository>(() => widget)
    ..registerLazySingleton<AuthRepository>(() => auth)
    ..registerLazySingleton<SyncRepository>(() => sync)
    ..registerLazySingleton<DataManagementRepository>(() => files)
    ..registerLazySingleton<BudgetRepository>(() => budgets)
    ..registerLazySingleton<RecurringRepository>(() => recurring)
    ..registerLazySingleton<PeopleRepository>(() => people)
    ..registerLazySingleton<ReminderRepository>(() => reminder)
    ..registerLazySingleton<AppLockRepository>(() => appLock)
    ..registerLazySingleton<AssistantRepository>(() => assistant);
  configureDependencies();

  // The same order as main.dart: due automatic payments first.
  await sl<SettingsCubit>().load(localeName: localeName);
  await sl<AppLockCubit>().load();
  await sl<RecurringCubit>().load();
  await Future.wait([
    sl<CategoriesCubit>().load(),
    sl<HomeCubit>().load(),
    sl<BudgetCubit>().load(Month.current()),
  ]);
  await sl<ReminderCubit>().load(currentReminderMessage());

  return harness;
}

/// Boots what the home screen widget opens: the quick-add dialog on its own,
/// with no home screen behind it.
Future<AppHarness> bootQuickAdd(
  WidgetTester tester, {
  String? categoryId,
  String localeName = 'en_US',
}) async {
  final harness = await _bootDependencies(tester, localeName: localeName);
  await tester.pumpWidget(QuickAddApp(categoryId: categoryId));
  await tester.pumpAndSettle();
  return harness;
}

/// Records what the app asks the Android window to do, so a test can tell
/// whether the quick-add activity was closed.
List<String> recordPlatformCalls(WidgetTester tester) {
  final calls = <String>[];
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    calls.add(call.method);
    return null;
  });
  addTearDown(
    () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
  );
  return calls;
}

/// Scrolls the home screen until [finder] shows. The period bar and the
/// summary cards come first, so on the 800 × 600 test screen the cards and
/// transactions below them start out of view.
Future<void> scrollHomeTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    150,
    scrollable: find
        .descendant(
          of: find.byType(CustomScrollView),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.pumpAndSettle();
}
