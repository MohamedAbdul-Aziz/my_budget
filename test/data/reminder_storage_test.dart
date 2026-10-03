import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/local_records.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/features/data_management/data/codecs/backup_codec.dart';
import 'package:my_budget/features/reminders/data/datasources/reminder_local_data_source.dart';
import 'package:my_budget/features/reminders/data/datasources/reminder_notifications_data_source.dart';
import 'package:my_budget/features/reminders/data/repositories/reminder_repository_impl.dart';
import 'package:my_budget/features/reminders/domain/entities/daily_reminder.dart';
import 'package:my_budget/features/reminders/domain/entities/reminder_message.dart';
import 'package:my_budget/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:my_budget/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const _words = ReminderMessage(
  title: "Log today's spending",
  body: 'Take a moment to add what you spent today.',
  channelName: 'Daily reminder',
);
const _halfPastSeven = DailyReminder(enabled: true, hour: 7, minute: 30);

/// The reminder on the real SQLite data layer, including the trip it takes
/// with the backup file and the cloud sync, which share [LocalRecords].
void main() {
  late Phone phoneA;
  late Phone phoneB;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    phoneA = Phone('a');
    phoneB = Phone('b');
  });

  tearDown(() async {
    await phoneA.dispose();
    await phoneB.dispose();
  });

  test('a new phone has the reminder off, set for 9 PM', () async {
    expect(await phoneA.reminder(), const DailyReminder(hour: 21));
  });

  test('stores the reminder and reads it back', () async {
    await phoneA.reminders.saveReminder(_halfPastSeven);

    expect(await phoneA.reminder(), _halfPastSeven);
  });

  test('turning it off keeps the chosen time', () async {
    await phoneA.reminders.saveReminder(_halfPastSeven);
    await phoneA.reminders.saveReminder(
      _halfPastSeven.copyWith(enabled: false),
    );

    expect(await phoneA.reminder(), _halfPastSeven.copyWith(enabled: false));
  });

  test('every change is queued for the next backup', () async {
    await phoneA.reminders.saveReminder(_halfPastSeven);

    final pending = (await phoneA.records.readPending()).settings;
    expect(
      {for (final row in pending) row['key']: row['value']},
      {'reminder.enabled': 'true', 'reminder.time': '07:30'},
    );
  });

  test('ignores a stored value it cannot read', () async {
    final db = await phoneA.database.database;
    await db.insert(
      'settings',
      AppDatabase.changed({'key': 'reminder.enabled', 'value': 'yes'}),
    );
    await db.insert(
      'settings',
      AppDatabase.changed({'key': 'reminder.time', 'value': '25:00'}),
    );

    expect(await phoneA.reminder(), const DailyReminder());
  });

  test('leaves the other settings alone', () async {
    await phoneA.settings.saveCurrencySymbol('EGP');
    await phoneA.reminders.saveReminder(_halfPastSeven);

    final settings = (await phoneA.settings.loadSettings()).dataOrNull!;
    expect(settings.currencySymbol, 'EGP');
    expect(await phoneA.reminder(), _halfPastSeven);
  });

  test('the reminder travels to another phone in a backup file', () async {
    await phoneA.reminders.saveReminder(_halfPastSeven);

    final file = BackupCodec.encode(
      await phoneA.records.readAll(),
      exportedAt: DateTime(2026, 10, 1),
    );
    await phoneB.records.mergeNewest(
      BackupCodec.decode(file).records,
      fromCloud: false,
    );

    expect(await phoneB.reminder(), _halfPastSeven);
  });

  test(
    'schedules the reminder while it is on and cancels it when off',
    () async {
      await phoneA.reminders.schedule(_halfPastSeven, _words);
      expect(phoneA.notifications.scheduled, (7, 30, _words));

      await phoneA.reminders.schedule(
        _halfPastSeven.copyWith(enabled: false),
        _words,
      );
      expect(phoneA.notifications.scheduled, isNull);
    },
  );
}

/// The phone's scheduler, without the plugin: remembers what is scheduled.
class RecordingNotifications implements ReminderNotificationsDataSource {
  (int, int, ReminderMessage)? scheduled;

  @override
  bool get isSupported => true;

  @override
  Future<bool> areAllowed() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderMessage message,
  }) async => scheduled = (hour, minute, message);

  @override
  Future<void> cancel() async => scheduled = null;
}

/// One phone: its own database file and the repositories the reminder
/// touches.
class Phone {
  Phone(String name)
    : fileName =
          'reminder_test_${name}_${DateTime.now().microsecondsSinceEpoch}.db' {
    database = AppDatabase(fileName: fileName);
    records = LocalRecords(database);
    reminders = ReminderRepositoryImpl(
      local: ReminderLocalDataSourceImpl(database),
      notifications: notifications,
    );
    settings = SettingsRepositoryImpl(SettingsLocalDataSourceImpl(database));
  }

  final String fileName;
  final RecordingNotifications notifications = RecordingNotifications();
  late final AppDatabase database;
  late final LocalRecords records;
  late final ReminderRepositoryImpl reminders;
  late final SettingsRepositoryImpl settings;

  Future<DailyReminder> reminder() async =>
      (await reminders.getReminder()).dataOrNull!;

  Future<void> dispose() async {
    await database.close();
    await deleteDatabase(p.join(await getDatabasesPath(), fileName));
  }
}
