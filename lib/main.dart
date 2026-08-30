import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/di/injection.dart';
import 'features/categories/presentation/cubit/categories_cubit.dart';
import 'features/expenses/presentation/cubit/home_cubit.dart';
import 'features/quick_expense/presentation/quick_add_app.dart';
import 'features/quick_expense/presentation/quick_add_launch.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Month and day names for every supported language.
  await initializeDateFormatting();

  // Everything is on-device: open the local database and read the stored
  // preferences before the first frame so the app opens straight into data.
  configureDependencies();
  await sl<AppDatabase>().database;

  final platform = WidgetsBinding.instance.platformDispatcher;
  await sl<SettingsCubit>().load(localeName: platform.locale.toString());

  // The home screen widget boots the engine on its own route. That path shows
  // the quick-add dialog alone, so it skips everything the home screen needs.
  final launch = QuickAddLaunch.tryParse(platform.defaultRouteName);
  if (launch != null) {
    await sl<CategoriesCubit>().load();
    runApp(QuickAddApp(categoryId: launch.categoryId));
    return;
  }

  await Future.wait([sl<CategoriesCubit>().load(), sl<HomeCubit>().load()]);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyBudgetApp());
}
