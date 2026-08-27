import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';

abstract interface class SettingsLocalDataSource {
  Future<Map<String, String>> readAll();

  Future<void> write(String key, String value);
}

/// Key/value rows in the same local database — no extra storage plugin.
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<Map<String, String>> readAll() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.query('settings');
      return {
        for (final row in rows) row['key']! as String: row['value']! as String,
      };
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load settings: $error');
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      final db = await _appDatabase.database;
      await db.insert('settings', {
        'key': key,
        'value': value,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('write setting: $error');
    }
  }
}
