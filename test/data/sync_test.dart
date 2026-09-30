import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/local_records.dart';
import 'package:my_budget/core/database/portable_records.dart';
import 'package:my_budget/core/database/record_batch.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/data/datasources/category_local_data_source.dart';
import 'package:my_budget/features/categories/data/repositories/category_repository_impl.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';
import 'package:my_budget/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:my_budget/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/people/data/datasources/people_local_data_source.dart';
import 'package:my_budget/features/people/data/repositories/people_repository_impl.dart';
import 'package:my_budget/features/people/domain/entities/person.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction_type.dart';
import 'package:my_budget/features/recurring/data/datasources/recurring_local_data_source.dart';
import 'package:my_budget/features/recurring/data/repositories/recurring_repository_impl.dart';
import 'package:my_budget/features/recurring/domain/entities/recurrence_frequency.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_expense.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_mode.dart';
import 'package:my_budget/features/recurring/domain/usecases/log_due_recurring.dart';
import 'package:my_budget/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:my_budget/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:my_budget/features/sync/data/datasources/sync_local_data_source.dart';
import 'package:my_budget/features/sync/data/datasources/sync_remote_data_source.dart';
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
      type: TransactionType.expense,
    );
    await phoneA.settingsRepo.saveCurrencySymbol('€');

    final report = (await phoneA.sync.backUp()).dataOrNull!;

    // 13 built-in categories, the new one, the expense and the setting.
    expect(report.changes, 16);
    expect(cloud.rows('categories'), hasLength(14));
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
      type: TransactionType.expense,
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
        type: TransactionType.expense,
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

  test(
    'once the account is deleted, another account can back up everything',
    () async {
      final lunch = await phoneA.addExpense(12.5);
      final dinner = await phoneA.addExpense(20);
      await phoneA.expenses.deleteExpense(dinner.id);
      await phoneA.sync.backUp();

      await phoneA.sync.forgetAccount('user-1');
      phoneA.remote.userId = 'user-2';
      final report = (await phoneA.sync.backUp()).dataOrNull!;

      // The 13 built-in categories and the one expense left. The deleted
      // expense only existed to reach user-1's backup, so it is gone.
      expect(report.changes, 14);
      expect(cloud.rows('expenses', userId: 'user-2').single['id'], lunch.id);
      expect((await phoneA.sync.lastSyncedAt()).dataOrNull, report.finishedAt);
    },
  );

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

  test(
    'a recurring payment and what it logged reach the other phone',
    () async {
      final rent = await phoneA.addRecurring();
      await phoneA.recurring.recordPayment(
        rent,
        due: DateTime(2026, 8, 1),
        paidAt: august,
      );
      await phoneA.sync.backUp();
      expect(cloud.rows('recurring_expenses'), hasLength(1));

      await phoneB.sync.restore();

      final restored =
          (await phoneB.recurring.getRecurring()).dataOrNull!.single;
      expect(restored.title, 'Rent');
      expect(restored.frequency, RecurrenceFrequency.monthly);
      expect(restored.paidThrough, DateTime(2026, 8, 1));
      expect((await phoneB.monthOf(august)).single.description, 'Rent');

      // Deleting it on B reaches A too.
      await phoneB.recurring.deleteRecurring(rent.id);
      await phoneB.sync.backUp();
      await phoneA.sync.restore();
      expect((await phoneA.recurring.getRecurring()).dataOrNull, isEmpty);
    },
  );

  test(
    'forgetting a deleted account clears deleted recurring payments',
    () async {
      final gym = (await phoneA.categories.createCategory(
        name: 'Gym',
        iconName: 'fitness_center',
        colorValue: 0xFF123456,
        type: TransactionType.expense,
      )).dataOrNull!;
      final membership = (await phoneA.recurring.createRecurring(
        title: 'Membership',
        amount: 30,
        categoryId: gym.id,
        frequency: RecurrenceFrequency.monthly,
        dueDay: 1,
        mode: RecurringMode.reminder,
        startsOn: august,
      )).dataOrNull!;
      final rent = await phoneA.addRecurring();
      // The deleted payment still points at the category deleted after it.
      await phoneA.recurring.deleteRecurring(membership.id);
      await phoneA.categories.deleteCategory(gym.id);
      await phoneA.sync.backUp();

      final forgotten = await phoneA.sync.forgetAccount('user-1');

      expect(forgotten.isSuccess, isTrue);
      phoneA.remote.userId = 'user-2';
      await phoneA.sync.backUp();
      final uploaded = cloud.rows('recurring_expenses', userId: 'user-2');
      expect(uploaded.single['id'], rent.id);
    },
  );

  test('two phones deducting the same payment log it once', () async {
    await phoneA.addRecurring(mode: RecurringMode.autoDeduct);
    await phoneA.sync.backUp();
    await phoneB.sync.restore();

    // Both open the app after the due date, before either backs up.
    await LogDueRecurring(phoneA.recurring)(today: DateTime(2026, 8, 20));
    await LogDueRecurring(phoneB.recurring)(today: DateTime(2026, 8, 20));
    await phoneA.sync.backUp();
    await phoneB.sync.backUp();
    await phoneA.sync.restore();

    expect(cloud.rows('expenses'), hasLength(1));
    expect(await phoneA.monthOf(august), hasLength(1));
  });

  test('people, their transactions, change logs and settlements reach '
      'another phone', () async {
    final sara = await phoneA.addPerson('Sara');
    final lunch = await phoneA.addDebt(sara, 20);
    await phoneA.people.updateTransaction(
      id: lunch.id,
      amount: 24,
      type: PersonTransactionType.iPaidForThem,
      date: august,
    );
    await phoneA.people.settleUp(sara.id);
    await phoneA.addDebt(sara, 10, type: PersonTransactionType.theyPaidForMe);

    final report = (await phoneA.sync.backUp()).dataOrNull!;
    expect(cloud.rows('people'), hasLength(1));
    expect(cloud.rows('person_transactions'), hasLength(2));
    expect(cloud.rows('person_transaction_edits'), hasLength(1));
    expect(cloud.rows('settlements'), hasLength(1));
    expect(report.changes, greaterThanOrEqualTo(5));

    await phoneB.sync.restore();

    final ledger = (await phoneB.people.getLedger(sara.id)).dataOrNull!;
    expect(ledger.person.name, 'Sara');
    expect(ledger.balance.cents, -1000);
    final settled = ledger.history.single;
    expect(settled.settlement.balance.cents, 2400);
    expect(settled.transactions.single.edits.single.amount, 20);
    // Restored rows are already in the cloud, so none waits for upload.
    final db = await phoneB.database.database;
    for (final table in AppDatabase.peopleTables) {
      expect(await db.query(table, where: 'dirty = 1'), isEmpty);
    }
  });

  test('a person deleted on another phone takes along what this phone '
      'recorded with them', () async {
    final sara = await phoneA.addPerson('Sara');
    await phoneA.sync.backUp();
    await phoneB.sync.restore();

    // Phone B records something for Sara, phone A deletes her.
    await phoneB.addDebt(sara, 15);
    await phoneA.people.deletePerson(sara.id);
    await phoneA.sync.backUp();
    await phoneB.sync.restore();

    expect((await phoneB.people.getPeople()).dataOrNull, isEmpty);
    // The delete goes back up with phone B's next backup, so the cloud
    // does not keep a transaction for someone who is gone.
    await phoneB.sync.backUp();
    expect(cloud.rows('person_transactions').single['deleted_at'], isNotNull);
  });

  test('forgetting a deleted account clears deleted people rows', () async {
    final sara = await phoneA.addPerson('Sara');
    await phoneA.addDebt(sara, 15);
    final omar = await phoneA.addPerson('Omar');
    await phoneA.people.deletePerson(sara.id);
    await phoneA.sync.backUp();

    final forgotten = await phoneA.sync.forgetAccount('user-1');

    expect(forgotten.isSuccess, isTrue);
    final db = await phoneA.database.database;
    expect(await db.query('person_transactions'), isEmpty);
    phoneA.remote.userId = 'user-2';
    await phoneA.sync.backUp();
    expect(cloud.rows('people', userId: 'user-2').single['id'], omar.id);
  });

  test('rows survive the trip off the phone and back unchanged', () {
    const category = {
      'id': 'cat_1',
      'name': 'Pets',
      'icon_name': 'pets',
      'color_value': 0xFFEF6C00,
      'type': 'income',
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

    final portable = PortableRecords.categoryToPortable(category);
    expect(portable['is_default'], isTrue);
    expect(PortableRecords.categoryFromPortable(portable), category);
    expect(
      PortableRecords.expenseFromPortable(
        PortableRecords.expenseToPortable(expense),
      ),
      expense,
    );
    expect(
      PortableRecords.settingFromPortable(
        PortableRecords.settingToPortable(setting),
      ),
      setting,
    );
    const recurring = {
      'id': 'rec_1',
      'title': 'Rent',
      'amount': 900.0,
      'category_id': 'cat_bills',
      'frequency': 'yearly',
      'due_day': 29,
      'due_month': 2,
      'mode': 'auto',
      'starts_on': '2026-08-01',
      'paid_through': '2026-02-28',
      'created_at': 1785000000000,
      'updated_at': 1785000000001,
      'deleted_at': null,
    };
    expect(
      PortableRecords.recurringFromPortable(
        PortableRecords.recurringToPortable(recurring),
      ),
      recurring,
    );
    const people = <String, Map<String, Object?>>{
      'people': {
        'id': 'per_1',
        'name': 'سارة',
        'phone': '+20 100 000',
        'color_value': 0xFF1E88E5,
        'created_at': 1785000000000,
        'updated_at': 1785000000001,
        'deleted_at': null,
      },
      'settlements': {
        'id': 'set_1',
        'person_id': 'per_1',
        'net_amount': -12.5,
        'settled_at': 1785000000000,
        'expense_id': 'exp_1',
        'created_at': 1785000000000,
        'updated_at': 1785000000001,
        'deleted_at': null,
      },
      'person_transactions': {
        'id': 'ptx_1',
        'person_id': 'per_1',
        'amount': 12.5,
        'type': 'they_paid_for_me',
        'note': 'Taxi',
        'date': 1785000000000,
        'settled_at': 1785000000000,
        'settlement_id': 'set_1',
        'created_at': 1785000000000,
        'updated_at': 1785000000001,
        'deleted_at': 1785000000002,
      },
      'person_transaction_edits': {
        'id': 'pte_1',
        'transaction_id': 'ptx_1',
        'amount': 10.0,
        'type': 'i_paid_for_them',
        'note': null,
        'date': 1785000000000,
        'edited_at': 1785000000001,
        'updated_at': 1785000000001,
        'deleted_at': null,
      },
    };
    for (final MapEntry(key: table, value: row) in people.entries) {
      final portable = PortableRecords.toPortable(table, {...row, 'dirty': 1});
      expect(portable.containsKey('dirty'), isFalse, reason: table);
      expect(PortableRecords.fromPortable(table, portable), row);
    }
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
    recurring = RecurringRepositoryImpl(RecurringLocalDataSourceImpl(database));
    people = PeopleRepositoryImpl(PeopleLocalDataSourceImpl(database));
    sync = SyncRepositoryImpl(
      local: SyncLocalDataSourceImpl(database, LocalRecords(database)),
      remote: remote,
    );
  }

  final String fileName;
  final FakeRemote remote;
  late final AppDatabase database;
  late final ExpenseRepositoryImpl expenses;
  late final CategoryRepositoryImpl categories;
  late final SettingsRepositoryImpl settingsRepo;
  late final RecurringRepositoryImpl recurring;
  late final PeopleRepositoryImpl people;
  late final SyncRepositoryImpl sync;

  Future<Person> addPerson(String name) async =>
      (await people.addPerson(name: name, colorValue: 0xFF1E88E5)).dataOrNull!;

  Future<PersonTransaction> addDebt(
    Person person,
    double amount, {
    PersonTransactionType type = PersonTransactionType.iPaidForThem,
  }) async => (await people.addTransaction(
    personId: person.id,
    amount: amount,
    type: type,
    date: DateTime(2026, 8, 4),
  )).dataOrNull!;

  Future<RecurringExpense> addRecurring({
    RecurringMode mode = RecurringMode.reminder,
  }) async => (await recurring.createRecurring(
    title: 'Rent',
    amount: 900,
    categoryId: 'cat_bills',
    frequency: RecurrenceFrequency.monthly,
    dueDay: 1,
    mode: mode,
    startsOn: DateTime(2026, 8, 1),
  )).dataOrNull!;

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
      (await expenses.getTransactionsForMonth(
        Month.fromDate(date),
      )).dataOrNull!;

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
    'recurring_expenses': {},
    for (final table in AppDatabase.peopleTables) table: {},
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
    RecordBatch batch, {
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
    for (final row in batch.recurring) {
      cloud.upsert('recurring_expenses', userId, row['id']! as String, row);
    }
    // Through the portable form, as the real upload sends them.
    for (final MapEntry(key: table, value: rows)
        in batch.peopleTables.entries) {
      for (final row in rows) {
        cloud.upsert(
          table,
          userId,
          row['id']! as String,
          PortableRecords.toPortable(table, row),
        );
      }
    }
    onUploaded?.call(batch.length);
  }

  @override
  Future<RecordBatch> download({
    void Function(double fraction)? onProgress,
  }) async {
    final user = userId!;
    onProgress?.call(1);
    return RecordBatch(
      categories: cloud.rows('categories', userId: user),
      expenses: cloud.rows('expenses', userId: user),
      settings: cloud.rows('user_settings', userId: user),
      recurring: cloud.rows('recurring_expenses', userId: user),
      people: _people('people', user),
      settlements: _people('settlements', user),
      personTransactions: _people('person_transactions', user),
      personTransactionEdits: _people('person_transaction_edits', user),
    );
  }

  List<Map<String, Object?>> _people(String table, String user) => [
    for (final row in cloud.rows(table, userId: user))
      PortableRecords.fromPortable(table, row),
  ];
}
