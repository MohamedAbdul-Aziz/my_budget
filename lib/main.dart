import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/supabase_config.dart';
import 'core/database/app_database.dart';
import 'core/di/injection.dart';
import 'features/app_lock/presentation/cubit/app_lock_cubit.dart';
import 'features/budgets/presentation/cubit/budget_cubit.dart';
import 'features/categories/presentation/cubit/categories_cubit.dart';
import 'features/expenses/domain/entities/month.dart';
import 'features/expenses/presentation/cubit/home_cubit.dart';
import 'features/quick_expense/presentation/quick_add_app.dart';
import 'features/quick_expense/presentation/quick_add_launch.dart';
import 'features/recurring/presentation/cubit/recurring_cubit.dart';
import 'features/reminders/presentation/cubit/reminder_cubit.dart';
import 'features/reminders/presentation/reminder_texts.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Month and day names for every supported language.
  await initializeDateFormatting();

  // Only restores a saved session from local storage, so it works offline and
  // does not delay the first frame on a network call.
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

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

  // Read before the first frame, so a locked app never shows a glimpse of
  // the data behind the lock. The quick-add dialog above is not locked: it
  // only adds an expense and shows nothing already recorded.
  await sl<AppLockCubit>().load();

  // Automatic recurring payments that fell due while the app was closed are
  // logged first, so the month below already has them.
  await sl<RecurringCubit>().load();

  // The budget card is read up front too, so it does not pop in under the
  // month total a moment after the first frame.
  await Future.wait([
    sl<CategoriesCubit>().load(),
    sl<HomeCubit>().load(),
    sl<BudgetCubit>().load(Month.current()),
  ]);

  // Scheduled again at every launch, in case the phone moved time zone. The
  // first frame does not wait for it: only the settings sheet shows it.
  unawaited(sl<ReminderCubit>().load(currentReminderMessage()));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyBudgetApp());
}
