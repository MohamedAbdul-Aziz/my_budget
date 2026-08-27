import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_budget/app.dart';
import 'package:my_budget/core/di/injection.dart';
import 'package:my_budget/features/categories/domain/repositories/category_repository.dart';
import 'package:my_budget/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:my_budget/features/expenses/domain/repositories/expense_repository.dart';
import 'package:my_budget/features/expenses/presentation/cubit/home_cubit.dart';
import 'package:my_budget/features/settings/domain/repositories/settings_repository.dart';
import 'package:my_budget/features/settings/presentation/cubit/settings_cubit.dart';

import 'fakes.dart';

/// Boots the real widget tree and cubits over in-memory repositories.
///
/// Widget tests run inside a fake-async zone where the real database's
/// background isolate never completes; the SQL itself is covered by the
/// integration tests in `test/data`.
Future<void> bootApp(WidgetTester tester, {String localeName = 'en_US'}) async {
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
  sl
    ..registerLazySingleton<CategoryRepository>(() => categories)
    ..registerLazySingleton<ExpenseRepository>(
      () => FakeExpenseRepository(categories),
    )
    ..registerLazySingleton<SettingsRepository>(FakeSettingsRepository.new);
  configureDependencies();

  await sl<SettingsCubit>().load(localeName: localeName);
  await Future.wait([sl<CategoriesCubit>().load(), sl<HomeCubit>().load()]);

  await tester.pumpWidget(const MyBudgetApp());
  await tester.pumpAndSettle();
}
