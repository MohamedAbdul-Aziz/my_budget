import 'dart:convert';

import '../../../../core/database/record_batch.dart';
import '../../../../core/database/synced_tables.dart';
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
  ///
  /// 4: adds `people`, `settlements`, `person_transactions` and
  /// `person_transaction_edits`. Older files have none, and import with
  /// none; the bump keeps an older app from dropping them.
  static const int schemaVersion = 4;

  static String encode(RecordBatch records, {required DateTime exportedAt}) =>
      const JsonEncoder.withIndent('  ').convert({
        'format': format,
        'schema_version': schemaVersion,
        'app': 'My Budget',
        'exported_at': exportedAt.toUtc().toIso8601String(),
        for (final table in SyncedTables.all)
          table.name: [for (final row in records[table]) table.toPortable(row)],
      });

  /// Throws a [FileFailure] unless [text] is a complete, well-formed backup
  /// this version of the app can read. Nothing is half-accepted: one bad
  /// record rejects the whole file.
  static DecodedBackup decode(String text) => decodeJson(parse(text));

  /// [text] as JSON, or a [FileFailure] when it is not JSON at all.
  static Object? parse(String text) {
    try {
      // A byte order mark is harmless but not valid JSON.
      return jsonDecode(text.startsWith('﻿') ? text.substring(1) : text);
    } on FormatException catch (error) {
      throw FileFailure(FailureCode.backupNotRecognized, '$error');
    }
  }

  /// [decode] for text already parsed, e.g. by [AssistedImport].
  static DecodedBackup decodeJson(Object? json) {
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
      // A table added after the file's format has none of its rows.
      final records = RecordBatch({
        for (final table in SyncedTables.all)
          table.name: version < table.since
              ? const []
              : _rows(json[table.name], table),
      });
      for (final table in SyncedTables.all) {
        _requireUnique(records[table], table.key);
      }

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

  /// [table]'s rows, each checked against the rules its columns declare.
  static List<Map<String, Object?>> _rows(Object? list, SyncedTable table) {
    if (list is! List) _damaged('${table.name} missing');
    return [
      for (final item in list)
        if (item is Map<String, dynamic>)
          switch (table.problemIn(item)) {
            final problem? => _damaged('${table.name}.$problem'),
            null => table.fromPortable(item),
          }
        else
          _damaged('record is not an object'),
    ];
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
