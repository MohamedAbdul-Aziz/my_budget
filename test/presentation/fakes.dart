import 'dart:async';

import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/auth/domain/entities/app_user.dart';
import 'package:my_budget/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_budget/features/budgets/domain/entities/budget_limits.dart';
import 'package:my_budget/features/budgets/domain/repositories/budget_repository.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';
import 'package:my_budget/features/data_management/domain/entities/backup_preview.dart';
import 'package:my_budget/features/data_management/domain/entities/export_format.dart';
import 'package:my_budget/features/data_management/domain/entities/export_locale.dart';
import 'package:my_budget/features/data_management/domain/entities/exported_file.dart';
import 'package:my_budget/features/data_management/domain/entities/import_mode.dart';
import 'package:my_budget/features/data_management/domain/entities/share_anchor.dart';
import 'package:my_budget/features/data_management/domain/repositories/data_management_repository.dart';
import 'package:my_budget/features/categories/domain/repositories/category_repository.dart';
import 'package:my_budget/features/expenses/domain/entities/category_usage.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/expenses/domain/entities/monthly_summary.dart';
import 'package:my_budget/features/expenses/domain/repositories/expense_repository.dart';
import 'package:my_budget/features/quick_expense/domain/entities/quick_expense_snapshot.dart';
import 'package:my_budget/features/quick_expense/domain/repositories/quick_expense_widget_repository.dart';
import 'package:my_budget/features/recurring/domain/entities/recurrence_frequency.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_expense.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_mode.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_payment.dart';
import 'package:my_budget/features/recurring/domain/repositories/recurring_repository.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:my_budget/features/settings/domain/repositories/settings_repository.dart';
import 'package:my_budget/features/sync/domain/entities/sync_report.dart';
import 'package:my_budget/features/sync/domain/repositories/sync_repository.dart';

/// In-memory stand-ins for the sqflite repositories.
///
/// Widget tests run inside a fake-async zone, where the real database's
/// background isolate never completes. The SQL itself is covered by the
/// integration tests in `test/data`.

class FakeCategoryRepository implements CategoryRepository {
  final List<ExpenseCategory> categories = [
    const ExpenseCategory(
      id: 'cat_food',
      name: 'Food',
      iconName: 'restaurant',
      colorValue: 0xFFEF6C00,
      isDefault: true,
    ),
    const ExpenseCategory(
      id: 'cat_bills',
      name: 'Bills',
      iconName: 'receipt_long',
      colorValue: 0xFF6D4C41,
      isDefault: true,
      sortOrder: 1,
    ),
    const ExpenseCategory(
      id: ExpenseCategory.fallbackId,
      name: 'Other',
      iconName: 'category',
      colorValue: 0xFF546E7A,
      isDefault: true,
      sortOrder: 2,
    ),
    const ExpenseCategory(
      id: 'cat_salary',
      name: 'Salary',
      iconName: 'payments',
      colorValue: 0xFF2E7D32,
      type: TransactionType.income,
      isDefault: true,
    ),
    const ExpenseCategory(
      id: ExpenseCategory.incomeFallbackId,
      name: 'Other income',
      iconName: 'savings',
      colorValue: 0xFF607D8B,
      type: TransactionType.income,
      isDefault: true,
      sortOrder: 1,
    ),
  ];

  int _nextId = 0;

  @override
  Future<ApiResult<List<ExpenseCategory>>> getCategories() async =>
      Success(List.unmodifiable(categories));

  @override
  Future<ApiResult<ExpenseCategory>> createCategory({
    required String name,
    required String iconName,
    required int colorValue,
    required TransactionType type,
  }) async {
    final created = ExpenseCategory(
      id: 'cat_new_${_nextId++}',
      name: name,
      iconName: iconName,
      colorValue: colorValue,
      type: type,
      sortOrder: categories.length,
    );
    categories.add(created);
    return Success(created);
  }

  @override
  Future<ApiResult<ExpenseCategory>> updateCategory(
    ExpenseCategory category,
  ) async {
    final index = categories.indexWhere((item) => item.id == category.id);
    if (index == -1) {
      return const ResultFailure(NotFoundFailure('missing category'));
    }
    categories[index] = category;
    return Success(category);
  }

  @override
  Future<ApiResult<int>> deleteCategory(String categoryId) async {
    categories.removeWhere((category) => category.id == categoryId);
    return const Success(0);
  }
}

class FakeExpenseRepository implements ExpenseRepository {
  FakeExpenseRepository(this._categories);

  final FakeCategoryRepository _categories;
  final List<Expense> expenses = [];

  int _nextId = 0;

  @override
  Future<ApiResult<List<Expense>>> getTransactionsForMonth(Month month) async {
    final matching =
        expenses.where((expense) => expense.month == month).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return Success(matching);
  }

  @override
  Future<ApiResult<List<MonthlySummary>>> getMonthlySummaries() async {
    // Spending only, as the real query counts it.
    final totals = <Month, (double, int)>{};
    for (final expense in expenses) {
      final current = totals[expense.month] ?? (0.0, 0);
      totals[expense.month] = expense.isIncome
          ? current
          : (current.$1 + expense.amount, current.$2 + 1);
    }
    final summaries =
        totals.entries
            .map(
              (entry) => MonthlySummary(
                month: entry.key,
                total: entry.value.$1,
                expenseCount: entry.value.$2,
              ),
            )
            .toList()
          ..sort((a, b) => b.month.compareTo(a.month));
    return Success(summaries);
  }

  @override
  Future<ApiResult<List<CategoryUsage>>> getCategoryUsage() async {
    final counts = <String, int>{};
    for (final expense in expenses) {
      counts[expense.category.id] = (counts[expense.category.id] ?? 0) + 1;
    }
    final usage =
        counts.entries
            .map(
              (entry) =>
                  CategoryUsage(categoryId: entry.key, count: entry.value),
            )
            .toList()
          ..sort((a, b) => b.count.compareTo(a.count));
    return Success(usage);
  }

  @override
  Future<ApiResult<Expense>> addExpense({
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) async {
    final category = _categories.categories.firstWhere(
      (item) => item.id == categoryId,
    );
    final created = Expense(
      id: 'exp_${_nextId++}',
      amount: amount,
      category: category,
      date: date,
      description: description,
      createdAt: DateTime.now(),
    );
    expenses.add(created);
    return Success(created);
  }

  @override
  Future<ApiResult<Expense>> updateExpense({
    required String id,
    required double amount,
    required String categoryId,
    required DateTime date,
    String? description,
  }) async {
    final index = expenses.indexWhere((expense) => expense.id == id);
    if (index == -1) {
      return const ResultFailure(NotFoundFailure('missing expense'));
    }
    final updated = expenses[index].copyWith(
      amount: amount,
      date: date,
      description: description,
      category: _categories.categories.firstWhere(
        (item) => item.id == categoryId,
      ),
    );
    expenses[index] = updated;
    return Success(updated);
  }

  @override
  Future<ApiResult<void>> deleteExpense(String id) async {
    expenses.removeWhere((expense) => expense.id == id);
    return const Success(null);
  }
}

class FakeSettingsRepository implements SettingsRepository {
  AppSettings settings = const AppSettings();

  @override
  Future<ApiResult<AppSettings>> loadSettings() async => Success(settings);

  @override
  Future<ApiResult<AppSettings>> saveThemeMode(AppThemeMode mode) async {
    settings = settings.copyWith(themeMode: mode);
    return Success(settings);
  }

  @override
  Future<ApiResult<AppSettings>> saveLanguage(AppLanguage language) async {
    settings = settings.copyWith(language: language);
    return Success(settings);
  }

  @override
  Future<ApiResult<AppSettings>> saveCurrencySymbol(String symbol) async {
    settings = settings.copyWith(currencySymbol: symbol);
    return Success(settings);
  }
}

class FakeBudgetRepository implements BudgetRepository {
  double? monthly;
  final Map<String, double> byCategory = {};

  @override
  Future<ApiResult<BudgetLimits>> getLimits() async =>
      Success(BudgetLimits(monthly: monthly, byCategory: Map.of(byCategory)));

  @override
  Future<ApiResult<void>> saveMonthlyLimit(double? limit) async {
    monthly = limit;
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> saveCategoryLimit(
    String categoryId,
    double? limit,
  ) async {
    if (limit == null) {
      byCategory.remove(categoryId);
    } else {
      byCategory[categoryId] = limit;
    }
    return const Success(null);
  }
}

/// Recurring payments in memory. A payment lands in [FakeExpenseRepository]
/// under the same predictable id the real data layer gives it, and a
/// payment already settled is refused the same way; the SQL itself is
/// covered by `test/data/recurring_storage_test.dart`.
class FakeRecurringRepository implements RecurringRepository {
  FakeRecurringRepository(this._categories, this._expenses);

  final FakeCategoryRepository _categories;
  final FakeExpenseRepository _expenses;
  final List<RecurringExpense> recurring = [];

  int _nextId = 0;

  /// A payment set up as if it had been added on [startsOn].
  RecurringExpense seed({
    required String title,
    required double amount,
    String categoryId = 'cat_bills',
    RecurrenceFrequency frequency = RecurrenceFrequency.monthly,
    required int dueDay,
    int? dueMonth,
    RecurringMode mode = RecurringMode.reminder,
    required DateTime startsOn,
    DateTime? paidThrough,
  }) {
    final item = RecurringExpense(
      id: 'rec_${_nextId++}',
      title: title,
      amount: amount,
      category: _category(categoryId),
      frequency: frequency,
      dueDay: dueDay,
      dueMonth: dueMonth,
      mode: mode,
      startsOn: RecurringExpense.dayOf(startsOn),
      paidThrough: paidThrough,
      createdAt: startsOn,
    );
    recurring.add(item);
    return item;
  }

  @override
  Future<ApiResult<List<RecurringExpense>>> getRecurring() async => Success([
    // Joined with the category as it is now, as the real query does.
    for (final item in recurring)
      item.copyWith(category: _category(item.category.id)),
  ]);

  @override
  Future<ApiResult<RecurringExpense>> createRecurring({
    required String title,
    required double amount,
    required String categoryId,
    required RecurrenceFrequency frequency,
    required int dueDay,
    int? dueMonth,
    required RecurringMode mode,
    required DateTime startsOn,
  }) async => Success(
    seed(
      title: title,
      amount: amount,
      categoryId: categoryId,
      frequency: frequency,
      dueDay: dueDay,
      dueMonth: dueMonth,
      mode: mode,
      startsOn: startsOn,
    ),
  );

  @override
  Future<ApiResult<RecurringExpense>> updateRecurring(
    RecurringExpense item,
  ) async {
    final index = recurring.indexWhere((r) => r.id == item.id);
    if (index == -1) {
      return const ResultFailure(NotFoundFailure('missing recurring'));
    }
    recurring[index] = item;
    return Success(item);
  }

  @override
  Future<ApiResult<void>> deleteRecurring(String id) async {
    recurring.removeWhere((item) => item.id == id);
    return const Success(null);
  }

  @override
  Future<ApiResult<RecurringPayment>> recordPayment(
    RecurringExpense item, {
    required DateTime due,
    required DateTime paidAt,
  }) async {
    final index = recurring.indexWhere((r) => r.id == item.id);
    if (index == -1) {
      return const ResultFailure(NotFoundFailure('missing recurring'));
    }
    final current = recurring[index];
    if (current.isSettled(due)) {
      return const ResultFailure(ValidationFailure(FailureCode.alreadyPaid));
    }
    final day = RecurringExpense.dayOf(due);
    final expenseId =
        '${item.id}_${day.year}'
        '${day.month.toString().padLeft(2, '0')}'
        '${day.day.toString().padLeft(2, '0')}';
    _expenses.expenses
      ..removeWhere((expense) => expense.id == expenseId)
      ..add(
        Expense(
          id: expenseId,
          amount: current.amount,
          category: _category(current.category.id),
          date: paidAt,
          description: current.title,
          createdAt: DateTime.now(),
        ),
      );
    recurring[index] = current.copyWith(paidThrough: () => day);
    return Success(
      RecurringPayment(
        recurringId: item.id,
        expenseId: expenseId,
        due: day,
        previousPaidThrough: current.paidThrough,
      ),
    );
  }

  @override
  Future<ApiResult<void>> undoPayment(RecurringPayment payment) async {
    _expenses.expenses.removeWhere((e) => e.id == payment.expenseId);
    final index = recurring.indexWhere((r) => r.id == payment.recurringId);
    if (index != -1 && recurring[index].paidThrough == payment.due) {
      recurring[index] = recurring[index].copyWith(
        paidThrough: () => payment.previousPaidThrough,
      );
    }
    return const Success(null);
  }

  ExpenseCategory _category(String id) => _categories.categories.firstWhere(
    (category) => category.id == id,
    orElse: () => _categories.categories.firstWhere(
      (category) => category.id == ExpenseCategory.fallbackId,
    ),
  );
}

/// Stands in for the Android home screen widget: records what the app would
/// have drawn on it.
class FakeQuickExpenseWidgetRepository implements QuickExpenseWidgetRepository {
  final List<QuickExpenseSnapshot> published = [];

  QuickExpenseSnapshot? get latest => published.isEmpty ? null : published.last;

  @override
  Future<ApiResult<void>> publish(QuickExpenseSnapshot snapshot) async {
    published.add(snapshot);
    return const Success(null);
  }
}

/// Stands in for Supabase Auth with "Confirm email" on: a new account cannot
/// sign in until it is confirmed with the code in [codes].
class FakeAuthRepository implements AuthRepository {
  final Map<String, String> passwords = {};
  final Set<String> confirmed = {};

  /// The code each unconfirmed account was last emailed.
  final Map<String, String> codes = {};
  int resends = 0;

  final StreamController<AppUser?> _changes =
      StreamController<AppUser?>.broadcast();

  @override
  AppUser? currentUser;

  @override
  Stream<AppUser?> get userChanges => _changes.stream;

  /// What tapping a confirmation link does on the phone: the account is
  /// confirmed and the app is signed in from outside the cubit.
  void openConfirmationLink(String email) {
    confirmed.add(email);
    _changes.add(currentUser = _userFor(email));
  }

  /// An account that already went through confirmation.
  void addConfirmedAccount(String email, String password) {
    passwords[email] = password;
    confirmed.add(email);
  }

  @override
  Future<ApiResult<AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    if (passwords[email] != password) {
      return const ResultFailure(AuthFailure(FailureCode.invalidCredentials));
    }
    if (!confirmed.contains(email)) {
      return const ResultFailure(AuthFailure(FailureCode.emailNotConfirmed));
    }
    return Success(currentUser = _userFor(email));
  }

  @override
  Future<ApiResult<AppUser?>> signUp({
    required String email,
    required String password,
  }) async {
    passwords[email] = password;
    codes[email] = '123456';
    return const Success(null);
  }

  @override
  Future<ApiResult<AppUser>> confirmSignUp({
    required String email,
    required String code,
  }) async {
    if (codes[email] != code) {
      return const ResultFailure(AuthFailure(FailureCode.codeInvalid));
    }
    confirmed.add(email);
    return Success(currentUser = _userFor(email));
  }

  @override
  Future<ApiResult<void>> resendSignUpCode({required String email}) async {
    resends++;
    codes[email] = '654321';
    return const Success(null);
  }

  @override
  Future<ApiResult<void>> signOut() async {
    currentUser = null;
    return const Success(null);
  }

  /// Emails of the accounts deleted so far.
  final List<String> deletedAccounts = [];

  /// When set, deleting the account fails with it.
  Failure? deleteFailure;

  @override
  Future<ApiResult<void>> deleteAccount() async {
    final failure = deleteFailure;
    if (failure != null) return ResultFailure(failure);
    final email = currentUser!.email;
    deletedAccounts.add(email);
    passwords.remove(email);
    confirmed.remove(email);
    // The real data source signs the phone out once the account is gone.
    _changes.add(currentUser = null);
    return const Success(null);
  }

  static AppUser _userFor(String email) =>
      AppUser(id: 'user_$email', email: email);
}

/// Stands in for backup and restore; the real data layer is covered by
/// `test/data/sync_test.dart`.
class FakeSyncRepository implements SyncRepository {
  int backUps = 0;
  int restores = 0;
  DateTime? last;

  /// When set, the next backup or restore fails with it.
  Failure? failWith;

  /// Runs during a restore, standing in for rows arriving on the phone.
  Future<void> Function()? onRestore;

  /// Accounts whose link to this phone's data was dropped.
  final List<String> forgottenAccounts = [];

  @override
  Future<ApiResult<DateTime?>> lastSyncedAt() async => Success(last);

  @override
  Future<ApiResult<SyncReport>> backUp({SyncProgress? onProgress}) async {
    backUps++;
    return _finish(onProgress);
  }

  @override
  Future<ApiResult<SyncReport>> restore({SyncProgress? onProgress}) async {
    restores++;
    await onRestore?.call();
    return _finish(onProgress);
  }

  @override
  Future<ApiResult<void>> forgetAccount(String userId) async {
    forgottenAccounts.add(userId);
    return const Success(null);
  }

  ApiResult<SyncReport> _finish(SyncProgress? onProgress) {
    final failure = failWith;
    if (failure != null) return ResultFailure(failure);
    onProgress?.call(1);
    final at = last = DateTime.now();
    return Success(SyncReport(changes: 1, finishedAt: at));
  }
}

/// Stands in for exports, sharing, saving and importing; the real files are
/// covered by `test/data/data_management_test.dart`.
class FakeDataManagementRepository implements DataManagementRepository {
  final List<ExportFormat> exports = [];
  final List<ExportLocale> exportLocales = [];
  final List<List<ExportedFile>> shared = [];
  final List<List<ExportedFile>> saved = [];
  final List<ImportMode> imports = [];

  /// When set, exporting fails with it.
  Failure? exportFailure;

  /// What the save dialog answers: false is the user cancelling.
  bool saveConfirmed = true;

  /// What the file chooser returns: null is the user cancelling.
  String? pickedPath = '/picked/backup.mybudget.json';

  /// When set, checking the picked file fails with it.
  Failure? previewFailure;

  BackupPreview preview = BackupPreview(
    path: '/picked/backup.mybudget.json',
    expenses: 12,
    categories: 9,
    exportedAt: DateTime(2026, 9, 1, 10),
  );

  /// Runs during an import, standing in for records arriving on the phone.
  Future<void> Function()? onImport;
  int importChanges = 3;

  @override
  Future<ApiResult<List<ExportedFile>>> export(
    ExportFormat format,
    ExportLocale locale, {
    DataProgress? onProgress,
  }) async {
    exports.add(format);
    exportLocales.add(locale);
    final failure = exportFailure;
    if (failure != null) return ResultFailure(failure);
    onProgress?.call(1);
    return Success([
      ExportedFile(
        path: '/tmp/export.${format.name}',
        name: 'export.${format.name}',
        mimeType: 'application/octet-stream',
      ),
    ]);
  }

  @override
  Future<ApiResult<void>> share(
    List<ExportedFile> files, {
    ShareAnchor? anchor,
  }) async {
    shared.add(files);
    return const Success(null);
  }

  @override
  Future<ApiResult<bool>> saveToDevice(List<ExportedFile> files) async {
    if (saveConfirmed) saved.add(files);
    return Success(saveConfirmed);
  }

  @override
  Future<ApiResult<String?>> pickFile() async => Success(pickedPath);

  @override
  Future<ApiResult<BackupPreview>> previewBackup(String path) async {
    final failure = previewFailure;
    if (failure != null) return ResultFailure(failure);
    return Success(preview);
  }

  @override
  Future<ApiResult<int>> importBackup(
    String path,
    ImportMode mode, {
    DataProgress? onProgress,
  }) async {
    imports.add(mode);
    await onImport?.call();
    onProgress?.call(1);
    return Success(importChanges);
  }
}
