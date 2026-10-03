import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/analyses/presentation/cubit/analyses_cubit.dart';
import 'features/app_lock/presentation/cubit/app_lock_cubit.dart';
import 'features/app_lock/presentation/widgets/app_lock_gate.dart';
import 'features/auth/presentation/cubit/account_cubit.dart';
import 'features/budgets/presentation/cubit/budget_cubit.dart';
import 'features/data_management/presentation/cubit/data_management_cubit.dart';
import 'features/data_management/presentation/cubit/data_management_state.dart';
import 'features/categories/presentation/cubit/categories_cubit.dart';
import 'features/categories/presentation/cubit/categories_state.dart';
import 'features/expenses/presentation/cubit/home_cubit.dart';
import 'features/expenses/presentation/cubit/home_state.dart';
import 'features/people/presentation/cubit/people_cubit.dart';
import 'features/quick_expense/presentation/widgets/quick_expense_bridge.dart';
import 'features/recurring/presentation/cubit/recurring_cubit.dart';
import 'features/recurring/presentation/cubit/recurring_state.dart';
import 'features/reminders/presentation/cubit/reminder_cubit.dart';
import 'features/reminders/presentation/reminder_texts.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';
import 'features/shell/presentation/app_shell.dart';
import 'features/sync/presentation/cubit/auto_backup_cubit.dart';
import 'features/sync/presentation/cubit/auto_backup_state.dart';
import 'features/sync/presentation/cubit/sync_cubit.dart';
import 'features/sync/presentation/cubit/sync_state.dart';
import 'features/sync/presentation/widgets/auto_backup_bridge.dart';

/// Hosts the long-lived cubits. They are resolved from the service locator
/// with `.value`, so navigating away never closes them.
class MyBudgetApp extends StatelessWidget {
  const MyBudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<SettingsCubit>()),
        BlocProvider.value(value: sl<CategoriesCubit>()),
        BlocProvider.value(value: sl<HomeCubit>()),
        BlocProvider.value(value: sl<AccountCubit>()),
        BlocProvider.value(value: sl<SyncCubit>()),
        BlocProvider.value(value: sl<AnalysesCubit>()),
        BlocProvider.value(value: sl<BudgetCubit>()),
        BlocProvider.value(value: sl<DataManagementCubit>()),
        BlocProvider.value(value: sl<RecurringCubit>()),
        BlocProvider.value(value: sl<PeopleCubit>()),
        BlocProvider.value(value: sl<ReminderCubit>()),
        BlocProvider.value(value: sl<AutoBackupCubit>()),
        BlocProvider.value(value: sl<AppLockCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          // A restore or an import rewrites the database underneath the other
          // cubits, so they read it again. The home screen widget and the
          // analyses follow HomeCubit on their own.
          BlocListener<SyncCubit, SyncState>(
            listenWhen: (_, state) =>
                state is SyncSucceeded && state.kind == SyncKind.restore,
            listener: (context, _) => _reloadData(context),
          ),
          BlocListener<DataManagementCubit, DataManagementState>(
            listenWhen: (_, state) =>
                state is DataImported && state.changes > 0,
            listener: (context, _) => _reloadData(context),
          ),
          // Analyses and budgets follow the home screen: its selected month,
          // and every change to that month's expenses.
          BlocListener<HomeCubit, HomeState>(
            listenWhen: (previous, current) =>
                current is HomeReady &&
                (previous is! HomeReady ||
                    previous.overview != current.overview ||
                    previous.months != current.months),
            listener: (context, state) {
              final month = (state as HomeReady).month;
              context.read<AnalysesCubit>().load(month);
              context.read<BudgetCubit>().load(month);
            },
          ),
          // The budgets page lists every category, so it follows a category
          // being added, renamed or deleted. Recurring payments show theirs,
          // and a deleted one moves them to Other.
          BlocListener<CategoriesCubit, CategoriesState>(
            listenWhen: (previous, current) =>
                current is CategoriesReady &&
                (previous is! CategoriesReady ||
                    previous.categories != current.categories),
            listener: (context, _) {
              context.read<BudgetCubit>().refresh();
              context.read<RecurringCubit>().refresh();
            },
          ),
          // A recurring payment marked paid, taken back, or logged on its
          // own is a transaction, so the month reads its transactions
          // again. Analyses, budgets and the home screen widget follow.
          BlocListener<RecurringCubit, RecurringState>(
            listenWhen: (previous, current) =>
                current is RecurringReady &&
                current.ledgerVersion !=
                    switch (previous) {
                      RecurringReady(:final ledgerVersion) => ledgerVersion,
                      _ => 0,
                    },
            listener: (context, _) => context.read<HomeCubit>().refresh(),
          ),
          // Turning automatic backup on uploads what is waiting right away,
          // rather than the next time the app is left.
          BlocListener<AutoBackupCubit, AutoBackupState>(
            listenWhen: (previous, current) =>
                current is AutoBackupReady &&
                current.enabled &&
                !(previous is AutoBackupReady && previous.enabled),
            listener: (context, _) => context.read<SyncCubit>().autoBackUp(),
          ),
          // The scheduled reminder carries its own text, so it is written
          // again in the new language.
          BlocListener<SettingsCubit, SettingsState>(
            listenWhen: (previous, current) =>
                previous.languageCode != current.languageCode,
            listener: (context, state) => context.read<ReminderCubit>().load(
              reminderMessage(AppStrings.forLanguageCode(state.languageCode)),
            ),
          ),
        ],
        // Only theme and language rebuild MaterialApp — the currency format
        // is read further down the tree.
        child: BlocSelector<SettingsCubit, SettingsState, (ThemeMode, Locale?)>(
          selector: (state) => (state.themeMode, state.locale),
          builder: (context, appearance) {
            final (themeMode, locale) = appearance;
            return MaterialApp(
              onGenerateTitle: (context) => context.strings.appTitle,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              // Null follows the device; Arabic also flips the layout to RTL.
              locale: locale,
              supportedLocales: AppStrings.supportedLocales,
              localizationsDelegates: const [
                AppStrings.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // The lock covers everything, the navigator included.
              builder: (context, child) => AppLockGate(
                child: QuickExpenseBridge(
                  child: AutoBackupBridge(
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
              home: const AppShell(),
            );
          },
        ),
      ),
    );
  }

  static void _reloadData(BuildContext context) {
    context.read<CategoriesCubit>().load();
    context.read<HomeCubit>().refresh();
    context.read<SettingsCubit>().load();
    // Limits can change without any expense changing.
    context.read<BudgetCubit>().refresh();
    // Recurring payments came along too, and any now due are logged.
    context.read<RecurringCubit>().refresh();
    // People, their transactions and settlements came along as well.
    context.read<PeopleCubit>().refresh();
    // So did the reminder, which is scheduled again or cancelled.
    context.read<ReminderCubit>().load(currentReminderMessage());
  }
}
