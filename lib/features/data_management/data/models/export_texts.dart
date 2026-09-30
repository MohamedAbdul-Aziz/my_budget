/// Every word an exported CSV or PDF uses, already in the app's language.
///
/// Plain strings only, so the texts can travel to the background isolate
/// where the files are built, away from the widget tree.
class ExportTexts {
  const ExportTexts({
    required this.date,
    required this.month,
    required this.category,
    required this.type,
    required this.expense,
    required this.income,
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
    required this.totalIncome,
    required this.net,
    required this.monthlyAverage,
    required this.byCategory,
    required this.byMonth,
    required this.allExpenses,
    required this.empty,
    required this.pageTemplate,
    required this.recurringPayments,
    required this.repeats,
    required this.mode,
    required this.autoDeduct,
    required this.reminder,
    required this.paidThrough,
    required this.peopleAndDebts,
    required this.person,
    required this.phone,
    required this.balance,
    required this.status,
    required this.owesYou,
    required this.youOwe,
    required this.settledUp,
    required this.iPaidForThem,
    required this.theyPaidForMe,
    required this.open,
    required this.settled,
    required this.settledOn,
    required this.created,
    required this.lastEdited,
    required this.edits,
    required this.activeTransactions,
    required this.settledHistory,
    required this.owedToYou,
    required this.theyPaidYou,
    required this.youPaidThem,
  });

  // Column headings.
  final String date;
  final String month;
  final String category;
  final String type;
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

  // Values of the type column.
  final String expense;
  final String income;

  // Report.
  final String title;

  /// "Generated 28 Sep 2026, 3:05 PM", already formatted.
  final String generated;
  final String period;
  final String totalSpent;
  final String totalIncome;
  final String net;
  final String monthlyAverage;
  final String byCategory;
  final String byMonth;
  final String allExpenses;
  final String empty;

  /// With `{page}` and `{pages}` placeholders.
  final String pageTemplate;

  // Recurring payments: the report section heading and its own CSV.
  final String recurringPayments;
  final String repeats;
  final String mode;
  final String autoDeduct;
  final String reminder;
  final String paidThrough;

  // People and debts: the report section and its two CSVs.
  final String peopleAndDebts;
  final String person;
  final String phone;
  final String balance;
  final String status;

  // Where the user stands with a person.
  final String owesYou;
  final String youOwe;
  final String settledUp;

  // Values of the type and status columns.
  final String iPaidForThem;
  final String theyPaidForMe;
  final String open;
  final String settled;

  // The audit trail.
  final String settledOn;
  final String created;
  final String lastEdited;
  final String edits;

  final String activeTransactions;
  final String settledHistory;

  /// The total everyone owes the user.
  final String owedToYou;

  // Which way a past settlement went.
  final String theyPaidYou;
  final String youPaidThem;

  String page(int page, int pages) => pageTemplate
      .replaceAll('{page}', '$page')
      .replaceAll('{pages}', '$pages');
}
