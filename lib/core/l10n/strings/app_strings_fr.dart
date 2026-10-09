import '../../error/failures.dart';
import '../app_strings.dart';
import '../plural.dart';

class AppStringsFr extends AppStrings {
  const AppStringsFr();

  @override
  String get localeName => 'fr';

  @override
  String get appTitle => 'Mon Budget';

  @override
  String get add => 'Ajouter';

  @override
  String get undo => 'Annuler';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get nothingRecordedYet => 'Rien d’enregistré pour l’instant';

  @override
  String get emptyPeriodHint =>
      'Touchez Ajouter pour enregistrer une dépense ou un revenu sur cette période.';

  @override
  String get periodDay => 'Jour';

  @override
  String get periodWeek => 'Semaine';

  @override
  String get periodMonth => 'Mois';

  @override
  String get periodYear => 'Année';

  @override
  String get previousPeriod => 'Précédent';

  @override
  String get nextPeriod => 'Suivant';

  @override
  String get yourMonths => 'Vos mois';

  @override
  String spentIn(String month) => 'Dépensé en $month';

  @override
  String expenseCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count dépense',
    other: '$count dépenses',
  );

  @override
  String get quickExpense => 'Dépense rapide';

  @override
  String get expenseSaved => 'Dépense enregistrée';

  @override
  String get newExpense => 'Nouvelle dépense';

  @override
  String get editExpense => 'Modifier la dépense';

  @override
  String get when => 'Quand';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get pickADate => 'Choisir une date';

  @override
  String get category => 'Catégorie';

  @override
  String get noteOptional => 'Note (facultatif)';

  @override
  String get noteHint => 'C’était pour quoi ?';

  @override
  String get addExpense => 'Ajouter la dépense';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Catégories';

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get categoryName => 'Nom';

  @override
  String get color => 'Couleur';

  @override
  String get icon => 'Icône';

  @override
  String get builtIn => 'Intégrée';

  @override
  String get custom => 'Personnalisée';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get cancel => 'Annuler';

  @override
  String deleteCategoryTitle(String name) => 'Supprimer « $name » ?';

  @override
  String get deleteCategoryBody =>
      'Les dépenses de cette catégorie seront déplacées vers Autre. Rien '
      'n’est supprimé.';

  @override
  String get settings => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Système';

  @override
  String get currency => 'Devise';

  @override
  String get currencySymbol => 'Symbole';

  @override
  String get currencySymbolHint => 'Affiché à côté de chaque montant';

  @override
  String get currencyOther => 'Autre';

  @override
  String get reminders => 'Rappels';

  @override
  String get dailyReminder => 'Rappel quotidien';

  @override
  String get dailyReminderHint =>
      'Un petit rappel pour noter vos dépenses du jour';

  @override
  String get reminderTime => 'Heure';

  @override
  String get notificationsBlocked =>
      'Les notifications de cette appli sont désactivées. Autorisez-les dans les réglages du téléphone.';

  @override
  String get reminderNotificationTitle => 'Notez vos dépenses du jour';

  @override
  String get reminderNotificationBody =>
      'Prenez un instant pour ajouter ce que vous avez dépensé aujourd’hui.';

  @override
  String get security => 'Sécurité';

  @override
  String get appLock => 'Verrouillage de l’appli';

  @override
  String get appLockHint =>
      'Demander l’empreinte, le visage ou le verrouillage de l’écran à l’ouverture';

  @override
  String get appLockUnavailable =>
      'Configurez d’abord un verrouillage de l’écran sur ce téléphone';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get unlockToContinue => 'Déverrouillez pour voir votre budget';

  @override
  String get confirmItsYou =>
      'Confirmez votre identité pour modifier le verrouillage';

  @override
  String get storedOnThisDevice =>
      'Vos dépenses sont stockées sur cet appareil. Connectez-vous pour les '
      'sauvegarder.';

  @override
  String get account => 'Compte';

  @override
  String get accountOptional =>
      'Un compte est facultatif. L’application fonctionne entièrement sans.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signedIn => 'Connecté';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get noAccountYet => 'Pas encore de compte ? Créez-en un';

  @override
  String get haveAnAccount => 'Déjà un compte ? Connectez-vous';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordRules => 'Au moins 6 caractères';

  @override
  String get confirmEmail => 'Confirmez votre e-mail';

  @override
  String codeSentTo(String email) =>
      'Nous avons envoyé un code à $email. Saisissez-le ci-dessous pour '
      'terminer la création de votre compte.';

  @override
  String get confirmationCode => 'Code';

  @override
  String get confirm => 'Confirmer';

  @override
  String get resendCode => 'Envoyer un nouveau code';

  @override
  String get codeResent => 'Un nouveau code est en route';

  @override
  String get useDifferentEmail => 'Utiliser une autre adresse e-mail';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String resetCodeSentTo(String email) =>
      'Nous avons envoyé un code à $email. Saisissez-le avec un nouveau mot de passe pour votre compte.';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get saveNewPassword => 'Enregistrer le mot de passe';

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String get backupHint =>
      'Sauvegardez pour garder une copie de vos dépenses dans votre compte. '
      'Restaurer ramène cette copie sur ce téléphone sans rien supprimer de '
      'ce qui s’y trouve déjà.';

  @override
  String get backUpNow => 'Sauvegarder';

  @override
  String get autoBackup => 'Sauvegarde automatique';

  @override
  String get autoBackupHint =>
      'Chaque fois que vous quittez l’appli, les nouveaux changements sont sauvegardés dans votre compte.';

  @override
  String get restoreData => 'Restaurer';

  @override
  String get backingUp => 'Sauvegarde…';

  @override
  String get restoring => 'Restauration…';

  @override
  String get backupDone => 'Sauvegarde terminée';

  @override
  String get restoreDone => 'Restauration terminée';

  @override
  String get neverSynced => 'Pas encore sauvegardé';

  @override
  String lastSynced(String when) => 'Dernière synchronisation : $when';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountTitle => 'Supprimer votre compte ?';

  @override
  String get deleteAccountBody =>
      'Cela supprime définitivement votre compte et la sauvegarde de vos '
      'dépenses qui y est associée. C’est irréversible. Les dépenses de ce '
      'téléphone restent ici, et vous pouvez continuer à utiliser '
      'l’application sans compte.';

  @override
  String get deletingAccount => 'Suppression de votre compte…';

  @override
  String get accountDeleted => 'Votre compte a été supprimé';

  @override
  String get home => 'Accueil';

  @override
  String get analyses => 'Analyses';

  @override
  String get vsLastMonth => 'Par rapport au mois dernier';

  @override
  String get noComparison => 'Aucune donnée le mois dernier';

  @override
  String get dailySpending => 'Dépenses quotidiennes';

  @override
  String get dailyAverage => 'Moyenne par jour';

  @override
  String get topDay => 'Jour le plus élevé';

  @override
  String get byCategory => 'Dépenses par catégorie';

  @override
  String get noSpendingThisMonth => 'Aucune dépense ce mois-ci.';

  @override
  String get monthlyTrend => '6 derniers mois';

  @override
  String lastMonthTotal(String amount) => 'Mois dernier : $amount';

  @override
  String get budgets => 'Budgets';

  @override
  String get monthlyBudget => 'Budget mensuel';

  @override
  String get setMonthlyBudget => 'Définir un budget mensuel';

  @override
  String get setBudgetHint =>
      'Voyez ce qu’il reste et soyez prévenu avant de trop dépenser.';

  @override
  String get setBudget => 'Définir';

  @override
  String get editBudget => 'Modifier le budget';

  @override
  String get removeBudget => 'Retirer';

  @override
  String get save => 'Enregistrer';

  @override
  String amountLeft(String amount) => 'Reste $amount';

  @override
  String amountOver(String amount) => '$amount au-delà du budget';

  @override
  String spentOfLimit(String spent, String limit) =>
      '$spent dépensés sur $limit';

  @override
  String amountSpent(String amount) => '$amount dépensés';

  @override
  String budgetUsed(String percent) => '$percent du budget utilisé';

  @override
  String get categoryBudgets => 'Budgets par catégorie';

  @override
  String get categoryBudgetsHint =>
      'Plafonnez ce que vous dépensez dans une catégorie.';

  @override
  String categoryBudgetTitle(String name) => 'Budget « $name »';

  @override
  String get setLimit => 'Fixer une limite';

  @override
  String get closeToLimit => 'Proches de leur limite';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Les budgets se renouvellent chaque mois. Vous serez prévenu quand les '
      'dépenses dépassent $nearing, puis à $reached.';

  @override
  String get budgetAlertTitle => 'Alerte budget';

  @override
  String get ok => 'OK';

  @override
  String get view => 'Voir';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Vous avez utilisé $percent de votre budget mensuel';

  @override
  String get monthlyBudgetUsedUp =>
      'Vous avez utilisé tout votre budget mensuel';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Vous dépassez votre budget mensuel de $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Vous avez utilisé $percent de votre budget « $name »';

  @override
  String categoryBudgetUsedUp(String name) =>
      'Vous avez utilisé tout votre budget « $name »';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Vous dépassez votre budget « $name » de $amount';

  @override
  String get dataManagement => 'Gestion des données';

  @override
  String get dataManagementHint =>
      'Des fichiers que vous gardez vous-même. Ils fonctionnent hors ligne '
      'et sans compte.';

  @override
  String get backUpToFile => 'Sauvegarder mes données';

  @override
  String get backUpToFileHint =>
      'Un fichier de sauvegarde complet à importer plus tard';

  @override
  String get exportCsv => 'Exporter en CSV';

  @override
  String get exportCsvHint => 'Pour Excel ou Google Sheets';

  @override
  String get exportPdf => 'Exporter en PDF';

  @override
  String get exportPdfHint => 'Un rapport à lire, imprimer ou partager';

  @override
  String get importData => 'Importer des données';

  @override
  String get importDataHint => 'Restaurer depuis un fichier de sauvegarde';

  @override
  String get preparingFile => 'Préparation de votre fichier…';

  @override
  String get importingData => 'Importation…';

  @override
  String get fileSaved => 'Fichier enregistré';

  @override
  String get importDone => 'Importation terminée';

  @override
  String get importNothingNew =>
      'Ce téléphone contenait déjà tout ce qui est dans la sauvegarde';

  @override
  String get fileReady => 'Votre fichier est prêt';

  @override
  String get shareFile => 'Partager';

  @override
  String get shareFileHint => 'WhatsApp, e-mail, Google Drive et plus';

  @override
  String get saveToPhone => 'Enregistrer sur ce téléphone';

  @override
  String get saveToPhoneHint => 'Choisissez où le garder';

  @override
  String get importTitle => 'Importer cette sauvegarde ?';

  @override
  String get importMergeHint =>
      'Fusionner garde tout ce qui est sur ce téléphone et ajoute ce qui '
      'manque. Quand un élément diffère, la modification la plus récente '
      'l’emporte.';

  @override
  String get merge => 'Fusionner';

  @override
  String get replaceEverything => 'Tout remplacer';

  @override
  String get replaceTitle => 'Tout remplacer sur ce téléphone ?';

  @override
  String get replaceBody =>
      'Tout ce qui est sur ce téléphone et absent de la sauvegarde sera '
      'supprimé, et la version de la sauvegarde sera utilisée pour chaque '
      'élément. C’est irréversible.';

  @override
  String get replace => 'Remplacer';

  @override
  String get colDate => 'Date';

  @override
  String get colMonth => 'Mois';

  @override
  String get colAmount => 'Montant';

  @override
  String get colNote => 'Note';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Transactions';

  @override
  String get colTotal => 'Total';

  @override
  String get colShare => 'Part';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get reportTitle => 'Mon Budget : rapport des dépenses';

  @override
  String get reportPeriod => 'Période';

  @override
  String get reportTotal => 'Total dépensé';

  @override
  String get reportMonthlyAverage => 'Moyenne par mois';

  @override
  String get reportByMonth => 'Dépenses par mois';

  @override
  String get reportAllExpenses => 'Toutes les dépenses';

  @override
  String get reportEmpty => 'Aucune dépense enregistrée pour l’instant.';

  @override
  String get reportPageTemplate => 'Page {page} sur {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} et ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} et '
              '${personCount(people)}';
    return date == null
        ? 'Cette sauvegarde contient $contents.'
        : 'Sauvegarde du $date : $contents.';
  }

  @override
  String categoryCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count catégorie',
    other: '$count catégories',
  );

  @override
  String reportGenerated(String when) => 'Généré le $when';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Alimentation',
    'cat_transport' => 'Transport',
    'cat_bills' => 'Factures',
    'cat_shopping' => 'Shopping',
    'cat_health' => 'Santé et sport',
    'cat_entertainment' => 'Loisirs',
    'cat_work' => 'Travail',
    'cat_other' => 'Autre',
    'cat_salary' => 'Salaire',
    'cat_freelance' => 'Freelance',
    'cat_investments' => 'Investissements',
    'cat_gifts' => 'Cadeaux',
    'cat_income_other' => 'Autres revenus',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'Impossible d’enregistrer sur cet appareil. Réessayez.',
    FailureCode.notFound => 'Cet élément n’existe plus.',
    FailureCode.unknown => 'Une erreur s’est produite.',
    FailureCode.amountRequired => 'Saisissez un montant supérieur à zéro.',
    FailureCode.amountTooLarge => 'Ce montant est trop élevé.',
    FailureCode.amountInvalid => 'Saisissez un montant valide.',
    FailureCode.categoryRequired => 'Choisissez une catégorie.',
    FailureCode.categoryNameRequired => 'Donnez un nom à la catégorie.',
    FailureCode.categoryNameTaken =>
      'Vous avez déjà une catégorie portant ce nom.',
    FailureCode.categoryNameTooLong =>
      'Le nom doit faire moins de 30 caractères.',
    FailureCode.categoryProtected =>
      'Cette catégorie ne peut pas être supprimée.',
    FailureCode.currencySymbolInvalid => 'Utilisez de 1 à 4 caractères.',
    FailureCode.network =>
      'Connexion impossible. Vérifiez votre connexion Internet et réessayez.',
    FailureCode.emailInvalid => 'Saisissez une adresse e-mail valide.',
    FailureCode.passwordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères.',
    FailureCode.invalidCredentials => 'E-mail ou mot de passe incorrect.',
    FailureCode.emailTaken => 'Un compte existe déjà avec cet e-mail.',
    FailureCode.emailNotConfirmed =>
      'Confirmez d’abord votre e-mail avec le code que nous vous avons envoyé.',
    FailureCode.codeInvalid => 'Ce code est incorrect ou a expiré.',
    FailureCode.signInRequired => 'Reconnectez-vous, puis réessayez.',
    FailureCode.syncOtherAccount =>
      'Les données de ce téléphone sont liées à un autre compte.',
    FailureCode.syncFailed =>
      'Impossible de synchroniser avec votre compte. Réessayez.',
    FailureCode.accountDeletionFailed =>
      'Impossible de supprimer votre compte. Réessayez.',
    FailureCode.backupNotRecognized =>
      'Ce fichier n’est pas une sauvegarde de Mon Budget.',
    FailureCode.pastedNotRecognized =>
      'Le texte collé n’est pas lisible par l’app. Copiez toute la réponse de l’IA et réessayez, ou demandez-lui de la corriger.',
    FailureCode.backupTooNew =>
      'Cette sauvegarde vient d’une version plus récente de Mon Budget. '
          'Mettez l’application à jour, puis réessayez.',
    FailureCode.backupDamaged =>
      'Ce fichier de sauvegarde est endommagé, rien n’a donc été importé.',
    FailureCode.fileUnavailable =>
      'Impossible d’ouvrir ce fichier. Essayez de le choisir à nouveau.',
    FailureCode.storageFull =>
      'Il n’y a pas assez d’espace libre sur ce téléphone.',
    FailureCode.exportFailed => 'Impossible de créer le fichier. Réessayez.',
    FailureCode.shareUnavailable => 'Impossible d’ouvrir le menu de partage.',
    FailureCode.saveFailed => 'Impossible d’enregistrer le fichier. Réessayez.',
    FailureCode.tooManyAttempts =>
      'Trop de tentatives. Patientez un instant et réessayez.',
    FailureCode.titleRequired => 'Donnez-lui un nom.',
    FailureCode.titleTooLong => 'Le nom doit faire moins de 40 caractères.',
    FailureCode.dueDayInvalid => 'Choisissez l’échéance.',
    FailureCode.alreadyPaid => 'Ce paiement est déjà enregistré.',
    FailureCode.personRequired => 'Choisissez une personne.',
    FailureCode.personNameRequired => 'Saisissez un nom.',
    FailureCode.personNameTooLong =>
      'Le nom doit faire moins de 40 caractères.',
    FailureCode.phoneInvalid => 'Saisissez un numéro de téléphone valide.',
    FailureCode.transactionSettled =>
      'Les transactions réglées ne peuvent pas être modifiées.',
    FailureCode.nothingToSettle => 'Il n’y a rien à régler.',
    FailureCode.settlementAlreadyLogged =>
      'Ce règlement est déjà dans votre budget.',
  };

  @override
  String get expenseDeleted => 'Dépense supprimée';

  @override
  String get expenseRestored => 'Dépense restaurée';

  @override
  String categoryAdded(String name) => '« $name » ajouté';

  @override
  String get categoryUpdated => 'Catégorie mise à jour';

  @override
  String categoryDeleted(String name) => '« $name » supprimé';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '« $name » supprimée — ${expenseCount(count)} déplacée(s) vers Autre';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '« $name » supprimée — ${transactionCount(count)} déplacée(s) vers '
      'Autres revenus';

  @override
  String get expense => 'Dépense';

  @override
  String get income => 'Revenu';

  @override
  String get search => 'Rechercher';

  @override
  String get searchHint => 'Chercher une note ou un montant';

  @override
  String get searchPrompt =>
      'Retrouvez une opération par sa note ou son montant, ou filtrez par type, catégorie et date.';

  @override
  String get noSearchResults => 'Aucune opération ne correspond';

  @override
  String get allTypes => 'Tout';

  @override
  String get anyCategory => 'Toutes catégories';

  @override
  String get anyDate => 'Toutes dates';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get transactionType => 'Dépense ou revenu';

  @override
  String get quickIncome => 'Revenu rapide';

  @override
  String get newIncome => 'Nouveau revenu';

  @override
  String get editIncome => 'Modifier le revenu';

  @override
  String get addIncome => 'Ajouter le revenu';

  @override
  String get incomeNoteHint => 'D’où vient-il ?';

  @override
  String get totalIncome => 'Total des revenus';

  @override
  String get totalExpenses => 'Total des dépenses';

  @override
  String get netBalance => 'Solde net';

  @override
  String get savingsRate => 'Taux d’épargne';

  @override
  String get savingsRateNoIncome =>
      'Ajoutez un revenu pour voir votre taux d’épargne';

  @override
  String get expenseCategories => 'Catégories de dépenses';

  @override
  String get incomeCategories => 'Catégories de revenus';

  @override
  String get deleteIncomeCategoryBody =>
      'Les revenus de cette catégorie seront déplacés vers Autres revenus. '
      'Rien n’est supprimé.';

  @override
  String get incomeDeleted => 'Revenu supprimé';

  @override
  String get incomeRestored => 'Revenu restauré';

  @override
  String get colType => 'Type';

  @override
  String transactionCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count transaction',
    other: '$count transactions',
  );

  @override
  String get recurringPayments => 'Paiements récurrents';

  @override
  String get newRecurring => 'Nouveau paiement récurrent';

  @override
  String get editRecurring => 'Modifier le paiement récurrent';

  @override
  String get addRecurring => 'Ajouter le paiement';

  @override
  String get recurringTitle => 'Nom';

  @override
  String get recurringTitleHint => 'Loyer, Netflix, salle de sport…';

  @override
  String get amount => 'Montant';

  @override
  String get repeats => 'Fréquence';

  @override
  String get weekly => 'Hebdo';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get dueOn => 'Échéance';

  @override
  String get dueDayOfMonth => 'Jour du mois';

  @override
  String get dueMonthLabel => 'Mois';

  @override
  String get dueDayLabel => 'Jour';

  @override
  String get shortMonthHint =>
      'Les mois plus courts, il tombe le dernier jour.';

  @override
  String get whenDue => 'À l’échéance';

  @override
  String get autoDeduct => 'Prélèvement auto';

  @override
  String get remindMe => 'Me rappeler';

  @override
  String get autoDeductHint =>
      'Enregistré automatiquement comme dépense à l’échéance.';

  @override
  String get remindMeHint =>
      'Vous devrez confirmer chaque paiement avant qu’il soit enregistré.';

  @override
  String get statusPaid => 'Payé';

  @override
  String get statusUpcoming => 'À venir';

  @override
  String get statusOverdue => 'En retard';

  @override
  String get markAsPaid => 'Marquer payé';

  @override
  String get dueToday => 'Échéance aujourd’hui';

  @override
  String dueOnDate(String date) => 'Échéance le $date';

  @override
  String nextDueOn(String date) => 'Prochain le $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Échéance le $date'
      : '${paymentCount(count)} en retard depuis le $date';

  @override
  String everyWeekday(String weekday) => 'Chaque $weekday';

  @override
  String monthlyOnDay(String day) => 'Chaque mois le $day';

  @override
  String yearlyOn(String date) => 'Chaque année le $date';

  @override
  String get monthlyAverage => 'Par mois';

  @override
  String get monthlyAverageHint => 'Tous vos paiements récurrents, en moyenne';

  @override
  String get noRecurringYet => 'Aucun paiement récurrent';

  @override
  String get noRecurringHint =>
      'Ajoutez loyer, factures et abonnements une seule fois. Chaque mois, '
      'vous verrez ce qui est payé et ce qui reste dû.';

  @override
  String get paymentsToConfirm => 'Paiements à confirmer';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get deleteRecurringBody =>
      'Il ne se répétera plus. Les paiements déjà enregistrés restent dans '
      'vos transactions.';

  @override
  String recurringPaid(String name) => '« $name » marqué comme payé';

  @override
  String recurringReceived(String name) => '« $name » marqué comme reçu';

  @override
  String get statusReceived => 'Reçu';

  @override
  String get markAsReceived => 'Marquer reçu';

  @override
  String get autoAdd => 'Ajout auto';

  @override
  String get autoAddHint =>
      'Enregistré automatiquement comme revenu à l’échéance.';

  @override
  String get monthlyIncomeAverage => 'Revenus par mois';

  @override
  String get recurringPaymentUndone => 'Paiement retiré';

  @override
  String recurringAutoLogged(int count) => plural(
    count,
    locale: localeName,
    one: '$count paiement récurrent enregistré automatiquement',
    other: '$count paiements récurrents enregistrés automatiquement',
  );

  @override
  String paymentCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count paiement',
    other: '$count paiements',
  );

  @override
  String get colPaidThrough => 'Payé jusqu’au';

  // People & debts

  @override
  String get people => 'Personnes';

  @override
  String get peopleAndDebts => 'Personnes et dettes';

  @override
  String get person => 'Personne';

  @override
  String get personName => 'Nom';

  @override
  String get phone => 'Téléphone';

  @override
  String get phoneOptional => 'Téléphone (facultatif)';

  @override
  String get balance => 'Solde';

  @override
  String get colStatus => 'Statut';

  @override
  String get owesYou => 'Vous doit';

  @override
  String get youOwe => 'Vous devez';

  @override
  String get owedToYou => 'On vous doit';

  @override
  String get settledUp => 'Réglé';

  @override
  String get iPaidForThem => 'J’ai payé pour lui/elle';

  @override
  String get theyPaidForMe => 'Il/elle a payé pour moi';

  @override
  String get theyPaidYou => 'Vous a payé';

  @override
  String get youPaidThem => 'Vous avez payé';

  @override
  String get openStatus => 'En cours';

  @override
  String get settledStatus => 'Réglé';

  @override
  String get settledOn => 'Réglé le';

  @override
  String get createdOn => 'Créé';

  @override
  String get lastEdited => 'Dernière modification';

  @override
  String get colEdits => 'Modifications';

  @override
  String get activeTransactions => 'Transactions en cours';

  @override
  String get settledHistory => 'Historique des règlements';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterOwedToMe => 'On me doit';

  @override
  String get filterIOwe => 'Je dois';

  @override
  String get filterSettled => 'Réglés';

  @override
  String get addPerson => 'Ajouter une personne';

  @override
  String get addPersonHint => 'Quelqu’un avec qui vous partagez des frais';

  @override
  String get newPerson => 'Nouvelle personne';

  @override
  String get editPerson => 'Modifier la personne';

  @override
  String get deletePerson => 'Supprimer la personne';

  @override
  String get quickTransaction => 'Transaction rapide';

  @override
  String get quickTransactionHint =>
      'Notez qui a payé, avec une personne ajoutée';

  @override
  String get noPeopleYet => 'Aucune personne';

  @override
  String get noPeopleHint =>
      'Ajoutez les personnes avec qui vous partagez des frais pour savoir qui '
      'doit quoi à qui.';

  @override
  String get nobodyHere => 'Personne ne correspond à ce filtre.';

  @override
  String get addPersonFirst => 'Ajoutez d’abord une personne.';

  @override
  String get newTransaction => 'Nouvelle transaction';

  @override
  String get editTransaction => 'Modifier la transaction';

  @override
  String get transactionDetails => 'Détails de la transaction';

  @override
  String get debtNoteHint => 'C’était pour quoi ?';

  @override
  String get changeHistory => 'Historique des modifications';

  @override
  String get edited => 'Modifié';

  @override
  String get settleUp => 'Régler';

  @override
  String get settle => 'Régler';

  @override
  String get noDebtsYet => 'Rien d’enregistré pour l’instant';

  @override
  String get noDebtsHint =>
      'Ajoutez ce que vous avez payé pour cette personne, ou ce qu’elle a '
      'payé pour vous.';

  @override
  String get settleEven =>
      'Ces transactions s’annulent, aucun argent n’a besoin de changer de '
      'mains.';

  @override
  String get logSettlementTitle =>
      'Enregistrer ce règlement dans votre budget mensuel ?';

  @override
  String get loggedInBudget => 'Dans votre budget';

  @override
  String get deleteTransactionTitle => 'Supprimer cette transaction ?';

  @override
  String get deleteTransactionBody =>
      'Elle sera retirée du solde avec cette personne.';

  @override
  String get deletePersonBody =>
      'Ses transactions et son historique de règlements seront aussi '
      'supprimés. Ce que vous avez enregistré dans votre budget reste.';

  @override
  String get settledLocked => 'Réglée, elle ne peut plus être modifiée.';

  @override
  String get personUpdated => 'Personne mise à jour';

  @override
  String get debtDeleted => 'Transaction supprimée';

  @override
  String get settledUpNotice => 'Tout est réglé';

  @override
  String get settlementLogged => 'Ajouté à votre budget';

  @override
  String personOwesYou(String name) => '$name vous doit';

  @override
  String youOwePerson(String name) => 'Vous devez à $name';

  @override
  String settledWith(String name) => 'Tout est réglé avec $name';

  @override
  String settleUpFor(String amount) => 'Régler $amount';

  @override
  String settleTitle(String name) => 'Régler avec $name ?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name vous paie $amount pour tout solder.';

  @override
  String settleYouPay(String name, String amount) =>
      'Vous payez $amount à $name pour tout solder.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} passeront dans l’historique des règlements.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount sera ajouté comme revenu dans Autres revenus. Vous pourrez le '
      'déplacer vers une autre catégorie plus tard.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount sera ajouté comme dépense dans Autre. Vous pourrez le déplacer '
      'vers une autre catégorie plus tard.';

  @override
  String settlementNote(String name) => 'Règlement avec $name';

  @override
  String settledGroupTitle(String date) => 'Réglé le $date';

  @override
  String deletePersonTitle(String name) => 'Supprimer $name ?';

  @override
  String editedOn(String date) => 'Modifié le $date';

  @override
  String wasValues(String values) => 'Avant : $values';

  @override
  String personCount(int count) => plural(
    count,
    locale: localeName,
    one: '$count personne',
    other: '$count personnes',
  );

  @override
  String get importFromAi => 'Depuis une autre app';

  @override
  String get importFromAiHint =>
      'Convertissez vos données avec ChatGPT, Gemini, Claude ou une autre IA';

  @override
  String get aiImportTitle => 'Importer depuis une autre app';

  @override
  String get aiImportIntro =>
      'Une IA peut transformer les données d’une autre app ou d’un tableur en fichier que My Budget sait importer.';

  @override
  String get aiImportStep1 => 'Copiez le prompt.';

  @override
  String get aiImportStep2 =>
      'Collez-le dans ChatGPT, Gemini, Claude ou une autre IA, puis joignez ou collez vos données.';

  @override
  String get aiImportStep3 =>
      'Copiez la réponse de l’IA et collez-la ici, ou enregistrez-la dans un fichier et choisissez-le.';

  @override
  String get copyPrompt => 'Copier le prompt';

  @override
  String get pasteAnswer => 'Coller la réponse';

  @override
  String get chooseFile => 'Choisir un fichier';

  @override
  String get aiImportPrivacy =>
      'Vos données sont envoyées au service d’IA que vous choisissez. Vous verrez ce qui sera importé avant tout changement.';

  @override
  String get promptCopied => 'Prompt copié';

  @override
  String get askTitle => 'Questions sur vos dépenses';

  @override
  String get askHint => 'Touchez une question pour voir la réponse.';

  @override
  String get askCompareMonths => 'Comparer des mois';

  @override
  String get askTopCategory => 'Catégorie principale';

  @override
  String get askVsLastMonth => 'vs mois dernier';

  @override
  String get askBiggestExpense => 'Plus grosse dépense';

  @override
  String get askTopDay => 'Jour le plus cher';

  @override
  String get askWeekday => 'Jour le plus dépensier';

  @override
  String get askMonthEnd => 'Estimation fin de mois';

  @override
  String get askSaved => 'Ai-je économisé ?';

  @override
  String get askBudgetLeft => 'Budget restant';

  @override
  String get askHighestLowest => 'Mois le plus et le moins cher';

  @override
  String get askCount => 'Combien de dépenses';

  @override
  String get askTopIncome => 'Revenu principal';

  @override
  String get otherCategories => 'Autres';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'Le plus gros poste : $category, $amount ($percent du mois).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Vous avez dépensé $amount de plus en $month qu’en $other (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Vous avez dépensé $amount de moins en $month qu’en $other (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'Vous avez dépensé autant en $month qu’en $other.';

  @override
  String answerNothingIn(String month) => 'Aucune dépense en $month.';

  @override
  String answerRise(String category, String amount) =>
      'Plus forte hausse : $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Plus forte baisse : $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Plus grosse dépense : $amount en $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Jour le plus cher : $date, avec $amount dépensés.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Jour de la semaine le plus dépensier : $weekday ($amount ce mois-ci).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'À ce rythme (environ $average par jour), vous dépenserez environ $amount d’ici la fin du mois.';

  @override
  String answerMonthTotal(String amount) =>
      'Ce mois est terminé : vous avez dépensé $amount au total.';

  @override
  String answerSaved(String amount, String income) =>
      'Vous avez économisé $amount sur $income de revenus.';

  @override
  String answerOverspent(String amount) =>
      'Vous avez dépensé $amount de plus que vos revenus.';

  @override
  String get answerNoIncome => 'Aucun revenu enregistré ce mois-ci.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'Il reste $amount dans votre budget mensuel ($percent utilisés).';

  @override
  String answerBudgetOver(String amount) =>
      'Vous dépassez votre budget mensuel de $amount.';

  @override
  String get answerNoBudget =>
      'Vous n’avez pas encore défini de budget mensuel.';

  @override
  String answerOverLimit(String names) => 'Limite dépassée : $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) =>
      'Mois le plus cher : $high ($highAmount). Le moins cher : $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'Vous avez enregistré ${expenseCount(count)}, $average en moyenne.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'Principale source de revenus : $category, $amount ($percent).';

  @override
  String? currencyName(String code) => switch (code) {
    'EGP' => 'Livre égyptienne',
    'USD' => 'Dollar américain',
    'EUR' => 'Euro',
    'SAR' => 'Riyal saoudien',
    'AED' => 'Dirham des EAU',
    'KWD' => 'Dinar koweïtien',
    'QAR' => 'Riyal qatari',
    'BHD' => 'Dinar bahreïni',
    'OMR' => 'Rial omanais',
    'JOD' => 'Dinar jordanien',
    'IQD' => 'Dinar irakien',
    'LBP' => 'Livre libanaise',
    'SYP' => 'Livre syrienne',
    'YER' => 'Rial yéménite',
    'SDG' => 'Livre soudanaise',
    'LYD' => 'Dinar libyen',
    'MAD' => 'Dirham marocain',
    'TND' => 'Dinar tunisien',
    'DZD' => 'Dinar algérien',
    'GBP' => 'Livre sterling',
    'TRY' => 'Livre turque',
    'IRR' => 'Rial iranien',
    'PKR' => 'Roupie pakistanaise',
    'INR' => 'Roupie indienne',
    'RUB' => 'Rouble russe',
    'UAH' => 'Hryvnia ukrainienne',
    'PLN' => 'Zloty polonais',
    'CHF' => 'Franc suisse',
    'BRL' => 'Réal brésilien',
    'CAD' => 'Dollar canadien',
    'AUD' => 'Dollar australien',
    'CNY' => 'Yuan chinois',
    'JPY' => 'Yen japonais',
    'KRW' => 'Won sud-coréen',
    'IDR' => 'Roupie indonésienne',
    'MYR' => 'Ringgit malaisien',
    'VND' => 'Dong vietnamien',
    'NGN' => 'Naira nigérian',
    _ => null,
  };
}
