import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart';

import '../../features/recurring/domain/entities/recurrence_frequency.dart';
import '../error/failures.dart';
import '../utils/app_formats.dart';
import '../utils/ui_notice.dart';

/// Hand-written localizations — no code generation, no build_runner.
///
/// Add a language by writing one more subclass and listing its locale in
/// [supportedLocales].
abstract class AppStrings {
  const AppStrings();

  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings) ?? const AppStringsEn();

  /// Resolves a language code the same way the delegate does. Anything the app
  /// does not translate falls back to English.
  static AppStrings forLanguageCode(String? languageCode) =>
      languageCode == 'ar' ? const AppStringsAr() : const AppStringsEn();

  /// Locale used for numbers and dates.
  String get localeName;

  String get appTitle;

  // Home
  String get add;
  String get undo;
  String get tryAgain;
  String get nothingRecordedYet;
  String get emptyMonthHint;
  String get yourMonths;
  String spentIn(String month);
  String expenseCount(int count);

  // Quick expense (home screen widget + quick-add sheet)
  String get quickExpense;
  String get expenseSaved;

  // Expense form
  String get newExpense;
  String get editExpense;
  String get when;
  String get today;
  String get yesterday;
  String get pickADate;
  String get category;
  String get noteOptional;
  String get noteHint;
  String get addExpense;
  String get saveChanges;
  String get amountHint;

  // Categories
  String get categories;
  String get newCategory;
  String get editCategory;
  String get addCategory;
  String get categoryName;
  String get color;
  String get icon;
  String get builtIn;
  String get custom;
  String get edit;
  String get delete;
  String get cancel;
  String deleteCategoryTitle(String name);
  String get deleteCategoryBody;

  // Settings
  String get settings;
  String get appearance;
  String get themeSystem;
  String get themeLight;
  String get themeDark;
  String get language;
  String get languageSystem;
  String get currency;
  String get currencySymbol;
  String get currencySymbolHint;
  String get storedOnThisDevice;

  // Account
  String get account;
  String get accountOptional;
  String get signIn;
  String get signOut;
  String get signedIn;
  String get createAccount;
  String get noAccountYet;
  String get haveAnAccount;
  String get email;
  String get password;
  String get passwordRules;
  String get confirmEmail;
  String codeSentTo(String email);
  String get confirmationCode;
  String get confirm;
  String get resendCode;
  String get codeResent;
  String get useDifferentEmail;

  // Backup
  String get backupHint;
  String get backUpNow;
  String get restoreData;
  String get backingUp;
  String get restoring;
  String get backupDone;
  String get restoreDone;
  String get neverSynced;
  String lastSynced(String when);

  // Account deletion
  String get deleteAccount;
  String get deleteAccountTitle;
  String get deleteAccountBody;
  String get deletingAccount;
  String get accountDeleted;

  // Analyses
  String get home;
  String get analyses;
  String get vsLastMonth;
  String lastMonthTotal(String amount);
  String get noComparison;
  String get dailySpending;
  String get dailyAverage;
  String get topDay;
  String get byCategory;
  String get noSpendingThisMonth;
  String get monthlyTrend;

  // Budgets
  String get budgets;
  String get monthlyBudget;
  String get setMonthlyBudget;
  String get setBudgetHint;
  String get setBudget;
  String get editBudget;
  String get removeBudget;
  String get save;
  String amountLeft(String amount);
  String amountOver(String amount);
  String spentOfLimit(String spent, String limit);
  String amountSpent(String amount);
  String budgetUsed(String percent);
  String get categoryBudgets;
  String get categoryBudgetsHint;
  String categoryBudgetTitle(String name);
  String get setLimit;
  String get closeToLimit;
  String budgetsRepeatHint(String nearing, String reached);

  // Budget alerts, shown when an expense crosses a threshold
  String get budgetAlertTitle;
  String get ok;
  String get view;
  String monthlyBudgetNearing(String percent);
  String get monthlyBudgetUsedUp;
  String monthlyBudgetExceeded(String amount);
  String categoryBudgetNearing(String name, String percent);
  String categoryBudgetUsedUp(String name);
  String categoryBudgetExceeded(String name, String amount);

  // Data management (files kept by the user)
  String get dataManagement;
  String get dataManagementHint;
  String get backUpToFile;
  String get backUpToFileHint;
  String get exportCsv;
  String get exportCsvHint;
  String get exportPdf;
  String get exportPdfHint;
  String get importData;
  String get importDataHint;
  String get preparingFile;
  String get importingData;
  String get fileSaved;
  String get importDone;
  String get importNothingNew;
  String get fileReady;
  String get shareFile;
  String get shareFileHint;
  String get saveToPhone;
  String get saveToPhoneHint;
  String get importTitle;

  /// [people] is left out of the sentence when there are none.
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  });
  String get importMergeHint;
  String get merge;
  String get replaceEverything;
  String get replaceTitle;
  String get replaceBody;
  String get replace;
  String categoryCount(int count);

  // Exported files: CSV columns and the PDF report
  String get colDate;
  String get colMonth;
  String get colAmount;
  String get colNote;
  String get colId;
  String get colCount;
  String get colTotal;
  String get colShare;
  String get yes;
  String get no;
  String get reportTitle;
  String reportGenerated(String when);
  String get reportPeriod;
  String get reportTotal;
  String get reportMonthlyAverage;
  String get reportByMonth;
  String get reportAllExpenses;
  String get reportEmpty;

  /// With `{page}` and `{pages}` placeholders: the report is laid out away
  /// from the widget tree, where only plain strings can travel.
  String get reportPageTemplate;
  String get showPassword;
  String get hidePassword;

  /// Localized names for the seeded categories; null for user-made ones.
  String? defaultCategoryName(String id);

  String failure(FailureCode code);

  /// `Today` / `Yesterday` / a formatted date.
  String dayLabel(DateTime date, AppFormats formats) =>
      switch (AppFormats.daysAgo(date)) {
        0 => today,
        1 => yesterday,
        _ => formats.dayLabel(date),
      };

  /// Renders a cubit's one-shot notice as a sentence.
  String notice(UiNotice notice) => switch (notice.code) {
    NoticeCode.expenseDeleted => expenseDeleted,
    NoticeCode.expenseRestored => expenseRestored,
    NoticeCode.incomeDeleted => incomeDeleted,
    NoticeCode.incomeRestored => incomeRestored,
    NoticeCode.categoryAdded => categoryAdded(notice.name ?? ''),
    NoticeCode.categoryUpdated => categoryUpdated,
    NoticeCode.categoryDeleted => categoryDeleted(notice.name ?? ''),
    NoticeCode.categoryDeletedWithMoves => categoryDeletedWithMoves(
      notice.name ?? '',
      notice.count ?? 0,
    ),
    NoticeCode.incomeCategoryDeletedWithMoves => incomeCategoryDeletedWithMoves(
      notice.name ?? '',
      notice.count ?? 0,
    ),
    NoticeCode.recurringPaid => recurringPaid(notice.name ?? ''),
    NoticeCode.recurringPaymentUndone => recurringPaymentUndone,
    NoticeCode.recurringDeleted => categoryDeleted(notice.name ?? ''),
    NoticeCode.recurringAutoLogged => recurringAutoLogged(notice.count ?? 0),
    NoticeCode.personAdded => categoryAdded(notice.name ?? ''),
    NoticeCode.personUpdated => personUpdated,
    NoticeCode.personDeleted => categoryDeleted(notice.name ?? ''),
    NoticeCode.debtDeleted => debtDeleted,
    NoticeCode.settledUp => settledUpNotice,
    NoticeCode.settlementLogged => settlementLogged,
    NoticeCode.failure => failure(notice.failure?.code ?? FailureCode.unknown),
  };

  String get expenseDeleted;
  String get expenseRestored;
  String categoryAdded(String name);
  String get categoryUpdated;
  String categoryDeleted(String name);
  String categoryDeletedWithMoves(String name, int count);
  String incomeCategoryDeletedWithMoves(String name, int count);

  // Income and the month's balance
  String get expense;
  String get income;
  String get transactionType;
  String get quickIncome;
  String get newIncome;
  String get editIncome;
  String get addIncome;
  String get incomeNoteHint;
  String get totalIncome;
  String get totalExpenses;
  String get netBalance;
  String get savingsRate;
  String get savingsRateNoIncome;
  String get expenseCategories;
  String get incomeCategories;
  String get deleteIncomeCategoryBody;
  String get incomeDeleted;
  String get incomeRestored;
  String get colType;
  String transactionCount(int count);

  // Recurring payments
  String get recurringPayments;
  String get newRecurring;
  String get editRecurring;
  String get addRecurring;
  String get recurringTitle;
  String get recurringTitleHint;
  String get amount;
  String get repeats;
  String get weekly;
  String get monthly;
  String get yearly;
  String get dueOn;
  String get dueDayOfMonth;
  String get dueMonthLabel;
  String get dueDayLabel;
  String get shortMonthHint;
  String get whenDue;
  String get autoDeduct;
  String get remindMe;
  String get autoDeductHint;
  String get remindMeHint;
  String get statusPaid;
  String get statusUpcoming;
  String get statusOverdue;
  String get markAsPaid;
  String get dueToday;
  String dueOnDate(String date);
  String nextDueOn(String date);
  String overdueSince(String date, int count);
  String everyWeekday(String weekday);
  String monthlyOnDay(String day);
  String yearlyOn(String date);
  String get monthlyAverage;
  String get monthlyAverageHint;
  String get noRecurringYet;
  String get noRecurringHint;
  String get paymentsToConfirm;
  String get seeAll;
  String get deleteRecurringBody;
  String recurringPaid(String name);
  String get recurringPaymentUndone;
  String recurringAutoLogged(int count);
  String paymentCount(int count);
  String get colPaidThrough;

  /// "Every Friday", "Monthly on day 15", "Yearly on 10 Mar".
  String recurringSchedule(
    RecurrenceFrequency frequency, {
    required int dueDay,
    int? dueMonth,
    required AppFormats formats,
  }) => switch (frequency) {
    RecurrenceFrequency.weekly => everyWeekday(formats.weekdayName(dueDay)),
    RecurrenceFrequency.monthly => monthlyOnDay(formats.number(dueDay)),
    RecurrenceFrequency.yearly => yearlyOn(
      formats.dayOfYear(dueMonth ?? 1, dueDay),
    ),
  };

  String frequencyName(RecurrenceFrequency frequency) => switch (frequency) {
    RecurrenceFrequency.weekly => weekly,
    RecurrenceFrequency.monthly => monthly,
    RecurrenceFrequency.yearly => yearly,
  };

  // People & debts
  String get people;
  String get peopleAndDebts;
  String get person;
  String get personName;
  String get phone;
  String get phoneOptional;
  String get balance;
  String get colStatus;
  String get owesYou;
  String get youOwe;
  String get owedToYou;
  String get settledUp;
  String get iPaidForThem;
  String get theyPaidForMe;
  String get theyPaidYou;
  String get youPaidThem;
  String get openStatus;
  String get settledStatus;
  String get settledOn;
  String get createdOn;
  String get lastEdited;
  String get colEdits;
  String get activeTransactions;
  String get settledHistory;
  String get filterAll;
  String get filterOwedToMe;
  String get filterIOwe;
  String get filterSettled;
  String get addPerson;
  String get addPersonHint;
  String get newPerson;
  String get editPerson;
  String get deletePerson;
  String get quickTransaction;
  String get quickTransactionHint;
  String get noPeopleYet;
  String get noPeopleHint;
  String get nobodyHere;
  String get addPersonFirst;
  String get newTransaction;
  String get editTransaction;
  String get transactionDetails;
  String get debtNoteHint;
  String get changeHistory;
  String get edited;
  String get settleUp;
  String get settle;
  String get noDebtsYet;
  String get noDebtsHint;
  String get settleEven;
  String get logSettlementTitle;
  String get loggedInBudget;
  String get deleteTransactionTitle;
  String get deleteTransactionBody;
  String get deletePersonBody;
  String get settledLocked;
  String get personUpdated;
  String get debtDeleted;
  String get settledUpNotice;
  String get settlementLogged;
  String personOwesYou(String name);
  String youOwePerson(String name);
  String settledWith(String name);
  String settleUpFor(String amount);
  String settleTitle(String name);
  String settleTheyPay(String name, String amount);
  String settleYouPay(String name, String amount);
  String settleMoves(int count);
  String logSettlementIncome(String amount);
  String logSettlementExpense(String amount);
  String settlementNote(String name);
  String settledGroupTitle(String date);
  String deletePersonTitle(String name);
  String editedOn(String date);
  String wasValues(String values);
  String personCount(int count);
}

class AppStringsEn extends AppStrings {
  const AppStringsEn();

  @override
  String get localeName => 'en_US';

  @override
  String get appTitle => 'My Budget';

  @override
  String get add => 'Add';

  @override
  String get undo => 'Undo';

  @override
  String get tryAgain => 'Try again';

  @override
  String get nothingRecordedYet => 'Nothing recorded yet';

  @override
  String get emptyMonthHint =>
      'Tap Add to record your first expense or income for this month.';

  @override
  String get yourMonths => 'Your months';

  @override
  String spentIn(String month) => 'Spent in $month';

  @override
  String expenseCount(int count) =>
      count == 1 ? '1 expense' : '$count expenses';

  @override
  String get quickExpense => 'Quick expense';

  @override
  String get expenseSaved => 'Expense saved';

  @override
  String get newExpense => 'New expense';

  @override
  String get editExpense => 'Edit expense';

  @override
  String get when => 'When';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get pickADate => 'Pick a date';

  @override
  String get category => 'Category';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get noteHint => 'What was it for?';

  @override
  String get addExpense => 'Add expense';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Categories';

  @override
  String get newCategory => 'New category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get addCategory => 'Add category';

  @override
  String get categoryName => 'Name';

  @override
  String get color => 'Color';

  @override
  String get icon => 'Icon';

  @override
  String get builtIn => 'Built in';

  @override
  String get custom => 'Custom';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String deleteCategoryTitle(String name) => 'Delete $name?';

  @override
  String get deleteCategoryBody =>
      'Expenses in this category will be moved to Other. Nothing is deleted.';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get currency => 'Currency';

  @override
  String get currencySymbol => 'Symbol';

  @override
  String get currencySymbolHint => 'Shown next to every amount';

  @override
  String get storedOnThisDevice =>
      'Your expenses are stored on this device. Sign in to back them up.';

  @override
  String get account => 'Account';

  @override
  String get accountOptional =>
      'An account is optional. The app works fully without one.';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get signedIn => 'Signed in';

  @override
  String get createAccount => 'Create account';

  @override
  String get noAccountYet => 'No account yet? Create one';

  @override
  String get haveAnAccount => 'Already have an account? Sign in';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get passwordRules => 'At least 6 characters';

  @override
  String get confirmEmail => 'Confirm your email';

  @override
  String codeSentTo(String email) =>
      'We sent a code to $email. Enter it below to finish creating your '
      'account.';

  @override
  String get confirmationCode => 'Code';

  @override
  String get confirm => 'Confirm';

  @override
  String get resendCode => 'Send a new code';

  @override
  String get codeResent => 'A new code is on its way';

  @override
  String get useDifferentEmail => 'Use a different email';

  @override
  String get backupHint =>
      'Back up to keep a copy of your expenses in your account. Restore '
      'brings that copy to this phone without removing anything already here.';

  @override
  String get backUpNow => 'Back up now';

  @override
  String get restoreData => 'Restore';

  @override
  String get backingUp => 'Backing up…';

  @override
  String get restoring => 'Restoring…';

  @override
  String get backupDone => 'Backup complete';

  @override
  String get restoreDone => 'Restore complete';

  @override
  String get neverSynced => 'Not backed up yet';

  @override
  String lastSynced(String when) => 'Last synced $when';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountBody =>
      'This permanently deletes your account and the backup of your expenses '
      'stored with it. It cannot be undone. The expenses on this phone stay '
      'here, and you can keep using the app without an account.';

  @override
  String get deletingAccount => 'Deleting your account…';

  @override
  String get accountDeleted => 'Your account was deleted';

  @override
  String get home => 'Home';

  @override
  String get analyses => 'Analyses';

  @override
  String get vsLastMonth => 'Compared with last month';

  @override
  String get noComparison => 'No data last month';

  @override
  String get dailySpending => 'Daily spending';

  @override
  String get dailyAverage => 'Average per day';

  @override
  String get topDay => 'Highest day';

  @override
  String get byCategory => 'Spending by category';

  @override
  String get noSpendingThisMonth => 'Nothing spent this month yet.';

  @override
  String get monthlyTrend => 'Last 6 months';

  @override
  String lastMonthTotal(String amount) => 'Last month: $amount';

  @override
  String get budgets => 'Budgets';

  @override
  String get monthlyBudget => 'Monthly budget';

  @override
  String get setMonthlyBudget => 'Set a monthly budget';

  @override
  String get setBudgetHint =>
      "See what's left and get a heads-up before you overspend.";

  @override
  String get setBudget => 'Set';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get removeBudget => 'Remove';

  @override
  String get save => 'Save';

  @override
  String amountLeft(String amount) => '$amount left';

  @override
  String amountOver(String amount) => '$amount over budget';

  @override
  String spentOfLimit(String spent, String limit) => '$spent of $limit spent';

  @override
  String amountSpent(String amount) => '$amount spent';

  @override
  String budgetUsed(String percent) => '$percent of the budget used';

  @override
  String get categoryBudgets => 'Category budgets';

  @override
  String get categoryBudgetsHint => 'Cap what you spend on a single category.';

  @override
  String categoryBudgetTitle(String name) => '$name budget';

  @override
  String get setLimit => 'Set limit';

  @override
  String get closeToLimit => 'Close to their limit';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      "Budgets repeat every month. You'll get a heads-up when spending "
      'passes $nearing, and again at $reached.';

  @override
  String get budgetAlertTitle => 'Budget alert';

  @override
  String get ok => 'OK';

  @override
  String get view => 'View';

  @override
  String monthlyBudgetNearing(String percent) =>
      "You've used $percent of your monthly budget";

  @override
  String get monthlyBudgetUsedUp => "You've used all of your monthly budget";

  @override
  String monthlyBudgetExceeded(String amount) =>
      "You're $amount over your monthly budget";

  @override
  String categoryBudgetNearing(String name, String percent) =>
      "You've used $percent of your $name budget";

  @override
  String categoryBudgetUsedUp(String name) =>
      "You've used all of your $name budget";

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      "You're $amount over your $name budget";

  @override
  String get dataManagement => 'Data management';

  @override
  String get dataManagementHint =>
      'Files you keep yourself. They work offline and need no account.';

  @override
  String get backUpToFile => 'Back up my data';

  @override
  String get backUpToFileHint => 'A complete backup file you can import later';

  @override
  String get exportCsv => 'Export as CSV';

  @override
  String get exportCsvHint => 'For Excel or Google Sheets';

  @override
  String get exportPdf => 'Export as PDF';

  @override
  String get exportPdfHint => 'A report to read, print or share';

  @override
  String get importData => 'Import data';

  @override
  String get importDataHint => 'Restore from a backup file';

  @override
  String get preparingFile => 'Preparing your file…';

  @override
  String get importingData => 'Importing…';

  @override
  String get fileSaved => 'File saved';

  @override
  String get importDone => 'Import complete';

  @override
  String get importNothingNew =>
      'This phone already had everything in the backup';

  @override
  String get fileReady => 'Your file is ready';

  @override
  String get shareFile => 'Share';

  @override
  String get shareFileHint => 'WhatsApp, email, Google Drive and more';

  @override
  String get saveToPhone => 'Save to this phone';

  @override
  String get saveToPhoneHint => 'Choose where to keep it';

  @override
  String get importTitle => 'Import this backup?';

  @override
  String get importMergeHint =>
      'Merge keeps everything on this phone and adds what is missing. Where a record differs, the newer change wins.';

  @override
  String get merge => 'Merge';

  @override
  String get replaceEverything => 'Replace everything';

  @override
  String get replaceTitle => 'Replace everything on this phone?';

  @override
  String get replaceBody =>
      'Everything on this phone that is not in the backup will be deleted, and the backup\'s version of every record will be used. This cannot be undone.';

  @override
  String get replace => 'Replace';

  @override
  String get colDate => 'Date';

  @override
  String get colMonth => 'Month';

  @override
  String get colAmount => 'Amount';

  @override
  String get colNote => 'Note';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Transactions';

  @override
  String get colTotal => 'Total';

  @override
  String get colShare => 'Share';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get reportTitle => 'My Budget: expense report';

  @override
  String get reportPeriod => 'Period';

  @override
  String get reportTotal => 'Total spent';

  @override
  String get reportMonthlyAverage => 'Average per month';

  @override
  String get reportByMonth => 'Spending by month';

  @override
  String get reportAllExpenses => 'All expenses';

  @override
  String get reportEmpty => 'No expenses recorded yet.';

  @override
  String get reportPageTemplate => 'Page {page} of {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} and ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} and '
              '${personCount(people)}';
    return date == null
        ? 'This backup has $contents.'
        : 'Backup from $date: $contents.';
  }

  @override
  String categoryCount(int count) =>
      count == 1 ? '1 category' : '$count categories';

  @override
  String reportGenerated(String when) => 'Generated $when';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Food',
    'cat_transport' => 'Transportation',
    'cat_bills' => 'Bills',
    'cat_shopping' => 'Shopping',
    'cat_health' => 'Health & Fitness',
    'cat_entertainment' => 'Entertainment',
    'cat_work' => 'Work',
    'cat_other' => 'Other',
    'cat_salary' => 'Salary',
    'cat_freelance' => 'Freelance',
    'cat_investments' => 'Investments',
    'cat_gifts' => 'Gifts',
    'cat_income_other' => 'Other income',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => "Couldn't save to this device. Try again.",
    FailureCode.notFound => 'That item no longer exists.',
    FailureCode.unknown => 'Something went wrong.',
    FailureCode.amountRequired => 'Enter an amount greater than zero.',
    FailureCode.amountTooLarge => 'That amount is too large.',
    FailureCode.amountInvalid => 'Enter a valid amount.',
    FailureCode.categoryRequired => 'Pick a category.',
    FailureCode.categoryNameRequired => 'Give the category a name.',
    FailureCode.categoryNameTooLong => 'Keep the name under 30 characters.',
    FailureCode.categoryProtected => 'This category cannot be deleted.',
    FailureCode.currencySymbolInvalid => 'Use 1 to 4 characters.',
    FailureCode.network =>
      "Couldn't connect. Check your internet and try again.",
    FailureCode.emailInvalid => 'Enter a valid email address.',
    FailureCode.passwordTooShort =>
      'Use at least 6 characters for the password.',
    FailureCode.invalidCredentials => 'Wrong email or password.',
    FailureCode.emailTaken => 'An account with this email already exists.',
    FailureCode.emailNotConfirmed =>
      'Confirm your email first with the code we sent you.',
    FailureCode.codeInvalid => 'That code is wrong or has expired.',
    FailureCode.signInRequired => 'Sign in again, then try once more.',
    FailureCode.syncOtherAccount =>
      "This phone's data is linked to a different account.",
    FailureCode.syncFailed => "Couldn't sync with your account. Try again.",
    FailureCode.accountDeletionFailed =>
      "Couldn't delete your account. Try again.",
    FailureCode.backupNotRecognized => "This file isn't a My Budget backup.",
    FailureCode.backupTooNew =>
      'This backup comes from a newer version of My Budget. Update the app, '
          'then try again.',
    FailureCode.backupDamaged =>
      'This backup file is damaged, so nothing was imported.',
    FailureCode.fileUnavailable =>
      "Couldn't open that file. Try choosing it again.",
    FailureCode.storageFull => "There isn't enough free space on this phone.",
    FailureCode.exportFailed => "Couldn't create the file. Try again.",
    FailureCode.shareUnavailable => "Couldn't open the share menu.",
    FailureCode.saveFailed => "Couldn't save the file. Try again.",
    FailureCode.tooManyAttempts =>
      'Too many attempts. Wait a moment and try again.',
    FailureCode.titleRequired => 'Give it a name.',
    FailureCode.titleTooLong => 'Keep the name under 40 characters.',
    FailureCode.dueDayInvalid => 'Pick when it is due.',
    FailureCode.alreadyPaid => 'That payment is already recorded.',
    FailureCode.personRequired => 'Choose a person.',
    FailureCode.personNameRequired => 'Enter a name.',
    FailureCode.personNameTooLong => 'Keep the name under 40 characters.',
    FailureCode.phoneInvalid => 'Enter a valid phone number.',
    FailureCode.transactionSettled => "Settled transactions can't be changed.",
    FailureCode.nothingToSettle => "There's nothing to settle.",
    FailureCode.settlementAlreadyLogged =>
      'This settlement is already in your budget.',
  };

  @override
  String get expenseDeleted => 'Expense deleted';

  @override
  String get expenseRestored => 'Expense restored';

  @override
  String categoryAdded(String name) => '$name added';

  @override
  String get categoryUpdated => 'Category updated';

  @override
  String categoryDeleted(String name) => '$name deleted';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name deleted — ${expenseCount(count)} moved to Other';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name deleted — ${transactionCount(count)} moved to Other income';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get transactionType => 'Expense or income';

  @override
  String get quickIncome => 'Quick income';

  @override
  String get newIncome => 'New income';

  @override
  String get editIncome => 'Edit income';

  @override
  String get addIncome => 'Add income';

  @override
  String get incomeNoteHint => 'Where did it come from?';

  @override
  String get totalIncome => 'Total income';

  @override
  String get totalExpenses => 'Total expenses';

  @override
  String get netBalance => 'Net balance';

  @override
  String get savingsRate => 'Savings rate';

  @override
  String get savingsRateNoIncome => 'Add income to see your savings rate';

  @override
  String get expenseCategories => 'Expense categories';

  @override
  String get incomeCategories => 'Income categories';

  @override
  String get deleteIncomeCategoryBody =>
      'Income in this category will be moved to Other income. Nothing is '
      'deleted.';

  @override
  String get incomeDeleted => 'Income deleted';

  @override
  String get incomeRestored => 'Income restored';

  @override
  String get colType => 'Type';

  @override
  String transactionCount(int count) =>
      count == 1 ? '1 transaction' : '$count transactions';

  @override
  String get recurringPayments => 'Recurring payments';

  @override
  String get newRecurring => 'New recurring payment';

  @override
  String get editRecurring => 'Edit recurring payment';

  @override
  String get addRecurring => 'Add payment';

  @override
  String get recurringTitle => 'Name';

  @override
  String get recurringTitleHint => 'Rent, Netflix, gym…';

  @override
  String get amount => 'Amount';

  @override
  String get repeats => 'Repeats';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get dueOn => 'Due on';

  @override
  String get dueDayOfMonth => 'Day of the month';

  @override
  String get dueMonthLabel => 'Month';

  @override
  String get dueDayLabel => 'Day';

  @override
  String get shortMonthHint => 'In shorter months, it falls on the last day.';

  @override
  String get whenDue => "When it's due";

  @override
  String get autoDeduct => 'Auto-deduct';

  @override
  String get remindMe => 'Remind me';

  @override
  String get autoDeductHint =>
      'Logged as an expense automatically on the due date.';

  @override
  String get remindMeHint =>
      "You'll be asked to confirm each payment before it's logged.";

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get markAsPaid => 'Mark as paid';

  @override
  String get dueToday => 'Due today';

  @override
  String dueOnDate(String date) => 'Due $date';

  @override
  String nextDueOn(String date) => 'Next on $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Was due $date'
      : '${paymentCount(count)} overdue since $date';

  @override
  String everyWeekday(String weekday) => 'Every $weekday';

  @override
  String monthlyOnDay(String day) => 'Monthly on day $day';

  @override
  String yearlyOn(String date) => 'Yearly on $date';

  @override
  String get monthlyAverage => 'Each month';

  @override
  String get monthlyAverageHint => 'All your recurring payments, on average';

  @override
  String get noRecurringYet => 'No recurring payments yet';

  @override
  String get noRecurringHint =>
      "Add rent, bills and subscriptions once. Each month you'll see what's "
      'paid and what is still due.';

  @override
  String get paymentsToConfirm => 'Payments to confirm';

  @override
  String get seeAll => 'See all';

  @override
  String get deleteRecurringBody =>
      'It stops repeating. Payments already logged stay in your transactions.';

  @override
  String recurringPaid(String name) => '$name marked as paid';

  @override
  String get recurringPaymentUndone => 'Payment removed';

  @override
  String recurringAutoLogged(int count) => count == 1
      ? '1 recurring payment was logged automatically'
      : '$count recurring payments were logged automatically';

  @override
  String paymentCount(int count) =>
      count == 1 ? '1 payment' : '$count payments';

  @override
  String get colPaidThrough => 'Paid through';

  // People & debts

  @override
  String get people => 'People';

  @override
  String get peopleAndDebts => 'People & debts';

  @override
  String get person => 'Person';

  @override
  String get personName => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get balance => 'Balance';

  @override
  String get colStatus => 'Status';

  @override
  String get owesYou => 'Owes you';

  @override
  String get youOwe => 'You owe';

  @override
  String get owedToYou => 'Owed to you';

  @override
  String get settledUp => 'Settled up';

  @override
  String get iPaidForThem => 'I paid for them';

  @override
  String get theyPaidForMe => 'They paid for me';

  @override
  String get theyPaidYou => 'They paid you';

  @override
  String get youPaidThem => 'You paid them';

  @override
  String get openStatus => 'Open';

  @override
  String get settledStatus => 'Settled';

  @override
  String get settledOn => 'Settled on';

  @override
  String get createdOn => 'Created';

  @override
  String get lastEdited => 'Last edited';

  @override
  String get colEdits => 'Edits';

  @override
  String get activeTransactions => 'Active transactions';

  @override
  String get settledHistory => 'Settled history';

  @override
  String get filterAll => 'All';

  @override
  String get filterOwedToMe => 'Owed to me';

  @override
  String get filterIOwe => 'I owe';

  @override
  String get filterSettled => 'Settled';

  @override
  String get addPerson => 'Add person';

  @override
  String get addPersonHint => 'Someone you share costs with';

  @override
  String get newPerson => 'New person';

  @override
  String get editPerson => 'Edit person';

  @override
  String get deletePerson => 'Delete person';

  @override
  String get quickTransaction => 'Quick transaction';

  @override
  String get quickTransactionHint =>
      "Record who paid, with someone you've added";

  @override
  String get noPeopleYet => 'No people yet';

  @override
  String get noPeopleHint =>
      'Add the people you share costs with to keep track of who owes whom.';

  @override
  String get nobodyHere => 'Nobody matches this filter.';

  @override
  String get addPersonFirst => 'Add a person first.';

  @override
  String get newTransaction => 'New transaction';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get transactionDetails => 'Transaction details';

  @override
  String get debtNoteHint => 'What was it for?';

  @override
  String get changeHistory => 'Change history';

  @override
  String get edited => 'Edited';

  @override
  String get settleUp => 'Settle up';

  @override
  String get settle => 'Settle';

  @override
  String get noDebtsYet => 'Nothing recorded yet';

  @override
  String get noDebtsHint =>
      'Add what you paid for them, or what they paid for you.';

  @override
  String get settleEven =>
      'These transactions cancel each other out, so no money needs to change hands.';

  @override
  String get logSettlementTitle =>
      'Log this settlement in your monthly budget?';

  @override
  String get loggedInBudget => 'In your budget';

  @override
  String get deleteTransactionTitle => 'Delete this transaction?';

  @override
  String get deleteTransactionBody =>
      'It will be removed from the balance with this person.';

  @override
  String get deletePersonBody =>
      'Their transactions and settled history are deleted too. Anything you logged in your budget stays.';

  @override
  String get settledLocked => 'Settled, so it can no longer be changed.';

  @override
  String get personUpdated => 'Person updated';

  @override
  String get debtDeleted => 'Transaction deleted';

  @override
  String get settledUpNotice => 'All settled up';

  @override
  String get settlementLogged => 'Added to your budget';

  @override
  String personOwesYou(String name) => '$name owes you';

  @override
  String youOwePerson(String name) => 'You owe $name';

  @override
  String settledWith(String name) => 'All settled up with $name';

  @override
  String settleUpFor(String amount) => 'Settle up $amount';

  @override
  String settleTitle(String name) => 'Settle up with $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name pays you $amount to clear everything.';

  @override
  String settleYouPay(String name, String amount) =>
      'You pay $name $amount to clear everything.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} will move to the settled history.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount will be added as income in Other income. You can move it to another category later.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount will be added as an expense in Other. You can move it to another category later.';

  @override
  String settlementNote(String name) => 'Settlement with $name';

  @override
  String settledGroupTitle(String date) => 'Settled $date';

  @override
  String deletePersonTitle(String name) => 'Delete $name?';

  @override
  String editedOn(String date) => 'Edited $date';

  @override
  String wasValues(String values) => 'Was: $values';

  @override
  String personCount(int count) => count == 1 ? '1 person' : '$count people';
}

class AppStringsAr extends AppStrings {
  const AppStringsAr();

  @override
  String get localeName => 'ar';

  @override
  String get appTitle => 'ميزانيتي';

  @override
  String get add => 'إضافة';

  @override
  String get undo => 'تراجع';

  @override
  String get tryAgain => 'إعادة المحاولة';

  @override
  String get nothingRecordedYet => 'لا توجد مصروفات بعد';

  @override
  String get emptyMonthHint =>
      'اضغط "إضافة" لتسجيل أول مصروف أو دخل في هذا الشهر.';

  @override
  String get yourMonths => 'شهورك';

  @override
  String spentIn(String month) => 'الإنفاق في $month';

  /// Arabic counts differently for 1, 2, 3-10 and 11 or more.
  @override
  String expenseCount(int count) => switch (count) {
    0 => 'لا مصروفات',
    1 => 'مصروف واحد',
    2 => 'مصروفان',
    >= 3 && <= 10 => '$count مصروفات',
    _ => '$count مصروفًا',
  };

  @override
  String get quickExpense => 'مصروف سريع';

  @override
  String get expenseSaved => 'تم حفظ المصروف';

  @override
  String get newExpense => 'مصروف جديد';

  @override
  String get editExpense => 'تعديل المصروف';

  @override
  String get when => 'التاريخ';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get pickADate => 'اختر تاريخًا';

  @override
  String get category => 'الفئة';

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get noteHint => 'على ماذا أنفقت؟';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get amountHint => '٠';

  @override
  String get categories => 'الفئات';

  @override
  String get newCategory => 'فئة جديدة';

  @override
  String get editCategory => 'تعديل الفئة';

  @override
  String get addCategory => 'إضافة الفئة';

  @override
  String get categoryName => 'الاسم';

  @override
  String get color => 'اللون';

  @override
  String get icon => 'الأيقونة';

  @override
  String get builtIn => 'أساسية';

  @override
  String get custom => 'مخصصة';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String deleteCategoryTitle(String name) => 'حذف $name؟';

  @override
  String get deleteCategoryBody =>
      'ستُنقل مصروفات هذه الفئة إلى "أخرى". لن يُحذف أي مصروف.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'لغة النظام';

  @override
  String get currency => 'العملة';

  @override
  String get currencySymbol => 'الرمز';

  @override
  String get currencySymbolHint => 'يظهر بجانب كل مبلغ';

  @override
  String get storedOnThisDevice =>
      'تُحفظ مصروفاتك على هذا الجهاز. سجّل الدخول لنسخها احتياطيًا.';

  @override
  String get account => 'الحساب';

  @override
  String get accountOptional => 'الحساب اختياري، ويعمل التطبيق بالكامل بدونه.';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signedIn => 'تم تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get noAccountYet => 'ليس لديك حساب؟ أنشئ حسابًا';

  @override
  String get haveAnAccount => 'لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordRules => '٦ أحرف على الأقل';

  @override
  String get confirmEmail => 'تأكيد البريد';

  @override
  String codeSentTo(String email) =>
      'أرسلنا رمزًا إلى $email. أدخله هنا لإكمال إنشاء حسابك.';

  @override
  String get confirmationCode => 'الرمز';

  @override
  String get confirm => 'تأكيد';

  @override
  String get resendCode => 'إرسال رمز جديد';

  @override
  String get codeResent => 'تم إرسال رمز جديد';

  @override
  String get useDifferentEmail => 'استخدام بريد آخر';

  @override
  String get backupHint =>
      'انسخ مصروفاتك احتياطيًا لتحتفظ بنسخة منها في حسابك. الاستعادة تنقل '
      'هذه النسخة إلى هذا الهاتف دون حذف أي شيء موجود عليه.';

  @override
  String get backUpNow => 'نسخ احتياطي الآن';

  @override
  String get restoreData => 'استعادة';

  @override
  String get backingUp => 'جارٍ النسخ الاحتياطي…';

  @override
  String get restoring => 'جارٍ الاستعادة…';

  @override
  String get backupDone => 'اكتمل النسخ الاحتياطي';

  @override
  String get restoreDone => 'اكتملت الاستعادة';

  @override
  String get neverSynced => 'لم يُنسخ احتياطيًا بعد';

  @override
  String lastSynced(String when) => 'آخر مزامنة: $when';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountTitle => 'حذف حسابك؟';

  @override
  String get deleteAccountBody =>
      'سيؤدي هذا إلى حذف حسابك نهائيًا مع النسخة الاحتياطية لمصروفاتك المحفوظة '
      'فيه، ولا يمكن التراجع عنه. تبقى المصروفات الموجودة على هذا الهاتف كما هي، '
      'ويمكنك الاستمرار في استخدام التطبيق بدون حساب.';

  @override
  String get deletingAccount => 'جارٍ حذف حسابك…';

  @override
  String get accountDeleted => 'تم حذف حسابك';

  @override
  String get home => 'الرئيسية';

  @override
  String get analyses => 'التحليلات';

  @override
  String get vsLastMonth => 'مقارنة بالشهر الماضي';

  @override
  String get noComparison => 'لا بيانات للشهر الماضي';

  @override
  String get dailySpending => 'الإنفاق اليومي';

  @override
  String get dailyAverage => 'المتوسط اليومي';

  @override
  String get topDay => 'أعلى يوم';

  @override
  String get byCategory => 'الإنفاق حسب الفئة';

  @override
  String get noSpendingThisMonth => 'لا مصروفات في هذا الشهر بعد.';

  @override
  String get monthlyTrend => 'آخر ٦ أشهر';

  @override
  String lastMonthTotal(String amount) => 'الشهر الماضي: $amount';

  @override
  String get budgets => 'الميزانيات';

  @override
  String get monthlyBudget => 'الميزانية الشهرية';

  @override
  String get setMonthlyBudget => 'حدّد ميزانية شهرية';

  @override
  String get setBudgetHint =>
      'اعرف كم تبقّى لك، واحصل على تنبيه قبل أن تتجاوز حدّك.';

  @override
  String get setBudget => 'تحديد';

  @override
  String get editBudget => 'تعديل الميزانية';

  @override
  String get removeBudget => 'إزالة';

  @override
  String get save => 'حفظ';

  @override
  String amountLeft(String amount) => 'تبقّى $amount';

  @override
  String amountOver(String amount) => 'تجاوزت الميزانية بمقدار $amount';

  @override
  String spentOfLimit(String spent, String limit) => 'أنفقت $spent من $limit';

  @override
  String amountSpent(String amount) => 'الإنفاق: $amount';

  @override
  String budgetUsed(String percent) => 'استُخدم $percent من الميزانية';

  @override
  String get categoryBudgets => 'ميزانيات الفئات';

  @override
  String get categoryBudgetsHint => 'ضع حدًا لإنفاقك على فئة بعينها.';

  @override
  String categoryBudgetTitle(String name) => 'ميزانية $name';

  @override
  String get setLimit => 'تحديد حد';

  @override
  String get closeToLimit => 'قريبة من حدّها';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'تتكرّر الميزانيات كل شهر. ستصلك تنبيهات عندما يتجاوز إنفاقك $nearing، '
      'ثم عند $reached.';

  @override
  String get budgetAlertTitle => 'تنبيه الميزانية';

  @override
  String get ok => 'حسنًا';

  @override
  String get view => 'عرض';

  @override
  String monthlyBudgetNearing(String percent) =>
      'استخدمت $percent من ميزانيتك الشهرية';

  @override
  String get monthlyBudgetUsedUp => 'استنفدت ميزانيتك الشهرية بالكامل';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'تجاوزت ميزانيتك الشهرية بمقدار $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'استخدمت $percent من ميزانية $name';

  @override
  String categoryBudgetUsedUp(String name) => 'استنفدت ميزانية $name بالكامل';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'تجاوزت ميزانية $name بمقدار $amount';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get dataManagementHint =>
      'ملفات تحتفظ بها بنفسك، تعمل دون إنترنت ولا تحتاج إلى حساب.';

  @override
  String get backUpToFile => 'نسخ بياناتي احتياطيًا';

  @override
  String get backUpToFileHint => 'ملف نسخة احتياطية كامل يمكنك استيراده لاحقًا';

  @override
  String get exportCsv => 'تصدير بصيغة CSV';

  @override
  String get exportCsvHint => 'لبرنامج Excel أو جداول بيانات Google';

  @override
  String get exportPdf => 'تصدير بصيغة PDF';

  @override
  String get exportPdfHint => 'تقرير للقراءة أو الطباعة أو المشاركة';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get importDataHint => 'الاستعادة من ملف نسخة احتياطية';

  @override
  String get preparingFile => 'جارٍ تجهيز الملف…';

  @override
  String get importingData => 'جارٍ الاستيراد…';

  @override
  String get fileSaved => 'تم حفظ الملف';

  @override
  String get importDone => 'اكتمل الاستيراد';

  @override
  String get importNothingNew =>
      'كل ما في النسخة الاحتياطية موجود بالفعل على هذا الهاتف';

  @override
  String get fileReady => 'ملفك جاهز';

  @override
  String get shareFile => 'مشاركة';

  @override
  String get shareFileHint => 'واتساب أو البريد أو Google Drive وغيرها';

  @override
  String get saveToPhone => 'حفظ على هذا الهاتف';

  @override
  String get saveToPhoneHint => 'اختر مكان حفظه';

  @override
  String get importTitle => 'استيراد هذه النسخة الاحتياطية؟';

  @override
  String get importMergeHint =>
      'الدمج يُبقي كل ما على هذا الهاتف ويضيف ما ينقصه. وعند اختلاف سجل ما، يُعتمد التعديل الأحدث.';

  @override
  String get merge => 'دمج';

  @override
  String get replaceEverything => 'استبدال الكل';

  @override
  String get replaceTitle => 'استبدال كل ما على هذا الهاتف؟';

  @override
  String get replaceBody =>
      'سيُحذف كل ما على هذا الهاتف وليس في النسخة الاحتياطية، وتُعتمد نسخة الملف من كل سجل. لا يمكن التراجع عن ذلك.';

  @override
  String get replace => 'استبدال';

  @override
  String get colDate => 'التاريخ';

  @override
  String get colMonth => 'الشهر';

  @override
  String get colAmount => 'المبلغ';

  @override
  String get colNote => 'ملاحظة';

  @override
  String get colId => 'المعرّف';

  @override
  String get colCount => 'عدد المعاملات';

  @override
  String get colTotal => 'الإجمالي';

  @override
  String get colShare => 'النسبة';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get reportTitle => 'ميزانيتي: تقرير المصروفات';

  @override
  String get reportPeriod => 'الفترة';

  @override
  String get reportTotal => 'إجمالي الإنفاق';

  @override
  String get reportMonthlyAverage => 'المتوسط الشهري';

  @override
  String get reportByMonth => 'الإنفاق حسب الشهر';

  @override
  String get reportAllExpenses => 'كل المصروفات';

  @override
  String get reportEmpty => 'لا توجد مصروفات مسجّلة بعد.';

  @override
  String get reportPageTemplate => 'صفحة {page} من {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} و${categoryCount(categories)}'
        : '${expenseCount(expenses)} و${categoryCount(categories)} '
              'و${personCount(people)}';
    return date == null
        ? 'تحتوي هذه النسخة على $contents.'
        : 'نسخة احتياطية بتاريخ $date: $contents.';
  }

  /// Arabic counts differently for 1, 2, 3-10 and 11 or more.
  @override
  String categoryCount(int count) => switch (count) {
    0 => 'لا فئات',
    1 => 'فئة واحدة',
    2 => 'فئتان',
    >= 3 && <= 10 => '$count فئات',
    _ => '$count فئة',
  };

  @override
  String reportGenerated(String when) => 'أُنشئ في $when';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'طعام',
    'cat_transport' => 'مواصلات',
    'cat_bills' => 'فواتير',
    'cat_shopping' => 'تسوّق',
    'cat_health' => 'الصحة واللياقة',
    'cat_entertainment' => 'ترفيه',
    'cat_work' => 'عمل',
    'cat_other' => 'أخرى',
    'cat_salary' => 'الراتب',
    'cat_freelance' => 'عمل حر',
    'cat_investments' => 'استثمارات',
    'cat_gifts' => 'هدايا',
    'cat_income_other' => 'دخل آخر',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => 'تعذّر الحفظ على هذا الجهاز. حاول مرة أخرى.',
    FailureCode.notFound => 'لم يعد هذا العنصر موجودًا.',
    FailureCode.unknown => 'حدث خطأ ما.',
    FailureCode.amountRequired => 'أدخل مبلغًا أكبر من صفر.',
    FailureCode.amountTooLarge => 'هذا المبلغ كبير جدًا.',
    FailureCode.amountInvalid => 'أدخل مبلغًا صحيحًا.',
    FailureCode.categoryRequired => 'اختر فئة.',
    FailureCode.categoryNameRequired => 'أدخل اسمًا للفئة.',
    FailureCode.categoryNameTooLong => 'اجعل الاسم أقل من ٣٠ حرفًا.',
    FailureCode.categoryProtected => 'لا يمكن حذف هذه الفئة.',
    FailureCode.currencySymbolInvalid => 'استخدم من رمز إلى ٤ رموز.',
    FailureCode.network => 'تعذّر الاتصال. تحقّق من الإنترنت وحاول مرة أخرى.',
    FailureCode.emailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا.',
    FailureCode.passwordTooShort => 'استخدم ٦ أحرف على الأقل لكلمة المرور.',
    FailureCode.invalidCredentials => 'البريد أو كلمة المرور غير صحيحة.',
    FailureCode.emailTaken => 'يوجد حساب بهذا البريد بالفعل.',
    FailureCode.emailNotConfirmed => 'أكّد بريدك أولًا بالرمز الذي أرسلناه لك.',
    FailureCode.codeInvalid => 'الرمز غير صحيح أو انتهت صلاحيته.',
    FailureCode.signInRequired => 'سجّل الدخول مرة أخرى، ثم حاول من جديد.',
    FailureCode.syncOtherAccount => 'بيانات هذا الهاتف مرتبطة بحساب آخر.',
    FailureCode.syncFailed => 'تعذّرت المزامنة مع حسابك. حاول مرة أخرى.',
    FailureCode.accountDeletionFailed => 'تعذّر حذف حسابك. حاول مرة أخرى.',
    FailureCode.backupNotRecognized =>
      'هذا الملف ليس نسخة احتياطية من ميزانيتي.',
    FailureCode.backupTooNew =>
      'هذه النسخة من إصدار أحدث من ميزانيتي. حدّث التطبيق ثم حاول مرة أخرى.',
    FailureCode.backupDamaged =>
      'ملف النسخة الاحتياطية تالف، لذلك لم يُستورد أي شيء.',
    FailureCode.fileUnavailable =>
      'تعذّر فتح هذا الملف. حاول اختياره مرة أخرى.',
    FailureCode.storageFull => 'لا توجد مساحة كافية على هذا الهاتف.',
    FailureCode.exportFailed => 'تعذّر إنشاء الملف. حاول مرة أخرى.',
    FailureCode.shareUnavailable => 'تعذّر فتح قائمة المشاركة.',
    FailureCode.saveFailed => 'تعذّر حفظ الملف. حاول مرة أخرى.',
    FailureCode.tooManyAttempts =>
      'محاولات كثيرة. انتظر قليلًا ثم حاول مرة أخرى.',
    FailureCode.titleRequired => 'أدخل اسمًا.',
    FailureCode.titleTooLong => 'اجعل الاسم أقل من ٤٠ حرفًا.',
    FailureCode.dueDayInvalid => 'اختر موعد الاستحقاق.',
    FailureCode.alreadyPaid => 'هذه الدفعة مسجّلة بالفعل.',
    FailureCode.personRequired => 'اختر شخصًا.',
    FailureCode.personNameRequired => 'أدخل اسمًا.',
    FailureCode.personNameTooLong => 'اجعل الاسم أقل من ٤٠ حرفًا.',
    FailureCode.phoneInvalid => 'أدخل رقم هاتف صحيحًا.',
    FailureCode.transactionSettled =>
      'لا يمكن تعديل المعاملات التي تمت تسويتها.',
    FailureCode.nothingToSettle => 'لا يوجد ما تتم تسويته.',
    FailureCode.settlementAlreadyLogged =>
      'هذه التسوية مسجّلة في ميزانيتك بالفعل.',
  };

  @override
  String get expenseDeleted => 'تم حذف المصروف';

  @override
  String get expenseRestored => 'تمت استعادة المصروف';

  @override
  String categoryAdded(String name) => 'تمت إضافة $name';

  @override
  String get categoryUpdated => 'تم تحديث الفئة';

  @override
  String categoryDeleted(String name) => 'تم حذف $name';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      'تم حذف $name — نُقل ${expenseCount(count)} إلى "أخرى"';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      'تم حذف $name — نُقلت ${transactionCount(count)} إلى "دخل آخر"';

  @override
  String get expense => 'مصروف';

  @override
  String get income => 'دخل';

  @override
  String get transactionType => 'مصروف أو دخل';

  @override
  String get quickIncome => 'دخل سريع';

  @override
  String get newIncome => 'دخل جديد';

  @override
  String get editIncome => 'تعديل الدخل';

  @override
  String get addIncome => 'إضافة دخل';

  @override
  String get incomeNoteHint => 'من أين جاء؟';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpenses => 'إجمالي المصروفات';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get savingsRateNoIncome => 'أضف دخلك لمعرفة معدل الادخار';

  @override
  String get expenseCategories => 'فئات المصروفات';

  @override
  String get incomeCategories => 'فئات الدخل';

  @override
  String get deleteIncomeCategoryBody =>
      'سيُنقل الدخل في هذه الفئة إلى "دخل آخر". لن يُحذف أي شيء.';

  @override
  String get incomeDeleted => 'تم حذف الدخل';

  @override
  String get incomeRestored => 'تمت استعادة الدخل';

  @override
  String get colType => 'النوع';

  /// Arabic counts differently for 1, 2, 3-10 and 11 or more.
  @override
  String transactionCount(int count) => switch (count) {
    0 => 'لا معاملات',
    1 => 'معاملة واحدة',
    2 => 'معاملتان',
    >= 3 && <= 10 => '$count معاملات',
    _ => '$count معاملة',
  };

  @override
  String get recurringPayments => 'المدفوعات المتكررة';

  @override
  String get newRecurring => 'دفعة متكررة جديدة';

  @override
  String get editRecurring => 'تعديل الدفعة المتكررة';

  @override
  String get addRecurring => 'إضافة الدفعة';

  @override
  String get recurringTitle => 'الاسم';

  @override
  String get recurringTitleHint => 'الإيجار، نتفليكس، النادي…';

  @override
  String get amount => 'المبلغ';

  @override
  String get repeats => 'التكرار';

  @override
  String get weekly => 'أسبوعيًا';

  @override
  String get monthly => 'شهريًا';

  @override
  String get yearly => 'سنويًا';

  @override
  String get dueOn => 'موعد الاستحقاق';

  @override
  String get dueDayOfMonth => 'يوم الشهر';

  @override
  String get dueMonthLabel => 'الشهر';

  @override
  String get dueDayLabel => 'اليوم';

  @override
  String get shortMonthHint => 'في الأشهر الأقصر تُستحق في آخر يوم منها.';

  @override
  String get whenDue => 'عند الاستحقاق';

  @override
  String get autoDeduct => 'خصم تلقائي';

  @override
  String get remindMe => 'ذكّرني';

  @override
  String get autoDeductHint => 'تُسجَّل كمصروف تلقائيًا في موعد استحقاقها.';

  @override
  String get remindMeHint => 'سيُطلب منك تأكيد كل دفعة قبل تسجيلها.';

  @override
  String get statusPaid => 'مدفوعة';

  @override
  String get statusUpcoming => 'قادمة';

  @override
  String get statusOverdue => 'متأخرة';

  @override
  String get markAsPaid => 'تأكيد الدفع';

  @override
  String get dueToday => 'مستحقة اليوم';

  @override
  String dueOnDate(String date) => 'تُستحق في $date';

  @override
  String nextDueOn(String date) => 'القادمة في $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'كانت مستحقة في $date'
      : '${paymentCount(count)} متأخرة منذ $date';

  @override
  String everyWeekday(String weekday) => 'كل $weekday';

  @override
  String monthlyOnDay(String day) => 'شهريًا في يوم $day';

  @override
  String yearlyOn(String date) => 'سنويًا في $date';

  @override
  String get monthlyAverage => 'كل شهر';

  @override
  String get monthlyAverageHint => 'متوسط كل مدفوعاتك المتكررة';

  @override
  String get noRecurringYet => 'لا توجد مدفوعات متكررة بعد';

  @override
  String get noRecurringHint =>
      'أضف الإيجار والفواتير والاشتراكات مرة واحدة، وسترى كل شهر ما دُفع '
      'وما زال مستحقًا.';

  @override
  String get paymentsToConfirm => 'مدفوعات بانتظار التأكيد';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get deleteRecurringBody =>
      'سيتوقف تكرارها، وتبقى الدفعات المسجّلة سابقًا ضمن معاملاتك.';

  @override
  String recurringPaid(String name) => 'تم تسجيل دفع $name';

  @override
  String get recurringPaymentUndone => 'أُلغيت الدفعة';

  @override
  String recurringAutoLogged(int count) => count == 1
      ? 'سُجّلت دفعة متكررة تلقائيًا'
      : 'سُجّلت ${paymentCount(count)} متكررة تلقائيًا';

  /// Arabic counts differently for 1, 2, 3-10 and 11 or more.
  @override
  String paymentCount(int count) => switch (count) {
    0 => 'لا دفعات',
    1 => 'دفعة واحدة',
    2 => 'دفعتان',
    >= 3 && <= 10 => '$count دفعات',
    _ => '$count دفعة',
  };

  @override
  String get colPaidThrough => 'مدفوعة حتى';

  // People & debts

  @override
  String get people => 'الأشخاص';

  @override
  String get peopleAndDebts => 'الأشخاص والتسويات';

  @override
  String get person => 'الشخص';

  @override
  String get personName => 'الاسم';

  @override
  String get phone => 'الهاتف';

  @override
  String get phoneOptional => 'الهاتف (اختياري)';

  @override
  String get balance => 'الرصيد';

  @override
  String get colStatus => 'الحالة';

  @override
  String get owesYou => 'مدين لك';

  @override
  String get youOwe => 'أنت مدين';

  @override
  String get owedToYou => 'مستحق لك';

  @override
  String get settledUp => 'تمت التسوية';

  @override
  String get iPaidForThem => 'دفعتُ عنه';

  @override
  String get theyPaidForMe => 'دفع عنّي';

  @override
  String get theyPaidYou => 'دفع لك';

  @override
  String get youPaidThem => 'دفعتَ له';

  @override
  String get openStatus => 'مفتوحة';

  @override
  String get settledStatus => 'تمت تسويتها';

  @override
  String get settledOn => 'تاريخ التسوية';

  @override
  String get createdOn => 'تاريخ الإنشاء';

  @override
  String get lastEdited => 'آخر تعديل';

  @override
  String get colEdits => 'التعديلات';

  @override
  String get activeTransactions => 'المعاملات الحالية';

  @override
  String get settledHistory => 'سجل التسويات';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterOwedToMe => 'مستحق لي';

  @override
  String get filterIOwe => 'عليّ';

  @override
  String get filterSettled => 'تمت تسويتهم';

  @override
  String get addPerson => 'إضافة شخص';

  @override
  String get addPersonHint => 'شخص تتقاسم معه المصاريف';

  @override
  String get newPerson => 'شخص جديد';

  @override
  String get editPerson => 'تعديل الشخص';

  @override
  String get deletePerson => 'حذف الشخص';

  @override
  String get quickTransaction => 'معاملة سريعة';

  @override
  String get quickTransactionHint => 'سجّل من دفع مع شخص أضفته';

  @override
  String get noPeopleYet => 'لا يوجد أشخاص بعد';

  @override
  String get noPeopleHint =>
      'أضف الأشخاص الذين تتقاسم معهم المصاريف لتعرف من المدين لمن.';

  @override
  String get nobodyHere => 'لا أحد يطابق هذا الاختيار.';

  @override
  String get addPersonFirst => 'أضف شخصًا أولًا.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get editTransaction => 'تعديل المعاملة';

  @override
  String get transactionDetails => 'تفاصيل المعاملة';

  @override
  String get debtNoteHint => 'مقابل ماذا؟';

  @override
  String get changeHistory => 'سجل التعديلات';

  @override
  String get edited => 'معدّلة';

  @override
  String get settleUp => 'تسوية';

  @override
  String get settle => 'تسوية';

  @override
  String get noDebtsYet => 'لا شيء مسجّل بعد';

  @override
  String get noDebtsHint => 'أضف ما دفعته عنه، أو ما دفعه عنك.';

  @override
  String get settleEven =>
      'هذه المعاملات يلغي بعضها بعضًا، فلا حاجة لدفع أي مبلغ.';

  @override
  String get logSettlementTitle => 'تسجيل هذه التسوية في ميزانيتك الشهرية؟';

  @override
  String get loggedInBudget => 'في ميزانيتك';

  @override
  String get deleteTransactionTitle => 'حذف هذه المعاملة؟';

  @override
  String get deleteTransactionBody => 'ستُحذف من الرصيد مع هذا الشخص.';

  @override
  String get deletePersonBody =>
      'ستُحذف معاملاته وسجل تسوياته أيضًا. ما سجّلته في ميزانيتك يبقى كما هو.';

  @override
  String get settledLocked => 'تمت تسويتها، فلا يمكن تعديلها بعد الآن.';

  @override
  String get personUpdated => 'تم تحديث بيانات الشخص';

  @override
  String get debtDeleted => 'تم حذف المعاملة';

  @override
  String get settledUpNotice => 'تمت التسوية بالكامل';

  @override
  String get settlementLogged => 'أُضيفت إلى ميزانيتك';

  @override
  String personOwesYou(String name) => '$name مدين لك';

  @override
  String youOwePerson(String name) => 'أنت مدين لـ$name';

  @override
  String settledWith(String name) => 'لا ديون بينك وبين $name';

  @override
  String settleUpFor(String amount) => 'تسوية $amount';

  @override
  String settleTitle(String name) => 'تسوية الحساب مع $name؟';

  @override
  String settleTheyPay(String name, String amount) =>
      'يدفع لك $name مبلغ $amount لتسوية كل شيء.';

  @override
  String settleYouPay(String name, String amount) =>
      'تدفع لـ$name مبلغ $amount لتسوية كل شيء.';

  @override
  String settleMoves(int count) =>
      'ستنتقل ${transactionCount(count)} إلى سجل التسويات.';

  @override
  String logSettlementIncome(String amount) =>
      'سيُضاف $amount كدخل في "دخل آخر". يمكنك نقله إلى فئة أخرى لاحقًا.';

  @override
  String logSettlementExpense(String amount) =>
      'سيُضاف $amount كمصروف في "أخرى". يمكنك نقله إلى فئة أخرى لاحقًا.';

  @override
  String settlementNote(String name) => 'تسوية مع $name';

  @override
  String settledGroupTitle(String date) => 'تمت التسوية في $date';

  @override
  String deletePersonTitle(String name) => 'حذف $name؟';

  @override
  String editedOn(String date) => 'عُدّلت في $date';

  @override
  String wasValues(String values) => 'كانت: $values';

  /// Arabic counts differently for 1, 2, 3-10 and 11 or more.
  @override
  String personCount(int count) => switch (count) {
    0 => 'لا أشخاص',
    1 => 'شخص واحد',
    2 => 'شخصان',
    >= 3 && <= 10 => '$count أشخاص',
    _ => '$count شخصًا',
  };
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture(AppStrings.forLanguageCode(locale.languageCode));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}

extension AppStringsX on BuildContext {
  /// Shorthand for `AppStrings.of(context)`.
  AppStrings get strings => AppStrings.of(this);
}
