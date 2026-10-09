import '../../error/failures.dart';
import '../app_strings.dart';

/// Vietnamese nouns do not change after a number, so counts need no plural
/// forms.
class AppStringsVi extends AppStrings {
  const AppStringsVi();

  @override
  String get localeName => 'vi';

  @override
  String get appTitle => 'Ngân sách của tôi';

  @override
  String get add => 'Thêm';

  @override
  String get undo => 'Hoàn tác';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get nothingRecordedYet => 'Chưa có ghi chép nào';

  @override
  String get emptyMonthHint =>
      'Nhấn Thêm để ghi khoản chi hoặc khoản thu đầu tiên của tháng này.';

  @override
  String get yourMonths => 'Các tháng của bạn';

  @override
  String spentIn(String month) => 'Đã chi trong $month';

  @override
  String expenseCount(int count) => '$count khoản chi';

  @override
  String get quickExpense => 'Chi nhanh';

  @override
  String get expenseSaved => 'Đã lưu khoản chi';

  @override
  String get newExpense => 'Khoản chi mới';

  @override
  String get editExpense => 'Sửa khoản chi';

  @override
  String get when => 'Khi nào';

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get pickADate => 'Chọn ngày';

  @override
  String get category => 'Danh mục';

  @override
  String get noteOptional => 'Ghi chú (không bắt buộc)';

  @override
  String get noteHint => 'Chi cho việc gì?';

  @override
  String get addExpense => 'Thêm khoản chi';

  @override
  String get saveChanges => 'Lưu thay đổi';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'Danh mục';

  @override
  String get newCategory => 'Danh mục mới';

  @override
  String get editCategory => 'Sửa danh mục';

  @override
  String get addCategory => 'Thêm danh mục';

  @override
  String get categoryName => 'Tên';

  @override
  String get color => 'Màu';

  @override
  String get icon => 'Biểu tượng';

  @override
  String get builtIn => 'Có sẵn';

  @override
  String get custom => 'Tự tạo';

  @override
  String get edit => 'Sửa';

  @override
  String get delete => 'Xóa';

  @override
  String get cancel => 'Hủy';

  @override
  String deleteCategoryTitle(String name) => 'Xóa $name?';

  @override
  String get deleteCategoryBody =>
      'Các khoản chi trong danh mục này sẽ được chuyển sang Khác. Không có gì '
      'bị xóa.';

  @override
  String get settings => 'Cài đặt';

  @override
  String get appearance => 'Giao diện';

  @override
  String get themeSystem => 'Hệ thống';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Hệ thống';

  @override
  String get currency => 'Tiền tệ';

  @override
  String get currencySymbol => 'Ký hiệu';

  @override
  String get currencySymbolHint => 'Hiển thị cạnh mỗi số tiền';

  @override
  String get reminders => 'Lời nhắc';

  @override
  String get dailyReminder => 'Nhắc nhở hằng ngày';

  @override
  String get dailyReminderHint => 'Nhắc ghi lại các khoản chi hôm nay';

  @override
  String get reminderTime => 'Thời gian';

  @override
  String get notificationsBlocked =>
      'Thông báo của ứng dụng này đang tắt. Hãy cho phép trong phần cài đặt của điện thoại.';

  @override
  String get reminderNotificationTitle => 'Ghi lại chi tiêu hôm nay';

  @override
  String get reminderNotificationBody =>
      'Dành một phút để thêm các khoản chi hôm nay.';

  @override
  String get security => 'Bảo mật';

  @override
  String get appLock => 'Khóa ứng dụng';

  @override
  String get appLockHint =>
      'Yêu cầu vân tay, khuôn mặt hoặc khóa màn hình khi mở ứng dụng';

  @override
  String get appLockUnavailable =>
      'Hãy đặt khóa màn hình trên điện thoại này trước';

  @override
  String get unlock => 'Mở khóa';

  @override
  String get unlockToContinue => 'Mở khóa để xem ngân sách';

  @override
  String get confirmItsYou => 'Xác nhận là bạn để thay đổi khóa ứng dụng';

  @override
  String get storedOnThisDevice =>
      'Các khoản chi được lưu trên thiết bị này. Đăng nhập để sao lưu.';

  @override
  String get account => 'Tài khoản';

  @override
  String get accountOptional =>
      'Tài khoản là tùy chọn. Ứng dụng hoạt động đầy đủ mà không cần tài '
      'khoản.';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get signedIn => 'Đã đăng nhập';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get noAccountYet => 'Chưa có tài khoản? Tạo ngay';

  @override
  String get haveAnAccount => 'Đã có tài khoản? Đăng nhập';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get passwordRules => 'Ít nhất 6 ký tự';

  @override
  String get confirmEmail => 'Xác nhận email';

  @override
  String codeSentTo(String email) =>
      'Chúng tôi đã gửi mã đến $email. Nhập mã bên dưới để hoàn tất tạo tài '
      'khoản.';

  @override
  String get confirmationCode => 'Mã';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get resendCode => 'Gửi mã mới';

  @override
  String get codeResent => 'Mã mới đang được gửi';

  @override
  String get useDifferentEmail => 'Dùng email khác';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String resetCodeSentTo(String email) =>
      'Chúng tôi đã gửi mã đến $email. Nhập mã cùng mật khẩu mới cho tài khoản.';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get saveNewPassword => 'Lưu mật khẩu mới';

  @override
  String get backToSignIn => 'Quay lại đăng nhập';

  @override
  String get backupHint =>
      'Sao lưu để giữ một bản các khoản chi trong tài khoản. Khôi phục sẽ '
      'đưa bản đó về điện thoại này mà không xóa gì đang có.';

  @override
  String get backUpNow => 'Sao lưu ngay';

  @override
  String get autoBackup => 'Tự động sao lưu';

  @override
  String get autoBackupHint =>
      'Mỗi khi bạn rời ứng dụng, các thay đổi mới được sao lưu vào tài khoản.';

  @override
  String get restoreData => 'Khôi phục';

  @override
  String get backingUp => 'Đang sao lưu…';

  @override
  String get restoring => 'Đang khôi phục…';

  @override
  String get backupDone => 'Đã sao lưu xong';

  @override
  String get restoreDone => 'Đã khôi phục xong';

  @override
  String get neverSynced => 'Chưa sao lưu';

  @override
  String lastSynced(String when) => 'Đồng bộ lần cuối: $when';

  @override
  String get deleteAccount => 'Xóa tài khoản';

  @override
  String get deleteAccountTitle => 'Xóa tài khoản của bạn?';

  @override
  String get deleteAccountBody =>
      'Thao tác này xóa vĩnh viễn tài khoản và bản sao lưu các khoản chi '
      'trong đó. Không thể hoàn tác. Các khoản chi trên điện thoại này vẫn '
      'còn, và bạn vẫn dùng được ứng dụng mà không cần tài khoản.';

  @override
  String get deletingAccount => 'Đang xóa tài khoản…';

  @override
  String get accountDeleted => 'Đã xóa tài khoản';

  @override
  String get home => 'Trang chủ';

  @override
  String get analyses => 'Phân tích';

  @override
  String get vsLastMonth => 'So với tháng trước';

  @override
  String get noComparison => 'Không có dữ liệu tháng trước';

  @override
  String get dailySpending => 'Chi tiêu hằng ngày';

  @override
  String get dailyAverage => 'Trung bình mỗi ngày';

  @override
  String get topDay => 'Ngày cao nhất';

  @override
  String get byCategory => 'Chi tiêu theo danh mục';

  @override
  String get noSpendingThisMonth => 'Tháng này chưa chi gì.';

  @override
  String get monthlyTrend => '6 tháng gần đây';

  @override
  String lastMonthTotal(String amount) => 'Tháng trước: $amount';

  @override
  String get budgets => 'Ngân sách';

  @override
  String get monthlyBudget => 'Ngân sách tháng';

  @override
  String get setMonthlyBudget => 'Đặt ngân sách tháng';

  @override
  String get setBudgetHint =>
      'Xem số tiền còn lại và được cảnh báo trước khi chi quá tay.';

  @override
  String get setBudget => 'Đặt';

  @override
  String get editBudget => 'Sửa ngân sách';

  @override
  String get removeBudget => 'Bỏ';

  @override
  String get save => 'Lưu';

  @override
  String amountLeft(String amount) => 'Còn $amount';

  @override
  String amountOver(String amount) => 'Vượt ngân sách $amount';

  @override
  String spentOfLimit(String spent, String limit) =>
      'Đã chi $spent trên $limit';

  @override
  String amountSpent(String amount) => 'Đã chi $amount';

  @override
  String budgetUsed(String percent) => 'Đã dùng $percent ngân sách';

  @override
  String get categoryBudgets => 'Ngân sách theo danh mục';

  @override
  String get categoryBudgetsHint => 'Giới hạn số tiền chi cho một danh mục.';

  @override
  String categoryBudgetTitle(String name) => 'Ngân sách $name';

  @override
  String get setLimit => 'Đặt giới hạn';

  @override
  String get closeToLimit => 'Sắp chạm giới hạn';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      'Ngân sách lặp lại mỗi tháng. Bạn sẽ được nhắc khi chi tiêu vượt '
      '$nearing, và một lần nữa ở $reached.';

  @override
  String get budgetAlertTitle => 'Cảnh báo ngân sách';

  @override
  String get ok => 'OK';

  @override
  String get view => 'Xem';

  @override
  String monthlyBudgetNearing(String percent) =>
      'Bạn đã dùng $percent ngân sách tháng';

  @override
  String get monthlyBudgetUsedUp => 'Bạn đã dùng hết ngân sách tháng';

  @override
  String monthlyBudgetExceeded(String amount) =>
      'Bạn đã vượt ngân sách tháng $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      'Bạn đã dùng $percent ngân sách $name';

  @override
  String categoryBudgetUsedUp(String name) => 'Bạn đã dùng hết ngân sách $name';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      'Bạn đã vượt ngân sách $name $amount';

  @override
  String get dataManagement => 'Quản lý dữ liệu';

  @override
  String get dataManagementHint =>
      'Các tệp do bạn tự giữ. Dùng được khi ngoại tuyến và không cần tài '
      'khoản.';

  @override
  String get backUpToFile => 'Sao lưu dữ liệu';

  @override
  String get backUpToFileHint => 'Một tệp sao lưu đầy đủ để nhập lại sau';

  @override
  String get exportCsv => 'Xuất CSV';

  @override
  String get exportCsvHint => 'Cho Excel hoặc Google Trang tính';

  @override
  String get exportPdf => 'Xuất PDF';

  @override
  String get exportPdfHint => 'Báo cáo để đọc, in hoặc chia sẻ';

  @override
  String get importData => 'Nhập dữ liệu';

  @override
  String get importDataHint => 'Khôi phục từ tệp sao lưu';

  @override
  String get preparingFile => 'Đang chuẩn bị tệp…';

  @override
  String get importingData => 'Đang nhập…';

  @override
  String get fileSaved => 'Đã lưu tệp';

  @override
  String get importDone => 'Đã nhập xong';

  @override
  String get importNothingNew =>
      'Điện thoại này đã có mọi thứ trong bản sao lưu';

  @override
  String get fileReady => 'Tệp đã sẵn sàng';

  @override
  String get shareFile => 'Chia sẻ';

  @override
  String get shareFileHint => 'WhatsApp, email, Google Drive và hơn nữa';

  @override
  String get saveToPhone => 'Lưu vào điện thoại này';

  @override
  String get saveToPhoneHint => 'Chọn nơi lưu';

  @override
  String get importTitle => 'Nhập bản sao lưu này?';

  @override
  String get importMergeHint =>
      'Gộp giữ mọi thứ trên điện thoại này và thêm phần còn thiếu. Nếu một '
      'mục khác nhau, thay đổi mới hơn sẽ được giữ.';

  @override
  String get merge => 'Gộp';

  @override
  String get replaceEverything => 'Thay thế tất cả';

  @override
  String get replaceTitle => 'Thay thế mọi thứ trên điện thoại này?';

  @override
  String get replaceBody =>
      'Mọi thứ trên điện thoại này mà không có trong bản sao lưu sẽ bị xóa, '
      'và mỗi mục sẽ dùng phiên bản trong bản sao lưu. Không thể hoàn tác.';

  @override
  String get replace => 'Thay thế';

  @override
  String get colDate => 'Ngày';

  @override
  String get colMonth => 'Tháng';

  @override
  String get colAmount => 'Số tiền';

  @override
  String get colNote => 'Ghi chú';

  @override
  String get colId => 'ID';

  @override
  String get colCount => 'Giao dịch';

  @override
  String get colTotal => 'Tổng';

  @override
  String get colShare => 'Tỷ lệ';

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get reportTitle => 'Ngân sách của tôi: báo cáo chi tiêu';

  @override
  String get reportPeriod => 'Kỳ';

  @override
  String get reportTotal => 'Tổng đã chi';

  @override
  String get reportMonthlyAverage => 'Trung bình mỗi tháng';

  @override
  String get reportByMonth => 'Chi tiêu theo tháng';

  @override
  String get reportAllExpenses => 'Tất cả khoản chi';

  @override
  String get reportEmpty => 'Chưa ghi khoản chi nào.';

  @override
  String get reportPageTemplate => 'Trang {page}/{pages}';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)} và ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)} và '
              '${personCount(people)}';
    return date == null
        ? 'Bản sao lưu này có $contents.'
        : 'Bản sao lưu ngày $date: $contents.';
  }

  @override
  String categoryCount(int count) => '$count danh mục';

  @override
  String reportGenerated(String when) => 'Tạo lúc $when';

  @override
  String get showPassword => 'Hiện mật khẩu';

  @override
  String get hidePassword => 'Ẩn mật khẩu';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => 'Ăn uống',
    'cat_transport' => 'Đi lại',
    'cat_bills' => 'Hóa đơn',
    'cat_shopping' => 'Mua sắm',
    'cat_health' => 'Sức khỏe & thể thao',
    'cat_entertainment' => 'Giải trí',
    'cat_work' => 'Công việc',
    'cat_other' => 'Khác',
    'cat_salary' => 'Lương',
    'cat_freelance' => 'Làm tự do',
    'cat_investments' => 'Đầu tư',
    'cat_gifts' => 'Quà tặng',
    'cat_income_other' => 'Thu nhập khác',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => 'Không lưu được vào thiết bị này. Hãy thử lại.',
    FailureCode.notFound => 'Mục đó không còn nữa.',
    FailureCode.unknown => 'Đã xảy ra lỗi.',
    FailureCode.amountRequired => 'Nhập số tiền lớn hơn 0.',
    FailureCode.amountTooLarge => 'Số tiền đó quá lớn.',
    FailureCode.amountInvalid => 'Nhập số tiền hợp lệ.',
    FailureCode.categoryRequired => 'Chọn một danh mục.',
    FailureCode.categoryNameRequired => 'Đặt tên cho danh mục.',
    FailureCode.categoryNameTaken => 'Bạn đã có danh mục với tên này.',
    FailureCode.categoryNameTooLong => 'Tên phải ngắn hơn 30 ký tự.',
    FailureCode.categoryProtected => 'Không thể xóa danh mục này.',
    FailureCode.currencySymbolInvalid => 'Dùng từ 1 đến 4 ký tự.',
    FailureCode.network => 'Không kết nối được. Kiểm tra internet rồi thử lại.',
    FailureCode.emailInvalid => 'Nhập địa chỉ email hợp lệ.',
    FailureCode.passwordTooShort => 'Mật khẩu cần ít nhất 6 ký tự.',
    FailureCode.invalidCredentials => 'Sai email hoặc mật khẩu.',
    FailureCode.emailTaken => 'Đã có tài khoản dùng email này.',
    FailureCode.emailNotConfirmed =>
      'Hãy xác nhận email bằng mã chúng tôi đã gửi trước.',
    FailureCode.codeInvalid => 'Mã sai hoặc đã hết hạn.',
    FailureCode.signInRequired => 'Đăng nhập lại rồi thử thêm lần nữa.',
    FailureCode.syncOtherAccount =>
      'Dữ liệu trên điện thoại này đang liên kết với tài khoản khác.',
    FailureCode.syncFailed => 'Không đồng bộ được với tài khoản. Hãy thử lại.',
    FailureCode.accountDeletionFailed =>
      'Không xóa được tài khoản. Hãy thử lại.',
    FailureCode.backupNotRecognized =>
      'Tệp này không phải bản sao lưu của Ngân sách của tôi.',
    FailureCode.pastedNotRecognized =>
      'Văn bản đã dán không phải dữ liệu ứng dụng đọc được. Hãy sao chép toàn bộ câu trả lời của AI và thử lại, hoặc nhờ AI sửa lại.',
    FailureCode.backupTooNew =>
      'Bản sao lưu này đến từ phiên bản mới hơn của Ngân sách của tôi. Hãy '
          'cập nhật ứng dụng rồi thử lại.',
    FailureCode.backupDamaged =>
      'Tệp sao lưu bị hỏng nên không có gì được nhập.',
    FailureCode.fileUnavailable => 'Không mở được tệp đó. Hãy thử chọn lại.',
    FailureCode.storageFull => 'Điện thoại này không đủ dung lượng trống.',
    FailureCode.exportFailed => 'Không tạo được tệp. Hãy thử lại.',
    FailureCode.shareUnavailable => 'Không mở được menu chia sẻ.',
    FailureCode.saveFailed => 'Không lưu được tệp. Hãy thử lại.',
    FailureCode.tooManyAttempts =>
      'Thử quá nhiều lần. Chờ một chút rồi thử lại.',
    FailureCode.titleRequired => 'Đặt tên cho nó.',
    FailureCode.titleTooLong => 'Tên phải ngắn hơn 40 ký tự.',
    FailureCode.dueDayInvalid => 'Chọn ngày đến hạn.',
    FailureCode.alreadyPaid => 'Khoản thanh toán đó đã được ghi.',
    FailureCode.personRequired => 'Chọn một người.',
    FailureCode.personNameRequired => 'Nhập tên.',
    FailureCode.personNameTooLong => 'Tên phải ngắn hơn 40 ký tự.',
    FailureCode.phoneInvalid => 'Nhập số điện thoại hợp lệ.',
    FailureCode.transactionSettled =>
      'Không thể sửa giao dịch đã thanh toán xong.',
    FailureCode.nothingToSettle => 'Không có gì cần thanh toán.',
    FailureCode.settlementAlreadyLogged =>
      'Lần thanh toán này đã có trong ngân sách.',
  };

  @override
  String get expenseDeleted => 'Đã xóa khoản chi';

  @override
  String get expenseRestored => 'Đã khôi phục khoản chi';

  @override
  String categoryAdded(String name) => 'Đã thêm $name';

  @override
  String get categoryUpdated => 'Đã cập nhật danh mục';

  @override
  String categoryDeleted(String name) => 'Đã xóa $name';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      'Đã xóa $name — ${expenseCount(count)} được chuyển sang Khác';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      'Đã xóa $name — ${transactionCount(count)} được chuyển sang Thu nhập '
      'khác';

  @override
  String get expense => 'Khoản chi';

  @override
  String get income => 'Khoản thu';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get searchHint => 'Tìm ghi chú hoặc số tiền';

  @override
  String get searchPrompt =>
      'Tìm giao dịch theo ghi chú hoặc số tiền, hoặc lọc theo loại, danh mục và ngày.';

  @override
  String get noSearchResults => 'Không có giao dịch phù hợp';

  @override
  String get allTypes => 'Tất cả';

  @override
  String get anyCategory => 'Mọi danh mục';

  @override
  String get anyDate => 'Mọi ngày';

  @override
  String get clearFilters => 'Xóa bộ lọc';

  @override
  String get transactionType => 'Chi hay thu';

  @override
  String get quickIncome => 'Thu nhanh';

  @override
  String get newIncome => 'Khoản thu mới';

  @override
  String get editIncome => 'Sửa khoản thu';

  @override
  String get addIncome => 'Thêm khoản thu';

  @override
  String get incomeNoteHint => 'Tiền từ đâu?';

  @override
  String get totalIncome => 'Tổng thu';

  @override
  String get totalExpenses => 'Tổng chi';

  @override
  String get netBalance => 'Số dư ròng';

  @override
  String get savingsRate => 'Tỷ lệ tiết kiệm';

  @override
  String get savingsRateNoIncome => 'Thêm khoản thu để xem tỷ lệ tiết kiệm';

  @override
  String get expenseCategories => 'Danh mục chi';

  @override
  String get incomeCategories => 'Danh mục thu';

  @override
  String get deleteIncomeCategoryBody =>
      'Các khoản thu trong danh mục này sẽ được chuyển sang Thu nhập khác. '
      'Không có gì bị xóa.';

  @override
  String get incomeDeleted => 'Đã xóa khoản thu';

  @override
  String get incomeRestored => 'Đã khôi phục khoản thu';

  @override
  String get colType => 'Loại';

  @override
  String transactionCount(int count) => '$count giao dịch';

  @override
  String get recurringPayments => 'Khoản định kỳ';

  @override
  String get newRecurring => 'Khoản định kỳ mới';

  @override
  String get editRecurring => 'Sửa khoản định kỳ';

  @override
  String get addRecurring => 'Thêm khoản';

  @override
  String get recurringTitle => 'Tên';

  @override
  String get recurringTitleHint => 'Tiền nhà, Netflix, phòng gym…';

  @override
  String get amount => 'Số tiền';

  @override
  String get repeats => 'Lặp lại';

  @override
  String get weekly => 'Hằng tuần';

  @override
  String get monthly => 'Hằng tháng';

  @override
  String get yearly => 'Hằng năm';

  @override
  String get dueOn => 'Đến hạn';

  @override
  String get dueDayOfMonth => 'Ngày trong tháng';

  @override
  String get dueMonthLabel => 'Tháng';

  @override
  String get dueDayLabel => 'Ngày';

  @override
  String get shortMonthHint => 'Ở tháng ngắn hơn, sẽ rơi vào ngày cuối tháng.';

  @override
  String get whenDue => 'Khi đến hạn';

  @override
  String get autoDeduct => 'Tự động trừ';

  @override
  String get remindMe => 'Nhắc tôi';

  @override
  String get autoDeductHint => 'Tự động ghi thành khoản chi vào ngày đến hạn.';

  @override
  String get remindMeHint =>
      'Bạn sẽ được hỏi xác nhận từng khoản trước khi ghi.';

  @override
  String get statusPaid => 'Đã trả';

  @override
  String get statusUpcoming => 'Sắp tới';

  @override
  String get statusOverdue => 'Quá hạn';

  @override
  String get markAsPaid => 'Đã trả';

  @override
  String get dueToday => 'Đến hạn hôm nay';

  @override
  String dueOnDate(String date) => 'Đến hạn $date';

  @override
  String nextDueOn(String date) => 'Lần tới $date';

  @override
  String overdueSince(String date, int count) => count <= 1
      ? 'Đã đến hạn $date'
      : '${paymentCount(count)} quá hạn từ $date';

  @override
  String everyWeekday(String weekday) => 'Mỗi $weekday';

  @override
  String monthlyOnDay(String day) => 'Hằng tháng vào ngày $day';

  @override
  String yearlyOn(String date) => 'Hằng năm vào $date';

  @override
  String get monthlyAverage => 'Mỗi tháng';

  @override
  String get monthlyAverageHint => 'Trung bình tất cả khoản định kỳ';

  @override
  String get noRecurringYet => 'Chưa có khoản định kỳ nào';

  @override
  String get noRecurringHint =>
      'Thêm tiền nhà, hóa đơn và gói đăng ký một lần. Mỗi tháng bạn sẽ thấy '
      'khoản nào đã trả và khoản nào còn phải trả.';

  @override
  String get paymentsToConfirm => 'Khoản cần xác nhận';

  @override
  String get seeAll => 'Xem tất cả';

  @override
  String get deleteRecurringBody =>
      'Khoản này sẽ ngừng lặp lại. Các khoản đã ghi vẫn còn trong giao dịch '
      'của bạn.';

  @override
  String recurringPaid(String name) => 'Đã đánh dấu $name là đã trả';

  @override
  String recurringReceived(String name) => 'Đã đánh dấu $name là đã nhận';

  @override
  String get statusReceived => 'Đã nhận';

  @override
  String get markAsReceived => 'Đã nhận';

  @override
  String get autoAdd => 'Tự động cộng';

  @override
  String get autoAddHint => 'Tự động ghi thành khoản thu vào ngày đến hạn.';

  @override
  String get monthlyIncomeAverage => 'Thu mỗi tháng';

  @override
  String get recurringPaymentUndone => 'Đã bỏ khoản thanh toán';

  @override
  String recurringAutoLogged(int count) =>
      'Đã tự động ghi $count khoản định kỳ';

  @override
  String paymentCount(int count) => '$count khoản';

  @override
  String get colPaidThrough => 'Đã trả đến';

  // People & debts

  @override
  String get people => 'Mọi người';

  @override
  String get peopleAndDebts => 'Mọi người & nợ';

  @override
  String get person => 'Người';

  @override
  String get personName => 'Tên';

  @override
  String get phone => 'Điện thoại';

  @override
  String get phoneOptional => 'Điện thoại (không bắt buộc)';

  @override
  String get balance => 'Số dư';

  @override
  String get colStatus => 'Trạng thái';

  @override
  String get owesYou => 'Nợ bạn';

  @override
  String get youOwe => 'Bạn nợ';

  @override
  String get owedToYou => 'Người khác nợ bạn';

  @override
  String get settledUp => 'Đã xong';

  @override
  String get iPaidForThem => 'Tôi trả giùm';

  @override
  String get theyPaidForMe => 'Họ trả giùm tôi';

  @override
  String get theyPaidYou => 'Họ trả bạn';

  @override
  String get youPaidThem => 'Bạn trả họ';

  @override
  String get openStatus => 'Chưa xong';

  @override
  String get settledStatus => 'Đã xong';

  @override
  String get settledOn => 'Xong vào';

  @override
  String get createdOn => 'Ngày tạo';

  @override
  String get lastEdited => 'Sửa lần cuối';

  @override
  String get colEdits => 'Lần sửa';

  @override
  String get activeTransactions => 'Giao dịch đang mở';

  @override
  String get settledHistory => 'Lịch sử đã thanh toán';

  @override
  String get filterAll => 'Tất cả';

  @override
  String get filterOwedToMe => 'Nợ tôi';

  @override
  String get filterIOwe => 'Tôi nợ';

  @override
  String get filterSettled => 'Đã xong';

  @override
  String get addPerson => 'Thêm người';

  @override
  String get addPersonHint => 'Người bạn chia sẻ chi phí';

  @override
  String get newPerson => 'Người mới';

  @override
  String get editPerson => 'Sửa người';

  @override
  String get deletePerson => 'Xóa người';

  @override
  String get quickTransaction => 'Giao dịch nhanh';

  @override
  String get quickTransactionHint => 'Ghi lại ai đã trả, với người bạn đã thêm';

  @override
  String get noPeopleYet => 'Chưa có ai';

  @override
  String get noPeopleHint =>
      'Thêm những người bạn chia sẻ chi phí để theo dõi ai nợ ai.';

  @override
  String get nobodyHere => 'Không ai khớp với bộ lọc này.';

  @override
  String get addPersonFirst => 'Hãy thêm một người trước.';

  @override
  String get newTransaction => 'Giao dịch mới';

  @override
  String get editTransaction => 'Sửa giao dịch';

  @override
  String get transactionDetails => 'Chi tiết giao dịch';

  @override
  String get debtNoteHint => 'Cho việc gì?';

  @override
  String get changeHistory => 'Lịch sử thay đổi';

  @override
  String get edited => 'Đã sửa';

  @override
  String get settleUp => 'Thanh toán';

  @override
  String get settle => 'Thanh toán';

  @override
  String get noDebtsYet => 'Chưa có ghi chép nào';

  @override
  String get noDebtsHint =>
      'Thêm những gì bạn trả giùm họ, hoặc họ trả giùm bạn.';

  @override
  String get settleEven =>
      'Các giao dịch này bù trừ nhau nên không ai cần trả tiền.';

  @override
  String get logSettlementTitle =>
      'Ghi lần thanh toán này vào ngân sách tháng?';

  @override
  String get loggedInBudget => 'Trong ngân sách';

  @override
  String get deleteTransactionTitle => 'Xóa giao dịch này?';

  @override
  String get deleteTransactionBody =>
      'Giao dịch sẽ bị bỏ khỏi số dư với người này.';

  @override
  String get deletePersonBody =>
      'Các giao dịch và lịch sử thanh toán của người này cũng bị xóa. Những '
      'gì bạn đã ghi vào ngân sách vẫn còn.';

  @override
  String get settledLocked => 'Đã thanh toán xong nên không sửa được nữa.';

  @override
  String get personUpdated => 'Đã cập nhật người';

  @override
  String get debtDeleted => 'Đã xóa giao dịch';

  @override
  String get settledUpNotice => 'Đã thanh toán xong hết';

  @override
  String get settlementLogged => 'Đã thêm vào ngân sách';

  @override
  String personOwesYou(String name) => '$name nợ bạn';

  @override
  String youOwePerson(String name) => 'Bạn nợ $name';

  @override
  String settledWith(String name) => 'Đã xong hết với $name';

  @override
  String settleUpFor(String amount) => 'Thanh toán $amount';

  @override
  String settleTitle(String name) => 'Thanh toán với $name?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name trả bạn $amount để xong hết.';

  @override
  String settleYouPay(String name, String amount) =>
      'Bạn trả $name $amount để xong hết.';

  @override
  String settleMoves(int count) =>
      '${transactionCount(count)} sẽ chuyển sang lịch sử đã thanh toán.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount sẽ được thêm thành khoản thu trong Thu nhập khác. Bạn có thể '
      'chuyển sang danh mục khác sau.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount sẽ được thêm thành khoản chi trong Khác. Bạn có thể chuyển '
      'sang danh mục khác sau.';

  @override
  String settlementNote(String name) => 'Thanh toán với $name';

  @override
  String settledGroupTitle(String date) => 'Xong vào $date';

  @override
  String deletePersonTitle(String name) => 'Xóa $name?';

  @override
  String editedOn(String date) => 'Đã sửa $date';

  @override
  String wasValues(String values) => 'Trước đây: $values';

  @override
  String personCount(int count) => '$count người';

  @override
  String get importFromAi => 'Từ ứng dụng khác';

  @override
  String get importFromAiHint =>
      'Chuyển đổi dữ liệu bằng ChatGPT, Gemini, Claude hoặc AI khác';

  @override
  String get aiImportTitle => 'Nhập từ ứng dụng khác';

  @override
  String get aiImportIntro =>
      'Trò chuyện AI có thể chuyển dữ liệu từ ứng dụng khác hoặc bảng tính thành tệp mà My Budget nhập được.';

  @override
  String get aiImportStep1 => 'Sao chép câu lệnh (prompt).';

  @override
  String get aiImportStep2 =>
      'Dán vào ChatGPT, Gemini, Claude hoặc AI khác, rồi đính kèm hoặc dán dữ liệu của bạn.';

  @override
  String get aiImportStep3 =>
      'Sao chép câu trả lời của AI và dán vào đây, hoặc lưu thành tệp rồi chọn tệp đó.';

  @override
  String get copyPrompt => 'Sao chép prompt';

  @override
  String get pasteAnswer => 'Dán câu trả lời';

  @override
  String get chooseFile => 'Chọn tệp';

  @override
  String get aiImportPrivacy =>
      'Dữ liệu của bạn được gửi tới dịch vụ AI bạn chọn. Bạn sẽ thấy những gì được nhập trước khi có thay đổi.';

  @override
  String get promptCopied => 'Đã sao chép prompt';

  @override
  String get askTitle => 'Hỏi về chi tiêu';

  @override
  String get askHint => 'Chạm vào câu hỏi để xem câu trả lời.';

  @override
  String get askCompareMonths => 'So sánh tháng';

  @override
  String get askTopCategory => 'Danh mục chính';

  @override
  String get askVsLastMonth => 'So với tháng trước';

  @override
  String get askBiggestExpense => 'Khoản chi lớn nhất';

  @override
  String get askTopDay => 'Ngày tốn nhất';

  @override
  String get askWeekday => 'Thứ chi nhiều nhất';

  @override
  String get askMonthEnd => 'Ước tính cuối tháng';

  @override
  String get askSaved => 'Có tiết kiệm không?';

  @override
  String get askBudgetLeft => 'Ngân sách còn lại';

  @override
  String get askHighestLowest => 'Tháng cao & thấp nhất';

  @override
  String get askCount => 'Bao nhiêu khoản chi';

  @override
  String get askTopIncome => 'Thu nhập chính';

  @override
  String get otherCategories => 'Khác';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      'Chi nhiều nhất cho $category: $amount ($percent của tháng).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month chi nhiều hơn $other $amount (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month chi ít hơn $other $amount (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      '$month và $other chi bằng nhau.';

  @override
  String answerNothingIn(String month) =>
      'Không có khoản chi nào trong $month.';

  @override
  String answerRise(String category, String amount) =>
      'Tăng nhiều nhất: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      'Giảm nhiều nhất: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      'Khoản chi lớn nhất: $amount cho $category ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      'Ngày tốn nhất: $date, chi $amount.';

  @override
  String answerWeekday(String weekday, String amount) =>
      'Ngày trong tuần chi nhiều nhất: $weekday ($amount tháng này).';

  @override
  String answerMonthEnd(String amount, String average) =>
      'Với tốc độ này (khoảng $average mỗi ngày), đến cuối tháng bạn sẽ chi khoảng $amount.';

  @override
  String answerMonthTotal(String amount) =>
      'Tháng này đã kết thúc: tổng chi $amount.';

  @override
  String answerSaved(String amount, String income) =>
      'Bạn tiết kiệm được $amount trong $income thu nhập.';

  @override
  String answerOverspent(String amount) =>
      'Bạn chi nhiều hơn thu nhập $amount.';

  @override
  String get answerNoIncome => 'Tháng này chưa có thu nhập.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      'Ngân sách tháng còn $amount (đã dùng $percent).';

  @override
  String answerBudgetOver(String amount) => 'Bạn vượt ngân sách tháng $amount.';

  @override
  String get answerNoBudget => 'Bạn chưa đặt ngân sách tháng.';

  @override
  String answerOverLimit(String names) => 'Vượt giới hạn: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => 'Tháng cao nhất: $high ($highAmount). Thấp nhất: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      'Bạn đã ghi ${expenseCount(count)}, trung bình $average mỗi khoản.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      'Thu nhập chủ yếu từ $category: $amount ($percent).';
}
