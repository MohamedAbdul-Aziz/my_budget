import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsUr extends AppStrings {
  const AppStringsUr();

  @override
  String get localeName => 'ur';

  @override
  String get appTitle => 'میرا بجٹ';

  @override
  String get add => 'شامل کریں';

  @override
  String get undo => 'واپس لیں';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get nothingRecordedYet => 'ابھی تک کچھ درج نہیں';

  @override
  String get emptyMonthHint =>
      'اس مہینے کا پہلا خرچ یا آمدنی درج کرنے کے لیے "شامل کریں" پر ٹیپ کریں۔';

  @override
  String get yourMonths => 'آپ کے مہینے';

  @override
  String spentIn(String month) => '$month میں خرچ';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count خرچ',
    other: '$count اخراجات',
  );

  @override
  String get quickExpense => 'فوری خرچ';

  @override
  String get expenseSaved => 'خرچ محفوظ ہو گیا';

  @override
  String get newExpense => 'نیا خرچ';

  @override
  String get editExpense => 'خرچ میں ترمیم';

  @override
  String get when => 'کب';

  @override
  String get today => 'آج';

  @override
  String get yesterday => 'کل';

  @override
  String get pickADate => 'تاریخ منتخب کریں';

  @override
  String get category => 'زمرہ';

  @override
  String get noteOptional => 'نوٹ (اختیاری)';

  @override
  String get noteHint => 'یہ کس لیے تھا؟';

  @override
  String get addExpense => 'خرچ شامل کریں';

  @override
  String get saveChanges => 'تبدیلیاں محفوظ کریں';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'زمرے';

  @override
  String get newCategory => 'نیا زمرہ';

  @override
  String get editCategory => 'زمرے میں ترمیم';

  @override
  String get addCategory => 'زمرہ شامل کریں';

  @override
  String get categoryName => 'نام';

  @override
  String get color => 'رنگ';

  @override
  String get icon => 'آئیکن';

  @override
  String get builtIn => 'پہلے سے موجود';

  @override
  String get custom => 'اپنا';

  @override
  String get edit => 'ترمیم';

  @override
  String get delete => 'حذف کریں';

  @override
  String get cancel => 'منسوخ';

  @override
  String deleteCategoryTitle(String name) => '"$name" حذف کریں؟';

  @override
  String get deleteCategoryBody =>
      'اس زمرے کے اخراجات "دیگر" میں منتقل ہو جائیں گے۔ کچھ بھی حذف نہیں ہوگا۔';

  @override
  String get settings => 'ترتیبات';

  @override
  String get appearance => 'ظاہری شکل';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get themeLight => 'ہلکا';

  @override
  String get themeDark => 'گہرا';

  @override
  String get language => 'زبان';

  @override
  String get languageSystem => 'سسٹم';

  @override
  String get currency => 'کرنسی';

  @override
  String get currencySymbol => 'علامت';

  @override
  String get currencySymbolHint => 'ہر رقم کے ساتھ دکھائی جاتی ہے';

  @override
  String get storedOnThisDevice =>
      'آپ کے اخراجات اسی ڈیوائس پر محفوظ ہیں۔ بیک اپ کے لیے سائن ان کریں۔';

  @override
  String get account => 'اکاؤنٹ';

  @override
  String get accountOptional =>
      'اکاؤنٹ اختیاری ہے۔ ایپ اکاؤنٹ کے بغیر بھی پوری طرح کام کرتی ہے۔';

  @override
  String get signIn => 'سائن ان';

  @override
  String get signOut => 'سائن آؤٹ';

  @override
  String get signedIn => 'سائن ان ہیں';

  @override
  String get createAccount => 'اکاؤنٹ بنائیں';

  @override
  String get noAccountYet => 'اکاؤنٹ نہیں ہے؟ بنائیں';

  @override
  String get haveAnAccount => 'پہلے سے اکاؤنٹ ہے؟ سائن ان کریں';

  @override
  String get email => 'ای میل';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get passwordRules => 'کم از کم 6 حروف';

  @override
  String get confirmEmail => 'اپنی ای میل کی تصدیق کریں';

  @override
  String codeSentTo(String email) =>
      'ہم نے $email پر ایک کوڈ بھیجا ہے۔ اکاؤنٹ مکمل کرنے کے لیے اسے نیچے درج '
      'کریں۔';

  @override
  String get confirmationCode => 'کوڈ';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String get resendCode => 'نیا کوڈ بھیجیں';

  @override
  String get codeResent => 'نیا کوڈ بھیج دیا گیا';

  @override
  String get useDifferentEmail => 'دوسری ای میل استعمال کریں';

  @override
  String get backupHint =>
      'بیک اپ لینے سے آپ کے اخراجات کی ایک کاپی آپ کے اکاؤنٹ میں رہتی ہے۔ '
      'بحالی اس کاپی کو اس فون پر لاتی ہے، یہاں موجود کچھ بھی ہٹائے بغیر۔';

  @override
  String get backUpNow => 'ابھی بیک اپ لیں';

  @override
  String get restoreData => 'بحال کریں';

  @override
  String get backingUp => 'بیک اپ ہو رہا ہے…';

  @override
  String get restoring => 'بحالی جاری ہے…';

  @override
  String get backupDone => 'بیک اپ مکمل';

  @override
  String get restoreDone => 'بحالی مکمل';

  @override
  String get neverSynced => 'ابھی بیک اپ نہیں لیا گیا';

  @override
  String lastSynced(String when) => 'آخری ہم آہنگی: $when';

  @override
  String get deleteAccount => 'اکاؤنٹ حذف کریں';

  @override
  String get deleteAccountTitle => 'اپنا اکاؤنٹ حذف کریں؟';

  @override
  String get deleteAccountBody =>
      'اس سے آپ کا اکاؤنٹ اور اس میں محفوظ اخراجات کا بیک اپ ہمیشہ کے لیے حذف '
      'ہو جائے گا۔ اسے واپس نہیں لیا جا سکتا۔ اس فون کے اخراجات یہیں رہیں گے، '
      'اور آپ اکاؤنٹ کے بغیر ایپ استعمال کرتے رہ سکتے ہیں۔';

  @override
  String get deletingAccount => 'اکاؤنٹ حذف ہو رہا ہے…';

  @override
  String get accountDeleted => 'آپ کا اکاؤنٹ حذف ہو گیا';

  @override
  String get home => 'ہوم';

  @override
  String get analyses => 'تجزیہ';

  @override
  String get vsLastMonth => 'پچھلے مہینے کے مقابلے میں';

  @override
  String get noComparison => 'پچھلے مہینے کا ڈیٹا نہیں';

  @override
  String get dailySpending => 'روزانہ خرچ';

  @override
  String get dailyAverage => 'روزانہ اوسط';

  @override
  String get topDay => 'سب سے زیادہ خرچ والا دن';

  @override
  String get byCategory => 'زمرے کے لحاظ سے خرچ';

  @override
  String get noSpendingThisMonth => 'اس مہینے ابھی کوئی خرچ نہیں۔';

  @override
  String get monthlyTrend => 'پچھلے 6 مہینے';

  @override
  String lastMonthTotal(String amount) => 'پچھلا مہینہ: $amount';

  @override
  String get budgets => 'بجٹ';

  @override
  String get monthlyBudget => 'ماہانہ بجٹ';

  @override
  String get setMonthlyBudget => 'ماہانہ بجٹ مقرر کریں';

  @override
  String get setBudgetHint =>
      'دیکھیں کتنا بچا ہے، اور زیادہ خرچ سے پہلے اطلاع پائیں۔';

  @override
  String get setBudget => 'مقرر کریں';

  @override
  String get editBudget => 'بجٹ میں ترمیم';

  @override
  String get removeBudget => 'ہٹائیں';

  @override
  String get save => 'محفوظ کریں';

  @override
  String amountLeft(String amount) => '$amount باقی';

  @override
  String amountOver(String amount) => 'بجٹ سے $amount زیادہ';

  @override
  String spentOfLimit(String spent, String limit) => '$limit میں سے $spent خرچ';

  @override
  String amountSpent(String amount) => '$amount خرچ';

  @override
  String budgetUsed(String percent) => 'بجٹ کا $percent استعمال ہوا';

  @override
  String get categoryBudgets => 'زمروں کا بجٹ';

  @override
  String get categoryBudgetsHint => 'کسی ایک زمرے پر خرچ کی حد مقرر کریں۔';

  @override
  String categoryBudgetTitle(String name) => '$name کا بجٹ';

  @override
  String get setLimit => 'حد مقرر کریں';

  @override
  String get closeToLimit => 'حد کے قریب';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'بجٹ ہر مہینے دہرایا جاتا ہے۔ خرچ $nearing سے بڑھنے پر اور پھر $reached '
      'پر آپ کو اطلاع ملے گی۔';

  @override
  String get budgetAlertTitle => 'بجٹ الرٹ';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get view => 'دیکھیں';

  @override
  String monthlyBudgetNearing(String percent) =>
      'آپ نے ماہانہ بجٹ کا $percent استعمال کر لیا';

  @override
  String get monthlyBudgetUsedUp => 'آپ نے پورا ماہانہ بجٹ استعمال کر لیا';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'آپ ماہانہ بجٹ سے $amount آگے ہیں';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'آپ نے $name کے بجٹ کا $percent استعمال کر لیا';

  @override
  String categoryBudgetUsedUp(String name) =>
      'آپ نے $name کا پورا بجٹ استعمال کر لیا';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'آپ $name کے بجٹ سے $amount آگے ہیں';

  @override
  String get dataManagement => 'ڈیٹا کا انتظام';

  @override
  String get dataManagementHint =>
      'فائلیں جو آپ خود رکھتے ہیں۔ یہ آف لائن اور اکاؤنٹ کے بغیر کام کرتی ہیں۔';

  @override
  String get backUpToFile => 'میرے ڈیٹا کا بیک اپ';

  @override
  String get backUpToFileHint =>
      'مکمل بیک اپ فائل جسے آپ بعد میں امپورٹ کر سکتے ہیں';

  @override
  String get exportCsv => 'CSV میں ایکسپورٹ';

  @override
  String get exportCsvHint => 'Excel یا Google Sheets کے لیے';

  @override
  String get exportPdf => 'PDF میں ایکسپورٹ';

  @override
  String get exportPdfHint => 'پڑھنے، پرنٹ کرنے یا شیئر کرنے کے لیے رپورٹ';

  @override
  String get importData => 'ڈیٹا امپورٹ کریں';

  @override
  String get importDataHint => 'بیک اپ فائل سے بحال کریں';

  @override
  String get preparingFile => 'فائل تیار ہو رہی ہے…';

  @override
  String get importingData => 'امپورٹ ہو رہا ہے…';

  @override
  String get fileSaved => 'فائل محفوظ ہو گئی';

  @override
  String get importDone => 'امپورٹ مکمل';

  @override
  String get importNothingNew => 'اس فون پر بیک اپ کی ہر چیز پہلے سے موجود تھی';

  @override
  String get fileReady => 'آپ کی فائل تیار ہے';

  @override
  String get shareFile => 'شیئر کریں';

  @override
  String get shareFileHint => 'واٹس ایپ، ای میل، گوگل ڈرائیو اور مزید';

  @override
  String get saveToPhone => 'اس فون پر محفوظ کریں';

  @override
  String get saveToPhoneHint => 'منتخب کریں کہاں رکھنا ہے';

  @override
  String get importTitle => 'یہ بیک اپ امپورٹ کریں؟';

  @override
  String get importMergeHint =>
      'ضم کرنا اس فون کی ہر چیز رکھتا ہے اور جو کمی ہو وہ شامل کرتا ہے۔ اگر کوئی '
      'ریکارڈ مختلف ہو تو نئی تبدیلی لاگو ہوتی ہے۔';

  @override
  String get merge => 'ضم کریں';

  @override
  String get replaceEverything => 'سب کچھ بدلیں';

  @override
  String get replaceTitle => 'اس فون پر سب کچھ بدل دیں؟';

  @override
  String get replaceBody =>
      'اس فون پر جو کچھ بیک اپ میں نہیں وہ حذف ہو جائے گا، اور ہر ریکارڈ کا '
      'بیک اپ والا ورژن استعمال ہوگا۔ اسے واپس نہیں لیا جا سکتا۔';

  @override
  String get replace => 'بدلیں';

  @override
  String get colDate => 'تاریخ';

  @override
  String get colMonth => 'مہینہ';

  @override
  String get colAmount => 'رقم';

  @override
  String get colNote => 'نوٹ';

  @override
  String get colId => 'شناخت';

  @override
  String get colCount => 'لین دین';

  @override
  String get colTotal => 'کل';

  @override
  String get colShare => 'حصہ';

  @override
  String get yes => 'ہاں';

  @override
  String get no => 'نہیں';

  @override
  String get reportTitle => 'میرا بجٹ: اخراجات کی رپورٹ';

  @override
  String get reportPeriod => 'مدت';

  @override
  String get reportTotal => 'کل خرچ';

  @override
  String get reportMonthlyAverage => 'ماہانہ اوسط';

  @override
  String get reportByMonth => 'مہینے کے لحاظ سے خرچ';

  @override
  String get reportAllExpenses => 'تمام اخراجات';

  @override
  String get reportEmpty => 'ابھی کوئی خرچ درج نہیں۔';

  @override
  String get reportPageTemplate => 'صفحہ {page} از {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} اور ${categoryCount(categories)}'
        : '${expenseCount(expenses)}، ${categoryCount(categories)} اور '
              '${personCount(people)}';
    return date == null
        ? 'اس بیک اپ میں $contents ہیں۔'
        : '$date کا بیک اپ: $contents۔';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count زمرہ',
    other: '$count زمرے',
  );

  @override
  String reportGenerated(String when) => '$when کو تیار کی گئی';

  @override
  String get showPassword => 'پاس ورڈ دکھائیں';

  @override
  String get hidePassword => 'پاس ورڈ چھپائیں';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'کھانا',
    'cat_transport' => 'آمد و رفت',
    'cat_bills' => 'بل',
    'cat_shopping' => 'خریداری',
    'cat_health' => 'صحت اور ورزش',
    'cat_entertainment' => 'تفریح',
    'cat_work' => 'کام',
    'cat_other' => 'دیگر',
    'cat_salary' => 'تنخواہ',
    'cat_freelance' => 'فری لانس',
    'cat_investments' => 'سرمایہ کاری',
    'cat_gifts' => 'تحائف',
    'cat_income_other' => 'دیگر آمدنی',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => 'اس ڈیوائس پر محفوظ نہیں ہو سکا۔ دوبارہ کوشش کریں۔',
    FailureCode.notFound => 'یہ چیز اب موجود نہیں۔',
    FailureCode.unknown => 'کچھ غلط ہو گیا۔',
    FailureCode.amountRequired => 'صفر سے زیادہ رقم درج کریں۔',
    FailureCode.amountTooLarge => 'یہ رقم بہت زیادہ ہے۔',
    FailureCode.amountInvalid => 'درست رقم درج کریں۔',
    FailureCode.categoryRequired => 'ایک زمرہ منتخب کریں۔',
    FailureCode.categoryNameRequired => 'زمرے کا نام رکھیں۔',
    FailureCode.categoryNameTooLong => 'نام 30 حروف سے کم رکھیں۔',
    FailureCode.categoryProtected => 'یہ زمرہ حذف نہیں ہو سکتا۔',
    FailureCode.currencySymbolInvalid => '1 سے 4 حروف استعمال کریں۔',
    FailureCode.network =>
      'رابطہ نہیں ہو سکا۔ انٹرنیٹ چیک کر کے دوبارہ کوشش کریں۔',
    FailureCode.emailInvalid => 'درست ای میل پتا درج کریں۔',
    FailureCode.passwordTooShort => 'پاس ورڈ کم از کم 6 حروف کا ہو۔',
    FailureCode.invalidCredentials => 'ای میل یا پاس ورڈ غلط ہے۔',
    FailureCode.emailTaken => 'اس ای میل سے ایک اکاؤنٹ پہلے سے موجود ہے۔',
    FailureCode.emailNotConfirmed =>
      'پہلے بھیجے گئے کوڈ سے اپنی ای میل کی تصدیق کریں۔',
    FailureCode.codeInvalid => 'کوڈ غلط ہے یا اس کی میعاد ختم ہو گئی۔',
    FailureCode.signInRequired => 'دوبارہ سائن ان کر کے پھر کوشش کریں۔',
    FailureCode.syncOtherAccount =>
      'اس فون کا ڈیٹا کسی دوسرے اکاؤنٹ سے منسلک ہے۔',
    FailureCode.syncFailed =>
      'اکاؤنٹ سے ہم آہنگی نہیں ہو سکی۔ دوبارہ کوشش کریں۔',
    FailureCode.accountDeletionFailed =>
      'اکاؤنٹ حذف نہیں ہو سکا۔ دوبارہ کوشش کریں۔',
    FailureCode.backupNotRecognized => 'یہ فائل میرا بجٹ کا بیک اپ نہیں۔',
    FailureCode.backupTooNew =>
      'یہ بیک اپ میرا بجٹ کے نئے ورژن کا ہے۔ ایپ اپ ڈیٹ کر کے دوبارہ کوشش '
          'کریں۔',
    FailureCode.backupDamaged =>
      'بیک اپ فائل خراب ہے، اس لیے کچھ امپورٹ نہیں ہوا۔',
    FailureCode.fileUnavailable =>
      'فائل نہیں کھل سکی۔ دوبارہ منتخب کر کے دیکھیں۔',
    FailureCode.storageFull => 'اس فون پر کافی خالی جگہ نہیں۔',
    FailureCode.exportFailed => 'فائل نہیں بن سکی۔ دوبارہ کوشش کریں۔',
    FailureCode.shareUnavailable => 'شیئر مینو نہیں کھل سکا۔',
    FailureCode.saveFailed => 'فائل محفوظ نہیں ہو سکی۔ دوبارہ کوشش کریں۔',
    FailureCode.tooManyAttempts =>
      'بہت زیادہ کوششیں۔ تھوڑا انتظار کر کے دوبارہ کوشش کریں۔',
    FailureCode.titleRequired => 'نام رکھیں۔',
    FailureCode.titleTooLong => 'نام 40 حروف سے کم رکھیں۔',
    FailureCode.dueDayInvalid => 'ادائیگی کی تاریخ منتخب کریں۔',
    FailureCode.alreadyPaid => 'یہ ادائیگی پہلے سے درج ہے۔',
    FailureCode.personRequired => 'کسی شخص کو منتخب کریں۔',
    FailureCode.personNameRequired => 'نام درج کریں۔',
    FailureCode.personNameTooLong => 'نام 40 حروف سے کم رکھیں۔',
    FailureCode.phoneInvalid => 'درست فون نمبر درج کریں۔',
    FailureCode.transactionSettled => 'طے شدہ لین دین تبدیل نہیں ہو سکتا۔',
    FailureCode.nothingToSettle => 'طے کرنے کو کچھ نہیں۔',
    FailureCode.settlementAlreadyLogged => 'یہ حساب پہلے سے آپ کے بجٹ میں ہے۔',
  };

  @override
  String get expenseDeleted => 'خرچ حذف ہو گیا';

  @override
  String get expenseRestored => 'خرچ بحال ہو گیا';

  @override
  String categoryAdded(String name) => '"$name" شامل ہو گیا';

  @override
  String get categoryUpdated => 'زمرہ اپ ڈیٹ ہو گیا';

  @override
  String categoryDeleted(String name) => '"$name" حذف ہو گیا';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '"$name" حذف ہو گیا — ${expenseCount(count)} "دیگر" میں منتقل';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '"$name" حذف ہو گیا — ${transactionCount(count)} "دیگر آمدنی" میں منتقل';

  @override
  String get expense => 'خرچ';

  @override
  String get income => 'آمدنی';

  @override
  String get transactionType => 'خرچ یا آمدنی';

  @override
  String get quickIncome => 'فوری آمدنی';

  @override
  String get newIncome => 'نئی آمدنی';

  @override
  String get editIncome => 'آمدنی میں ترمیم';

  @override
  String get addIncome => 'آمدنی شامل کریں';

  @override
  String get incomeNoteHint => 'یہ کہاں سے آئی؟';

  @override
  String get totalIncome => 'کل آمدنی';

  @override
  String get totalExpenses => 'کل اخراجات';

  @override
  String get netBalance => 'خالص بیلنس';

  @override
  String get savingsRate => 'بچت کی شرح';

  @override
  String get savingsRateNoIncome => 'بچت کی شرح دیکھنے کے لیے آمدنی شامل کریں';

  @override
  String get expenseCategories => 'اخراجات کے زمرے';

  @override
  String get incomeCategories => 'آمدنی کے زمرے';

  @override
  String get deleteIncomeCategoryBody =>
      'اس زمرے کی آمدنی "دیگر آمدنی" میں منتقل ہو جائے گی۔ کچھ بھی حذف نہیں '
      'ہوگا۔';

  @override
  String get incomeDeleted => 'آمدنی حذف ہو گئی';

  @override
  String get incomeRestored => 'آمدنی بحال ہو گئی';

  @override
  String get colType => 'قسم';

  @override
  String transactionCount(int count) => '$count لین دین';

  @override
  String get recurringPayments => 'بار بار کی ادائیگیاں';

  @override
  String get newRecurring => 'نئی بار بار کی ادائیگی';

  @override
  String get editRecurring => 'بار بار کی ادائیگی میں ترمیم';

  @override
  String get addRecurring => 'ادائیگی شامل کریں';

  @override
  String get recurringTitle => 'نام';

  @override
  String get recurringTitleHint => 'کرایہ، نیٹ فلکس، جم…';

  @override
  String get amount => 'رقم';

  @override
  String get repeats => 'تکرار';

  @override
  String get weekly => 'ہفتہ وار';

  @override
  String get monthly => 'ماہانہ';

  @override
  String get yearly => 'سالانہ';

  @override
  String get dueOn => 'واجب الادا';

  @override
  String get dueDayOfMonth => 'مہینے کا دن';

  @override
  String get dueMonthLabel => 'مہینہ';

  @override
  String get dueDayLabel => 'دن';

  @override
  String get shortMonthHint => 'چھوٹے مہینوں میں یہ آخری دن پڑتی ہے۔';

  @override
  String get whenDue => 'ادائیگی کے دن';

  @override
  String get autoDeduct => 'خودکار کٹوتی';

  @override
  String get remindMe => 'یاد دلائیں';

  @override
  String get autoDeductHint =>
      'ادائیگی کے دن خودبخود خرچ کے طور پر درج ہو جاتی ہے۔';

  @override
  String get remindMeHint =>
      'ہر ادائیگی درج ہونے سے پہلے آپ سے تصدیق مانگی جائے گی۔';

  @override
  String get statusPaid => 'ادا شدہ';

  @override
  String get statusUpcoming => 'آنے والی';

  @override
  String get statusOverdue => 'واجب الادا';

  @override
  String get markAsPaid => 'ادا ہو گئی';

  @override
  String get dueToday => 'آج ادا کرنی ہے';

  @override
  String dueOnDate(String date) => '$date کو ادا کرنی ہے';

  @override
  String nextDueOn(String date) => 'اگلی: $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? '$date کو ادا کرنی تھی'
      : '$date سے ${paymentCount(count)} باقی';

  @override
  String everyWeekday(String weekday) => 'ہر $weekday';

  @override
  String monthlyOnDay(String day) => 'ہر مہینے کی $day تاریخ';

  @override
  String yearlyOn(String date) => 'ہر سال $date کو';

  @override
  String get monthlyAverage => 'ہر مہینے';

  @override
  String get monthlyAverageHint => 'آپ کی تمام بار بار کی ادائیگیاں، اوسطاً';

  @override
  String get noRecurringYet => 'ابھی کوئی بار بار کی ادائیگی نہیں';

  @override
  String get noRecurringHint =>
      'کرایہ، بل اور سبسکرپشنز ایک بار شامل کریں۔ ہر مہینے آپ دیکھیں گے کہ کیا '
      'ادا ہو گیا اور کیا باقی ہے۔';

  @override
  String get paymentsToConfirm => 'تصدیق طلب ادائیگیاں';

  @override
  String get seeAll => 'سب دیکھیں';

  @override
  String get deleteRecurringBody =>
      'یہ دہرانا بند ہو جائے گی۔ پہلے سے درج ادائیگیاں آپ کے لین دین میں رہیں '
      'گی۔';

  @override
  String recurringPaid(String name) => '"$name" ادا شدہ نشان زد';

  @override
  String get recurringPaymentUndone => 'ادائیگی ہٹا دی گئی';

  @override
  String recurringAutoLogged(int count) =>
      '$count بار بار کی ادائیگی خودبخود درج ہوئی';

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count ادائیگی',
    other: '$count ادائیگیاں',
  );

  @override
  String get colPaidThrough => 'تک ادا شدہ';

  // People & debts

  @override
  String get people => 'لوگ';

  @override
  String get peopleAndDebts => 'لوگ اور قرض';

  @override
  String get person => 'شخص';

  @override
  String get personName => 'نام';

  @override
  String get phone => 'فون';

  @override
  String get phoneOptional => 'فون (اختیاری)';

  @override
  String get balance => 'بیلنس';

  @override
  String get colStatus => 'حیثیت';

  @override
  String get owesYou => 'آپ کا قرض دار';

  @override
  String get youOwe => 'آپ پر قرض';

  @override
  String get owedToYou => 'آپ کا لینا';

  @override
  String get settledUp => 'حساب برابر';

  @override
  String get iPaidForThem => 'میں نے ان کی جگہ ادا کیا';

  @override
  String get theyPaidForMe => 'انہوں نے میری جگہ ادا کیا';

  @override
  String get theyPaidYou => 'انہوں نے آپ کو دیا';

  @override
  String get youPaidThem => 'آپ نے انہیں دیا';

  @override
  String get openStatus => 'کھلا';

  @override
  String get settledStatus => 'طے شدہ';

  @override
  String get settledOn => 'طے ہوا';

  @override
  String get createdOn => 'بنایا گیا';

  @override
  String get lastEdited => 'آخری ترمیم';

  @override
  String get colEdits => 'ترامیم';

  @override
  String get activeTransactions => 'کھلے لین دین';

  @override
  String get settledHistory => 'طے شدہ حساب';

  @override
  String get filterAll => 'سب';

  @override
  String get filterOwedToMe => 'میرا لینا';

  @override
  String get filterIOwe => 'میرا دینا';

  @override
  String get filterSettled => 'طے شدہ';

  @override
  String get addPerson => 'شخص شامل کریں';

  @override
  String get addPersonHint => 'کوئی جس کے ساتھ آپ اخراجات بانٹتے ہیں';

  @override
  String get newPerson => 'نیا شخص';

  @override
  String get editPerson => 'شخص میں ترمیم';

  @override
  String get deletePerson => 'شخص حذف کریں';

  @override
  String get quickTransaction => 'فوری لین دین';

  @override
  String get quickTransactionHint =>
      'درج کریں کس نے ادا کیا، کسی شامل کیے گئے شخص کے ساتھ';

  @override
  String get noPeopleYet => 'ابھی کوئی شخص نہیں';

  @override
  String get noPeopleHint =>
      'جن لوگوں کے ساتھ اخراجات بانٹتے ہیں انہیں شامل کریں تاکہ پتا رہے کس کا '
      'کس پر قرض ہے۔';

  @override
  String get nobodyHere => 'اس فلٹر سے کوئی میل نہیں کھاتا۔';

  @override
  String get addPersonFirst => 'پہلے کوئی شخص شامل کریں۔';

  @override
  String get newTransaction => 'نیا لین دین';

  @override
  String get editTransaction => 'لین دین میں ترمیم';

  @override
  String get transactionDetails => 'لین دین کی تفصیل';

  @override
  String get debtNoteHint => 'یہ کس لیے تھا؟';

  @override
  String get changeHistory => 'تبدیلیوں کی تاریخ';

  @override
  String get edited => 'ترمیم شدہ';

  @override
  String get settleUp => 'حساب برابر کریں';

  @override
  String get settle => 'طے کریں';

  @override
  String get noDebtsYet => 'ابھی تک کچھ درج نہیں';

  @override
  String get noDebtsHint =>
      'وہ شامل کریں جو آپ نے ان کے لیے ادا کیا، یا جو انہوں نے آپ کے لیے ادا '
      'کیا۔';

  @override
  String get settleEven =>
      'یہ لین دین ایک دوسرے کو برابر کر دیتے ہیں، اس لیے کسی کو پیسے دینے کی '
      'ضرورت نہیں۔';

  @override
  String get logSettlementTitle => 'یہ حساب ماہانہ بجٹ میں درج کریں؟';

  @override
  String get loggedInBudget => 'آپ کے بجٹ میں';

  @override
  String get deleteTransactionTitle => 'یہ لین دین حذف کریں؟';

  @override
  String get deleteTransactionBody =>
      'اسے اس شخص کے ساتھ بیلنس سے ہٹا دیا جائے گا۔';

  @override
  String get deletePersonBody =>
      'ان کے لین دین اور طے شدہ حساب بھی حذف ہو جائیں گے۔ جو آپ نے بجٹ میں '
      'درج کیا وہ رہے گا۔';

  @override
  String get settledLocked => 'طے ہو چکا، اس لیے اب تبدیل نہیں ہو سکتا۔';

  @override
  String get personUpdated => 'شخص اپ ڈیٹ ہو گیا';

  @override
  String get debtDeleted => 'لین دین حذف ہو گیا';

  @override
  String get settledUpNotice => 'سب حساب برابر';

  @override
  String get settlementLogged => 'آپ کے بجٹ میں شامل ہو گیا';

  @override
  String personOwesYou(String name) => '$name آپ کا قرض دار ہے';

  @override
  String youOwePerson(String name) => 'آپ $name کے قرض دار ہیں';

  @override
  String settledWith(String name) => '$name کے ساتھ سب حساب برابر';

  @override
  String settleUpFor(String amount) => '$amount کا حساب برابر کریں';

  @override
  String settleTitle(String name) => '$name کے ساتھ حساب برابر کریں؟';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name آپ کو $amount دیں گے اور سب حساب برابر ہو جائے گا۔';

  @override
  String settleYouPay(String name, String amount) =>
      'آپ $name کو $amount دیں گے اور سب حساب برابر ہو جائے گا۔';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} طے شدہ حساب میں منتقل ہو جائیں گے۔';

  @override
  String logSettlementIncome(String amount) =>
      '$amount "دیگر آمدنی" میں آمدنی کے طور پر شامل ہوگا۔ بعد میں اسے دوسرے '
      'زمرے میں منتقل کر سکتے ہیں۔';

  @override
  String logSettlementExpense(String amount) =>
      '$amount "دیگر" میں خرچ کے طور پر شامل ہوگا۔ بعد میں اسے دوسرے زمرے میں '
      'منتقل کر سکتے ہیں۔';

  @override
  String settlementNote(String name) => '$name کے ساتھ حساب';

  @override
  String settledGroupTitle(String date) => '$date کو طے ہوا';

  @override
  String deletePersonTitle(String name) => '$name کو حذف کریں؟';

  @override
  String editedOn(String date) => '$date کو ترمیم';

  @override
  String wasValues(String values) => 'پہلے: $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count شخص',
    other: '$count افراد',
  );
}
