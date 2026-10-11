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

  /// What the AI assistant may see besides the totals, as JSON: chosen on
  /// each phone, like the agreement itself.
  static const String aiSharing = 'ai_sharing';

  /// A random id the AI assistant's server counts a guest's questions by.
  /// Phone-only, so a restore never hands one phone's count to another.
  static const String aiDeviceId = 'ai_device_id';

  final AppDatabase _appDatabase;

  /// Off unless it was turned on on this phone.
  Future<bool> readFlag(String key) async => await readValue(key) == 'true';

  Future<void> writeFlag(String key, {required bool on}) =>
      writeValue(key, on ? 'true' : 'false');

  /// Null when nothing was saved under [key] on this phone.
  Future<String?> readValue(String key) async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.query(
        'device_settings',
        columns: ['value'],
        where: 'key = ?',
        whereArgs: [key],
      );
      return rows.isEmpty ? null : rows.first['value'] as String?;
    } on DatabaseException catch (error) {
      throw DatabaseFailure('read $key: $error');
    }
  }

  Future<void> writeValue(String key, String value) async {
    try {
      final db = await _appDatabase.database;
      await db.insert('device_settings', {
        'key': key,
        'value': value,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('save $key: $error');
    }
  }
}
