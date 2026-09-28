import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/confirm_sign_up.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/resend_sign_up_code.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/domain/usecases/watch_user.dart';
import '../../features/auth/presentation/cubit/account_cubit.dart';
import '../../features/categories/data/datasources/category_local_data_source.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/create_category.dart';
import '../../features/categories/domain/usecases/delete_category.dart';
import '../../features/categories/domain/usecases/get_categories.dart';
import '../../features/categories/domain/usecases/update_category.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../features/expenses/data/datasources/expense_local_data_source.dart';
import '../../features/expenses/data/repositories/expense_repository_impl.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';
import '../../features/expenses/domain/usecases/add_expense.dart';
import '../../features/expenses/domain/usecases/delete_expense.dart';
import '../../features/expenses/domain/usecases/get_month_overview.dart';
import '../../features/expenses/domain/usecases/get_monthly_summaries.dart';
import '../../features/expenses/domain/usecases/update_expense.dart';
import '../../features/expenses/presentation/cubit/expense_form_cubit.dart';
import '../../features/expenses/presentation/cubit/home_cubit.dart';
import '../../features/quick_expense/data/datasources/quick_expense_widget_channel.dart';
import '../../features/quick_expense/data/repositories/quick_expense_widget_repository_impl.dart';
import '../../features/quick_expense/domain/repositories/quick_expense_widget_repository.dart';
import '../../features/quick_expense/domain/usecases/get_quick_expense_data.dart';
import '../../features/quick_expense/domain/usecases/publish_quick_expense_widget.dart';
import '../../features/quick_expense/presentation/quick_expense_widget_sync.dart';
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/load_settings.dart';
import '../../features/settings/domain/usecases/save_currency_symbol.dart';
import '../../features/settings/domain/usecases/save_language.dart';
import '../../features/settings/domain/usecases/save_theme_mode.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/sync/data/datasources/sync_local_data_source.dart';
import '../../features/sync/data/datasources/sync_remote_data_source.dart';
import '../../features/sync/data/repositories/sync_repository_impl.dart';
import '../../features/sync/domain/repositories/sync_repository.dart';
import '../../features/sync/domain/usecases/back_up_data.dart';
import '../../features/sync/domain/usecases/get_last_synced_at.dart';
import '../../features/sync/domain/usecases/restore_data.dart';
import '../../features/sync/presentation/cubit/sync_cubit.dart';
import '../database/app_database.dart';

/// The single service locator. Nothing in the app constructs a cubit, use case
/// or repository by hand — everything is resolved from here.
final GetIt sl = GetIt.instance;

/// Wires the object graph. Registration only — nothing touches the disk here,
/// so tests can call this after substituting their own repositories.
///
/// [database] lets a test point the data layer at an in-memory database.
void configureDependencies({AppDatabase? database}) {
  _registerCore(database);
  _registerAuth();
  _registerCategories();
  _registerExpenses();
  _registerSettings();
  _registerQuickExpense();
  _registerSync();
}

/// Repositories are the seam tests replace, so they are only registered when
/// nothing has claimed them yet.
void _registerRepository<T extends Object>(T Function() create) {
  if (!sl.isRegistered<T>()) sl.registerLazySingleton<T>(create);
}

void _registerCore(AppDatabase? database) {
  sl.registerLazySingleton<AppDatabase>(() => database ?? AppDatabase());
  // Lazy so tests that never touch the network need no Supabase.initialize.
  if (!sl.isRegistered<SupabaseClient>()) {
    sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  }
}

void _registerAuth() {
  _registerRepository<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => GetCurrentUser(sl()))
    ..registerLazySingleton(() => WatchUser(sl()))
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ConfirmSignUp(sl()))
    ..registerLazySingleton(() => ResendSignUpCode(sl()))
    ..registerLazySingleton(() => SignOut(sl()))
    ..registerLazySingleton(
      () => AccountCubit(
        getCurrentUser: sl(),
        watchUser: sl(),
        signIn: sl(),
        signUp: sl(),
        confirmSignUp: sl(),
        resendSignUpCode: sl(),
        signOut: sl(),
      ),
    );
}

void _registerCategories() {
  _registerRepository<CategoryRepository>(() => CategoryRepositoryImpl(sl()));
  sl
    ..registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => GetCategories(sl()))
    ..registerLazySingleton(() => CreateCategory(sl()))
    ..registerLazySingleton(() => UpdateCategory(sl()))
    ..registerLazySingleton(() => DeleteCategory(sl()))
    // Shared: the manage screen and the add-expense picker read the same list,
    // so an edit in one is visible in the other immediately.
    ..registerLazySingleton(
      () => CategoriesCubit(
        getCategories: sl(),
        createCategory: sl(),
        updateCategory: sl(),
        deleteCategory: sl(),
      ),
    );
}

void _registerExpenses() {
  _registerRepository<ExpenseRepository>(() => ExpenseRepositoryImpl(sl()));
  sl
    ..registerLazySingleton<ExpenseLocalDataSource>(
      () => ExpenseLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => GetMonthOverview(sl()))
    ..registerLazySingleton(() => GetMonthlySummaries(sl()))
    ..registerLazySingleton(() => AddExpense(sl()))
    ..registerLazySingleton(() => UpdateExpense(sl()))
    ..registerLazySingleton(() => DeleteExpense(sl()))
    ..registerLazySingleton(
      () => HomeCubit(
        getMonthOverview: sl(),
        getMonthlySummaries: sl(),
        deleteExpense: sl(),
        addExpense: sl(),
      ),
    )
    // One per add/edit screen: each form owns its own draft state.
    ..registerFactory(
      () => ExpenseFormCubit(addExpense: sl(), updateExpense: sl()),
    );
}

void _registerQuickExpense() {
  _registerRepository<QuickExpenseWidgetRepository>(
    () => QuickExpenseWidgetRepositoryImpl(sl()),
  );
  sl
    ..registerLazySingleton<QuickExpenseWidgetChannel>(
      QuickExpenseWidgetChannelImpl.new,
    )
    ..registerLazySingleton(
      () => GetQuickExpenseData(
        expenseRepository: sl(),
        categoryRepository: sl(),
      ),
    )
    ..registerLazySingleton(() => PublishQuickExpenseWidget(sl()))
    ..registerLazySingleton(
      () => QuickExpenseWidgetSync(getData: sl(), publish: sl()),
    );
}

void _registerSettings() {
  _registerRepository<SettingsRepository>(() => SettingsRepositoryImpl(sl()));
  sl
    ..registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => LoadSettings(sl()))
    ..registerLazySingleton(() => SaveThemeMode(sl()))
    ..registerLazySingleton(() => SaveLanguage(sl()))
    ..registerLazySingleton(() => SaveCurrencySymbol(sl()))
    ..registerLazySingleton(
      () => SettingsCubit(
        loadSettings: sl(),
        saveThemeMode: sl(),
        saveLanguage: sl(),
        saveCurrencySymbol: sl(),
      ),
    );
}

void _registerSync() {
  _registerRepository<SyncRepository>(
    () => SyncRepositoryImpl(local: sl(), remote: sl()),
  );
  sl
    ..registerLazySingleton<SyncLocalDataSource>(
      () => SyncLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<SyncRemoteDataSource>(
      () => SyncRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => GetLastSyncedAt(sl()))
    ..registerLazySingleton(() => BackUpData(sl()))
    ..registerLazySingleton(() => RestoreData(sl()))
    // Shared, so a backup keeps running and reporting when the settings
    // sheet is closed and reopened.
    ..registerLazySingleton(
      () =>
          SyncCubit(getLastSyncedAt: sl(), backUpData: sl(), restoreData: sl()),
    );
}
