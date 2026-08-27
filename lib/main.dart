import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/di/injection.dart';
import 'features/categories/presentation/cubit/categories_cubit.dart';
import 'features/expenses/presentation/cubit/home_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Month and day names for every supported language.
  await initializeDateFormatting();

  // Everything is on-device: open the local database and read the stored
  // preferences before the first frame so the app opens straight into data.
  configureDependencies();
  await sl<AppDatabase>().database;

  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  await sl<SettingsCubit>().load(localeName: locale.toString());
  await Future.wait([sl<CategoriesCubit>().load(), sl<HomeCubit>().load()]);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyBudgetApp());
}
