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
  static const int schemaVersion = 1;

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
      );
      _requireUnique(records.categories, 'id');
      _requireUnique(records.expenses, 'id');
      _requireUnique(records.settings, 'key');

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
