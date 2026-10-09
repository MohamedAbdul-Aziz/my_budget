import '../../error/failures.dart';
import '../app_strings.dart';

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
  String get reminders => 'Reminders';

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get dailyReminderHint => 'A nudge to log what you spent today';

  @override
  String get reminderTime => 'Time';

  @override
  String get notificationsBlocked =>
      "Notifications are off for this app. Allow them in your phone's settings.";

  @override
  String get reminderNotificationTitle => "Log today's spending";

  @override
  String get reminderNotificationBody =>
      'Take a moment to add what you spent today.';

  @override
  String get security => 'Security';

  @override
  String get appLock => 'App lock';

  @override
  String get appLockHint =>
      'Ask for your fingerprint, face or screen lock when the app opens';

  @override
  String get appLockUnavailable =>
      'Set up a screen lock on this phone to use this';

  @override
  String get unlock => 'Unlock';

  @override
  String get unlockToContinue => 'Unlock to see your budget';

  @override
  String get confirmItsYou => "Confirm it's you to change the app lock";

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
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPassword => 'Reset password';

  @override
  String resetCodeSentTo(String email) =>
      'We sent a code to $email. Enter it with a new password for your account.';

  @override
  String get newPassword => 'New password';

  @override
  String get saveNewPassword => 'Save new password';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get backupHint =>
      'Back up to keep a copy of your expenses in your account. Restore '
      'brings that copy to this phone without removing anything already here.';

  @override
  String get backUpNow => 'Back up now';

  @override
  String get autoBackup => 'Back up automatically';

  @override
  String get autoBackupHint =>
      'Whenever you leave the app, new changes are backed up to your account.';

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
    FailureCode.pastedNotRecognized =>
      "The pasted text isn't data My Budget can read. Copy the AI's whole answer and try again, or ask the AI to fix it.",
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
  String get search => 'Search';

  @override
  String get searchHint => 'Search notes or amounts';

  @override
  String get searchPrompt =>
      'Find any transaction by its note or amount, or filter by type, category and date.';

  @override
  String get noSearchResults => 'No transactions match';

  @override
  String get allTypes => 'All';

  @override
  String get anyCategory => 'Any category';

  @override
  String get anyDate => 'Any date';

  @override
  String get clearFilters => 'Clear filters';

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
  String recurringReceived(String name) => '$name marked as received';

  @override
  String get statusReceived => 'Received';

  @override
  String get markAsReceived => 'Mark as received';

  @override
  String get autoAdd => 'Auto-add';

  @override
  String get autoAddHint => 'Logged as income automatically on the due date.';

  @override
  String get monthlyIncomeAverage => 'Income each month';

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

  @override
  String get importFromAi => 'From another app';

  @override
  String get importFromAiHint =>
      'Convert your data with ChatGPT, Gemini, Claude or any AI';

  @override
  String get aiImportTitle => 'Import from another app';

  @override
  String get aiImportIntro =>
      'An AI chat can turn data from another app or a spreadsheet into a file My Budget can import.';

  @override
  String get aiImportStep1 => 'Copy the prompt.';

  @override
  String get aiImportStep2 =>
      'Paste it into ChatGPT, Gemini, Claude or any AI, then attach or paste your data.';

  @override
  String get aiImportStep3 =>
      'Copy the AI’s answer and paste it here, or save it as a file and choose it.';

  @override
  String get copyPrompt => 'Copy prompt';

  @override
  String get pasteAnswer => 'Paste answer';

  @override
  String get chooseFile => 'Choose file';

  @override
  String get aiImportPrivacy =>
      'Your data goes to the AI service you choose. You will see what will be imported before anything changes.';

  @override
  String get promptCopied => 'Prompt copied';

  @override
  String get askTitle => 'Ask about your spending';

  @override
  String get askHint => 'Tap a question to see the answer.';

  @override
  String get askCompareMonths => 'Compare months';

  @override
  String get askTopCategory => 'Top category';

  @override
  String get askVsLastMonth => 'vs last month';

  @override
  String get askBiggestExpense => 'Biggest expense';

  @override
  String get askTopDay => 'Priciest day';

  @override
  String get askWeekday => 'Busiest weekday';

  @override
  String get askMonthEnd => 'Month-end estimate';

  @override
  String get askSaved => 'Did I save?';

  @override
  String get askBudgetLeft => 'Budget left';

  @override
  String get askHighestLowest => 'Highest & lowest month';

  @override
  String get askCount => 'How many expenses';

  @override
  String get askTopIncome => 'Top income';

  @override
  String get otherCategories => 'Others';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'Most went to $category: $amount ($percent of the month).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'You spent $amount more in $month than in $other (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'You spent $amount less in $month than in $other (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'You spent the same in $month and $other.';

  @override
  String answerNothingIn(String month) => 'Nothing was spent in $month.';

  @override
  String answerRise(String category, String amount) =>
      'Biggest rise: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Biggest drop: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Biggest expense: $amount in $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Priciest day: $date, with $amount spent.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Busiest weekday: $weekday ($amount this month).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'At this pace (about $average a day) you will spend around $amount by the end of the month.';

  @override
  String answerMonthTotal(String amount) =>
      'This month is over: you spent $amount in total.';

  @override
  String answerSaved(String amount, String income) =>
      'You saved $amount of the $income you earned.';

  @override
  String answerOverspent(String amount) =>
      'You spent $amount more than you earned.';

  @override
  String get answerNoIncome => 'No income recorded this month.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      '$amount left in your monthly budget ($percent used).';

  @override
  String answerBudgetOver(String amount) =>
      'You are $amount over your monthly budget.';

  @override
  String get answerNoBudget => 'You have not set a monthly budget yet.';

  @override
  String answerOverLimit(String names) => 'Over their limit: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'Highest month: $high ($highAmount). Lowest: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'You logged ${expenseCount(count)}, $average each on average.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'Most income came from $category: $amount ($percent).';
}
