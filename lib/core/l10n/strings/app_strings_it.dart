import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsIt extends AppStrings {
  const AppStringsIt();

  @override
  String get localeName => 'it';

  @override
  String get appTitle => 'Il Mio Budget';

  @override
  String get add => 'Aggiungi';

  @override
  String get undo => 'Annulla';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get nothingRecordedYet => 'Ancora nessuna registrazione';

  @override
  String get emptyMonthHint =>
      'Tocca Aggiungi per registrare la prima spesa o entrata di questo mese.';

  @override
  String get yourMonths => 'I tuoi mesi';

  @override
  String spentIn(String month) => 'Speso a $month';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count spesa',
    other: '$count spese',
  );

  @override
  String get quickExpense => 'Spesa rapida';

  @override
  String get expenseSaved => 'Spesa salvata';

  @override
  String get newExpense => 'Nuova spesa';

  @override
  String get editExpense => 'Modifica spesa';

  @override
  String get when => 'Quando';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get pickADate => 'Scegli una data';

  @override
  String get category => 'Categoria';

  @override
  String get noteOptional => 'Nota (facoltativa)';

  @override
  String get noteHint => 'A cosa serviva?';

  @override
  String get addExpense => 'Aggiungi spesa';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Categorie';

  @override
  String get newCategory => 'Nuova categoria';

  @override
  String get editCategory => 'Modifica categoria';

  @override
  String get addCategory => 'Aggiungi categoria';

  @override
  String get categoryName => 'Nome';

  @override
  String get color => 'Colore';

  @override
  String get icon => 'Icona';

  @override
  String get builtIn => 'Predefinita';

  @override
  String get custom => 'Personalizzata';

  @override
  String get edit => 'Modifica';

  @override
  String get delete => 'Elimina';

  @override
  String get cancel => 'Annulla';

  @override
  String deleteCategoryTitle(String name) => 'Eliminare $name?';

  @override
  String get deleteCategoryBody =>
      'Le spese di questa categoria passeranno in Altro. Non viene eliminato '
      'nulla.';

  @override
  String get settings => 'Impostazioni';

  @override
  String get appearance => 'Aspetto';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get language => 'Lingua';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get currency => 'Valuta';

  @override
  String get currencySymbol => 'Simbolo';

  @override
  String get currencySymbolHint => 'Mostrato accanto a ogni importo';

  @override
  String get reminders => 'Promemoria';

  @override
  String get dailyReminder => 'Promemoria giornaliero';

  @override
  String get dailyReminderHint =>
      'Un avviso per registrare quanto hai speso oggi';

  @override
  String get reminderTime => 'Ora';

  @override
  String get notificationsBlocked =>
      'Le notifiche di questa app sono disattivate. Consentile nelle impostazioni del telefono.';

  @override
  String get reminderNotificationTitle => 'Registra le spese di oggi';

  @override
  String get reminderNotificationBody =>
      'Prenditi un momento per aggiungere quanto hai speso oggi.';

  @override
  String get security => 'Sicurezza';

  @override
  String get appLock => 'Blocco app';

  @override
  String get appLockHint =>
      'Chiedi impronta, volto o blocco schermo all’apertura';

  @override
  String get appLockUnavailable =>
      'Imposta prima un blocco schermo su questo telefono';

  @override
  String get unlock => 'Sblocca';

  @override
  String get unlockToContinue => 'Sblocca per vedere il tuo budget';

  @override
  String get confirmItsYou => 'Conferma la tua identità per cambiare il blocco';

  @override
  String get storedOnThisDevice =>
      'Le tue spese sono salvate su questo dispositivo. Accedi per farne un '
      'backup.';

  @override
  String get account => 'Account';

  @override
  String get accountOptional =>
      'L’account è facoltativo. L’app funziona completamente anche senza.';

  @override
  String get signIn => 'Accedi';

  @override
  String get signOut => 'Esci';

  @override
  String get signedIn => 'Accesso effettuato';

  @override
  String get createAccount => 'Crea account';

  @override
  String get noAccountYet => 'Non hai un account? Creane uno';

  @override
  String get haveAnAccount => 'Hai già un account? Accedi';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get passwordRules => 'Almeno 6 caratteri';

  @override
  String get confirmEmail => 'Conferma la tua email';

  @override
  String codeSentTo(String email) =>
      'Abbiamo inviato un codice a $email. Inseriscilo qui sotto per finire '
      'di creare il tuo account.';

  @override
  String get confirmationCode => 'Codice';

  @override
  String get confirm => 'Conferma';

  @override
  String get resendCode => 'Invia un nuovo codice';

  @override
  String get codeResent => 'Un nuovo codice è in arrivo';

  @override
  String get useDifferentEmail => 'Usa un’altra email';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get resetPassword => 'Reimposta password';

  @override
  String resetCodeSentTo(String email) =>
      'Abbiamo inviato un codice a $email. Inseriscilo con una nuova password per il tuo account.';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get saveNewPassword => 'Salva nuova password';

  @override
  String get backToSignIn => 'Torna all’accesso';

  @override
  String get backupHint =>
      'Fai un backup per tenere una copia delle tue spese nel tuo account. '
      'Ripristina riporta quella copia su questo telefono senza togliere '
      'nulla di ciò che c’è già.';

  @override
  String get backUpNow => 'Esegui backup';

  @override
  String get autoBackup => 'Backup automatico';

  @override
  String get autoBackupHint =>
      'Ogni volta che esci dall’app, le nuove modifiche vengono salvate nel tuo account.';

  @override
  String get restoreData => 'Ripristina';

  @override
  String get backingUp => 'Backup in corso…';

  @override
  String get restoring => 'Ripristino in corso…';

  @override
  String get backupDone => 'Backup completato';

  @override
  String get restoreDone => 'Ripristino completato';

  @override
  String get neverSynced => 'Nessun backup ancora';

  @override
  String lastSynced(String when) => 'Ultima sincronizzazione: $when';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountTitle => 'Eliminare il tuo account?';

  @override
  String get deleteAccountBody =>
      'L’account e il backup delle tue spese salvato al suo interno verranno '
      'eliminati per sempre. Non si può annullare. Le spese su questo '
      'telefono restano qui e puoi continuare a usare l’app senza account.';

  @override
  String get deletingAccount => 'Eliminazione dell’account…';

  @override
  String get accountDeleted => 'Il tuo account è stato eliminato';

  @override
  String get home => 'Home';

  @override
  String get analyses => 'Analisi';

  @override
  String get vsLastMonth => 'Rispetto al mese scorso';

  @override
  String get noComparison => 'Nessun dato il mese scorso';

  @override
  String get dailySpending => 'Spesa giornaliera';

  @override
  String get dailyAverage => 'Media al giorno';

  @override
  String get topDay => 'Giorno più alto';

  @override
  String get byCategory => 'Spesa per categoria';

  @override
  String get noSpendingThisMonth => 'Nessuna spesa questo mese.';

  @override
  String get monthlyTrend => 'Ultimi 6 mesi';

  @override
  String lastMonthTotal(String amount) => 'Mese scorso: $amount';

  @override
  String get budgets => 'Budget';

  @override
  String get monthlyBudget => 'Budget mensile';

  @override
  String get setMonthlyBudget => 'Imposta un budget mensile';

  @override
  String get setBudgetHint =>
      'Vedi quanto resta e ricevi un avviso prima di spendere troppo.';

  @override
  String get setBudget => 'Imposta';

  @override
  String get editBudget => 'Modifica budget';

  @override
  String get removeBudget => 'Rimuovi';

  @override
  String get save => 'Salva';

  @override
  String amountLeft(String amount) => 'Restano $amount';

  @override
  String amountOver(String amount) => '$amount oltre il budget';

  @override
  String spentOfLimit(String spent, String limit) => '$spent spesi su $limit';

  @override
  String amountSpent(String amount) => '$amount spesi';

  @override
  String budgetUsed(String percent) => '$percent del budget usato';

  @override
  String get categoryBudgets => 'Budget per categoria';

  @override
  String get categoryBudgetsHint =>
      'Metti un tetto a quanto spendi in una categoria.';

  @override
  String categoryBudgetTitle(String name) => 'Budget $name';

  @override
  String get setLimit => 'Imposta limite';

  @override
  String get closeToLimit => 'Vicine al limite';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'I budget si ripetono ogni mese. Riceverai un avviso quando la spesa '
      'supera il $nearing e di nuovo al $reached.';

  @override
  String get budgetAlertTitle => 'Avviso budget';

  @override
  String get ok => 'OK';

  @override
  String get view => 'Vedi';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Hai usato il $percent del tuo budget mensile';

  @override
  String get monthlyBudgetUsedUp => 'Hai usato tutto il tuo budget mensile';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Hai superato il budget mensile di $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Hai usato il $percent del budget $name';

  @override
  String categoryBudgetUsedUp(String name) => 'Hai usato tutto il budget $name';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Hai superato il budget $name di $amount';

  @override
  String get dataManagement => 'Gestione dati';

  @override
  String get dataManagementHint =>
      'File che conservi tu. Funzionano offline e senza account.';

  @override
  String get backUpToFile => 'Backup dei miei dati';

  @override
  String get backUpToFileHint =>
      'Un file di backup completo da importare in seguito';

  @override
  String get exportCsv => 'Esporta come CSV';

  @override
  String get exportCsvHint => 'Per Excel o Google Sheets';

  @override
  String get exportPdf => 'Esporta come PDF';

  @override
  String get exportPdfHint => 'Un report da leggere, stampare o condividere';

  @override
  String get importData => 'Importa dati';

  @override
  String get importDataHint => 'Ripristina da un file di backup';

  @override
  String get preparingFile => 'Preparazione del file…';

  @override
  String get importingData => 'Importazione…';

  @override
  String get fileSaved => 'File salvato';

  @override
  String get importDone => 'Importazione completata';

  @override
  String get importNothingNew =>
      'Questo telefono aveva già tutto ciò che c’è nel backup';

  @override
  String get fileReady => 'Il tuo file è pronto';

  @override
  String get shareFile => 'Condividi';

  @override
  String get shareFileHint => 'WhatsApp, email, Google Drive e altro';

  @override
  String get saveToPhone => 'Salva su questo telefono';

  @override
  String get saveToPhoneHint => 'Scegli dove tenerlo';

  @override
  String get importTitle => 'Importare questo backup?';

  @override
  String get importMergeHint =>
      'Unisci mantiene tutto ciò che è su questo telefono e aggiunge ciò che '
      'manca. Se un elemento è diverso, vince la modifica più recente.';

  @override
  String get merge => 'Unisci';

  @override
  String get replaceEverything => 'Sostituisci tutto';

  @override
  String get replaceTitle => 'Sostituire tutto su questo telefono?';

  @override
  String get replaceBody =>
      'Tutto ciò che è su questo telefono e non è nel backup verrà eliminato, '
      'e per ogni elemento verrà usata la versione del backup. Non si può '
      'annullare.';

  @override
  String get replace => 'Sostituisci';

  @override
  String get colDate => 'Data';

  @override
  String get colMonth => 'Mese';

  @override
  String get colAmount => 'Importo';

  @override
  String get colNote => 'Nota';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Transazioni';

  @override
  String get colTotal => 'Totale';

  @override
  String get colShare => 'Quota';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get reportTitle => 'Il Mio Budget: report delle spese';

  @override
  String get reportPeriod => 'Periodo';

  @override
  String get reportTotal => 'Totale speso';

  @override
  String get reportMonthlyAverage => 'Media al mese';

  @override
  String get reportByMonth => 'Spesa per mese';

  @override
  String get reportAllExpenses => 'Tutte le spese';

  @override
  String get reportEmpty => 'Ancora nessuna spesa registrata.';

  @override
  String get reportPageTemplate => 'Pagina {page} di {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} e ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} e '
              '${personCount(people)}';
    return date == null
        ? 'Questo backup contiene $contents.'
        : 'Backup del $date: $contents.';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count categoria',
    other: '$count categorie',
  );

  @override
  String reportGenerated(String when) => 'Generato il $when';

  @override
  String get showPassword => 'Mostra password';

  @override
  String get hidePassword => 'Nascondi password';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Cibo',
    'cat_transport' => 'Trasporti',
    'cat_bills' => 'Bollette',
    'cat_shopping' => 'Shopping',
    'cat_health' => 'Salute e fitness',
    'cat_entertainment' => 'Svago',
    'cat_work' => 'Lavoro',
    'cat_other' => 'Altro',
    'cat_salary' => 'Stipendio',
    'cat_freelance' => 'Freelance',
    'cat_investments' => 'Investimenti',
    'cat_gifts' => 'Regali',
    'cat_income_other' => 'Altre entrate',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'Impossibile salvare su questo dispositivo. Riprova.',
    FailureCode.notFound => 'Questo elemento non esiste più.',
    FailureCode.unknown => 'Qualcosa è andato storto.',
    FailureCode.amountRequired => 'Inserisci un importo maggiore di zero.',
    FailureCode.amountTooLarge => 'Questo importo è troppo alto.',
    FailureCode.amountInvalid => 'Inserisci un importo valido.',
    FailureCode.categoryRequired => 'Scegli una categoria.',
    FailureCode.categoryNameRequired => 'Dai un nome alla categoria.',
    FailureCode.categoryNameTooLong =>
      'Il nome deve avere meno di 30 caratteri.',
    FailureCode.categoryProtected =>
      'Questa categoria non può essere eliminata.',
    FailureCode.currencySymbolInvalid => 'Usa da 1 a 4 caratteri.',
    FailureCode.network =>
      'Connessione non riuscita. Controlla internet e riprova.',
    FailureCode.emailInvalid => 'Inserisci un indirizzo email valido.',
    FailureCode.passwordTooShort =>
      'La password deve avere almeno 6 caratteri.',
    FailureCode.invalidCredentials => 'Email o password errate.',
    FailureCode.emailTaken => 'Esiste già un account con questa email.',
    FailureCode.emailNotConfirmed =>
      'Prima conferma la tua email con il codice che ti abbiamo inviato.',
    FailureCode.codeInvalid => 'Il codice è errato o scaduto.',
    FailureCode.signInRequired => 'Accedi di nuovo, poi riprova.',
    FailureCode.syncOtherAccount =>
      'I dati di questo telefono sono collegati a un altro account.',
    FailureCode.syncFailed =>
      'Impossibile sincronizzare con il tuo account. Riprova.',
    FailureCode.accountDeletionFailed =>
      'Impossibile eliminare il tuo account. Riprova.',
    FailureCode.backupNotRecognized =>
      'Questo file non è un backup di Il Mio Budget.',
    FailureCode.backupTooNew =>
      'Questo backup viene da una versione più recente di Il Mio Budget. '
          'Aggiorna l’app e riprova.',
    FailureCode.backupDamaged =>
      'Questo file di backup è danneggiato, quindi non è stato importato '
          'nulla.',
    FailureCode.fileUnavailable =>
      'Impossibile aprire il file. Prova a sceglierlo di nuovo.',
    FailureCode.storageFull =>
      'Non c’è abbastanza spazio libero su questo telefono.',
    FailureCode.exportFailed => 'Impossibile creare il file. Riprova.',
    FailureCode.shareUnavailable =>
      'Impossibile aprire il menu di condivisione.',
    FailureCode.saveFailed => 'Impossibile salvare il file. Riprova.',
    FailureCode.tooManyAttempts =>
      'Troppi tentativi. Aspetta un momento e riprova.',
    FailureCode.titleRequired => 'Dagli un nome.',
    FailureCode.titleTooLong => 'Il nome deve avere meno di 40 caratteri.',
    FailureCode.dueDayInvalid => 'Scegli la scadenza.',
    FailureCode.alreadyPaid => 'Questo pagamento è già registrato.',
    FailureCode.personRequired => 'Scegli una persona.',
    FailureCode.personNameRequired => 'Inserisci un nome.',
    FailureCode.personNameTooLong => 'Il nome deve avere meno di 40 caratteri.',
    FailureCode.phoneInvalid => 'Inserisci un numero di telefono valido.',
    FailureCode.transactionSettled =>
      'Le transazioni saldate non si possono modificare.',
    FailureCode.nothingToSettle => 'Non c’è nulla da saldare.',
    FailureCode.settlementAlreadyLogged => 'Questo saldo è già nel tuo budget.',
  };

  @override
  String get expenseDeleted => 'Spesa eliminata';

  @override
  String get expenseRestored => 'Spesa ripristinata';

  @override
  String categoryAdded(String name) => '$name aggiunto';

  @override
  String get categoryUpdated => 'Categoria aggiornata';

  @override
  String categoryDeleted(String name) => '$name eliminato';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name eliminata: ${expenseCount(count)} spostate in Altro';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name eliminata: ${transactionCount(count)} spostate in Altre entrate';

  @override
  String get expense => 'Spesa';

  @override
  String get income => 'Entrata';

  @override
  String get search => 'Cerca';

  @override
  String get searchHint => 'Cerca note o importi';

  @override
  String get searchPrompt =>
      'Trova un movimento dalla nota o dall’importo, oppure filtra per tipo, categoria e data.';

  @override
  String get noSearchResults => 'Nessun movimento corrisponde';

  @override
  String get allTypes => 'Tutto';

  @override
  String get anyCategory => 'Qualsiasi categoria';

  @override
  String get anyDate => 'Qualsiasi data';

  @override
  String get clearFilters => 'Rimuovi filtri';

  @override
  String get transactionType => 'Spesa o entrata';

  @override
  String get quickIncome => 'Entrata rapida';

  @override
  String get newIncome => 'Nuova entrata';

  @override
  String get editIncome => 'Modifica entrata';

  @override
  String get addIncome => 'Aggiungi entrata';

  @override
  String get incomeNoteHint => 'Da dove arriva?';

  @override
  String get totalIncome => 'Entrate totali';

  @override
  String get totalExpenses => 'Spese totali';

  @override
  String get netBalance => 'Saldo netto';

  @override
  String get savingsRate => 'Tasso di risparmio';

  @override
  String get savingsRateNoIncome =>
      'Aggiungi un’entrata per vedere il tasso di risparmio';

  @override
  String get expenseCategories => 'Categorie di spesa';

  @override
  String get incomeCategories => 'Categorie di entrata';

  @override
  String get deleteIncomeCategoryBody =>
      'Le entrate di questa categoria passeranno in Altre entrate. Non viene '
      'eliminato nulla.';

  @override
  String get incomeDeleted => 'Entrata eliminata';

  @override
  String get incomeRestored => 'Entrata ripristinata';

  @override
  String get colType => 'Tipo';

  @override
  String transactionCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count transazione',
    other: '$count transazioni',
  );

  @override
  String get recurringPayments => 'Pagamenti ricorrenti';

  @override
  String get newRecurring => 'Nuovo pagamento ricorrente';

  @override
  String get editRecurring => 'Modifica pagamento ricorrente';

  @override
  String get addRecurring => 'Aggiungi pagamento';

  @override
  String get recurringTitle => 'Nome';

  @override
  String get recurringTitleHint => 'Affitto, Netflix, palestra…';

  @override
  String get amount => 'Importo';

  @override
  String get repeats => 'Ripetizione';

  @override
  String get weekly => 'Settimanale';

  @override
  String get monthly => 'Mensile';

  @override
  String get yearly => 'Annuale';

  @override
  String get dueOn => 'Scade il';

  @override
  String get dueDayOfMonth => 'Giorno del mese';

  @override
  String get dueMonthLabel => 'Mese';

  @override
  String get dueDayLabel => 'Giorno';

  @override
  String get shortMonthHint => 'Nei mesi più corti, cade l’ultimo giorno.';

  @override
  String get whenDue => 'Alla scadenza';

  @override
  String get autoDeduct => 'Addebito automatico';

  @override
  String get remindMe => 'Ricordamelo';

  @override
  String get autoDeductHint =>
      'Registrato automaticamente come spesa alla scadenza.';

  @override
  String get remindMeHint =>
      'Ti verrà chiesto di confermare ogni pagamento prima di registrarlo.';

  @override
  String get statusPaid => 'Pagato';

  @override
  String get statusUpcoming => 'In arrivo';

  @override
  String get statusOverdue => 'Scaduto';

  @override
  String get markAsPaid => 'Pagato';

  @override
  String get dueToday => 'Scade oggi';

  @override
  String dueOnDate(String date) => 'Scade il $date';

  @override
  String nextDueOn(String date) => 'Prossimo il $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Scaduto il $date'
      : '${paymentCount(count)} scaduti dal $date';

  @override
  String everyWeekday(String weekday) => 'Ogni $weekday';

  @override
  String monthlyOnDay(String day) => 'Ogni mese il giorno $day';

  @override
  String yearlyOn(String date) => 'Ogni anno il $date';

  @override
  String get monthlyAverage => 'Al mese';

  @override
  String get monthlyAverageHint => 'Tutti i pagamenti ricorrenti, in media';

  @override
  String get noRecurringYet => 'Ancora nessun pagamento ricorrente';

  @override
  String get noRecurringHint =>
      'Aggiungi affitto, bollette e abbonamenti una volta sola. Ogni mese '
      'vedrai cosa è pagato e cosa manca.';

  @override
  String get paymentsToConfirm => 'Pagamenti da confermare';

  @override
  String get seeAll => 'Vedi tutti';

  @override
  String get deleteRecurringBody =>
      'Smette di ripetersi. I pagamenti già registrati restano tra le tue '
      'transazioni.';

  @override
  String recurringPaid(String name) => '$name segnato come pagato';

  @override
  String recurringReceived(String name) => '$name segnato come ricevuto';

  @override
  String get statusReceived => 'Ricevuto';

  @override
  String get markAsReceived => 'Ricevuto';

  @override
  String get autoAdd => 'Accredito automatico';

  @override
  String get autoAddHint =>
      'Registrato automaticamente come entrata alla scadenza.';

  @override
  String get monthlyIncomeAverage => 'Entrate al mese';

  @override
  String get recurringPaymentUndone => 'Pagamento rimosso';

  @override
  String recurringAutoLogged(int count) => plural(
    count,
    locale: localeName,
    one: '$count pagamento ricorrente registrato automaticamente',
    other: '$count pagamenti ricorrenti registrati automaticamente',
  );

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count pagamento',
    other: '$count pagamenti',
  );

  @override
  String get colPaidThrough => 'Pagato fino al';

  // People & debts

  @override
  String get people => 'Persone';

  @override
  String get peopleAndDebts => 'Persone e debiti';

  @override
  String get person => 'Persona';

  @override
  String get personName => 'Nome';

  @override
  String get phone => 'Telefono';

  @override
  String get phoneOptional => 'Telefono (facoltativo)';

  @override
  String get balance => 'Saldo';

  @override
  String get colStatus => 'Stato';

  @override
  String get owesYou => 'Ti deve';

  @override
  String get youOwe => 'Devi';

  @override
  String get owedToYou => 'Ti devono';

  @override
  String get settledUp => 'Saldato';

  @override
  String get iPaidForThem => 'Ho pagato io';

  @override
  String get theyPaidForMe => 'Ha pagato per me';

  @override
  String get theyPaidYou => 'Ti ha pagato';

  @override
  String get youPaidThem => 'Hai pagato';

  @override
  String get openStatus => 'Aperto';

  @override
  String get settledStatus => 'Saldato';

  @override
  String get settledOn => 'Saldato il';

  @override
  String get createdOn => 'Creato';

  @override
  String get lastEdited => 'Ultima modifica';

  @override
  String get colEdits => 'Modifiche';

  @override
  String get activeTransactions => 'Transazioni aperte';

  @override
  String get settledHistory => 'Storico dei saldi';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterOwedToMe => 'Mi devono';

  @override
  String get filterIOwe => 'Devo io';

  @override
  String get filterSettled => 'Saldati';

  @override
  String get addPerson => 'Aggiungi persona';

  @override
  String get addPersonHint => 'Qualcuno con cui dividi le spese';

  @override
  String get newPerson => 'Nuova persona';

  @override
  String get editPerson => 'Modifica persona';

  @override
  String get deletePerson => 'Elimina persona';

  @override
  String get quickTransaction => 'Transazione rapida';

  @override
  String get quickTransactionHint =>
      'Segna chi ha pagato, con una persona già aggiunta';

  @override
  String get noPeopleYet => 'Ancora nessuna persona';

  @override
  String get noPeopleHint =>
      'Aggiungi le persone con cui dividi le spese per sapere chi deve cosa a '
      'chi.';

  @override
  String get nobodyHere => 'Nessuno corrisponde a questo filtro.';

  @override
  String get addPersonFirst => 'Prima aggiungi una persona.';

  @override
  String get newTransaction => 'Nuova transazione';

  @override
  String get editTransaction => 'Modifica transazione';

  @override
  String get transactionDetails => 'Dettagli della transazione';

  @override
  String get debtNoteHint => 'A cosa serviva?';

  @override
  String get changeHistory => 'Cronologia modifiche';

  @override
  String get edited => 'Modificato';

  @override
  String get settleUp => 'Salda';

  @override
  String get settle => 'Salda';

  @override
  String get noDebtsYet => 'Ancora nessuna registrazione';

  @override
  String get noDebtsHint =>
      'Aggiungi ciò che hai pagato per questa persona o ciò che ha pagato per '
      'te.';

  @override
  String get settleEven =>
      'Queste transazioni si compensano, quindi non serve scambiarsi soldi.';

  @override
  String get logSettlementTitle =>
      'Registrare questo saldo nel tuo budget mensile?';

  @override
  String get loggedInBudget => 'Nel tuo budget';

  @override
  String get deleteTransactionTitle => 'Eliminare questa transazione?';

  @override
  String get deleteTransactionBody =>
      'Verrà tolta dal saldo con questa persona.';

  @override
  String get deletePersonBody =>
      'Vengono eliminate anche le sue transazioni e lo storico dei saldi. '
      'Ciò che hai registrato nel budget resta.';

  @override
  String get settledLocked => 'Saldata, quindi non si può più modificare.';

  @override
  String get personUpdated => 'Persona aggiornata';

  @override
  String get debtDeleted => 'Transazione eliminata';

  @override
  String get settledUpNotice => 'Tutto saldato';

  @override
  String get settlementLogged => 'Aggiunto al tuo budget';

  @override
  String personOwesYou(String name) => '$name ti deve';

  @override
  String youOwePerson(String name) => 'Devi a $name';

  @override
  String settledWith(String name) => 'Tutto saldato con $name';

  @override
  String settleUpFor(String amount) => 'Salda $amount';

  @override
  String settleTitle(String name) => 'Saldare con $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name ti paga $amount per chiudere tutto.';

  @override
  String settleYouPay(String name, String amount) =>
      'Paghi $amount a $name per chiudere tutto.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} passeranno nello storico dei saldi.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount verrà aggiunto come entrata in Altre entrate. Potrai spostarlo '
      'in un’altra categoria in seguito.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount verrà aggiunto come spesa in Altro. Potrai spostarlo in '
      'un’altra categoria in seguito.';

  @override
  String settlementNote(String name) => 'Saldo con $name';

  @override
  String settledGroupTitle(String date) => 'Saldato il $date';

  @override
  String deletePersonTitle(String name) => 'Eliminare $name?';

  @override
  String editedOn(String date) => 'Modificato il $date';

  @override
  String wasValues(String values) => 'Prima: $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count persona',
    other: '$count persone',
  );

  @override
  String get askTitle => 'Chiedi delle tue spese';

  @override
  String get askHint => 'Tocca una domanda per vedere la risposta.';

  @override
  String get askCompareMonths => 'Confronta mesi';

  @override
  String get askTopCategory => 'Categoria principale';

  @override
  String get askVsLastMonth => 'vs mese scorso';

  @override
  String get askBiggestExpense => 'Spesa più alta';

  @override
  String get askTopDay => 'Giorno più caro';

  @override
  String get askWeekday => 'Giorno con più spese';

  @override
  String get askMonthEnd => 'Stima di fine mese';

  @override
  String get askSaved => 'Ho risparmiato?';

  @override
  String get askBudgetLeft => 'Budget rimasto';

  @override
  String get askHighestLowest => 'Mese più alto e più basso';

  @override
  String get askCount => 'Quante spese';

  @override
  String get askTopIncome => 'Entrata principale';

  @override
  String get compareWith => 'Confronta con';

  @override
  String get otherCategories => 'Altre';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'Hai speso di più per $category: $amount ($percent del mese).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Hai speso $amount in più a $month rispetto a $other (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Hai speso $amount in meno a $month rispetto a $other (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'Hai speso lo stesso a $month e a $other.';

  @override
  String answerNothingIn(String month) => 'Nessuna spesa a $month.';

  @override
  String answerRise(String category, String amount) =>
      'Aumento maggiore: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Calo maggiore: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Spesa più alta: $amount in $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Giorno più caro: $date, con $amount spesi.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Giorno della settimana con più spese: $weekday ($amount questo mese).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'A questo ritmo (circa $average al giorno) spenderai circa $amount entro fine mese.';

  @override
  String answerMonthTotal(String amount) =>
      'Questo mese è finito: hai speso $amount in totale.';

  @override
  String answerSaved(String amount, String income) =>
      'Hai risparmiato $amount su $income di entrate.';

  @override
  String answerOverspent(String amount) =>
      'Hai speso $amount più di quanto hai guadagnato.';

  @override
  String get answerNoIncome => 'Nessuna entrata registrata questo mese.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'Restano $amount del budget mensile ($percent usato).';

  @override
  String answerBudgetOver(String amount) =>
      'Hai superato il budget mensile di $amount.';

  @override
  String get answerNoBudget => 'Non hai ancora impostato un budget mensile.';

  @override
  String answerOverLimit(String names) => 'Oltre il limite: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'Mese più alto: $high ($highAmount). Più basso: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'Hai registrato ${expenseCount(count)}, in media $average ciascuna.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'La maggior parte delle entrate da $category: $amount ($percent).';
}
