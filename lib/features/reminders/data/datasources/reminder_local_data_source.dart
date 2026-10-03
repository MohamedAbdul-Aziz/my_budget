import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/daily_reminder.dart';
import '../models/reminder_keys.dart';

abstract interface class ReminderLocalDataSource {
  Future<DailyReminder> read();

  Future<void> write(DailyReminder reminder);
}

/// The reminder is rows in the `settings` table under their own `reminder.`
/// keys ([ReminderKeys]).
class ReminderLocalDataSourceImpl implements ReminderLocalDataSource {
  const ReminderLocalDataSourceImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<DailyReminder> read() async {
    try {
      final db = await _appDatabase.database;
      final rows = await db.query(
        'settings',
        columns: ['key', 'value'],
        where: 'key LIKE ?',
        whereArgs: ['${ReminderKeys.prefix}%'],
      );
      return ReminderKeys.fromRows(rows);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('load reminder: $error');
    }
  }

  @override
  Future<void> write(DailyReminder reminder) async {
    try {
      final db = await _appDatabase.database;
      // Both rows or neither, so a sync never carries half a change.
      final batch = db.batch();
      for (final MapEntry(:key, :value) in ReminderKeys.encode(
        reminder,
      ).entries) {
        batch.insert(
          'settings',
          AppDatabase.changed({'key': key, 'value': value}),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } on DatabaseException catch (error) {
      throw DatabaseFailure('save reminder: $error');
    }
  }
}
