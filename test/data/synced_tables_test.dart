import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/synced_tables.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Data lives in three places: the phone's SQLite database, the Supabase
/// tables, and the backup file. [SyncedTables] is what connects them, so
/// these tests fail as soon as a table or column is added to one place and
/// not the others.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('every table and column on the phone travels', () {
    late AppDatabase database;

    setUp(() => database = AppDatabase(inMemory: true));
    tearDown(() => database.close());

    test('each user-data table is synced', () async {
      final db = await database.database;
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table' "
        "AND name NOT LIKE 'sqlite_%' AND name NOT IN ('android_metadata')",
      );
      expect(
        {for (final row in tables) row['name']},
        // sync_meta and device_settings are the phone's own and never leave
        // it.
        {
          for (final table in SyncedTables.all) table.name,
          'sync_meta',
          'device_settings',
        },
      );
    });

    test("each table's columns, minus the phone's dirty flag", () async {
      final db = await database.database;
      for (final table in SyncedTables.all) {
        final info = await db.rawQuery('PRAGMA table_info(${table.name})');
        expect(
          {for (final column in info) column['name']}..remove('dirty'),
          {for (final column in table.columns) column.name},
          reason: table.name,
        );
      }
    });
  });

  group('the Supabase migrations build the same tables', () {
    final cloud = _CloudSchema.fromMigrations(Directory('supabase/migrations'));

    test('with the same columns, plus user_id', () {
      for (final table in SyncedTables.all) {
        expect(
          cloud.columns[table.name],
          {'user_id', for (final column in table.columns) column.name},
          reason: '${table.name}: add a migration for it',
        );
      }
    });

    test('each set up for sync: own rows only, newest wins', () {
      for (final table in SyncedTables.all) {
        expect(
          cloud.synced,
          contains(table.name),
          reason: "select private.make_synced('public.${table.name}');",
        );
      }
    });
  });
}

/// The public tables the migrations leave behind, replayed in order from
/// their `create table`, `alter table` and `drop table` statements.
class _CloudSchema {
  _CloudSchema.fromMigrations(Directory directory) {
    final files =
        directory
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.sql'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      _statements(file.readAsStringSync()).forEach(_apply);
    }
  }

  final Map<String, Set<String>> columns = {};
  final Set<String> synced = {};

  static final _createTable = RegExp(
    r'^create table (?:if not exists )?public\.(\w+) \((.*)\)$',
  );
  static final _alterTable = RegExp(
    r'^alter table (?:if exists )?public\.(\w+) (.*)$',
  );
  static final _dropTable = RegExp(r'^drop table (?:if exists )?public\.(\w+)');
  static final _makeSynced = RegExp(r"private\.make_synced\('public\.(\w+)'\)");

  /// Statements in lower case on one line each, without comments or
  /// function bodies (whose semicolons would split them).
  static Iterable<String> _statements(String sql) => sql
      .replaceAll(RegExp(r'--[^\n]*'), '')
      .replaceAll(RegExp(r'\$\$[\s\S]*?\$\$'), r'$$')
      .toLowerCase()
      .split(';')
      .map((statement) => statement.replaceAll(RegExp(r'\s+'), ' ').trim())
      .where((statement) => statement.isNotEmpty);

  void _apply(String statement) {
    if (_createTable.firstMatch(statement) case final match?) {
      columns[match[1]!] = {
        for (final item in _topLevel(match[2]!))
          if (!_constraint.hasMatch(item)) item.split(' ').first,
      };
    } else if (_alterTable.firstMatch(statement) case final match?) {
      _alter(match[1]!, match[2]!);
    } else if (_dropTable.firstMatch(statement) case final match?) {
      columns.remove(match[1]);
    }
    for (final match in _makeSynced.allMatches(statement)) {
      synced.add(match[1]!);
    }
  }

  static final _constraint = RegExp(
    r'^(primary key|foreign key|unique|check|constraint) ',
  );

  void _alter(String table, String actions) {
    if (RegExp(r'^rename to (\w+)$').firstMatch(actions) case final match?) {
      columns[match[1]!] = columns.remove(table)!;
      return;
    }
    for (final action in _topLevel(actions)) {
      if (RegExp(r'^add column (?:if not exists )?(\w+)').firstMatch(action)
          case final match?) {
        columns[table]!.add(match[1]!);
      } else if (RegExp(r'^drop column (?:if exists )?(\w+)').firstMatch(action)
          case final match?) {
        columns[table]!.remove(match[1]);
      } else if (RegExp(r'^rename column (\w+) to (\w+)').firstMatch(action)
          case final match?) {
        columns[table]!
          ..remove(match[1])
          ..add(match[2]!);
      }
    }
  }

  /// [list] split at the commas outside parentheses.
  static List<String> _topLevel(String list) {
    final items = <String>[];
    var depth = 0;
    var start = 0;
    for (var i = 0; i < list.length; i++) {
      switch (list[i]) {
        case '(':
          depth++;
        case ')':
          depth--;
        case ',' when depth == 0:
          items.add(list.substring(start, i).trim());
          start = i + 1;
      }
    }
    return [...items, list.substring(start).trim()];
  }
}
