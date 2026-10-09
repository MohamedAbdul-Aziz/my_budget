import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsNl extends AppStrings {
  const AppStringsNl();

  @override
  String get localeName => 'nl';

  @override
  String get appTitle => 'Mijn Budget';

  @override
  String get add => 'Toevoegen';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get tryAgain => 'Opnieuw proberen';

  @override
  String get nothingRecordedYet => 'Nog niets vastgelegd';

  @override
  String get emptyMonthHint =>
      'Tik op Toevoegen om je eerste uitgave of inkomsten van deze maand vast '
      'te leggen.';

  @override
  String get yourMonths => 'Je maanden';

  @override
  String spentIn(String month) => 'Uitgegeven in $month';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count uitgave',
    other: '$count uitgaven',
  );

  @override
  String get quickExpense => 'Snelle uitgave';

  @override
  String get expenseSaved => 'Uitgave opgeslagen';

  @override
  String get newExpense => 'Nieuwe uitgave';

  @override
  String get editExpense => 'Uitgave bewerken';

  @override
  String get when => 'Wanneer';

  @override
  String get today => 'Vandaag';

  @override
  String get yesterday => 'Gisteren';

  @override
  String get pickADate => 'Kies een datum';

  @override
  String get category => 'Categorie';

  @override
  String get noteOptional => 'Notitie (optioneel)';

  @override
  String get noteHint => 'Waar was het voor?';

  @override
  String get addExpense => 'Uitgave toevoegen';

  @override
  String get saveChanges => 'Wijzigingen opslaan';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Categorieën';

  @override
  String get newCategory => 'Nieuwe categorie';

  @override
  String get editCategory => 'Categorie bewerken';

  @override
  String get addCategory => 'Categorie toevoegen';

  @override
  String get categoryName => 'Naam';

  @override
  String get color => 'Kleur';

  @override
  String get icon => 'Pictogram';

  @override
  String get builtIn => 'Standaard';

  @override
  String get custom => 'Eigen';

  @override
  String get edit => 'Bewerken';

  @override
  String get delete => 'Verwijderen';

  @override
  String get cancel => 'Annuleren';

  @override
  String deleteCategoryTitle(String name) => '$name verwijderen?';

  @override
  String get deleteCategoryBody =>
      'Uitgaven in deze categorie gaan naar Overig. Er wordt niets '
      'verwijderd.';

  @override
  String get settings => 'Instellingen';

  @override
  String get appearance => 'Weergave';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get language => 'Taal';

  @override
  String get languageSystem => 'Systeem';

  @override
  String get currency => 'Valuta';

  @override
  String get currencySymbol => 'Symbool';

  @override
  String get currencySymbolHint => 'Staat naast elk bedrag';

  @override
  String get currencyOther => 'Andere';

  @override
  String get reminders => 'Herinneringen';

  @override
  String get dailyReminder => 'Dagelijkse herinnering';

  @override
  String get dailyReminderHint =>
      'Een seintje om je uitgaven van vandaag te noteren';

  @override
  String get reminderTime => 'Tijd';

  @override
  String get notificationsBlocked =>
      'Meldingen staan uit voor deze app. Sta ze toe in de instellingen van je telefoon.';

  @override
  String get reminderNotificationTitle => 'Noteer je uitgaven van vandaag';

  @override
  String get reminderNotificationBody =>
      'Neem even de tijd om toe te voegen wat je vandaag hebt uitgegeven.';

  @override
  String get security => 'Beveiliging';

  @override
  String get appLock => 'App-vergrendeling';

  @override
  String get appLockHint =>
      'Vraag om vingerafdruk, gezicht of schermvergrendeling bij openen';

  @override
  String get appLockUnavailable =>
      'Stel eerst een schermvergrendeling in op deze telefoon';

  @override
  String get unlock => 'Ontgrendelen';

  @override
  String get unlockToContinue => 'Ontgrendel om je budget te zien';

  @override
  String get confirmItsYou =>
      'Bevestig dat jij het bent om de vergrendeling te wijzigen';

  @override
  String get storedOnThisDevice =>
      'Je uitgaven staan op dit apparaat. Log in om er een back-up van te '
      'maken.';

  @override
  String get account => 'Account';

  @override
  String get accountOptional =>
      'Een account is optioneel. De app werkt ook volledig zonder.';

  @override
  String get signIn => 'Inloggen';

  @override
  String get signOut => 'Uitloggen';

  @override
  String get signedIn => 'Ingelogd';

  @override
  String get createAccount => 'Account maken';

  @override
  String get noAccountYet => 'Nog geen account? Maak er een';

  @override
  String get haveAnAccount => 'Heb je al een account? Log in';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Wachtwoord';

  @override
  String get passwordRules => 'Minstens 6 tekens';

  @override
  String get confirmEmail => 'Bevestig je e-mail';

  @override
  String codeSentTo(String email) =>
      'We hebben een code naar $email gestuurd. Vul die hieronder in om je '
      'account af te maken.';

  @override
  String get confirmationCode => 'Code';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get resendCode => 'Nieuwe code sturen';

  @override
  String get codeResent => 'Er is een nieuwe code onderweg';

  @override
  String get useDifferentEmail => 'Ander e-mailadres gebruiken';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get resetPassword => 'Wachtwoord opnieuw instellen';

  @override
  String resetCodeSentTo(String email) =>
      'We hebben een code naar $email gestuurd. Vul die in met een nieuw wachtwoord voor je account.';

  @override
  String get newPassword => 'Nieuw wachtwoord';

  @override
  String get saveNewPassword => 'Nieuw wachtwoord opslaan';

  @override
  String get backToSignIn => 'Terug naar inloggen';

  @override
  String get backupHint =>
      'Maak een back-up om een kopie van je uitgaven in je account te '
      'bewaren. Herstellen zet die kopie op deze telefoon zonder iets weg te '
      'halen wat er al staat.';

  @override
  String get backUpNow => 'Nu back-up maken';

  @override
  String get autoBackup => 'Automatisch back-uppen';

  @override
  String get autoBackupHint =>
      'Telkens als je de app verlaat, worden nieuwe wijzigingen naar je account geback-upt.';

  @override
  String get restoreData => 'Herstellen';

  @override
  String get backingUp => 'Back-up maken…';

  @override
  String get restoring => 'Herstellen…';

  @override
  String get backupDone => 'Back-up klaar';

  @override
  String get restoreDone => 'Herstel klaar';

  @override
  String get neverSynced => 'Nog geen back-up';

  @override
  String lastSynced(String when) => 'Laatst gesynchroniseerd: $when';

  @override
  String get deleteAccount => 'Account verwijderen';

  @override
  String get deleteAccountTitle => 'Je account verwijderen?';

  @override
  String get deleteAccountBody =>
      'Hiermee verwijder je je account en de back-up van je uitgaven die '
      'erbij hoort voorgoed. Dit kan niet ongedaan worden gemaakt. De '
      'uitgaven op deze telefoon blijven staan en je kunt de app zonder '
      'account blijven gebruiken.';

  @override
  String get deletingAccount => 'Je account wordt verwijderd…';

  @override
  String get accountDeleted => 'Je account is verwijderd';

  @override
  String get home => 'Start';

  @override
  String get analyses => 'Analyses';

  @override
  String get vsLastMonth => 'Vergeleken met vorige maand';

  @override
  String get noComparison => 'Geen gegevens vorige maand';

  @override
  String get dailySpending => 'Dagelijkse uitgaven';

  @override
  String get dailyAverage => 'Gemiddeld per dag';

  @override
  String get topDay => 'Hoogste dag';

  @override
  String get byCategory => 'Uitgaven per categorie';

  @override
  String get noSpendingThisMonth => 'Deze maand nog niets uitgegeven.';

  @override
  String get monthlyTrend => 'Laatste 6 maanden';

  @override
  String lastMonthTotal(String amount) => 'Vorige maand: $amount';

  @override
  String get budgets => 'Budgetten';

  @override
  String get monthlyBudget => 'Maandbudget';

  @override
  String get setMonthlyBudget => 'Stel een maandbudget in';

  @override
  String get setBudgetHint =>
      'Zie wat er over is en krijg een seintje voordat je te veel uitgeeft.';

  @override
  String get setBudget => 'Instellen';

  @override
  String get editBudget => 'Budget bewerken';

  @override
  String get removeBudget => 'Verwijderen';

  @override
  String get save => 'Opslaan';

  @override
  String amountLeft(String amount) => '$amount over';

  @override
  String amountOver(String amount) => '$amount boven budget';

  @override
  String spentOfLimit(String spent, String limit) =>
      '$spent van $limit uitgegeven';

  @override
  String amountSpent(String amount) => '$amount uitgegeven';

  @override
  String budgetUsed(String percent) => '$percent van het budget gebruikt';

  @override
  String get categoryBudgets => 'Categoriebudgetten';

  @override
  String get categoryBudgetsHint => 'Beperk wat je aan één categorie uitgeeft.';

  @override
  String categoryBudgetTitle(String name) => 'Budget voor $name';

  @override
  String get setLimit => 'Limiet instellen';

  @override
  String get closeToLimit => 'Bijna aan hun limiet';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Budgetten gelden elke maand opnieuw. Je krijgt een seintje als de '
      'uitgaven boven $nearing komen, en nog eens bij $reached.';

  @override
  String get budgetAlertTitle => 'Budgetmelding';

  @override
  String get ok => 'OK';

  @override
  String get view => 'Bekijken';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Je hebt $percent van je maandbudget gebruikt';

  @override
  String get monthlyBudgetUsedUp => 'Je hebt je hele maandbudget gebruikt';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Je zit $amount boven je maandbudget';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Je hebt $percent van je budget voor $name gebruikt';

  @override
  String categoryBudgetUsedUp(String name) =>
      'Je hebt je hele budget voor $name gebruikt';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Je zit $amount boven je budget voor $name';

  @override
  String get dataManagement => 'Gegevensbeheer';

  @override
  String get dataManagementHint =>
      'Bestanden die je zelf bewaart. Ze werken offline en zonder account.';

  @override
  String get backUpToFile => 'Back-up van mijn gegevens';

  @override
  String get backUpToFileHint =>
      'Een volledig back-upbestand dat je later kunt importeren';

  @override
  String get exportCsv => 'Exporteren als CSV';

  @override
  String get exportCsvHint => 'Voor Excel of Google Sheets';

  @override
  String get exportPdf => 'Exporteren als PDF';

  @override
  String get exportPdfHint => 'Een rapport om te lezen, printen of delen';

  @override
  String get importData => 'Gegevens importeren';

  @override
  String get importDataHint => 'Herstellen uit een back-upbestand';

  @override
  String get preparingFile => 'Je bestand wordt klaargemaakt…';

  @override
  String get importingData => 'Importeren…';

  @override
  String get fileSaved => 'Bestand opgeslagen';

  @override
  String get importDone => 'Import klaar';

  @override
  String get importNothingNew => 'Deze telefoon had alles uit de back-up al';

  @override
  String get fileReady => 'Je bestand is klaar';

  @override
  String get shareFile => 'Delen';

  @override
  String get shareFileHint => 'WhatsApp, e-mail, Google Drive en meer';

  @override
  String get saveToPhone => 'Op deze telefoon opslaan';

  @override
  String get saveToPhoneHint => 'Kies waar je het bewaart';

  @override
  String get importTitle => 'Deze back-up importeren?';

  @override
  String get importMergeHint =>
      'Samenvoegen houdt alles op deze telefoon en vult aan wat ontbreekt. '
      'Waar een item verschilt, wint de nieuwste wijziging.';

  @override
  String get merge => 'Samenvoegen';

  @override
  String get replaceEverything => 'Alles vervangen';

  @override
  String get replaceTitle => 'Alles op deze telefoon vervangen?';

  @override
  String get replaceBody =>
      'Alles op deze telefoon wat niet in de back-up staat, wordt verwijderd, '
      'en van elk item wordt de versie uit de back-up gebruikt. Dit kan niet '
      'ongedaan worden gemaakt.';

  @override
  String get replace => 'Vervangen';

  @override
  String get colDate => 'Datum';

  @override
  String get colMonth => 'Maand';

  @override
  String get colAmount => 'Bedrag';

  @override
  String get colNote => 'Notitie';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Transacties';

  @override
  String get colTotal => 'Totaal';

  @override
  String get colShare => 'Aandeel';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get reportTitle => 'Mijn Budget: uitgavenrapport';

  @override
  String get reportPeriod => 'Periode';

  @override
  String get reportTotal => 'Totaal uitgegeven';

  @override
  String get reportMonthlyAverage => 'Gemiddeld per maand';

  @override
  String get reportByMonth => 'Uitgaven per maand';

  @override
  String get reportAllExpenses => 'Alle uitgaven';

  @override
  String get reportEmpty => 'Nog geen uitgaven vastgelegd.';

  @override
  String get reportPageTemplate => 'Pagina {page} van {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} en ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} en '
              '${personCount(people)}';
    return date == null
        ? 'Deze back-up bevat $contents.'
        : 'Back-up van $date: $contents.';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count categorie',
    other: '$count categorieën',
  );

  @override
  String reportGenerated(String when) => 'Gemaakt op $when';

  @override
  String get showPassword => 'Wachtwoord tonen';

  @override
  String get hidePassword => 'Wachtwoord verbergen';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Eten',
    'cat_transport' => 'Vervoer',
    'cat_bills' => 'Rekeningen',
    'cat_shopping' => 'Winkelen',
    'cat_health' => 'Gezondheid & sport',
    'cat_entertainment' => 'Vrije tijd',
    'cat_work' => 'Werk',
    'cat_other' => 'Overig',
    'cat_salary' => 'Salaris',
    'cat_freelance' => 'Freelance',
    'cat_investments' => 'Beleggingen',
    'cat_gifts' => 'Cadeaus',
    'cat_income_other' => 'Overige inkomsten',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'Opslaan op dit apparaat is mislukt. Probeer het opnieuw.',
    FailureCode.notFound => 'Dat item bestaat niet meer.',
    FailureCode.unknown => 'Er ging iets mis.',
    FailureCode.amountRequired => 'Vul een bedrag boven nul in.',
    FailureCode.amountTooLarge => 'Dat bedrag is te hoog.',
    FailureCode.amountInvalid => 'Vul een geldig bedrag in.',
    FailureCode.categoryRequired => 'Kies een categorie.',
    FailureCode.categoryNameRequired => 'Geef de categorie een naam.',
    FailureCode.categoryNameTaken => 'Je hebt al een categorie met deze naam.',
    FailureCode.categoryNameTooLong => 'Houd de naam korter dan 30 tekens.',
    FailureCode.categoryProtected =>
      'Deze categorie kan niet worden verwijderd.',
    FailureCode.currencySymbolInvalid => 'Gebruik 1 tot 4 tekens.',
    FailureCode.network =>
      'Geen verbinding. Controleer je internet en probeer het opnieuw.',
    FailureCode.emailInvalid => 'Vul een geldig e-mailadres in.',
    FailureCode.passwordTooShort =>
      'Gebruik minstens 6 tekens voor het wachtwoord.',
    FailureCode.invalidCredentials => 'Verkeerd e-mailadres of wachtwoord.',
    FailureCode.emailTaken => 'Er bestaat al een account met dit e-mailadres.',
    FailureCode.emailNotConfirmed =>
      'Bevestig eerst je e-mail met de code die we je stuurden.',
    FailureCode.codeInvalid => 'Die code klopt niet of is verlopen.',
    FailureCode.signInRequired => 'Log opnieuw in en probeer het nog een keer.',
    FailureCode.syncOtherAccount =>
      'De gegevens op deze telefoon horen bij een ander account.',
    FailureCode.syncFailed =>
      'Synchroniseren met je account is mislukt. Probeer het opnieuw.',
    FailureCode.accountDeletionFailed =>
      'Je account kon niet worden verwijderd. Probeer het opnieuw.',
    FailureCode.backupNotRecognized =>
      'Dit bestand is geen back-up van Mijn Budget.',
    FailureCode.pastedNotRecognized =>
      'De geplakte tekst zijn geen gegevens die de app kan lezen. Kopieer het hele antwoord van de AI en probeer opnieuw, of vraag de AI het te verbeteren.',
    FailureCode.backupTooNew =>
      'Deze back-up komt uit een nieuwere versie van Mijn Budget. Werk de '
          'app bij en probeer het opnieuw.',
    FailureCode.backupDamaged =>
      'Dit back-upbestand is beschadigd, dus er is niets geïmporteerd.',
    FailureCode.fileUnavailable =>
      'Dat bestand kon niet worden geopend. Kies het nog eens.',
    FailureCode.storageFull =>
      'Er is niet genoeg vrije ruimte op deze telefoon.',
    FailureCode.exportFailed =>
      'Het bestand kon niet worden gemaakt. Probeer het opnieuw.',
    FailureCode.shareUnavailable => 'Het deelmenu kon niet worden geopend.',
    FailureCode.saveFailed =>
      'Het bestand kon niet worden opgeslagen. Probeer het opnieuw.',
    FailureCode.tooManyAttempts =>
      'Te veel pogingen. Wacht even en probeer het opnieuw.',
    FailureCode.titleRequired => 'Geef het een naam.',
    FailureCode.titleTooLong => 'Houd de naam korter dan 40 tekens.',
    FailureCode.dueDayInvalid => 'Kies wanneer het moet worden betaald.',
    FailureCode.alreadyPaid => 'Die betaling is al vastgelegd.',
    FailureCode.personRequired => 'Kies een persoon.',
    FailureCode.personNameRequired => 'Vul een naam in.',
    FailureCode.personNameTooLong => 'Houd de naam korter dan 40 tekens.',
    FailureCode.phoneInvalid => 'Vul een geldig telefoonnummer in.',
    FailureCode.transactionSettled =>
      'Verrekende transacties kunnen niet worden gewijzigd.',
    FailureCode.nothingToSettle => 'Er valt niets te verrekenen.',
    FailureCode.settlementAlreadyLogged =>
      'Deze verrekening staat al in je budget.',
  };

  @override
  String get expenseDeleted => 'Uitgave verwijderd';

  @override
  String get expenseRestored => 'Uitgave hersteld';

  @override
  String categoryAdded(String name) => '$name toegevoegd';

  @override
  String get categoryUpdated => 'Categorie bijgewerkt';

  @override
  String categoryDeleted(String name) => '$name verwijderd';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name verwijderd: ${expenseCount(count)} verplaatst naar Overig';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name verwijderd: ${transactionCount(count)} verplaatst naar Overige '
      'inkomsten';

  @override
  String get expense => 'Uitgave';

  @override
  String get income => 'Inkomsten';

  @override
  String get search => 'Zoeken';

  @override
  String get searchHint => 'Zoek notities of bedragen';

  @override
  String get searchPrompt =>
      'Vind een transactie via de notitie of het bedrag, of filter op soort, categorie en datum.';

  @override
  String get noSearchResults => 'Geen transacties gevonden';

  @override
  String get allTypes => 'Alles';

  @override
  String get anyCategory => 'Elke categorie';

  @override
  String get anyDate => 'Elke datum';

  @override
  String get clearFilters => 'Filters wissen';

  @override
  String get transactionType => 'Uitgave of inkomsten';

  @override
  String get quickIncome => 'Snelle inkomsten';

  @override
  String get newIncome => 'Nieuwe inkomsten';

  @override
  String get editIncome => 'Inkomsten bewerken';

  @override
  String get addIncome => 'Inkomsten toevoegen';

  @override
  String get incomeNoteHint => 'Waar kwam het vandaan?';

  @override
  String get totalIncome => 'Totale inkomsten';

  @override
  String get totalExpenses => 'Totale uitgaven';

  @override
  String get netBalance => 'Nettosaldo';

  @override
  String get savingsRate => 'Spaarquote';

  @override
  String get savingsRateNoIncome =>
      'Voeg inkomsten toe om je spaarquote te zien';

  @override
  String get expenseCategories => 'Uitgavencategorieën';

  @override
  String get incomeCategories => 'Inkomstencategorieën';

  @override
  String get deleteIncomeCategoryBody =>
      'Inkomsten in deze categorie gaan naar Overige inkomsten. Er wordt '
      'niets verwijderd.';

  @override
  String get incomeDeleted => 'Inkomsten verwijderd';

  @override
  String get incomeRestored => 'Inkomsten hersteld';

  @override
  String get colType => 'Soort';

  @override
  String transactionCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count transactie',
    other: '$count transacties',
  );

  @override
  String get recurringPayments => 'Terugkerende betalingen';

  @override
  String get newRecurring => 'Nieuwe terugkerende betaling';

  @override
  String get editRecurring => 'Terugkerende betaling bewerken';

  @override
  String get addRecurring => 'Betaling toevoegen';

  @override
  String get recurringTitle => 'Naam';

  @override
  String get recurringTitleHint => 'Huur, Netflix, sportschool…';

  @override
  String get amount => 'Bedrag';

  @override
  String get repeats => 'Herhaling';

  @override
  String get weekly => 'Wekelijks';

  @override
  String get monthly => 'Maandelijks';

  @override
  String get yearly => 'Jaarlijks';

  @override
  String get dueOn => 'Te betalen op';

  @override
  String get dueDayOfMonth => 'Dag van de maand';

  @override
  String get dueMonthLabel => 'Maand';

  @override
  String get dueDayLabel => 'Dag';

  @override
  String get shortMonthHint => 'In kortere maanden valt hij op de laatste dag.';

  @override
  String get whenDue => 'Bij de vervaldatum';

  @override
  String get autoDeduct => 'Automatisch';

  @override
  String get remindMe => 'Herinner me';

  @override
  String get autoDeductHint =>
      'Wordt op de vervaldatum automatisch als uitgave vastgelegd.';

  @override
  String get remindMeHint =>
      'Je bevestigt elke betaling voordat die wordt vastgelegd.';

  @override
  String get statusPaid => 'Betaald';

  @override
  String get statusUpcoming => 'Gepland';

  @override
  String get statusOverdue => 'Te laat';

  @override
  String get markAsPaid => 'Betaald';

  @override
  String get dueToday => 'Vandaag te betalen';

  @override
  String dueOnDate(String date) => 'Te betalen op $date';

  @override
  String nextDueOn(String date) => 'Volgende op $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Moest op $date'
      : '${paymentCount(count)} te laat sinds $date';

  @override
  String everyWeekday(String weekday) => 'Elke $weekday';

  @override
  String monthlyOnDay(String day) => 'Maandelijks op dag $day';

  @override
  String yearlyOn(String date) => 'Jaarlijks op $date';

  @override
  String get monthlyAverage => 'Per maand';

  @override
  String get monthlyAverageHint => 'Al je terugkerende betalingen, gemiddeld';

  @override
  String get noRecurringYet => 'Nog geen terugkerende betalingen';

  @override
  String get noRecurringHint =>
      'Voeg huur, rekeningen en abonnementen één keer toe. Elke maand zie je '
      'wat betaald is en wat nog openstaat.';

  @override
  String get paymentsToConfirm => 'Te bevestigen betalingen';

  @override
  String get seeAll => 'Alles';

  @override
  String get deleteRecurringBody =>
      'Hij herhaalt niet meer. Al vastgelegde betalingen blijven in je '
      'transacties.';

  @override
  String recurringPaid(String name) => '$name gemarkeerd als betaald';

  @override
  String recurringReceived(String name) => '$name gemarkeerd als ontvangen';

  @override
  String get statusReceived => 'Ontvangen';

  @override
  String get markAsReceived => 'Ontvangen';

  @override
  String get autoAdd => 'Automatisch';

  @override
  String get autoAddHint =>
      'Wordt op de vervaldatum automatisch als inkomsten vastgelegd.';

  @override
  String get monthlyIncomeAverage => 'Inkomsten per maand';

  @override
  String get recurringPaymentUndone => 'Betaling verwijderd';

  @override
  String recurringAutoLogged(int count) => plural(
    count,
    locale: localeName,
    one: '$count terugkerende betaling is automatisch vastgelegd',
    other: '$count terugkerende betalingen zijn automatisch vastgelegd',
  );

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count betaling',
    other: '$count betalingen',
  );

  @override
  String get colPaidThrough => 'Betaald tot';

  // People & debts

  @override
  String get people => 'Personen';

  @override
  String get peopleAndDebts => 'Personen & schulden';

  @override
  String get person => 'Persoon';

  @override
  String get personName => 'Naam';

  @override
  String get phone => 'Telefoon';

  @override
  String get phoneOptional => 'Telefoon (optioneel)';

  @override
  String get balance => 'Saldo';

  @override
  String get colStatus => 'Status';

  @override
  String get owesYou => 'Moet jou';

  @override
  String get youOwe => 'Jij moet';

  @override
  String get owedToYou => 'Tegoed';

  @override
  String get settledUp => 'Verrekend';

  @override
  String get iPaidForThem => 'Ik betaalde voor hen';

  @override
  String get theyPaidForMe => 'Zij betaalden voor mij';

  @override
  String get theyPaidYou => 'Betaalde jou';

  @override
  String get youPaidThem => 'Jij betaalde';

  @override
  String get openStatus => 'Open';

  @override
  String get settledStatus => 'Verrekend';

  @override
  String get settledOn => 'Verrekend op';

  @override
  String get createdOn => 'Gemaakt';

  @override
  String get lastEdited => 'Laatst bewerkt';

  @override
  String get colEdits => 'Wijzigingen';

  @override
  String get activeTransactions => 'Open transacties';

  @override
  String get settledHistory => 'Verrekende geschiedenis';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterOwedToMe => 'Tegoed';

  @override
  String get filterIOwe => 'Ik moet';

  @override
  String get filterSettled => 'Verrekend';

  @override
  String get addPerson => 'Persoon toevoegen';

  @override
  String get addPersonHint => 'Iemand met wie je kosten deelt';

  @override
  String get newPerson => 'Nieuwe persoon';

  @override
  String get editPerson => 'Persoon bewerken';

  @override
  String get deletePerson => 'Persoon verwijderen';

  @override
  String get quickTransaction => 'Snelle transactie';

  @override
  String get quickTransactionHint =>
      'Leg vast wie betaalde, met iemand die je al hebt toegevoegd';

  @override
  String get noPeopleYet => 'Nog geen personen';

  @override
  String get noPeopleHint =>
      'Voeg de mensen toe met wie je kosten deelt om bij te houden wie wie '
      'wat schuldig is.';

  @override
  String get nobodyHere => 'Niemand past bij dit filter.';

  @override
  String get addPersonFirst => 'Voeg eerst een persoon toe.';

  @override
  String get newTransaction => 'Nieuwe transactie';

  @override
  String get editTransaction => 'Transactie bewerken';

  @override
  String get transactionDetails => 'Transactiegegevens';

  @override
  String get debtNoteHint => 'Waar was het voor?';

  @override
  String get changeHistory => 'Wijzigingsgeschiedenis';

  @override
  String get edited => 'Bewerkt';

  @override
  String get settleUp => 'Verrekenen';

  @override
  String get settle => 'Verrekenen';

  @override
  String get noDebtsYet => 'Nog niets vastgelegd';

  @override
  String get noDebtsHint =>
      'Voeg toe wat jij voor hen betaalde, of wat zij voor jou betaalden.';

  @override
  String get settleEven =>
      'Deze transacties heffen elkaar op, dus er hoeft geen geld van eigenaar '
      'te wisselen.';

  @override
  String get logSettlementTitle =>
      'Deze verrekening in je maandbudget vastleggen?';

  @override
  String get loggedInBudget => 'In je budget';

  @override
  String get deleteTransactionTitle => 'Deze transactie verwijderen?';

  @override
  String get deleteTransactionBody =>
      'Ze wordt uit het saldo met deze persoon gehaald.';

  @override
  String get deletePersonBody =>
      'Hun transacties en verrekende geschiedenis worden ook verwijderd. Wat '
      'je in je budget hebt vastgelegd, blijft staan.';

  @override
  String get settledLocked => 'Verrekend, dus niet meer te wijzigen.';

  @override
  String get personUpdated => 'Persoon bijgewerkt';

  @override
  String get debtDeleted => 'Transactie verwijderd';

  @override
  String get settledUpNotice => 'Alles verrekend';

  @override
  String get settlementLogged => 'Toegevoegd aan je budget';

  @override
  String personOwesYou(String name) => '$name moet jou betalen';

  @override
  String youOwePerson(String name) => 'Jij moet $name betalen';

  @override
  String settledWith(String name) => 'Alles verrekend met $name';

  @override
  String settleUpFor(String amount) => '$amount verrekenen';

  @override
  String settleTitle(String name) => 'Verrekenen met $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name betaalt jou $amount en dan staat alles op nul.';

  @override
  String settleYouPay(String name, String amount) =>
      'Jij betaalt $name $amount en dan staat alles op nul.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} gaan naar de verrekende geschiedenis.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount wordt als inkomsten toegevoegd bij Overige inkomsten. Je kunt '
      'het later naar een andere categorie verplaatsen.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount wordt als uitgave toegevoegd bij Overig. Je kunt het later '
      'naar een andere categorie verplaatsen.';

  @override
  String settlementNote(String name) => 'Verrekening met $name';

  @override
  String settledGroupTitle(String date) => 'Verrekend op $date';

  @override
  String deletePersonTitle(String name) => '$name verwijderen?';

  @override
  String editedOn(String date) => 'Bewerkt op $date';

  @override
  String wasValues(String values) => 'Was: $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count persoon',
    other: '$count personen',
  );

  @override
  String get importFromAi => 'Uit een andere app';

  @override
  String get importFromAiHint =>
      'Zet je gegevens om met ChatGPT, Gemini, Claude of een andere AI';

  @override
  String get aiImportTitle => 'Importeren uit een andere app';

  @override
  String get aiImportIntro =>
      'Een AI-chat kan gegevens uit een andere app of spreadsheet omzetten in een bestand dat My Budget kan importeren.';

  @override
  String get aiImportStep1 => 'Kopieer de prompt.';

  @override
  String get aiImportStep2 =>
      'Plak hem in ChatGPT, Gemini, Claude of een andere AI en voeg je gegevens toe of plak ze.';

  @override
  String get aiImportStep3 =>
      'Kopieer het antwoord van de AI en plak het hier, of bewaar het als bestand en kies het.';

  @override
  String get copyPrompt => 'Prompt kopiëren';

  @override
  String get pasteAnswer => 'Antwoord plakken';

  @override
  String get chooseFile => 'Bestand kiezen';

  @override
  String get aiImportPrivacy =>
      'Je gegevens gaan naar de AI-dienst die je kiest. Je ziet wat er wordt geïmporteerd voordat er iets verandert.';

  @override
  String get promptCopied => 'Prompt gekopieerd';

  @override
  String get askTitle => 'Vraag over je uitgaven';

  @override
  String get askHint => 'Tik op een vraag om het antwoord te zien.';

  @override
  String get askCompareMonths => 'Maanden vergelijken';

  @override
  String get askTopCategory => 'Topcategorie';

  @override
  String get askVsLastMonth => 'vs vorige maand';

  @override
  String get askBiggestExpense => 'Grootste uitgave';

  @override
  String get askTopDay => 'Duurste dag';

  @override
  String get askWeekday => 'Duurste weekdag';

  @override
  String get askMonthEnd => 'Schatting maandeinde';

  @override
  String get askSaved => 'Heb ik gespaard?';

  @override
  String get askBudgetLeft => 'Budget over';

  @override
  String get askHighestLowest => 'Hoogste & laagste maand';

  @override
  String get askCount => 'Hoeveel uitgaven';

  @override
  String get askTopIncome => 'Grootste inkomen';

  @override
  String get otherCategories => 'Overige';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'Het meest aan $category: $amount ($percent van de maand).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Je gaf in $month $amount meer uit dan in $other (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Je gaf in $month $amount minder uit dan in $other (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'Je gaf in $month en $other evenveel uit.';

  @override
  String answerNothingIn(String month) => 'Geen uitgaven in $month.';

  @override
  String answerRise(String category, String amount) =>
      'Grootste stijging: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Grootste daling: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Grootste uitgave: $amount in $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Duurste dag: $date, met $amount uitgegeven.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Duurste weekdag: $weekday ($amount deze maand).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'In dit tempo (ongeveer $average per dag) geef je tegen het eind van de maand zo’n $amount uit.';

  @override
  String answerMonthTotal(String amount) =>
      'Deze maand is voorbij: je gaf in totaal $amount uit.';

  @override
  String answerSaved(String amount, String income) =>
      'Je spaarde $amount van je $income inkomen.';

  @override
  String answerOverspent(String amount) =>
      'Je gaf $amount meer uit dan je verdiende.';

  @override
  String get answerNoIncome => 'Geen inkomen geregistreerd deze maand.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'Nog $amount over in je maandbudget ($percent gebruikt).';

  @override
  String answerBudgetOver(String amount) =>
      'Je zit $amount boven je maandbudget.';

  @override
  String get answerNoBudget => 'Je hebt nog geen maandbudget ingesteld.';

  @override
  String answerOverLimit(String names) => 'Over de limiet: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'Hoogste maand: $high ($highAmount). Laagste: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'Je registreerde ${expenseCount(count)}, gemiddeld $average per stuk.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'Het meeste inkomen kwam van $category: $amount ($percent).';

  @override
  String? currencyName(String code) => switch (code) {
    'EGP' => 'Egyptisch pond',
    'USD' => 'Amerikaanse dollar',
    'EUR' => 'Euro',
    'SAR' => 'Saoedische riyal',
    'AED' => 'VAE-dirham',
    'KWD' => 'Koeweitse dinar',
    'QAR' => 'Qatarese rial',
    'BHD' => 'Bahreinse dinar',
    'OMR' => 'Omaanse rial',
    'JOD' => 'Jordaanse dinar',
    'IQD' => 'Iraakse dinar',
    'LBP' => 'Libanees pond',
    'SYP' => 'Syrisch pond',
    'YER' => 'Jemenitische rial',
    'SDG' => 'Soedanees pond',
    'LYD' => 'Libische dinar',
    'MAD' => 'Marokkaanse dirham',
    'TND' => 'Tunesische dinar',
    'DZD' => 'Algerijnse dinar',
    'GBP' => 'Brits pond',
    'TRY' => 'Turkse lira',
    'IRR' => 'Iraanse rial',
    'PKR' => 'Pakistaanse roepie',
    'INR' => 'Indiase roepie',
    'RUB' => 'Russische roebel',
    'UAH' => 'Oekraïense grivna',
    'PLN' => 'Poolse zloty',
    'CHF' => 'Zwitserse frank',
    'BRL' => 'Braziliaanse real',
    'CAD' => 'Canadese dollar',
    'AUD' => 'Australische dollar',
    'CNY' => 'Chinese yuan',
    'JPY' => 'Japanse yen',
    'KRW' => 'Zuid-Koreaanse won',
    'IDR' => 'Indonesische roepia',
    'MYR' => 'Maleisische ringgit',
    'VND' => 'Vietnamese dong',
    'NGN' => 'Nigeriaanse naira',
    _ => null,
  };
}
