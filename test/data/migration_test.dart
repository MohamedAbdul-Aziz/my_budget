import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/features/categories/data/datasources/category_local_data_source.dart';
import 'package:my_budget/features/categories/data/repositories/category_repository_impl.dart';
import 'package:my_budget/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:my_budget/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A phone that installed the app before sync existed (schema version 1)
/// and then updates it.
void main() {
  late String fileName;
  late String path;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    fileName = 'migration_test_${DateTime.now().microsecondsSinceEpoch}.db';
    path = p.join(await getDatabasesPath(), fileName);
    await _createVersion1(path);
  });

  tearDown(() => deleteDatabase(path));

  test(
    'upgrading keeps every record and queues it for the first backup',
    () async {
      final database = AppDatabase(fileName: fileName);
      addTearDown(database.close);
      final db = await database.database;

      expect(await db.getVersion(), 5);

      final expense = (await db.query('expenses')).single;
      expect(expense['updated_at'], expense['created_at']);
      expect(expense['deleted_at'], isNull);
      expect(expense['dirty'], 1);

      final categories = {
        for (final row in await db.query('categories')) row['id']: row,
      };
      // An untouched built-in is the same everywhere, so any edit elsewhere
      // beats it. Edited and custom categories count as changed now.
      expect(categories['cat_bills']!['updated_at'], 0);
      expect(categories['cat_food']!['updated_at'] as int, greaterThan(0));
      expect(categories['cat_pets']!['updated_at'] as int, greaterThan(0));
      expect(categories.values.every((row) => row['dirty'] == 1), isTrue);

      // Everything recorded before income existed is spending, and the
      // income built-ins arrive untouched.
      expect(categories['cat_pets']!['type'], 'expense');
      expect(categories['cat_bills']!['type'], 'expense');
      for (final seeded in AppDatabase.defaultIncomeCategories) {
        final row = categories[seeded['id']]!;
        expect(row['type'], 'income');
        expect(row['updated_at'], 0);
      }

      final setting = (await db.query('settings')).single;
      expect(setting['updated_at'] as int, greaterThan(0));
      expect(setting['dirty'], 1);

      expect(await db.query('sync_meta'), isEmpty);

      // Recurring payments arrive empty, ready to be set up.
      expect(await db.query('recurring_expenses'), isEmpty);

      // So do people and debts, each table with its sync columns.
      for (final table in AppDatabase.peopleTables) {
        expect(await db.query(table), isEmpty);
        final columns = {
          for (final row in await db.rawQuery('PRAGMA table_info($table)'))
            row['name'],
        };
        expect(columns, containsAll(['updated_at', 'deleted_at', 'dirty']));
      }
    },
  );

  test('the app reads upgraded data exactly as before', () async {
    final database = AppDatabase(fileName: fileName);
    addTearDown(database.close);
    final expenses = ExpenseRepositoryImpl(
      ExpenseLocalDataSourceImpl(database),
    );
    final categories = CategoryRepositoryImpl(
      CategoryLocalDataSourceImpl(database),
    );

    final month = (await expenses.getTransactionsForMonth(
      const Month(2026, 8),
    )).dataOrNull!;
    expect(month.single.amount, 12.5);
    expect(month.single.category.name, 'Groceries');

    final names = (await categories.getCategories()).dataOrNull!.map(
      (category) => category.name,
    );
    expect(names, containsAll(['Groceries', 'Bills', 'Pets']));
  });
}

/// The schema and a little data exactly as version 1 of the app left them.
Future<void> _createVersion1(String path) async {
  final db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE categories (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          icon_name TEXT NOT NULL,
          color_value INTEGER NOT NULL,
          is_default INTEGER NOT NULL DEFAULT 0,
          sort_order INTEGER NOT NULL DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE expenses (
          id TEXT PRIMARY KEY,
          amount REAL NOT NULL,
          description TEXT,
          category_id TEXT NOT NULL,
          date INTEGER NOT NULL,
          month_key TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE RESTRICT
        )
      ''');
      await db.execute('''
        CREATE TABLE settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');
      for (final (index, category) in AppDatabase.defaultCategories.indexed) {
        await db.insert('categories', {
          ...category,
          'is_default': 1,
          'sort_order': index,
        });
      }
    },
  );

  // A renamed built-in, a custom category, one expense and one setting.
  await db.update(
    'categories',
    {'name': 'Groceries', 'is_default': 0},
    where: 'id = ?',
    whereArgs: ['cat_food'],
  );
  await db.insert('categories', {
    'id': 'cat_pets',
    'name': 'Pets',
    'icon_name': 'pets',
    'color_value': 0xFF123456,
    'sort_order': 8,
  });
  final date = DateTime(2026, 8, 4);
  await db.insert('expenses', {
    'id': 'exp_1',
    'amount': 12.5,
    'category_id': 'cat_food',
    'date': date.millisecondsSinceEpoch,
    'month_key': '2026-08',
    'created_at': date.millisecondsSinceEpoch,
  });
  await db.insert('settings', {'key': 'currency_symbol', 'value': '€'});
  await db.close();
}
