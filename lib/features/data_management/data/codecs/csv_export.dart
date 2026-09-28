import '../models/export_texts.dart';

/// Spreadsheet exports for Excel, Google Sheets, Numbers and the like.
///
/// UTF-8 with a byte order mark, which Excel needs before it reads Arabic
/// (or any non-English text) correctly; CRLF line endings and RFC 4180
/// quoting, which every spreadsheet understands. Dates are ISO (2026-08-04)
/// and amounts plain numbers (12.50), which spreadsheets parse in any
/// language. Deleted records are left out: this is for reading, not
/// restoring.
///
/// Pure Dart, so it can run on a background isolate.
abstract final class CsvExport {
  static const String byteOrderMark = '﻿';

  static String expenses({
    required List<Map<String, Object?>> expenses,
    required Map<String, String> categoryNames,
    required String currency,
    required ExportTexts texts,
  }) {
    final live = _live(expenses)
      ..sort((a, b) {
        final byDate = _int(a['date']).compareTo(_int(b['date']));
        return byDate != 0
            ? byDate
            : _int(a['created_at']).compareTo(_int(b['created_at']));
      });

    return _document([
      [
        texts.date,
        texts.month,
        texts.category,
        texts.amount,
        texts.currency,
        texts.note,
        texts.id,
      ],
      for (final expense in live)
        [
          isoDate(_int(expense['date'])),
          '${expense['month_key']}',
          categoryNames[expense['category_id']] ?? '${expense['category_id']}',
          amount(expense['amount']! as num),
          currency,
          (expense['description'] as String?) ?? '',
          '${expense['id']}',
        ],
    ]);
  }

  static String categories({
    required List<Map<String, Object?>> categories,
    required List<Map<String, Object?>> expenses,
    required Map<String, String> categoryNames,
    required ExportTexts texts,
  }) {
    final counts = <Object?, int>{};
    final totals = <Object?, double>{};
    for (final expense in _live(expenses)) {
      final id = expense['category_id'];
      counts[id] = (counts[id] ?? 0) + 1;
      totals[id] = (totals[id] ?? 0) + (expense['amount']! as num).toDouble();
    }
    final live = _live(categories)
      ..sort((a, b) => _int(a['sort_order']).compareTo(_int(b['sort_order'])));

    return _document([
      [texts.name, texts.builtIn, texts.count, texts.total, texts.id],
      for (final category in live)
        [
          categoryNames[category['id']] ?? '${category['name']}',
          category['is_default'] == 1 ? texts.yes : texts.no,
          '${counts[category['id']] ?? 0}',
          amount(totals[category['id']] ?? 0),
          '${category['id']}',
        ],
    ]);
  }

  static String isoDate(int millis) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }

  static String amount(num value) => value.toStringAsFixed(2);

  /// One field, quoted when it has to be. Text that a spreadsheet would run
  /// as a formula gets a leading apostrophe (the usual guard against CSV
  /// injection): a note can be typed or imported by anyone.
  static String field(String value) {
    final safe = value.isNotEmpty && '=+-@\t\r'.contains(value[0])
        ? "'$value"
        : value;
    final needsQuotes =
        safe.contains(RegExp(r'[",\r\n]')) || safe != safe.trim();
    return needsQuotes ? '"${safe.replaceAll('"', '""')}"' : safe;
  }

  static String _document(List<List<String>> rows) {
    final buffer = StringBuffer(byteOrderMark);
    for (final row in rows) {
      buffer
        ..write(row.map(field).join(','))
        ..write('\r\n');
    }
    return buffer.toString();
  }

  static List<Map<String, Object?>> _live(List<Map<String, Object?>> rows) => [
    for (final row in rows)
      if (row['deleted_at'] == null) row,
  ];

  static int _int(Object? value) => (value! as num).toInt();
}
