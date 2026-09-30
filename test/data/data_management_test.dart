import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/local_records.dart';
import 'package:my_budget/core/database/record_batch.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/core/l10n/app_strings.dart';
import 'package:my_budget/features/budgets/data/datasources/budget_local_data_source.dart';
import 'package:my_budget/features/categories/data/datasources/category_local_data_source.dart';
import 'package:my_budget/features/categories/data/repositories/category_repository_impl.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
import 'package:my_budget/features/categories/domain/entities/transaction_type.dart';
import 'package:my_budget/features/data_management/data/codecs/backup_codec.dart';
import 'package:my_budget/features/data_management/data/codecs/csv_export.dart';
import 'package:my_budget/features/data_management/data/datasources/device_files_data_source.dart';
import 'package:my_budget/features/data_management/data/datasources/report_fonts_data_source.dart';
import 'package:my_budget/features/data_management/data/repositories/data_management_repository_impl.dart';
import 'package:my_budget/features/data_management/domain/entities/export_format.dart';
import 'package:my_budget/features/data_management/domain/entities/export_locale.dart';
import 'package:my_budget/features/data_management/domain/entities/exported_file.dart';
import 'package:my_budget/features/data_management/domain/entities/import_mode.dart';
import 'package:my_budget/features/data_management/domain/entities/share_anchor.dart';
import 'package:my_budget/features/data_management/domain/usecases/choose_backup.dart';
import 'package:my_budget/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:my_budget/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:my_budget/features/expenses/domain/entities/expense.dart';
import 'package:my_budget/features/expenses/domain/entities/month.dart';
import 'package:my_budget/features/people/data/datasources/people_local_data_source.dart';
import 'package:my_budget/features/people/data/repositories/people_repository_impl.dart';
import 'package:my_budget/features/people/domain/entities/person.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction.dart';
import 'package:my_budget/features/people/domain/entities/person_transaction_type.dart';
import 'package:my_budget/features/recurring/data/datasources/recurring_local_data_source.dart';
import 'package:my_budget/features/recurring/data/repositories/recurring_repository_impl.dart';
import 'package:my_budget/features/recurring/domain/entities/recurrence_frequency.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_expense.dart';
import 'package:my_budget/features/recurring/domain/entities/recurring_mode.dart';
import 'package:my_budget/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:my_budget/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:my_budget/features/settings/domain/entities/app_settings.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Local backup, export and import against the real SQLite data layer, the
/// real file formats and background isolates. Only the phone's file plugins
/// (share sheet, save dialog, file chooser) are stood in for.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory folder;
  late Phone phoneA;
  late Phone phoneB;

  const english = ExportLocale(
    languageCode: 'en',
    formatsLocale: 'en_US',
    currencySymbol: r'$',
  );
  const arabic = ExportLocale(
    languageCode: 'ar',
    formatsLocale: 'ar',
    currencySymbol: 'ج.م',
  );
  final august = DateTime(2026, 8, 4);

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await initializeDateFormatting();
  });

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('data_management_test');
    phoneA = Phone('a', folder);
    phoneB = Phone('b', folder);
  });

  tearDown(() async {
    await phoneA.dispose();
    await phoneB.dispose();
    await folder.delete(recursive: true);
  });

  group('JSON backup', () {
    test('holds every record with its original ids and timestamps', () async {
      final lunch = await phoneA.addExpense(12.5, note: 'غداء مع الفريق');
      final dinner = await phoneA.addExpense(20);
      await phoneA.expenses.deleteExpense(dinner.id);
      await phoneA.settingsRepo.saveCurrencySymbol('€');

      final file = await phoneA.export(ExportFormat.backup, english);
      expect(file.name, endsWith('.mybudget.json'));
      final json =
          jsonDecode(await File(file.path).readAsString())
              as Map<String, dynamic>;

      expect(json['format'], 'my_budget_backup');
      expect(json['schema_version'], BackupCodec.schemaVersion);
      expect(json.keys, {
        'format',
        'schema_version',
        'app',
        'exported_at',
        'categories',
        'expenses',
        'settings',
        'recurring_expenses',
        'people',
        'settlements',
        'person_transactions',
        'person_transaction_edits',
      });
      final expenses = json['expenses'] as List;
      final stored = (await phoneA.records.readAll()).expenses;
      final storedLunch = stored.firstWhere((row) => row['id'] == lunch.id);
      final exportedLunch = expenses.firstWhere((row) => row['id'] == lunch.id);
      expect(exportedLunch['description'], 'غداء مع الفريق');
      expect(exportedLunch['created_at'], storedLunch['created_at']);
      expect(exportedLunch['updated_at'], storedLunch['updated_at']);
      // The delete travels with the file.
      expect(
        expenses.firstWhere((row) => row['id'] == dinner.id)['deleted_at'],
        isNotNull,
      );
      // Only records: no sync bookkeeping, no account.
      final text = await File(file.path).readAsString();
      expect(text, isNot(contains('dirty')));
      expect(text, isNot(contains('user_id')));
      expect(text, isNot(contains('owner')));
    });

    test('income travels with the file and stays income', () async {
      final salary = await phoneA.addExpense(2000, categoryId: 'cat_salary');
      final backup = await phoneA.export(ExportFormat.backup, english);

      await phoneB.importFile(backup, ImportMode.merge);

      final month = await phoneB.monthOf(august);
      final imported = month.singleWhere((e) => e.id == salary.id);
      expect(imported.isIncome, isTrue);
      expect(imported.category.id, 'cat_salary');
    });

    test('recurring payments travel with the file', () async {
      final rent = await phoneA.addRecurring('Rent');
      await phoneA.recurring.recordPayment(
        rent,
        due: DateTime(2026, 8, 1),
        paidAt: august,
      );
      final backup = await phoneA.export(ExportFormat.backup, english);

      await phoneB.importFile(backup, ImportMode.merge);

      final imported = (await phoneB.recurring.getRecurring()).dataOrNull!;
      expect(imported.single.id, rent.id);
      expect(imported.single.frequency, RecurrenceFrequency.yearly);
      expect(imported.single.dueMonth, 2);
      expect(imported.single.isAutomatic, isTrue);
      expect(imported.single.paidThrough, DateTime(2026, 8, 1));
      expect((await phoneB.monthOf(august)).single.description, 'Rent');
    });

    test('a backup from before recurring payments existed imports', () async {
      await phoneA.addExpense(12.5, note: 'Lunch');
      final backup = await phoneA.export(ExportFormat.backup, english);
      final json =
          jsonDecode(await File(backup.path).readAsString())
              as Map<String, dynamic>;
      json['schema_version'] = 2;
      json.remove('recurring_expenses');
      await File(backup.path).writeAsString(jsonEncode(json));
      await phoneB.addRecurring('Only on this phone');

      await phoneB.importFile(backup, ImportMode.merge);

      expect((await phoneB.monthOf(august)).single.description, 'Lunch');
      final kept = (await phoneB.recurring.getRecurring()).dataOrNull!;
      expect(kept.single.title, 'Only on this phone');
    });

    test('people and their full ledger travel with the file', () async {
      final sara = await phoneA.addPerson('سارة', phone: '+20 100');
      final lunch = await phoneA.addDebt(sara, 20, note: 'Lunch');
      await phoneA.people.updateTransaction(
        id: lunch.id,
        amount: 24,
        type: PersonTransactionType.iPaidForThem,
        date: august,
        note: 'Lunch',
      );
      await phoneA.people.settleUp(sara.id);
      await phoneA.addDebt(
        sara,
        7.5,
        type: PersonTransactionType.theyPaidForMe,
      );
      final backup = await phoneA.export(ExportFormat.backup, english);

      final preview = (await phoneB.repository.previewBackup(
        backup.path,
      )).dataOrNull!;
      expect(preview.people, 1);
      await phoneB.importFile(backup, ImportMode.merge);

      expect(
        (await phoneB.people.getLedger(sara.id)).dataOrNull,
        (await phoneA.people.getLedger(sara.id)).dataOrNull,
      );
    });

    test('a backup from before people existed imports, and keeps the '
        "phone's people", () async {
      await phoneA.addExpense(12.5, note: 'Lunch');
      final backup = await phoneA.export(ExportFormat.backup, english);
      final json =
          jsonDecode(await File(backup.path).readAsString())
              as Map<String, dynamic>;
      json['schema_version'] = 3;
      for (final table in AppDatabase.peopleTables) {
        json.remove(table);
      }
      await File(backup.path).writeAsString(jsonEncode(json));
      final omar = await phoneB.addPerson('Omar');
      await phoneB.addDebt(omar, 10);

      await phoneB.importFile(backup, ImportMode.merge);

      expect((await phoneB.monthOf(august)).single.description, 'Lunch');
      final kept = (await phoneB.people.getPeople()).dataOrNull!;
      expect(kept.single.balance.cents, 1000);
    });

    test(
      'replacing removes people the file lacks, with their ledger',
      () async {
        final backup = await phoneA.export(ExportFormat.backup, english);
        final omar = await phoneB.addPerson('Omar');
        await phoneB.addDebt(omar, 10);

        await phoneB.importFile(backup, ImportMode.replace);

        expect((await phoneB.people.getPeople()).dataOrNull, isEmpty);
        final db = await phoneB.database.database;
        final transactions = await db.query('person_transactions');
        expect(transactions.single['deleted_at'], isNotNull);
      },
    );

    test('replacing removes recurring payments the file lacks', () async {
      final kept = await phoneA.addRecurring('Rent');
      final backup = await phoneA.export(ExportFormat.backup, english);
      await phoneB.addRecurring('Gym');

      await phoneB.importFile(backup, ImportMode.replace);

      final left = (await phoneB.recurring.getRecurring()).dataOrNull!;
      expect(left.map((r) => r.id), [kept.id]);
    });

    test('a backup from before income existed imports as spending', () async {
      final pets = await phoneA.addCategory('Pets');
      final vet = await phoneA.addExpense(8, categoryId: pets.id);
      final backup = await phoneA.export(ExportFormat.backup, english);

      // Exactly what version 1 of the file looked like: no types, and no
      // income categories.
      final json =
          jsonDecode(await File(backup.path).readAsString())
              as Map<String, dynamic>;
      json['schema_version'] = 1;
      final categories = json['categories'] as List;
      categories.removeWhere((row) => (row as Map)['type'] == 'income');
      for (final row in categories) {
        (row as Map).remove('type');
      }
      await File(backup.path).writeAsString(jsonEncode(json));

      await phoneB.importFile(backup, ImportMode.merge);

      final imported = (await phoneB.monthOf(
        august,
      )).singleWhere((e) => e.id == vet.id);
      expect(imported.category.name, 'Pets');
      expect(imported.isIncome, isFalse);
    });

    test('importing into an empty phone restores everything', () async {
      final lunch = await phoneA.addExpense(12.5, note: 'Lunch');
      final pets = await phoneA.addCategory('Pets');
      await phoneA.addExpense(8, categoryId: pets.id, note: 'Vet');
      await phoneA.settingsRepo.saveCurrencySymbol('€');
      final backup = await phoneA.export(ExportFormat.backup, english);

      final changes = await phoneB.importFile(backup, ImportMode.merge);

      expect(changes, greaterThan(0));
      final month = await phoneB.monthOf(august);
      expect(month.map((e) => e.id), contains(lunch.id));
      expect(
        month.firstWhere((e) => e.description == 'Vet').category.name,
        'Pets',
      );
      final settings = (await phoneB.settingsRepo.loadSettings()).dataOrNull!;
      expect(settings.currencySymbol, '€');
    });

    test('importing the same backup twice changes nothing', () async {
      await phoneA.addExpense(12.5);
      await phoneA.addExpense(7);
      final backup = await phoneA.export(ExportFormat.backup, english);

      await phoneB.importFile(backup, ImportMode.merge);
      final again = await phoneB.importFile(backup, ImportMode.merge);

      expect(again, 0);
      expect(await phoneB.monthOf(august), hasLength(2));
    });

    test('merging keeps what only this phone has', () async {
      await phoneA.addExpense(12.5, note: 'From the backup');
      final backup = await phoneA.export(ExportFormat.backup, english);
      await phoneB.addExpense(3, note: 'Only on this phone');

      await phoneB.importFile(backup, ImportMode.merge);

      final notes = (await phoneB.monthOf(august)).map((e) => e.description);
      expect(notes, containsAll(['From the backup', 'Only on this phone']));
    });

    test('the newer change to a record wins, whichever side has it', () async {
      final lunch = await phoneA.addExpense(10);
      final first = await phoneA.export(ExportFormat.backup, english);
      await phoneB.importFile(first, ImportMode.merge);

      // An older backup never undoes a newer edit made on this phone.
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await phoneB.setAmount(lunch.id, 99);
      await phoneB.importFile(first, ImportMode.merge);
      expect((await phoneB.monthOf(august)).single.amount, 99);

      // A newer edit in the backup replaces the phone's older one.
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await phoneA.setAmount(lunch.id, 30);
      final second = await phoneA.export(ExportFormat.backup, english);
      await phoneB.importFile(second, ImportMode.merge);
      expect((await phoneB.monthOf(august)).single.amount, 30);
    });

    test('a newer delete in the backup removes the record here', () async {
      final lunch = await phoneA.addExpense(10);
      await phoneB.importFile(
        await phoneA.export(ExportFormat.backup, english),
        ImportMode.merge,
      );

      await phoneA.expenses.deleteExpense(lunch.id);
      await phoneB.importFile(
        await phoneA.export(ExportFormat.backup, english),
        ImportMode.merge,
      );

      expect(await phoneB.monthOf(august), isEmpty);
    });

    test('imported records wait for the next cloud backup', () async {
      final lunch = await phoneA.addExpense(10);
      final backup = await phoneA.export(ExportFormat.backup, english);

      await phoneB.importFile(backup, ImportMode.merge);

      final pending = await phoneB.records.readPending();
      expect(pending.expenses.map((row) => row['id']), contains(lunch.id));
    });

    test('replacing makes the phone hold exactly the backup', () async {
      final lunch = await phoneA.addExpense(12.5, note: 'From the backup');
      final backup = await phoneA.export(ExportFormat.backup, english);

      final extra = await phoneB.addExpense(3, note: 'Only on this phone');
      final gym = await phoneB.addCategory('Gym');
      await phoneB.settingsRepo.saveCurrencySymbol('£');

      final before = DateTime.now().millisecondsSinceEpoch;
      await phoneB.importFile(backup, ImportMode.replace);

      final month = await phoneB.monthOf(august);
      expect(month.map((e) => e.id), [lunch.id]);
      final names = (await phoneB.categories.getCategories()).dataOrNull!.map(
        (c) => c.id,
      );
      expect(names, isNot(contains(gym.id)));
      expect(names, contains(ExpenseCategory.fallbackId));
      final settings = (await phoneB.settingsRepo.loadSettings()).dataOrNull!;
      expect(settings.currencySymbol, isNull);

      // Kept as deletes, and every change is newer than any older copy in
      // the cloud, so a later cloud backup carries the replacement.
      final all = await phoneB.records.readAll();
      final removed = all.expenses.firstWhere((row) => row['id'] == extra.id);
      expect(removed['deleted_at'], isNotNull);
      final replaced = all.expenses.firstWhere((row) => row['id'] == lunch.id);
      expect(replaced['updated_at'] as int, greaterThanOrEqualTo(before));
      expect(replaced['dirty'], 1);
      expect(replaced['created_at'], lunch.createdAt.millisecondsSinceEpoch);
    });

    test('an expense whose category is missing lands in Other', () async {
      final batch = RecordBatch({
        'expenses': [
          _expenseRow('exp_orphan', categoryId: 'cat_nowhere', updatedAt: 1),
        ],
      });

      await phoneB.records.mergeNewest(batch, fromCloud: false);

      final orphan = (await phoneB.monthOf(august)).single;
      expect(orphan.category.id, ExpenseCategory.fallbackId);
    });
  });

  group('invalid backup files change nothing', () {
    Future<FailureCode?> importText(String text) async {
      final path = p.join(folder.path, 'candidate.json');
      await File(path).writeAsString(text);
      final result = await phoneB.repository.importBackup(
        path,
        ImportMode.merge,
      );
      return result.failureOrNull?.code;
    }

    late String valid;

    setUp(() async {
      await phoneA.addExpense(12.5);
      valid = await File(
        (await phoneA.export(ExportFormat.backup, english)).path,
      ).readAsString();
    });

    Future<void> expectUnchanged() async =>
        expect(await phoneB.monthOf(august), isEmpty);

    test('not JSON at all', () async {
      expect(await importText('hello'), FailureCode.backupNotRecognized);
      await expectUnchanged();
    });

    test('JSON from something else', () async {
      expect(
        await importText('{"name": "not a backup"}'),
        FailureCode.backupNotRecognized,
      );
      await expectUnchanged();
    });

    test('made by a newer version of the app', () async {
      final json = jsonDecode(valid) as Map<String, dynamic>;
      json['schema_version'] = BackupCodec.schemaVersion + 1;
      expect(await importText(jsonEncode(json)), FailureCode.backupTooNew);
      await expectUnchanged();
    });

    test('a record with a missing field', () async {
      final json = jsonDecode(valid) as Map<String, dynamic>;
      ((json['expenses'] as List).first as Map).remove('amount');
      expect(await importText(jsonEncode(json)), FailureCode.backupDamaged);
      await expectUnchanged();
    });

    test('a category that is neither spending nor income', () async {
      final json = jsonDecode(valid) as Map<String, dynamic>;
      ((json['categories'] as List).first as Map)['type'] = 'transfer';
      expect(await importText(jsonEncode(json)), FailureCode.backupDamaged);
      await expectUnchanged();
    });

    test('a recurring payment with an unknown schedule', () async {
      await phoneA.addRecurring('Rent');
      valid = await File(
        (await phoneA.export(ExportFormat.backup, english)).path,
      ).readAsString();
      final json = jsonDecode(valid) as Map<String, dynamic>;
      ((json['recurring_expenses'] as List).single as Map)['frequency'] =
          'daily';
      expect(await importText(jsonEncode(json)), FailureCode.backupDamaged);
      await expectUnchanged();
      expect((await phoneB.recurring.getRecurring()).dataOrNull, isEmpty);
    });

    test('a person transaction that is neither way round', () async {
      final sara = await phoneA.addPerson('Sara');
      await phoneA.addDebt(sara, 5);
      valid = await File(
        (await phoneA.export(ExportFormat.backup, english)).path,
      ).readAsString();
      final json = jsonDecode(valid) as Map<String, dynamic>;
      ((json['person_transactions'] as List).single as Map)['type'] = 'gift';
      expect(await importText(jsonEncode(json)), FailureCode.backupDamaged);
      await expectUnchanged();
      expect((await phoneB.people.getPeople()).dataOrNull, isEmpty);
    });

    test('the same id twice', () async {
      final json = jsonDecode(valid) as Map<String, dynamic>;
      final expenses = json['expenses'] as List;
      expenses.add(Map<String, dynamic>.from(expenses.first as Map));
      expect(await importText(jsonEncode(json)), FailureCode.backupDamaged);
      await expectUnchanged();
    });

    test('a file that is not text', () async {
      final path = p.join(folder.path, 'photo.jpg');
      await File(path).writeAsBytes([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0xC3]);
      final result = await phoneB.repository.previewBackup(path);
      expect(result.failureOrNull?.code, FailureCode.backupNotRecognized);
    });

    test('a file that no longer exists', () async {
      final result = await phoneB.repository.previewBackup(
        p.join(folder.path, 'gone.json'),
      );
      expect(result.failureOrNull?.code, FailureCode.fileUnavailable);
    });

    test('a byte order mark in front is fine', () async {
      expect(await importText('﻿$valid'), isNull);
    });
  });

  group('a failure part way through rolls everything back', () {
    test('when merging', () async {
      final batch = RecordBatch({
        'expenses': [
          _expenseRow('exp_good', updatedAt: 1),
          {..._expenseRow('exp_bad', updatedAt: 1), 'amount': null},
        ],
      });

      await expectLater(
        phoneB.records.mergeNewest(batch, fromCloud: false),
        throwsA(isA<DatabaseFailure>()),
      );
      expect(await phoneB.monthOf(august), isEmpty);
    });

    test('when replacing', () async {
      final kept = await phoneB.addExpense(5, note: 'Still here');
      final batch = RecordBatch({
        'expenses': [
          _expenseRow('exp_good', updatedAt: 1),
          {..._expenseRow('exp_bad', updatedAt: 1), 'amount': null},
        ],
      });

      await expectLater(
        phoneB.records.replaceAll(batch),
        throwsA(isA<DatabaseFailure>()),
      );
      expect((await phoneB.monthOf(august)).map((e) => e.id), [kept.id]);
    });
  });

  group('CSV', () {
    test('opens in any spreadsheet, Arabic included', () async {
      final pets = await phoneA.addCategory('حيوانات أليفة');
      await phoneA.addExpense(12.5, categoryId: pets.id, note: 'طعام, ولعبة');
      await phoneA.addExpense(3, note: '=HYPERLINK("x")');
      final gone = await phoneA.addExpense(99, note: 'Deleted');
      await phoneA.expenses.deleteExpense(gone.id);

      final files = await phoneA.exportAll(ExportFormat.spreadsheet, arabic);
      expect(files.map((f) => f.name), [
        startsWith('my_budget_expenses_'),
        startsWith('my_budget_categories_'),
      ]);
      final bytes = await File(files.first.path).readAsBytes();
      // UTF-8 with a byte order mark, so Excel reads the Arabic.
      expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
      final text = utf8.decode(bytes);
      final lines = text
          .replaceFirst(CsvExport.byteOrderMark, '')
          .split('\r\n');

      expect(
        lines.first,
        'التاريخ,الشهر,الفئة,النوع,المبلغ,العملة,ملاحظة,المعرّف',
      );
      expect(text, contains('حيوانات أليفة'));
      // A comma inside a note is quoted, not a new column.
      expect(text, contains('"طعام, ولعبة"'));
      expect(text, contains('2026-08-04,2026-08,'));
      expect(text, contains(',12.50,ج.م,'));
      // Text a spreadsheet would run as a formula is defused.
      expect(text, contains(''''=HYPERLINK(""x"")'''));
      expect(text, isNot(contains('Deleted')));
      expect(lines.where((line) => line.isNotEmpty), hasLength(3));

      final categories = utf8.decode(await File(files.last.path).readAsBytes());
      expect(categories, contains('حيوانات أليفة,مصروف,لا,1,12.50,'));
    });

    test('recurring payments get a sheet of their own', () async {
      final rent = await phoneA.addRecurring('Rent, flat 4');
      await phoneA.recurring.recordPayment(
        rent,
        due: DateTime(2027, 2, 28),
        paidAt: august,
      );

      final files = await phoneA.exportAll(ExportFormat.spreadsheet, english);
      expect(files.map((f) => f.name), [
        startsWith('my_budget_expenses_'),
        startsWith('my_budget_categories_'),
        startsWith('my_budget_recurring_'),
      ]);
      final lines = utf8
          .decode(await File(files.last.path).readAsBytes())
          .replaceFirst(CsvExport.byteOrderMark, '')
          .split('\r\n');
      expect(
        lines.first,
        'Name,Category,Amount,Currency,Repeats,When it\'s due,Paid through,ID',
      );
      expect(
        lines[1],
        '"Rent, flat 4",Bills,900.00,\$,Yearly on Feb 29,Auto-deduct,'
        '2027-02-28,${rent.id}',
      );
    });

    test('people and their debts get two sheets of their own', () async {
      final sara = await phoneA.addPerson('Sara', phone: '+20 100');
      final lunch = await phoneA.addDebt(sara, 20, note: 'Lunch, team');
      await phoneA.people.updateTransaction(
        id: lunch.id,
        amount: 24,
        type: PersonTransactionType.iPaidForThem,
        date: august,
        note: 'Lunch, team',
      );
      await phoneA.people.settleUp(sara.id);
      final taxi = await phoneA.addDebt(
        sara,
        7.5,
        type: PersonTransactionType.theyPaidForMe,
        note: 'Taxi',
      );

      final files = await phoneA.exportAll(ExportFormat.spreadsheet, english);
      expect(files.map((f) => f.name), [
        startsWith('my_budget_expenses_'),
        startsWith('my_budget_categories_'),
        startsWith('my_budget_people_'),
        startsWith('my_budget_debts_'),
        startsWith('my_budget_settlements_'),
      ]);
      List<String> lines(ExportedFile file) => utf8
          .decode(File(file.path).readAsBytesSync())
          .replaceFirst(CsvExport.byteOrderMark, '')
          .split('\r\n');

      final people = lines(files[2]);
      expect(people.first, 'Person,Phone,Status,Balance,Open,Created,ID');
      // The phone gets the formula guard like any other text.
      expect(people[1], startsWith("Sara,'+20 100,You owe,7.50,1,"));

      final debts = lines(files[3]);
      expect(
        debts.first,
        'Person,Date,Type,Amount,Currency,Note,Status,Settled on,Created,'
        'Last edited,Edits,ID',
      );
      expect(
        debts[1],
        allOf(
          startsWith('Sara,2026-08-04,They paid for me,7.50,\$,Taxi,Open,,'),
          endsWith(',,0,${taxi.id}'),
        ),
      );
      expect(
        debts[2],
        allOf(
          startsWith(
            'Sara,2026-08-04,I paid for them,24.00,\$,"Lunch, team",Settled,',
          ),
          endsWith(',1,${lunch.id}'),
        ),
      );

      final settlements = lines(files[4]);
      expect(
        settlements.first,
        'Person,Settled on,Type,Amount,Currency,Transactions,ID',
      );
      expect(
        settlements[1],
        matches(r'^Sara,\d{4}-\d{2}-\d{2},They paid you,24\.00,\$,1,'),
      );
    });

    test('budgets get a sheet of their own', () async {
      final pets = await phoneA.addCategory('Pets');
      final gone = await phoneA.addCategory('Old');
      final budgets = BudgetLocalDataSourceImpl(phoneA.database);
      await budgets.writeMonthly(1500);
      await budgets.writeCategory(pets.id, 200);
      await budgets.writeCategory(gone.id, 50);
      await phoneA.categories.deleteCategory(gone.id);
      // A removed budget is an empty value, which is no budget at all.
      await budgets.writeCategory('cat_food', 300);
      await budgets.writeCategory('cat_food', null);

      final files = await phoneA.exportAll(ExportFormat.spreadsheet, english);
      expect(files.last.name, startsWith('my_budget_budgets_'));
      final lines = utf8
          .decode(await File(files.last.path).readAsBytes())
          .replaceFirst(CsvExport.byteOrderMark, '')
          .split('\r\n');
      expect(lines.where((line) => line.isNotEmpty), [
        'Category,Amount,Currency,ID',
        'Monthly budget,1500.00,\$,',
        'Pets,200.00,\$,${pets.id}',
      ]);
    });

    test('no people sheets for someone with no people', () async {
      await phoneA.addExpense(12.5);
      final files = await phoneA.exportAll(ExportFormat.spreadsheet, english);
      expect(files, hasLength(2));
    });

    test('quotes fields that need it', () {
      expect(CsvExport.field('plain'), 'plain');
      expect(CsvExport.field('a,b'), '"a,b"');
      expect(CsvExport.field('say "hi"'), '"say ""hi"""');
      expect(CsvExport.field('two\nlines'), '"two\nlines"');
      expect(CsvExport.field('+1 555'), "'+1 555");
    });
  });

  group('PDF', () {
    test('is a readable report, in Arabic and right to left', () async {
      final pets = await phoneA.addCategory('حيوانات أليفة');
      await phoneA.addExpense(12.5, categoryId: pets.id, note: 'زيارة الطبيب');
      await phoneA.addExpense(40, note: 'Groceries');

      final file = await phoneA.export(ExportFormat.report, arabic);

      expect(file.name, endsWith('.pdf'));
      expect(file.mimeType, 'application/pdf');
      final bytes = await File(file.path).readAsBytes();
      expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
      expect(bytes.length, greaterThan(1000));
    });

    test('lists income and budgets, in Arabic too', () async {
      await phoneA.addExpense(40, note: 'Groceries');
      await phoneA.addExpense(2500, categoryId: 'cat_salary', note: 'راتب');
      await BudgetLocalDataSourceImpl(phoneA.database).writeMonthly(1500);

      for (final locale in [english, arabic]) {
        final file = await phoneA.export(ExportFormat.report, locale);
        final bytes = await File(file.path).readAsBytes();
        expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
      }
    });

    test('still works with only income recorded', () async {
      await phoneA.addExpense(2500, categoryId: 'cat_salary');
      final file = await phoneA.export(ExportFormat.report, english);
      final bytes = await File(file.path).readAsBytes();
      expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
    });

    test('lists recurring payments, in Arabic too', () async {
      await phoneA.addRecurring('الإيجار');
      await phoneA.addExpense(40, note: 'Groceries');

      for (final locale in [english, arabic]) {
        final file = await phoneA.export(ExportFormat.report, locale);
        final bytes = await File(file.path).readAsBytes();
        expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
      }
    });

    test('lists people and their ledgers, in Arabic too', () async {
      final sara = await phoneA.addPerson('سارة');
      await phoneA.addDebt(sara, 20, note: 'غداء');
      await phoneA.people.settleUp(sara.id);
      await phoneA.addDebt(
        sara,
        7.5,
        type: PersonTransactionType.theyPaidForMe,
      );

      for (final locale in [english, arabic]) {
        final file = await phoneA.export(ExportFormat.report, locale);
        final bytes = await File(file.path).readAsBytes();
        expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
      }
    });

    group('in every translated language', () {
      final englishTitle = RegExp(r'/Title\s*\(My Budget: expense report\)');

      /// The fonts a report embeds, by name.
      Set<String> fontsIn(String pdf) => {
        for (final match in RegExp(r'/BaseFont\s*/([^\s/>]+)').allMatches(pdf))
          match.group(1)!,
      };
      ExportLocale locale(String code) => ExportLocale(
        languageCode: code,
        formatsLocale: code,
        currencySymbol: r'$',
      );
      Future<String> report(String code) async {
        final file = await phoneA.export(ExportFormat.report, locale(code));
        return latin1.decode(await File(file.path).readAsBytes());
      }

      setUp(() async {
        await phoneA.addExpense(40, note: 'Groceries');
        final pets = await phoneA.addCategory('حيوانات أليفة');
        await phoneA.addExpense(
          12.5,
          categoryId: pets.id,
          note: 'زيارة الطبيب',
        );
      });

      test('Cyrillic and Latin Extended use their own font, with Arabic '
          'names still set in the Arabic one', () async {
        for (final code in ['ru', 'uk', 'tr', 'pl', 'vi', 'fr']) {
          final pdf = await report(code);
          expect(pdf, startsWith('%PDF-'));
          expect(
            fontsIn(pdf),
            containsAll(['IBMPlexSans', 'IBMPlexSansArabic-Regular']),
          );
          expect(pdf, isNot(contains(englishTitle)));
        }
      });

      test('Arabic, Persian and Urdu keep the Arabic font alone', () async {
        for (final code in ['ar', 'fa', 'ur']) {
          final fonts = fontsIn(await report(code));
          expect(fonts, contains('IBMPlexSansArabic-Regular'), reason: code);
          expect(fonts, isNot(contains('IBMPlexSans')), reason: code);
          // Persian's zero-width non-joiner has no glyph; nothing falls back.
          expect(fonts, isNot(contains('Helvetica')), reason: code);
        }
      });

      test('Chinese, Japanese and Korean reports are written in English, '
          'since no bundled font draws them', () async {
        for (final code in ['zh', 'ja', 'ko']) {
          final pdf = await report(code);
          expect(pdf, contains(englishTitle));
          expect(fontsIn(pdf), isNot(contains('IBMPlexSans')));
        }
      });

      test('the spreadsheet stays in the app\'s language, even without a '
          'PDF font for it', () async {
        final files = await phoneA.exportAll(
          ExportFormat.spreadsheet,
          locale('zh'),
        );
        final expenses = await File(files.first.path).readAsString();
        expect(expenses, contains(const AppStringsZh().colDate));
      });

      test('the fonts cover every translation but Chinese, Japanese and '
          'Korean', () {
        const fonts = ReportFontsDataSourceImpl();
        for (final language in AppLanguage.translated) {
          final code = language.languageCode!;
          expect(
            fonts.supports(code),
            !{'zh', 'ja', 'ko'}.contains(code),
            reason: code,
          );
        }
      });
    });

    test('still works with nothing recorded', () async {
      final file = await phoneA.export(ExportFormat.report, english);
      final bytes = await File(file.path).readAsBytes();
      expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
    });
  });

  group('the file chooser and share sheet', () {
    test('cancelling the chooser is not an error', () async {
      phoneB.files.pickResult = null;

      final result = await ChooseBackup(phoneB.repository)();

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isNull);
    });

    test('a chooser the system cannot open is reported', () async {
      phoneB.files.pickError = const FileFailure(FailureCode.fileUnavailable);

      final result = await ChooseBackup(phoneB.repository)();

      expect(result.failureOrNull?.code, FailureCode.fileUnavailable);
    });

    test('a share sheet that fails to open is reported', () async {
      final file = await phoneA.export(ExportFormat.backup, english);
      phoneA.files.shareError = const FileFailure(FailureCode.shareUnavailable);

      final result = await phoneA.repository.share([file]);

      expect(result.failureOrNull?.code, FailureCode.shareUnavailable);
    });

    test('a full phone is reported when writing the export', () async {
      phoneA.files.writeError = const FileFailure(FailureCode.storageFull);

      final result = await phoneA.repository.export(
        ExportFormat.backup,
        english,
      );

      expect(result.failureOrNull?.code, FailureCode.storageFull);
    });

    test('cancelling one of several save dialogs stops the rest', () async {
      final files = await phoneA.exportAll(ExportFormat.spreadsheet, english);
      phoneA.files.saveAnswers = [false, true];

      final result = await phoneA.repository.saveToDevice(files);

      expect(result.dataOrNull, isFalse);
      expect(phoneA.files.saved, isEmpty);
    });

    test('reading a real file reports missing and non-text files', () async {
      const device = DeviceFilesDataSourceImpl();
      await expectLater(
        device.readText(p.join(folder.path, 'missing.json')),
        throwsA(
          isA<FileFailure>().having(
            (f) => f.code,
            'code',
            FailureCode.fileUnavailable,
          ),
        ),
      );
      final binary = p.join(folder.path, 'binary.bin');
      await File(binary).writeAsBytes([0xC3, 0x28]);
      await expectLater(
        device.readText(binary),
        throwsA(
          isA<FileFailure>().having(
            (f) => f.code,
            'code',
            FailureCode.backupNotRecognized,
          ),
        ),
      );
    });
  });
}

Map<String, Object?> _expenseRow(
  String id, {
  String categoryId = 'cat_food',
  required int updatedAt,
}) {
  final date = DateTime(2026, 8, 4).millisecondsSinceEpoch;
  return {
    'id': id,
    'amount': 10.0,
    'description': null,
    'category_id': categoryId,
    'date': date,
    'month_key': '2026-08',
    'created_at': date,
    'updated_at': updatedAt,
    'deleted_at': null,
  };
}

/// One phone: its own database file, the app's repositories, and the data
/// management repository writing its exports into a test folder.
class Phone {
  Phone(String name, Directory folder)
    : fileName =
          'data_management_test_${name}_'
          '${DateTime.now().microsecondsSinceEpoch}.db',
      files = FakeDeviceFiles(Directory(p.join(folder.path, name))) {
    database = AppDatabase(fileName: fileName);
    records = LocalRecords(database);
    expenses = ExpenseRepositoryImpl(ExpenseLocalDataSourceImpl(database));
    categories = CategoryRepositoryImpl(CategoryLocalDataSourceImpl(database));
    settingsRepo = SettingsRepositoryImpl(
      SettingsLocalDataSourceImpl(database),
    );
    recurring = RecurringRepositoryImpl(RecurringLocalDataSourceImpl(database));
    people = PeopleRepositoryImpl(PeopleLocalDataSourceImpl(database));
    repository = DataManagementRepositoryImpl(
      records: records,
      files: files,
      fonts: const ReportFontsDataSourceImpl(),
    );
  }

  final String fileName;
  final FakeDeviceFiles files;
  late final AppDatabase database;
  late final LocalRecords records;
  late final ExpenseRepositoryImpl expenses;
  late final CategoryRepositoryImpl categories;
  late final SettingsRepositoryImpl settingsRepo;
  late final RecurringRepositoryImpl recurring;
  late final PeopleRepositoryImpl people;
  late final DataManagementRepositoryImpl repository;

  Future<Person> addPerson(String name, {String? phone}) async =>
      (await people.addPerson(
        name: name,
        colorValue: 0xFF1E88E5,
        phone: phone,
      )).dataOrNull!;

  Future<PersonTransaction> addDebt(
    Person person,
    double amount, {
    PersonTransactionType type = PersonTransactionType.iPaidForThem,
    String? note,
  }) async => (await people.addTransaction(
    personId: person.id,
    amount: amount,
    type: type,
    date: DateTime(2026, 8, 4),
    note: note,
  )).dataOrNull!;

  /// Yearly on 29 February, logged automatically.
  Future<RecurringExpense> addRecurring(String title) async =>
      (await recurring.createRecurring(
        title: title,
        amount: 900,
        categoryId: 'cat_bills',
        frequency: RecurrenceFrequency.yearly,
        dueDay: 29,
        dueMonth: 2,
        mode: RecurringMode.autoDeduct,
        startsOn: DateTime(2026, 8, 1),
      )).dataOrNull!;

  Future<Expense> addExpense(
    double amount, {
    String categoryId = 'cat_food',
    String? note,
  }) async => (await expenses.addExpense(
    amount: amount,
    categoryId: categoryId,
    date: DateTime(2026, 8, 4),
    description: note,
  )).dataOrNull!;

  Future<ExpenseCategory> addCategory(String name) async =>
      (await categories.createCategory(
        name: name,
        iconName: 'pets',
        colorValue: 0xFF123456,
        type: TransactionType.expense,
      )).dataOrNull!;

  Future<void> setAmount(String id, double amount) async {
    final result = await expenses.updateExpense(
      id: id,
      amount: amount,
      categoryId: 'cat_food',
      date: DateTime(2026, 8, 4),
    );
    expect(result.isSuccess, isTrue);
  }

  Future<List<Expense>> monthOf(DateTime date) async =>
      (await expenses.getTransactionsForMonth(
        Month.fromDate(date),
      )).dataOrNull!;

  Future<List<ExportedFile>> exportAll(
    ExportFormat format,
    ExportLocale locale,
  ) async {
    final result = await repository.export(format, locale);
    expect(result.failureOrNull, isNull);
    return result.dataOrNull!;
  }

  Future<ExportedFile> export(ExportFormat format, ExportLocale locale) async =>
      (await exportAll(format, locale)).single;

  Future<int> importFile(ExportedFile file, ImportMode mode) async {
    final result = await repository.importBackup(file.path, mode);
    expect(result.failureOrNull, isNull);
    return result.dataOrNull!;
  }

  Future<void> dispose() async {
    await database.close();
    await deleteDatabase(p.join(await getDatabasesPath(), fileName));
  }
}

/// Real files in a test folder; the share sheet, save dialog and chooser are
/// scripted.
class FakeDeviceFiles implements DeviceFilesDataSource {
  FakeDeviceFiles(this.folder);

  final Directory folder;

  String? pickResult;
  Failure? pickError;
  Failure? shareError;
  Failure? writeError;
  List<bool> saveAnswers = [];
  final List<ExportedFile> saved = [];

  @override
  Future<void> clearExports() async {
    if (await folder.exists()) await folder.delete(recursive: true);
  }

  @override
  Future<String> writeExport(String name, List<int> bytes) async {
    final error = writeError;
    if (error != null) throw error;
    await folder.create(recursive: true);
    final file = File(p.join(folder.path, name));
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Future<String> readText(String path) =>
      const DeviceFilesDataSourceImpl().readText(path);

  @override
  Future<void> share(List<ExportedFile> files, {ShareAnchor? anchor}) async {
    final error = shareError;
    if (error != null) throw error;
  }

  @override
  Future<bool> save(ExportedFile file) async {
    final answer = saveAnswers.isEmpty ? true : saveAnswers.removeAt(0);
    if (answer) saved.add(file);
    return answer;
  }

  @override
  Future<String?> pickFile() async {
    final error = pickError;
    if (error != null) throw error;
    return pickResult;
  }
}
