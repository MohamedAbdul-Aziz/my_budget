import '../../error/failures.dart';
import '../app_strings.dart';

/// Malay nouns do not change after a number, so counts need no plural forms.
class AppStringsMs extends AppStrings {
  const AppStringsMs();

  @override
  String get localeName => 'ms';

  @override
  String get appTitle => 'Bajet Saya';

  @override
  String get add => 'Tambah';

  @override
  String get undo => 'Buat asal';

  @override
  String get tryAgain => 'Cuba lagi';

  @override
  String get nothingRecordedYet => 'Belum ada rekod';

  @override
  String get emptyMonthHint =>
      'Ketik Tambah untuk merekod perbelanjaan atau pendapatan pertama bulan '
      'ini.';

  @override
  String get yourMonths => 'Bulan anda';

  @override
  String spentIn(String month) => 'Dibelanjakan pada $month';

  @override
  String expenseCount(int count) => '$count perbelanjaan';

  @override
  String get quickExpense => 'Perbelanjaan pantas';

  @override
  String get expenseSaved => 'Perbelanjaan disimpan';

  @override
  String get newExpense => 'Perbelanjaan baharu';

  @override
  String get editExpense => 'Edit perbelanjaan';

  @override
  String get when => 'Bila';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Semalam';

  @override
  String get pickADate => 'Pilih tarikh';

  @override
  String get category => 'Kategori';

  @override
  String get noteOptional => 'Nota (pilihan)';

  @override
  String get noteHint => 'Untuk apa?';

  @override
  String get addExpense => 'Tambah perbelanjaan';

  @override
  String get saveChanges => 'Simpan perubahan';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Kategori';

  @override
  String get newCategory => 'Kategori baharu';

  @override
  String get editCategory => 'Edit kategori';

  @override
  String get addCategory => 'Tambah kategori';

  @override
  String get categoryName => 'Nama';

  @override
  String get color => 'Warna';

  @override
  String get icon => 'Ikon';

  @override
  String get builtIn => 'Terbina';

  @override
  String get custom => 'Tersuai';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Padam';

  @override
  String get cancel => 'Batal';

  @override
  String deleteCategoryTitle(String name) => 'Padam $name?';

  @override
  String get deleteCategoryBody =>
      'Perbelanjaan dalam kategori ini akan dipindahkan ke Lain-lain. Tiada '
      'apa yang dipadam.';

  @override
  String get settings => 'Tetapan';

  @override
  String get appearance => 'Penampilan';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Cerah';

  @override
  String get themeDark => 'Gelap';

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get currency => 'Mata wang';

  @override
  String get currencySymbol => 'Simbol';

  @override
  String get currencySymbolHint => 'Dipaparkan di sebelah setiap amaun';

  @override
  String get reminders => 'Peringatan';

  @override
  String get dailyReminder => 'Peringatan harian';

  @override
  String get dailyReminderHint =>
      'Peringatan untuk mencatat perbelanjaan anda hari ini';

  @override
  String get reminderTime => 'Masa';

  @override
  String get notificationsBlocked =>
      'Pemberitahuan untuk apl ini dimatikan. Benarkan dalam tetapan telefon anda.';

  @override
  String get reminderNotificationTitle => 'Catat perbelanjaan hari ini';

  @override
  String get reminderNotificationBody =>
      'Luangkan sedikit masa untuk menambah perbelanjaan hari ini.';

  @override
  String get security => 'Keselamatan';

  @override
  String get appLock => 'Kunci apl';

  @override
  String get appLockHint =>
      'Minta cap jari, wajah atau kunci skrin apabila apl dibuka';

  @override
  String get appLockUnavailable =>
      'Tetapkan kunci skrin pada telefon ini dahulu';

  @override
  String get unlock => 'Buka kunci';

  @override
  String get unlockToContinue => 'Buka kunci untuk melihat bajet anda';

  @override
  String get confirmItsYou => 'Sahkan ini anda untuk menukar kunci apl';

  @override
  String get storedOnThisDevice =>
      'Perbelanjaan anda disimpan pada peranti ini. Log masuk untuk membuat '
      'sandaran.';

  @override
  String get account => 'Akaun';

  @override
  String get accountOptional =>
      'Akaun adalah pilihan. Aplikasi berfungsi sepenuhnya tanpanya.';

  @override
  String get signIn => 'Log masuk';

  @override
  String get signOut => 'Log keluar';

  @override
  String get signedIn => 'Sudah log masuk';

  @override
  String get createAccount => 'Cipta akaun';

  @override
  String get noAccountYet => 'Belum ada akaun? Cipta satu';

  @override
  String get haveAnAccount => 'Sudah ada akaun? Log masuk';

  @override
  String get email => 'E-mel';

  @override
  String get password => 'Kata laluan';

  @override
  String get passwordRules => 'Sekurang-kurangnya 6 aksara';

  @override
  String get confirmEmail => 'Sahkan e-mel anda';

  @override
  String codeSentTo(String email) =>
      'Kami telah menghantar kod ke $email. Masukkan di bawah untuk '
      'melengkapkan akaun anda.';

  @override
  String get confirmationCode => 'Kod';

  @override
  String get confirm => 'Sahkan';

  @override
  String get resendCode => 'Hantar kod baharu';

  @override
  String get codeResent => 'Kod baharu sedang dihantar';

  @override
  String get useDifferentEmail => 'Guna e-mel lain';

  @override
  String get forgotPassword => 'Lupa kata laluan?';

  @override
  String get resetPassword => 'Tetapkan semula kata laluan';

  @override
  String resetCodeSentTo(String email) =>
      'Kami telah menghantar kod ke $email. Masukkan kod itu bersama kata laluan baharu untuk akaun anda.';

  @override
  String get newPassword => 'Kata laluan baharu';

  @override
  String get saveNewPassword => 'Simpan kata laluan baharu';

  @override
  String get backToSignIn => 'Kembali ke log masuk';

  @override
  String get backupHint =>
      'Buat sandaran untuk menyimpan salinan perbelanjaan dalam akaun anda. '
      'Pulihkan membawa salinan itu ke telefon ini tanpa membuang apa-apa '
      'yang sudah ada.';

  @override
  String get backUpNow => 'Sandarkan sekarang';

  @override
  String get autoBackup => 'Sandaran automatik';

  @override
  String get autoBackupHint =>
      'Setiap kali anda keluar dari apl, perubahan baharu disandarkan ke akaun anda.';

  @override
  String get restoreData => 'Pulihkan';

  @override
  String get backingUp => 'Menyandarkan…';

  @override
  String get restoring => 'Memulihkan…';

  @override
  String get backupDone => 'Sandaran selesai';

  @override
  String get restoreDone => 'Pemulihan selesai';

  @override
  String get neverSynced => 'Belum disandarkan';

  @override
  String lastSynced(String when) => 'Kali terakhir disegerakkan $when';

  @override
  String get deleteAccount => 'Padam akaun';

  @override
  String get deleteAccountTitle => 'Padam akaun anda?';

  @override
  String get deleteAccountBody =>
      'Ini memadamkan akaun anda dan sandaran perbelanjaan di dalamnya secara '
      'kekal. Ia tidak boleh dibuat asal. Perbelanjaan pada telefon ini kekal '
      'di sini, dan anda boleh terus menggunakan aplikasi tanpa akaun.';

  @override
  String get deletingAccount => 'Memadam akaun anda…';

  @override
  String get accountDeleted => 'Akaun anda telah dipadam';

  @override
  String get home => 'Utama';

  @override
  String get analyses => 'Analisis';

  @override
  String get vsLastMonth => 'Berbanding bulan lepas';

  @override
  String get noComparison => 'Tiada data bulan lepas';

  @override
  String get dailySpending => 'Perbelanjaan harian';

  @override
  String get dailyAverage => 'Purata sehari';

  @override
  String get topDay => 'Hari tertinggi';

  @override
  String get byCategory => 'Perbelanjaan ikut kategori';

  @override
  String get noSpendingThisMonth => 'Belum ada perbelanjaan bulan ini.';

  @override
  String get monthlyTrend => '6 bulan lepas';

  @override
  String lastMonthTotal(String amount) => 'Bulan lepas: $amount';

  @override
  String get budgets => 'Bajet';

  @override
  String get monthlyBudget => 'Bajet bulanan';

  @override
  String get setMonthlyBudget => 'Tetapkan bajet bulanan';

  @override
  String get setBudgetHint =>
      'Lihat baki anda dan dapatkan amaran sebelum berbelanja berlebihan.';

  @override
  String get setBudget => 'Tetapkan';

  @override
  String get editBudget => 'Edit bajet';

  @override
  String get removeBudget => 'Buang';

  @override
  String get save => 'Simpan';

  @override
  String amountLeft(String amount) => 'Baki $amount';

  @override
  String amountOver(String amount) => '$amount melebihi bajet';

  @override
  String spentOfLimit(String spent, String limit) =>
      '$spent daripada $limit dibelanjakan';

  @override
  String amountSpent(String amount) => '$amount dibelanjakan';

  @override
  String budgetUsed(String percent) => '$percent bajet digunakan';

  @override
  String get categoryBudgets => 'Bajet kategori';

  @override
  String get categoryBudgetsHint =>
      'Hadkan perbelanjaan anda untuk satu kategori.';

  @override
  String categoryBudgetTitle(String name) => 'Bajet $name';

  @override
  String get setLimit => 'Tetapkan had';

  @override
  String get closeToLimit => 'Hampir mencapai had';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Bajet berulang setiap bulan. Anda akan dimaklumkan apabila '
      'perbelanjaan melepasi $nearing, dan sekali lagi pada $reached.';

  @override
  String get budgetAlertTitle => 'Amaran bajet';

  @override
  String get ok => 'OK';

  @override
  String get view => 'Lihat';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Anda telah menggunakan $percent bajet bulanan';

  @override
  String get monthlyBudgetUsedUp =>
      'Anda telah menggunakan semua bajet bulanan';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Anda melebihi bajet bulanan sebanyak $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Anda telah menggunakan $percent bajet $name';

  @override
  String categoryBudgetUsedUp(String name) =>
      'Anda telah menggunakan semua bajet $name';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Anda melebihi bajet $name sebanyak $amount';

  @override
  String get dataManagement => 'Pengurusan data';

  @override
  String get dataManagementHint =>
      'Fail yang anda simpan sendiri. Berfungsi di luar talian dan tanpa '
      'akaun.';

  @override
  String get backUpToFile => 'Sandarkan data saya';

  @override
  String get backUpToFileHint =>
      'Fail sandaran lengkap yang boleh diimport kemudian';

  @override
  String get exportCsv => 'Eksport sebagai CSV';

  @override
  String get exportCsvHint => 'Untuk Excel atau Google Sheets';

  @override
  String get exportPdf => 'Eksport sebagai PDF';

  @override
  String get exportPdfHint => 'Laporan untuk dibaca, dicetak atau dikongsi';

  @override
  String get importData => 'Import data';

  @override
  String get importDataHint => 'Pulihkan daripada fail sandaran';

  @override
  String get preparingFile => 'Menyediakan fail anda…';

  @override
  String get importingData => 'Mengimport…';

  @override
  String get fileSaved => 'Fail disimpan';

  @override
  String get importDone => 'Import selesai';

  @override
  String get importNothingNew =>
      'Telefon ini sudah mempunyai semua kandungan sandaran';

  @override
  String get fileReady => 'Fail anda sudah sedia';

  @override
  String get shareFile => 'Kongsi';

  @override
  String get shareFileHint => 'WhatsApp, e-mel, Google Drive dan lain-lain';

  @override
  String get saveToPhone => 'Simpan ke telefon ini';

  @override
  String get saveToPhoneHint => 'Pilih tempat menyimpannya';

  @override
  String get importTitle => 'Import sandaran ini?';

  @override
  String get importMergeHint =>
      'Gabung mengekalkan semua yang ada di telefon ini dan menambah yang '
      'tiada. Jika sesuatu rekod berbeza, perubahan terbaharu diguna pakai.';

  @override
  String get merge => 'Gabung';

  @override
  String get replaceEverything => 'Ganti semua';

  @override
  String get replaceTitle => 'Ganti semua di telefon ini?';

  @override
  String get replaceBody =>
      'Semua yang ada di telefon ini tetapi tiada dalam sandaran akan '
      'dipadam, dan versi sandaran bagi setiap rekod akan digunakan. Ini '
      'tidak boleh dibuat asal.';

  @override
  String get replace => 'Ganti';

  @override
  String get colDate => 'Tarikh';

  @override
  String get colMonth => 'Bulan';

  @override
  String get colAmount => 'Amaun';

  @override
  String get colNote => 'Nota';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Transaksi';

  @override
  String get colTotal => 'Jumlah';

  @override
  String get colShare => 'Bahagian';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get reportTitle => 'Bajet Saya: laporan perbelanjaan';

  @override
  String get reportPeriod => 'Tempoh';

  @override
  String get reportTotal => 'Jumlah dibelanjakan';

  @override
  String get reportMonthlyAverage => 'Purata sebulan';

  @override
  String get reportByMonth => 'Perbelanjaan ikut bulan';

  @override
  String get reportAllExpenses => 'Semua perbelanjaan';

  @override
  String get reportEmpty => 'Belum ada perbelanjaan direkodkan.';

  @override
  String get reportPageTemplate => 'Halaman {page} daripada {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} dan ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} dan '
              '${personCount(people)}';
    return date == null
        ? 'Sandaran ini mengandungi $contents.'
        : 'Sandaran bertarikh $date: $contents.';
  }

  @override
  String categoryCount(int count) => '$count kategori';

  @override
  String reportGenerated(String when) => 'Dijana $when';

  @override
  String get showPassword => 'Tunjukkan kata laluan';

  @override
  String get hidePassword => 'Sembunyikan kata laluan';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Makanan',
    'cat_transport' => 'Pengangkutan',
    'cat_bills' => 'Bil',
    'cat_shopping' => 'Membeli-belah',
    'cat_health' => 'Kesihatan & Kecergasan',
    'cat_entertainment' => 'Hiburan',
    'cat_work' => 'Kerja',
    'cat_other' => 'Lain-lain',
    'cat_salary' => 'Gaji',
    'cat_freelance' => 'Bebas',
    'cat_investments' => 'Pelaburan',
    'cat_gifts' => 'Hadiah',
    'cat_income_other' => 'Pendapatan lain',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database =>
      'Tidak dapat menyimpan pada peranti ini. Cuba lagi.',
    FailureCode.notFound => 'Item itu sudah tiada.',
    FailureCode.unknown => 'Sesuatu tidak kena.',
    FailureCode.amountRequired => 'Masukkan amaun melebihi sifar.',
    FailureCode.amountTooLarge => 'Amaun itu terlalu besar.',
    FailureCode.amountInvalid => 'Masukkan amaun yang sah.',
    FailureCode.categoryRequired => 'Pilih kategori.',
    FailureCode.categoryNameRequired => 'Beri nama kepada kategori.',
    FailureCode.categoryNameTooLong => 'Nama mesti kurang daripada 30 aksara.',
    FailureCode.categoryProtected => 'Kategori ini tidak boleh dipadam.',
    FailureCode.currencySymbolInvalid => 'Gunakan 1 hingga 4 aksara.',
    FailureCode.network =>
      'Tidak dapat bersambung. Semak internet anda dan cuba lagi.',
    FailureCode.emailInvalid => 'Masukkan alamat e-mel yang sah.',
    FailureCode.passwordTooShort =>
      'Kata laluan mesti sekurang-kurangnya 6 aksara.',
    FailureCode.invalidCredentials => 'E-mel atau kata laluan salah.',
    FailureCode.emailTaken => 'Akaun dengan e-mel ini sudah wujud.',
    FailureCode.emailNotConfirmed =>
      'Sahkan e-mel anda dahulu dengan kod yang kami hantar.',
    FailureCode.codeInvalid => 'Kod itu salah atau sudah tamat tempoh.',
    FailureCode.signInRequired => 'Log masuk semula, kemudian cuba lagi.',
    FailureCode.syncOtherAccount =>
      'Data telefon ini dipautkan kepada akaun lain.',
    FailureCode.syncFailed =>
      'Tidak dapat menyegerak dengan akaun anda. Cuba lagi.',
    FailureCode.accountDeletionFailed =>
      'Tidak dapat memadam akaun anda. Cuba lagi.',
    FailureCode.backupNotRecognized => 'Fail ini bukan sandaran Bajet Saya.',
    FailureCode.backupTooNew =>
      'Sandaran ini daripada versi Bajet Saya yang lebih baharu. Kemas kini '
          'aplikasi, kemudian cuba lagi.',
    FailureCode.backupDamaged =>
      'Fail sandaran ini rosak, jadi tiada apa yang diimport.',
    FailureCode.fileUnavailable =>
      'Tidak dapat membuka fail itu. Cuba pilih semula.',
    FailureCode.storageFull => 'Ruang kosong di telefon ini tidak mencukupi.',
    FailureCode.exportFailed => 'Tidak dapat mencipta fail. Cuba lagi.',
    FailureCode.shareUnavailable => 'Tidak dapat membuka menu kongsi.',
    FailureCode.saveFailed => 'Tidak dapat menyimpan fail. Cuba lagi.',
    FailureCode.tooManyAttempts =>
      'Terlalu banyak cubaan. Tunggu sebentar dan cuba lagi.',
    FailureCode.titleRequired => 'Beri nama.',
    FailureCode.titleTooLong => 'Nama mesti kurang daripada 40 aksara.',
    FailureCode.dueDayInvalid => 'Pilih bila tarikh akhirnya.',
    FailureCode.alreadyPaid => 'Bayaran itu sudah direkodkan.',
    FailureCode.personRequired => 'Pilih seseorang.',
    FailureCode.personNameRequired => 'Masukkan nama.',
    FailureCode.personNameTooLong => 'Nama mesti kurang daripada 40 aksara.',
    FailureCode.phoneInvalid => 'Masukkan nombor telefon yang sah.',
    FailureCode.transactionSettled =>
      'Transaksi yang telah dijelaskan tidak boleh diubah.',
    FailureCode.nothingToSettle => 'Tiada apa untuk dijelaskan.',
    FailureCode.settlementAlreadyLogged =>
      'Penjelasan ini sudah ada dalam bajet anda.',
  };

  @override
  String get expenseDeleted => 'Perbelanjaan dipadam';

  @override
  String get expenseRestored => 'Perbelanjaan dipulihkan';

  @override
  String categoryAdded(String name) => '$name ditambah';

  @override
  String get categoryUpdated => 'Kategori dikemas kini';

  @override
  String categoryDeleted(String name) => '$name dipadam';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name dipadam — ${expenseCount(count)} dipindahkan ke Lain-lain';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name dipadam — ${transactionCount(count)} dipindahkan ke Pendapatan '
      'lain';

  @override
  String get expense => 'Perbelanjaan';

  @override
  String get income => 'Pendapatan';

  @override
  String get search => 'Cari';

  @override
  String get searchHint => 'Cari nota atau amaun';

  @override
  String get searchPrompt =>
      'Cari mana-mana transaksi melalui nota atau amaunnya, atau tapis mengikut jenis, kategori dan tarikh.';

  @override
  String get noSearchResults => 'Tiada transaksi yang sepadan';

  @override
  String get allTypes => 'Semua';

  @override
  String get anyCategory => 'Semua kategori';

  @override
  String get anyDate => 'Semua tarikh';

  @override
  String get clearFilters => 'Kosongkan penapis';

  @override
  String get transactionType => 'Perbelanjaan atau pendapatan';

  @override
  String get quickIncome => 'Pendapatan pantas';

  @override
  String get newIncome => 'Pendapatan baharu';

  @override
  String get editIncome => 'Edit pendapatan';

  @override
  String get addIncome => 'Tambah pendapatan';

  @override
  String get incomeNoteHint => 'Dari mana datangnya?';

  @override
  String get totalIncome => 'Jumlah pendapatan';

  @override
  String get totalExpenses => 'Jumlah perbelanjaan';

  @override
  String get netBalance => 'Baki bersih';

  @override
  String get savingsRate => 'Kadar simpanan';

  @override
  String get savingsRateNoIncome =>
      'Tambah pendapatan untuk melihat kadar simpanan anda';

  @override
  String get expenseCategories => 'Kategori perbelanjaan';

  @override
  String get incomeCategories => 'Kategori pendapatan';

  @override
  String get deleteIncomeCategoryBody =>
      'Pendapatan dalam kategori ini akan dipindahkan ke Pendapatan lain. '
      'Tiada apa yang dipadam.';

  @override
  String get incomeDeleted => 'Pendapatan dipadam';

  @override
  String get incomeRestored => 'Pendapatan dipulihkan';

  @override
  String get colType => 'Jenis';

  @override
  String transactionCount(int count) => '$count transaksi';

  @override
  String get recurringPayments => 'Bayaran berulang';

  @override
  String get newRecurring => 'Bayaran berulang baharu';

  @override
  String get editRecurring => 'Edit bayaran berulang';

  @override
  String get addRecurring => 'Tambah bayaran';

  @override
  String get recurringTitle => 'Nama';

  @override
  String get recurringTitleHint => 'Sewa, Netflix, gim…';

  @override
  String get amount => 'Amaun';

  @override
  String get repeats => 'Berulang';

  @override
  String get weekly => 'Mingguan';

  @override
  String get monthly => 'Bulanan';

  @override
  String get yearly => 'Tahunan';

  @override
  String get dueOn => 'Tarikh akhir';

  @override
  String get dueDayOfMonth => 'Hari dalam bulan';

  @override
  String get dueMonthLabel => 'Bulan';

  @override
  String get dueDayLabel => 'Hari';

  @override
  String get shortMonthHint =>
      'Dalam bulan yang lebih pendek, ia jatuh pada hari terakhir.';

  @override
  String get whenDue => 'Apabila tiba tarikh';

  @override
  String get autoDeduct => 'Tolak automatik';

  @override
  String get remindMe => 'Ingatkan saya';

  @override
  String get autoDeductHint =>
      'Direkod sebagai perbelanjaan secara automatik pada tarikh akhir.';

  @override
  String get remindMeHint =>
      'Anda akan diminta mengesahkan setiap bayaran sebelum direkodkan.';

  @override
  String get statusPaid => 'Dibayar';

  @override
  String get statusUpcoming => 'Akan datang';

  @override
  String get statusOverdue => 'Tertunggak';

  @override
  String get markAsPaid => 'Dibayar';

  @override
  String get dueToday => 'Perlu dibayar hari ini';

  @override
  String dueOnDate(String date) => 'Perlu dibayar $date';

  @override
  String nextDueOn(String date) => 'Seterusnya $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Tarikh akhir $date'
      : '${paymentCount(count)} tertunggak sejak $date';

  @override
  String everyWeekday(String weekday) => 'Setiap $weekday';

  @override
  String monthlyOnDay(String day) => 'Setiap bulan pada hari $day';

  @override
  String yearlyOn(String date) => 'Setiap tahun pada $date';

  @override
  String get monthlyAverage => 'Sebulan';

  @override
  String get monthlyAverageHint => 'Semua bayaran berulang anda, secara purata';

  @override
  String get noRecurringYet => 'Belum ada bayaran berulang';

  @override
  String get noRecurringHint =>
      'Tambah sewa, bil dan langganan sekali sahaja. Setiap bulan anda akan '
      'nampak apa yang sudah dibayar dan apa yang belum.';

  @override
  String get paymentsToConfirm => 'Bayaran untuk disahkan';

  @override
  String get seeAll => 'Lihat semua';

  @override
  String get deleteRecurringBody =>
      'Ia berhenti berulang. Bayaran yang sudah direkodkan kekal dalam '
      'transaksi anda.';

  @override
  String recurringPaid(String name) => '$name ditanda sebagai dibayar';

  @override
  String recurringReceived(String name) => '$name ditanda sebagai diterima';

  @override
  String get statusReceived => 'Diterima';

  @override
  String get markAsReceived => 'Diterima';

  @override
  String get autoAdd => 'Tambah automatik';

  @override
  String get autoAddHint =>
      'Direkod sebagai pendapatan secara automatik pada tarikh akhir.';

  @override
  String get monthlyIncomeAverage => 'Pendapatan sebulan';

  @override
  String get recurringPaymentUndone => 'Bayaran dibuang';

  @override
  String recurringAutoLogged(int count) =>
      '$count bayaran berulang direkodkan secara automatik';

  @override
  String paymentCount(int count) => '$count bayaran';

  @override
  String get colPaidThrough => 'Dibayar hingga';

  // People & debts

  @override
  String get people => 'Orang';

  @override
  String get peopleAndDebts => 'Orang & hutang';

  @override
  String get person => 'Orang';

  @override
  String get personName => 'Nama';

  @override
  String get phone => 'Telefon';

  @override
  String get phoneOptional => 'Telefon (pilihan)';

  @override
  String get balance => 'Baki';

  @override
  String get colStatus => 'Status';

  @override
  String get owesYou => 'Berhutang dengan anda';

  @override
  String get youOwe => 'Anda berhutang';

  @override
  String get owedToYou => 'Hutang kepada anda';

  @override
  String get settledUp => 'Selesai';

  @override
  String get iPaidForThem => 'Saya yang bayar';

  @override
  String get theyPaidForMe => 'Dia yang bayar';

  @override
  String get theyPaidYou => 'Dia bayar anda';

  @override
  String get youPaidThem => 'Anda bayar dia';

  @override
  String get openStatus => 'Terbuka';

  @override
  String get settledStatus => 'Selesai';

  @override
  String get settledOn => 'Selesai pada';

  @override
  String get createdOn => 'Dicipta';

  @override
  String get lastEdited => 'Terakhir diedit';

  @override
  String get colEdits => 'Suntingan';

  @override
  String get activeTransactions => 'Transaksi aktif';

  @override
  String get settledHistory => 'Sejarah penjelasan';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterOwedToMe => 'Hutang saya';

  @override
  String get filterIOwe => 'Saya berhutang';

  @override
  String get filterSettled => 'Selesai';

  @override
  String get addPerson => 'Tambah orang';

  @override
  String get addPersonHint => 'Seseorang yang berkongsi kos dengan anda';

  @override
  String get newPerson => 'Orang baharu';

  @override
  String get editPerson => 'Edit orang';

  @override
  String get deletePerson => 'Padam orang';

  @override
  String get quickTransaction => 'Transaksi pantas';

  @override
  String get quickTransactionHint =>
      'Rekod siapa yang bayar, dengan orang yang sudah anda tambah';

  @override
  String get noPeopleYet => 'Belum ada orang';

  @override
  String get noPeopleHint =>
      'Tambah orang yang berkongsi kos dengan anda untuk menjejak siapa '
      'berhutang dengan siapa.';

  @override
  String get nobodyHere => 'Tiada sesiapa yang sepadan dengan penapis ini.';

  @override
  String get addPersonFirst => 'Tambah seseorang dahulu.';

  @override
  String get newTransaction => 'Transaksi baharu';

  @override
  String get editTransaction => 'Edit transaksi';

  @override
  String get transactionDetails => 'Butiran transaksi';

  @override
  String get debtNoteHint => 'Untuk apa?';

  @override
  String get changeHistory => 'Sejarah perubahan';

  @override
  String get edited => 'Diedit';

  @override
  String get settleUp => 'Jelaskan';

  @override
  String get settle => 'Jelaskan';

  @override
  String get noDebtsYet => 'Belum ada rekod';

  @override
  String get noDebtsHint =>
      'Tambah apa yang anda bayar untuknya, atau apa yang dia bayar untuk '
      'anda.';

  @override
  String get settleEven =>
      'Transaksi ini saling membatalkan, jadi tiada wang perlu bertukar '
      'tangan.';

  @override
  String get logSettlementTitle =>
      'Rekod penjelasan ini dalam bajet bulanan anda?';

  @override
  String get loggedInBudget => 'Dalam bajet anda';

  @override
  String get deleteTransactionTitle => 'Padam transaksi ini?';

  @override
  String get deleteTransactionBody =>
      'Ia akan dibuang daripada baki dengan orang ini.';

  @override
  String get deletePersonBody =>
      'Transaksi dan sejarah penjelasannya turut dipadam. Apa yang anda '
      'rekodkan dalam bajet kekal.';

  @override
  String get settledLocked => 'Sudah selesai, jadi tidak boleh diubah lagi.';

  @override
  String get personUpdated => 'Orang dikemas kini';

  @override
  String get debtDeleted => 'Transaksi dipadam';

  @override
  String get settledUpNotice => 'Semua sudah selesai';

  @override
  String get settlementLogged => 'Ditambah ke bajet anda';

  @override
  String personOwesYou(String name) => '$name berhutang dengan anda';

  @override
  String youOwePerson(String name) => 'Anda berhutang dengan $name';

  @override
  String settledWith(String name) => 'Semua selesai dengan $name';

  @override
  String settleUpFor(String amount) => 'Jelaskan $amount';

  @override
  String settleTitle(String name) => 'Jelaskan dengan $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name membayar anda $amount untuk menyelesaikan semuanya.';

  @override
  String settleYouPay(String name, String amount) =>
      'Anda membayar $name $amount untuk menyelesaikan semuanya.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} akan dipindahkan ke sejarah penjelasan.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount akan ditambah sebagai pendapatan dalam Pendapatan lain. Anda '
      'boleh memindahkannya ke kategori lain kemudian.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount akan ditambah sebagai perbelanjaan dalam Lain-lain. Anda '
      'boleh memindahkannya ke kategori lain kemudian.';

  @override
  String settlementNote(String name) => 'Penjelasan dengan $name';

  @override
  String settledGroupTitle(String date) => 'Selesai $date';

  @override
  String deletePersonTitle(String name) => 'Padam $name?';

  @override
  String editedOn(String date) => 'Diedit $date';

  @override
  String wasValues(String values) => 'Sebelum ini: $values';

  @override
  String personCount(int count) => '$count orang';

  @override
  String get askTitle => 'Tanya tentang perbelanjaan';

  @override
  String get askHint => 'Ketik soalan untuk melihat jawapan.';

  @override
  String get askCompareMonths => 'Banding bulan';

  @override
  String get askTopCategory => 'Kategori utama';

  @override
  String get askVsLastMonth => 'vs bulan lepas';

  @override
  String get askBiggestExpense => 'Perbelanjaan terbesar';

  @override
  String get askTopDay => 'Hari termahal';

  @override
  String get askWeekday => 'Hari paling sibuk';

  @override
  String get askMonthEnd => 'Anggaran hujung bulan';

  @override
  String get askSaved => 'Adakah saya jimat?';

  @override
  String get askBudgetLeft => 'Baki bajet';

  @override
  String get askHighestLowest => 'Bulan tertinggi & terendah';

  @override
  String get askCount => 'Berapa perbelanjaan';

  @override
  String get askTopIncome => 'Pendapatan utama';

  @override
  String get compareWith => 'Banding dengan';

  @override
  String get otherCategories => 'Lain-lain';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'Paling banyak untuk $category: $amount ($percent daripada bulan ini).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Perbelanjaan $month lebih $amount berbanding $other (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => 'Perbelanjaan $month kurang $amount berbanding $other (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      'Perbelanjaan $month dan $other sama.';

  @override
  String answerNothingIn(String month) => 'Tiada perbelanjaan pada $month.';

  @override
  String answerRise(String category, String amount) =>
      'Kenaikan terbesar: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Penurunan terbesar: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Perbelanjaan terbesar: $amount dalam $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Hari termahal: $date, sebanyak $amount.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Hari paling sibuk dalam minggu: $weekday ($amount bulan ini).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'Pada kadar ini (kira-kira $average sehari) anda akan berbelanja kira-kira $amount menjelang hujung bulan.';

  @override
  String answerMonthTotal(String amount) =>
      'Bulan ini sudah tamat: jumlah perbelanjaan $amount.';

  @override
  String answerSaved(String amount, String income) =>
      'Anda menyimpan $amount daripada pendapatan $income.';

  @override
  String answerOverspent(String amount) =>
      'Anda berbelanja $amount lebih daripada pendapatan.';

  @override
  String get answerNoIncome => 'Tiada pendapatan direkodkan bulan ini.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'Baki bajet bulanan $amount ($percent digunakan).';

  @override
  String answerBudgetOver(String amount) =>
      'Anda melebihi bajet bulanan sebanyak $amount.';

  @override
  String get answerNoBudget => 'Anda belum menetapkan bajet bulanan.';

  @override
  String answerOverLimit(String names) => 'Melebihi had: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'Bulan tertinggi: $high ($highAmount). Terendah: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'Anda merekod ${expenseCount(count)}, purata $average.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'Kebanyakan pendapatan daripada $category: $amount ($percent).';
}
