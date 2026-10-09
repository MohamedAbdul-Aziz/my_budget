import '../../error/failures.dart';
import '../app_strings.dart';

/// Korean. Counts take a counter word and no plural form.
class AppStringsKo extends AppStrings {
  const AppStringsKo();

  @override
  String get localeName => 'ko';

  @override
  String get appTitle => '내 예산';

  @override
  String get add => '추가';

  @override
  String get undo => '실행 취소';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get nothingRecordedYet => '아직 기록이 없어요';

  @override
  String get emptyPeriodHint => '추가를 눌러 이 기간의 지출이나 수입을 기록하세요.';

  @override
  String get periodDay => '일';

  @override
  String get periodWeek => '주';

  @override
  String get periodMonth => '월';

  @override
  String get periodYear => '년';

  @override
  String get previousPeriod => '이전';

  @override
  String get nextPeriod => '다음';

  @override
  String get yourMonths => '월 목록';

  @override
  String spentIn(String month) => '$month 지출';

  @override
  String expenseCount(int count) => '지출 $count건';

  @override
  String get quickExpense => '빠른 지출';

  @override
  String get expenseSaved => '지출을 저장했어요';

  @override
  String get newExpense => '새 지출';

  @override
  String get editExpense => '지출 수정';

  @override
  String get when => '날짜';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get pickADate => '날짜 선택';

  @override
  String get category => '카테고리';

  @override
  String get noteOptional => '메모(선택)';

  @override
  String get noteHint => '어디에 썼나요?';

  @override
  String get addExpense => '지출 추가';

  @override
  String get saveChanges => '변경 사항 저장';

  @override
  String get amountHint => '0';

  @override
  String get categories => '카테고리';

  @override
  String get newCategory => '새 카테고리';

  @override
  String get editCategory => '카테고리 수정';

  @override
  String get addCategory => '카테고리 추가';

  @override
  String get categoryName => '이름';

  @override
  String get color => '색상';

  @override
  String get icon => '아이콘';

  @override
  String get builtIn => '기본';

  @override
  String get custom => '사용자 지정';

  @override
  String get edit => '수정';

  @override
  String get delete => '삭제';

  @override
  String get cancel => '취소';

  @override
  String deleteCategoryTitle(String name) => '$name 카테고리를 삭제할까요?';

  @override
  String get deleteCategoryBody => '이 카테고리의 지출은 기타로 옮겨집니다. 삭제되는 것은 없어요.';

  @override
  String get settings => '설정';

  @override
  String get appearance => '화면';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get language => '언어';

  @override
  String get languageSystem => '시스템';

  @override
  String get currency => '통화';

  @override
  String get currencySymbol => '기호';

  @override
  String get currencySymbolHint => '모든 금액 옆에 표시됩니다';

  @override
  String get currencyOther => '기타';

  @override
  String get reminders => '알림';

  @override
  String get dailyReminder => '매일 알림';

  @override
  String get dailyReminderHint => '오늘 쓴 돈을 기록하도록 알려 드려요';

  @override
  String get reminderTime => '시간';

  @override
  String get notificationsBlocked => '이 앱의 알림이 꺼져 있습니다. 휴대폰 설정에서 허용하세요.';

  @override
  String get reminderNotificationTitle => '오늘의 지출을 기록하세요';

  @override
  String get reminderNotificationBody => '잠시 시간을 내어 오늘 쓴 금액을 추가하세요.';

  @override
  String get security => '보안';

  @override
  String get appLock => '앱 잠금';

  @override
  String get appLockHint => '앱을 열 때 지문, 얼굴 또는 화면 잠금을 요청해요';

  @override
  String get appLockUnavailable => '먼저 이 휴대폰에 화면 잠금을 설정하세요';

  @override
  String get unlock => '잠금 해제';

  @override
  String get unlockToContinue => '잠금을 해제하고 예산을 확인하세요';

  @override
  String get confirmItsYou => '앱 잠금을 바꾸려면 본인임을 확인하세요';

  @override
  String get storedOnThisDevice => '지출은 이 기기에 저장됩니다. 백업하려면 로그인하세요.';

  @override
  String get account => '계정';

  @override
  String get accountOptional => '계정은 선택 사항이에요. 계정 없이도 모든 기능을 쓸 수 있어요.';

  @override
  String get signIn => '로그인';

  @override
  String get signOut => '로그아웃';

  @override
  String get signedIn => '로그인됨';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get noAccountYet => '계정이 없나요? 만들기';

  @override
  String get haveAnAccount => '이미 계정이 있나요? 로그인';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get passwordRules => '6자 이상';

  @override
  String get confirmEmail => '이메일 인증';

  @override
  String codeSentTo(String email) =>
      '$email(으)로 코드를 보냈어요. 아래에 입력해 계정 만들기를 완료하세요.';

  @override
  String get confirmationCode => '코드';

  @override
  String get confirm => '확인';

  @override
  String get resendCode => '새 코드 보내기';

  @override
  String get codeResent => '새 코드를 보냈어요';

  @override
  String get useDifferentEmail => '다른 이메일 사용';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get resetPassword => '비밀번호 재설정';

  @override
  String resetCodeSentTo(String email) =>
      '$email(으)로 코드를 보냈어요. 코드와 계정의 새 비밀번호를 입력하세요.';

  @override
  String get newPassword => '새 비밀번호';

  @override
  String get saveNewPassword => '새 비밀번호 저장';

  @override
  String get backToSignIn => '로그인으로 돌아가기';

  @override
  String get backupHint =>
      '백업하면 지출 사본이 계정에 보관돼요. 복원하면 이 휴대폰에 있는 기록은 그대로 두고 사본을 가져옵니다.';

  @override
  String get backUpNow => '지금 백업';

  @override
  String get autoBackup => '자동 백업';

  @override
  String get autoBackupHint => '앱을 나갈 때마다 새 변경 사항이 계정에 백업돼요.';

  @override
  String get restoreData => '복원';

  @override
  String get backingUp => '백업 중…';

  @override
  String get restoring => '복원 중…';

  @override
  String get backupDone => '백업 완료';

  @override
  String get restoreDone => '복원 완료';

  @override
  String get neverSynced => '아직 백업하지 않았어요';

  @override
  String lastSynced(String when) => '마지막 동기화: $when';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountTitle => '계정을 삭제할까요?';

  @override
  String get deleteAccountBody =>
      '계정과 그 안에 저장된 지출 백업이 영구적으로 삭제되며 되돌릴 수 없어요. 이 휴대폰의 지출은 그대로 남고, 계정 없이 앱을 계속 쓸 수 있어요.';

  @override
  String get deletingAccount => '계정을 삭제하는 중…';

  @override
  String get accountDeleted => '계정을 삭제했어요';

  @override
  String get home => '홈';

  @override
  String get analyses => '분석';

  @override
  String get vsLastMonth => '지난달 대비';

  @override
  String get noComparison => '지난달 데이터 없음';

  @override
  String get dailySpending => '일별 지출';

  @override
  String get dailyAverage => '하루 평균';

  @override
  String get topDay => '가장 많이 쓴 날';

  @override
  String get byCategory => '카테고리별 지출';

  @override
  String get noSpendingThisMonth => '이번 달 지출이 아직 없어요.';

  @override
  String get monthlyTrend => '최근 6개월';

  @override
  String lastMonthTotal(String amount) => '지난달: $amount';

  @override
  String get budgets => '예산';

  @override
  String get monthlyBudget => '월 예산';

  @override
  String get setMonthlyBudget => '월 예산 설정';

  @override
  String get setBudgetHint => '남은 금액을 보고, 과소비하기 전에 알림을 받으세요.';

  @override
  String get setBudget => '설정';

  @override
  String get editBudget => '예산 수정';

  @override
  String get removeBudget => '삭제';

  @override
  String get save => '저장';

  @override
  String amountLeft(String amount) => '$amount 남음';

  @override
  String amountOver(String amount) => '예산 $amount 초과';

  @override
  String spentOfLimit(String spent, String limit) => '$limit 중 $spent 사용';

  @override
  String amountSpent(String amount) => '$amount 사용';

  @override
  String budgetUsed(String percent) => '예산의 $percent 사용';

  @override
  String get categoryBudgets => '카테고리 예산';

  @override
  String get categoryBudgetsHint => '한 카테고리에 쓰는 금액에 한도를 정하세요.';

  @override
  String categoryBudgetTitle(String name) => '$name 예산';

  @override
  String get setLimit => '한도 설정';

  @override
  String get closeToLimit => '한도에 가까운 카테고리';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      '예산은 매달 반복돼요. 지출이 $nearing를 넘으면 알려 드리고, $reached에 도달하면 한 번 더 알려 드려요.';

  @override
  String get budgetAlertTitle => '예산 알림';

  @override
  String get ok => '확인';

  @override
  String get view => '보기';

  @override
  String monthlyBudgetNearing(String percent) => '월 예산의 $percent를 썼어요';

  @override
  String get monthlyBudgetUsedUp => '월 예산을 모두 썼어요';

  @override
  String monthlyBudgetExceeded(String amount) => '월 예산을 $amount 초과했어요';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      '$name 예산의 $percent를 썼어요';

  @override
  String categoryBudgetUsedUp(String name) => '$name 예산을 모두 썼어요';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      '$name 예산을 $amount 초과했어요';

  @override
  String get dataManagement => '데이터 관리';

  @override
  String get dataManagementHint => '직접 보관하는 파일이에요. 오프라인에서도, 계정 없이도 쓸 수 있어요.';

  @override
  String get backUpToFile => '내 데이터 백업';

  @override
  String get backUpToFileHint => '나중에 가져올 수 있는 전체 백업 파일';

  @override
  String get exportCsv => 'CSV로 내보내기';

  @override
  String get exportCsvHint => 'Excel 또는 Google 스프레드시트용';

  @override
  String get exportPdf => 'PDF로 내보내기';

  @override
  String get exportPdfHint => '읽고, 인쇄하고, 공유할 수 있는 보고서';

  @override
  String get importData => '데이터 가져오기';

  @override
  String get importDataHint => '백업 파일에서 복원';

  @override
  String get preparingFile => '파일을 준비하는 중…';

  @override
  String get importingData => '가져오는 중…';

  @override
  String get fileSaved => '파일을 저장했어요';

  @override
  String get importDone => '가져오기 완료';

  @override
  String get importNothingNew => '이 휴대폰에 백업의 내용이 이미 모두 있었어요';

  @override
  String get fileReady => '파일이 준비됐어요';

  @override
  String get shareFile => '공유';

  @override
  String get shareFileHint => 'WhatsApp, 이메일, Google 드라이브 등';

  @override
  String get saveToPhone => '이 휴대폰에 저장';

  @override
  String get saveToPhoneHint => '저장할 위치 선택';

  @override
  String get importTitle => '이 백업을 가져올까요?';

  @override
  String get importMergeHint =>
      '병합은 이 휴대폰의 데이터를 모두 유지하고 없는 것을 추가해요. 기록이 서로 다르면 더 최근 변경이 적용돼요.';

  @override
  String get merge => '병합';

  @override
  String get replaceEverything => '모두 바꾸기';

  @override
  String get replaceTitle => '이 휴대폰의 모든 데이터를 바꿀까요?';

  @override
  String get replaceBody =>
      '백업에 없는 데이터는 이 휴대폰에서 삭제되고, 모든 기록이 백업의 내용으로 바뀌어요. 되돌릴 수 없어요.';

  @override
  String get replace => '바꾸기';

  @override
  String get colDate => '날짜';

  @override
  String get colMonth => '월';

  @override
  String get colAmount => '금액';

  @override
  String get colNote => '메모';

  @override
  String get colId => 'ID';

  @override
  String get colCount => '건수';

  @override
  String get colTotal => '합계';

  @override
  String get colShare => '비율';

  @override
  String get yes => '예';

  @override
  String get no => '아니요';

  @override
  String get reportTitle => '내 예산: 지출 보고서';

  @override
  String get reportPeriod => '기간';

  @override
  String get reportTotal => '총 지출';

  @override
  String get reportMonthlyAverage => '월 평균';

  @override
  String get reportByMonth => '월별 지출';

  @override
  String get reportAllExpenses => '모든 지출';

  @override
  String get reportEmpty => '아직 기록된 지출이 없어요.';

  @override
  String get reportPageTemplate => '{page} / {pages}쪽';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)}, ${categoryCount(categories)}'
        : '${expenseCount(expenses)}, ${categoryCount(categories)}, '
              '${personCount(people)}';
    return date == null ? '이 백업에는 $contents이 있어요.' : '$date 백업: $contents.';
  }

  @override
  String categoryCount(int count) => '카테고리 $count개';

  @override
  String reportGenerated(String when) => '$when 생성';

  @override
  String get showPassword => '비밀번호 표시';

  @override
  String get hidePassword => '비밀번호 숨기기';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => '식비',
    'cat_transport' => '교통',
    'cat_bills' => '공과금',
    'cat_shopping' => '쇼핑',
    'cat_health' => '건강·운동',
    'cat_entertainment' => '여가',
    'cat_work' => '업무',
    'cat_other' => '기타',
    'cat_salary' => '급여',
    'cat_freelance' => '프리랜스',
    'cat_investments' => '투자',
    'cat_gifts' => '선물',
    'cat_income_other' => '기타 수입',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => '이 기기에 저장하지 못했어요. 다시 시도해 주세요.',
    FailureCode.notFound => '해당 항목이 더 이상 없어요.',
    FailureCode.unknown => '문제가 발생했어요.',
    FailureCode.amountRequired => '0보다 큰 금액을 입력하세요.',
    FailureCode.amountTooLarge => '금액이 너무 커요.',
    FailureCode.amountInvalid => '올바른 금액을 입력하세요.',
    FailureCode.categoryRequired => '카테고리를 선택하세요.',
    FailureCode.categoryNameRequired => '카테고리 이름을 입력하세요.',
    FailureCode.categoryNameTaken => '이미 같은 이름의 카테고리가 있어요.',
    FailureCode.categoryNameTooLong => '이름은 30자 미만이어야 해요.',
    FailureCode.categoryProtected => '이 카테고리는 삭제할 수 없어요.',
    FailureCode.currencySymbolInvalid => '1~4자로 입력하세요.',
    FailureCode.network => '연결하지 못했어요. 인터넷을 확인하고 다시 시도해 주세요.',
    FailureCode.emailInvalid => '올바른 이메일 주소를 입력하세요.',
    FailureCode.passwordTooShort => '비밀번호는 6자 이상이어야 해요.',
    FailureCode.invalidCredentials => '이메일 또는 비밀번호가 올바르지 않아요.',
    FailureCode.emailTaken => '이 이메일로 된 계정이 이미 있어요.',
    FailureCode.emailNotConfirmed => '보내 드린 코드로 먼저 이메일을 인증하세요.',
    FailureCode.codeInvalid => '코드가 틀렸거나 만료됐어요.',
    FailureCode.signInRequired => '다시 로그인한 뒤 한 번 더 시도해 주세요.',
    FailureCode.syncOtherAccount => '이 휴대폰의 데이터는 다른 계정에 연결되어 있어요.',
    FailureCode.syncFailed => '계정과 동기화하지 못했어요. 다시 시도해 주세요.',
    FailureCode.accountDeletionFailed => '계정을 삭제하지 못했어요. 다시 시도해 주세요.',
    FailureCode.backupNotRecognized => '이 파일은 내 예산 백업이 아니에요.',
    FailureCode.pastedNotRecognized =>
      '붙여넣은 텍스트는 앱이 읽을 수 있는 데이터가 아니에요. AI의 답변 전체를 복사해 다시 시도하거나 AI에게 고쳐 달라고 하세요.',
    FailureCode.backupTooNew =>
      '이 백업은 더 새로운 버전의 내 예산에서 만들어졌어요. 앱을 업데이트한 뒤 다시 시도해 주세요.',
    FailureCode.backupDamaged => '백업 파일이 손상되어 아무것도 가져오지 않았어요.',
    FailureCode.fileUnavailable => '파일을 열지 못했어요. 다시 선택해 주세요.',
    FailureCode.storageFull => '이 휴대폰의 저장 공간이 부족해요.',
    FailureCode.exportFailed => '파일을 만들지 못했어요. 다시 시도해 주세요.',
    FailureCode.shareUnavailable => '공유 메뉴를 열지 못했어요.',
    FailureCode.saveFailed => '파일을 저장하지 못했어요. 다시 시도해 주세요.',
    FailureCode.tooManyAttempts => '시도 횟수가 너무 많아요. 잠시 후 다시 시도해 주세요.',
    FailureCode.titleRequired => '이름을 입력하세요.',
    FailureCode.titleTooLong => '이름은 40자 미만이어야 해요.',
    FailureCode.dueDayInvalid => '결제일을 선택하세요.',
    FailureCode.alreadyPaid => '이미 기록된 결제예요.',
    FailureCode.personRequired => '사람을 선택하세요.',
    FailureCode.personNameRequired => '이름을 입력하세요.',
    FailureCode.personNameTooLong => '이름은 40자 미만이어야 해요.',
    FailureCode.phoneInvalid => '올바른 전화번호를 입력하세요.',
    FailureCode.transactionSettled => '정산된 거래는 바꿀 수 없어요.',
    FailureCode.nothingToSettle => '정산할 내용이 없어요.',
    FailureCode.settlementAlreadyLogged => '이 정산은 이미 예산에 기록되어 있어요.',
    FailureCode.questionRequired => '질문을 입력하세요.',
    FailureCode.questionTooLong => '질문은 500자 미만으로 해 주세요.',
    FailureCode.summaryTooLarge => '데이터가 너무 많아 도우미용으로 요약할 수 없어요.',
    FailureCode.aiUnavailable => '지금은 도우미를 사용할 수 없어요. 나중에 다시 시도하세요.',
    FailureCode.aiBusy => '도우미가 바빠요. 1분 후에 다시 시도하세요.',
    FailureCode.aiDailyLimit => '오늘 질문 20개를 모두 사용했어요. 내일 다시 시도하세요.',
  };

  @override
  String get expenseDeleted => '지출을 삭제했어요';

  @override
  String get expenseRestored => '지출을 복원했어요';

  @override
  String categoryAdded(String name) => '$name 추가됨';

  @override
  String get categoryUpdated => '카테고리를 수정했어요';

  @override
  String categoryDeleted(String name) => '$name 삭제됨';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '$name 삭제됨 — ${expenseCount(count)}을 기타로 옮겼어요';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '$name 삭제됨 — ${transactionCount(count)}을 기타 수입으로 옮겼어요';

  @override
  String get expense => '지출';

  @override
  String get income => '수입';

  @override
  String get search => '검색';

  @override
  String get searchHint => '메모나 금액 검색';

  @override
  String get searchPrompt => '메모나 금액으로 내역을 찾거나 유형, 카테고리, 날짜로 걸러 보세요.';

  @override
  String get noSearchResults => '일치하는 내역이 없어요';

  @override
  String get allTypes => '전체';

  @override
  String get anyCategory => '모든 카테고리';

  @override
  String get anyDate => '모든 날짜';

  @override
  String get clearFilters => '필터 지우기';

  @override
  String get transactionType => '지출 또는 수입';

  @override
  String get quickIncome => '빠른 수입';

  @override
  String get newIncome => '새 수입';

  @override
  String get editIncome => '수입 수정';

  @override
  String get addIncome => '수입 추가';

  @override
  String get incomeNoteHint => '어디서 들어왔나요?';

  @override
  String get totalIncome => '총수입';

  @override
  String get totalExpenses => '총지출';

  @override
  String get netBalance => '순잔액';

  @override
  String get savingsRate => '저축률';

  @override
  String get savingsRateNoIncome => '수입을 추가하면 저축률을 볼 수 있어요';

  @override
  String get expenseCategories => '지출 카테고리';

  @override
  String get incomeCategories => '수입 카테고리';

  @override
  String get deleteIncomeCategoryBody =>
      '이 카테고리의 수입은 기타 수입으로 옮겨집니다. 삭제되는 것은 없어요.';

  @override
  String get incomeDeleted => '수입을 삭제했어요';

  @override
  String get incomeRestored => '수입을 복원했어요';

  @override
  String get colType => '유형';

  @override
  String transactionCount(int count) => '거래 $count건';

  @override
  String get recurringPayments => '정기 결제';

  @override
  String get newRecurring => '새 정기 결제';

  @override
  String get editRecurring => '정기 결제 수정';

  @override
  String get addRecurring => '결제 추가';

  @override
  String get recurringTitle => '이름';

  @override
  String get recurringTitleHint => '월세, Netflix, 헬스장…';

  @override
  String get amount => '금액';

  @override
  String get repeats => '반복';

  @override
  String get weekly => '매주';

  @override
  String get monthly => '매월';

  @override
  String get yearly => '매년';

  @override
  String get dueOn => '결제일';

  @override
  String get dueDayOfMonth => '매월 날짜';

  @override
  String get dueMonthLabel => '월';

  @override
  String get dueDayLabel => '일';

  @override
  String get shortMonthHint => '날짜가 없는 달에는 말일로 처리돼요.';

  @override
  String get whenDue => '결제일이 되면';

  @override
  String get autoDeduct => '자동 차감';

  @override
  String get remindMe => '알림';

  @override
  String get autoDeductHint => '결제일에 자동으로 지출로 기록돼요.';

  @override
  String get remindMeHint => '기록하기 전에 결제마다 확인을 요청해요.';

  @override
  String get statusPaid => '결제됨';

  @override
  String get statusUpcoming => '예정';

  @override
  String get statusOverdue => '연체';

  @override
  String get markAsPaid => '결제 완료';

  @override
  String get dueToday => '오늘 결제';

  @override
  String dueOnDate(String date) => '$date 결제';

  @override
  String nextDueOn(String date) => '다음: $date';

  @override
  String overdueSince(String date, int count) =>
      count <= 1 ? '$date 결제 예정이었어요' : '$date부터 ${paymentCount(count)} 연체';

  @override
  String everyWeekday(String weekday) => '매주 $weekday';

  @override
  String monthlyOnDay(String day) => '매월 $day일';

  @override
  String yearlyOn(String date) => '매년 $date';

  @override
  String get monthlyAverage => '월 기준';

  @override
  String get monthlyAverageHint => '모든 정기 결제의 월 평균';

  @override
  String get noRecurringYet => '아직 정기 결제가 없어요';

  @override
  String get noRecurringHint =>
      '월세, 공과금, 구독을 한 번만 추가하세요. 매달 무엇을 냈고 무엇이 남았는지 볼 수 있어요.';

  @override
  String get paymentsToConfirm => '확인할 결제';

  @override
  String get seeAll => '모두 보기';

  @override
  String get deleteRecurringBody => '더 이상 반복되지 않아요. 이미 기록된 결제는 거래에 남아요.';

  @override
  String recurringPaid(String name) => '$name 결제 완료로 표시했어요';

  @override
  String recurringReceived(String name) => '$name 수령 완료로 표시했어요';

  @override
  String get statusReceived => '받음';

  @override
  String get markAsReceived => '수령 완료';

  @override
  String get autoAdd => '자동 추가';

  @override
  String get autoAddHint => '예정일에 자동으로 수입으로 기록돼요.';

  @override
  String get monthlyIncomeAverage => '월 수입';

  @override
  String get recurringPaymentUndone => '결제를 취소했어요';

  @override
  String recurringAutoLogged(int count) => '정기 결제 $count건이 자동으로 기록됐어요';

  @override
  String paymentCount(int count) => '결제 $count건';

  @override
  String get colPaidThrough => '결제 완료 기간';

  // People & debts

  @override
  String get people => '사람';

  @override
  String get peopleAndDebts => '사람과 빚';

  @override
  String get person => '사람';

  @override
  String get personName => '이름';

  @override
  String get phone => '전화번호';

  @override
  String get phoneOptional => '전화번호(선택)';

  @override
  String get balance => '잔액';

  @override
  String get colStatus => '상태';

  @override
  String get owesYou => '받을 돈';

  @override
  String get youOwe => '갚을 돈';

  @override
  String get owedToYou => '받을 돈';

  @override
  String get settledUp => '정산 완료';

  @override
  String get iPaidForThem => '내가 대신 냈어요';

  @override
  String get theyPaidForMe => '상대가 대신 냈어요';

  @override
  String get theyPaidYou => '상대가 나에게 줬어요';

  @override
  String get youPaidThem => '내가 상대에게 줬어요';

  @override
  String get openStatus => '미정산';

  @override
  String get settledStatus => '정산됨';

  @override
  String get settledOn => '정산일';

  @override
  String get createdOn => '생성일';

  @override
  String get lastEdited => '마지막 수정';

  @override
  String get colEdits => '수정 횟수';

  @override
  String get activeTransactions => '미정산 거래';

  @override
  String get settledHistory => '정산 내역';

  @override
  String get filterAll => '전체';

  @override
  String get filterOwedToMe => '받을 돈';

  @override
  String get filterIOwe => '갚을 돈';

  @override
  String get filterSettled => '정산됨';

  @override
  String get addPerson => '사람 추가';

  @override
  String get addPersonHint => '비용을 함께 나누는 사람';

  @override
  String get newPerson => '새 사람';

  @override
  String get editPerson => '사람 수정';

  @override
  String get deletePerson => '사람 삭제';

  @override
  String get quickTransaction => '빠른 거래';

  @override
  String get quickTransactionHint => '추가한 사람과 누가 냈는지 기록하세요';

  @override
  String get noPeopleYet => '아직 추가한 사람이 없어요';

  @override
  String get noPeopleHint => '비용을 함께 나누는 사람을 추가하면 누가 누구에게 얼마를 빚졌는지 볼 수 있어요.';

  @override
  String get nobodyHere => '이 필터에 맞는 사람이 없어요.';

  @override
  String get addPersonFirst => '먼저 사람을 추가하세요.';

  @override
  String get newTransaction => '새 거래';

  @override
  String get editTransaction => '거래 수정';

  @override
  String get transactionDetails => '거래 정보';

  @override
  String get debtNoteHint => '무엇에 쓴 돈인가요?';

  @override
  String get changeHistory => '변경 기록';

  @override
  String get edited => '수정됨';

  @override
  String get settleUp => '정산하기';

  @override
  String get settle => '정산';

  @override
  String get noDebtsYet => '아직 기록이 없어요';

  @override
  String get noDebtsHint => '상대를 위해 낸 돈이나 상대가 나를 위해 낸 돈을 추가하세요.';

  @override
  String get settleEven => '이 거래들은 서로 상쇄되어 주고받을 돈이 없어요.';

  @override
  String get logSettlementTitle => '이 정산을 월 예산에 기록할까요?';

  @override
  String get loggedInBudget => '예산에 기록됨';

  @override
  String get deleteTransactionTitle => '이 거래를 삭제할까요?';

  @override
  String get deleteTransactionBody => '이 사람과의 잔액에서 빠져요.';

  @override
  String get deletePersonBody => '이 사람의 거래와 정산 내역도 삭제돼요. 예산에 기록한 내용은 남아요.';

  @override
  String get settledLocked => '정산이 끝나서 더 이상 바꿀 수 없어요.';

  @override
  String get personUpdated => '사람 정보를 수정했어요';

  @override
  String get debtDeleted => '거래를 삭제했어요';

  @override
  String get settledUpNotice => '모두 정산했어요';

  @override
  String get settlementLogged => '예산에 추가했어요';

  @override
  String personOwesYou(String name) => '$name님에게 받을 돈';

  @override
  String youOwePerson(String name) => '$name님에게 갚을 돈';

  @override
  String settledWith(String name) => '$name님과 모두 정산했어요';

  @override
  String settleUpFor(String amount) => '$amount 정산하기';

  @override
  String settleTitle(String name) => '$name님과 정산할까요?';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name님이 $amount을 주면 모두 정산돼요.';

  @override
  String settleYouPay(String name, String amount) =>
      '$name님에게 $amount을 주면 모두 정산돼요.';

  @override
  String settleMoves(int count) => '${transactionCount(count)}이 정산 내역으로 옮겨져요.';

  @override
  String logSettlementIncome(String amount) =>
      '$amount이 기타 수입에 수입으로 추가돼요. 나중에 다른 카테고리로 옮길 수 있어요.';

  @override
  String logSettlementExpense(String amount) =>
      '$amount이 기타에 지출로 추가돼요. 나중에 다른 카테고리로 옮길 수 있어요.';

  @override
  String settlementNote(String name) => '$name님과 정산';

  @override
  String settledGroupTitle(String date) => '$date 정산';

  @override
  String deletePersonTitle(String name) => '$name님을 삭제할까요?';

  @override
  String editedOn(String date) => '$date 수정';

  @override
  String wasValues(String values) => '변경 전: $values';

  @override
  String personCount(int count) => '$count명';

  @override
  String get importFromAi => '다른 앱에서';

  @override
  String get importFromAiHint => 'ChatGPT, Gemini, Claude 등 AI로 데이터를 변환하세요';

  @override
  String get aiImportTitle => '다른 앱에서 가져오기';

  @override
  String get aiImportIntro =>
      'AI 채팅으로 다른 앱이나 스프레드시트의 데이터를 My Budget이 가져올 수 있는 파일로 바꿀 수 있어요.';

  @override
  String get aiImportStep1 => '프롬프트를 복사하세요.';

  @override
  String get aiImportStep2 =>
      'ChatGPT, Gemini, Claude 등 AI에 붙여넣고 데이터를 첨부하거나 붙여넣으세요.';

  @override
  String get aiImportStep3 => 'AI의 답변을 복사해 여기에 붙여넣거나, 파일로 저장한 뒤 선택하세요.';

  @override
  String get copyPrompt => '프롬프트 복사';

  @override
  String get pasteAnswer => '답변 붙여넣기';

  @override
  String get chooseFile => '파일 선택';

  @override
  String get aiImportPrivacy =>
      '데이터는 선택한 AI 서비스로 전송돼요. 변경 전에 가져올 내용을 먼저 확인할 수 있어요.';

  @override
  String get promptCopied => '프롬프트를 복사했어요';

  @override
  String get askTitle => '지출에 대해 묻기';

  @override
  String get askHint => '질문을 누르면 답을 볼 수 있어요.';

  @override
  String get askCompareMonths => '월 비교';

  @override
  String get askTopCategory => '최다 카테고리';

  @override
  String get askVsLastMonth => '지난달 대비';

  @override
  String get askBiggestExpense => '가장 큰 지출';

  @override
  String get askTopDay => '가장 비싼 날';

  @override
  String get askWeekday => '가장 많이 쓴 요일';

  @override
  String get askMonthEnd => '월말 예상';

  @override
  String get askSaved => '저축했나요?';

  @override
  String get askBudgetLeft => '남은 예산';

  @override
  String get askHighestLowest => '최고·최저 달';

  @override
  String get askCount => '지출 건수';

  @override
  String get askTopIncome => '가장 큰 수입';

  @override
  String get askAi => 'AI에게 묻기';

  @override
  String get assistantTitle => 'AI 도우미';

  @override
  String get assistantEmpty => '최근 3개월 지출에 대해 무엇이든 물어보세요.';

  @override
  String get assistantHint => '질문을 입력하세요';

  @override
  String get assistantSend => '보내기';

  @override
  String get assistantSignInBody =>
      'AI 도우미를 사용하려면 로그인하세요. 계정마다 하루 20개까지 질문할 수 있어요.';

  @override
  String get assistantConsentTitle => '질문하기 전에';

  @override
  String get assistantConsentBody =>
      '답변을 위해 앱은 질문, 최근 메시지, 최근 3개월 합계 요약(카테고리별, 수입, 지출, 예산)을 저희 서버를 거쳐 AI 제공업체 Groq에 보냅니다. 설명, 메모, 사람 이름은 절대 보내지 않아요. 질문과 답변은 저장하지 않으며, 서버는 하루 질문 수만 셉니다. 언제든지 공유를 중지할 수 있어요.';

  @override
  String get assistantConsentAgree => '동의';

  @override
  String get assistantStopSharing => '공유 중지';

  @override
  String get assistantDisclaimer => 'AI 답변은 틀릴 수 있어요. 중요한 숫자는 확인하세요.';

  @override
  List<String> get assistantSuggestions => [
    '어디서 아낄 수 있을까요?',
    '이번 달은 지난달과 비교해 어때요?',
    '예산을 잘 지키고 있나요?',
  ];

  @override
  String get otherCategories => '기타';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      '가장 많이 쓴 곳은 $category: $amount (이번 달의 $percent).';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month에 $other보다 $amount 더 썼어요 (+$percent).';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month에 $other보다 $amount 덜 썼어요 (−$percent).';

  @override
  String answerSpentSame(String month, String other) =>
      '$month와 $other의 지출이 같아요.';

  @override
  String answerNothingIn(String month) => '$month에는 지출이 없어요.';

  @override
  String answerRise(String category, String amount) =>
      '가장 크게 늘어난 곳: $category (+$amount).';

  @override
  String answerDrop(String category, String amount) =>
      '가장 크게 줄어든 곳: $category (−$amount).';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      '가장 큰 지출: $category에서 $amount ($date).';

  @override
  String answerTopDay(String date, String amount) =>
      '가장 비싼 날: $date, $amount 지출.';

  @override
  String answerWeekday(String weekday, String amount) =>
      '가장 많이 쓴 요일: $weekday (이번 달 $amount).';

  @override
  String answerMonthEnd(String amount, String average) =>
      '이 속도라면 (하루 약 $average) 월말까지 약 $amount을 쓰게 돼요.';

  @override
  String answerMonthTotal(String amount) => '이번 달은 끝났어요: 총 $amount을 썼어요.';

  @override
  String answerSaved(String amount, String income) =>
      '수입 $income 중 $amount을 저축했어요.';

  @override
  String answerOverspent(String amount) => '수입보다 $amount 더 썼어요.';

  @override
  String get answerNoIncome => '이번 달 기록된 수입이 없어요.';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      '월 예산이 $amount 남았어요 ($percent 사용).';

  @override
  String answerBudgetOver(String amount) => '월 예산을 $amount 초과했어요.';

  @override
  String get answerNoBudget => '아직 월 예산을 정하지 않았어요.';

  @override
  String answerOverLimit(String names) => '한도 초과: $names.';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => '최고: $high ($highAmount). 최저: $low ($lowAmount).';

  @override
  String answerCount(int count, String average) =>
      '${expenseCount(count)}을 기록했고 평균 $average예요.';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      '수입은 주로 $category에서: $amount ($percent).';

  @override
  String? currencyName(String code) => switch (code) {
    'EGP' => '이집트 파운드',
    'USD' => '미국 달러',
    'EUR' => '유로',
    'SAR' => '사우디 리얄',
    'AED' => '아랍에미리트 디르함',
    'KWD' => '쿠웨이트 디나르',
    'QAR' => '카타르 리얄',
    'BHD' => '바레인 디나르',
    'OMR' => '오만 리알',
    'JOD' => '요르단 디나르',
    'IQD' => '이라크 디나르',
    'LBP' => '레바논 파운드',
    'SYP' => '시리아 파운드',
    'YER' => '예멘 리알',
    'SDG' => '수단 파운드',
    'LYD' => '리비아 디나르',
    'MAD' => '모로코 디르함',
    'TND' => '튀니지 디나르',
    'DZD' => '알제리 디나르',
    'GBP' => '영국 파운드',
    'TRY' => '터키 리라',
    'IRR' => '이란 리알',
    'PKR' => '파키스탄 루피',
    'INR' => '인도 루피',
    'RUB' => '러시아 루블',
    'UAH' => '우크라이나 흐리우냐',
    'PLN' => '폴란드 즐로티',
    'CHF' => '스위스 프랑',
    'BRL' => '브라질 헤알',
    'CAD' => '캐나다 달러',
    'AUD' => '호주 달러',
    'CNY' => '중국 위안',
    'JPY' => '일본 엔',
    'KRW' => '대한민국 원',
    'IDR' => '인도네시아 루피아',
    'MYR' => '말레이시아 링깃',
    'VND' => '베트남 동',
    'NGN' => '나이지리아 나이라',
    _ => null,
  };
}
