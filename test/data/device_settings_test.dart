import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/device_settings.dart';
import 'package:my_budget/core/database/local_records.dart';
import 'package:my_budget/features/data_management/data/codecs/backup_codec.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Phone-only preferences stay on the phone: they never reach the cloud or a
/// backup file, and a restore or import never changes them.
void main() {
  late AppDatabase database;
  late DeviceSettings settings;
  late LocalRecords records;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    database = AppDatabase(inMemory: true);
    settings = DeviceSettings(database);
    records = LocalRecords(database);
  });

  tearDown(() => database.close());

  test('everything is off on a new phone', () async {
    expect(await settings.readFlag(DeviceSettings.autoBackup), isFalse);
    expect(await settings.readFlag(DeviceSettings.appLock), isFalse);
  });

  test('keeps each switch as it was set', () async {
    await settings.writeFlag(DeviceSettings.autoBackup, on: true);
    await settings.writeFlag(DeviceSettings.appLock, on: true);
    await settings.writeFlag(DeviceSettings.appLock, on: false);

    expect(await settings.readFlag(DeviceSettings.autoBackup), isTrue);
    expect(await settings.readFlag(DeviceSettings.appLock), isFalse);
  });

  test('never travels with a backup, and a restore never changes it', () async {
    await settings.writeFlag(DeviceSettings.appLock, on: true);

    // Nothing queued for the cloud mentions it.
    final pending = BackupCodec.encode(
      await records.readPending(),
      exportedAt: DateTime(2026, 10, 1),
    );
    expect(pending, isNot(contains('app_lock')));
    final file = BackupCodec.encode(
      await records.readAll(),
      exportedAt: DateTime(2026, 10, 1),
    );
    expect(file, isNot(contains('app_lock')));

    // Replacing everything with the file keeps this phone's own choices.
    await records.replaceAll(BackupCodec.decode(file).records);
    expect(await settings.readFlag(DeviceSettings.appLock), isTrue);
  });
}
