import '../../error/failures.dart';
import '../app_strings.dart';

/// Persian keeps a noun singular after a number, so counts need no plural
/// forms.
class AppStringsFa extends AppStrings {
  const AppStringsFa();

  @override
  String get localeName => 'fa';

  @override
  String get appTitle => 'بودجه من';

  @override
  String get add => 'افزودن';

  @override
  String get undo => 'واگرد';

  @override
  String get tryAgain => 'تلاش دوباره';

  @override
  String get nothingRecordedYet => 'هنوز چیزی ثبت نشده';

  @override
  String get emptyMonthHint =>
      'روی «افزودن» بزنید تا اولین هزینه یا درآمد این ماه را ثبت کنید.';

  @override
  String get yourMonths => 'ماه‌های شما';

  @override
  String spentIn(String month) => 'هزینه در $month';

  @override
  String expenseCount(int count) => '$count هزینه';

  @override
  String get quickExpense => 'هزینه سریع';

  @override
  String get expenseSaved => 'هزینه ذخیره شد';

  @override
  String get newExpense => 'هزینه جدید';

  @override
  String get editExpense => 'ویرایش هزینه';

  @override
  String get when => 'تاریخ';

  @override
  String get today => 'امروز';

  @override
  String get yesterday => 'دیروز';

  @override
  String get pickADate => 'انتخاب تاریخ';

  @override
  String get category => 'دسته';

  @override
  String get noteOptional => 'یادداشت (اختیاری)';

  @override
  String get noteHint => 'برای چه بود؟';

  @override
  String get addExpense => 'افزودن هزینه';

  @override
  String get saveChanges => 'ذخیره تغییرات';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'دسته‌ها';

  @override
  String get newCategory => 'دسته جدید';

  @override
  String get editCategory => 'ویرایش دسته';

  @override
  String get addCategory => 'افزودن دسته';

  @override
  String get categoryName => 'نام';

  @override
  String get color => 'رنگ';

  @override
  String get icon => 'نماد';

  @override
  String get builtIn => 'پیش‌فرض';

  @override
  String get custom => 'سفارشی';

  @override
  String get edit => 'ویرایش';

  @override
  String get delete => 'حذف';

  @override
  String get cancel => 'لغو';

  @override
  String deleteCategoryTitle(String name) => '«$name» حذف شود؟';

  @override
  String get deleteCategoryBody =>
      'هزینه‌های این دسته به «سایر» منتقل می‌شوند. چیزی حذف نمی‌شود.';

  @override
  String get settings => 'تنظیمات';

  @override
  String get appearance => 'ظاهر';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

  @override
  String get language => 'زبان';

  @override
  String get languageSystem => 'سیستم';

  @override
  String get currency => 'واحد پول';

  @override
  String get currencySymbol => 'نماد';

  @override
  String get currencySymbolHint => 'کنار هر مبلغ نمایش داده می‌شود';

  @override
  String get reminders => 'یادآورها';

  @override
  String get dailyReminder => 'یادآور روزانه';

  @override
  String get dailyReminderHint => 'یادآوری برای ثبت خرج‌های امروز';

  @override
  String get reminderTime => 'زمان';

  @override
  String get notificationsBlocked =>
      'اعلان‌های این برنامه خاموش است. از تنظیمات گوشی اجازه دهید.';

  @override
  String get reminderNotificationTitle => 'خرج‌های امروز را ثبت کنید';

  @override
  String get reminderNotificationBody =>
      'چند لحظه وقت بگذارید و خرج‌های امروز را اضافه کنید.';

  @override
  String get security => 'امنیت';

  @override
  String get appLock => 'قفل برنامه';

  @override
  String get appLockHint =>
      'هنگام باز شدن برنامه، اثر انگشت، چهره یا قفل صفحه خواسته شود';

  @override
  String get appLockUnavailable => 'ابتدا روی این گوشی قفل صفحه تنظیم کنید';

  @override
  String get unlock => 'باز کردن قفل';

  @override
  String get unlockToContinue => 'برای دیدن بودجه‌تان قفل را باز کنید';

  @override
  String get confirmItsYou => 'برای تغییر قفل برنامه، هویت خود را تأیید کنید';

  @override
  String get storedOnThisDevice =>
      'هزینه‌های شما روی همین دستگاه ذخیره می‌شوند. برای پشتیبان‌گیری وارد '
      'شوید.';

  @override
  String get account => 'حساب';

  @override
  String get accountOptional =>
      'حساب اختیاری است. برنامه بدون حساب هم کامل کار می‌کند.';

  @override
  String get signIn => 'ورود';

  @override
  String get signOut => 'خروج';

  @override
  String get signedIn => 'وارد شده‌اید';

  @override
  String get createAccount => 'ساخت حساب';

  @override
  String get noAccountYet => 'حساب ندارید؟ بسازید';

  @override
  String get haveAnAccount => 'حساب دارید؟ وارد شوید';

  @override
  String get email => 'ایمیل';

  @override
  String get password => 'رمز عبور';

  @override
  String get passwordRules => 'دست‌کم ۶ نویسه';

  @override
  String get confirmEmail => 'ایمیل خود را تأیید کنید';

  @override
  String codeSentTo(String email) =>
      'کدی به $email فرستادیم. برای تکمیل ساخت حساب، آن را در زیر وارد کنید.';

  @override
  String get confirmationCode => 'کد';

  @override
  String get confirm => 'تأیید';

  @override
  String get resendCode => 'ارسال کد جدید';

  @override
  String get codeResent => 'کد جدید در راه است';

  @override
  String get useDifferentEmail => 'استفاده از ایمیل دیگر';

  @override
  String get forgotPassword => 'رمز عبور را فراموش کرده‌اید؟';

  @override
  String get resetPassword => 'بازنشانی رمز عبور';

  @override
  String resetCodeSentTo(String email) =>
      'کدی به $email فرستادیم. آن را همراه با رمز عبور جدید حساب خود وارد کنید.';

  @override
  String get newPassword => 'رمز عبور جدید';

  @override
  String get saveNewPassword => 'ذخیره رمز عبور جدید';

  @override
  String get backToSignIn => 'بازگشت به ورود';

  @override
  String get backupHint =>
      'با پشتیبان‌گیری، نسخه‌ای از هزینه‌هایتان در حسابتان نگه داشته می‌شود. '
      'بازیابی آن نسخه را بدون حذف چیزی از این گوشی برمی‌گرداند.';

  @override
  String get backUpNow => 'پشتیبان‌گیری';

  @override
  String get autoBackup => 'پشتیبان‌گیری خودکار';

  @override
  String get autoBackupHint =>
      'هر بار که از برنامه بیرون می‌روید، تغییرات تازه در حسابتان پشتیبان‌گیری می‌شود.';

  @override
  String get restoreData => 'بازیابی';

  @override
  String get backingUp => 'در حال پشتیبان‌گیری…';

  @override
  String get restoring => 'در حال بازیابی…';

  @override
  String get backupDone => 'پشتیبان‌گیری انجام شد';

  @override
  String get restoreDone => 'بازیابی انجام شد';

  @override
  String get neverSynced => 'هنوز پشتیبانی گرفته نشده';

  @override
  String lastSynced(String when) => 'آخرین همگام‌سازی: $when';

  @override
  String get deleteAccount => 'حذف حساب';

  @override
  String get deleteAccountTitle => 'حساب شما حذف شود؟';

  @override
  String get deleteAccountBody =>
      'با این کار حساب شما و پشتیبان هزینه‌هایی که در آن است برای همیشه حذف '
      'می‌شوند و قابل بازگشت نیست. هزینه‌های روی این گوشی باقی می‌مانند و '
      'می‌توانید بدون حساب از برنامه استفاده کنید.';

  @override
  String get deletingAccount => 'در حال حذف حساب…';

  @override
  String get accountDeleted => 'حساب شما حذف شد';

  @override
  String get home => 'خانه';

  @override
  String get analyses => 'تحلیل';

  @override
  String get vsLastMonth => 'در مقایسه با ماه گذشته';

  @override
  String get noComparison => 'بدون داده ماه گذشته';

  @override
  String get dailySpending => 'هزینه روزانه';

  @override
  String get dailyAverage => 'میانگین روزانه';

  @override
  String get topDay => 'بیشترین روز';

  @override
  String get byCategory => 'هزینه بر اساس دسته';

  @override
  String get noSpendingThisMonth => 'هنوز هزینه‌ای در این ماه نیست.';

  @override
  String get monthlyTrend => '۶ ماه اخیر';

  @override
  String lastMonthTotal(String amount) => 'ماه گذشته: $amount';

  @override
  String get budgets => 'بودجه‌ها';

  @override
  String get monthlyBudget => 'بودجه ماهانه';

  @override
  String get setMonthlyBudget => 'بودجه ماهانه تعیین کنید';

  @override
  String get setBudgetHint =>
      'ببینید چقدر مانده و پیش از زیاده‌روی باخبر شوید.';

  @override
  String get setBudget => 'تعیین';

  @override
  String get editBudget => 'ویرایش بودجه';

  @override
  String get removeBudget => 'حذف';

  @override
  String get save => 'ذخیره';

  @override
  String amountLeft(String amount) => '$amount مانده';

  @override
  String amountOver(String amount) => '$amount بیش از بودجه';

  @override
  String spentOfLimit(String spent, String limit) => '$spent از $limit خرج شده';

  @override
  String amountSpent(String amount) => '$amount خرج شده';

  @override
  String budgetUsed(String percent) => '$percent از بودجه مصرف شده';

  @override
  String get categoryBudgets => 'بودجه دسته‌ها';

  @override
  String get categoryBudgetsHint => 'برای هزینه یک دسته سقف تعیین کنید.';

  @override
  String categoryBudgetTitle(String name) => 'بودجه $name';

  @override
  String get setLimit => 'تعیین سقف';

  @override
  String get closeToLimit => 'نزدیک به سقف';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'بودجه‌ها هر ماه تکرار می‌شوند. وقتی هزینه از $nearing بگذرد و دوباره '
      'در $reached باخبر می‌شوید.';

  @override
  String get budgetAlertTitle => 'هشدار بودجه';

  @override
  String get ok => 'باشه';

  @override
  String get view => 'مشاهده';

  @override
  String monthlyBudgetNearing(String percent) =>
      '$percent از بودجه ماهانه را خرج کرده‌اید';

  @override
  String get monthlyBudgetUsedUp => 'همه بودجه ماهانه را خرج کرده‌اید';

  @override
  String monthlyBudgetExceeded(String amount) =>
      '$amount از بودجه ماهانه بیشتر خرج کرده‌اید';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      '$percent از بودجه $name را خرج کرده‌اید';

  @override
  String categoryBudgetUsedUp(String name) => 'همه بودجه $name را خرج کرده‌اید';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      '$amount از بودجه $name بیشتر خرج کرده‌اید';

  @override
  String get dataManagement => 'مدیریت داده';

  @override
  String get dataManagementHint =>
      'فایل‌هایی که خودتان نگه می‌دارید. بدون اینترنت و بدون حساب کار می‌کنند.';

  @override
  String get backUpToFile => 'پشتیبان از داده‌هایم';

  @override
  String get backUpToFileHint =>
      'یک فایل پشتیبان کامل که بعداً می‌توانید وارد کنید';

  @override
  String get exportCsv => 'خروجی CSV';

  @override
  String get exportCsvHint => 'برای Excel یا Google Sheets';

  @override
  String get exportPdf => 'خروجی PDF';

  @override
  String get exportPdfHint => 'گزارشی برای خواندن، چاپ یا اشتراک‌گذاری';

  @override
  String get importData => 'وارد کردن داده';

  @override
  String get importDataHint => 'بازیابی از فایل پشتیبان';

  @override
  String get preparingFile => 'در حال آماده‌سازی فایل…';

  @override
  String get importingData => 'در حال وارد کردن…';

  @override
  String get fileSaved => 'فایل ذخیره شد';

  @override
  String get importDone => 'وارد کردن انجام شد';

  @override
  String get importNothingNew => 'این گوشی همه محتوای پشتیبان را از قبل داشت';

  @override
  String get fileReady => 'فایل آماده است';

  @override
  String get shareFile => 'اشتراک‌گذاری';

  @override
  String get shareFileHint => 'واتس‌اپ، ایمیل، گوگل درایو و غیره';

  @override
  String get saveToPhone => 'ذخیره در این گوشی';

  @override
  String get saveToPhoneHint => 'محل نگهداری را انتخاب کنید';

  @override
  String get importTitle => 'این پشتیبان وارد شود؟';

  @override
  String get importMergeHint =>
      'ادغام همه چیز را روی این گوشی نگه می‌دارد و موارد جاافتاده را اضافه '
      'می‌کند. اگر رکوردی متفاوت باشد، تغییر جدیدتر اعمال می‌شود.';

  @override
  String get merge => 'ادغام';

  @override
  String get replaceEverything => 'جایگزینی همه';

  @override
  String get replaceTitle => 'همه چیز روی این گوشی جایگزین شود؟';

  @override
  String get replaceBody =>
      'هر چیزی روی این گوشی که در پشتیبان نیست حذف می‌شود و برای هر رکورد '
      'نسخه پشتیبان به کار می‌رود. این کار قابل بازگشت نیست.';

  @override
  String get replace => 'جایگزینی';

  @override
  String get colDate => 'تاریخ';

  @override
  String get colMonth => 'ماه';

  @override
  String get colAmount => 'مبلغ';

  @override
  String get colNote => 'یادداشت';

  @override
  String get colId => 'شناسه';

  @override
  String get colCount => 'تراکنش‌ها';

  @override
  String get colTotal => 'جمع';

  @override
  String get colShare => 'سهم';

  @override
  String get yes => 'بله';

  @override
  String get no => 'خیر';

  @override
  String get reportTitle => 'بودجه من: گزارش هزینه‌ها';

  @override
  String get reportPeriod => 'دوره';

  @override
  String get reportTotal => 'جمع هزینه';

  @override
  String get reportMonthlyAverage => 'میانگین ماهانه';

  @override
  String get reportByMonth => 'هزینه بر اساس ماه';

  @override
  String get reportAllExpenses => 'همه هزینه‌ها';

  @override
  String get reportEmpty => 'هنوز هزینه‌ای ثبت نشده.';

  @override
  String get reportPageTemplate => 'صفحه {page} از {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} و ${categoryCount(categories)}'
        : '${expenseCount(expenses)}، ${categoryCount(categories)} و '
              '${personCount(people)}';
    return date == null
        ? 'این پشتیبان شامل $contents است.'
        : 'پشتیبان $date: $contents.';
  }

  @override
  String categoryCount(int count) => '$count دسته';

  @override
  String reportGenerated(String when) => 'تهیه‌شده در $when';

  @override
  String get showPassword => 'نمایش رمز عبور';

  @override
  String get hidePassword => 'پنهان کردن رمز عبور';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'خوراک',
    'cat_transport' => 'حمل‌ونقل',
    'cat_bills' => 'قبض‌ها',
    'cat_shopping' => 'خرید',
    'cat_health' => 'سلامت و ورزش',
    'cat_entertainment' => 'سرگرمی',
    'cat_work' => 'کار',
    'cat_other' => 'سایر',
    'cat_salary' => 'حقوق',
    'cat_freelance' => 'کار آزاد',
    'cat_investments' => 'سرمایه‌گذاری',
    'cat_gifts' => 'هدیه‌ها',
    'cat_income_other' => 'درآمد دیگر',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => 'ذخیره روی این دستگاه ممکن نشد. دوباره تلاش کنید.',
    FailureCode.notFound => 'این مورد دیگر وجود ندارد.',
    FailureCode.unknown => 'مشکلی پیش آمد.',
    FailureCode.amountRequired => 'مبلغی بیشتر از صفر وارد کنید.',
    FailureCode.amountTooLarge => 'این مبلغ خیلی بزرگ است.',
    FailureCode.amountInvalid => 'مبلغ معتبری وارد کنید.',
    FailureCode.categoryRequired => 'یک دسته انتخاب کنید.',
    FailureCode.categoryNameRequired => 'برای دسته نامی بگذارید.',
    FailureCode.categoryNameTooLong => 'نام باید کمتر از ۳۰ نویسه باشد.',
    FailureCode.categoryProtected => 'این دسته قابل حذف نیست.',
    FailureCode.currencySymbolInvalid => 'از ۱ تا ۴ نویسه استفاده کنید.',
    FailureCode.network =>
      'اتصال برقرار نشد. اینترنت را بررسی کنید و دوباره تلاش کنید.',
    FailureCode.emailInvalid => 'نشانی ایمیل معتبری وارد کنید.',
    FailureCode.passwordTooShort => 'رمز عبور باید دست‌کم ۶ نویسه باشد.',
    FailureCode.invalidCredentials => 'ایمیل یا رمز عبور نادرست است.',
    FailureCode.emailTaken => 'حسابی با این ایمیل از قبل وجود دارد.',
    FailureCode.emailNotConfirmed =>
      'ابتدا ایمیل خود را با کدی که فرستادیم تأیید کنید.',
    FailureCode.codeInvalid => 'کد نادرست است یا منقضی شده.',
    FailureCode.signInRequired => 'دوباره وارد شوید و باز امتحان کنید.',
    FailureCode.syncOtherAccount => 'داده‌های این گوشی به حساب دیگری وصل است.',
    FailureCode.syncFailed => 'همگام‌سازی با حساب ممکن نشد. دوباره تلاش کنید.',
    FailureCode.accountDeletionFailed => 'حذف حساب ممکن نشد. دوباره تلاش کنید.',
    FailureCode.backupNotRecognized => 'این فایل پشتیبان بودجه من نیست.',
    FailureCode.backupTooNew =>
      'این پشتیبان از نسخه جدیدتر بودجه من است. برنامه را به‌روز کنید و '
          'دوباره تلاش کنید.',
    FailureCode.backupDamaged =>
      'فایل پشتیبان آسیب دیده است، پس چیزی وارد نشد.',
    FailureCode.fileUnavailable =>
      'باز کردن فایل ممکن نشد. دوباره آن را انتخاب کنید.',
    FailureCode.storageFull => 'فضای خالی کافی روی این گوشی نیست.',
    FailureCode.exportFailed => 'ساخت فایل ممکن نشد. دوباره تلاش کنید.',
    FailureCode.shareUnavailable => 'باز کردن منوی اشتراک‌گذاری ممکن نشد.',
    FailureCode.saveFailed => 'ذخیره فایل ممکن نشد. دوباره تلاش کنید.',
    FailureCode.tooManyAttempts =>
      'تلاش‌ها زیاد بود. کمی صبر کنید و دوباره امتحان کنید.',
    FailureCode.titleRequired => 'نامی بگذارید.',
    FailureCode.titleTooLong => 'نام باید کمتر از ۴۰ نویسه باشد.',
    FailureCode.dueDayInvalid => 'زمان سررسید را انتخاب کنید.',
    FailureCode.alreadyPaid => 'این پرداخت قبلاً ثبت شده.',
    FailureCode.personRequired => 'یک نفر را انتخاب کنید.',
    FailureCode.personNameRequired => 'نامی وارد کنید.',
    FailureCode.personNameTooLong => 'نام باید کمتر از ۴۰ نویسه باشد.',
    FailureCode.phoneInvalid => 'شماره تلفن معتبری وارد کنید.',
    FailureCode.transactionSettled => 'تراکنش‌های تسویه‌شده قابل تغییر نیستند.',
    FailureCode.nothingToSettle => 'چیزی برای تسویه نیست.',
    FailureCode.settlementAlreadyLogged =>
      'این تسویه قبلاً در بودجه شما ثبت شده.',
  };

  @override
  String get expenseDeleted => 'هزینه حذف شد';

  @override
  String get expenseRestored => 'هزینه بازگردانده شد';

  @override
  String categoryAdded(String name) => '«$name» افزوده شد';

  @override
  String get categoryUpdated => 'دسته به‌روز شد';

  @override
  String categoryDeleted(String name) => '«$name» حذف شد';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '«$name» حذف شد — ${expenseCount(count)} به «سایر» منتقل شد';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '«$name» حذف شد — ${transactionCount(count)} به «درآمد دیگر» منتقل شد';

  @override
  String get expense => 'هزینه';

  @override
  String get income => 'درآمد';

  @override
  String get search => 'جستجو';

  @override
  String get searchHint => 'جستجوی یادداشت یا مبلغ';

  @override
  String get searchPrompt =>
      'هر تراکنش را با یادداشت یا مبلغش پیدا کنید، یا بر اساس نوع، دسته و تاریخ فیلتر کنید.';

  @override
  String get noSearchResults => 'تراکنشی پیدا نشد';

  @override
  String get allTypes => 'همه';

  @override
  String get anyCategory => 'هر دسته';

  @override
  String get anyDate => 'هر تاریخ';

  @override
  String get clearFilters => 'پاک کردن فیلترها';

  @override
  String get transactionType => 'هزینه یا درآمد';

  @override
  String get quickIncome => 'درآمد سریع';

  @override
  String get newIncome => 'درآمد جدید';

  @override
  String get editIncome => 'ویرایش درآمد';

  @override
  String get addIncome => 'افزودن درآمد';

  @override
  String get incomeNoteHint => 'از کجا آمد؟';

  @override
  String get totalIncome => 'جمع درآمد';

  @override
  String get totalExpenses => 'جمع هزینه‌ها';

  @override
  String get netBalance => 'مانده خالص';

  @override
  String get savingsRate => 'نرخ پس‌انداز';

  @override
  String get savingsRateNoIncome => 'برای دیدن نرخ پس‌انداز، درآمد اضافه کنید';

  @override
  String get expenseCategories => 'دسته‌های هزینه';

  @override
  String get incomeCategories => 'دسته‌های درآمد';

  @override
  String get deleteIncomeCategoryBody =>
      'درآمدهای این دسته به «درآمد دیگر» منتقل می‌شوند. چیزی حذف نمی‌شود.';

  @override
  String get incomeDeleted => 'درآمد حذف شد';

  @override
  String get incomeRestored => 'درآمد بازگردانده شد';

  @override
  String get colType => 'نوع';

  @override
  String transactionCount(int count) => '$count تراکنش';

  @override
  String get recurringPayments => 'پرداخت‌های تکراری';

  @override
  String get newRecurring => 'پرداخت تکراری جدید';

  @override
  String get editRecurring => 'ویرایش پرداخت تکراری';

  @override
  String get addRecurring => 'افزودن پرداخت';

  @override
  String get recurringTitle => 'نام';

  @override
  String get recurringTitleHint => 'اجاره، نتفلیکس، باشگاه…';

  @override
  String get amount => 'مبلغ';

  @override
  String get repeats => 'تکرار';

  @override
  String get weekly => 'هفتگی';

  @override
  String get monthly => 'ماهانه';

  @override
  String get yearly => 'سالانه';

  @override
  String get dueOn => 'سررسید';

  @override
  String get dueDayOfMonth => 'روز ماه';

  @override
  String get dueMonthLabel => 'ماه';

  @override
  String get dueDayLabel => 'روز';

  @override
  String get shortMonthHint => 'در ماه‌های کوتاه‌تر، روز آخر ماه می‌افتد.';

  @override
  String get whenDue => 'هنگام سررسید';

  @override
  String get autoDeduct => 'کسر خودکار';

  @override
  String get remindMe => 'یادآوری';

  @override
  String get autoDeductHint =>
      'در روز سررسید خودکار به‌عنوان هزینه ثبت می‌شود.';

  @override
  String get remindMeHint => 'پیش از ثبت هر پرداخت از شما تأیید خواسته می‌شود.';

  @override
  String get statusPaid => 'پرداخت‌شده';

  @override
  String get statusUpcoming => 'پیش رو';

  @override
  String get statusOverdue => 'معوق';

  @override
  String get markAsPaid => 'پرداخت شد';

  @override
  String get dueToday => 'سررسید امروز';

  @override
  String dueOnDate(String date) => 'سررسید $date';

  @override
  String nextDueOn(String date) => 'بعدی $date';

  @override
  String overdueSince(String date, int count) =>
      count <= 1 ? 'سررسید $date بود' : '${paymentCount(count)} معوق از $date';

  @override
  String everyWeekday(String weekday) => 'هر $weekday';

  @override
  String monthlyOnDay(String day) => 'ماهانه، روز $day';

  @override
  String yearlyOn(String date) => 'سالانه، $date';

  @override
  String get monthlyAverage => 'ماهانه';

  @override
  String get monthlyAverageHint => 'میانگین همه پرداخت‌های تکراری';

  @override
  String get noRecurringYet => 'هنوز پرداخت تکراری ندارید';

  @override
  String get noRecurringHint =>
      'اجاره، قبض‌ها و اشتراک‌ها را یک بار اضافه کنید. هر ماه می‌بینید چه '
      'پرداخت شده و چه مانده.';

  @override
  String get paymentsToConfirm => 'پرداخت‌های منتظر تأیید';

  @override
  String get seeAll => 'همه';

  @override
  String get deleteRecurringBody =>
      'دیگر تکرار نمی‌شود. پرداخت‌های ثبت‌شده در تراکنش‌های شما می‌مانند.';

  @override
  String recurringPaid(String name) => '«$name» پرداخت‌شده علامت خورد';

  @override
  String recurringReceived(String name) => '«$name» دریافت‌شده علامت خورد';

  @override
  String get statusReceived => 'دریافت‌شده';

  @override
  String get markAsReceived => 'دریافت شد';

  @override
  String get autoAdd => 'افزودن خودکار';

  @override
  String get autoAddHint => 'در روز سررسید خودکار به‌عنوان درآمد ثبت می‌شود.';

  @override
  String get monthlyIncomeAverage => 'درآمد ماهانه';

  @override
  String get recurringPaymentUndone => 'پرداخت برداشته شد';

  @override
  String recurringAutoLogged(int count) => '$count پرداخت تکراری خودکار ثبت شد';

  @override
  String paymentCount(int count) => '$count پرداخت';

  @override
  String get colPaidThrough => 'پرداخت تا';

  // People & debts

  @override
  String get people => 'افراد';

  @override
  String get peopleAndDebts => 'افراد و بدهی‌ها';

  @override
  String get person => 'فرد';

  @override
  String get personName => 'نام';

  @override
  String get phone => 'تلفن';

  @override
  String get phoneOptional => 'تلفن (اختیاری)';

  @override
  String get balance => 'مانده';

  @override
  String get colStatus => 'وضعیت';

  @override
  String get owesYou => 'به شما بدهکار است';

  @override
  String get youOwe => 'شما بدهکارید';

  @override
  String get owedToYou => 'طلب شما';

  @override
  String get settledUp => 'تسویه شد';

  @override
  String get iPaidForThem => 'من به جایش پرداختم';

  @override
  String get theyPaidForMe => 'به جای من پرداخت';

  @override
  String get theyPaidYou => 'به شما پرداخت';

  @override
  String get youPaidThem => 'شما پرداختید';

  @override
  String get openStatus => 'باز';

  @override
  String get settledStatus => 'تسویه‌شده';

  @override
  String get settledOn => 'تسویه در';

  @override
  String get createdOn => 'ساخته‌شده';

  @override
  String get lastEdited => 'آخرین ویرایش';

  @override
  String get colEdits => 'ویرایش‌ها';

  @override
  String get activeTransactions => 'تراکنش‌های باز';

  @override
  String get settledHistory => 'سابقه تسویه';

  @override
  String get filterAll => 'همه';

  @override
  String get filterOwedToMe => 'طلب من';

  @override
  String get filterIOwe => 'بدهی من';

  @override
  String get filterSettled => 'تسویه‌شده';

  @override
  String get addPerson => 'افزودن فرد';

  @override
  String get addPersonHint => 'کسی که با او هزینه‌ها را تقسیم می‌کنید';

  @override
  String get newPerson => 'فرد جدید';

  @override
  String get editPerson => 'ویرایش فرد';

  @override
  String get deletePerson => 'حذف فرد';

  @override
  String get quickTransaction => 'تراکنش سریع';

  @override
  String get quickTransactionHint =>
      'ثبت کنید چه کسی پرداخت کرد، با فردی که افزوده‌اید';

  @override
  String get noPeopleYet => 'هنوز کسی اضافه نشده';

  @override
  String get noPeopleHint =>
      'افرادی را که با آن‌ها هزینه تقسیم می‌کنید اضافه کنید تا بدانید چه کسی '
      'به چه کسی بدهکار است.';

  @override
  String get nobodyHere => 'کسی با این فیلتر جور نیست.';

  @override
  String get addPersonFirst => 'اول یک نفر اضافه کنید.';

  @override
  String get newTransaction => 'تراکنش جدید';

  @override
  String get editTransaction => 'ویرایش تراکنش';

  @override
  String get transactionDetails => 'جزئیات تراکنش';

  @override
  String get debtNoteHint => 'برای چه بود؟';

  @override
  String get changeHistory => 'سابقه تغییرات';

  @override
  String get edited => 'ویرایش‌شده';

  @override
  String get settleUp => 'تسویه حساب';

  @override
  String get settle => 'تسویه';

  @override
  String get noDebtsYet => 'هنوز چیزی ثبت نشده';

  @override
  String get noDebtsHint =>
      'آنچه به جای او پرداختید یا او به جای شما پرداخت را اضافه کنید.';

  @override
  String get settleEven =>
      'این تراکنش‌ها همدیگر را خنثی می‌کنند، پس نیازی به جابه‌جایی پول نیست.';

  @override
  String get logSettlementTitle => 'این تسویه در بودجه ماهانه ثبت شود؟';

  @override
  String get loggedInBudget => 'در بودجه شما';

  @override
  String get deleteTransactionTitle => 'این تراکنش حذف شود؟';

  @override
  String get deleteTransactionBody =>
      'از مانده حساب با این فرد برداشته می‌شود.';

  @override
  String get deletePersonBody =>
      'تراکنش‌ها و سابقه تسویه او هم حذف می‌شوند. آنچه در بودجه ثبت کرده‌اید '
      'می‌ماند.';

  @override
  String get settledLocked => 'تسویه شده و دیگر قابل تغییر نیست.';

  @override
  String get personUpdated => 'فرد به‌روز شد';

  @override
  String get debtDeleted => 'تراکنش حذف شد';

  @override
  String get settledUpNotice => 'همه چیز تسویه شد';

  @override
  String get settlementLogged => 'به بودجه شما اضافه شد';

  @override
  String personOwesYou(String name) => '$name به شما بدهکار است';

  @override
  String youOwePerson(String name) => 'شما به $name بدهکارید';

  @override
  String settledWith(String name) => 'همه چیز با $name تسویه شد';

  @override
  String settleUpFor(String amount) => 'تسویه $amount';

  @override
  String settleTitle(String name) => 'با $name تسویه شود؟';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name مبلغ $amount به شما می‌پردازد و همه چیز تسویه می‌شود.';

  @override
  String settleYouPay(String name, String amount) =>
      'شما مبلغ $amount به $name می‌پردازید و همه چیز تسویه می‌شود.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} به سابقه تسویه منتقل می‌شود.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount به‌عنوان درآمد در «درآمد دیگر» ثبت می‌شود. بعداً می‌توانید آن '
      'را به دسته دیگری ببرید.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount به‌عنوان هزینه در «سایر» ثبت می‌شود. بعداً می‌توانید آن را به '
      'دسته دیگری ببرید.';

  @override
  String settlementNote(String name) => 'تسویه با $name';

  @override
  String settledGroupTitle(String date) => 'تسویه در $date';

  @override
  String deletePersonTitle(String name) => '$name حذف شود؟';

  @override
  String editedOn(String date) => 'ویرایش در $date';

  @override
  String wasValues(String values) => 'قبلاً: $values';

  @override
  String personCount(int count) => '$count نفر';

  @override
  String get askTitle => 'دربارهٔ هزینه‌هایت بپرس';

  @override
  String get askHint => 'روی یک پرسش بزن تا پاسخ را ببینی.';

  @override
  String get askCompareMonths => 'مقایسهٔ ماه‌ها';

  @override
  String get askTopCategory => 'بیشترین دسته';

  @override
  String get askVsLastMonth => 'در برابر ماه قبل';

  @override
  String get askBiggestExpense => 'بزرگ‌ترین هزینه';

  @override
  String get askTopDay => 'گران‌ترین روز';

  @override
  String get askWeekday => 'پرخرج‌ترین روز هفته';

  @override
  String get askMonthEnd => 'پیش‌بینی پایان ماه';

  @override
  String get askSaved => 'پس‌انداز کردم؟';

  @override
  String get askBudgetLeft => 'باقیماندهٔ بودجه';

  @override
  String get askHighestLowest => 'بیشترین و کمترین ماه';

  @override
  String get askCount => 'چند هزینه؟';

  @override
  String get askTopIncome => 'بیشترین درآمد';

  @override
  String get compareWith => 'مقایسه با';

  @override
  String get otherCategories => 'سایر';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'بیشترین هزینه برای $category: $amount ($percent از ماه).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'در $month نسبت به $other مبلغ $amount بیشتر خرج کردی (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'در $month نسبت به $other مبلغ $amount کمتر خرج کردی (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'در $month و $other به یک اندازه خرج کردی.';

  @override
  String answerNothingIn(String month) => 'در $month هزینه‌ای ثبت نشده است.';

  @override
  String answerRise(String category, String amount) =>
      'بیشترین افزایش: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'بیشترین کاهش: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'بزرگ‌ترین هزینه: $amount در $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'گران‌ترین روز: $date، با $amount هزینه.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'پرخرج‌ترین روز هفته: $weekday ($amount در این ماه).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'با این روند (حدود $average در روز) تا پایان ماه حدود $amount خرج می‌کنی.';

  @override
  String answerMonthTotal(String amount) =>
      'این ماه تمام شده است: در مجموع $amount خرج کردی.';

  @override
  String answerSaved(String amount, String income) =>
      'از درآمد $income، مبلغ $amount پس‌انداز کردی.';

  @override
  String answerOverspent(String amount) => '$amount بیشتر از درآمدت خرج کردی.';

  @override
  String get answerNoIncome => 'این ماه درآمدی ثبت نشده است.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      '$amount از بودجهٔ ماهانه‌ات مانده است ($percent مصرف شده).';

  @override
  String answerBudgetOver(String amount) =>
      '$amount از بودجهٔ ماهانه‌ات بیشتر خرج کردی.';

  @override
  String get answerNoBudget => 'هنوز بودجهٔ ماهانه تعیین نکرده‌ای.';

  @override
  String answerOverLimit(String names) => 'بیش از سقف: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'بیشترین ماه: $high ($highAmount). کمترین: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      '${expenseCount(count)} ثبت کردی، به‌طور میانگین هر کدام $average.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'بیشتر درآمدت از $category بود: $amount ($percent).';
}
