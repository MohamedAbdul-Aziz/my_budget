import '../../../budgets/domain/entities/budget_limits.dart';
import '../models/export_texts.dart';
import 'debt_rows.dart';

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

  /// Every transaction, spending and income, with a column saying which.
  static String expenses({
    required List<Map<String, Object?>> expenses,
    required Map<String, String> categoryNames,
    required Set<String> incomeCategoryIds,
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
        texts.type,
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
          incomeCategoryIds.contains(expense['category_id'])
              ? texts.income
              : texts.expense,
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
      [
        texts.name,
        texts.type,
        texts.builtIn,
        texts.count,
        texts.total,
        texts.id,
      ],
      for (final category in live)
        [
          categoryNames[category['id']] ?? '${category['name']}',
          category['type'] == 'income' ? texts.income : texts.expense,
          category['is_default'] == 1 ? texts.yes : texts.no,
          '${counts[category['id']] ?? 0}',
          amount(totals[category['id']] ?? 0),
          '${category['id']}',
        ],
    ]);
  }

  /// Recurring payments with their schedule, already worded in the app's
  /// language in [schedules] (by id).
  static String recurring({
    required List<Map<String, Object?>> recurring,
    required Map<String, String> categoryNames,
    required Map<String, String> schedules,
    required String currency,
    required ExportTexts texts,
  }) => _document([
    [
      texts.name,
      texts.category,
      texts.amount,
      texts.currency,
      texts.repeats,
      texts.mode,
      texts.paidThrough,
      texts.id,
    ],
    for (final row in _live(recurring))
      [
        '${row['title']}',
        categoryNames[row['category_id']] ?? '${row['category_id']}',
        amount(row['amount']! as num),
        currency,
        schedules[row['id']] ?? '',
        row['mode'] == 'auto' ? texts.autoDeduct : texts.reminder,
        // Already ISO: 2026-09-30.
        (row['paid_through'] as String?) ?? '',
        '${row['id']}',
      ],
  ]);

  /// One row per person: where the user stands with them now.
  static String people({required DebtRows debts, required ExportTexts texts}) =>
      _document([
        [
          texts.person,
          texts.phone,
          texts.status,
          texts.balance,
          texts.open,
          texts.created,
          texts.id,
        ],
        for (final person in debts.people) _personRow(person, debts, texts),
      ]);

  /// Every transaction with every person, open and settled, with its audit
  /// trail: when it was recorded, last edited and settled.
  static String debts({
    required DebtRows debts,
    required String currency,
    required ExportTexts texts,
  }) => _document([
    [
      texts.person,
      texts.date,
      texts.type,
      texts.amount,
      texts.currency,
      texts.note,
      texts.status,
      texts.settledOn,
      texts.created,
      texts.lastEdited,
      texts.edits,
      texts.id,
    ],
    for (final row in debts.transactions) _debtRow(row, debts, currency, texts),
  ]);

  /// Every settle-up: when, with whom, which way the money went, and how
  /// many transactions it cleared.
  static String settlements({
    required DebtRows debts,
    required String currency,
    required ExportTexts texts,
  }) => _document([
    [
      texts.person,
      texts.settledOn,
      texts.type,
      texts.amount,
      texts.currency,
      texts.count,
      texts.id,
    ],
    for (final row in debts.settlements)
      [
        debts.personName(row['person_id']),
        isoDate(_int(row['settled_at'])),
        DebtRows.settlementDirection(row, texts),
        // Unsigned, with the type column saying which way it went.
        amount((row['net_amount']! as num).abs()),
        currency,
        '${debts.clearedBy(row['id'])}',
        '${row['id']}',
      ],
  ]);

  /// The monthly budget first, then each category's.
  static String budgets({
    required BudgetLimits budgets,
    required Map<String, String> categoryNames,
    required String currency,
    required ExportTexts texts,
  }) => _document([
    [texts.category, texts.amount, texts.currency, texts.id],
    if (budgets.monthly case final monthly?)
      [texts.monthlyBudget, amount(monthly), currency, ''],
    for (final MapEntry(key: id, value: limit) in budgets.byCategory.entries)
      [categoryNames[id] ?? id, amount(limit), currency, id],
  ]);

  static List<String> _personRow(
    Map<String, Object?> person,
    DebtRows debts,
    ExportTexts texts,
  ) {
    final balance = debts.balanceOf(person['id']);
    final open = debts.transactions.where(
      (t) => t['person_id'] == person['id'] && t['settled_at'] == null,
    );
    return [
      '${person['name']}',
      (person['phone'] as String?) ?? '',
      DebtRows.standing(balance, texts),
      // Unsigned, with the status column saying which way it is owed: a
      // leading minus would trip the formula guard and stop being a number.
      amount(balance.magnitude),
      '${open.length}',
      isoDate(_int(person['created_at'])),
      '${person['id']}',
    ];
  }

  static List<String> _debtRow(
    Map<String, Object?> row,
    DebtRows debts,
    String currency,
    ExportTexts texts,
  ) {
    final (edits, lastEdited) = debts.editsOf(row['id']);
    final settledAt = row['settled_at'];
    return [
      debts.personName(row['person_id']),
      isoDate(_int(row['date'])),
      DebtRows.typeLabel(row, texts),
      amount(row['amount']! as num),
      currency,
      (row['note'] as String?) ?? '',
      settledAt == null ? texts.open : texts.settled,
      settledAt == null ? '' : isoDate(_int(settledAt)),
      isoDate(_int(row['created_at'])),
      lastEdited == null ? '' : isoDate(lastEdited.millisecondsSinceEpoch),
      '$edits',
      '${row['id']}',
    ];
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
