import '../../../../core/database/synced_tables.dart';
import '../../../../core/error/failures.dart';
import '../../../categories/domain/entities/expense_category.dart';
import 'backup_codec.dart';

/// Makes a file written by an AI chat (from the prompt the app hands out)
/// readable by [BackupCodec], before the codec checks it as strictly as any
/// backup.
///
/// The prompt asks only for what a person would write: dates as
/// `YYYY-MM-DD`, positive amounts, a category id. Everything a backup also
/// carries (epoch milliseconds, `month_key`, sync stamps, empty tables) is
/// filled in here, because those are exactly what a language model gets
/// wrong. A real backup already has all of it and passes through unchanged.
///
/// Pure Dart, so it runs on the same background isolate as the codec.
abstract final class AssistedImport {
  /// Colour of an imported category when no [palette] is given.
  static const int defaultColor = 0xFF546E7A;
  static const String defaultIcon = 'category';

  /// [text] parsed and completed, ready for [BackupCodec.decodeJson].
  ///
  /// New categories take an icon from [iconNames] when the AI chose one the
  /// app has (`icon` or `icon_name`), and colours from [palette] in turn so
  /// they do not all look alike. Both are passed in to keep this pure Dart.
  static Object? prepare(
    String text, {
    required DateTime now,
    Set<String> iconNames = const {},
    List<int> palette = const [defaultColor],
  }) {
    final json = BackupCodec.parse(_jsonPart(text));
    if (json is! Map<String, dynamic>) return json;

    // Without our marker, only something that looks like our data is
    // completed; any other JSON stays unrecognised.
    if (json['format'] == null) {
      if (json['expenses'] is! List && json['categories'] is! List) {
        return json;
      }
      json['format'] = BackupCodec.format;
    }
    json['schema_version'] ??= BackupCodec.schemaVersion;
    for (final table in SyncedTables.all) {
      json[table.name] ??= <Object?>[];
    }

    final stamp = now.millisecondsSinceEpoch;
    if (json['categories'] case final List categories) {
      for (final (index, item) in categories.indexed) {
        if (item is Map<String, dynamic>) {
          _category(item, index, stamp, iconNames, palette);
        }
      }
    }
    if (json['expenses'] case final List expenses) {
      for (final (index, item) in expenses.indexed) {
        if (item is Map<String, dynamic>) _expense(item, index, stamp);
      }
    }
    return json;
  }

  /// The JSON inside an AI reply: chats wrap it in ```json fences or a
  /// sentence before and after.
  static String _jsonPart(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) {
      throw const FileFailure(FailureCode.backupNotRecognized, 'no JSON');
    }
    return text.substring(start, end + 1);
  }

  static void _category(
    Map<String, dynamic> row,
    int index,
    int stamp,
    Set<String> iconNames,
    List<int> palette,
  ) {
    row['id'] ??= 'imp_cat_${index + 1}';
    // A backup's own icon is kept as it is; only a missing one is chosen.
    final chosen = row.remove('icon');
    row['icon_name'] ??= chosen is String && iconNames.contains(chosen)
        ? chosen
        : defaultIcon;
    row['color_value'] ??= palette[index % palette.length];
    row['is_default'] ??= false;
    row['sort_order'] ??= 100 + index;
    row['updated_at'] ??= stamp;
  }

  static void _expense(Map<String, dynamic> row, int index, int stamp) {
    row['id'] ??= 'imp_${index + 1}';
    row['category_id'] ??= ExpenseCategory.fallbackId;

    final amount = switch (row['amount']) {
      final String text => num.tryParse(text.replaceAll(',', '').trim()),
      final num value => value,
      _ => null,
    };
    // Exports from banks and other apps often show spending as negative.
    if (amount != null) row['amount'] = amount.abs();

    final date = _date(row['date']);
    if (date != null) {
      row['date'] = date.millisecondsSinceEpoch;
      row['month_key'] ??=
          '${date.year}-${date.month.toString().padLeft(2, '0')}';
      row['created_at'] ??= date.millisecondsSinceEpoch;
    }
    row['updated_at'] ??= stamp;
    if (row['description'] case final String note when note.trim().isEmpty) {
      row['description'] = null;
    }
  }

  /// A day as text (`2026-08-14`, with or without a time) or a timestamp,
  /// in seconds or milliseconds. A bare day is placed at noon so it stays
  /// on that day in every timezone the phone may later be in.
  static DateTime? _date(Object? value) {
    switch (value) {
      case final String text:
        final parsed = DateTime.tryParse(text.trim());
        if (parsed == null) return null;
        final dayOnly = text.trim().length <= 10;
        return dayOnly
            ? DateTime(parsed.year, parsed.month, parsed.day, 12)
            : parsed.toLocal();
      case final int stamp:
        // Ten digits is seconds; thirteen is milliseconds.
        return DateTime.fromMillisecondsSinceEpoch(
          stamp < 100000000000 ? stamp * 1000 : stamp,
        );
      default:
        return null;
    }
  }
}
