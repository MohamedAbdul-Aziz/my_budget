import '../../domain/entities/daily_reminder.dart';

/// How the reminder is stored: rows in the `settings` table under their own
/// `reminder.` keys.
///
/// That table already travels with the cloud backup and the backup file, the
/// newest change winning, so the reminder needs no table, column or server
/// change of its own, and an older version of the app simply ignores the rows.
abstract final class ReminderKeys {
  static const String prefix = 'reminder.';
  static const String enabled = '${prefix}enabled';
  static const String time = '${prefix}time';

  static final RegExp _timePattern = RegExp(r'^(\d{2}):(\d{2})$');

  /// The rows for [reminder]; the time is kept while it is off, so turning it
  /// back on brings back the time the user chose.
  static Map<String, String> encode(DailyReminder reminder) => {
    enabled: reminder.enabled ? 'true' : 'false',
    time: '${_twoDigits(reminder.hour)}:${_twoDigits(reminder.minute)}',
  };

  /// The reminder among [rows] of the `settings` table. A missing or
  /// unreadable value, which only a damaged copy could hold, keeps its
  /// default.
  static DailyReminder fromRows(Iterable<Map<String, Object?>> rows) {
    final values = {
      for (final row in rows) row['key']! as String: row['value']! as String,
    };
    final reminder = DailyReminder(enabled: values[enabled] == 'true');

    final match = _timePattern.firstMatch(values[time] ?? '');
    if (match == null) return reminder;
    final hour = int.parse(match[1]!);
    final minute = int.parse(match[2]!);
    return hour < 24 && minute < 60
        ? reminder.copyWith(hour: hour, minute: minute)
        : reminder;
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
