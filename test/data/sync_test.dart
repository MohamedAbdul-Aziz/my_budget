import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/data/datasources/category_local_data_source.dart';
import 'package:my_budget/features/categories/data/repositories/category_repository_impl.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:my_budget/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:my_budget/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:my_budget/features/sync/data/datasources/sync_local_data_source.dart';
import 'package:my_budget/features/sync/data/datasources/sync_remote_data_source.dart';
import 'package:my_budget/features/sync/data/models/cloud_rows.dart';
import 'package:my_budget/features/sync/data/models/sync_batch.dart';
import 'package:my_budget/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Two phones syncing through one account: the real SQLite data layer on each
/// phone, and an in-memory cloud that applies the same newest-wins rule as the
/// trigger in Supabase.
void main() {
  late FakeCloud cloud;
  late Phone phoneA;
  late Phone phoneB;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    cloud = FakeCloud();
    phoneA = Phone('a', cloud);
    phoneB = Phone('b', cloud);
  });

  tearDown(() async {
    await phoneA.dispose();
    await phoneB.dispose();
  });

  final august = DateTime(2026, 8, 4);

  test('the first backup uploads everything on the phone', () async {
    await phoneA.addExpense(12.5, note: 'Lunch');
    await phoneA.categories.createCategory(
      name: 'Pets',
      iconName: 'pets',
      colorValue: 0xFF123456,
    );
    await phoneA.settingsRepo.saveCurrencySymbol('€');

    final report = (await phoneA.sync.backUp()).dataOrNull!;

    // 8 built-in categories, the new one, the expense and the setting.
    expect(report.changes, 11);
    expect(cloud.rows('categories'), hasLength(9));
    expect(cloud.rows('expenses'), hasLength(1));
    expect(cloud.rows('user_settings'), hasLength(1));
  });

  test('later backups upload only what changed, never duplicates', () async {
    final lunch = await phoneA.addExpense(12.5);
    await phoneA.sync.backUp();

    final nothingNew = (await phoneA.sync.backUp()).dataOrNull!;
    expect(nothingNew.changes, 0);

    await phoneA.expenses.updateExpense(
      id: lunch.id,
      amount: 15,
      categoryId: 'cat_food',
      date: august,
    );
    final oneEdit = (await phoneA.sync.backUp()).dataOrNull!;

    expect(oneEdit.changes, 1);
    expect(cloud.rows('expenses'), hasLength(1));
    expect(cloud.rows('expenses').single['amount'], 15);
  });

  test('restore brings the account to another phone', () async {
    await phoneA.addExpense(12.5, note: 'Lunch');
    await phoneA.categories.createCategory(
      name: 'Pets',
      iconName: 'pets',
      colorValue: 0xFF123456,
    );
    await phoneA.settingsRepo.saveCurrencySymbol('€');
    await phoneA.sync.backUp();

    await phoneB.sync.restore();

    final month = await phoneB.monthOf(august);
    expect(month.single.description, 'Lunch');
    expect(month.single.amount, 12.5);
    final names = (await phoneB.categories.getCategories()).dataOrNull!.map(
      (category) => category.name,
    );
    expect(names, contains('Pets'));
    final settings = (await phoneB.settingsRepo.loadSettings()).dataOrNull!;
    expect(settings.currencySymbol, '€');
  });

  test('restoring twice changes nothing the second time', () async {
    await phoneA.addExpense(12.5);
    await phoneA.sync.backUp();

    await phoneB.sync.restore();
    final again = (await phoneB.sync.restore()).dataOrNull!;

    expect(again.changes, 0);
    expect(await phoneB.monthOf(august), hasLength(1));
  });

  test('restore merges: what only this phone has stays', () async {
    await phoneA.addExpense(12.5, note: 'From A');
    await phoneA.sync.backUp();
    await phoneB.addExpense(3, note: 'Only on B');

    await phoneB.sync.restore();

    final notes = (await phoneB.monthOf(august)).map((e) => e.description);
    expect(notes, containsAll(['From A', 'Only on B']));

    // And B's own expense goes up with its next backup.
    await phoneB.sync.backUp();
    expect(cloud.rows('expenses'), hasLength(2));
  });

  test('a delete reaches the other phone', () async {
    final lunch = await phoneA.addExpense(12.5);
    await phoneA.sync.backUp();
    await phoneB.sync.restore();

    await phoneA.expenses.deleteExpense(lunch.id);
    await phoneA.sync.backUp();
    await phoneB.sync.restore();

    expect(await phoneB.monthOf(august), isEmpty);
    expect(cloud.rows('expenses').single['deleted_at'], isNotNull);
  });

  test('the newer edit wins, whichever phone backs up last', () async {
    final lunch = await phoneA.addExpense(10);
    await phoneA.sync.backUp();
    await phoneB.sync.restore();

    // B edits first, A edits later: A's edit is the newer one.
    await phoneB.setAmount(lunch.id, 20);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await phoneA.setAmount(lunch.id, 30);

    await phoneA.sync.backUp();
    // B's older edit does not overwrite A's in the cloud...
    await phoneB.sync.backUp();
    expect(cloud.rows('expenses').single['amount'], 30);

    // ...and restoring brings A's edit to B.
    await phoneB.sync.restore();
    expect((await phoneB.monthOf(august)).single.amount, 30);
  });

  test('restore does not overwrite a newer edit made on this phone', () async {
    final lunch = await phoneA.addExpense(10);
    await phoneA.sync.backUp();
    await phoneB.sync.restore();

    await Future<void>.delayed(const Duration(milliseconds: 5));
    await phoneB.setAmount(lunch.id, 99);
    await phoneB.sync.restore();

    expect((await phoneB.monthOf(august)).single.amount, 99);
  });

  test(
    'a category deleted on another phone moves this phone\'s expenses to Other',
    () async {
      final pets = (await phoneA.categories.createCategory(
        name: 'Pets',
        iconName: 'pets',
        colorValue: 0xFF123456,
      )).dataOrNull!;
      await phoneA.sync.backUp();
      await phoneB.sync.restore();
      await phoneB.addExpense(8, categoryId: pets.id, note: 'Vet');

      await phoneA.categories.deleteCategory(pets.id);
      await phoneA.sync.backUp();
      await phoneB.sync.restore();

      final vet = (await phoneB.monthOf(august)).single;
      expect(vet.category.id, ExpenseCategory.fallbackId);
      final names = (await phoneB.categories.getCategories()).dataOrNull!.map(
        (category) => category.name,
      );
      expect(names, isNot(contains('Pets')));

      // The move is itself a change, so the cloud learns about it too.
      await phoneB.sync.backUp();
      final cloudVet = cloud.rows('expenses').single;
      expect(cloudVet['category_id'], ExpenseCategory.fallbackId);
    },
  );

  test('refuses to sync the phone with a second account', () async {
    await phoneA.addExpense(12.5);
    await phoneA.sync.backUp();

    phoneA.remote.userId = 'someone-else';
    final result = await phoneA.sync.backUp();

    expect(result.failureOrNull?.code, FailureCode.syncOtherAccount);
    expect(cloud.rows('expenses', userId: 'someone-else'), isEmpty);
  });

  test('needs a signed-in user', () async {
    phoneA.remote.userId = null;

    final result = await phoneA.sync.backUp();

    expect(result.failureOrNull?.code, FailureCode.signInRequired);
  });

  test('remembers when the account last synced on this phone', () async {
    expect((await phoneA.sync.lastSyncedAt()).dataOrNull, isNull);

    final report = (await phoneA.sync.backUp()).dataOrNull!;

    expect((await phoneA.sync.lastSyncedAt()).dataOrNull, report.finishedAt);
  });

  test('rows survive the trip to the cloud and back unchanged', () {
    const category = {
      'id': 'cat_1',
      'name': 'Pets',
      'icon_name': 'pets',
      'color_value': 0xFFEF6C00,
      'is_default': 1,
      'sort_order': 3,
      'updated_at': 1000,
      'deleted_at': null,
    };
    const expense = {
      'id': 'exp_1',
      'amount': 12.5,
      'description': 'Lunch',
      'category_id': 'cat_1',
      'date': 1785000000000,
      'month_key': '2026-08',
      'created_at': 1785000000000,
      'updated_at': 1785000000001,
      'deleted_at': 1785000000002,
    };
    const setting = {'key': 'currency_symbol', 'value': '€', 'updated_at': 5};

    final cloudCategory = CloudRows.categoryToCloud(category, 'user-1');
    expect(cloudCategory['user_id'], 'user-1');
    expect(cloudCategory['is_default'], isTrue);
    expect(CloudRows.categoryFromCloud(cloudCategory), category);
    expect(
      CloudRows.expenseFromCloud(CloudRows.expenseToCloud(expense, 'user-1')),
      expense,
    );
    expect(
      CloudRows.settingFromCloud(CloudRows.settingToCloud(setting, 'user-1')),
      setting,
    );
  });
}

/// One phone: its own database file, the app's real repositories on it, and
/// a sync repository talking to the shared [FakeCloud].
class Phone {
  Phone(String name, FakeCloud cloud)
    : fileName =
          'sync_test_${name}_${DateTime.now().microsecondsSinceEpoch}.db',
      remote = FakeRemote(cloud) {
    database = AppDatabase(fileName: fileName);
    expenses = ExpenseRepositoryImpl(ExpenseLocalDataSourceImpl(database));
    categories = CategoryRepositoryImpl(CategoryLocalDataSourceImpl(database));
    settingsRepo = SettingsRepositoryImpl(
      SettingsLocalDataSourceImpl(database),
    );
    sync = SyncRepositoryImpl(
      local: SyncLocalDataSourceImpl(database),
      remote: remote,
    );
  }

  final String fileName;
  final FakeRemote remote;
  late final AppDatabase database;
  late final ExpenseRepositoryImpl expenses;
  late final CategoryRepositoryImpl categories;
  late final SettingsRepositoryImpl settingsRepo;
  late final SyncRepositoryImpl sync;

  Future<Expense> addExpense(
    double amount, {
    String categoryId = 'cat_food',
    String? note,
  }) async => (await expenses.addExpense(
    amount: amount,
    categoryId: categoryId,
    date: DateTime(2026, 8, 4),
    description: note,
  )).dataOrNull!;

  Future<void> setAmount(String id, double amount) async {
    final result = await expenses.updateExpense(
      id: id,
      amount: amount,
      categoryId: 'cat_food',
      date: DateTime(2026, 8, 4),
    );
    expect(result.isSuccess, isTrue);
  }

  Future<List<Expense>> monthOf(DateTime date) async =>
      (await expenses.getExpensesForMonth(Month.fromDate(date))).dataOrNull!;

  Future<void> dispose() async {
    await database.close();
    await deleteDatabase(p.join(await getDatabasesPath(), fileName));
  }
}

/// The account's cloud copy, keyed by user and id like the Supabase tables.
/// Upserts follow the database trigger: an older or equal `updated_at` never
/// replaces the stored row.
class FakeCloud {
  final Map<String, Map<String, Map<String, Object?>>> _tables = {
    'categories': {},
    'expenses': {},
    'user_settings': {},
  };

  List<Map<String, Object?>> rows(String table, {String userId = 'user-1'}) =>
      _tables[table]!.entries
          .where((entry) => entry.key.startsWith('$userId|'))
          .map((entry) => entry.value)
          .toList();

  void upsert(
    String table,
    String userId,
    String key,
    Map<String, Object?> row,
  ) {
    final id = '$userId|$key';
    final stored = _tables[table]![id];
    if (stored != null &&
        (row['updated_at']! as int) <= (stored['updated_at']! as int)) {
      return;
    }
    _tables[table]![id] = {
      for (final entry in row.entries)
        if (entry.key != 'dirty') entry.key: entry.value,
    };
  }
}

class FakeRemote implements SyncRemoteDataSource {
  FakeRemote(this.cloud);

  final FakeCloud cloud;

  String? userId = 'user-1';

  @override
  String? get currentUserId => userId;

  @override
  Future<void> upload(
    SyncBatch batch, {
    required String userId,
    void Function(int count)? onUploaded,
  }) async {
    for (final row in batch.categories) {
      cloud.upsert('categories', userId, row['id']! as String, row);
    }
    for (final row in batch.expenses) {
      cloud.upsert('expenses', userId, row['id']! as String, row);
    }
    for (final row in batch.settings) {
      cloud.upsert('user_settings', userId, row['key']! as String, row);
    }
    onUploaded?.call(batch.length);
  }

  @override
  Future<SyncBatch> download({
    void Function(double fraction)? onProgress,
  }) async {
    final user = userId!;
    onProgress?.call(1);
    return SyncBatch(
      categories: cloud.rows('categories', userId: user),
      expenses: cloud.rows('expenses', userId: user),
      settings: cloud.rows('user_settings', userId: user),
    );
  }
}
