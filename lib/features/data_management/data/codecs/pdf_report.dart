import 'dart:typed_data';

import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/utils/app_formats.dart';
import '../../../expenses/domain/entities/month.dart';
import '../models/export_texts.dart';
import 'debt_rows.dart';

/// Everything a report is built from. Plain data, so it can be handed to a
/// background isolate.
class ReportInput {
  const ReportInput({
    required this.expenses,
    required this.categoryNames,
    this.incomeCategoryIds = const {},
    required this.texts,
    required this.formatsLocale,
    required this.currencySymbol,
    required this.rightToLeft,
    required this.font,
    required this.boldFont,
    this.recurring = const [],
    this.recurringSchedules = const {},
    this.people = const [],
    this.settlements = const [],
    this.personTransactions = const [],
    this.personTransactionEdits = const [],
  });

  /// Rows in the phone's format; deleted ones are skipped.
  final List<Map<String, Object?>> expenses;

  /// Category id to the name shown in the app.
  final Map<String, String> categoryNames;

  /// Transactions in these categories are income, not spending.
  final Set<String> incomeCategoryIds;
  final ExportTexts texts;
  final String formatsLocale;
  final String currencySymbol;
  final bool rightToLeft;

  /// One font with Arabic and Latin: the PDF's built-in fonts have no
  /// Arabic, and notes and category names can be in either language
  /// whatever the app's language is.
  final Uint8List font;
  final Uint8List boldFont;

  /// `recurring_expenses` rows; deleted ones are skipped.
  final List<Map<String, Object?>> recurring;

  /// Recurring payment id to its schedule, worded in the report's language.
  final Map<String, String> recurringSchedules;

  /// The people and debts tables' rows; deleted ones are skipped.
  final List<Map<String, Object?>> people;
  final List<Map<String, Object?>> settlements;
  final List<Map<String, Object?>> personTransactions;
  final List<Map<String, Object?>> personTransactionEdits;
}

/// A readable, printable report of every expense: totals, spending by
/// category and by month, then each month's expenses. Income is summed up
/// next to the spending but kept out of every spending figure. Then any
/// recurring payments, and what is owed between the user and each person,
/// with the settled history. For reading and sharing only; it cannot be
/// imported.
///
/// Pure Dart, so it can run on a background isolate.
Future<Uint8List> buildPdfReport(ReportInput input) async {
  // Date names are loaded per isolate.
  await initializeDateFormatting();
  final formats = AppFormats(
    localeName: input.formatsLocale,
    currencySymbol: input.currencySymbol,
  );
  final texts = input.texts;
  final direction = input.rightToLeft
      ? pw.TextDirection.rtl
      : pw.TextDirection.ltr;

  final transactions = [
    for (final row in input.expenses)
      if (row['deleted_at'] == null) _ReportExpense.from(row),
  ]..sort((a, b) => b.date.compareTo(a.date));
  bool isIncome(_ReportExpense e) =>
      input.incomeCategoryIds.contains(e.categoryId);
  final expenses = [
    for (final e in transactions)
      if (!isIncome(e)) e,
  ];

  final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
  final income = transactions.fold<double>(
    0,
    (sum, e) => isIncome(e) ? sum + e.amount : sum,
  );
  final byMonth = <Month, List<_ReportExpense>>{};
  final byCategory = <String, (int, double)>{};
  for (final expense in expenses) {
    byMonth.putIfAbsent(expense.month, () => []).add(expense);
    final (count, sum) = byCategory[expense.categoryId] ?? (0, 0.0);
    byCategory[expense.categoryId] = (count + 1, sum + expense.amount);
  }
  final categoryRows = byCategory.entries.toList()
    ..sort((a, b) => b.value.$2.compareTo(a.value.$2));

  String categoryName(String id) => input.categoryNames[id] ?? id;

  final recurring = [
    for (final row in input.recurring)
      if (row['deleted_at'] == null) row,
  ];

  final debts = DebtRows(
    people: input.people,
    settlements: input.settlements,
    transactions: input.personTransactions,
    edits: input.personTransactionEdits,
  );
  final (owedToYou, youOwe) = debts.totals;

  final theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(input.font.buffer.asByteData()),
    bold: pw.Font.ttf(input.boldFont.buffer.asByteData()),
    // Rare symbols the font lacks.
    fontFallback: [pw.Font.helvetica()],
  );
  const amountColumn = pw.AlignmentDirectional.centerEnd;
  const cellStyle = pw.TextStyle(fontSize: 9.5);

  pw.Widget table({
    required List<String> headers,
    required List<List<String>> rows,
    required Set<int> amountColumns,
  }) => pw.TableHelper.fromTextArray(
    headers: [
      for (final header in headers)
        _text(
          header,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
    ],
    data: rows,
    // Columns follow the report's language; each cell's text then takes its
    // own direction, so a note in the other language still reads right.
    tableDirection: direction,
    cellBuilder: (_, cell, _) => _text('$cell', style: cellStyle),
    border: null,
    headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
      ),
    ),
    cellAlignment: pw.AlignmentDirectional.centerStart,
    headerAlignment: pw.AlignmentDirectional.centerStart,
    cellAlignments: {for (final column in amountColumns) column: amountColumn},
    headerAlignments: {
      for (final column in amountColumns) column: amountColumn,
    },
  );

  pw.Widget heading(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 18, bottom: 8),
    child: _text(
      text,
      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
    ),
  );

  final document = pw.Document(theme: theme, title: texts.title);
  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      textDirection: direction,
      margin: const pw.EdgeInsets.all(36),
      // Room for years of expenses; the default of 20 pages is too few.
      maxPages: 5000,
      footer: (context) => pw.Align(
        alignment: pw.AlignmentDirectional.centerEnd,
        child: _text(
          texts.page(context.pageNumber, context.pagesCount),
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
        ),
      ),
      build: (context) => [
        _text(
          texts.title,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        _text(
          texts.generated,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        if (transactions.isEmpty) ...[
          pw.SizedBox(height: 24),
          _text(texts.empty),
        ] else ...[
          pw.SizedBox(height: 16),
          table(
            headers: [texts.period, texts.totalSpent, texts.count],
            rows: [
              [
                '${formats.fullDate(transactions.last.date)} - '
                    '${formats.fullDate(transactions.first.date)}',
                formats.money(total),
                '${expenses.length}',
              ],
            ],
            amountColumns: {1, 2},
          ),
          pw.SizedBox(height: 6),
          if (byMonth.isNotEmpty)
            _text(
              '${texts.monthlyAverage}: '
              '${formats.money(total / byMonth.length)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          if (income > 0)
            _text(
              '${texts.totalIncome}: ${formats.money(income)}  ·  '
              '${texts.net}: ${formats.money(income - total)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          heading(texts.byCategory),
          table(
            headers: [texts.category, texts.count, texts.total, texts.share],
            rows: [
              for (final entry in categoryRows)
                [
                  categoryName(entry.key),
                  '${entry.value.$1}',
                  formats.money(entry.value.$2),
                  _percent(entry.value.$2, total),
                ],
            ],
            amountColumns: {1, 2, 3},
          ),
          heading(texts.byMonth),
          table(
            headers: [texts.month, texts.count, texts.total],
            rows: [
              for (final MapEntry(key: month, value: items) in byMonth.entries)
                [
                  formats.monthLabel(month),
                  '${items.length}',
                  formats.money(items.fold(0.0, (sum, e) => sum + e.amount)),
                ],
            ],
            amountColumns: {1, 2},
          ),
          heading(texts.allExpenses),
          for (final MapEntry(key: month, value: items) in byMonth.entries) ...[
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
              child: _text(
                '${formats.monthLabel(month)}: '
                '${formats.money(items.fold(0.0, (sum, e) => sum + e.amount))}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            table(
              headers: [texts.date, texts.category, texts.note, texts.amount],
              rows: [
                for (final expense in items)
                  [
                    formats.fullDate(expense.date),
                    categoryName(expense.categoryId),
                    expense.note ?? '',
                    formats.money(expense.amount),
                  ],
              ],
              amountColumns: {3},
            ),
          ],
        ],
        if (recurring.isNotEmpty) ...[
          heading(texts.recurringPayments),
          table(
            headers: [
              texts.name,
              texts.category,
              texts.repeats,
              texts.mode,
              texts.amount,
            ],
            rows: [
              for (final row in recurring)
                [
                  '${row['title']}',
                  categoryName(row['category_id']! as String),
                  input.recurringSchedules[row['id']] ?? '',
                  row['mode'] == 'auto' ? texts.autoDeduct : texts.reminder,
                  formats.money((row['amount']! as num).toDouble()),
                ],
            ],
            amountColumns: {4},
          ),
        ],
        if (!debts.isEmpty) ...[
          heading(texts.peopleAndDebts),
          _text(
            '${texts.owedToYou}: ${formats.money(owedToYou)}  ·  '
            '${texts.youOwe}: ${formats.money(youOwe)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 6),
          table(
            headers: [texts.person, texts.status, texts.balance],
            rows: [
              for (final person in debts.people)
                [
                  '${person['name']}',
                  DebtRows.standing(debts.balanceOf(person['id']), texts),
                  formats.money(debts.balanceOf(person['id']).magnitude),
                ],
            ],
            amountColumns: {2},
          ),
          for (final person in debts.people)
            ..._personLedger(
              person,
              debts: debts,
              texts: texts,
              formats: formats,
              table: table,
            ),
        ],
      ],
    ),
  );
  return document.save();
}

/// One person's open transactions, then each settlement with what it
/// cleared, newest first. Nothing for a person with no transactions.
List<pw.Widget> _personLedger(
  Map<String, Object?> person, {
  required DebtRows debts,
  required ExportTexts texts,
  required AppFormats formats,
  required pw.Widget Function({
    required List<String> headers,
    required List<List<String>> rows,
    required Set<int> amountColumns,
  })
  table,
}) {
  final transactions = [
    for (final row in debts.transactions)
      if (row['person_id'] == person['id']) row,
  ];
  if (transactions.isEmpty) return const [];

  final open = [
    for (final row in transactions)
      if (row['settled_at'] == null) row,
  ];
  final balance = debts.balanceOf(person['id']);

  pw.Widget label(String text, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
    child: _text(
      text,
      style: pw.TextStyle(
        fontSize: bold ? 11 : 10,
        fontWeight: bold ? pw.FontWeight.bold : null,
      ),
    ),
  );

  pw.Widget rows(List<Map<String, Object?>> items) => table(
    headers: [texts.date, texts.type, texts.note, texts.amount],
    rows: [
      for (final row in items)
        [
          formats.fullDate(DebtRows.time(row['date'])),
          DebtRows.typeLabel(row, texts),
          (row['note'] as String?) ?? '',
          formats.money((row['amount']! as num).toDouble()),
        ],
    ],
    amountColumns: {3},
  );

  return [
    pw.SizedBox(height: 8),
    label(
      '${person['name']}: ${DebtRows.standing(balance, texts)} '
      '${formats.money(balance.magnitude)}',
      bold: true,
    ),
    if (open.isNotEmpty) ...[label(texts.activeTransactions), rows(open)],
    for (final settlement in debts.settlements)
      if (settlement['person_id'] == person['id']) ...[
        label(
          '${texts.settledOn} '
          '${formats.fullDate(DebtRows.time(settlement['settled_at']))}: '
          '${_settlementDirection(settlement, texts)} '
          '${formats.money(((settlement['net_amount']! as num).toDouble()).abs())}',
        ),
        rows([
          for (final row in transactions)
            if (row['settlement_id'] == settlement['id']) row,
        ]),
      ],
  ];
}

String _settlementDirection(Map<String, Object?> row, ExportTexts texts) {
  final net = (row['net_amount']! as num).toDouble();
  return net > 0
      ? texts.theyPaidYou
      : net < 0
      ? texts.youPaidThem
      : texts.settledUp;
}

final RegExp _arabicLetters = RegExp(
  '[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
);

/// One piece of report text, laid out in the direction its content needs.
///
/// The PDF layout only joins and orders Arabic correctly inside a
/// right-to-left paragraph (Latin inside one is fine), so anything with
/// Arabic in it is laid out right to left, whatever the report's language,
/// and everything else left to right. The layout applies no kerning, so the
/// tail of a final ر or ل would run into the next word; wider word gaps keep
/// Arabic words visibly apart.
pw.Text _text(String text, {pw.TextStyle? style}) {
  final printable = _printable(text);
  final arabic = _arabicLetters.hasMatch(printable);
  return pw.Text(
    printable,
    textDirection: arabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
    style: (style ?? const pw.TextStyle()).copyWith(
      wordSpacing: arabic ? 1.5 : 1,
    ),
  );
}

/// Arabic number and date formats wrap values in invisible direction marks.
/// The PDF layout already orders right-to-left text itself, and a mark with
/// no glyph would print as a box, so they are dropped; a narrow no-break
/// space becomes an ordinary one.
String _printable(String text) => text
    .replaceAll(RegExp('[\u200E\u200F\u061C\u202A-\u202E\u2066-\u2069]'), '')
    .replaceAll('\u202F', ' ');

String _percent(double part, double whole) =>
    whole == 0 ? '0%' : '${(part / whole * 100).round()}%';

class _ReportExpense {
  const _ReportExpense({
    required this.date,
    required this.month,
    required this.amount,
    required this.categoryId,
    this.note,
  });

  factory _ReportExpense.from(Map<String, Object?> row) => _ReportExpense(
    date: DateTime.fromMillisecondsSinceEpoch((row['date']! as num).toInt()),
    month: Month.fromKey(row['month_key']! as String),
    amount: (row['amount']! as num).toDouble(),
    categoryId: row['category_id']! as String,
    note: row['description'] as String?,
  );

  final DateTime date;
  final Month month;
  final double amount;
  final String categoryId;
  final String? note;
}
