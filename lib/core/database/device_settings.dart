import 'package:sqflite/sqflite.dart';

import '../error/failures.dart';
import 'app_database.dart';

/// Preferences that belong to this phone alone, in the `device_settings`
/// table: never synced, never in a backup file, never touched by a restore.
///
/// Shared by the features that keep one (automatic backup, app lock), the
/// way [LocalRecords] is shared by sync and file backups.
class DeviceSettings {
  const DeviceSettings(this._appDatabase);

  static const String autoBackup = 'auto_backup';
  static const String appLock = 'app_lock';

  /// Agreement to send a spending summary to the AI assistant: asked on each
  /// phone, so a restore never turns it on for someone who did not agree.
  static const String aiConsent = 'ai_consent';

  final AppDatabase _appDatabase;

  /// Off unless it was turned on on this phone.
  Future<bool> readFlag(String key) async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.query(
        'device_settings',
        columns: ['value'],
        where: 'key = ?',
        whereArgs: [key],
      );
      return rows.isNotEmpty && rows.first['value'] == 'true';
    } on DatabaseException catch (error) {
      throw DatabaseFailure('read $key: $error');
    }
  }

  Future<void> writeFlag(String key, {required bool on}) async {
    try {
      final db = await _appDatabase.database;
      await db.insert('device_settings', {
        'key': key,
        'value': on ? 'true' : 'false',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('save $key: $error');
    }
  }
}
