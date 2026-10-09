import '../../error/failures.dart';
import '../app_strings.dart';

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
  String get reminders => 'التذكيرات';

  @override
  String get dailyReminder => 'تذكير يومي';

  @override
  String get dailyReminderHint => 'تنبيه لتسجيل ما صرفته اليوم';

  @override
  String get reminderTime => 'الوقت';

  @override
  String get notificationsBlocked =>
      'الإشعارات متوقفة لهذا التطبيق. اسمح بها من إعدادات هاتفك.';

  @override
  String get reminderNotificationTitle => 'سجّل مصروفات اليوم';

  @override
  String get reminderNotificationBody => 'خذ لحظة لإضافة ما صرفته اليوم.';

  @override
  String get security => 'الأمان';

  @override
  String get appLock => 'قفل التطبيق';

  @override
  String get appLockHint => 'اطلب بصمتك أو وجهك أو قفل الشاشة عند فتح التطبيق';

  @override
  String get appLockUnavailable =>
      'اضبط قفل شاشة على هذا الهاتف لاستخدام هذه الميزة';

  @override
  String get unlock => 'فتح القفل';

  @override
  String get unlockToContinue => 'افتح القفل لرؤية ميزانيتك';

  @override
  String get confirmItsYou => 'أكّد هويتك لتغيير قفل التطبيق';

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
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String resetCodeSentTo(String email) =>
      'أرسلنا رمزًا إلى $email. أدخله مع كلمة مرور جديدة لحسابك.';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get saveNewPassword => 'حفظ كلمة المرور الجديدة';

  @override
  String get backToSignIn => 'العودة إلى تسجيل الدخول';

  @override
  String get backupHint =>
      'انسخ مصروفاتك احتياطيًا لتحتفظ بنسخة منها في حسابك. الاستعادة تنقل '
      'هذه النسخة إلى هذا الهاتف دون حذف أي شيء موجود عليه.';

  @override
  String get backUpNow => 'نسخ احتياطي الآن';

  @override
  String get autoBackup => 'نسخ احتياطي تلقائي';

  @override
  String get autoBackupHint =>
      'كلما غادرت التطبيق، تُنسخ التغييرات الجديدة احتياطيًا إلى حسابك.';

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
    FailureCode.categoryNameTaken => 'لديك فئة بهذا الاسم بالفعل.',
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
    FailureCode.pastedNotRecognized =>
      'النص الملصوق ليس بيانات يستطيع التطبيق قراءتها. انسخ رد الذكاء الاصطناعي كاملًا وحاول مجددًا، أو اطلب منه تصحيحه.',
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
  String get search => 'بحث';

  @override
  String get searchHint => 'ابحث في الملاحظات أو المبالغ';

  @override
  String get searchPrompt =>
      'ابحث عن أي معاملة بملاحظتها أو مبلغها، أو صفِّ حسب النوع والفئة والتاريخ.';

  @override
  String get noSearchResults => 'لا توجد معاملات مطابقة';

  @override
  String get allTypes => 'الكل';

  @override
  String get anyCategory => 'أي فئة';

  @override
  String get anyDate => 'أي تاريخ';

  @override
  String get clearFilters => 'مسح عوامل التصفية';

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
  String recurringReceived(String name) => 'تم تسجيل استلام $name';

  @override
  String get statusReceived => 'مستلمة';

  @override
  String get markAsReceived => 'تأكيد الاستلام';

  @override
  String get autoAdd => 'إضافة تلقائية';

  @override
  String get autoAddHint => 'تُسجَّل كدخل تلقائيًا في موعد استحقاقها.';

  @override
  String get monthlyIncomeAverage => 'الدخل كل شهر';

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

  @override
  String get importFromAi => 'من تطبيق آخر';

  @override
  String get importFromAiHint =>
      'حوّل بياناتك باستخدام ChatGPT أو Gemini أو Claude أو أي ذكاء اصطناعي';

  @override
  String get aiImportTitle => 'الاستيراد من تطبيق آخر';

  @override
  String get aiImportIntro =>
      'يمكن لمحادثة ذكاء اصطناعي تحويل بيانات من تطبيق آخر أو جدول بيانات إلى ملف يستطيع My Budget استيراده.';

  @override
  String get aiImportStep1 => 'انسخ النص الجاهز (البرومبت).';

  @override
  String get aiImportStep2 =>
      'الصقه في ChatGPT أو Gemini أو Claude أو أي ذكاء اصطناعي، ثم أرفق بياناتك أو الصقها.';

  @override
  String get aiImportStep3 =>
      'انسخ رد الذكاء الاصطناعي والصقه هنا، أو احفظه كملف واختره.';

  @override
  String get copyPrompt => 'نسخ البرومبت';

  @override
  String get pasteAnswer => 'لصق الرد';

  @override
  String get chooseFile => 'اختيار ملف';

  @override
  String get aiImportPrivacy =>
      'ستُرسل بياناتك إلى خدمة الذكاء الاصطناعي التي تختارها. سترى ما سيتم استيراده قبل أي تغيير.';

  @override
  String get promptCopied => 'تم نسخ البرومبت';

  @override
  String get askTitle => 'اسأل عن مصروفاتك';

  @override
  String get askHint => 'اضغط على سؤال لترى الإجابة.';

  @override
  String get askCompareMonths => 'قارن شهرين';

  @override
  String get askTopCategory => 'أعلى فئة';

  @override
  String get askVsLastMonth => 'مقابل الشهر الماضي';

  @override
  String get askBiggestExpense => 'أكبر مصروف';

  @override
  String get askTopDay => 'أغلى يوم';

  @override
  String get askWeekday => 'أكثر يوم بالأسبوع';

  @override
  String get askMonthEnd => 'توقع نهاية الشهر';

  @override
  String get askSaved => 'هل وفّرت؟';

  @override
  String get askBudgetLeft => 'المتبقي من الميزانية';

  @override
  String get askHighestLowest => 'أعلى وأقل شهر';

  @override
  String get askCount => 'كم مصروفًا؟';

  @override
  String get askTopIncome => 'أكبر دخل';

  @override
  String get otherCategories => 'أخرى';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'أكثر ما صرفت عليه $category: $amount ($percent من الشهر).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'صرفت في $month أكثر من $other بمقدار $amount (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'صرفت في $month أقل من $other بمقدار $amount (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'صرفت المبلغ نفسه في $month و$other.';

  @override
  String answerNothingIn(String month) => 'لم يُصرف شيء في $month.';

  @override
  String answerRise(String category, String amount) =>
      'أكبر زيادة: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'أكبر انخفاض: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'أكبر مصروف: $amount في $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'أغلى يوم: $date، صرفت فيه $amount.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'أكثر يوم تصرف فيه: $weekday ($amount هذا الشهر).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'بهذا المعدل (حوالي $average يوميًا) ستصرف قرابة $amount بنهاية الشهر.';

  @override
  String answerMonthTotal(String amount) =>
      'انتهى هذا الشهر: صرفت $amount إجمالًا.';

  @override
  String answerSaved(String amount, String income) =>
      'وفّرت $amount من دخلك البالغ $income.';

  @override
  String answerOverspent(String amount) => 'صرفت $amount أكثر من دخلك.';

  @override
  String get answerNoIncome => 'لا يوجد دخل مسجل هذا الشهر.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'المتبقي من ميزانيتك الشهرية $amount (استُخدم $percent).';

  @override
  String answerBudgetOver(String amount) =>
      'تجاوزت ميزانيتك الشهرية بمقدار $amount.';

  @override
  String get answerNoBudget => 'لم تحدد ميزانية شهرية بعد.';

  @override
  String answerOverLimit(String names) => 'تجاوزت حدها: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'أعلى شهر: $high ($highAmount). أقل شهر: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'سجلت ${expenseCount(count)}، بمتوسط $average للمصروف.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'أغلب دخلك من $category: $amount ($percent).';
}
