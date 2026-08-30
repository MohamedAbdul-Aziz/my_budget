import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_budget/app.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/categories/domain/repositories/category_repository.dart';
import 'package:my_budget/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:my_budget/features/expenses/domain/repositories/expense_repository.dart';
import 'package:my_budget/features/expenses/presentation/cubit/home_cubit.dart';
import 'package:my_budget/features/quick_expense/domain/entities/quick_add_request.dart';
import 'package:my_budget/features/quick_expense/domain/repositories/quick_expense_widget_repository.dart';
import 'package:my_budget/features/settings/domain/repositories/settings_repository.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'fakes.dart';

/// The in-memory doubles behind a booted app, so a test can inspect what the
/// app stored or drew on the home screen widget.
class AppHarness {
  AppHarness({
    required this.categories,
    required this.expenses,
    required this.settings,
    required this.widget,
  });

  final FakeCategoryRepository categories;
  final FakeExpenseRepository expenses;
  final FakeSettingsRepository settings;
  final FakeQuickExpenseWidgetRepository widget;
}

/// Boots the real widget tree and cubits over in-memory repositories.
///
/// Widget tests run inside a fake-async zone where the real database's
/// background isolate never completes; the SQL itself is covered by the
/// integration tests in `test/data`.
Future<AppHarness> bootApp(
  WidgetTester tester, {
  String localeName = 'en_US',
  QuickAddRequest? launchRequest,
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
  final widget = FakeQuickExpenseWidgetRepository()
    ..launchRequest = launchRequest;
  addTearDown(widget.dispose);

  sl
    ..registerLazySingleton<CategoryRepository>(() => categories)
    ..registerLazySingleton<ExpenseRepository>(() => expenses)
    ..registerLazySingleton<SettingsRepository>(() => settings)
    ..registerLazySingleton<QuickExpenseWidgetRepository>(() => widget);
  configureDependencies();

  await sl<SettingsCubit>().load(localeName: localeName);
  await Future.wait([sl<CategoriesCubit>().load(), sl<HomeCubit>().load()]);

  await tester.pumpWidget(const MyBudgetApp());
  await tester.pumpAndSettle();

  return AppHarness(
    categories: categories,
    expenses: expenses,
    settings: settings,
    widget: widget,
  );
}
