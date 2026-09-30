import '../../error/failures.dart';
import '../app_strings.dart';

/// Turkish keeps a noun singular after a number, so counts need no plural
/// forms.
class AppStringsTr extends AppStrings {
  const AppStringsTr();

  @override
  String get localeName => 'tr';

  @override
  String get appTitle => 'Bütçem';

  @override
  String get add => 'Ekle';

  @override
  String get undo => 'Geri al';

  @override
  String get tryAgain => 'Tekrar dene';

  @override
  String get nothingRecordedYet => 'Henüz kayıt yok';

  @override
  String get emptyMonthHint =>
      'Bu ayın ilk gider ya da gelirini kaydetmek için Ekle’ye dokunun.';

  @override
  String get yourMonths => 'Aylarınız';

  @override
  String spentIn(String month) => '$month harcaması';

  @override
  String expenseCount(int count) => '$count gider';

  @override
  String get quickExpense => 'Hızlı gider';

  @override
  String get expenseSaved => 'Gider kaydedildi';

  @override
  String get newExpense => 'Yeni gider';

  @override
  String get editExpense => 'Gideri düzenle';

  @override
  String get when => 'Ne zaman';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get pickADate => 'Tarih seç';

  @override
  String get category => 'Kategori';

  @override
  String get noteOptional => 'Not (isteğe bağlı)';

  @override
  String get noteHint => 'Ne içindi?';

  @override
  String get addExpense => 'Gider ekle';

  @override
  String get saveChanges => 'Değişiklikleri kaydet';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Kategoriler';

  @override
  String get newCategory => 'Yeni kategori';

  @override
  String get editCategory => 'Kategoriyi düzenle';

  @override
  String get addCategory => 'Kategori ekle';

  @override
  String get categoryName => 'Ad';

  @override
  String get color => 'Renk';

  @override
  String get icon => 'Simge';

  @override
  String get builtIn => 'Hazır';

  @override
  String get custom => 'Özel';

  @override
  String get edit => 'Düzenle';

  @override
  String get delete => 'Sil';

  @override
  String get cancel => 'İptal';

  @override
  String deleteCategoryTitle(String name) => '$name silinsin mi?';

  @override
  String get deleteCategoryBody =>
      'Bu kategorideki giderler Diğer’e taşınır. Hiçbir şey silinmez.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get appearance => 'Görünüm';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get language => 'Dil';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get currency => 'Para birimi';

  @override
  String get currencySymbol => 'Simge';

  @override
  String get currencySymbolHint => 'Her tutarın yanında gösterilir';

  @override
  String get reminders => 'Hatırlatıcılar';

  @override
  String get dailyReminder => 'Günlük hatırlatıcı';

  @override
  String get dailyReminderHint =>
      'Bugünkü harcamalarınızı kaydetmeniz için bir hatırlatma';

  @override
  String get reminderTime => 'Saat';

  @override
  String get notificationsBlocked =>
      'Bu uygulamanın bildirimleri kapalı. Telefonunuzun ayarlarından izin verin.';

  @override
  String get reminderNotificationTitle => 'Bugünkü harcamalarınızı kaydedin';

  @override
  String get reminderNotificationBody =>
      'Bugün harcadıklarınızı eklemek için bir dakikanızı ayırın.';

  @override
  String get security => 'Güvenlik';

  @override
  String get appLock => 'Uygulama kilidi';

  @override
  String get appLockHint =>
      'Uygulama açılırken parmak izi, yüz veya ekran kilidi istensin';

  @override
  String get appLockUnavailable =>
      'Önce bu telefonda bir ekran kilidi ayarlayın';

  @override
  String get unlock => 'Kilidi aç';

  @override
  String get unlockToContinue => 'Bütçenizi görmek için kilidi açın';

  @override
  String get confirmItsYou =>
      'Kilidi değiştirmek için siz olduğunuzu doğrulayın';

  @override
  String get storedOnThisDevice =>
      'Giderleriniz bu cihazda saklanır. Yedeklemek için giriş yapın.';

  @override
  String get account => 'Hesap';

  @override
  String get accountOptional =>
      'Hesap isteğe bağlıdır. Uygulama hesapsız da tamamen çalışır.';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get signedIn => 'Giriş yapıldı';

  @override
  String get createAccount => 'Hesap oluştur';

  @override
  String get noAccountYet => 'Hesabınız yok mu? Oluşturun';

  @override
  String get haveAnAccount => 'Zaten hesabınız var mı? Giriş yapın';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get passwordRules => 'En az 6 karakter';

  @override
  String get confirmEmail => 'E-postanızı doğrulayın';

  @override
  String codeSentTo(String email) =>
      '$email adresine bir kod gönderdik. Hesabınızı oluşturmayı bitirmek '
      'için aşağıya girin.';

  @override
  String get confirmationCode => 'Kod';

  @override
  String get confirm => 'Onayla';

  @override
  String get resendCode => 'Yeni kod gönder';

  @override
  String get codeResent => 'Yeni kod yolda';

  @override
  String get useDifferentEmail => 'Başka bir e-posta kullan';

  @override
  String get forgotPassword => 'Şifrenizi mi unuttunuz?';

  @override
  String get resetPassword => 'Şifreyi sıfırla';

  @override
  String resetCodeSentTo(String email) =>
      '$email adresine bir kod gönderdik. Kodu, hesabınız için yeni bir şifreyle birlikte girin.';

  @override
  String get newPassword => 'Yeni şifre';

  @override
  String get saveNewPassword => 'Yeni şifreyi kaydet';

  @override
  String get backToSignIn => 'Girişe dön';

  @override
  String get backupHint =>
      'Giderlerinizin bir kopyasını hesabınızda tutmak için yedekleyin. Geri '
      'yükleme, bu kopyayı buradaki hiçbir şeyi silmeden telefona getirir.';

  @override
  String get backUpNow => 'Şimdi yedekle';

  @override
  String get autoBackup => 'Otomatik yedekle';

  @override
  String get autoBackupHint =>
      'Uygulamadan her çıktığınızda yeni değişiklikler hesabınıza yedeklenir.';

  @override
  String get restoreData => 'Geri yükle';

  @override
  String get backingUp => 'Yedekleniyor…';

  @override
  String get restoring => 'Geri yükleniyor…';

  @override
  String get backupDone => 'Yedekleme tamamlandı';

  @override
  String get restoreDone => 'Geri yükleme tamamlandı';

  @override
  String get neverSynced => 'Henüz yedeklenmedi';

  @override
  String lastSynced(String when) => 'Son eşitleme: $when';

  @override
  String get deleteAccount => 'Hesabı sil';

  @override
  String get deleteAccountTitle => 'Hesabınız silinsin mi?';

  @override
  String get deleteAccountBody =>
      'Bu işlem hesabınızı ve içinde saklanan gider yedeğinizi kalıcı olarak '
      'siler. Geri alınamaz. Bu telefondaki giderler burada kalır ve '
      'uygulamayı hesapsız kullanmaya devam edebilirsiniz.';

  @override
  String get deletingAccount => 'Hesabınız siliniyor…';

  @override
  String get accountDeleted => 'Hesabınız silindi';

  @override
  String get home => 'Ana sayfa';

  @override
  String get analyses => 'Analiz';

  @override
  String get vsLastMonth => 'Geçen aya göre';

  @override
  String get noComparison => 'Geçen ay veri yok';

  @override
  String get dailySpending => 'Günlük harcama';

  @override
  String get dailyAverage => 'Günlük ortalama';

  @override
  String get topDay => 'En yüksek gün';

  @override
  String get byCategory => 'Kategoriye göre harcama';

  @override
  String get noSpendingThisMonth => 'Bu ay henüz harcama yok.';

  @override
  String get monthlyTrend => 'Son 6 ay';

  @override
  String lastMonthTotal(String amount) => 'Geçen ay: $amount';

  @override
  String get budgets => 'Bütçeler';

  @override
  String get monthlyBudget => 'Aylık bütçe';

  @override
  String get setMonthlyBudget => 'Aylık bütçe belirleyin';

  @override
  String get setBudgetHint =>
      'Ne kaldığını görün, fazla harcamadan önce uyarı alın.';

  @override
  String get setBudget => 'Belirle';

  @override
  String get editBudget => 'Bütçeyi düzenle';

  @override
  String get removeBudget => 'Kaldır';

  @override
  String get save => 'Kaydet';

  @override
  String amountLeft(String amount) => '$amount kaldı';

  @override
  String amountOver(String amount) => 'Bütçe $amount aşıldı';

  @override
  String spentOfLimit(String spent, String limit) =>
      '$limit bütçenin $spent kadarı harcandı';

  @override
  String amountSpent(String amount) => '$amount harcandı';

  @override
  String budgetUsed(String percent) => 'Bütçenin $percent kadarı kullanıldı';

  @override
  String get categoryBudgets => 'Kategori bütçeleri';

  @override
  String get categoryBudgetsHint =>
      'Tek bir kategoriye harcadığınıza sınır koyun.';

  @override
  String categoryBudgetTitle(String name) => '$name bütçesi';

  @override
  String get setLimit => 'Sınır belirle';

  @override
  String get closeToLimit => 'Sınırına yakın';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Bütçeler her ay yenilenir. Harcama $nearing oranını geçince ve '
      '$reached oranına ulaşınca uyarı alırsınız.';

  @override
  String get budgetAlertTitle => 'Bütçe uyarısı';

  @override
  String get ok => 'Tamam';

  @override
  String get view => 'Görüntüle';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Aylık bütçenizin $percent kadarını kullandınız';

  @override
  String get monthlyBudgetUsedUp => 'Aylık bütçenizin tamamını kullandınız';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Aylık bütçenizi $amount aştınız';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      '$name bütçenizin $percent kadarını kullandınız';

  @override
  String categoryBudgetUsedUp(String name) =>
      '$name bütçenizin tamamını kullandınız';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      '$name bütçenizi $amount aştınız';

  @override
  String get dataManagement => 'Veri yönetimi';

  @override
  String get dataManagementHint =>
      'Kendiniz sakladığınız dosyalar. Çevrimdışı ve hesapsız çalışırlar.';

  @override
  String get backUpToFile => 'Verilerimi yedekle';

  @override
  String get backUpToFileHint =>
      'Daha sonra içe aktarabileceğiniz eksiksiz bir yedek dosyası';

  @override
  String get exportCsv => 'CSV olarak dışa aktar';

  @override
  String get exportCsvHint => 'Excel veya Google E-Tablolar için';

  @override
  String get exportPdf => 'PDF olarak dışa aktar';

  @override
  String get exportPdfHint => 'Okumak, yazdırmak ya da paylaşmak için rapor';

  @override
  String get importData => 'Verileri içe aktar';

  @override
  String get importDataHint => 'Bir yedek dosyasından geri yükle';

  @override
  String get preparingFile => 'Dosyanız hazırlanıyor…';

  @override
  String get importingData => 'İçe aktarılıyor…';

  @override
  String get fileSaved => 'Dosya kaydedildi';

  @override
  String get importDone => 'İçe aktarma tamamlandı';

  @override
  String get importNothingNew => 'Bu telefonda yedekteki her şey zaten vardı';

  @override
  String get fileReady => 'Dosyanız hazır';

  @override
  String get shareFile => 'Paylaş';

  @override
  String get shareFileHint => 'WhatsApp, e-posta, Google Drive ve daha fazlası';

  @override
  String get saveToPhone => 'Bu telefona kaydet';

  @override
  String get saveToPhoneHint => 'Nerede saklanacağını seçin';

  @override
  String get importTitle => 'Bu yedek içe aktarılsın mı?';

  @override
  String get importMergeHint =>
      'Birleştir, bu telefondaki her şeyi korur ve eksikleri ekler. Bir kayıt '
      'farklıysa daha yeni değişiklik geçerli olur.';

  @override
  String get merge => 'Birleştir';

  @override
  String get replaceEverything => 'Tümünü değiştir';

  @override
  String get replaceTitle => 'Bu telefondaki her şey değiştirilsin mi?';

  @override
  String get replaceBody =>
      'Bu telefonda olup yedekte olmayan her şey silinir ve her kaydın '
      'yedekteki sürümü kullanılır. Geri alınamaz.';

  @override
  String get replace => 'Değiştir';

  @override
  String get colDate => 'Tarih';

  @override
  String get colMonth => 'Ay';

  @override
  String get colAmount => 'Tutar';

  @override
  String get colNote => 'Not';

  @override
  String get colId => 'Kimlik';

  @override
  String get colCount => 'İşlemler';

  @override
  String get colTotal => 'Toplam';

  @override
  String get colShare => 'Pay';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get reportTitle => 'Bütçem: gider raporu';

  @override
  String get reportPeriod => 'Dönem';

  @override
  String get reportTotal => 'Toplam harcama';

  @override
  String get reportMonthlyAverage => 'Aylık ortalama';

  @override
  String get reportByMonth => 'Aylara göre harcama';

  @override
  String get reportAllExpenses => 'Tüm giderler';

  @override
  String get reportEmpty => 'Henüz gider kaydı yok.';

  @override
  String get reportPageTemplate => 'Sayfa {page}/{pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} ve ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} ve '
              '${personCount(people)}';
    return date == null
        ? 'Bu yedekte $contents var.'
        : '$date tarihli yedek: $contents.';
  }

  @override
  String categoryCount(int count) => '$count kategori';

  @override
  String reportGenerated(String when) => 'Oluşturulma: $when';

  @override
  String get showPassword => 'Şifreyi göster';

  @override
  String get hidePassword => 'Şifreyi gizle';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Yemek',
    'cat_transport' => 'Ulaşım',
    'cat_bills' => 'Faturalar',
    'cat_shopping' => 'Alışveriş',
    'cat_health' => 'Sağlık ve spor',
    'cat_entertainment' => 'Eğlence',
    'cat_work' => 'İş',
    'cat_other' => 'Diğer',
    'cat_salary' => 'Maaş',
    'cat_freelance' => 'Serbest iş',
    'cat_investments' => 'Yatırımlar',
    'cat_gifts' => 'Hediyeler',
    'cat_income_other' => 'Diğer gelir',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => 'Bu cihaza kaydedilemedi. Tekrar deneyin.',
    FailureCode.notFound => 'Bu öğe artık yok.',
    FailureCode.unknown => 'Bir şeyler ters gitti.',
    FailureCode.amountRequired => 'Sıfırdan büyük bir tutar girin.',
    FailureCode.amountTooLarge => 'Bu tutar çok büyük.',
    FailureCode.amountInvalid => 'Geçerli bir tutar girin.',
    FailureCode.categoryRequired => 'Bir kategori seçin.',
    FailureCode.categoryNameRequired => 'Kategoriye bir ad verin.',
    FailureCode.categoryNameTooLong => 'Ad 30 karakterden kısa olmalı.',
    FailureCode.categoryProtected => 'Bu kategori silinemez.',
    FailureCode.currencySymbolInvalid => '1 ile 4 karakter kullanın.',
    FailureCode.network =>
      'Bağlanılamadı. İnternetinizi kontrol edip tekrar deneyin.',
    FailureCode.emailInvalid => 'Geçerli bir e-posta adresi girin.',
    FailureCode.passwordTooShort => 'Şifre en az 6 karakter olmalı.',
    FailureCode.invalidCredentials => 'E-posta veya şifre yanlış.',
    FailureCode.emailTaken => 'Bu e-postayla bir hesap zaten var.',
    FailureCode.emailNotConfirmed =>
      'Önce gönderdiğimiz kodla e-postanızı doğrulayın.',
    FailureCode.codeInvalid => 'Kod yanlış ya da süresi dolmuş.',
    FailureCode.signInRequired => 'Tekrar giriş yapıp yeniden deneyin.',
    FailureCode.syncOtherAccount =>
      'Bu telefondaki veriler başka bir hesaba bağlı.',
    FailureCode.syncFailed => 'Hesabınızla eşitlenemedi. Tekrar deneyin.',
    FailureCode.accountDeletionFailed =>
      'Hesabınız silinemedi. Tekrar deneyin.',
    FailureCode.backupNotRecognized => 'Bu dosya bir Bütçem yedeği değil.',
    FailureCode.backupTooNew =>
      'Bu yedek Bütçem’in daha yeni bir sürümünden. Uygulamayı güncelleyip '
          'tekrar deneyin.',
    FailureCode.backupDamaged =>
      'Bu yedek dosyası bozuk, bu yüzden hiçbir şey içe aktarılmadı.',
    FailureCode.fileUnavailable => 'Dosya açılamadı. Yeniden seçmeyi deneyin.',
    FailureCode.storageFull => 'Bu telefonda yeterli boş alan yok.',
    FailureCode.exportFailed => 'Dosya oluşturulamadı. Tekrar deneyin.',
    FailureCode.shareUnavailable => 'Paylaşım menüsü açılamadı.',
    FailureCode.saveFailed => 'Dosya kaydedilemedi. Tekrar deneyin.',
    FailureCode.tooManyAttempts =>
      'Çok fazla deneme. Biraz bekleyip tekrar deneyin.',
    FailureCode.titleRequired => 'Bir ad verin.',
    FailureCode.titleTooLong => 'Ad 40 karakterden kısa olmalı.',
    FailureCode.dueDayInvalid => 'Ödeme gününü seçin.',
    FailureCode.alreadyPaid => 'Bu ödeme zaten kayıtlı.',
    FailureCode.personRequired => 'Bir kişi seçin.',
    FailureCode.personNameRequired => 'Bir ad girin.',
    FailureCode.personNameTooLong => 'Ad 40 karakterden kısa olmalı.',
    FailureCode.phoneInvalid => 'Geçerli bir telefon numarası girin.',
    FailureCode.transactionSettled => 'Kapatılan işlemler değiştirilemez.',
    FailureCode.nothingToSettle => 'Kapatılacak bir şey yok.',
    FailureCode.settlementAlreadyLogged => 'Bu hesaplaşma zaten bütçenizde.',
  };

  @override
  String get expenseDeleted => 'Gider silindi';

  @override
  String get expenseRestored => 'Gider geri yüklendi';

  @override
  String categoryAdded(String name) => '$name eklendi';

  @override
  String get categoryUpdated => 'Kategori güncellendi';

  @override
  String categoryDeleted(String name) => '$name silindi';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name silindi — ${expenseCount(count)} Diğer’e taşındı';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name silindi — ${transactionCount(count)} Diğer gelir’e taşındı';

  @override
  String get expense => 'Gider';

  @override
  String get income => 'Gelir';

  @override
  String get search => 'Ara';

  @override
  String get searchHint => 'Not veya tutar arayın';

  @override
  String get searchPrompt =>
      'Herhangi bir işlemi notu veya tutarıyla bulun ya da tür, kategori ve tarihe göre süzün.';

  @override
  String get noSearchResults => 'Eşleşen işlem yok';

  @override
  String get allTypes => 'Tümü';

  @override
  String get anyCategory => 'Tüm kategoriler';

  @override
  String get anyDate => 'Tüm tarihler';

  @override
  String get clearFilters => 'Filtreleri temizle';

  @override
  String get transactionType => 'Gider ya da gelir';

  @override
  String get quickIncome => 'Hızlı gelir';

  @override
  String get newIncome => 'Yeni gelir';

  @override
  String get editIncome => 'Geliri düzenle';

  @override
  String get addIncome => 'Gelir ekle';

  @override
  String get incomeNoteHint => 'Nereden geldi?';

  @override
  String get totalIncome => 'Toplam gelir';

  @override
  String get totalExpenses => 'Toplam gider';

  @override
  String get netBalance => 'Net bakiye';

  @override
  String get savingsRate => 'Tasarruf oranı';

  @override
  String get savingsRateNoIncome =>
      'Tasarruf oranınızı görmek için gelir ekleyin';

  @override
  String get expenseCategories => 'Gider kategorileri';

  @override
  String get incomeCategories => 'Gelir kategorileri';

  @override
  String get deleteIncomeCategoryBody =>
      'Bu kategorideki gelirler Diğer gelir’e taşınır. Hiçbir şey silinmez.';

  @override
  String get incomeDeleted => 'Gelir silindi';

  @override
  String get incomeRestored => 'Gelir geri yüklendi';

  @override
  String get colType => 'Tür';

  @override
  String transactionCount(int count) => '$count işlem';

  @override
  String get recurringPayments => 'Düzenli ödemeler';

  @override
  String get newRecurring => 'Yeni düzenli ödeme';

  @override
  String get editRecurring => 'Düzenli ödemeyi düzenle';

  @override
  String get addRecurring => 'Ödeme ekle';

  @override
  String get recurringTitle => 'Ad';

  @override
  String get recurringTitleHint => 'Kira, Netflix, spor salonu…';

  @override
  String get amount => 'Tutar';

  @override
  String get repeats => 'Tekrar';

  @override
  String get weekly => 'Haftalık';

  @override
  String get monthly => 'Aylık';

  @override
  String get yearly => 'Yıllık';

  @override
  String get dueOn => 'Son ödeme';

  @override
  String get dueDayOfMonth => 'Ayın günü';

  @override
  String get dueMonthLabel => 'Ay';

  @override
  String get dueDayLabel => 'Gün';

  @override
  String get shortMonthHint => 'Daha kısa aylarda son güne denk gelir.';

  @override
  String get whenDue => 'Ödeme günü gelince';

  @override
  String get autoDeduct => 'Otomatik';

  @override
  String get remindMe => 'Hatırlat';

  @override
  String get autoDeductHint =>
      'Ödeme gününde otomatik olarak gider kaydedilir.';

  @override
  String get remindMeHint =>
      'Her ödemeyi kaydedilmeden önce onaylamanız istenir.';

  @override
  String get statusPaid => 'Ödendi';

  @override
  String get statusUpcoming => 'Yaklaşan';

  @override
  String get statusOverdue => 'Gecikmiş';

  @override
  String get markAsPaid => 'Ödendi';

  @override
  String get dueToday => 'Bugün ödenecek';

  @override
  String dueOnDate(String date) => 'Son ödeme: $date';

  @override
  String nextDueOn(String date) => 'Sonraki: $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Son ödeme $date idi'
      : '$date tarihinden beri ${paymentCount(count)} gecikti';

  @override
  String everyWeekday(String weekday) => 'Her $weekday';

  @override
  String monthlyOnDay(String day) => 'Her ayın $day. günü';

  @override
  String yearlyOn(String date) => 'Her yıl $date';

  @override
  String get monthlyAverage => 'Aylık';

  @override
  String get monthlyAverageHint => 'Tüm düzenli ödemeleriniz, ortalama';

  @override
  String get noRecurringYet => 'Henüz düzenli ödeme yok';

  @override
  String get noRecurringHint =>
      'Kira, fatura ve abonelikleri bir kez ekleyin. Her ay neyin ödendiğini '
      've neyin beklediğini görürsünüz.';

  @override
  String get paymentsToConfirm => 'Onay bekleyen ödemeler';

  @override
  String get seeAll => 'Tümü';

  @override
  String get deleteRecurringBody =>
      'Artık tekrarlanmaz. Kaydedilmiş ödemeler işlemlerinizde kalır.';

  @override
  String recurringPaid(String name) => '$name ödendi olarak işaretlendi';

  @override
  String recurringReceived(String name) => '$name alındı olarak işaretlendi';

  @override
  String get statusReceived => 'Alındı';

  @override
  String get markAsReceived => 'Alındı';

  @override
  String get autoAdd => 'Otomatik';

  @override
  String get autoAddHint => 'Ödeme gününde otomatik olarak gelir kaydedilir.';

  @override
  String get monthlyIncomeAverage => 'Aylık gelir';

  @override
  String get recurringPaymentUndone => 'Ödeme kaldırıldı';

  @override
  String recurringAutoLogged(int count) =>
      '$count düzenli ödeme otomatik olarak kaydedildi';

  @override
  String paymentCount(int count) => '$count ödeme';

  @override
  String get colPaidThrough => 'Ödendiği son tarih';

  // People & debts

  @override
  String get people => 'Kişiler';

  @override
  String get peopleAndDebts => 'Kişiler ve borçlar';

  @override
  String get person => 'Kişi';

  @override
  String get personName => 'Ad';

  @override
  String get phone => 'Telefon';

  @override
  String get phoneOptional => 'Telefon (isteğe bağlı)';

  @override
  String get balance => 'Bakiye';

  @override
  String get colStatus => 'Durum';

  @override
  String get owesYou => 'Size borçlu';

  @override
  String get youOwe => 'Borçlusunuz';

  @override
  String get owedToYou => 'Alacağınız';

  @override
  String get settledUp => 'Kapandı';

  @override
  String get iPaidForThem => 'Onun yerine ödedim';

  @override
  String get theyPaidForMe => 'Benim yerime ödedi';

  @override
  String get theyPaidYou => 'Size ödedi';

  @override
  String get youPaidThem => 'Siz ödediniz';

  @override
  String get openStatus => 'Açık';

  @override
  String get settledStatus => 'Kapandı';

  @override
  String get settledOn => 'Kapanış';

  @override
  String get createdOn => 'Oluşturulma';

  @override
  String get lastEdited => 'Son düzenleme';

  @override
  String get colEdits => 'Düzenlemeler';

  @override
  String get activeTransactions => 'Açık işlemler';

  @override
  String get settledHistory => 'Kapanan işlemler';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterOwedToMe => 'Alacaklarım';

  @override
  String get filterIOwe => 'Borçlarım';

  @override
  String get filterSettled => 'Kapanan';

  @override
  String get addPerson => 'Kişi ekle';

  @override
  String get addPersonHint => 'Masrafları paylaştığınız biri';

  @override
  String get newPerson => 'Yeni kişi';

  @override
  String get editPerson => 'Kişiyi düzenle';

  @override
  String get deletePerson => 'Kişiyi sil';

  @override
  String get quickTransaction => 'Hızlı işlem';

  @override
  String get quickTransactionHint =>
      'Eklediğiniz biriyle kimin ödediğini kaydedin';

  @override
  String get noPeopleYet => 'Henüz kişi yok';

  @override
  String get noPeopleHint =>
      'Kimin kime borçlu olduğunu takip etmek için masrafları paylaştığınız '
      'kişileri ekleyin.';

  @override
  String get nobodyHere => 'Bu filtreye uyan kimse yok.';

  @override
  String get addPersonFirst => 'Önce bir kişi ekleyin.';

  @override
  String get newTransaction => 'Yeni işlem';

  @override
  String get editTransaction => 'İşlemi düzenle';

  @override
  String get transactionDetails => 'İşlem ayrıntıları';

  @override
  String get debtNoteHint => 'Ne içindi?';

  @override
  String get changeHistory => 'Değişiklik geçmişi';

  @override
  String get edited => 'Düzenlendi';

  @override
  String get settleUp => 'Hesaplaş';

  @override
  String get settle => 'Kapat';

  @override
  String get noDebtsYet => 'Henüz kayıt yok';

  @override
  String get noDebtsHint =>
      'Onun için ödediğinizi ya da onun sizin için ödediğini ekleyin.';

  @override
  String get settleEven =>
      'Bu işlemler birbirini sıfırlıyor, kimsenin para ödemesi gerekmiyor.';

  @override
  String get logSettlementTitle =>
      'Bu hesaplaşma aylık bütçenize kaydedilsin mi?';

  @override
  String get loggedInBudget => 'Bütçenizde';

  @override
  String get deleteTransactionTitle => 'Bu işlem silinsin mi?';

  @override
  String get deleteTransactionBody => 'Bu kişiyle olan bakiyeden çıkarılır.';

  @override
  String get deletePersonBody =>
      'Kişinin işlemleri ve kapanan işlemleri de silinir. Bütçenize '
      'kaydettikleriniz kalır.';

  @override
  String get settledLocked => 'Kapandığı için artık değiştirilemez.';

  @override
  String get personUpdated => 'Kişi güncellendi';

  @override
  String get debtDeleted => 'İşlem silindi';

  @override
  String get settledUpNotice => 'Tüm hesaplar kapandı';

  @override
  String get settlementLogged => 'Bütçenize eklendi';

  @override
  String personOwesYou(String name) => '$name size borçlu';

  @override
  String youOwePerson(String name) => '$name kişisine borçlusunuz';

  @override
  String settledWith(String name) => '$name ile tüm hesaplar kapandı';

  @override
  String settleUpFor(String amount) => '$amount hesaplaş';

  @override
  String settleTitle(String name) => '$name ile hesaplaşılsın mı?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name size $amount öder ve her şey kapanır.';

  @override
  String settleYouPay(String name, String amount) =>
      '$name kişisine $amount ödersiniz ve her şey kapanır.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} kapanan işlemlere taşınacak.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount, Diğer gelir altında gelir olarak eklenecek. Daha sonra başka '
      'bir kategoriye taşıyabilirsiniz.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount, Diğer altında gider olarak eklenecek. Daha sonra başka bir '
      'kategoriye taşıyabilirsiniz.';

  @override
  String settlementNote(String name) => '$name ile hesaplaşma';

  @override
  String settledGroupTitle(String date) => '$date tarihinde kapandı';

  @override
  String deletePersonTitle(String name) => '$name silinsin mi?';

  @override
  String editedOn(String date) => '$date tarihinde düzenlendi';

  @override
  String wasValues(String values) => 'Önceki: $values';

  @override
  String personCount(int count) => '$count kişi';
}
