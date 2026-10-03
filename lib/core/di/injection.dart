import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/analyses/domain/usecases/compare_months.dart';
import '../../features/analyses/domain/usecases/get_month_analysis.dart';
import '../../features/app_lock/data/datasources/device_auth_data_source.dart';
import '../../features/app_lock/data/repositories/app_lock_repository_impl.dart';
import '../../features/app_lock/domain/repositories/app_lock_repository.dart';
import '../../features/app_lock/domain/usecases/get_app_lock.dart';
import '../../features/app_lock/domain/usecases/set_app_lock.dart';
import '../../features/app_lock/domain/usecases/unlock_app.dart';
import '../../features/app_lock/presentation/cubit/app_lock_cubit.dart';
import '../../features/analyses/presentation/cubit/analyses_cubit.dart';
import '../../features/analyses/presentation/cubit/compare_months_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/data_management/data/datasources/device_files_data_source.dart';
import '../../features/data_management/data/datasources/report_fonts_data_source.dart';
import '../../features/data_management/data/repositories/data_management_repository_impl.dart';
import '../../features/data_management/domain/repositories/data_management_repository.dart';
import '../../features/data_management/domain/usecases/choose_backup.dart';
import '../../features/data_management/domain/usecases/export_data.dart';
import '../../features/data_management/domain/usecases/import_backup.dart';
import '../../features/data_management/domain/usecases/save_files.dart';
import '../../features/data_management/domain/usecases/share_files.dart';
import '../../features/data_management/presentation/cubit/data_management_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/confirm_sign_up.dart';
import '../../features/auth/domain/usecases/delete_account.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/resend_sign_up_code.dart';
import '../../features/auth/domain/usecases/reset_password.dart';
import '../../features/auth/domain/usecases/send_password_reset.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/domain/usecases/watch_user.dart';
import '../../features/auth/presentation/cubit/account_cubit.dart';
import '../../features/budgets/data/datasources/budget_local_data_source.dart';
import '../../features/budgets/data/repositories/budget_repository_impl.dart';
import '../../features/budgets/domain/repositories/budget_repository.dart';
import '../../features/budgets/domain/usecases/check_budget_alerts.dart';
import '../../features/budgets/domain/usecases/get_budget_status.dart';
import '../../features/budgets/domain/usecases/set_category_budget.dart';
import '../../features/budgets/domain/usecases/set_monthly_budget.dart';
import '../../features/budgets/presentation/cubit/budget_cubit.dart';
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
import '../../features/expenses/domain/usecases/search_transactions.dart';
import '../../features/expenses/domain/usecases/update_expense.dart';
import '../../features/expenses/presentation/cubit/expense_form_cubit.dart';
import '../../features/expenses/presentation/cubit/home_cubit.dart';
import '../../features/expenses/presentation/cubit/search_cubit.dart';
import '../../features/people/data/datasources/people_local_data_source.dart';
import '../../features/people/data/repositories/people_repository_impl.dart';
import '../../features/people/domain/repositories/people_repository.dart';
import '../../features/people/domain/usecases/add_person.dart';
import '../../features/people/domain/usecases/add_person_transaction.dart';
import '../../features/people/domain/usecases/delete_person.dart';
import '../../features/people/domain/usecases/delete_person_transaction.dart';
import '../../features/people/domain/usecases/get_people.dart';
import '../../features/people/domain/usecases/get_person_ledger.dart';
import '../../features/people/domain/usecases/log_settlement_to_budget.dart';
import '../../features/people/domain/usecases/settle_up.dart';
import '../../features/people/domain/usecases/update_person.dart';
import '../../features/people/domain/usecases/update_person_transaction.dart';
import '../../features/people/presentation/cubit/people_cubit.dart';
import '../../features/people/presentation/cubit/person_ledger_cubit.dart';
import '../../features/quick_expense/data/datasources/quick_expense_widget_channel.dart';
import '../../features/quick_expense/data/repositories/quick_expense_widget_repository_impl.dart';
import '../../features/quick_expense/domain/repositories/quick_expense_widget_repository.dart';
import '../../features/quick_expense/domain/usecases/get_quick_expense_data.dart';
import '../../features/quick_expense/domain/usecases/publish_quick_expense_widget.dart';
import '../../features/quick_expense/presentation/quick_expense_widget_sync.dart';
import '../../features/recurring/data/datasources/recurring_local_data_source.dart';
import '../../features/recurring/data/repositories/recurring_repository_impl.dart';
import '../../features/recurring/domain/repositories/recurring_repository.dart';
import '../../features/recurring/domain/usecases/delete_recurring_expense.dart';
import '../../features/recurring/domain/usecases/get_recurring_overview.dart';
import '../../features/recurring/domain/usecases/log_due_recurring.dart';
import '../../features/recurring/domain/usecases/mark_recurring_paid.dart';
import '../../features/recurring/domain/usecases/save_recurring_expense.dart';
import '../../features/recurring/domain/usecases/undo_recurring_payment.dart';
import '../../features/recurring/presentation/cubit/recurring_cubit.dart';
import '../../features/recurring/presentation/cubit/recurring_form_cubit.dart';
import '../../features/reminders/data/datasources/reminder_local_data_source.dart';
import '../../features/reminders/data/datasources/reminder_notifications_data_source.dart';
import '../../features/reminders/data/repositories/reminder_repository_impl.dart';
import '../../features/reminders/domain/repositories/reminder_repository.dart';
import '../../features/reminders/domain/usecases/load_reminder.dart';
import '../../features/reminders/domain/usecases/save_reminder.dart';
import '../../features/reminders/presentation/cubit/reminder_cubit.dart';
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
import '../../features/sync/domain/usecases/auto_back_up.dart';
import '../../features/sync/domain/usecases/back_up_data.dart';
import '../../features/sync/domain/usecases/get_auto_backup.dart';
import '../../features/sync/domain/usecases/get_last_synced_at.dart';
import '../../features/sync/domain/usecases/restore_data.dart';
import '../../features/sync/domain/usecases/set_auto_backup.dart';
import '../../features/sync/presentation/cubit/auto_backup_cubit.dart';
import '../../features/sync/presentation/cubit/sync_cubit.dart';
import '../database/app_database.dart';
import '../database/device_settings.dart';
import '../database/local_records.dart';

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
  _registerBudgets();
  _registerRecurring();
  _registerPeople();
  _registerSettings();
  _registerReminders();
  _registerAppLock();
  _registerQuickExpense();
  _registerSync();
  _registerAnalyses();
  _registerDataManagement();
}

/// Repositories are the seam tests replace, so they are only registered when
/// nothing has claimed them yet.
void _registerRepository<T extends Object>(T Function() create) {
  if (!sl.isRegistered<T>()) sl.registerLazySingleton<T>(create);
}

void _registerCore(AppDatabase? database) {
  sl
    ..registerLazySingleton<AppDatabase>(() => database ?? AppDatabase())
    // Bulk record moves shared by cloud sync and file backups.
    ..registerLazySingleton(() => LocalRecords(sl()))
    // Phone-only preferences: automatic backup, app lock.
    ..registerLazySingleton(() => DeviceSettings(sl()));
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
    ..registerLazySingleton(() => SendPasswordReset(sl()))
    ..registerLazySingleton(() => ResetPassword(sl()))
    ..registerLazySingleton(
      () => DeleteAccount(authRepository: sl(), syncRepository: sl()),
    )
    ..registerLazySingleton(() => SignOut(sl()))
    ..registerLazySingleton(
      () => AccountCubit(
        getCurrentUser: sl(),
        watchUser: sl(),
        signIn: sl(),
        signUp: sl(),
        confirmSignUp: sl(),
        resendSignUpCode: sl(),
        sendPasswordReset: sl(),
        resetPassword: sl(),
        signOut: sl(),
        deleteAccount: sl(),
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
    ..registerLazySingleton(() => SearchTransactions(sl()))
    ..registerLazySingleton(
      () => HomeCubit(
        getMonthOverview: sl(),
        getMonthlySummaries: sl(),
        deleteExpense: sl(),
        addExpense: sl(),
      ),
    )
    // One per search screen: each keeps its own text and filters.
    ..registerFactory(() => SearchCubit(searchTransactions: sl()))
    // One per add/edit screen: each form owns its own draft state.
    ..registerFactory(
      () => ExpenseFormCubit(
        addExpense: sl(),
        updateExpense: sl(),
        checkBudgetAlerts: sl(),
      ),
    );
}

void _registerBudgets() {
  _registerRepository<BudgetRepository>(() => BudgetRepositoryImpl(sl()));
  sl
    ..registerLazySingleton<BudgetLocalDataSource>(
      () => BudgetLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton(
      () => GetBudgetStatus(
        budgetRepository: sl(),
        expenseRepository: sl(),
        categoryRepository: sl(),
      ),
    )
    ..registerLazySingleton(() => SetMonthlyBudget(sl()))
    ..registerLazySingleton(() => SetCategoryBudget(sl()))
    ..registerLazySingleton(() => CheckBudgetAlerts(sl()))
    // Shared: the home screen card and the budgets page show the same
    // numbers, and an edit in one is visible in the other immediately.
    ..registerLazySingleton(
      () => BudgetCubit(
        getBudgetStatus: sl(),
        setMonthlyBudget: sl(),
        setCategoryBudget: sl(),
      ),
    );
}

void _registerRecurring() {
  _registerRepository<RecurringRepository>(() => RecurringRepositoryImpl(sl()));
  sl
    ..registerLazySingleton<RecurringLocalDataSource>(
      () => RecurringLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => GetRecurringOverview(sl()))
    ..registerLazySingleton(() => SaveRecurringExpense(sl()))
    ..registerLazySingleton(() => DeleteRecurringExpense(sl()))
    ..registerLazySingleton(() => MarkRecurringPaid(sl()))
    ..registerLazySingleton(() => UndoRecurringPayment(sl()))
    ..registerLazySingleton(() => LogDueRecurring(sl()))
    // Shared: the recurring payments page and the home screen's prompt show
    // the same payments, and marking one paid in either updates both.
    ..registerLazySingleton(
      () => RecurringCubit(
        getOverview: sl(),
        logDue: sl(),
        markPaid: sl(),
        undoPayment: sl(),
        deleteRecurring: sl(),
      ),
    )
    // One per add/edit screen: each form owns its own draft state.
    ..registerFactory(() => RecurringFormCubit(saveRecurring: sl()));
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

void _registerPeople() {
  _registerRepository<PeopleRepository>(() => PeopleRepositoryImpl(sl()));
  sl
    ..registerLazySingleton<PeopleLocalDataSource>(
      () => PeopleLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => GetPeople(sl()))
    ..registerLazySingleton(() => GetPersonLedger(sl()))
    ..registerLazySingleton(() => AddPerson(sl()))
    ..registerLazySingleton(() => UpdatePerson(sl()))
    ..registerLazySingleton(() => DeletePerson(sl()))
    ..registerLazySingleton(() => AddPersonTransaction(sl()))
    ..registerLazySingleton(() => UpdatePersonTransaction(sl()))
    ..registerLazySingleton(() => DeletePersonTransaction(sl()))
    ..registerLazySingleton(() => SettleUp(sl()))
    ..registerLazySingleton(
      () => LogSettlementToBudget(
        peopleRepository: sl(),
        expenseRepository: sl(),
      ),
    )
    // Shared: the People tab and every ledger screen change the same list.
    ..registerLazySingleton(
      () => PeopleCubit(
        getPeople: sl(),
        addPerson: sl(),
        addPersonTransaction: sl(),
        deletePerson: sl(),
      ),
    )
    // One per ledger screen: each shows one person.
    ..registerFactory(
      () => PersonLedgerCubit(
        getPersonLedger: sl(),
        updatePerson: sl(),
        addPersonTransaction: sl(),
        updatePersonTransaction: sl(),
        deletePersonTransaction: sl(),
        settleUp: sl(),
        logSettlementToBudget: sl(),
      ),
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

void _registerReminders() {
  _registerRepository<ReminderRepository>(
    () => ReminderRepositoryImpl(local: sl(), notifications: sl()),
  );
  sl
    ..registerLazySingleton<ReminderLocalDataSource>(
      () => ReminderLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ReminderNotificationsDataSource>(
      ReminderNotificationsDataSourceImpl.new,
    )
    ..registerLazySingleton(() => LoadReminder(sl()))
    ..registerLazySingleton(() => SaveReminder(sl()))
    // Shared: the launch, a restore and a language change reschedule the
    // same reminder the settings sheet shows.
    ..registerLazySingleton(
      () => ReminderCubit(loadReminder: sl(), saveReminder: sl()),
    );
}

void _registerAppLock() {
  _registerRepository<AppLockRepository>(
    () => AppLockRepositoryImpl(deviceAuth: sl(), deviceSettings: sl()),
  );
  sl
    ..registerLazySingleton<DeviceAuthDataSource>(DeviceAuthDataSourceImpl.new)
    ..registerLazySingleton(() => GetAppLock(sl()))
    ..registerLazySingleton(() => SetAppLock(sl()))
    ..registerLazySingleton(() => UnlockApp(sl()))
    // Shared: the lock screen over the whole app and the settings switch.
    ..registerLazySingleton(
      () => AppLockCubit(getAppLock: sl(), setAppLock: sl(), unlockApp: sl()),
    );
}

void _registerSync() {
  _registerRepository<SyncRepository>(
    () => SyncRepositoryImpl(local: sl(), remote: sl()),
  );
  sl
    ..registerLazySingleton<SyncLocalDataSource>(
      () => SyncLocalDataSourceImpl(sl(), sl(), sl()),
    )
    ..registerLazySingleton<SyncRemoteDataSource>(
      () => SyncRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => GetLastSyncedAt(sl()))
    ..registerLazySingleton(() => BackUpData(sl()))
    ..registerLazySingleton(() => RestoreData(sl()))
    ..registerLazySingleton(() => GetAutoBackup(sl()))
    ..registerLazySingleton(() => SetAutoBackup(sl()))
    ..registerLazySingleton(
      () => AutoBackUp(syncRepository: sl(), authRepository: sl()),
    )
    // Shared, so a backup keeps running and reporting when the settings
    // sheet is closed and reopened.
    ..registerLazySingleton(
      () => SyncCubit(
        getLastSyncedAt: sl(),
        backUpData: sl(),
        restoreData: sl(),
        autoBackUp: sl(),
      ),
    )
    ..registerLazySingleton(
      () => AutoBackupCubit(getAutoBackup: sl(), setAutoBackup: sl()),
    );
}

void _registerAnalyses() {
  sl
    ..registerLazySingleton(() => GetMonthAnalysis(sl()))
    ..registerLazySingleton(() => CompareMonths(sl()))
    ..registerLazySingleton(() => AnalysesCubit(getMonthAnalysis: sl()))
    ..registerFactory(
      () => CompareMonthsCubit(compareMonths: sl(), getMonthlySummaries: sl()),
    );
}

void _registerDataManagement() {
  _registerRepository<DataManagementRepository>(
    () => DataManagementRepositoryImpl(records: sl(), files: sl(), fonts: sl()),
  );
  sl
    ..registerLazySingleton<DeviceFilesDataSource>(
      DeviceFilesDataSourceImpl.new,
    )
    ..registerLazySingleton<ReportFontsDataSource>(
      ReportFontsDataSourceImpl.new,
    )
    ..registerLazySingleton(() => ExportData(sl()))
    ..registerLazySingleton(() => ShareFiles(sl()))
    ..registerLazySingleton(() => SaveFiles(sl()))
    ..registerLazySingleton(() => ChooseBackup(sl()))
    ..registerLazySingleton(() => ImportBackup(sl()))
    // Shared, so an export or import keeps running and reporting when the
    // settings sheet is closed and reopened.
    ..registerLazySingleton(
      () => DataManagementCubit(
        exportData: sl(),
        shareFiles: sl(),
        saveFiles: sl(),
        chooseBackup: sl(),
        importBackup: sl(),
      ),
    );
}
