import 'package:flutter_test/flutter_test.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/local_records.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/features/budgets/data/datasources/budget_local_data_source.dart';
import 'package:my_budget/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:my_budget/features/budgets/domain/entities/budget_limits.dart';
import 'package:my_budget/features/data_management/data/codecs/backup_codec.dart';
import 'package:my_budget/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:my_budget/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Budgets on the real SQLite data layer, including the trip they take with
/// the backup file and the cloud sync, which share [LocalRecords].
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

  test('a new phone has no budgets', () async {
    expect(await phoneA.limits(), const BudgetLimits());
  });

  test('stores the monthly and category budgets and reads them back', () async {
    await phoneA.budgets.saveMonthlyLimit(5000);
    await phoneA.budgets.saveCategoryLimit('cat_food', 200);
    await phoneA.budgets.saveCategoryLimit('cat_bills', 1250.5);

    expect(
      await phoneA.limits(),
      const BudgetLimits(
        monthly: 5000,
        byCategory: {'cat_food': 200, 'cat_bills': 1250.5},
      ),
    );
  });

  test('changing a budget replaces it, and removing it clears it', () async {
    await phoneA.budgets.saveMonthlyLimit(5000);
    await phoneA.budgets.saveCategoryLimit('cat_food', 200);

    await phoneA.budgets.saveMonthlyLimit(4000);
    await phoneA.budgets.saveCategoryLimit('cat_food', null);

    expect(await phoneA.limits(), const BudgetLimits(monthly: 4000));
  });

  test('every change is queued for the next backup', () async {
    await phoneA.budgets.saveMonthlyLimit(5000);
    await phoneA.budgets.saveCategoryLimit('cat_food', null);

    final pending = (await phoneA.records.readPending()).settings;
    expect(
      {for (final row in pending) row['key']: row['value']},
      // A removal is a row too: that is what carries it to other phones.
      {'budget.monthly': '5000.0', 'budget.category.cat_food': ''},
    );
  });

  test('ignores a stored value it cannot read', () async {
    final db = await phoneA.database.database;
    await db.insert(
      'settings',
      AppDatabase.changed({'key': 'budget.monthly', 'value': 'lots'}),
    );
    await db.insert(
      'settings',
      AppDatabase.changed({'key': 'budget.category.cat_food', 'value': '-3'}),
    );

    expect(await phoneA.limits(), const BudgetLimits());
  });

  test('leaves the other settings alone', () async {
    await phoneA.settings.saveCurrencySymbol('EGP');
    await phoneA.budgets.saveMonthlyLimit(5000);

    final settings = (await phoneA.settings.loadSettings()).dataOrNull!;
    expect(settings.currencySymbol, 'EGP');
    expect(await phoneA.limits(), const BudgetLimits(monthly: 5000));
  });

  test('budgets travel to another phone in a backup file', () async {
    await phoneA.budgets.saveMonthlyLimit(3000);
    await phoneA.budgets.saveCategoryLimit('cat_food', 450);

    final file = BackupCodec.encode(
      await phoneA.records.readAll(),
      exportedAt: DateTime(2026, 9, 28),
    );
    await phoneB.records.mergeNewest(
      BackupCodec.decode(file).records,
      fromCloud: false,
    );

    expect(
      await phoneB.limits(),
      const BudgetLimits(monthly: 3000, byCategory: {'cat_food': 450}),
    );
  });

  test('a newer removal wins over an older budget', () async {
    await phoneB.budgets.saveMonthlyLimit(3000);
    // Settings rows are stamped in milliseconds; make the removal later.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await phoneA.budgets.saveMonthlyLimit(null);

    await phoneB.records.mergeNewest(
      await phoneA.records.readAll(),
      fromCloud: false,
    );

    expect((await phoneB.limits()).monthly, isNull);
  });
}

/// One phone: its own database file and the repositories budgets touch.
class Phone {
  Phone(String name)
    : fileName =
          'budget_test_${name}_${DateTime.now().microsecondsSinceEpoch}.db' {
    database = AppDatabase(fileName: fileName);
    records = LocalRecords(database);
    budgets = BudgetRepositoryImpl(BudgetLocalDataSourceImpl(database));
    settings = SettingsRepositoryImpl(SettingsLocalDataSourceImpl(database));
  }

  final String fileName;
  late final AppDatabase database;
  late final LocalRecords records;
  late final BudgetRepositoryImpl budgets;
  late final SettingsRepositoryImpl settings;

  Future<BudgetLimits> limits() async =>
      (await budgets.getLimits()).dataOrNull!;

  Future<void> dispose() async {
    await database.close();
    await deleteDatabase(p.join(await getDatabasesPath(), fileName));
  }
}
