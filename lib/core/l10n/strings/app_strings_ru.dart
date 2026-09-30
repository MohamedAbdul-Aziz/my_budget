import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsRu extends AppStrings {
  const AppStringsRu();

  @override
  String get localeName => 'ru';

  @override
  String get appTitle => 'Мой бюджет';

  @override
  String get add => 'Добавить';

  @override
  String get undo => 'Отменить';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get nothingRecordedYet => 'Пока ничего не записано';

  @override
  String get emptyMonthHint =>
      'Нажмите «Добавить», чтобы записать первый расход или доход в этом '
      'месяце.';

  @override
  String get yourMonths => 'Ваши месяцы';

  @override
  String spentIn(String month) => 'Потрачено: $month';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count расход',
    few: '$count расхода',
    many: '$count расходов',
    other: '$count расхода',
  );

  @override
  String get quickExpense => 'Быстрый расход';

  @override
  String get expenseSaved => 'Расход сохранён';

  @override
  String get newExpense => 'Новый расход';

  @override
  String get editExpense => 'Изменить расход';

  @override
  String get when => 'Когда';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get pickADate => 'Выбрать дату';

  @override
  String get category => 'Категория';

  @override
  String get noteOptional => 'Заметка (необязательно)';

  @override
  String get noteHint => 'На что это было?';

  @override
  String get addExpense => 'Добавить расход';

  @override
  String get saveChanges => 'Сохранить';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Категории';

  @override
  String get newCategory => 'Новая категория';

  @override
  String get editCategory => 'Изменить категорию';

  @override
  String get addCategory => 'Добавить категорию';

  @override
  String get categoryName => 'Название';

  @override
  String get color => 'Цвет';

  @override
  String get icon => 'Значок';

  @override
  String get builtIn => 'Встроенная';

  @override
  String get custom => 'Своя';

  @override
  String get edit => 'Изменить';

  @override
  String get delete => 'Удалить';

  @override
  String get cancel => 'Отмена';

  @override
  String deleteCategoryTitle(String name) => 'Удалить «$name»?';

  @override
  String get deleteCategoryBody =>
      'Расходы из этой категории перейдут в «Другое». Ничего не удаляется.';

  @override
  String get settings => 'Настройки';

  @override
  String get appearance => 'Оформление';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Системный';

  @override
  String get currency => 'Валюта';

  @override
  String get currencySymbol => 'Символ';

  @override
  String get currencySymbolHint => 'Показывается рядом с каждой суммой';

  @override
  String get storedOnThisDevice =>
      'Ваши расходы хранятся на этом устройстве. Войдите, чтобы сделать '
      'резервную копию.';

  @override
  String get account => 'Аккаунт';

  @override
  String get accountOptional =>
      'Аккаунт не обязателен. Приложение полностью работает и без него.';

  @override
  String get signIn => 'Войти';

  @override
  String get signOut => 'Выйти';

  @override
  String get signedIn => 'Вы вошли';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get noAccountYet => 'Нет аккаунта? Создайте его';

  @override
  String get haveAnAccount => 'Уже есть аккаунт? Войдите';

  @override
  String get email => 'Эл. почта';

  @override
  String get password => 'Пароль';

  @override
  String get passwordRules => 'Не меньше 6 символов';

  @override
  String get confirmEmail => 'Подтвердите почту';

  @override
  String codeSentTo(String email) =>
      'Мы отправили код на $email. Введите его ниже, чтобы завершить '
      'создание аккаунта.';

  @override
  String get confirmationCode => 'Код';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get resendCode => 'Отправить новый код';

  @override
  String get codeResent => 'Новый код уже в пути';

  @override
  String get useDifferentEmail => 'Другая почта';

  @override
  String get backupHint =>
      'Резервная копия сохраняет ваши расходы в аккаунте. Восстановление '
      'переносит эту копию на телефон, ничего не удаляя из того, что уже '
      'здесь есть.';

  @override
  String get backUpNow => 'Создать копию';

  @override
  String get restoreData => 'Восстановить';

  @override
  String get backingUp => 'Создаём копию…';

  @override
  String get restoring => 'Восстанавливаем…';

  @override
  String get backupDone => 'Копия создана';

  @override
  String get restoreDone => 'Восстановление завершено';

  @override
  String get neverSynced => 'Копии ещё нет';

  @override
  String lastSynced(String when) => 'Последняя синхронизация: $when';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountBody =>
      'Аккаунт и сохранённая в нём копия ваших расходов будут удалены '
      'навсегда. Это нельзя отменить. Расходы на этом телефоне останутся, и '
      'вы сможете пользоваться приложением без аккаунта.';

  @override
  String get deletingAccount => 'Удаляем аккаунт…';

  @override
  String get accountDeleted => 'Аккаунт удалён';

  @override
  String get home => 'Главная';

  @override
  String get analyses => 'Анализ';

  @override
  String get vsLastMonth => 'По сравнению с прошлым месяцем';

  @override
  String get noComparison => 'Нет данных за прошлый месяц';

  @override
  String get dailySpending => 'Расходы по дням';

  @override
  String get dailyAverage => 'В среднем за день';

  @override
  String get topDay => 'Самый затратный день';

  @override
  String get byCategory => 'Расходы по категориям';

  @override
  String get noSpendingThisMonth => 'В этом месяце расходов пока нет.';

  @override
  String get monthlyTrend => 'Последние 6 месяцев';

  @override
  String lastMonthTotal(String amount) => 'Прошлый месяц: $amount';

  @override
  String get budgets => 'Бюджеты';

  @override
  String get monthlyBudget => 'Бюджет на месяц';

  @override
  String get setMonthlyBudget => 'Задайте бюджет на месяц';

  @override
  String get setBudgetHint =>
      'Видно, сколько осталось, и вы узнаете заранее, если тратите слишком '
      'много.';

  @override
  String get setBudget => 'Задать';

  @override
  String get editBudget => 'Изменить бюджет';

  @override
  String get removeBudget => 'Убрать';

  @override
  String get save => 'Сохранить';

  @override
  String amountLeft(String amount) => 'Осталось $amount';

  @override
  String amountOver(String amount) => 'Сверх бюджета на $amount';

  @override
  String spentOfLimit(String spent, String limit) =>
      'Потрачено $spent из $limit';

  @override
  String amountSpent(String amount) => 'Потрачено $amount';

  @override
  String budgetUsed(String percent) => 'Использовано $percent бюджета';

  @override
  String get categoryBudgets => 'Бюджеты категорий';

  @override
  String get categoryBudgetsHint => 'Ограничьте траты в отдельной категории.';

  @override
  String categoryBudgetTitle(String name) => 'Бюджет: $name';

  @override
  String get setLimit => 'Задать лимит';

  @override
  String get closeToLimit => 'Близко к лимиту';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Бюджеты повторяются каждый месяц. Вы получите предупреждение, когда '
      'расходы превысят $nearing, и ещё одно на $reached.';

  @override
  String get budgetAlertTitle => 'Бюджет';

  @override
  String get ok => 'ОК';

  @override
  String get view => 'Открыть';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Вы использовали $percent бюджета на месяц';

  @override
  String get monthlyBudgetUsedUp => 'Бюджет на месяц исчерпан';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Бюджет на месяц превышен на $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Вы использовали $percent бюджета «$name»';

  @override
  String categoryBudgetUsedUp(String name) => 'Бюджет «$name» исчерпан';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Бюджет «$name» превышен на $amount';

  @override
  String get dataManagement => 'Управление данными';

  @override
  String get dataManagementHint =>
      'Файлы, которые вы храните сами. Работают без интернета и без '
      'аккаунта.';

  @override
  String get backUpToFile => 'Резервная копия данных';

  @override
  String get backUpToFileHint =>
      'Полный файл копии, который можно импортировать позже';

  @override
  String get exportCsv => 'Экспорт в CSV';

  @override
  String get exportCsvHint => 'Для Excel или Google Таблиц';

  @override
  String get exportPdf => 'Экспорт в PDF';

  @override
  String get exportPdfHint => 'Отчёт для чтения, печати или отправки';

  @override
  String get importData => 'Импорт данных';

  @override
  String get importDataHint => 'Восстановить из файла копии';

  @override
  String get preparingFile => 'Готовим файл…';

  @override
  String get importingData => 'Импортируем…';

  @override
  String get fileSaved => 'Файл сохранён';

  @override
  String get importDone => 'Импорт завершён';

  @override
  String get importNothingNew => 'На этом телефоне уже есть всё из копии';

  @override
  String get fileReady => 'Файл готов';

  @override
  String get shareFile => 'Поделиться';

  @override
  String get shareFileHint => 'WhatsApp, почта, Google Диск и другое';

  @override
  String get saveToPhone => 'Сохранить на телефоне';

  @override
  String get saveToPhoneHint => 'Выберите, где хранить';

  @override
  String get importTitle => 'Импортировать эту копию?';

  @override
  String get importMergeHint =>
      'Объединение сохраняет всё на телефоне и добавляет недостающее. Если '
      'запись отличается, побеждает более новое изменение.';

  @override
  String get merge => 'Объединить';

  @override
  String get replaceEverything => 'Заменить всё';

  @override
  String get replaceTitle => 'Заменить всё на телефоне?';

  @override
  String get replaceBody =>
      'Всё на телефоне, чего нет в копии, будет удалено, а для каждой записи '
      'будет использована версия из копии. Это нельзя отменить.';

  @override
  String get replace => 'Заменить';

  @override
  String get colDate => 'Дата';

  @override
  String get colMonth => 'Месяц';

  @override
  String get colAmount => 'Сумма';

  @override
  String get colNote => 'Заметка';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Операции';

  @override
  String get colTotal => 'Итого';

  @override
  String get colShare => 'Доля';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get reportTitle => 'Мой бюджет: отчёт о расходах';

  @override
  String get reportPeriod => 'Период';

  @override
  String get reportTotal => 'Всего потрачено';

  @override
  String get reportMonthlyAverage => 'В среднем за месяц';

  @override
  String get reportByMonth => 'Расходы по месяцам';

  @override
  String get reportAllExpenses => 'Все расходы';

  @override
  String get reportEmpty => 'Расходов пока нет.';

  @override
  String get reportPageTemplate => 'Страница {page} из {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} и ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} и '
              '${personCount(people)}';
    return date == null
        ? 'В этой копии: $contents.'
        : 'Копия от $date: $contents.';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count категория',
    few: '$count категории',
    many: '$count категорий',
    other: '$count категории',
  );

  @override
  String reportGenerated(String when) => 'Создан $when';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Еда',
    'cat_transport' => 'Транспорт',
    'cat_bills' => 'Счета',
    'cat_shopping' => 'Покупки',
    'cat_health' => 'Здоровье и спорт',
    'cat_entertainment' => 'Развлечения',
    'cat_work' => 'Работа',
    'cat_other' => 'Другое',
    'cat_salary' => 'Зарплата',
    'cat_freelance' => 'Фриланс',
    'cat_investments' => 'Инвестиции',
    'cat_gifts' => 'Подарки',
    'cat_income_other' => 'Другой доход',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'Не удалось сохранить на устройстве. Попробуйте ещё раз.',
    FailureCode.notFound => 'Этой записи больше нет.',
    FailureCode.unknown => 'Что-то пошло не так.',
    FailureCode.amountRequired => 'Введите сумму больше нуля.',
    FailureCode.amountTooLarge => 'Слишком большая сумма.',
    FailureCode.amountInvalid => 'Введите правильную сумму.',
    FailureCode.categoryRequired => 'Выберите категорию.',
    FailureCode.categoryNameRequired => 'Дайте категории название.',
    FailureCode.categoryNameTooLong =>
      'Название должно быть короче 30 символов.',
    FailureCode.categoryProtected => 'Эту категорию нельзя удалить.',
    FailureCode.currencySymbolInvalid => 'Используйте от 1 до 4 символов.',
    FailureCode.network =>
      'Нет соединения. Проверьте интернет и попробуйте ещё раз.',
    FailureCode.emailInvalid => 'Введите правильный адрес почты.',
    FailureCode.passwordTooShort => 'Пароль должен быть не короче 6 символов.',
    FailureCode.invalidCredentials => 'Неверная почта или пароль.',
    FailureCode.emailTaken => 'Аккаунт с этой почтой уже существует.',
    FailureCode.emailNotConfirmed =>
      'Сначала подтвердите почту кодом, который мы отправили.',
    FailureCode.codeInvalid => 'Код неверный или устарел.',
    FailureCode.signInRequired => 'Войдите снова и повторите попытку.',
    FailureCode.syncOtherAccount =>
      'Данные на этом телефоне привязаны к другому аккаунту.',
    FailureCode.syncFailed =>
      'Не удалось синхронизировать с аккаунтом. Попробуйте ещё раз.',
    FailureCode.accountDeletionFailed =>
      'Не удалось удалить аккаунт. Попробуйте ещё раз.',
    FailureCode.backupNotRecognized =>
      'Этот файл не является копией «Моего бюджета».',
    FailureCode.backupTooNew =>
      'Эта копия создана в более новой версии «Моего бюджета». Обновите '
          'приложение и попробуйте ещё раз.',
    FailureCode.backupDamaged =>
      'Файл копии повреждён, поэтому ничего не импортировано.',
    FailureCode.fileUnavailable =>
      'Не удалось открыть файл. Попробуйте выбрать его снова.',
    FailureCode.storageFull => 'На телефоне недостаточно свободного места.',
    FailureCode.exportFailed => 'Не удалось создать файл. Попробуйте ещё раз.',
    FailureCode.shareUnavailable => 'Не удалось открыть меню «Поделиться».',
    FailureCode.saveFailed => 'Не удалось сохранить файл. Попробуйте ещё раз.',
    FailureCode.tooManyAttempts =>
      'Слишком много попыток. Подождите немного и попробуйте снова.',
    FailureCode.titleRequired => 'Дайте название.',
    FailureCode.titleTooLong => 'Название должно быть короче 40 символов.',
    FailureCode.dueDayInvalid => 'Выберите срок оплаты.',
    FailureCode.alreadyPaid => 'Этот платёж уже записан.',
    FailureCode.personRequired => 'Выберите человека.',
    FailureCode.personNameRequired => 'Введите имя.',
    FailureCode.personNameTooLong => 'Имя должно быть короче 40 символов.',
    FailureCode.phoneInvalid => 'Введите правильный номер телефона.',
    FailureCode.transactionSettled => 'Закрытые операции нельзя изменить.',
    FailureCode.nothingToSettle => 'Нечего закрывать.',
    FailureCode.settlementAlreadyLogged =>
      'Этот расчёт уже есть в вашем бюджете.',
  };

  @override
  String get expenseDeleted => 'Расход удалён';

  @override
  String get expenseRestored => 'Расход восстановлен';

  @override
  String categoryAdded(String name) => '«$name» добавлено';

  @override
  String get categoryUpdated => 'Категория обновлена';

  @override
  String categoryDeleted(String name) => '«$name» удалено';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '«$name» удалена — ${expenseCount(count)} перенесено в «Другое»';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '«$name» удалена — ${transactionCount(count)} перенесено в «Другой '
      'доход»';

  @override
  String get expense => 'Расход';

  @override
  String get income => 'Доход';

  @override
  String get transactionType => 'Расход или доход';

  @override
  String get quickIncome => 'Быстрый доход';

  @override
  String get newIncome => 'Новый доход';

  @override
  String get editIncome => 'Изменить доход';

  @override
  String get addIncome => 'Добавить доход';

  @override
  String get incomeNoteHint => 'Откуда он?';

  @override
  String get totalIncome => 'Всего доходов';

  @override
  String get totalExpenses => 'Всего расходов';

  @override
  String get netBalance => 'Итоговый баланс';

  @override
  String get savingsRate => 'Норма сбережений';

  @override
  String get savingsRateNoIncome =>
      'Добавьте доход, чтобы увидеть норму сбережений';

  @override
  String get expenseCategories => 'Категории расходов';

  @override
  String get incomeCategories => 'Категории доходов';

  @override
  String get deleteIncomeCategoryBody =>
      'Доходы из этой категории перейдут в «Другой доход». Ничего не '
      'удаляется.';

  @override
  String get incomeDeleted => 'Доход удалён';

  @override
  String get incomeRestored => 'Доход восстановлен';

  @override
  String get colType => 'Тип';

  @override
  String transactionCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count операция',
    few: '$count операции',
    many: '$count операций',
    other: '$count операции',
  );

  @override
  String get recurringPayments => 'Регулярные платежи';

  @override
  String get newRecurring => 'Новый регулярный платёж';

  @override
  String get editRecurring => 'Изменить регулярный платёж';

  @override
  String get addRecurring => 'Добавить платёж';

  @override
  String get recurringTitle => 'Название';

  @override
  String get recurringTitleHint => 'Аренда, Netflix, спортзал…';

  @override
  String get amount => 'Сумма';

  @override
  String get repeats => 'Повтор';

  @override
  String get weekly => 'Неделя';

  @override
  String get monthly => 'Месяц';

  @override
  String get yearly => 'Год';

  @override
  String get dueOn => 'Срок';

  @override
  String get dueDayOfMonth => 'День месяца';

  @override
  String get dueMonthLabel => 'Месяц';

  @override
  String get dueDayLabel => 'День';

  @override
  String get shortMonthHint => 'В более коротких месяцах — в последний день.';

  @override
  String get whenDue => 'Когда наступает срок';

  @override
  String get autoDeduct => 'Автосписание';

  @override
  String get remindMe => 'Напомнить';

  @override
  String get autoDeductHint =>
      'В день оплаты автоматически записывается как расход.';

  @override
  String get remindMeHint =>
      'Каждый платёж нужно будет подтвердить перед записью.';

  @override
  String get statusPaid => 'Оплачено';

  @override
  String get statusUpcoming => 'Предстоит';

  @override
  String get statusOverdue => 'Просрочено';

  @override
  String get markAsPaid => 'Оплачено';

  @override
  String get dueToday => 'Срок сегодня';

  @override
  String dueOnDate(String date) => 'Срок: $date';

  @override
  String nextDueOn(String date) => 'Следующий: $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Срок был $date'
      : '${paymentCount(count)} просрочено с $date';

  @override
  String everyWeekday(String weekday) => 'Каждую неделю: $weekday';

  @override
  String monthlyOnDay(String day) => 'Каждый месяц, $day-го числа';

  @override
  String yearlyOn(String date) => 'Каждый год, $date';

  @override
  String get monthlyAverage => 'В месяц';

  @override
  String get monthlyAverageHint => 'Все регулярные платежи в среднем';

  @override
  String get noRecurringYet => 'Регулярных платежей пока нет';

  @override
  String get noRecurringHint =>
      'Добавьте аренду, счета и подписки один раз. Каждый месяц будет видно, '
      'что оплачено, а что ещё нет.';

  @override
  String get paymentsToConfirm => 'Платежи к подтверждению';

  @override
  String get seeAll => 'Все';

  @override
  String get deleteRecurringBody =>
      'Платёж перестанет повторяться. Уже записанные платежи останутся в '
      'ваших операциях.';

  @override
  String recurringPaid(String name) => '«$name» отмечено как оплаченное';

  @override
  String get recurringPaymentUndone => 'Платёж убран';

  @override
  String recurringAutoLogged(int count) => plural(
    count,
    locale: localeName,
    one: 'Автоматически записан $count регулярный платёж',
    few: 'Автоматически записано $count регулярных платежа',
    many: 'Автоматически записано $count регулярных платежей',
    other: 'Автоматически записано $count регулярного платежа',
  );

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count платёж',
    few: '$count платежа',
    many: '$count платежей',
    other: '$count платежа',
  );

  @override
  String get colPaidThrough => 'Оплачено до';

  // People & debts

  @override
  String get people => 'Люди';

  @override
  String get peopleAndDebts => 'Люди и долги';

  @override
  String get person => 'Человек';

  @override
  String get personName => 'Имя';

  @override
  String get phone => 'Телефон';

  @override
  String get phoneOptional => 'Телефон (необязательно)';

  @override
  String get balance => 'Баланс';

  @override
  String get colStatus => 'Статус';

  @override
  String get owesYou => 'Должен вам';

  @override
  String get youOwe => 'Вы должны';

  @override
  String get owedToYou => 'Вам должны';

  @override
  String get settledUp => 'Рассчитались';

  @override
  String get iPaidForThem => 'Я заплатил(а) за него';

  @override
  String get theyPaidForMe => 'Заплатил(а) за меня';

  @override
  String get theyPaidYou => 'Заплатил(а) вам';

  @override
  String get youPaidThem => 'Вы заплатили';

  @override
  String get openStatus => 'Открыто';

  @override
  String get settledStatus => 'Закрыто';

  @override
  String get settledOn => 'Закрыто';

  @override
  String get createdOn => 'Создано';

  @override
  String get lastEdited => 'Изменено';

  @override
  String get colEdits => 'Правки';

  @override
  String get activeTransactions => 'Открытые операции';

  @override
  String get settledHistory => 'История расчётов';

  @override
  String get filterAll => 'Все';

  @override
  String get filterOwedToMe => 'Мне должны';

  @override
  String get filterIOwe => 'Я должен';

  @override
  String get filterSettled => 'Закрыто';

  @override
  String get addPerson => 'Добавить человека';

  @override
  String get addPersonHint => 'Тот, с кем вы делите расходы';

  @override
  String get newPerson => 'Новый человек';

  @override
  String get editPerson => 'Изменить';

  @override
  String get deletePerson => 'Удалить человека';

  @override
  String get quickTransaction => 'Быстрая операция';

  @override
  String get quickTransactionHint =>
      'Запишите, кто платил, с одним из добавленных людей';

  @override
  String get noPeopleYet => 'Пока никого нет';

  @override
  String get noPeopleHint =>
      'Добавьте тех, с кем делите расходы, чтобы видеть, кто кому должен.';

  @override
  String get nobodyHere => 'Под этот фильтр никто не подходит.';

  @override
  String get addPersonFirst => 'Сначала добавьте человека.';

  @override
  String get newTransaction => 'Новая операция';

  @override
  String get editTransaction => 'Изменить операцию';

  @override
  String get transactionDetails => 'Подробности операции';

  @override
  String get debtNoteHint => 'На что это было?';

  @override
  String get changeHistory => 'История изменений';

  @override
  String get edited => 'Изменено';

  @override
  String get settleUp => 'Рассчитаться';

  @override
  String get settle => 'Закрыть';

  @override
  String get noDebtsYet => 'Пока ничего не записано';

  @override
  String get noDebtsHint =>
      'Добавьте, что вы заплатили за этого человека или он за вас.';

  @override
  String get settleEven =>
      'Эти операции взаимно погашаются, так что никому ничего не нужно '
      'платить.';

  @override
  String get logSettlementTitle => 'Записать этот расчёт в бюджет на месяц?';

  @override
  String get loggedInBudget => 'В вашем бюджете';

  @override
  String get deleteTransactionTitle => 'Удалить эту операцию?';

  @override
  String get deleteTransactionBody =>
      'Она будет убрана из баланса с этим человеком.';

  @override
  String get deletePersonBody =>
      'Его операции и история расчётов тоже будут удалены. То, что вы '
      'записали в бюджет, останется.';

  @override
  String get settledLocked => 'Операция закрыта, её уже нельзя изменить.';

  @override
  String get personUpdated => 'Данные обновлены';

  @override
  String get debtDeleted => 'Операция удалена';

  @override
  String get settledUpNotice => 'Все расчёты закрыты';

  @override
  String get settlementLogged => 'Добавлено в бюджет';

  @override
  String personOwesYou(String name) => '$name должен вам';

  @override
  String youOwePerson(String name) => 'Вы должны: $name';

  @override
  String settledWith(String name) => 'С $name всё рассчитано';

  @override
  String settleUpFor(String amount) => 'Рассчитаться: $amount';

  @override
  String settleTitle(String name) => 'Рассчитаться с $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name платит вам $amount, и долгов не остаётся.';

  @override
  String settleYouPay(String name, String amount) =>
      'Вы платите $name $amount, и долгов не остаётся.';

  @override
  String settleMoves(int count) =>
      'В историю расчётов перейдёт: ${transactionCount(count)}.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount будет добавлено как доход в «Другой доход». Позже можно '
      'перенести в другую категорию.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount будет добавлено как расход в «Другое». Позже можно перенести '
      'в другую категорию.';

  @override
  String settlementNote(String name) => 'Расчёт с $name';

  @override
  String settledGroupTitle(String date) => 'Закрыто $date';

  @override
  String deletePersonTitle(String name) => 'Удалить $name?';

  @override
  String editedOn(String date) => 'Изменено $date';

  @override
  String wasValues(String values) => 'Было: $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count человек',
    few: '$count человека',
    many: '$count человек',
    other: '$count человека',
  );
}
