import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/local_records.dart';
import 'package:my_budget/core/database/record_batch.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/categories/data/datasources/category_local_data_source.dart';
import 'package:my_budget/features/categories/data/repositories/category_repository_impl.dart';
import 'package:my_budget/features/categories/domain/entities/expense_category.dart';
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
import 'package:my_budget/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:my_budget/features/settings/data/repositories/settings_repository_impl.dart';
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
      final batch = RecordBatch(
        expenses: [
          _expenseRow('exp_orphan', categoryId: 'cat_nowhere', updatedAt: 1),
        ],
      );

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
      final batch = RecordBatch(
        expenses: [
          _expenseRow('exp_good', updatedAt: 1),
          {..._expenseRow('exp_bad', updatedAt: 1), 'amount': null},
        ],
      );

      await expectLater(
        phoneB.records.mergeNewest(batch, fromCloud: false),
        throwsA(isA<DatabaseFailure>()),
      );
      expect(await phoneB.monthOf(august), isEmpty);
    });

    test('when replacing', () async {
      final kept = await phoneB.addExpense(5, note: 'Still here');
      final batch = RecordBatch(
        expenses: [
          _expenseRow('exp_good', updatedAt: 1),
          {..._expenseRow('exp_bad', updatedAt: 1), 'amount': null},
        ],
      );

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

      expect(lines.first, 'التاريخ,الشهر,الفئة,المبلغ,العملة,ملاحظة,المعرّف');
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
      expect(categories, contains('حيوانات أليفة,لا,1,12.50,'));
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
  late final DataManagementRepositoryImpl repository;

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
      (await expenses.getExpensesForMonth(Month.fromDate(date))).dataOrNull!;

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
