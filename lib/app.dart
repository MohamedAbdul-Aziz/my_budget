import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/analyses/presentation/cubit/analyses_cubit.dart';
import 'features/auth/presentation/cubit/account_cubit.dart';
import 'features/categories/presentation/cubit/categories_cubit.dart';
import 'features/expenses/presentation/cubit/home_cubit.dart';
import 'features/expenses/presentation/cubit/home_state.dart';
import 'features/quick_expense/presentation/widgets/quick_expense_bridge.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';
import 'features/shell/presentation/app_shell.dart';
import 'features/sync/presentation/cubit/sync_cubit.dart';
import 'features/sync/presentation/cubit/sync_state.dart';

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
      ],
      // A restore rewrites the database underneath the other cubits, so they
      // read it again. The home screen widget follows HomeCubit on its own.
      child: MultiBlocListener(
        listeners: [
          BlocListener<SyncCubit, SyncState>(
            listenWhen: (_, state) =>
                state is SyncSucceeded && state.kind == SyncKind.restore,
            listener: (context, _) {
              context.read<CategoriesCubit>().load();
              context.read<HomeCubit>().refresh();
              context.read<SettingsCubit>().load();
            },
          ),
          // Analyses follow the home screen: its selected month, and every
          // change to that month's expenses.
          BlocListener<HomeCubit, HomeState>(
            listenWhen: (previous, current) =>
                current is HomeReady &&
                (previous is! HomeReady ||
                    previous.overview != current.overview ||
                    previous.months != current.months),
            listener: (context, state) =>
                context.read<AnalysesCubit>().load((state as HomeReady).month),
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
              builder: (context, child) =>
                  QuickExpenseBridge(child: child ?? const SizedBox.shrink()),
              home: const AppShell(),
            );
          },
        ),
      ),
    );
  }
}
