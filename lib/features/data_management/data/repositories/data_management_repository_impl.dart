import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import '../../../../core/database/local_records.dart';
import '../../../../core/database/record_batch.dart';
import '../../../../core/error/api_result.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../domain/entities/backup_preview.dart';
import '../../domain/entities/export_format.dart';
import '../../domain/entities/export_locale.dart';
import '../../domain/entities/exported_file.dart';
import '../../domain/entities/import_mode.dart';
import '../../domain/entities/share_anchor.dart';
import '../../domain/repositories/data_management_repository.dart';
import '../codecs/backup_codec.dart';
import '../codecs/csv_export.dart';
import '../codecs/pdf_report.dart';
import '../datasources/device_files_data_source.dart';
import '../datasources/report_fonts_data_source.dart';
import '../models/export_texts.dart';

/// Reads and writes the phone's records through [LocalRecords], the same
/// path the cloud sync uses, so a backup file and the cloud copy hold the
/// same records in the same form and import with the same rules.
///
/// Building and parsing files happens on a background isolate, so a large
/// export or import never freezes the screen.
class DataManagementRepositoryImpl implements DataManagementRepository {
  DataManagementRepositoryImpl({
    required LocalRecords records,
    required DeviceFilesDataSource files,
    required ReportFontsDataSource fonts,
    DateTime Function()? clock,
  }) : _records = records,
       _files = files,
       _fonts = fonts,
       _clock = clock ?? DateTime.now;

  final LocalRecords _records;
  final DeviceFilesDataSource _files;
  final ReportFontsDataSource _fonts;
  final DateTime Function() _clock;

  @override
  Future<ApiResult<List<ExportedFile>>> export(
    ExportFormat format,
    ExportLocale locale, {
    DataProgress? onProgress,
  }) => ApiResult.guard(() async {
    onProgress?.call(0);
    final records = await _records.readAll();
    onProgress?.call(0.3);
    await _files.clearExports();

    final now = _clock();
    final stamp = _stamp(now);
    final files = switch (format) {
      ExportFormat.backup => [await _writeBackup(records, now, stamp)],
      ExportFormat.spreadsheet => await _writeSpreadsheets(
        records,
        locale,
        now,
        stamp,
      ),
      ExportFormat.report => [await _writeReport(records, locale, now, stamp)],
    };
    onProgress?.call(1);
    return files;
  });

  @override
  Future<ApiResult<void>> share(
    List<ExportedFile> files, {
    ShareAnchor? anchor,
  }) => ApiResult.guard(() => _files.share(files, anchor: anchor));

  @override
  Future<ApiResult<bool>> saveToDevice(List<ExportedFile> files) =>
      ApiResult.guard(() async {
        // One save dialog per file; cancelling any of them stops the rest.
        for (final file in files) {
          if (!await _files.save(file)) return false;
        }
        return true;
      });

  @override
  Future<ApiResult<String?>> pickFile() => ApiResult.guard(_files.pickFile);

  @override
  Future<ApiResult<BackupPreview>> previewBackup(String path) =>
      ApiResult.guard(() async {
        final backup = await _readBackup(path);
        return BackupPreview(
          path: path,
          exportedAt: backup.exportedAt,
          expenses: _liveCount(backup.records.expenses),
          categories: _liveCount(backup.records.categories),
        );
      });

  @override
  Future<ApiResult<int>> importBackup(
    String path,
    ImportMode mode, {
    DataProgress? onProgress,
  }) => ApiResult.guard(() async {
    onProgress?.call(0);
    // Checked again rather than trusting the preview: the file could have
    // changed in between, and nothing unchecked may reach the database.
    final backup = await _readBackup(path);
    onProgress?.call(0.5);
    final changes = switch (mode) {
      ImportMode.merge => await _records.mergeNewest(
        backup.records,
        fromCloud: false,
      ),
      ImportMode.replace => await _records.replaceAll(backup.records),
    };
    onProgress?.call(1);
    return changes;
  });

  Future<DecodedBackup> _readBackup(String path) async =>
      _decodeInBackground(await _files.readText(path));

  Future<ExportedFile> _writeBackup(
    RecordBatch records,
    DateTime now,
    String stamp,
  ) async {
    final name = 'my_budget_backup_$stamp.mybudget.json';
    final bytes = await _encodeBackupInBackground(records, now);
    return ExportedFile(
      path: await _files.writeExport(name, bytes),
      name: name,
      mimeType: 'application/json',
    );
  }

  Future<List<ExportedFile>> _writeSpreadsheets(
    RecordBatch records,
    ExportLocale locale,
    DateTime now,
    String stamp,
  ) async {
    final strings = AppStrings.forLanguageCode(locale.languageCode);
    final (expenses, categories) = await _spreadsheetsInBackground(
      records,
      _categoryNames(records, strings),
      locale.currencySymbol,
      _texts(strings, locale, now),
    );
    return [
      await _writeText('my_budget_expenses_$stamp.csv', expenses),
      await _writeText('my_budget_categories_$stamp.csv', categories),
    ];
  }

  Future<ExportedFile> _writeReport(
    RecordBatch records,
    ExportLocale locale,
    DateTime now,
    String stamp,
  ) async {
    final strings = AppStrings.forLanguageCode(locale.languageCode);
    final fonts = await _fonts.load();
    final bytes = await _reportInBackground(
      ReportInput(
        expenses: records.expenses,
        categoryNames: _categoryNames(records, strings),
        texts: _texts(strings, locale, now),
        formatsLocale: locale.formatsLocale,
        currencySymbol: locale.currencySymbol,
        rightToLeft: locale.isRightToLeft,
        font: fonts.regular,
        boldFont: fonts.bold,
      ),
    );
    final name = 'my_budget_report_$stamp.pdf';
    return ExportedFile(
      path: await _files.writeExport(name, bytes),
      name: name,
      mimeType: 'application/pdf',
    );
  }

  Future<ExportedFile> _writeText(String name, String text) async =>
      ExportedFile(
        path: await _files.writeExport(name, utf8.encode(text)),
        name: name,
        mimeType: 'text/csv',
      );

  // The background work lives in static functions so that only plain data,
  // never this repository and its database handle, is sent to the isolate.

  static Future<Uint8List> _encodeBackupInBackground(
    RecordBatch records,
    DateTime now,
  ) => Isolate.run(
    () => utf8.encode(BackupCodec.encode(records, exportedAt: now)),
  );

  static Future<DecodedBackup> _decodeInBackground(String text) =>
      Isolate.run(() => BackupCodec.decode(text));

  static Future<(String, String)> _spreadsheetsInBackground(
    RecordBatch records,
    Map<String, String> categoryNames,
    String currency,
    ExportTexts texts,
  ) => Isolate.run(
    () => (
      CsvExport.expenses(
        expenses: records.expenses,
        categoryNames: categoryNames,
        currency: currency,
        texts: texts,
      ),
      CsvExport.categories(
        categories: records.categories,
        expenses: records.expenses,
        categoryNames: categoryNames,
        texts: texts,
      ),
    ),
  );

  static Future<Uint8List> _reportInBackground(ReportInput input) =>
      Isolate.run(() => buildPdfReport(input));

  /// The names the app shows: built-in categories in the current language,
  /// the user's own exactly as typed (the rule `categoryLabel` applies on
  /// screen).
  static Map<String, String> _categoryNames(
    RecordBatch records,
    AppStrings strings,
  ) => {
    for (final row in records.categories)
      row['id']! as String: row['is_default'] == 1
          ? strings.defaultCategoryName(row['id']! as String) ??
                row['name']! as String
          : row['name']! as String,
  };

  static ExportTexts _texts(
    AppStrings strings,
    ExportLocale locale,
    DateTime now,
  ) {
    final formats = AppFormats(
      localeName: locale.formatsLocale,
      currencySymbol: locale.currencySymbol,
    );
    return ExportTexts(
      date: strings.colDate,
      month: strings.colMonth,
      category: strings.category,
      amount: strings.colAmount,
      currency: strings.currency,
      note: strings.colNote,
      id: strings.colId,
      name: strings.categoryName,
      builtIn: strings.builtIn,
      count: strings.colCount,
      total: strings.colTotal,
      share: strings.colShare,
      yes: strings.yes,
      no: strings.no,
      title: strings.reportTitle,
      generated: strings.reportGenerated(
        '${formats.fullDate(now)}, ${formats.time(now)}',
      ),
      period: strings.reportPeriod,
      totalSpent: strings.reportTotal,
      monthlyAverage: strings.reportMonthlyAverage,
      byCategory: strings.byCategory,
      byMonth: strings.reportByMonth,
      allExpenses: strings.reportAllExpenses,
      empty: strings.reportEmpty,
      pageTemplate: strings.reportPageTemplate,
    );
  }

  static int _liveCount(List<Map<String, Object?>> rows) =>
      rows.where((row) => row['deleted_at'] == null).length;

  /// `2026-09-28_1505`: sortable, and safe in a file name everywhere.
  static String _stamp(DateTime now) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${now.year}-${two(now.month)}-${two(now.day)}_'
        '${two(now.hour)}${two(now.minute)}';
  }
}
