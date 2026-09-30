import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../features/categories/domain/entities/expense_category.dart';

/// Owns the single on-device SQLite connection.
///
/// Everything the app stores lives here. A signed-in user can copy it to their
/// Supabase account and back (see `features/sync`); the app itself only ever
/// reads from this database.
///
/// Sync bookkeeping, added in schema version 2:
/// * `updated_at`: when the row last changed, in milliseconds. When the same
///   row changed on two phones, the newer change wins.
/// * `deleted_at`: set instead of deleting, so a delete can reach the cloud.
///   Every read skips these rows.
/// * `dirty`: 1 while the row has changes the cloud has not seen yet.
class AppDatabase {
  AppDatabase({this.fileName = 'my_budget.db', this.inMemory = false});

  static const int _schemaVersion = 2;

  /// Now, in the form stored in `updated_at` and `deleted_at`.
  static int nowMillis() => DateTime.now().millisecondsSinceEpoch;

  /// [row] stamped as a local change the cloud has not seen yet.
  static Map<String, Object?> changed(Map<String, Object?> row) => {
    ...row,
    'updated_at': nowMillis(),
    'dirty': 1,
  };

  final String fileName;

  /// Tests open a throwaway database instead of touching the device.
  final bool inMemory;

  Database? _database;

  /// Opens the database on first use and reuses the connection afterwards.
  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    // sqflite ships native bindings for Android/iOS only; desktop runs need the
    // FFI implementation so `flutter run -d macos` works during development.
    // The FFI factory is used directly rather than installed as sqflite's
    // global default, which warns every time it is replaced.
    final DatabaseFactory factory;
    if (Platform.isAndroid || Platform.isIOS) {
      factory = databaseFactory;
    } else {
      sqfliteFfiInit();
      factory = databaseFactoryFfi;
    }
    final path = inMemory
        ? inMemoryDatabasePath
        : p.join(await factory.getDatabasesPath(), fileName);
    return factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _schemaVersion,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
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

    // A fresh install takes the same upgrade path as an existing one, so both
    // end up with exactly the same schema.
    _addSyncColumns(batch);

    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    if (oldVersion < 2) _addSyncColumns(batch);
    await batch.commit(noResult: true);
  }

  /// Schema version 2. Everything already on the phone starts out dirty, so
  /// the first backup uploads all of it.
  void _addSyncColumns(Batch batch) {
    for (final table in ['categories', 'expenses']) {
      batch
        ..execute(
          'ALTER TABLE $table ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
        )
        ..execute('ALTER TABLE $table ADD COLUMN deleted_at INTEGER')
        ..execute(
          'ALTER TABLE $table ADD COLUMN dirty INTEGER NOT NULL DEFAULT 1',
        )
        ..execute(
          'CREATE INDEX idx_${table}_dirty ON $table (dirty) WHERE dirty = 1',
        );
    }
    batch
      ..execute(
        'ALTER TABLE settings ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
      )
      ..execute(
        'ALTER TABLE settings ADD COLUMN dirty INTEGER NOT NULL DEFAULT 1',
      );

    final now = nowMillis();
    batch
      ..execute('UPDATE expenses SET updated_at = created_at')
      ..execute('UPDATE categories SET updated_at = ?', [now])
      ..execute('UPDATE settings SET updated_at = ?', [now]);
    // A built-in category nobody has edited is the same on every phone. It
    // stays at 0 so that an edit to it made anywhere else always wins.
    for (final category in defaultCategories) {
      batch.execute(
        'UPDATE categories SET updated_at = 0 '
        'WHERE id = ? AND name = ? AND icon_name = ? AND color_value = ?',
        [
          category['id'],
          category['name'],
          category['icon_name'],
          category['color_value'],
        ],
      );
    }

    // Local bookkeeping for sync (who this phone's data belongs to, when it
    // last synced). Never uploaded.
    batch.execute('''
      CREATE TABLE sync_meta (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
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
