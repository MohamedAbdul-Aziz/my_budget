import '../../error/failures.dart';
import '../app_strings.dart';

/// Indonesian nouns do not change after a number, so counts need no plural
/// forms.
class AppStringsId extends AppStrings {
  const AppStringsId();

  @override
  String get localeName => 'id';

  @override
  String get appTitle => 'Anggaranku';

  @override
  String get add => 'Tambah';

  @override
  String get undo => 'Urungkan';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get nothingRecordedYet => 'Belum ada catatan';

  @override
  String get emptyMonthHint =>
      'Ketuk Tambah untuk mencatat pengeluaran atau pemasukan pertama bulan '
      'ini.';

  @override
  String get yourMonths => 'Bulan-bulanmu';

  @override
  String spentIn(String month) => 'Pengeluaran $month';

  @override
  String expenseCount(int count) => '$count pengeluaran';

  @override
  String get quickExpense => 'Pengeluaran cepat';

  @override
  String get expenseSaved => 'Pengeluaran disimpan';

  @override
  String get newExpense => 'Pengeluaran baru';

  @override
  String get editExpense => 'Ubah pengeluaran';

  @override
  String get when => 'Kapan';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get pickADate => 'Pilih tanggal';

  @override
  String get category => 'Kategori';

  @override
  String get noteOptional => 'Catatan (opsional)';

  @override
  String get noteHint => 'Untuk apa?';

  @override
  String get addExpense => 'Tambah pengeluaran';

  @override
  String get saveChanges => 'Simpan perubahan';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Kategori';

  @override
  String get newCategory => 'Kategori baru';

  @override
  String get editCategory => 'Ubah kategori';

  @override
  String get addCategory => 'Tambah kategori';

  @override
  String get categoryName => 'Nama';

  @override
  String get color => 'Warna';

  @override
  String get icon => 'Ikon';

  @override
  String get builtIn => 'Bawaan';

  @override
  String get custom => 'Buatan sendiri';

  @override
  String get edit => 'Ubah';

  @override
  String get delete => 'Hapus';

  @override
  String get cancel => 'Batal';

  @override
  String deleteCategoryTitle(String name) => 'Hapus $name?';

  @override
  String get deleteCategoryBody =>
      'Pengeluaran di kategori ini akan dipindah ke Lainnya. Tidak ada yang '
      'dihapus.';

  @override
  String get settings => 'Pengaturan';

  @override
  String get appearance => 'Tampilan';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get currency => 'Mata uang';

  @override
  String get currencySymbol => 'Simbol';

  @override
  String get currencySymbolHint => 'Ditampilkan di samping setiap jumlah';

  @override
  String get storedOnThisDevice =>
      'Pengeluaranmu tersimpan di perangkat ini. Masuk untuk mencadangkannya.';

  @override
  String get account => 'Akun';

  @override
  String get accountOptional =>
      'Akun bersifat opsional. Aplikasi berfungsi penuh tanpa akun.';

  @override
  String get signIn => 'Masuk';

  @override
  String get signOut => 'Keluar';

  @override
  String get signedIn => 'Sudah masuk';

  @override
  String get createAccount => 'Buat akun';

  @override
  String get noAccountYet => 'Belum punya akun? Buat sekarang';

  @override
  String get haveAnAccount => 'Sudah punya akun? Masuk';

  @override
  String get email => 'Email';

  @override
  String get password => 'Kata sandi';

  @override
  String get passwordRules => 'Minimal 6 karakter';

  @override
  String get confirmEmail => 'Konfirmasi emailmu';

  @override
  String codeSentTo(String email) =>
      'Kami mengirim kode ke $email. Masukkan di bawah untuk menyelesaikan '
      'pembuatan akunmu.';

  @override
  String get confirmationCode => 'Kode';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get resendCode => 'Kirim kode baru';

  @override
  String get codeResent => 'Kode baru sedang dikirim';

  @override
  String get useDifferentEmail => 'Pakai email lain';

  @override
  String get backupHint =>
      'Cadangkan untuk menyimpan salinan pengeluaranmu di akunmu. Pulihkan '
      'membawa salinan itu ke ponsel ini tanpa menghapus apa pun yang sudah '
      'ada.';

  @override
  String get backUpNow => 'Cadangkan sekarang';

  @override
  String get restoreData => 'Pulihkan';

  @override
  String get backingUp => 'Mencadangkan…';

  @override
  String get restoring => 'Memulihkan…';

  @override
  String get backupDone => 'Pencadangan selesai';

  @override
  String get restoreDone => 'Pemulihan selesai';

  @override
  String get neverSynced => 'Belum dicadangkan';

  @override
  String lastSynced(String when) => 'Terakhir disinkronkan $when';

  @override
  String get deleteAccount => 'Hapus akun';

  @override
  String get deleteAccountTitle => 'Hapus akunmu?';

  @override
  String get deleteAccountBody =>
      'Ini menghapus akunmu dan cadangan pengeluaran di dalamnya secara '
      'permanen. Tidak bisa dibatalkan. Pengeluaran di ponsel ini tetap ada, '
      'dan kamu tetap bisa memakai aplikasi tanpa akun.';

  @override
  String get deletingAccount => 'Menghapus akunmu…';

  @override
  String get accountDeleted => 'Akunmu sudah dihapus';

  @override
  String get home => 'Beranda';

  @override
  String get analyses => 'Analisis';

  @override
  String get vsLastMonth => 'Dibanding bulan lalu';

  @override
  String get noComparison => 'Tidak ada data bulan lalu';

  @override
  String get dailySpending => 'Pengeluaran harian';

  @override
  String get dailyAverage => 'Rata-rata per hari';

  @override
  String get topDay => 'Hari tertinggi';

  @override
  String get byCategory => 'Pengeluaran per kategori';

  @override
  String get noSpendingThisMonth => 'Belum ada pengeluaran bulan ini.';

  @override
  String get monthlyTrend => '6 bulan terakhir';

  @override
  String lastMonthTotal(String amount) => 'Bulan lalu: $amount';

  @override
  String get budgets => 'Anggaran';

  @override
  String get monthlyBudget => 'Anggaran bulanan';

  @override
  String get setMonthlyBudget => 'Atur anggaran bulanan';

  @override
  String get setBudgetHint =>
      'Lihat sisanya dan dapatkan peringatan sebelum terlalu boros.';

  @override
  String get setBudget => 'Atur';

  @override
  String get editBudget => 'Ubah anggaran';

  @override
  String get removeBudget => 'Hapus';

  @override
  String get save => 'Simpan';

  @override
  String amountLeft(String amount) => 'Sisa $amount';

  @override
  String amountOver(String amount) => 'Lewat $amount dari anggaran';

  @override
  String spentOfLimit(String spent, String limit) =>
      '$spent dari $limit terpakai';

  @override
  String amountSpent(String amount) => '$amount terpakai';

  @override
  String budgetUsed(String percent) => '$percent anggaran terpakai';

  @override
  String get categoryBudgets => 'Anggaran kategori';

  @override
  String get categoryBudgetsHint => 'Batasi pengeluaran untuk satu kategori.';

  @override
  String categoryBudgetTitle(String name) => 'Anggaran $name';

  @override
  String get setLimit => 'Atur batas';

  @override
  String get closeToLimit => 'Mendekati batas';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Anggaran berulang setiap bulan. Kamu akan diberi tahu saat '
      'pengeluaran melewati $nearing, dan lagi di $reached.';

  @override
  String get budgetAlertTitle => 'Peringatan anggaran';

  @override
  String get ok => 'OK';

  @override
  String get view => 'Lihat';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Kamu sudah memakai $percent anggaran bulananmu';

  @override
  String get monthlyBudgetUsedUp => 'Anggaran bulananmu sudah habis terpakai';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Kamu melewati anggaran bulanan sebesar $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Kamu sudah memakai $percent anggaran $name';

  @override
  String categoryBudgetUsedUp(String name) =>
      'Anggaran $name sudah habis terpakai';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Kamu melewati anggaran $name sebesar $amount';

  @override
  String get dataManagement => 'Kelola data';

  @override
  String get dataManagementHint =>
      'File yang kamu simpan sendiri. Bisa dipakai offline dan tanpa akun.';

  @override
  String get backUpToFile => 'Cadangkan dataku';

  @override
  String get backUpToFileHint =>
      'File cadangan lengkap yang bisa diimpor nanti';

  @override
  String get exportCsv => 'Ekspor ke CSV';

  @override
  String get exportCsvHint => 'Untuk Excel atau Google Sheets';

  @override
  String get exportPdf => 'Ekspor ke PDF';

  @override
  String get exportPdfHint => 'Laporan untuk dibaca, dicetak, atau dibagikan';

  @override
  String get importData => 'Impor data';

  @override
  String get importDataHint => 'Pulihkan dari file cadangan';

  @override
  String get preparingFile => 'Menyiapkan file…';

  @override
  String get importingData => 'Mengimpor…';

  @override
  String get fileSaved => 'File disimpan';

  @override
  String get importDone => 'Impor selesai';

  @override
  String get importNothingNew => 'Ponsel ini sudah punya semua isi cadangan';

  @override
  String get fileReady => 'File siap';

  @override
  String get shareFile => 'Bagikan';

  @override
  String get shareFileHint => 'WhatsApp, email, Google Drive, dan lainnya';

  @override
  String get saveToPhone => 'Simpan di ponsel ini';

  @override
  String get saveToPhoneHint => 'Pilih tempat menyimpannya';

  @override
  String get importTitle => 'Impor cadangan ini?';

  @override
  String get importMergeHint =>
      'Gabungkan menyimpan semua yang ada di ponsel ini dan menambahkan yang '
      'belum ada. Jika ada catatan yang berbeda, perubahan terbaru yang '
      'dipakai.';

  @override
  String get merge => 'Gabungkan';

  @override
  String get replaceEverything => 'Ganti semua';

  @override
  String get replaceTitle => 'Ganti semua di ponsel ini?';

  @override
  String get replaceBody =>
      'Semua yang ada di ponsel ini tapi tidak ada di cadangan akan dihapus, '
      'dan versi cadangan dari setiap catatan akan dipakai. Tidak bisa '
      'dibatalkan.';

  @override
  String get replace => 'Ganti';

  @override
  String get colDate => 'Tanggal';

  @override
  String get colMonth => 'Bulan';

  @override
  String get colAmount => 'Jumlah';

  @override
  String get colNote => 'Catatan';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Transaksi';

  @override
  String get colTotal => 'Total';

  @override
  String get colShare => 'Porsi';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get reportTitle => 'Anggaranku: laporan pengeluaran';

  @override
  String get reportPeriod => 'Periode';

  @override
  String get reportTotal => 'Total pengeluaran';

  @override
  String get reportMonthlyAverage => 'Rata-rata per bulan';

  @override
  String get reportByMonth => 'Pengeluaran per bulan';

  @override
  String get reportAllExpenses => 'Semua pengeluaran';

  @override
  String get reportEmpty => 'Belum ada pengeluaran tercatat.';

  @override
  String get reportPageTemplate => 'Halaman {page} dari {pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} dan ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)}, dan '
              '${personCount(people)}';
    return date == null
        ? 'Cadangan ini berisi $contents.'
        : 'Cadangan tanggal $date: $contents.';
  }

  @override
  String categoryCount(int count) => '$count kategori';

  @override
  String reportGenerated(String when) => 'Dibuat $when';

  @override
  String get showPassword => 'Tampilkan kata sandi';

  @override
  String get hidePassword => 'Sembunyikan kata sandi';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Makanan',
    'cat_transport' => 'Transportasi',
    'cat_bills' => 'Tagihan',
    'cat_shopping' => 'Belanja',
    'cat_health' => 'Kesehatan & Kebugaran',
    'cat_entertainment' => 'Hiburan',
    'cat_work' => 'Pekerjaan',
    'cat_other' => 'Lainnya',
    'cat_salary' => 'Gaji',
    'cat_freelance' => 'Lepas',
    'cat_investments' => 'Investasi',
    'cat_gifts' => 'Hadiah',
    'cat_income_other' => 'Pemasukan lain',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => 'Gagal menyimpan di perangkat ini. Coba lagi.',
    FailureCode.notFound => 'Item itu sudah tidak ada.',
    FailureCode.unknown => 'Terjadi kesalahan.',
    FailureCode.amountRequired => 'Masukkan jumlah lebih dari nol.',
    FailureCode.amountTooLarge => 'Jumlah itu terlalu besar.',
    FailureCode.amountInvalid => 'Masukkan jumlah yang valid.',
    FailureCode.categoryRequired => 'Pilih kategori.',
    FailureCode.categoryNameRequired => 'Beri nama kategorinya.',
    FailureCode.categoryNameTooLong => 'Nama harus kurang dari 30 karakter.',
    FailureCode.categoryProtected => 'Kategori ini tidak bisa dihapus.',
    FailureCode.currencySymbolInvalid => 'Gunakan 1 sampai 4 karakter.',
    FailureCode.network =>
      'Tidak bisa terhubung. Periksa internetmu lalu coba lagi.',
    FailureCode.emailInvalid => 'Masukkan alamat email yang valid.',
    FailureCode.passwordTooShort => 'Kata sandi minimal 6 karakter.',
    FailureCode.invalidCredentials => 'Email atau kata sandi salah.',
    FailureCode.emailTaken => 'Sudah ada akun dengan email ini.',
    FailureCode.emailNotConfirmed =>
      'Konfirmasi dulu emailmu dengan kode yang kami kirim.',
    FailureCode.codeInvalid => 'Kode itu salah atau sudah kedaluwarsa.',
    FailureCode.signInRequired => 'Masuk lagi, lalu coba sekali lagi.',
    FailureCode.syncOtherAccount =>
      'Data di ponsel ini terhubung ke akun lain.',
    FailureCode.syncFailed => 'Gagal sinkron dengan akunmu. Coba lagi.',
    FailureCode.accountDeletionFailed => 'Gagal menghapus akunmu. Coba lagi.',
    FailureCode.backupNotRecognized => 'File ini bukan cadangan Anggaranku.',
    FailureCode.backupTooNew =>
      'Cadangan ini berasal dari versi Anggaranku yang lebih baru. Perbarui '
          'aplikasi, lalu coba lagi.',
    FailureCode.backupDamaged =>
      'File cadangan ini rusak, jadi tidak ada yang diimpor.',
    FailureCode.fileUnavailable => 'Gagal membuka file itu. Coba pilih lagi.',
    FailureCode.storageFull => 'Ruang kosong di ponsel ini tidak cukup.',
    FailureCode.exportFailed => 'Gagal membuat file. Coba lagi.',
    FailureCode.shareUnavailable => 'Gagal membuka menu berbagi.',
    FailureCode.saveFailed => 'Gagal menyimpan file. Coba lagi.',
    FailureCode.tooManyAttempts =>
      'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.',
    FailureCode.titleRequired => 'Beri nama.',
    FailureCode.titleTooLong => 'Nama harus kurang dari 40 karakter.',
    FailureCode.dueDayInvalid => 'Pilih kapan jatuh temponya.',
    FailureCode.alreadyPaid => 'Pembayaran itu sudah tercatat.',
    FailureCode.personRequired => 'Pilih orang.',
    FailureCode.personNameRequired => 'Masukkan nama.',
    FailureCode.personNameTooLong => 'Nama harus kurang dari 40 karakter.',
    FailureCode.phoneInvalid => 'Masukkan nomor telepon yang valid.',
    FailureCode.transactionSettled =>
      'Transaksi yang sudah lunas tidak bisa diubah.',
    FailureCode.nothingToSettle => 'Tidak ada yang perlu dilunasi.',
    FailureCode.settlementAlreadyLogged =>
      'Pelunasan ini sudah ada di anggaranmu.',
  };

  @override
  String get expenseDeleted => 'Pengeluaran dihapus';

  @override
  String get expenseRestored => 'Pengeluaran dipulihkan';

  @override
  String categoryAdded(String name) => '$name ditambahkan';

  @override
  String get categoryUpdated => 'Kategori diperbarui';

  @override
  String categoryDeleted(String name) => '$name dihapus';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name dihapus — ${expenseCount(count)} dipindah ke Lainnya';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name dihapus — ${transactionCount(count)} dipindah ke Pemasukan lain';

  @override
  String get expense => 'Pengeluaran';

  @override
  String get income => 'Pemasukan';

  @override
  String get transactionType => 'Pengeluaran atau pemasukan';

  @override
  String get quickIncome => 'Pemasukan cepat';

  @override
  String get newIncome => 'Pemasukan baru';

  @override
  String get editIncome => 'Ubah pemasukan';

  @override
  String get addIncome => 'Tambah pemasukan';

  @override
  String get incomeNoteHint => 'Dari mana asalnya?';

  @override
  String get totalIncome => 'Total pemasukan';

  @override
  String get totalExpenses => 'Total pengeluaran';

  @override
  String get netBalance => 'Saldo bersih';

  @override
  String get savingsRate => 'Rasio tabungan';

  @override
  String get savingsRateNoIncome =>
      'Tambah pemasukan untuk melihat rasio tabunganmu';

  @override
  String get expenseCategories => 'Kategori pengeluaran';

  @override
  String get incomeCategories => 'Kategori pemasukan';

  @override
  String get deleteIncomeCategoryBody =>
      'Pemasukan di kategori ini akan dipindah ke Pemasukan lain. Tidak ada '
      'yang dihapus.';

  @override
  String get incomeDeleted => 'Pemasukan dihapus';

  @override
  String get incomeRestored => 'Pemasukan dipulihkan';

  @override
  String get colType => 'Jenis';

  @override
  String transactionCount(int count) => '$count transaksi';

  @override
  String get recurringPayments => 'Pembayaran rutin';

  @override
  String get newRecurring => 'Pembayaran rutin baru';

  @override
  String get editRecurring => 'Ubah pembayaran rutin';

  @override
  String get addRecurring => 'Tambah pembayaran';

  @override
  String get recurringTitle => 'Nama';

  @override
  String get recurringTitleHint => 'Sewa, Netflix, gym…';

  @override
  String get amount => 'Jumlah';

  @override
  String get repeats => 'Berulang';

  @override
  String get weekly => 'Mingguan';

  @override
  String get monthly => 'Bulanan';

  @override
  String get yearly => 'Tahunan';

  @override
  String get dueOn => 'Jatuh tempo';

  @override
  String get dueDayOfMonth => 'Tanggal dalam bulan';

  @override
  String get dueMonthLabel => 'Bulan';

  @override
  String get dueDayLabel => 'Tanggal';

  @override
  String get shortMonthHint =>
      'Di bulan yang lebih pendek, jatuh di hari terakhir.';

  @override
  String get whenDue => 'Saat jatuh tempo';

  @override
  String get autoDeduct => 'Potong otomatis';

  @override
  String get remindMe => 'Ingatkan';

  @override
  String get autoDeductHint =>
      'Dicatat sebagai pengeluaran otomatis pada tanggal jatuh tempo.';

  @override
  String get remindMeHint =>
      'Kamu akan diminta mengonfirmasi setiap pembayaran sebelum dicatat.';

  @override
  String get statusPaid => 'Lunas';

  @override
  String get statusUpcoming => 'Akan datang';

  @override
  String get statusOverdue => 'Terlambat';

  @override
  String get markAsPaid => 'Lunas';

  @override
  String get dueToday => 'Jatuh tempo hari ini';

  @override
  String dueOnDate(String date) => 'Jatuh tempo $date';

  @override
  String nextDueOn(String date) => 'Berikutnya $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Jatuh tempo $date'
      : '${paymentCount(count)} terlambat sejak $date';

  @override
  String everyWeekday(String weekday) => 'Setiap $weekday';

  @override
  String monthlyOnDay(String day) => 'Setiap bulan tanggal $day';

  @override
  String yearlyOn(String date) => 'Setiap tahun pada $date';

  @override
  String get monthlyAverage => 'Per bulan';

  @override
  String get monthlyAverageHint => 'Semua pembayaran rutinmu, rata-rata';

  @override
  String get noRecurringYet => 'Belum ada pembayaran rutin';

  @override
  String get noRecurringHint =>
      'Tambahkan sewa, tagihan, dan langganan sekali saja. Setiap bulan kamu '
      'akan melihat mana yang sudah dibayar dan mana yang belum.';

  @override
  String get paymentsToConfirm => 'Pembayaran untuk dikonfirmasi';

  @override
  String get seeAll => 'Lihat semua';

  @override
  String get deleteRecurringBody =>
      'Tidak akan berulang lagi. Pembayaran yang sudah dicatat tetap ada di '
      'transaksimu.';

  @override
  String recurringPaid(String name) => '$name ditandai lunas';

  @override
  String get recurringPaymentUndone => 'Pembayaran dihapus';

  @override
  String recurringAutoLogged(int count) =>
      '$count pembayaran rutin dicatat otomatis';

  @override
  String paymentCount(int count) => '$count pembayaran';

  @override
  String get colPaidThrough => 'Lunas sampai';

  // People & debts

  @override
  String get people => 'Orang';

  @override
  String get peopleAndDebts => 'Orang & utang';

  @override
  String get person => 'Orang';

  @override
  String get personName => 'Nama';

  @override
  String get phone => 'Telepon';

  @override
  String get phoneOptional => 'Telepon (opsional)';

  @override
  String get balance => 'Saldo';

  @override
  String get colStatus => 'Status';

  @override
  String get owesYou => 'Berutang padamu';

  @override
  String get youOwe => 'Kamu berutang';

  @override
  String get owedToYou => 'Piutangmu';

  @override
  String get settledUp => 'Lunas';

  @override
  String get iPaidForThem => 'Aku yang bayar';

  @override
  String get theyPaidForMe => 'Dia yang bayar';

  @override
  String get theyPaidYou => 'Dia membayarmu';

  @override
  String get youPaidThem => 'Kamu membayarnya';

  @override
  String get openStatus => 'Belum lunas';

  @override
  String get settledStatus => 'Lunas';

  @override
  String get settledOn => 'Lunas pada';

  @override
  String get createdOn => 'Dibuat';

  @override
  String get lastEdited => 'Terakhir diubah';

  @override
  String get colEdits => 'Perubahan';

  @override
  String get activeTransactions => 'Transaksi aktif';

  @override
  String get settledHistory => 'Riwayat pelunasan';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterOwedToMe => 'Piutangku';

  @override
  String get filterIOwe => 'Utangku';

  @override
  String get filterSettled => 'Lunas';

  @override
  String get addPerson => 'Tambah orang';

  @override
  String get addPersonHint => 'Seseorang yang berbagi biaya denganmu';

  @override
  String get newPerson => 'Orang baru';

  @override
  String get editPerson => 'Ubah orang';

  @override
  String get deletePerson => 'Hapus orang';

  @override
  String get quickTransaction => 'Transaksi cepat';

  @override
  String get quickTransactionHint =>
      'Catat siapa yang membayar, dengan orang yang sudah kamu tambahkan';

  @override
  String get noPeopleYet => 'Belum ada orang';

  @override
  String get noPeopleHint =>
      'Tambahkan orang yang berbagi biaya denganmu untuk melacak siapa '
      'berutang pada siapa.';

  @override
  String get nobodyHere => 'Tidak ada yang cocok dengan filter ini.';

  @override
  String get addPersonFirst => 'Tambahkan orang dulu.';

  @override
  String get newTransaction => 'Transaksi baru';

  @override
  String get editTransaction => 'Ubah transaksi';

  @override
  String get transactionDetails => 'Detail transaksi';

  @override
  String get debtNoteHint => 'Untuk apa?';

  @override
  String get changeHistory => 'Riwayat perubahan';

  @override
  String get edited => 'Diubah';

  @override
  String get settleUp => 'Lunasi';

  @override
  String get settle => 'Lunasi';

  @override
  String get noDebtsYet => 'Belum ada catatan';

  @override
  String get noDebtsHint =>
      'Tambahkan yang kamu bayar untuknya, atau yang dia bayar untukmu.';

  @override
  String get settleEven =>
      'Transaksi ini saling menutup, jadi tidak ada uang yang perlu '
      'berpindah.';

  @override
  String get logSettlementTitle => 'Catat pelunasan ini di anggaran bulananmu?';

  @override
  String get loggedInBudget => 'Di anggaranmu';

  @override
  String get deleteTransactionTitle => 'Hapus transaksi ini?';

  @override
  String get deleteTransactionBody =>
      'Transaksi ini akan dihapus dari saldo dengan orang ini.';

  @override
  String get deletePersonBody =>
      'Transaksi dan riwayat pelunasannya juga dihapus. Yang sudah kamu '
      'catat di anggaran tetap ada.';

  @override
  String get settledLocked => 'Sudah lunas, jadi tidak bisa diubah lagi.';

  @override
  String get personUpdated => 'Orang diperbarui';

  @override
  String get debtDeleted => 'Transaksi dihapus';

  @override
  String get settledUpNotice => 'Semua sudah lunas';

  @override
  String get settlementLogged => 'Ditambahkan ke anggaranmu';

  @override
  String personOwesYou(String name) => '$name berutang padamu';

  @override
  String youOwePerson(String name) => 'Kamu berutang pada $name';

  @override
  String settledWith(String name) => 'Semua lunas dengan $name';

  @override
  String settleUpFor(String amount) => 'Lunasi $amount';

  @override
  String settleTitle(String name) => 'Lunasi dengan $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name membayarmu $amount untuk melunasi semuanya.';

  @override
  String settleYouPay(String name, String amount) =>
      'Kamu membayar $name $amount untuk melunasi semuanya.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} akan pindah ke riwayat pelunasan.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount akan ditambahkan sebagai pemasukan di Pemasukan lain. Kamu '
      'bisa memindahkannya ke kategori lain nanti.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount akan ditambahkan sebagai pengeluaran di Lainnya. Kamu bisa '
      'memindahkannya ke kategori lain nanti.';

  @override
  String settlementNote(String name) => 'Pelunasan dengan $name';

  @override
  String settledGroupTitle(String date) => 'Lunas $date';

  @override
  String deletePersonTitle(String name) => 'Hapus $name?';

  @override
  String editedOn(String date) => 'Diubah $date';

  @override
  String wasValues(String values) => 'Sebelumnya: $values';

  @override
  String personCount(int count) => '$count orang';
}
