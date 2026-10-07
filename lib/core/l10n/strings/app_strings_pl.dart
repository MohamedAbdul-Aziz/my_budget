import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsPl extends AppStrings {
  const AppStringsPl();

  @override
  String get localeName => 'pl';

  @override
  String get appTitle => 'Mój Budżet';

  @override
  String get add => 'Dodaj';

  @override
  String get undo => 'Cofnij';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get nothingRecordedYet => 'Jeszcze nic nie zapisano';

  @override
  String get emptyMonthHint =>
      'Stuknij Dodaj, aby zapisać pierwszy wydatek lub przychód w tym '
      'miesiącu.';

  @override
  String get yourMonths => 'Twoje miesiące';

  @override
  String spentIn(String month) => 'Wydano: $month';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count wydatek',
    few: '$count wydatki',
    many: '$count wydatków',
    other: '$count wydatku',
  );

  @override
  String get quickExpense => 'Szybki wydatek';

  @override
  String get expenseSaved => 'Wydatek zapisany';

  @override
  String get newExpense => 'Nowy wydatek';

  @override
  String get editExpense => 'Edytuj wydatek';

  @override
  String get when => 'Kiedy';

  @override
  String get today => 'Dziś';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String get pickADate => 'Wybierz datę';

  @override
  String get category => 'Kategoria';

  @override
  String get noteOptional => 'Notatka (opcjonalnie)';

  @override
  String get noteHint => 'Na co to było?';

  @override
  String get addExpense => 'Dodaj wydatek';

  @override
  String get saveChanges => 'Zapisz zmiany';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Kategorie';

  @override
  String get newCategory => 'Nowa kategoria';

  @override
  String get editCategory => 'Edytuj kategorię';

  @override
  String get addCategory => 'Dodaj kategorię';

  @override
  String get categoryName => 'Nazwa';

  @override
  String get color => 'Kolor';

  @override
  String get icon => 'Ikona';

  @override
  String get builtIn => 'Wbudowana';

  @override
  String get custom => 'Własna';

  @override
  String get edit => 'Edytuj';

  @override
  String get delete => 'Usuń';

  @override
  String get cancel => 'Anuluj';

  @override
  String deleteCategoryTitle(String name) => 'Usunąć „$name”?';

  @override
  String get deleteCategoryBody =>
      'Wydatki z tej kategorii trafią do Inne. Nic nie zostanie usunięte.';

  @override
  String get settings => 'Ustawienia';

  @override
  String get appearance => 'Wygląd';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get language => 'Język';

  @override
  String get languageSystem => 'Systemowy';

  @override
  String get currency => 'Waluta';

  @override
  String get currencySymbol => 'Symbol';

  @override
  String get currencySymbolHint => 'Wyświetlany przy każdej kwocie';

  @override
  String get reminders => 'Przypomnienia';

  @override
  String get dailyReminder => 'Codzienne przypomnienie';

  @override
  String get dailyReminderHint =>
      'Przypomnienie, by zapisać dzisiejsze wydatki';

  @override
  String get reminderTime => 'Godzina';

  @override
  String get notificationsBlocked =>
      'Powiadomienia tej aplikacji są wyłączone. Zezwól na nie w ustawieniach telefonu.';

  @override
  String get reminderNotificationTitle => 'Zapisz dzisiejsze wydatki';

  @override
  String get reminderNotificationBody =>
      'Poświęć chwilę, aby dodać dzisiejsze wydatki.';

  @override
  String get security => 'Bezpieczeństwo';

  @override
  String get appLock => 'Blokada aplikacji';

  @override
  String get appLockHint =>
      'Pytaj o odcisk palca, twarz lub blokadę ekranu przy otwieraniu';

  @override
  String get appLockUnavailable =>
      'Najpierw ustaw blokadę ekranu w tym telefonie';

  @override
  String get unlock => 'Odblokuj';

  @override
  String get unlockToContinue => 'Odblokuj, aby zobaczyć budżet';

  @override
  String get confirmItsYou => 'Potwierdź, że to Ty, aby zmienić blokadę';

  @override
  String get storedOnThisDevice =>
      'Twoje wydatki są zapisane na tym urządzeniu. Zaloguj się, aby zrobić '
      'kopię zapasową.';

  @override
  String get account => 'Konto';

  @override
  String get accountOptional =>
      'Konto jest opcjonalne. Aplikacja w pełni działa bez niego.';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get signOut => 'Wyloguj się';

  @override
  String get signedIn => 'Zalogowano';

  @override
  String get createAccount => 'Utwórz konto';

  @override
  String get noAccountYet => 'Nie masz konta? Utwórz je';

  @override
  String get haveAnAccount => 'Masz już konto? Zaloguj się';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Hasło';

  @override
  String get passwordRules => 'Co najmniej 6 znaków';

  @override
  String get confirmEmail => 'Potwierdź e-mail';

  @override
  String codeSentTo(String email) =>
      'Wysłaliśmy kod na adres $email. Wpisz go poniżej, aby dokończyć '
      'zakładanie konta.';

  @override
  String get confirmationCode => 'Kod';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get resendCode => 'Wyślij nowy kod';

  @override
  String get codeResent => 'Nowy kod jest w drodze';

  @override
  String get useDifferentEmail => 'Użyj innego adresu';

  @override
  String get forgotPassword => 'Nie pamiętasz hasła?';

  @override
  String get resetPassword => 'Resetuj hasło';

  @override
  String resetCodeSentTo(String email) =>
      'Wysłaliśmy kod na adres $email. Wpisz go razem z nowym hasłem do konta.';

  @override
  String get newPassword => 'Nowe hasło';

  @override
  String get saveNewPassword => 'Zapisz nowe hasło';

  @override
  String get backToSignIn => 'Wróć do logowania';

  @override
  String get backupHint =>
      'Kopia zapasowa zachowuje Twoje wydatki na koncie. Przywracanie '
      'przenosi tę kopię na ten telefon, nie usuwając niczego, co już tu '
      'jest.';

  @override
  String get backUpNow => 'Utwórz kopię';

  @override
  String get autoBackup => 'Automatyczna kopia';

  @override
  String get autoBackupHint =>
      'Za każdym razem, gdy wychodzisz z aplikacji, nowe zmiany trafiają do kopii na koncie.';

  @override
  String get restoreData => 'Przywróć';

  @override
  String get backingUp => 'Tworzenie kopii…';

  @override
  String get restoring => 'Przywracanie…';

  @override
  String get backupDone => 'Kopia gotowa';

  @override
  String get restoreDone => 'Przywracanie zakończone';

  @override
  String get neverSynced => 'Brak kopii zapasowej';

  @override
  String lastSynced(String when) => 'Ostatnia synchronizacja: $when';

  @override
  String get deleteAccount => 'Usuń konto';

  @override
  String get deleteAccountTitle => 'Usunąć konto?';

  @override
  String get deleteAccountBody =>
      'Konto i zapisana na nim kopia Twoich wydatków zostaną trwale '
      'usunięte. Tego nie można cofnąć. Wydatki na tym telefonie zostaną, a '
      'z aplikacji możesz dalej korzystać bez konta.';

  @override
  String get deletingAccount => 'Usuwanie konta…';

  @override
  String get accountDeleted => 'Konto zostało usunięte';

  @override
  String get home => 'Start';

  @override
  String get analyses => 'Analizy';

  @override
  String get vsLastMonth => 'W porównaniu z zeszłym miesiącem';

  @override
  String get noComparison => 'Brak danych z zeszłego miesiąca';

  @override
  String get dailySpending => 'Wydatki dzienne';

  @override
  String get dailyAverage => 'Średnio na dzień';

  @override
  String get topDay => 'Najwyższy dzień';

  @override
  String get byCategory => 'Wydatki wg kategorii';

  @override
  String get noSpendingThisMonth => 'W tym miesiącu brak wydatków.';

  @override
  String get monthlyTrend => 'Ostatnie 6 miesięcy';

  @override
  String lastMonthTotal(String amount) => 'Zeszły miesiąc: $amount';

  @override
  String get budgets => 'Budżety';

  @override
  String get monthlyBudget => 'Budżet miesięczny';

  @override
  String get setMonthlyBudget => 'Ustal budżet miesięczny';

  @override
  String get setBudgetHint =>
      'Zobacz, ile zostało, i dostań ostrzeżenie, zanim wydasz za dużo.';

  @override
  String get setBudget => 'Ustal';

  @override
  String get editBudget => 'Edytuj budżet';

  @override
  String get removeBudget => 'Usuń';

  @override
  String get save => 'Zapisz';

  @override
  String amountLeft(String amount) => 'Zostało $amount';

  @override
  String amountOver(String amount) => '$amount ponad budżet';

  @override
  String spentOfLimit(String spent, String limit) => 'Wydano $spent z $limit';

  @override
  String amountSpent(String amount) => 'Wydano $amount';

  @override
  String budgetUsed(String percent) => 'Wykorzystano $percent budżetu';

  @override
  String get categoryBudgets => 'Budżety kategorii';

  @override
  String get categoryBudgetsHint => 'Ogranicz wydatki w jednej kategorii.';

  @override
  String categoryBudgetTitle(String name) => 'Budżet: $name';

  @override
  String get setLimit => 'Ustal limit';

  @override
  String get closeToLimit => 'Blisko limitu';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Budżety powtarzają się co miesiąc. Dostaniesz ostrzeżenie, gdy '
      'wydatki przekroczą $nearing, i ponownie przy $reached.';

  @override
  String get budgetAlertTitle => 'Alert budżetu';

  @override
  String get ok => 'OK';

  @override
  String get view => 'Pokaż';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Wykorzystano $percent budżetu miesięcznego';

  @override
  String get monthlyBudgetUsedUp => 'Budżet miesięczny został wyczerpany';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Budżet miesięczny przekroczony o $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Wykorzystano $percent budżetu „$name”';

  @override
  String categoryBudgetUsedUp(String name) =>
      'Budżet „$name” został wyczerpany';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Budżet „$name” przekroczony o $amount';

  @override
  String get dataManagement => 'Zarządzanie danymi';

  @override
  String get dataManagementHint =>
      'Pliki, które przechowujesz sam. Działają offline i bez konta.';

  @override
  String get backUpToFile => 'Kopia zapasowa danych';

  @override
  String get backUpToFileHint =>
      'Pełny plik kopii, który możesz później zaimportować';

  @override
  String get exportCsv => 'Eksportuj do CSV';

  @override
  String get exportCsvHint => 'Do Excela lub Arkuszy Google';

  @override
  String get exportPdf => 'Eksportuj do PDF';

  @override
  String get exportPdfHint => 'Raport do czytania, druku lub udostępnienia';

  @override
  String get importData => 'Importuj dane';

  @override
  String get importDataHint => 'Przywróć z pliku kopii';

  @override
  String get preparingFile => 'Przygotowywanie pliku…';

  @override
  String get importingData => 'Importowanie…';

  @override
  String get fileSaved => 'Plik zapisany';

  @override
  String get importDone => 'Import zakończony';

  @override
  String get importNothingNew =>
      'Ten telefon miał już wszystko, co jest w kopii';

  @override
  String get fileReady => 'Plik jest gotowy';

  @override
  String get shareFile => 'Udostępnij';

  @override
  String get shareFileHint => 'WhatsApp, e-mail, Dysk Google i inne';

  @override
  String get saveToPhone => 'Zapisz na tym telefonie';

  @override
  String get saveToPhoneHint => 'Wybierz, gdzie go zachować';

  @override
  String get importTitle => 'Zaimportować tę kopię?';

  @override
  String get importMergeHint =>
      'Scalanie zachowuje wszystko na tym telefonie i dodaje to, czego '
      'brakuje. Gdy wpis się różni, wygrywa nowsza zmiana.';

  @override
  String get merge => 'Scal';

  @override
  String get replaceEverything => 'Zastąp wszystko';

  @override
  String get replaceTitle => 'Zastąpić wszystko na tym telefonie?';

  @override
  String get replaceBody =>
      'Wszystko na tym telefonie, czego nie ma w kopii, zostanie usunięte, a '
      'dla każdego wpisu zostanie użyta wersja z kopii. Tego nie można '
      'cofnąć.';

  @override
  String get replace => 'Zastąp';

  @override
  String get colDate => 'Data';

  @override
  String get colMonth => 'Miesiąc';

  @override
  String get colAmount => 'Kwota';

  @override
  String get colNote => 'Notatka';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Transakcje';

  @override
  String get colTotal => 'Suma';

  @override
  String get colShare => 'Udział';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get reportTitle => 'Mój Budżet: raport wydatków';

  @override
  String get reportPeriod => 'Okres';

  @override
  String get reportTotal => 'Łącznie wydano';

  @override
  String get reportMonthlyAverage => 'Średnio na miesiąc';

  @override
  String get reportByMonth => 'Wydatki wg miesięcy';

  @override
  String get reportAllExpenses => 'Wszystkie wydatki';

  @override
  String get reportEmpty => 'Jeszcze nie zapisano wydatków.';

  @override
  String get reportPageTemplate => 'Strona {page} z {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} i ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} i '
              '${personCount(people)}';
    return date == null
        ? 'Ta kopia zawiera: $contents.'
        : 'Kopia z $date: $contents.';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count kategoria',
    few: '$count kategorie',
    many: '$count kategorii',
    other: '$count kategorii',
  );

  @override
  String reportGenerated(String when) => 'Utworzono $when';

  @override
  String get showPassword => 'Pokaż hasło';

  @override
  String get hidePassword => 'Ukryj hasło';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Jedzenie',
    'cat_transport' => 'Transport',
    'cat_bills' => 'Rachunki',
    'cat_shopping' => 'Zakupy',
    'cat_health' => 'Zdrowie i sport',
    'cat_entertainment' => 'Rozrywka',
    'cat_work' => 'Praca',
    'cat_other' => 'Inne',
    'cat_salary' => 'Pensja',
    'cat_freelance' => 'Zlecenia',
    'cat_investments' => 'Inwestycje',
    'cat_gifts' => 'Prezenty',
    'cat_income_other' => 'Inne przychody',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'Nie udało się zapisać na tym urządzeniu. Spróbuj ponownie.',
    FailureCode.notFound => 'Ten element już nie istnieje.',
    FailureCode.unknown => 'Coś poszło nie tak.',
    FailureCode.amountRequired => 'Wpisz kwotę większą od zera.',
    FailureCode.amountTooLarge => 'Ta kwota jest za duża.',
    FailureCode.amountInvalid => 'Wpisz prawidłową kwotę.',
    FailureCode.categoryRequired => 'Wybierz kategorię.',
    FailureCode.categoryNameRequired => 'Nadaj kategorii nazwę.',
    FailureCode.categoryNameTooLong => 'Nazwa musi mieć mniej niż 30 znaków.',
    FailureCode.categoryProtected => 'Tej kategorii nie można usunąć.',
    FailureCode.currencySymbolInvalid => 'Użyj od 1 do 4 znaków.',
    FailureCode.network =>
      'Brak połączenia. Sprawdź internet i spróbuj ponownie.',
    FailureCode.emailInvalid => 'Wpisz prawidłowy adres e-mail.',
    FailureCode.passwordTooShort => 'Hasło musi mieć co najmniej 6 znaków.',
    FailureCode.invalidCredentials => 'Nieprawidłowy e-mail lub hasło.',
    FailureCode.emailTaken => 'Konto z tym adresem już istnieje.',
    FailureCode.emailNotConfirmed =>
      'Najpierw potwierdź e-mail kodem, który wysłaliśmy.',
    FailureCode.codeInvalid => 'Kod jest błędny lub wygasł.',
    FailureCode.signInRequired => 'Zaloguj się ponownie i spróbuj jeszcze raz.',
    FailureCode.syncOtherAccount =>
      'Dane na tym telefonie są powiązane z innym kontem.',
    FailureCode.syncFailed =>
      'Nie udało się zsynchronizować z kontem. Spróbuj ponownie.',
    FailureCode.accountDeletionFailed =>
      'Nie udało się usunąć konta. Spróbuj ponownie.',
    FailureCode.backupNotRecognized =>
      'Ten plik nie jest kopią aplikacji Mój Budżet.',
    FailureCode.backupTooNew =>
      'Ta kopia pochodzi z nowszej wersji aplikacji Mój Budżet. Zaktualizuj '
          'aplikację i spróbuj ponownie.',
    FailureCode.backupDamaged =>
      'Plik kopii jest uszkodzony, więc nic nie zaimportowano.',
    FailureCode.fileUnavailable =>
      'Nie udało się otworzyć pliku. Spróbuj wybrać go ponownie.',
    FailureCode.storageFull => 'Na tym telefonie brakuje wolnego miejsca.',
    FailureCode.exportFailed =>
      'Nie udało się utworzyć pliku. Spróbuj ponownie.',
    FailureCode.shareUnavailable =>
      'Nie udało się otworzyć menu udostępniania.',
    FailureCode.saveFailed => 'Nie udało się zapisać pliku. Spróbuj ponownie.',
    FailureCode.tooManyAttempts =>
      'Za dużo prób. Poczekaj chwilę i spróbuj ponownie.',
    FailureCode.titleRequired => 'Nadaj nazwę.',
    FailureCode.titleTooLong => 'Nazwa musi mieć mniej niż 40 znaków.',
    FailureCode.dueDayInvalid => 'Wybierz termin płatności.',
    FailureCode.alreadyPaid => 'Ta płatność jest już zapisana.',
    FailureCode.personRequired => 'Wybierz osobę.',
    FailureCode.personNameRequired => 'Wpisz imię.',
    FailureCode.personNameTooLong => 'Imię musi mieć mniej niż 40 znaków.',
    FailureCode.phoneInvalid => 'Wpisz prawidłowy numer telefonu.',
    FailureCode.transactionSettled =>
      'Rozliczonych transakcji nie można zmieniać.',
    FailureCode.nothingToSettle => 'Nie ma nic do rozliczenia.',
    FailureCode.settlementAlreadyLogged =>
      'To rozliczenie jest już w Twoim budżecie.',
  };

  @override
  String get expenseDeleted => 'Wydatek usunięty';

  @override
  String get expenseRestored => 'Wydatek przywrócony';

  @override
  String categoryAdded(String name) => 'Dodano: $name';

  @override
  String get categoryUpdated => 'Kategoria zaktualizowana';

  @override
  String categoryDeleted(String name) => 'Usunięto: $name';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      'Usunięto „$name” — przeniesiono do Inne: ${expenseCount(count)}';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      'Usunięto „$name” — przeniesiono do Inne przychody: '
      '${transactionCount(count)}';

  @override
  String get expense => 'Wydatek';

  @override
  String get income => 'Przychód';

  @override
  String get search => 'Szukaj';

  @override
  String get searchHint => 'Szukaj notatek lub kwot';

  @override
  String get searchPrompt =>
      'Znajdź transakcję po notatce lub kwocie albo filtruj według typu, kategorii i daty.';

  @override
  String get noSearchResults => 'Brak pasujących transakcji';

  @override
  String get allTypes => 'Wszystko';

  @override
  String get anyCategory => 'Dowolna kategoria';

  @override
  String get anyDate => 'Dowolna data';

  @override
  String get clearFilters => 'Wyczyść filtry';

  @override
  String get transactionType => 'Wydatek czy przychód';

  @override
  String get quickIncome => 'Szybki przychód';

  @override
  String get newIncome => 'Nowy przychód';

  @override
  String get editIncome => 'Edytuj przychód';

  @override
  String get addIncome => 'Dodaj przychód';

  @override
  String get incomeNoteHint => 'Skąd pochodzi?';

  @override
  String get totalIncome => 'Przychody razem';

  @override
  String get totalExpenses => 'Wydatki razem';

  @override
  String get netBalance => 'Saldo netto';

  @override
  String get savingsRate => 'Stopa oszczędności';

  @override
  String get savingsRateNoIncome =>
      'Dodaj przychód, aby zobaczyć stopę oszczędności';

  @override
  String get expenseCategories => 'Kategorie wydatków';

  @override
  String get incomeCategories => 'Kategorie przychodów';

  @override
  String get deleteIncomeCategoryBody =>
      'Przychody z tej kategorii trafią do Inne przychody. Nic nie zostanie '
      'usunięte.';

  @override
  String get incomeDeleted => 'Przychód usunięty';

  @override
  String get incomeRestored => 'Przychód przywrócony';

  @override
  String get colType => 'Typ';

  @override
  String transactionCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count transakcja',
    few: '$count transakcje',
    many: '$count transakcji',
    other: '$count transakcji',
  );

  @override
  String get recurringPayments => 'Płatności cykliczne';

  @override
  String get newRecurring => 'Nowa płatność cykliczna';

  @override
  String get editRecurring => 'Edytuj płatność cykliczną';

  @override
  String get addRecurring => 'Dodaj płatność';

  @override
  String get recurringTitle => 'Nazwa';

  @override
  String get recurringTitleHint => 'Czynsz, Netflix, siłownia…';

  @override
  String get amount => 'Kwota';

  @override
  String get repeats => 'Powtarza się';

  @override
  String get weekly => 'Co tydzień';

  @override
  String get monthly => 'Co miesiąc';

  @override
  String get yearly => 'Co rok';

  @override
  String get dueOn => 'Termin';

  @override
  String get dueDayOfMonth => 'Dzień miesiąca';

  @override
  String get dueMonthLabel => 'Miesiąc';

  @override
  String get dueDayLabel => 'Dzień';

  @override
  String get shortMonthHint => 'W krótszych miesiącach wypada ostatniego dnia.';

  @override
  String get whenDue => 'W terminie';

  @override
  String get autoDeduct => 'Automatycznie';

  @override
  String get remindMe => 'Przypomnij';

  @override
  String get autoDeductHint =>
      'W dniu płatności zapisywana automatycznie jako wydatek.';

  @override
  String get remindMeHint =>
      'Każdą płatność potwierdzisz przed jej zapisaniem.';

  @override
  String get statusPaid => 'Zapłacono';

  @override
  String get statusUpcoming => 'Nadchodzi';

  @override
  String get statusOverdue => 'Zaległa';

  @override
  String get markAsPaid => 'Zapłacone';

  @override
  String get dueToday => 'Termin dziś';

  @override
  String dueOnDate(String date) => 'Termin: $date';

  @override
  String nextDueOn(String date) => 'Następna: $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Termin minął $date'
      : 'Zaległe od $date: ${paymentCount(count)}';

  @override
  String everyWeekday(String weekday) => 'Co tydzień: $weekday';

  @override
  String monthlyOnDay(String day) => 'Co miesiąc, $day. dnia';

  @override
  String yearlyOn(String date) => 'Co rok, $date';

  @override
  String get monthlyAverage => 'Miesięcznie';

  @override
  String get monthlyAverageHint => 'Wszystkie płatności cykliczne, średnio';

  @override
  String get noRecurringYet => 'Brak płatności cyklicznych';

  @override
  String get noRecurringHint =>
      'Dodaj czynsz, rachunki i subskrypcje raz. Co miesiąc zobaczysz, co '
      'jest zapłacone, a co jeszcze nie.';

  @override
  String get paymentsToConfirm => 'Płatności do potwierdzenia';

  @override
  String get seeAll => 'Wszystkie';

  @override
  String get deleteRecurringBody =>
      'Przestanie się powtarzać. Zapisane już płatności zostają w Twoich '
      'transakcjach.';

  @override
  String recurringPaid(String name) => 'Oznaczono jako zapłacone: $name';

  @override
  String recurringReceived(String name) => 'Oznaczono jako otrzymane: $name';

  @override
  String get statusReceived => 'Otrzymano';

  @override
  String get markAsReceived => 'Otrzymane';

  @override
  String get autoAdd => 'Automatycznie';

  @override
  String get autoAddHint =>
      'W dniu wpływu zapisywany automatycznie jako przychód.';

  @override
  String get monthlyIncomeAverage => 'Przychód miesięcznie';

  @override
  String get recurringPaymentUndone => 'Płatność usunięta';

  @override
  String recurringAutoLogged(int count) => plural(
    count,
    locale: localeName,
    one: 'Automatycznie zapisano $count płatność cykliczną',
    few: 'Automatycznie zapisano $count płatności cykliczne',
    many: 'Automatycznie zapisano $count płatności cyklicznych',
    other: 'Automatycznie zapisano $count płatności cyklicznej',
  );

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count płatność',
    few: '$count płatności',
    many: '$count płatności',
    other: '$count płatności',
  );

  @override
  String get colPaidThrough => 'Opłacono do';

  // People & debts

  @override
  String get people => 'Osoby';

  @override
  String get peopleAndDebts => 'Osoby i długi';

  @override
  String get person => 'Osoba';

  @override
  String get personName => 'Imię';

  @override
  String get phone => 'Telefon';

  @override
  String get phoneOptional => 'Telefon (opcjonalnie)';

  @override
  String get balance => 'Saldo';

  @override
  String get colStatus => 'Status';

  @override
  String get owesYou => 'Winien ci';

  @override
  String get youOwe => 'Jesteś winien';

  @override
  String get owedToYou => 'Należy ci się';

  @override
  String get settledUp => 'Rozliczono';

  @override
  String get iPaidForThem => 'Zapłaciłem za tę osobę';

  @override
  String get theyPaidForMe => 'Zapłacił(a) za mnie';

  @override
  String get theyPaidYou => 'Zapłacił(a) tobie';

  @override
  String get youPaidThem => 'Ty zapłaciłeś';

  @override
  String get openStatus => 'Otwarte';

  @override
  String get settledStatus => 'Rozliczone';

  @override
  String get settledOn => 'Rozliczono';

  @override
  String get createdOn => 'Utworzono';

  @override
  String get lastEdited => 'Ostatnia zmiana';

  @override
  String get colEdits => 'Zmiany';

  @override
  String get activeTransactions => 'Otwarte transakcje';

  @override
  String get settledHistory => 'Historia rozliczeń';

  @override
  String get filterAll => 'Wszystkie';

  @override
  String get filterOwedToMe => 'Dla mnie';

  @override
  String get filterIOwe => 'Jestem winien';

  @override
  String get filterSettled => 'Rozliczone';

  @override
  String get addPerson => 'Dodaj osobę';

  @override
  String get addPersonHint => 'Ktoś, z kim dzielisz koszty';

  @override
  String get newPerson => 'Nowa osoba';

  @override
  String get editPerson => 'Edytuj osobę';

  @override
  String get deletePerson => 'Usuń osobę';

  @override
  String get quickTransaction => 'Szybka transakcja';

  @override
  String get quickTransactionHint =>
      'Zapisz, kto zapłacił, z osobą, którą już dodałeś';

  @override
  String get noPeopleYet => 'Brak osób';

  @override
  String get noPeopleHint =>
      'Dodaj osoby, z którymi dzielisz koszty, aby wiedzieć, kto komu ile '
      'jest winien.';

  @override
  String get nobodyHere => 'Nikt nie pasuje do tego filtra.';

  @override
  String get addPersonFirst => 'Najpierw dodaj osobę.';

  @override
  String get newTransaction => 'Nowa transakcja';

  @override
  String get editTransaction => 'Edytuj transakcję';

  @override
  String get transactionDetails => 'Szczegóły transakcji';

  @override
  String get debtNoteHint => 'Na co to było?';

  @override
  String get changeHistory => 'Historia zmian';

  @override
  String get edited => 'Zmieniono';

  @override
  String get settleUp => 'Rozlicz';

  @override
  String get settle => 'Rozlicz';

  @override
  String get noDebtsYet => 'Jeszcze nic nie zapisano';

  @override
  String get noDebtsHint =>
      'Dodaj, co zapłaciłeś za tę osobę albo co ona zapłaciła za ciebie.';

  @override
  String get settleEven =>
      'Te transakcje się znoszą, więc nikt nie musi nikomu płacić.';

  @override
  String get logSettlementTitle =>
      'Zapisać to rozliczenie w budżecie miesięcznym?';

  @override
  String get loggedInBudget => 'W Twoim budżecie';

  @override
  String get deleteTransactionTitle => 'Usunąć tę transakcję?';

  @override
  String get deleteTransactionBody => 'Zostanie usunięta z salda z tą osobą.';

  @override
  String get deletePersonBody =>
      'Jej transakcje i historia rozliczeń też zostaną usunięte. To, co '
      'zapisałeś w budżecie, zostaje.';

  @override
  String get settledLocked => 'Rozliczona, więc nie można jej już zmienić.';

  @override
  String get personUpdated => 'Osoba zaktualizowana';

  @override
  String get debtDeleted => 'Transakcja usunięta';

  @override
  String get settledUpNotice => 'Wszystko rozliczone';

  @override
  String get settlementLogged => 'Dodano do budżetu';

  @override
  String personOwesYou(String name) => '$name jest ci winien';

  @override
  String youOwePerson(String name) => 'Jesteś winien: $name';

  @override
  String settledWith(String name) => 'Wszystko rozliczone: $name';

  @override
  String settleUpFor(String amount) => 'Rozlicz $amount';

  @override
  String settleTitle(String name) => 'Rozliczyć się: $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name płaci ci $amount i wszystko jest rozliczone.';

  @override
  String settleYouPay(String name, String amount) =>
      'Płacisz $amount osobie $name i wszystko jest rozliczone.';

  @override
  String settleMoves(int count) =>
      'Do historii rozliczeń trafi: ${transactionCount(count)}.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount zostanie dodane jako przychód w Inne przychody. Możesz to '
      'później przenieść do innej kategorii.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount zostanie dodane jako wydatek w Inne. Możesz to później '
      'przenieść do innej kategorii.';

  @override
  String settlementNote(String name) => 'Rozliczenie: $name';

  @override
  String settledGroupTitle(String date) => 'Rozliczono $date';

  @override
  String deletePersonTitle(String name) => 'Usunąć: $name?';

  @override
  String editedOn(String date) => 'Zmieniono $date';

  @override
  String wasValues(String values) => 'Było: $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count osoba',
    few: '$count osoby',
    many: '$count osób',
    other: '$count osoby',
  );

  @override
  String get askTitle => 'Pytania o wydatki';

  @override
  String get askHint => 'Dotknij pytania, aby zobaczyć odpowiedź.';

  @override
  String get askCompareMonths => 'Porównaj miesiące';

  @override
  String get askTopCategory => 'Główna kategoria';

  @override
  String get askVsLastMonth => 'vs poprzedni miesiąc';

  @override
  String get askBiggestExpense => 'Największy wydatek';

  @override
  String get askTopDay => 'Najdroższy dzień';

  @override
  String get askWeekday => 'Najdroższy dzień tyg.';

  @override
  String get askMonthEnd => 'Prognoza na koniec';

  @override
  String get askSaved => 'Czy oszczędziłem?';

  @override
  String get askBudgetLeft => 'Pozostały budżet';

  @override
  String get askHighestLowest => 'Najwyższy i najniższy';

  @override
  String get askCount => 'Ile wydatków';

  @override
  String get askTopIncome => 'Główny przychód';

  @override
  String get otherCategories => 'Inne';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'Najwięcej na „$category”: $amount ($percent miesiąca).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month: o $amount więcej niż $other (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month: o $amount mniej niż $other (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      '$month i $other: wydano tyle samo.';

  @override
  String answerNothingIn(String month) => '$month: brak wydatków.';

  @override
  String answerRise(String category, String amount) =>
      'Największy wzrost: „$category” (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Największy spadek: „$category” (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Największy wydatek: $amount, „$category” ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Najdroższy dzień: $date — $amount.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Najdroższy dzień tygodnia: $weekday ($amount w tym miesiącu).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'W tym tempie (ok. $average dziennie) do końca miesiąca wydasz ok. $amount.';

  @override
  String answerMonthTotal(String amount) =>
      'Ten miesiąc się skończył: łącznie wydano $amount.';

  @override
  String answerSaved(String amount, String income) =>
      'Zaoszczędzono $amount z przychodu $income.';

  @override
  String answerOverspent(String amount) =>
      'Wydano o $amount więcej, niż zarobiono.';

  @override
  String get answerNoIncome => 'Brak przychodów w tym miesiącu.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'W budżecie miesięcznym zostało $amount (wykorzystano $percent).';

  @override
  String answerBudgetOver(String amount) =>
      'Budżet miesięczny przekroczony o $amount.';

  @override
  String get answerNoBudget => 'Nie ustawiono jeszcze budżetu miesięcznego.';

  @override
  String answerOverLimit(String names) => 'Przekroczony limit: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'Najwyższy miesiąc: $high ($highAmount). Najniższy: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'Zapisano ${expenseCount(count)}, średnio $average.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'Najwięcej przychodu z „$category”: $amount ($percent).';
}
