import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsDe extends AppStrings {
  const AppStringsDe();

  @override
  String get localeName => 'de';

  @override
  String get appTitle => 'Mein Budget';

  @override
  String get add => 'Hinzufügen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get nothingRecordedYet => 'Noch nichts erfasst';

  @override
  String get emptyMonthHint =>
      'Tippe auf Hinzufügen, um deine erste Ausgabe oder Einnahme in diesem '
      'Monat zu erfassen.';

  @override
  String get yourMonths => 'Deine Monate';

  @override
  String spentIn(String month) => 'Ausgaben im $month';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count Ausgabe',
    other: '$count Ausgaben',
  );

  @override
  String get quickExpense => 'Schnelle Ausgabe';

  @override
  String get expenseSaved => 'Ausgabe gespeichert';

  @override
  String get newExpense => 'Neue Ausgabe';

  @override
  String get editExpense => 'Ausgabe bearbeiten';

  @override
  String get when => 'Wann';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get pickADate => 'Datum wählen';

  @override
  String get category => 'Kategorie';

  @override
  String get noteOptional => 'Notiz (optional)';

  @override
  String get noteHint => 'Wofür war das?';

  @override
  String get addExpense => 'Ausgabe hinzufügen';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Kategorien';

  @override
  String get newCategory => 'Neue Kategorie';

  @override
  String get editCategory => 'Kategorie bearbeiten';

  @override
  String get addCategory => 'Kategorie hinzufügen';

  @override
  String get categoryName => 'Name';

  @override
  String get color => 'Farbe';

  @override
  String get icon => 'Symbol';

  @override
  String get builtIn => 'Vorgegeben';

  @override
  String get custom => 'Eigene';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String deleteCategoryTitle(String name) => '$name löschen?';

  @override
  String get deleteCategoryBody =>
      'Ausgaben dieser Kategorie werden nach Sonstiges verschoben. Nichts '
      'wird gelöscht.';

  @override
  String get settings => 'Einstellungen';

  @override
  String get appearance => 'Darstellung';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'System';

  @override
  String get currency => 'Währung';

  @override
  String get currencySymbol => 'Symbol';

  @override
  String get currencySymbolHint => 'Wird neben jedem Betrag angezeigt';

  @override
  String get currencyOther => 'Andere';

  @override
  String get reminders => 'Erinnerungen';

  @override
  String get dailyReminder => 'Tägliche Erinnerung';

  @override
  String get dailyReminderHint =>
      'Ein Hinweis, deine Ausgaben von heute einzutragen';

  @override
  String get reminderTime => 'Uhrzeit';

  @override
  String get notificationsBlocked =>
      'Benachrichtigungen sind für diese App aus. Erlaube sie in den Einstellungen deines Handys.';

  @override
  String get reminderNotificationTitle => 'Heutige Ausgaben eintragen';

  @override
  String get reminderNotificationBody =>
      'Nimm dir kurz Zeit und trag ein, was du heute ausgegeben hast.';

  @override
  String get security => 'Sicherheit';

  @override
  String get appLock => 'App-Sperre';

  @override
  String get appLockHint =>
      'Beim Öffnen nach Fingerabdruck, Gesicht oder Displaysperre fragen';

  @override
  String get appLockUnavailable =>
      'Richte zuerst eine Displaysperre auf diesem Handy ein';

  @override
  String get unlock => 'Entsperren';

  @override
  String get unlockToContinue => 'Entsperre, um dein Budget zu sehen';

  @override
  String get confirmItsYou =>
      'Bestätige, dass du es bist, um die Sperre zu ändern';

  @override
  String get storedOnThisDevice =>
      'Deine Ausgaben werden auf diesem Gerät gespeichert. Melde dich an, um '
      'sie zu sichern.';

  @override
  String get account => 'Konto';

  @override
  String get accountOptional =>
      'Ein Konto ist optional. Die App funktioniert auch ohne vollständig.';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signedIn => 'Angemeldet';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get noAccountYet => 'Noch kein Konto? Jetzt erstellen';

  @override
  String get haveAnAccount => 'Schon ein Konto? Anmelden';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get passwordRules => 'Mindestens 6 Zeichen';

  @override
  String get confirmEmail => 'E-Mail bestätigen';

  @override
  String codeSentTo(String email) =>
      'Wir haben einen Code an $email gesendet. Gib ihn unten ein, um dein '
      'Konto fertig zu erstellen.';

  @override
  String get confirmationCode => 'Code';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get resendCode => 'Neuen Code senden';

  @override
  String get codeResent => 'Ein neuer Code ist unterwegs';

  @override
  String get useDifferentEmail => 'Andere E-Mail verwenden';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get resetPassword => 'Passwort zurücksetzen';

  @override
  String resetCodeSentTo(String email) =>
      'Wir haben einen Code an $email gesendet. Gib ihn mit einem neuen Passwort für dein Konto ein.';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get saveNewPassword => 'Passwort speichern';

  @override
  String get backToSignIn => 'Zurück zur Anmeldung';

  @override
  String get backupHint =>
      'Sichere deine Ausgaben, um eine Kopie in deinem Konto zu behalten. '
      'Wiederherstellen holt diese Kopie auf dieses Handy, ohne etwas zu '
      'entfernen, das schon hier ist.';

  @override
  String get backUpNow => 'Jetzt sichern';

  @override
  String get autoBackup => 'Automatisch sichern';

  @override
  String get autoBackupHint =>
      'Immer wenn du die App verlässt, werden neue Änderungen in deinem Konto gesichert.';

  @override
  String get restoreData => 'Wiederherstellen';

  @override
  String get backingUp => 'Wird gesichert…';

  @override
  String get restoring => 'Wird wiederhergestellt…';

  @override
  String get backupDone => 'Sicherung abgeschlossen';

  @override
  String get restoreDone => 'Wiederherstellung abgeschlossen';

  @override
  String get neverSynced => 'Noch nicht gesichert';

  @override
  String lastSynced(String when) => 'Zuletzt synchronisiert: $when';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountTitle => 'Dein Konto löschen?';

  @override
  String get deleteAccountBody =>
      'Dadurch werden dein Konto und die darin gespeicherte Sicherung deiner '
      'Ausgaben endgültig gelöscht. Das lässt sich nicht rückgängig machen. '
      'Die Ausgaben auf diesem Handy bleiben erhalten, und du kannst die App '
      'ohne Konto weiter nutzen.';

  @override
  String get deletingAccount => 'Dein Konto wird gelöscht…';

  @override
  String get accountDeleted => 'Dein Konto wurde gelöscht';

  @override
  String get home => 'Start';

  @override
  String get analyses => 'Analysen';

  @override
  String get vsLastMonth => 'Im Vergleich zum Vormonat';

  @override
  String get noComparison => 'Keine Daten im Vormonat';

  @override
  String get dailySpending => 'Tägliche Ausgaben';

  @override
  String get dailyAverage => 'Durchschnitt pro Tag';

  @override
  String get topDay => 'Höchster Tag';

  @override
  String get byCategory => 'Ausgaben nach Kategorie';

  @override
  String get noSpendingThisMonth => 'Diesen Monat noch keine Ausgaben.';

  @override
  String get monthlyTrend => 'Letzte 6 Monate';

  @override
  String lastMonthTotal(String amount) => 'Vormonat: $amount';

  @override
  String get budgets => 'Budgets';

  @override
  String get monthlyBudget => 'Monatsbudget';

  @override
  String get setMonthlyBudget => 'Monatsbudget festlegen';

  @override
  String get setBudgetHint =>
      'Sieh, was übrig ist, und werde gewarnt, bevor du zu viel ausgibst.';

  @override
  String get setBudget => 'Festlegen';

  @override
  String get editBudget => 'Budget bearbeiten';

  @override
  String get removeBudget => 'Entfernen';

  @override
  String get save => 'Speichern';

  @override
  String amountLeft(String amount) => '$amount übrig';

  @override
  String amountOver(String amount) => '$amount über dem Budget';

  @override
  String spentOfLimit(String spent, String limit) =>
      '$spent von $limit ausgegeben';

  @override
  String amountSpent(String amount) => '$amount ausgegeben';

  @override
  String budgetUsed(String percent) => '$percent des Budgets verbraucht';

  @override
  String get categoryBudgets => 'Kategoriebudgets';

  @override
  String get categoryBudgetsHint =>
      'Begrenze, was du in einer Kategorie ausgibst.';

  @override
  String categoryBudgetTitle(String name) => 'Budget für $name';

  @override
  String get setLimit => 'Limit festlegen';

  @override
  String get closeToLimit => 'Nahe am Limit';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Budgets gelten jeden Monat neu. Du wirst gewarnt, wenn die Ausgaben '
      '$nearing überschreiten, und noch einmal bei $reached.';

  @override
  String get budgetAlertTitle => 'Budgetwarnung';

  @override
  String get ok => 'OK';

  @override
  String get view => 'Ansehen';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Du hast $percent deines Monatsbudgets verbraucht';

  @override
  String get monthlyBudgetUsedUp =>
      'Du hast dein ganzes Monatsbudget verbraucht';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Du liegst $amount über deinem Monatsbudget';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Du hast $percent deines Budgets für $name verbraucht';

  @override
  String categoryBudgetUsedUp(String name) =>
      'Du hast dein ganzes Budget für $name verbraucht';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Du liegst $amount über deinem Budget für $name';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get dataManagementHint =>
      'Dateien, die du selbst aufbewahrst. Sie funktionieren offline und '
      'ohne Konto.';

  @override
  String get backUpToFile => 'Meine Daten sichern';

  @override
  String get backUpToFileHint =>
      'Eine vollständige Sicherungsdatei, die du später importieren kannst';

  @override
  String get exportCsv => 'Als CSV exportieren';

  @override
  String get exportCsvHint => 'Für Excel oder Google Sheets';

  @override
  String get exportPdf => 'Als PDF exportieren';

  @override
  String get exportPdfHint => 'Ein Bericht zum Lesen, Drucken oder Teilen';

  @override
  String get importData => 'Daten importieren';

  @override
  String get importDataHint => 'Aus einer Sicherungsdatei wiederherstellen';

  @override
  String get preparingFile => 'Datei wird vorbereitet…';

  @override
  String get importingData => 'Wird importiert…';

  @override
  String get fileSaved => 'Datei gespeichert';

  @override
  String get importDone => 'Import abgeschlossen';

  @override
  String get importNothingNew =>
      'Auf diesem Handy war bereits alles aus der Sicherung';

  @override
  String get fileReady => 'Deine Datei ist fertig';

  @override
  String get shareFile => 'Teilen';

  @override
  String get shareFileHint => 'WhatsApp, E-Mail, Google Drive und mehr';

  @override
  String get saveToPhone => 'Auf diesem Handy speichern';

  @override
  String get saveToPhoneHint => 'Wähle, wo sie liegen soll';

  @override
  String get importTitle => 'Diese Sicherung importieren?';

  @override
  String get importMergeHint =>
      'Zusammenführen behält alles auf diesem Handy und ergänzt, was fehlt. '
      'Wo sich ein Eintrag unterscheidet, gewinnt die neuere Änderung.';

  @override
  String get merge => 'Zusammenführen';

  @override
  String get replaceEverything => 'Alles ersetzen';

  @override
  String get replaceTitle => 'Alles auf diesem Handy ersetzen?';

  @override
  String get replaceBody =>
      'Alles auf diesem Handy, was nicht in der Sicherung ist, wird gelöscht, '
      'und für jeden Eintrag wird die Version aus der Sicherung verwendet. '
      'Das lässt sich nicht rückgängig machen.';

  @override
  String get replace => 'Ersetzen';

  @override
  String get colDate => 'Datum';

  @override
  String get colMonth => 'Monat';

  @override
  String get colAmount => 'Betrag';

  @override
  String get colNote => 'Notiz';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Buchungen';

  @override
  String get colTotal => 'Summe';

  @override
  String get colShare => 'Anteil';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get reportTitle => 'Mein Budget: Ausgabenbericht';

  @override
  String get reportPeriod => 'Zeitraum';

  @override
  String get reportTotal => 'Ausgaben gesamt';

  @override
  String get reportMonthlyAverage => 'Durchschnitt pro Monat';

  @override
  String get reportByMonth => 'Ausgaben nach Monat';

  @override
  String get reportAllExpenses => 'Alle Ausgaben';

  @override
  String get reportEmpty => 'Noch keine Ausgaben erfasst.';

  @override
  String get reportPageTemplate => 'Seite {page} von {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} und ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} und '
              '${personCount(people)}';
    return date == null
        ? 'Diese Sicherung enthält $contents.'
        : 'Sicherung vom $date: $contents.';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count Kategorie',
    other: '$count Kategorien',
  );

  @override
  String reportGenerated(String when) => 'Erstellt am $when';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Essen',
    'cat_transport' => 'Verkehr',
    'cat_bills' => 'Rechnungen',
    'cat_shopping' => 'Einkäufe',
    'cat_health' => 'Gesundheit & Sport',
    'cat_entertainment' => 'Freizeit',
    'cat_work' => 'Arbeit',
    'cat_other' => 'Sonstiges',
    'cat_salary' => 'Gehalt',
    'cat_freelance' => 'Freiberuflich',
    'cat_investments' => 'Geldanlagen',
    'cat_gifts' => 'Geschenke',
    'cat_income_other' => 'Sonstige Einnahmen',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'Speichern auf diesem Gerät fehlgeschlagen. Versuch es noch einmal.',
    FailureCode.notFound => 'Dieser Eintrag existiert nicht mehr.',
    FailureCode.unknown => 'Etwas ist schiefgelaufen.',
    FailureCode.amountRequired => 'Gib einen Betrag über null ein.',
    FailureCode.amountTooLarge => 'Dieser Betrag ist zu hoch.',
    FailureCode.amountInvalid => 'Gib einen gültigen Betrag ein.',
    FailureCode.categoryRequired => 'Wähle eine Kategorie.',
    FailureCode.categoryNameRequired => 'Gib der Kategorie einen Namen.',
    FailureCode.categoryNameTaken =>
      'Du hast bereits eine Kategorie mit diesem Namen.',
    FailureCode.categoryNameTooLong =>
      'Der Name muss kürzer als 30 Zeichen sein.',
    FailureCode.categoryProtected =>
      'Diese Kategorie kann nicht gelöscht werden.',
    FailureCode.currencySymbolInvalid => 'Verwende 1 bis 4 Zeichen.',
    FailureCode.network =>
      'Keine Verbindung. Prüfe dein Internet und versuch es noch einmal.',
    FailureCode.emailInvalid => 'Gib eine gültige E-Mail-Adresse ein.',
    FailureCode.passwordTooShort =>
      'Das Passwort braucht mindestens 6 Zeichen.',
    FailureCode.invalidCredentials => 'E-Mail oder Passwort ist falsch.',
    FailureCode.emailTaken => 'Mit dieser E-Mail gibt es schon ein Konto.',
    FailureCode.emailNotConfirmed =>
      'Bestätige zuerst deine E-Mail mit dem Code, den wir dir geschickt '
          'haben.',
    FailureCode.codeInvalid => 'Der Code ist falsch oder abgelaufen.',
    FailureCode.signInRequired =>
      'Melde dich erneut an und versuch es noch einmal.',
    FailureCode.syncOtherAccount =>
      'Die Daten auf diesem Handy gehören zu einem anderen Konto.',
    FailureCode.syncFailed =>
      'Synchronisieren mit deinem Konto fehlgeschlagen. Versuch es noch '
          'einmal.',
    FailureCode.accountDeletionFailed =>
      'Dein Konto konnte nicht gelöscht werden. Versuch es noch einmal.',
    FailureCode.backupNotRecognized =>
      'Diese Datei ist keine Sicherung von Mein Budget.',
    FailureCode.pastedNotRecognized =>
      'Der eingefügte Text sind keine Daten, die die App lesen kann. Kopiere die ganze Antwort der KI und versuche es erneut, oder bitte die KI, sie zu korrigieren.',
    FailureCode.backupTooNew =>
      'Diese Sicherung stammt aus einer neueren Version von Mein Budget. '
          'Aktualisiere die App und versuch es noch einmal.',
    FailureCode.backupDamaged =>
      'Diese Sicherungsdatei ist beschädigt, daher wurde nichts importiert.',
    FailureCode.fileUnavailable =>
      'Die Datei konnte nicht geöffnet werden. Wähle sie noch einmal aus.',
    FailureCode.storageFull =>
      'Auf diesem Handy ist nicht genug Speicherplatz frei.',
    FailureCode.exportFailed =>
      'Die Datei konnte nicht erstellt werden. Versuch es noch einmal.',
    FailureCode.shareUnavailable =>
      'Das Teilen-Menü konnte nicht geöffnet werden.',
    FailureCode.saveFailed =>
      'Die Datei konnte nicht gespeichert werden. Versuch es noch einmal.',
    FailureCode.tooManyAttempts =>
      'Zu viele Versuche. Warte kurz und versuch es noch einmal.',
    FailureCode.titleRequired => 'Gib einen Namen ein.',
    FailureCode.titleTooLong => 'Der Name muss kürzer als 40 Zeichen sein.',
    FailureCode.dueDayInvalid => 'Wähle, wann die Zahlung fällig ist.',
    FailureCode.alreadyPaid => 'Diese Zahlung ist schon erfasst.',
    FailureCode.personRequired => 'Wähle eine Person.',
    FailureCode.personNameRequired => 'Gib einen Namen ein.',
    FailureCode.personNameTooLong =>
      'Der Name muss kürzer als 40 Zeichen sein.',
    FailureCode.phoneInvalid => 'Gib eine gültige Telefonnummer ein.',
    FailureCode.transactionSettled =>
      'Ausgeglichene Buchungen können nicht geändert werden.',
    FailureCode.nothingToSettle => 'Es gibt nichts auszugleichen.',
    FailureCode.settlementAlreadyLogged =>
      'Dieser Ausgleich ist schon in deinem Budget.',
  };

  @override
  String get expenseDeleted => 'Ausgabe gelöscht';

  @override
  String get expenseRestored => 'Ausgabe wiederhergestellt';

  @override
  String categoryAdded(String name) => '$name hinzugefügt';

  @override
  String get categoryUpdated => 'Kategorie aktualisiert';

  @override
  String categoryDeleted(String name) => '$name gelöscht';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name gelöscht – ${expenseCount(count)} nach Sonstiges verschoben';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name gelöscht – ${transactionCount(count)} nach Sonstige Einnahmen '
      'verschoben';

  @override
  String get expense => 'Ausgabe';

  @override
  String get income => 'Einnahme';

  @override
  String get search => 'Suchen';

  @override
  String get searchHint => 'Notizen oder Beträge suchen';

  @override
  String get searchPrompt =>
      'Finde jede Buchung über Notiz oder Betrag, oder filtere nach Art, Kategorie und Datum.';

  @override
  String get noSearchResults => 'Keine passenden Buchungen';

  @override
  String get allTypes => 'Alle';

  @override
  String get anyCategory => 'Alle Kategorien';

  @override
  String get anyDate => 'Beliebiges Datum';

  @override
  String get clearFilters => 'Filter löschen';

  @override
  String get transactionType => 'Ausgabe oder Einnahme';

  @override
  String get quickIncome => 'Schnelle Einnahme';

  @override
  String get newIncome => 'Neue Einnahme';

  @override
  String get editIncome => 'Einnahme bearbeiten';

  @override
  String get addIncome => 'Einnahme hinzufügen';

  @override
  String get incomeNoteHint => 'Woher kam das Geld?';

  @override
  String get totalIncome => 'Einnahmen gesamt';

  @override
  String get totalExpenses => 'Ausgaben gesamt';

  @override
  String get netBalance => 'Saldo';

  @override
  String get savingsRate => 'Sparquote';

  @override
  String get savingsRateNoIncome =>
      'Erfasse Einnahmen, um deine Sparquote zu sehen';

  @override
  String get expenseCategories => 'Ausgabenkategorien';

  @override
  String get incomeCategories => 'Einnahmenkategorien';

  @override
  String get deleteIncomeCategoryBody =>
      'Einnahmen dieser Kategorie werden nach Sonstige Einnahmen verschoben. '
      'Nichts wird gelöscht.';

  @override
  String get incomeDeleted => 'Einnahme gelöscht';

  @override
  String get incomeRestored => 'Einnahme wiederhergestellt';

  @override
  String get colType => 'Art';

  @override
  String transactionCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count Buchung',
    other: '$count Buchungen',
  );

  @override
  String get recurringPayments => 'Wiederkehrende Zahlungen';

  @override
  String get newRecurring => 'Neue wiederkehrende Zahlung';

  @override
  String get editRecurring => 'Wiederkehrende Zahlung bearbeiten';

  @override
  String get addRecurring => 'Zahlung hinzufügen';

  @override
  String get recurringTitle => 'Name';

  @override
  String get recurringTitleHint => 'Miete, Netflix, Fitnessstudio…';

  @override
  String get amount => 'Betrag';

  @override
  String get repeats => 'Wiederholung';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get monthly => 'Monatlich';

  @override
  String get yearly => 'Jährlich';

  @override
  String get dueOn => 'Fällig am';

  @override
  String get dueDayOfMonth => 'Tag im Monat';

  @override
  String get dueMonthLabel => 'Monat';

  @override
  String get dueDayLabel => 'Tag';

  @override
  String get shortMonthHint =>
      'In kürzeren Monaten fällt sie auf den letzten Tag.';

  @override
  String get whenDue => 'Bei Fälligkeit';

  @override
  String get autoDeduct => 'Automatisch';

  @override
  String get remindMe => 'Erinnern';

  @override
  String get autoDeductHint =>
      'Wird am Fälligkeitstag automatisch als Ausgabe erfasst.';

  @override
  String get remindMeHint =>
      'Du bestätigst jede Zahlung, bevor sie erfasst wird.';

  @override
  String get statusPaid => 'Bezahlt';

  @override
  String get statusUpcoming => 'Anstehend';

  @override
  String get statusOverdue => 'Überfällig';

  @override
  String get markAsPaid => 'Bezahlt';

  @override
  String get dueToday => 'Heute fällig';

  @override
  String dueOnDate(String date) => 'Fällig am $date';

  @override
  String nextDueOn(String date) => 'Nächste am $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'War fällig am $date'
      : '${paymentCount(count)} überfällig seit $date';

  @override
  String everyWeekday(String weekday) => 'Jeden $weekday';

  @override
  String monthlyOnDay(String day) => 'Monatlich am $day.';

  @override
  String yearlyOn(String date) => 'Jährlich am $date';

  @override
  String get monthlyAverage => 'Pro Monat';

  @override
  String get monthlyAverageHint =>
      'Alle wiederkehrenden Zahlungen im Durchschnitt';

  @override
  String get noRecurringYet => 'Noch keine wiederkehrenden Zahlungen';

  @override
  String get noRecurringHint =>
      'Trage Miete, Rechnungen und Abos einmal ein. Jeden Monat siehst du, '
      'was bezahlt ist und was noch aussteht.';

  @override
  String get paymentsToConfirm => 'Zu bestätigende Zahlungen';

  @override
  String get seeAll => 'Alle';

  @override
  String get deleteRecurringBody =>
      'Sie wiederholt sich nicht mehr. Bereits erfasste Zahlungen bleiben in '
      'deinen Buchungen.';

  @override
  String recurringPaid(String name) => '$name als bezahlt markiert';

  @override
  String recurringReceived(String name) => '$name als erhalten markiert';

  @override
  String get statusReceived => 'Erhalten';

  @override
  String get markAsReceived => 'Erhalten';

  @override
  String get autoAdd => 'Automatisch';

  @override
  String get autoAddHint =>
      'Wird am Fälligkeitstag automatisch als Einnahme erfasst.';

  @override
  String get monthlyIncomeAverage => 'Einnahmen pro Monat';

  @override
  String get recurringPaymentUndone => 'Zahlung entfernt';

  @override
  String recurringAutoLogged(int count) => plural(
    count,
    locale: localeName,
    one: '$count wiederkehrende Zahlung wurde automatisch erfasst',
    other: '$count wiederkehrende Zahlungen wurden automatisch erfasst',
  );

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count Zahlung',
    other: '$count Zahlungen',
  );

  @override
  String get colPaidThrough => 'Bezahlt bis';

  // People & debts

  @override
  String get people => 'Personen';

  @override
  String get peopleAndDebts => 'Personen & Schulden';

  @override
  String get person => 'Person';

  @override
  String get personName => 'Name';

  @override
  String get phone => 'Telefon';

  @override
  String get phoneOptional => 'Telefon (optional)';

  @override
  String get balance => 'Saldo';

  @override
  String get colStatus => 'Status';

  @override
  String get owesYou => 'Schuldet dir';

  @override
  String get youOwe => 'Du schuldest';

  @override
  String get owedToYou => 'Du bekommst';

  @override
  String get settledUp => 'Ausgeglichen';

  @override
  String get iPaidForThem => 'Ich habe bezahlt';

  @override
  String get theyPaidForMe => 'Für mich bezahlt';

  @override
  String get theyPaidYou => 'Hat dich bezahlt';

  @override
  String get youPaidThem => 'Du hast bezahlt';

  @override
  String get openStatus => 'Offen';

  @override
  String get settledStatus => 'Ausgeglichen';

  @override
  String get settledOn => 'Ausgeglichen am';

  @override
  String get createdOn => 'Erstellt';

  @override
  String get lastEdited => 'Zuletzt bearbeitet';

  @override
  String get colEdits => 'Änderungen';

  @override
  String get activeTransactions => 'Offene Buchungen';

  @override
  String get settledHistory => 'Ausgeglichene Buchungen';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterOwedToMe => 'Bekomme ich';

  @override
  String get filterIOwe => 'Schulde ich';

  @override
  String get filterSettled => 'Erledigt';

  @override
  String get addPerson => 'Person hinzufügen';

  @override
  String get addPersonHint => 'Jemand, mit dem du Kosten teilst';

  @override
  String get newPerson => 'Neue Person';

  @override
  String get editPerson => 'Person bearbeiten';

  @override
  String get deletePerson => 'Person löschen';

  @override
  String get quickTransaction => 'Schnelle Buchung';

  @override
  String get quickTransactionHint =>
      'Erfasse, wer bezahlt hat, mit jemandem aus deiner Liste';

  @override
  String get noPeopleYet => 'Noch keine Personen';

  @override
  String get noPeopleHint =>
      'Füge die Leute hinzu, mit denen du Kosten teilst, um zu sehen, wer '
      'wem etwas schuldet.';

  @override
  String get nobodyHere => 'Niemand passt zu diesem Filter.';

  @override
  String get addPersonFirst => 'Füge zuerst eine Person hinzu.';

  @override
  String get newTransaction => 'Neue Buchung';

  @override
  String get editTransaction => 'Buchung bearbeiten';

  @override
  String get transactionDetails => 'Buchungsdetails';

  @override
  String get debtNoteHint => 'Wofür war das?';

  @override
  String get changeHistory => 'Änderungsverlauf';

  @override
  String get edited => 'Bearbeitet';

  @override
  String get settleUp => 'Ausgleichen';

  @override
  String get settle => 'Ausgleichen';

  @override
  String get noDebtsYet => 'Noch nichts erfasst';

  @override
  String get noDebtsHint =>
      'Erfasse, was du für die Person bezahlt hast oder sie für dich.';

  @override
  String get settleEven =>
      'Diese Buchungen gleichen sich aus, es muss also kein Geld fließen.';

  @override
  String get logSettlementTitle =>
      'Diesen Ausgleich in deinem Monatsbudget erfassen?';

  @override
  String get loggedInBudget => 'In deinem Budget';

  @override
  String get deleteTransactionTitle => 'Diese Buchung löschen?';

  @override
  String get deleteTransactionBody =>
      'Sie wird aus dem Saldo mit dieser Person entfernt.';

  @override
  String get deletePersonBody =>
      'Die Buchungen und ausgeglichenen Buchungen dieser Person werden auch '
      'gelöscht. Was du in deinem Budget erfasst hast, bleibt.';

  @override
  String get settledLocked => 'Ausgeglichen, daher nicht mehr änderbar.';

  @override
  String get personUpdated => 'Person aktualisiert';

  @override
  String get debtDeleted => 'Buchung gelöscht';

  @override
  String get settledUpNotice => 'Alles ausgeglichen';

  @override
  String get settlementLogged => 'Zu deinem Budget hinzugefügt';

  @override
  String personOwesYou(String name) => '$name schuldet dir';

  @override
  String youOwePerson(String name) => 'Du schuldest $name';

  @override
  String settledWith(String name) => 'Mit $name ist alles ausgeglichen';

  @override
  String settleUpFor(String amount) => '$amount ausgleichen';

  @override
  String settleTitle(String name) => 'Mit $name ausgleichen?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name zahlt dir $amount, dann ist alles ausgeglichen.';

  @override
  String settleYouPay(String name, String amount) =>
      'Du zahlst $name $amount, dann ist alles ausgeglichen.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} wandern zu den ausgeglichenen Buchungen.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount wird als Einnahme unter Sonstige Einnahmen erfasst. Du kannst '
      'sie später in eine andere Kategorie verschieben.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount wird als Ausgabe unter Sonstiges erfasst. Du kannst sie '
      'später in eine andere Kategorie verschieben.';

  @override
  String settlementNote(String name) => 'Ausgleich mit $name';

  @override
  String settledGroupTitle(String date) => 'Ausgeglichen am $date';

  @override
  String deletePersonTitle(String name) => '$name löschen?';

  @override
  String editedOn(String date) => 'Bearbeitet am $date';

  @override
  String wasValues(String values) => 'Vorher: $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count Person',
    other: '$count Personen',
  );

  @override
  String get importFromAi => 'Aus einer anderen App';

  @override
  String get importFromAiHint =>
      'Wandle deine Daten mit ChatGPT, Gemini, Claude oder einer anderen KI um';

  @override
  String get aiImportTitle => 'Aus einer anderen App importieren';

  @override
  String get aiImportIntro =>
      'Ein KI-Chat kann Daten aus einer anderen App oder Tabelle in eine Datei umwandeln, die My Budget importieren kann.';

  @override
  String get aiImportStep1 => 'Kopiere den Prompt.';

  @override
  String get aiImportStep2 =>
      'Füge ihn in ChatGPT, Gemini, Claude oder eine andere KI ein und hänge deine Daten an oder füge sie ein.';

  @override
  String get aiImportStep3 =>
      'Kopiere die Antwort der KI und füge sie hier ein, oder speichere sie als Datei und wähle sie aus.';

  @override
  String get copyPrompt => 'Prompt kopieren';

  @override
  String get pasteAnswer => 'Antwort einfügen';

  @override
  String get chooseFile => 'Datei wählen';

  @override
  String get aiImportPrivacy =>
      'Deine Daten gehen an den KI-Dienst deiner Wahl. Du siehst, was importiert wird, bevor sich etwas ändert.';

  @override
  String get promptCopied => 'Prompt kopiert';

  @override
  String get askTitle => 'Fragen zu deinen Ausgaben';

  @override
  String get askHint => 'Tippe auf eine Frage, um die Antwort zu sehen.';

  @override
  String get askCompareMonths => 'Monate vergleichen';

  @override
  String get askTopCategory => 'Top-Kategorie';

  @override
  String get askVsLastMonth => 'vs. Vormonat';

  @override
  String get askBiggestExpense => 'Größte Ausgabe';

  @override
  String get askTopDay => 'Teuerster Tag';

  @override
  String get askWeekday => 'Teuerster Wochentag';

  @override
  String get askMonthEnd => 'Prognose Monatsende';

  @override
  String get askSaved => 'Gespart?';

  @override
  String get askBudgetLeft => 'Budget übrig';

  @override
  String get askHighestLowest => 'Höchster & niedrigster Monat';

  @override
  String get askCount => 'Wie viele Ausgaben';

  @override
  String get askTopIncome => 'Top-Einnahme';

  @override
  String get otherCategories => 'Andere';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'Am meisten für $category: $amount ($percent des Monats).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Im $month hast du $amount mehr ausgegeben als im $other (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) =>
      'Im $month hast du $amount weniger ausgegeben als im $other (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'Im $month und im $other hast du gleich viel ausgegeben.';

  @override
  String answerNothingIn(String month) => 'Im $month gab es keine Ausgaben.';

  @override
  String answerRise(String category, String amount) =>
      'Größter Anstieg: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Größter Rückgang: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Größte Ausgabe: $amount in $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Teuerster Tag: $date mit $amount.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Teuerster Wochentag: $weekday ($amount in diesem Monat).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'Bei diesem Tempo (etwa $average pro Tag) gibst du bis Monatsende rund $amount aus.';

  @override
  String answerMonthTotal(String amount) =>
      'Dieser Monat ist vorbei: Du hast insgesamt $amount ausgegeben.';

  @override
  String answerSaved(String amount, String income) =>
      'Du hast $amount von $income Einnahmen gespart.';

  @override
  String answerOverspent(String amount) =>
      'Du hast $amount mehr ausgegeben als eingenommen.';

  @override
  String get answerNoIncome => 'Keine Einnahmen in diesem Monat.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'Noch $amount im Monatsbudget ($percent verbraucht).';

  @override
  String answerBudgetOver(String amount) =>
      'Du liegst $amount über deinem Monatsbudget.';

  @override
  String get answerNoBudget => 'Du hast noch kein Monatsbudget festgelegt.';

  @override
  String answerOverLimit(String names) => 'Über dem Limit: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'Höchster Monat: $high ($highAmount). Niedrigster: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'Du hast ${expenseCount(count)} erfasst, im Schnitt $average pro Ausgabe.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'Die meisten Einnahmen aus $category: $amount ($percent).';

  @override
  String? currencyName(String code) => switch (code) {
    'EGP' => 'Ägyptisches Pfund',
    'USD' => 'US-Dollar',
    'EUR' => 'Euro',
    'SAR' => 'Saudi-Rial',
    'AED' => 'VAE-Dirham',
    'KWD' => 'Kuwait-Dinar',
    'QAR' => 'Katar-Riyal',
    'BHD' => 'Bahrain-Dinar',
    'OMR' => 'Omanischer Rial',
    'JOD' => 'Jordanischer Dinar',
    'IQD' => 'Irakischer Dinar',
    'LBP' => 'Libanesisches Pfund',
    'SYP' => 'Syrisches Pfund',
    'YER' => 'Jemen-Rial',
    'SDG' => 'Sudanesisches Pfund',
    'LYD' => 'Libyscher Dinar',
    'MAD' => 'Marokkanischer Dirham',
    'TND' => 'Tunesischer Dinar',
    'DZD' => 'Algerischer Dinar',
    'GBP' => 'Britisches Pfund',
    'TRY' => 'Türkische Lira',
    'IRR' => 'Iranischer Rial',
    'PKR' => 'Pakistanische Rupie',
    'INR' => 'Indische Rupie',
    'RUB' => 'Russischer Rubel',
    'UAH' => 'Ukrainische Hrywnja',
    'PLN' => 'Polnischer Złoty',
    'CHF' => 'Schweizer Franken',
    'BRL' => 'Brasilianischer Real',
    'CAD' => 'Kanadischer Dollar',
    'AUD' => 'Australischer Dollar',
    'CNY' => 'Chinesischer Yuan',
    'JPY' => 'Japanischer Yen',
    'KRW' => 'Südkoreanischer Won',
    'IDR' => 'Indonesische Rupiah',
    'MYR' => 'Malaysischer Ringgit',
    'VND' => 'Vietnamesischer Dong',
    'NGN' => 'Nigerianischer Naira',
    _ => null,
  };
}
