import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart';

import '../../features/recurring/domain/entities/recurrence_frequency.dart';
import '../../features/settings/domain/entities/app_settings.dart';
import '../error/failures.dart';
import '../utils/app_formats.dart';
import '../utils/ui_notice.dart';
import 'strings/app_strings_ar.dart';
import 'strings/app_strings_de.dart';
import 'strings/app_strings_en.dart';
import 'strings/app_strings_es.dart';
import 'strings/app_strings_fa.dart';
import 'strings/app_strings_fr.dart';
import 'strings/app_strings_id.dart';
import 'strings/app_strings_it.dart';
import 'strings/app_strings_ja.dart';
import 'strings/app_strings_ko.dart';
import 'strings/app_strings_ms.dart';
import 'strings/app_strings_nl.dart';
import 'strings/app_strings_pl.dart';
import 'strings/app_strings_pt.dart';
import 'strings/app_strings_ru.dart';
import 'strings/app_strings_tr.dart';
import 'strings/app_strings_uk.dart';
import 'strings/app_strings_ur.dart';
import 'strings/app_strings_vi.dart';
import 'strings/app_strings_zh.dart';

export 'strings/app_strings_ar.dart';
export 'strings/app_strings_de.dart';
export 'strings/app_strings_en.dart';
export 'strings/app_strings_es.dart';
export 'strings/app_strings_fa.dart';
export 'strings/app_strings_fr.dart';
export 'strings/app_strings_id.dart';
export 'strings/app_strings_it.dart';
export 'strings/app_strings_ja.dart';
export 'strings/app_strings_ko.dart';
export 'strings/app_strings_ms.dart';
export 'strings/app_strings_nl.dart';
export 'strings/app_strings_pl.dart';
export 'strings/app_strings_pt.dart';
export 'strings/app_strings_ru.dart';
export 'strings/app_strings_tr.dart';
export 'strings/app_strings_uk.dart';
export 'strings/app_strings_ur.dart';
export 'strings/app_strings_vi.dart';
export 'strings/app_strings_zh.dart';

/// Hand-written localizations — no code generation, no build_runner.
///
/// Each language is one complete subclass in `strings/`, so the analyzer
/// flags any string a language is missing. Add a language by writing one more
/// subclass, adding it to [AppLanguage] and to [forLanguageCode].
abstract class AppStrings {
  const AppStrings();

  static final List<Locale> supportedLocales = [
    for (final language in AppLanguage.translated)
      Locale(language.languageCode!),
  ];

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings) ?? const AppStringsEn();

  /// Resolves a language code the same way the delegate does. Anything the app
  /// does not translate falls back to English.
  static AppStrings forLanguageCode(String? languageCode) =>
      switch (AppLanguage.fromCode(languageCode)) {
        AppLanguage.arabic => const AppStringsAr(),
        AppLanguage.french => const AppStringsFr(),
        AppLanguage.spanish => const AppStringsEs(),
        AppLanguage.german => const AppStringsDe(),
        AppLanguage.portuguese => const AppStringsPt(),
        AppLanguage.italian => const AppStringsIt(),
        AppLanguage.dutch => const AppStringsNl(),
        AppLanguage.russian => const AppStringsRu(),
        AppLanguage.ukrainian => const AppStringsUk(),
        AppLanguage.polish => const AppStringsPl(),
        AppLanguage.turkish => const AppStringsTr(),
        AppLanguage.indonesian => const AppStringsId(),
        AppLanguage.malay => const AppStringsMs(),
        AppLanguage.vietnamese => const AppStringsVi(),
        AppLanguage.chinese => const AppStringsZh(),
        AppLanguage.japanese => const AppStringsJa(),
        AppLanguage.korean => const AppStringsKo(),
        AppLanguage.persian => const AppStringsFa(),
        AppLanguage.urdu => const AppStringsUr(),
        _ => const AppStringsEn(),
      };

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

  // Daily reminder
  String get reminders;
  String get dailyReminder;
  String get dailyReminderHint;
  String get reminderTime;
  String get notificationsBlocked;
  String get reminderNotificationTitle;
  String get reminderNotificationBody;
  String get security;
  String get appLock;
  String get appLockHint;
  String get appLockUnavailable;
  String get unlock;
  String get unlockToContinue;
  String get confirmItsYou;

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
  String get forgotPassword;
  String get resetPassword;
  String resetCodeSentTo(String email);
  String get newPassword;
  String get saveNewPassword;
  String get backToSignIn;

  // Backup
  String get backupHint;
  String get backUpNow;
  String get autoBackup;
  String get autoBackupHint;
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

  // Importing another app's data through an AI chat
  String get importFromAi;
  String get importFromAiHint;
  String get aiImportTitle;
  String get aiImportIntro;
  String get aiImportStep1;
  String get aiImportStep2;
  String get aiImportStep3;
  String get copyPrompt;
  String get pasteAnswer;
  String get chooseFile;
  String get aiImportPrivacy;
  String get promptCopied;
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
    NoticeCode.recurringReceived => recurringReceived(notice.name ?? ''),
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
  String get search;
  String get searchHint;
  String get searchPrompt;
  String get noSearchResults;
  String get allTypes;
  String get anyCategory;
  String get anyDate;
  String get clearFilters;
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
  String recurringReceived(String name);
  String get statusReceived;
  String get markAsReceived;
  String get autoAdd;
  String get autoAddHint;
  String get monthlyIncomeAverage;
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

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLanguage.fromCode(locale.languageCode) != null;

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
