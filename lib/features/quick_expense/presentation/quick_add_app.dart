import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../categories/presentation/cubit/categories_cubit.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
import '../../settings/presentation/cubit/settings_state.dart';
import 'pages/quick_add_screen.dart';

/// The app as the home screen widget sees it: the quick-add dialog and nothing
/// else — no home screen, no navigation, no month history loaded.
///
/// It runs the same cubits, use cases and database as the full app, so an
/// expense added here is identical to one added inside it.
class QuickAddApp extends StatelessWidget {
  const QuickAddApp({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<SettingsCubit>()),
        BlocProvider.value(value: sl<CategoriesCubit>()),
      ],
      child: BlocSelector<SettingsCubit, SettingsState, (ThemeMode, Locale?)>(
        selector: (state) => (state.themeMode, state.locale),
        builder: (context, appearance) {
          final (themeMode, locale) = appearance;
          return MaterialApp(
            onGenerateTitle: (context) => context.strings.quickExpense,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            locale: locale,
            supportedLocales: AppStrings.supportedLocales,
            localizationsDelegates: const [
              AppStrings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: QuickAddScreen(categoryId: categoryId),
          );
        },
      ),
    );
  }
}
