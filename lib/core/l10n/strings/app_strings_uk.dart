import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsUk extends AppStrings {
  const AppStringsUk();

  @override
  String get localeName => 'uk';

  @override
  String get appTitle => 'Мій бюджет';

  @override
  String get add => 'Додати';

  @override
  String get undo => 'Скасувати';

  @override
  String get tryAgain => 'Спробувати ще';

  @override
  String get nothingRecordedYet => 'Поки нічого не записано';

  @override
  String get emptyMonthHint =>
      'Натисніть «Додати», щоб записати першу витрату чи дохід цього місяця.';

  @override
  String get yourMonths => 'Ваші місяці';

  @override
  String spentIn(String month) => 'Витрачено: $month';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count витрата',
    few: '$count витрати',
    many: '$count витрат',
    other: '$count витрати',
  );

  @override
  String get quickExpense => 'Швидка витрата';

  @override
  String get expenseSaved => 'Витрату збережено';

  @override
  String get newExpense => 'Нова витрата';

  @override
  String get editExpense => 'Змінити витрату';

  @override
  String get when => 'Коли';

  @override
  String get today => 'Сьогодні';

  @override
  String get yesterday => 'Учора';

  @override
  String get pickADate => 'Вибрати дату';

  @override
  String get category => 'Категорія';

  @override
  String get noteOptional => 'Нотатка (необов’язково)';

  @override
  String get noteHint => 'На що це було?';

  @override
  String get addExpense => 'Додати витрату';

  @override
  String get saveChanges => 'Зберегти';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Категорії';

  @override
  String get newCategory => 'Нова категорія';

  @override
  String get editCategory => 'Змінити категорію';

  @override
  String get addCategory => 'Додати категорію';

  @override
  String get categoryName => 'Назва';

  @override
  String get color => 'Колір';

  @override
  String get icon => 'Значок';

  @override
  String get builtIn => 'Вбудована';

  @override
  String get custom => 'Власна';

  @override
  String get edit => 'Змінити';

  @override
  String get delete => 'Видалити';

  @override
  String get cancel => 'Скасувати';

  @override
  String deleteCategoryTitle(String name) => 'Видалити «$name»?';

  @override
  String get deleteCategoryBody =>
      'Витрати з цієї категорії перейдуть до «Інше». Нічого не видаляється.';

  @override
  String get settings => 'Налаштування';

  @override
  String get appearance => 'Вигляд';

  @override
  String get themeSystem => 'Системна';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get language => 'Мова';

  @override
  String get languageSystem => 'Системна';

  @override
  String get currency => 'Валюта';

  @override
  String get currencySymbol => 'Символ';

  @override
  String get currencySymbolHint => 'Показується біля кожної суми';

  @override
  String get storedOnThisDevice =>
      'Ваші витрати зберігаються на цьому пристрої. Увійдіть, щоб зробити '
      'резервну копію.';

  @override
  String get account => 'Обліковий запис';

  @override
  String get accountOptional =>
      'Обліковий запис необов’язковий. Застосунок повністю працює і без '
      'нього.';

  @override
  String get signIn => 'Увійти';

  @override
  String get signOut => 'Вийти';

  @override
  String get signedIn => 'Ви увійшли';

  @override
  String get createAccount => 'Створити обліковий запис';

  @override
  String get noAccountYet => 'Немає облікового запису? Створіть';

  @override
  String get haveAnAccount => 'Уже маєте обліковий запис? Увійдіть';

  @override
  String get email => 'Ел. пошта';

  @override
  String get password => 'Пароль';

  @override
  String get passwordRules => 'Щонайменше 6 символів';

  @override
  String get confirmEmail => 'Підтвердьте пошту';

  @override
  String codeSentTo(String email) =>
      'Ми надіслали код на $email. Введіть його нижче, щоб завершити '
      'створення облікового запису.';

  @override
  String get confirmationCode => 'Код';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get resendCode => 'Надіслати новий код';

  @override
  String get codeResent => 'Новий код уже в дорозі';

  @override
  String get useDifferentEmail => 'Інша пошта';

  @override
  String get backupHint =>
      'Резервна копія зберігає ваші витрати в обліковому записі. Відновлення '
      'переносить цю копію на телефон, нічого не видаляючи з того, що вже '
      'тут є.';

  @override
  String get backUpNow => 'Створити копію';

  @override
  String get restoreData => 'Відновити';

  @override
  String get backingUp => 'Створюємо копію…';

  @override
  String get restoring => 'Відновлюємо…';

  @override
  String get backupDone => 'Копію створено';

  @override
  String get restoreDone => 'Відновлення завершено';

  @override
  String get neverSynced => 'Копії ще немає';

  @override
  String lastSynced(String when) => 'Остання синхронізація: $when';

  @override
  String get deleteAccount => 'Видалити обліковий запис';

  @override
  String get deleteAccountTitle => 'Видалити обліковий запис?';

  @override
  String get deleteAccountBody =>
      'Обліковий запис і збережену в ньому копію ваших витрат буде видалено '
      'назавжди. Це не можна скасувати. Витрати на цьому телефоні '
      'залишаться, і ви зможете користуватися застосунком без облікового '
      'запису.';

  @override
  String get deletingAccount => 'Видаляємо обліковий запис…';

  @override
  String get accountDeleted => 'Обліковий запис видалено';

  @override
  String get home => 'Головна';

  @override
  String get analyses => 'Аналіз';

  @override
  String get vsLastMonth => 'Порівняно з минулим місяцем';

  @override
  String get noComparison => 'Немає даних за минулий місяць';

  @override
  String get dailySpending => 'Витрати за днями';

  @override
  String get dailyAverage => 'У середньому за день';

  @override
  String get topDay => 'Найвитратніший день';

  @override
  String get byCategory => 'Витрати за категоріями';

  @override
  String get noSpendingThisMonth => 'Цього місяця витрат ще немає.';

  @override
  String get monthlyTrend => 'Останні 6 місяців';

  @override
  String lastMonthTotal(String amount) => 'Минулий місяць: $amount';

  @override
  String get budgets => 'Бюджети';

  @override
  String get monthlyBudget => 'Бюджет на місяць';

  @override
  String get setMonthlyBudget => 'Задайте бюджет на місяць';

  @override
  String get setBudgetHint =>
      'Видно, скільки лишилося, і ви дізнаєтеся заздалегідь, якщо витрачаєте '
      'забагато.';

  @override
  String get setBudget => 'Задати';

  @override
  String get editBudget => 'Змінити бюджет';

  @override
  String get removeBudget => 'Прибрати';

  @override
  String get save => 'Зберегти';

  @override
  String amountLeft(String amount) => 'Лишилося $amount';

  @override
  String amountOver(String amount) => 'Понад бюджет на $amount';

  @override
  String spentOfLimit(String spent, String limit) =>
      'Витрачено $spent із $limit';

  @override
  String amountSpent(String amount) => 'Витрачено $amount';

  @override
  String budgetUsed(String percent) => 'Використано $percent бюджету';

  @override
  String get categoryBudgets => 'Бюджети категорій';

  @override
  String get categoryBudgetsHint => 'Обмежте витрати в окремій категорії.';

  @override
  String categoryBudgetTitle(String name) => 'Бюджет: $name';

  @override
  String get setLimit => 'Задати ліміт';

  @override
  String get closeToLimit => 'Близько до ліміту';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Бюджети повторюються щомісяця. Ви отримаєте попередження, коли '
      'витрати перевищать $nearing, і ще одне на $reached.';

  @override
  String get budgetAlertTitle => 'Бюджет';

  @override
  String get ok => 'Гаразд';

  @override
  String get view => 'Відкрити';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Ви використали $percent бюджету на місяць';

  @override
  String get monthlyBudgetUsedUp => 'Бюджет на місяць вичерпано';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Бюджет на місяць перевищено на $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Ви використали $percent бюджету «$name»';

  @override
  String categoryBudgetUsedUp(String name) => 'Бюджет «$name» вичерпано';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Бюджет «$name» перевищено на $amount';

  @override
  String get dataManagement => 'Керування даними';

  @override
  String get dataManagementHint =>
      'Файли, які ви зберігаєте самі. Працюють без інтернету й без '
      'облікового запису.';

  @override
  String get backUpToFile => 'Резервна копія даних';

  @override
  String get backUpToFileHint =>
      'Повний файл копії, який можна імпортувати пізніше';

  @override
  String get exportCsv => 'Експорт у CSV';

  @override
  String get exportCsvHint => 'Для Excel або Google Таблиць';

  @override
  String get exportPdf => 'Експорт у PDF';

  @override
  String get exportPdfHint => 'Звіт для читання, друку чи надсилання';

  @override
  String get importData => 'Імпорт даних';

  @override
  String get importDataHint => 'Відновити з файлу копії';

  @override
  String get preparingFile => 'Готуємо файл…';

  @override
  String get importingData => 'Імпортуємо…';

  @override
  String get fileSaved => 'Файл збережено';

  @override
  String get importDone => 'Імпорт завершено';

  @override
  String get importNothingNew => 'На цьому телефоні вже є все з копії';

  @override
  String get fileReady => 'Файл готовий';

  @override
  String get shareFile => 'Поділитися';

  @override
  String get shareFileHint => 'WhatsApp, пошта, Google Диск та інше';

  @override
  String get saveToPhone => 'Зберегти на телефоні';

  @override
  String get saveToPhoneHint => 'Виберіть, де зберігати';

  @override
  String get importTitle => 'Імпортувати цю копію?';

  @override
  String get importMergeHint =>
      'Об’єднання зберігає все на телефоні й додає те, чого бракує. Якщо '
      'запис відрізняється, перемагає новіша зміна.';

  @override
  String get merge => 'Об’єднати';

  @override
  String get replaceEverything => 'Замінити все';

  @override
  String get replaceTitle => 'Замінити все на телефоні?';

  @override
  String get replaceBody =>
      'Усе на телефоні, чого немає в копії, буде видалено, а для кожного '
      'запису буде використано версію з копії. Це не можна скасувати.';

  @override
  String get replace => 'Замінити';

  @override
  String get colDate => 'Дата';

  @override
  String get colMonth => 'Місяць';

  @override
  String get colAmount => 'Сума';

  @override
  String get colNote => 'Нотатка';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Операції';

  @override
  String get colTotal => 'Разом';

  @override
  String get colShare => 'Частка';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get reportTitle => 'Мій бюджет: звіт про витрати';

  @override
  String get reportPeriod => 'Період';

  @override
  String get reportTotal => 'Усього витрачено';

  @override
  String get reportMonthlyAverage => 'У середньому за місяць';

  @override
  String get reportByMonth => 'Витрати за місяцями';

  @override
  String get reportAllExpenses => 'Усі витрати';

  @override
  String get reportEmpty => 'Витрат поки немає.';

  @override
  String get reportPageTemplate => 'Сторінка {page} з {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} і ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} і '
              '${personCount(people)}';
    return date == null
        ? 'У цій копії: $contents.'
        : 'Копія від $date: $contents.';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count категорія',
    few: '$count категорії',
    many: '$count категорій',
    other: '$count категорії',
  );

  @override
  String reportGenerated(String when) => 'Створено $when';

  @override
  String get showPassword => 'Показати пароль';

  @override
  String get hidePassword => 'Приховати пароль';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Їжа',
    'cat_transport' => 'Транспорт',
    'cat_bills' => 'Рахунки',
    'cat_shopping' => 'Покупки',
    'cat_health' => 'Здоров’я і спорт',
    'cat_entertainment' => 'Розваги',
    'cat_work' => 'Робота',
    'cat_other' => 'Інше',
    'cat_salary' => 'Зарплата',
    'cat_freelance' => 'Фриланс',
    'cat_investments' => 'Інвестиції',
    'cat_gifts' => 'Подарунки',
    'cat_income_other' => 'Інший дохід',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'Не вдалося зберегти на пристрої. Спробуйте ще раз.',
    FailureCode.notFound => 'Цього запису більше немає.',
    FailureCode.unknown => 'Щось пішло не так.',
    FailureCode.amountRequired => 'Введіть суму більше нуля.',
    FailureCode.amountTooLarge => 'Завелика сума.',
    FailureCode.amountInvalid => 'Введіть правильну суму.',
    FailureCode.categoryRequired => 'Виберіть категорію.',
    FailureCode.categoryNameRequired => 'Дайте категорії назву.',
    FailureCode.categoryNameTooLong =>
      'Назва має бути коротшою за 30 символів.',
    FailureCode.categoryProtected => 'Цю категорію не можна видалити.',
    FailureCode.currencySymbolInvalid => 'Використайте від 1 до 4 символів.',
    FailureCode.network =>
      'Немає з’єднання. Перевірте інтернет і спробуйте ще раз.',
    FailureCode.emailInvalid => 'Введіть правильну адресу пошти.',
    FailureCode.passwordTooShort => 'Пароль має містити щонайменше 6 символів.',
    FailureCode.invalidCredentials => 'Неправильна пошта або пароль.',
    FailureCode.emailTaken => 'Обліковий запис із цією поштою вже існує.',
    FailureCode.emailNotConfirmed =>
      'Спершу підтвердьте пошту кодом, який ми надіслали.',
    FailureCode.codeInvalid => 'Код неправильний або застарів.',
    FailureCode.signInRequired => 'Увійдіть знову й повторіть спробу.',
    FailureCode.syncOtherAccount =>
      'Дані на цьому телефоні прив’язані до іншого облікового запису.',
    FailureCode.syncFailed =>
      'Не вдалося синхронізувати з обліковим записом. Спробуйте ще раз.',
    FailureCode.accountDeletionFailed =>
      'Не вдалося видалити обліковий запис. Спробуйте ще раз.',
    FailureCode.backupNotRecognized => 'Цей файл не є копією «Мого бюджету».',
    FailureCode.backupTooNew =>
      'Цю копію створено в новішій версії «Мого бюджету». Оновіть '
          'застосунок і спробуйте ще раз.',
    FailureCode.backupDamaged =>
      'Файл копії пошкоджено, тому нічого не імпортовано.',
    FailureCode.fileUnavailable =>
      'Не вдалося відкрити файл. Спробуйте вибрати його ще раз.',
    FailureCode.storageFull => 'На телефоні бракує вільного місця.',
    FailureCode.exportFailed => 'Не вдалося створити файл. Спробуйте ще раз.',
    FailureCode.shareUnavailable => 'Не вдалося відкрити меню «Поділитися».',
    FailureCode.saveFailed => 'Не вдалося зберегти файл. Спробуйте ще раз.',
    FailureCode.tooManyAttempts =>
      'Забагато спроб. Зачекайте трохи й спробуйте знову.',
    FailureCode.titleRequired => 'Дайте назву.',
    FailureCode.titleTooLong => 'Назва має бути коротшою за 40 символів.',
    FailureCode.dueDayInvalid => 'Виберіть термін оплати.',
    FailureCode.alreadyPaid => 'Цей платіж уже записано.',
    FailureCode.personRequired => 'Виберіть людину.',
    FailureCode.personNameRequired => 'Введіть ім’я.',
    FailureCode.personNameTooLong => 'Ім’я має бути коротшим за 40 символів.',
    FailureCode.phoneInvalid => 'Введіть правильний номер телефону.',
    FailureCode.transactionSettled => 'Закриті операції не можна змінити.',
    FailureCode.nothingToSettle => 'Нічого закривати.',
    FailureCode.settlementAlreadyLogged =>
      'Цей розрахунок уже є у вашому бюджеті.',
  };

  @override
  String get expenseDeleted => 'Витрату видалено';

  @override
  String get expenseRestored => 'Витрату відновлено';

  @override
  String categoryAdded(String name) => '«$name» додано';

  @override
  String get categoryUpdated => 'Категорію оновлено';

  @override
  String categoryDeleted(String name) => '«$name» видалено';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '«$name» видалено — ${expenseCount(count)} перенесено до «Інше»';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '«$name» видалено — ${transactionCount(count)} перенесено до «Інший '
      'дохід»';

  @override
  String get expense => 'Витрата';

  @override
  String get income => 'Дохід';

  @override
  String get transactionType => 'Витрата чи дохід';

  @override
  String get quickIncome => 'Швидкий дохід';

  @override
  String get newIncome => 'Новий дохід';

  @override
  String get editIncome => 'Змінити дохід';

  @override
  String get addIncome => 'Додати дохід';

  @override
  String get incomeNoteHint => 'Звідки він?';

  @override
  String get totalIncome => 'Усього доходів';

  @override
  String get totalExpenses => 'Усього витрат';

  @override
  String get netBalance => 'Підсумковий баланс';

  @override
  String get savingsRate => 'Норма заощаджень';

  @override
  String get savingsRateNoIncome =>
      'Додайте дохід, щоб побачити норму заощаджень';

  @override
  String get expenseCategories => 'Категорії витрат';

  @override
  String get incomeCategories => 'Категорії доходів';

  @override
  String get deleteIncomeCategoryBody =>
      'Доходи з цієї категорії перейдуть до «Інший дохід». Нічого не '
      'видаляється.';

  @override
  String get incomeDeleted => 'Дохід видалено';

  @override
  String get incomeRestored => 'Дохід відновлено';

  @override
  String get colType => 'Тип';

  @override
  String transactionCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count операція',
    few: '$count операції',
    many: '$count операцій',
    other: '$count операції',
  );

  @override
  String get recurringPayments => 'Регулярні платежі';

  @override
  String get newRecurring => 'Новий регулярний платіж';

  @override
  String get editRecurring => 'Змінити регулярний платіж';

  @override
  String get addRecurring => 'Додати платіж';

  @override
  String get recurringTitle => 'Назва';

  @override
  String get recurringTitleHint => 'Оренда, Netflix, спортзал…';

  @override
  String get amount => 'Сума';

  @override
  String get repeats => 'Повтор';

  @override
  String get weekly => 'Тиждень';

  @override
  String get monthly => 'Місяць';

  @override
  String get yearly => 'Рік';

  @override
  String get dueOn => 'Термін';

  @override
  String get dueDayOfMonth => 'День місяця';

  @override
  String get dueMonthLabel => 'Місяць';

  @override
  String get dueDayLabel => 'День';

  @override
  String get shortMonthHint => 'У коротших місяцях — в останній день.';

  @override
  String get whenDue => 'Коли настає термін';

  @override
  String get autoDeduct => 'Автосписання';

  @override
  String get remindMe => 'Нагадати';

  @override
  String get autoDeductHint =>
      'У день оплати автоматично записується як витрата.';

  @override
  String get remindMeHint =>
      'Кожен платіж треба буде підтвердити перед записом.';

  @override
  String get statusPaid => 'Оплачено';

  @override
  String get statusUpcoming => 'Очікується';

  @override
  String get statusOverdue => 'Прострочено';

  @override
  String get markAsPaid => 'Оплачено';

  @override
  String get dueToday => 'Термін сьогодні';

  @override
  String dueOnDate(String date) => 'Термін: $date';

  @override
  String nextDueOn(String date) => 'Наступний: $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Термін був $date'
      : '${paymentCount(count)} прострочено з $date';

  @override
  String everyWeekday(String weekday) => 'Щотижня: $weekday';

  @override
  String monthlyOnDay(String day) => 'Щомісяця, $day-го числа';

  @override
  String yearlyOn(String date) => 'Щороку, $date';

  @override
  String get monthlyAverage => 'На місяць';

  @override
  String get monthlyAverageHint => 'Усі регулярні платежі в середньому';

  @override
  String get noRecurringYet => 'Регулярних платежів поки немає';

  @override
  String get noRecurringHint =>
      'Додайте оренду, рахунки й підписки один раз. Щомісяця буде видно, що '
      'оплачено, а що ще ні.';

  @override
  String get paymentsToConfirm => 'Платежі до підтвердження';

  @override
  String get seeAll => 'Усі';

  @override
  String get deleteRecurringBody =>
      'Платіж перестане повторюватися. Уже записані платежі залишаться у '
      'ваших операціях.';

  @override
  String recurringPaid(String name) => '«$name» позначено як оплачене';

  @override
  String get recurringPaymentUndone => 'Платіж прибрано';

  @override
  String recurringAutoLogged(int count) => plural(
    count,
    locale: localeName,
    one: 'Автоматично записано $count регулярний платіж',
    few: 'Автоматично записано $count регулярні платежі',
    many: 'Автоматично записано $count регулярних платежів',
    other: 'Автоматично записано $count регулярного платежу',
  );

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count платіж',
    few: '$count платежі',
    many: '$count платежів',
    other: '$count платежу',
  );

  @override
  String get colPaidThrough => 'Оплачено до';

  // People & debts

  @override
  String get people => 'Люди';

  @override
  String get peopleAndDebts => 'Люди й борги';

  @override
  String get person => 'Людина';

  @override
  String get personName => 'Ім’я';

  @override
  String get phone => 'Телефон';

  @override
  String get phoneOptional => 'Телефон (необов’язково)';

  @override
  String get balance => 'Баланс';

  @override
  String get colStatus => 'Статус';

  @override
  String get owesYou => 'Винен вам';

  @override
  String get youOwe => 'Ви винні';

  @override
  String get owedToYou => 'Вам винні';

  @override
  String get settledUp => 'Розраховано';

  @override
  String get iPaidForThem => 'Я заплатив(ла) за нього';

  @override
  String get theyPaidForMe => 'Заплатив(ла) за мене';

  @override
  String get theyPaidYou => 'Заплатив(ла) вам';

  @override
  String get youPaidThem => 'Ви заплатили';

  @override
  String get openStatus => 'Відкрито';

  @override
  String get settledStatus => 'Закрито';

  @override
  String get settledOn => 'Закрито';

  @override
  String get createdOn => 'Створено';

  @override
  String get lastEdited => 'Змінено';

  @override
  String get colEdits => 'Правки';

  @override
  String get activeTransactions => 'Відкриті операції';

  @override
  String get settledHistory => 'Історія розрахунків';

  @override
  String get filterAll => 'Усі';

  @override
  String get filterOwedToMe => 'Мені винні';

  @override
  String get filterIOwe => 'Я винен';

  @override
  String get filterSettled => 'Закрито';

  @override
  String get addPerson => 'Додати людину';

  @override
  String get addPersonHint => 'Той, з ким ви ділите витрати';

  @override
  String get newPerson => 'Нова людина';

  @override
  String get editPerson => 'Змінити';

  @override
  String get deletePerson => 'Видалити людину';

  @override
  String get quickTransaction => 'Швидка операція';

  @override
  String get quickTransactionHint =>
      'Запишіть, хто платив, з однією з доданих людей';

  @override
  String get noPeopleYet => 'Поки нікого немає';

  @override
  String get noPeopleHint =>
      'Додайте тих, з ким ділите витрати, щоб бачити, хто кому винен.';

  @override
  String get nobodyHere => 'Під цей фільтр ніхто не підходить.';

  @override
  String get addPersonFirst => 'Спершу додайте людину.';

  @override
  String get newTransaction => 'Нова операція';

  @override
  String get editTransaction => 'Змінити операцію';

  @override
  String get transactionDetails => 'Подробиці операції';

  @override
  String get debtNoteHint => 'На що це було?';

  @override
  String get changeHistory => 'Історія змін';

  @override
  String get edited => 'Змінено';

  @override
  String get settleUp => 'Розрахуватися';

  @override
  String get settle => 'Закрити';

  @override
  String get noDebtsYet => 'Поки нічого не записано';

  @override
  String get noDebtsHint =>
      'Додайте, що ви заплатили за цю людину або вона за вас.';

  @override
  String get settleEven =>
      'Ці операції взаємно погашаються, тож нікому нічого не треба платити.';

  @override
  String get logSettlementTitle =>
      'Записати цей розрахунок у бюджет на місяць?';

  @override
  String get loggedInBudget => 'У вашому бюджеті';

  @override
  String get deleteTransactionTitle => 'Видалити цю операцію?';

  @override
  String get deleteTransactionBody =>
      'Її буде прибрано з балансу з цією людиною.';

  @override
  String get deletePersonBody =>
      'Її операції та історію розрахунків теж буде видалено. Те, що ви '
      'записали в бюджет, залишиться.';

  @override
  String get settledLocked => 'Операцію закрито, її вже не можна змінити.';

  @override
  String get personUpdated => 'Дані оновлено';

  @override
  String get debtDeleted => 'Операцію видалено';

  @override
  String get settledUpNotice => 'Усі розрахунки закрито';

  @override
  String get settlementLogged => 'Додано до бюджету';

  @override
  String personOwesYou(String name) => '$name винен вам';

  @override
  String youOwePerson(String name) => 'Ви винні: $name';

  @override
  String settledWith(String name) => 'З $name все розраховано';

  @override
  String settleUpFor(String amount) => 'Розрахуватися: $amount';

  @override
  String settleTitle(String name) => 'Розрахуватися з $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name платить вам $amount, і боргів не лишається.';

  @override
  String settleYouPay(String name, String amount) =>
      'Ви платите $name $amount, і боргів не лишається.';

  @override
  String settleMoves(int count) =>
      'До історії розрахунків перейде: ${transactionCount(count)}.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount буде додано як дохід до «Інший дохід». Пізніше можна '
      'перенести в іншу категорію.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount буде додано як витрату до «Інше». Пізніше можна перенести в '
      'іншу категорію.';

  @override
  String settlementNote(String name) => 'Розрахунок із $name';

  @override
  String settledGroupTitle(String date) => 'Закрито $date';

  @override
  String deletePersonTitle(String name) => 'Видалити $name?';

  @override
  String editedOn(String date) => 'Змінено $date';

  @override
  String wasValues(String values) => 'Було: $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count людина',
    few: '$count людини',
    many: '$count людей',
    other: '$count людини',
  );
}
