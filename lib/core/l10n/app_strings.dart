import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart';

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
      Localizations.of<AppStrings>(context, AppStrings) ??
      const AppStringsEn();

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
    NoticeCode.categoryAdded => categoryAdded(notice.name ?? ''),
    NoticeCode.categoryUpdated => categoryUpdated,
    NoticeCode.categoryDeleted => categoryDeleted(notice.name ?? ''),
    NoticeCode.categoryDeletedWithMoves => categoryDeletedWithMoves(
      notice.name ?? '',
      notice.count ?? 0,
    ),
    NoticeCode.failure => failure(
      notice.failure?.code ?? FailureCode.unknown,
    ),
  };

  String get expenseDeleted;
  String get expenseRestored;
  String categoryAdded(String name);
  String get categoryUpdated;
  String categoryDeleted(String name);
  String categoryDeletedWithMoves(String name, int count);
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
      'Tap Add to record your first expense for this month.';

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
      'Your expenses are stored only on this device.';

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
  String get emptyMonthHint => 'اضغط "إضافة" لتسجيل أول مصروف في هذا الشهر.';

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
  String get storedOnThisDevice => 'تُحفظ مصروفاتك على هذا الجهاز فقط.';

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
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppStrings.supportedLocales.any(
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
