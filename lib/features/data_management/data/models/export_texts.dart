/// Every word an exported CSV or PDF uses, already in the app's language.
///
/// Plain strings only, so the texts can travel to the background isolate
/// where the files are built, away from the widget tree.
class ExportTexts {
  const ExportTexts({
    required this.date,
    required this.month,
    required this.category,
    required this.amount,
    required this.currency,
    required this.note,
    required this.id,
    required this.name,
    required this.builtIn,
    required this.count,
    required this.total,
    required this.share,
    required this.yes,
    required this.no,
    required this.title,
    required this.generated,
    required this.period,
    required this.totalSpent,
    required this.monthlyAverage,
    required this.byCategory,
    required this.byMonth,
    required this.allExpenses,
    required this.empty,
    required this.pageTemplate,
  });

  // Column headings.
  final String date;
  final String month;
  final String category;
  final String amount;
  final String currency;
  final String note;
  final String id;
  final String name;
  final String builtIn;
  final String count;
  final String total;
  final String share;
  final String yes;
  final String no;

  // Report.
  final String title;

  /// "Generated 28 Sep 2026, 3:05 PM", already formatted.
  final String generated;
  final String period;
  final String totalSpent;
  final String monthlyAverage;
  final String byCategory;
  final String byMonth;
  final String allExpenses;
  final String empty;

  /// With `{page}` and `{pages}` placeholders.
  final String pageTemplate;

  String page(int page, int pages) => pageTemplate
      .replaceAll('{page}', '$page')
      .replaceAll('{pages}', '$pages');
}
