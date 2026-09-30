import 'dart:convert';

import '../../../../core/database/portable_records.dart';
import '../../../../core/database/record_batch.dart';
import '../../../../core/error/failures.dart';

/// A backup file, read and checked.
class DecodedBackup {
  const DecodedBackup({required this.records, this.exportedAt});

  final RecordBatch records;
  final DateTime? exportedAt;
}

/// The `.mybudget.json` backup file.
///
/// Records use the same portable form as the cloud copy, so a record looks
/// the same whichever way it leaves the phone: original ids, `updated_at` for
/// newest-wins merging, and deleted records with their `deleted_at` so a
/// delete travels too. Nothing about the account goes in: no tokens, no user
/// id, no sync bookkeeping.
///
/// Pure Dart, so it can run on a background isolate.
abstract final class BackupCodec {
  static const String format = 'my_budget_backup';

  /// Bump when the file layout changes, and teach [decode] to upgrade the
  /// older layouts it still accepts.
  ///
  /// 2: categories carry a `type`, `expense` or `income`. A version 1 file
  /// has none, and all of it is spending. The bump makes an older app refuse
  /// a file with income in it rather than import that income as spending.
  ///
  /// 3: adds `recurring_expenses`. Older files have none, and import with
  /// none. The bump makes an older app refuse the file rather than import it
  /// and silently drop the schedules.
  static const int schemaVersion = 3;

  static String encode(RecordBatch records, {required DateTime exportedAt}) =>
      const JsonEncoder.withIndent('  ').convert({
        'format': format,
        'schema_version': schemaVersion,
        'app': 'My Budget',
        'exported_at': exportedAt.toUtc().toIso8601String(),
        'categories': [
          for (final row in records.categories)
            PortableRecords.categoryToPortable(row),
        ],
        'expenses': [
          for (final row in records.expenses)
            PortableRecords.expenseToPortable(row),
        ],
        'settings': [
          for (final row in records.settings)
            PortableRecords.settingToPortable(row),
        ],
        'recurring_expenses': [
          for (final row in records.recurring)
            PortableRecords.recurringToPortable(row),
        ],
      });

  /// Throws a [FileFailure] unless [text] is a complete, well-formed backup
  /// this version of the app can read. Nothing is half-accepted: one bad
  /// record rejects the whole file.
  static DecodedBackup decode(String text) {
    final Object? json;
    try {
      // A byte order mark is harmless but not valid JSON.
      json = jsonDecode(text.startsWith('﻿') ? text.substring(1) : text);
    } on FormatException catch (error) {
      throw FileFailure(FailureCode.backupNotRecognized, '$error');
    }
    if (json is! Map<String, dynamic> || json['format'] != format) {
      throw const FileFailure(
        FailureCode.backupNotRecognized,
        'missing format marker',
      );
    }

    final version = json['schema_version'];
    if (version is! int || version < 1) {
      throw const FileFailure(FailureCode.backupDamaged, 'schema_version');
    }
    if (version > schemaVersion) {
      throw FileFailure(FailureCode.backupTooNew, 'schema_version $version');
    }

    try {
      final records = RecordBatch(
        categories: _rows(json['categories'], _category),
        expenses: _rows(json['expenses'], _expense),
        settings: _rows(json['settings'], _setting),
        recurring: version < 3
            ? const []
            : _rows(json['recurring_expenses'], _recurring),
      );
      _requireUnique(records.categories, 'id');
      _requireUnique(records.expenses, 'id');
      _requireUnique(records.settings, 'key');
      _requireUnique(records.recurring, 'id');

      final exportedAt = json['exported_at'];
      return DecodedBackup(
        records: records,
        exportedAt: exportedAt is String
            ? DateTime.tryParse(exportedAt)?.toLocal()
            : null,
      );
    } on FileFailure {
      rethrow;
    } on Object catch (error) {
      // A wrong type anywhere in a record.
      throw FileFailure(FailureCode.backupDamaged, '$error');
    }
  }

  static List<Map<String, Object?>> _rows(
    Object? list,
    Map<String, Object?> Function(Map<String, dynamic>) read,
  ) {
    if (list is! List) _damaged('record list missing');
    return [
      for (final item in list)
        if (item is Map<String, dynamic>)
          read(item)
        else
          _damaged('record is not an object'),
    ];
  }

  static Map<String, Object?> _category(Map<String, dynamic> json) {
    _text(json, 'id');
    _text(json, 'name');
    _text(json, 'icon_name');
    _int(json, 'color_value');
    final type = json['type'];
    if (type != null && type != 'expense' && type != 'income') {
      _damaged('type');
    }
    if (json['is_default'] is! bool) _damaged('is_default');
    _int(json, 'sort_order');
    _timestamps(json);
    return PortableRecords.categoryFromPortable(json);
  }

  static Map<String, Object?> _expense(Map<String, dynamic> json) {
    _text(json, 'id');
    final amount = json['amount'];
    if (amount is! num || !amount.isFinite || amount <= 0) _damaged('amount');
    final description = json['description'];
    if (description != null && description is! String) {
      _damaged('description');
    }
    _text(json, 'category_id');
    _int(json, 'date');
    final monthKey = json['month_key'];
    if (monthKey is! String || !RegExp(r'^\d{4}-\d{2}$').hasMatch(monthKey)) {
      _damaged('month_key');
    }
    _int(json, 'created_at');
    _timestamps(json);
    return PortableRecords.expenseFromPortable(json);
  }

  static Map<String, Object?> _recurring(Map<String, dynamic> json) {
    _text(json, 'id');
    _text(json, 'title');
    final amount = json['amount'];
    if (amount is! num || !amount.isFinite || amount <= 0) _damaged('amount');
    _text(json, 'category_id');
    final frequency = json['frequency'];
    if (frequency != 'weekly' &&
        frequency != 'monthly' &&
        frequency != 'yearly') {
      _damaged('frequency');
    }
    final dueDay = json['due_day'];
    if (dueDay is! int || dueDay < 1 || dueDay > 31) _damaged('due_day');
    final dueMonth = json['due_month'];
    if (dueMonth != null &&
        (dueMonth is! int || dueMonth < 1 || dueMonth > 12)) {
      _damaged('due_month');
    }
    if (frequency == 'yearly' && dueMonth == null) _damaged('due_month');
    final mode = json['mode'];
    if (mode != 'auto' && mode != 'reminder') _damaged('mode');
    _day(json, 'starts_on');
    if (json['paid_through'] != null) _day(json, 'paid_through');
    _int(json, 'created_at');
    _timestamps(json);
    return PortableRecords.recurringFromPortable(json);
  }

  static void _day(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String ||
        !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value) ||
        DateTime.tryParse(value) == null) {
      _damaged(key);
    }
  }

  static Map<String, Object?> _setting(Map<String, dynamic> json) {
    _text(json, 'key');
    if (json['value'] is! String) _damaged('value');
    _int(json, 'updated_at');
    return PortableRecords.settingFromPortable(json);
  }

  static void _timestamps(Map<String, dynamic> json) {
    _int(json, 'updated_at');
    final deletedAt = json['deleted_at'];
    if (deletedAt != null && deletedAt is! int) _damaged('deleted_at');
  }

  static void _text(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.isEmpty) _damaged(key);
  }

  static void _int(Map<String, dynamic> json, String key) {
    if (json[key] is! int) _damaged(key);
  }

  static void _requireUnique(List<Map<String, Object?>> rows, String key) {
    final seen = <Object?>{};
    for (final row in rows) {
      if (!seen.add(row[key])) _damaged('duplicate $key ${row[key]}');
    }
  }

  static Never _damaged(String detail) =>
      throw FileFailure(FailureCode.backupDamaged, detail);
}
