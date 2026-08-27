import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../features/categories/domain/entities/expense_category.dart';

/// Owns the single on-device SQLite connection.
///
/// Everything the app stores lives here — there is no network layer and no
/// remote data source anywhere in the project.
class AppDatabase {
  AppDatabase({this.fileName = 'my_budget.db', this.inMemory = false});

  static const int _schemaVersion = 1;

  final String fileName;

  /// Tests open a throwaway database instead of touching the device.
  final bool inMemory;

  Database? _database;

  /// Opens the database on first use and reuses the connection afterwards.
  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    // sqflite ships native bindings for Android/iOS only; desktop runs need the
    // FFI implementation so `flutter run -d macos` works during development.
    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final path = inMemory
        ? inMemoryDatabasePath
        : p.join(await getDatabasesPath(), fileName);
    return openDatabase(
      path,
      version: _schemaVersion,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
    );
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon_name TEXT NOT NULL,
        color_value INTEGER NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        sort_order INTEGER NOT NULL DEFAULT 0
      )
    ''');

    batch.execute('''
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

    // month_key drives every monthly query; date drives ordering inside a month.
    batch.execute('CREATE INDEX idx_expenses_month ON expenses (month_key)');
    batch.execute('CREATE INDEX idx_expenses_date ON expenses (date DESC)');
    batch.execute(
      'CREATE INDEX idx_expenses_category ON expenses (category_id)',
    );

    batch.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    for (final (index, category) in defaultCategories.indexed) {
      batch.insert('categories', {
        ...category,
        'is_default': 1,
        'sort_order': index,
      });
    }

    await batch.commit(noResult: true);
  }

  /// Seeded on first launch. `icon_name` is a key into the app's const icon
  /// map — storing code points directly would break icon tree shaking.
  static const List<Map<String, Object>> defaultCategories = [
    {
      'id': 'cat_food',
      'name': 'Food',
      'icon_name': 'restaurant',
      'color_value': 0xFFEF6C00,
    },
    {
      'id': 'cat_transport',
      'name': 'Transportation',
      'icon_name': 'directions_bus',
      'color_value': 0xFF1E88E5,
    },
    {
      'id': 'cat_bills',
      'name': 'Bills',
      'icon_name': 'receipt_long',
      'color_value': 0xFF6D4C41,
    },
    {
      'id': 'cat_shopping',
      'name': 'Shopping',
      'icon_name': 'shopping_bag',
      'color_value': 0xFFD81B60,
    },
    {
      'id': 'cat_health',
      'name': 'Health & Fitness',
      'icon_name': 'fitness_center',
      'color_value': 0xFF43A047,
    },
    {
      'id': 'cat_entertainment',
      'name': 'Entertainment',
      'icon_name': 'movie',
      'color_value': 0xFF8E24AA,
    },
    {
      'id': 'cat_work',
      'name': 'Work',
      'icon_name': 'work',
      'color_value': 0xFF00897B,
    },
    {
      'id': ExpenseCategory.fallbackId,
      'name': 'Other',
      'icon_name': 'category',
      'color_value': 0xFF546E7A,
    },
  ];
}
