import '../../error/failures.dart';
import '../app_strings.dart';

/// Simplified Chinese. Counts take a measure word and no plural form.
class AppStringsZh extends AppStrings {
  const AppStringsZh();

  @override
  String get localeName => 'zh';

  @override
  String get appTitle => '我的预算';

  @override
  String get add => '添加';

  @override
  String get undo => '撤销';

  @override
  String get tryAgain => '重试';

  @override
  String get nothingRecordedYet => '还没有记录';

  @override
  String get emptyMonthHint => '点按“添加”，记下本月第一笔支出或收入。';

  @override
  String get yourMonths => '你的月份';

  @override
  String spentIn(String month) => '$month支出';

  @override
  String expenseCount(int count) => '$count 笔支出';

  @override
  String get quickExpense => '快速记账';

  @override
  String get expenseSaved => '支出已保存';

  @override
  String get newExpense => '新支出';

  @override
  String get editExpense => '编辑支出';

  @override
  String get when => '日期';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get pickADate => '选择日期';

  @override
  String get category => '类别';

  @override
  String get noteOptional => '备注（可选）';

  @override
  String get noteHint => '这笔钱花在哪了？';

  @override
  String get addExpense => '添加支出';

  @override
  String get saveChanges => '保存更改';

  @override
  String get amountHint => '0';

  @override
  String get categories => '类别';

  @override
  String get newCategory => '新类别';

  @override
  String get editCategory => '编辑类别';

  @override
  String get addCategory => '添加类别';

  @override
  String get categoryName => '名称';

  @override
  String get color => '颜色';

  @override
  String get icon => '图标';

  @override
  String get builtIn => '内置';

  @override
  String get custom => '自定义';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String deleteCategoryTitle(String name) => '删除“$name”？';

  @override
  String get deleteCategoryBody => '此类别中的支出将移至“其他”，不会删除任何内容。';

  @override
  String get settings => '设置';

  @override
  String get appearance => '外观';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get currency => '货币';

  @override
  String get currencySymbol => '符号';

  @override
  String get currencySymbolHint => '显示在每个金额旁边';

  @override
  String get currencyOther => '其他';

  @override
  String get reminders => '提醒';

  @override
  String get dailyReminder => '每日提醒';

  @override
  String get dailyReminderHint => '提醒你记录今天的花费';

  @override
  String get reminderTime => '时间';

  @override
  String get notificationsBlocked => '此应用的通知已关闭。请在手机设置中允许通知。';

  @override
  String get reminderNotificationTitle => '记录今天的支出';

  @override
  String get reminderNotificationBody => '花一点时间，添加今天的花费。';

  @override
  String get security => '安全';

  @override
  String get appLock => '应用锁';

  @override
  String get appLockHint => '打开应用时需要指纹、面容或屏幕锁';

  @override
  String get appLockUnavailable => '请先在手机上设置屏幕锁';

  @override
  String get unlock => '解锁';

  @override
  String get unlockToContinue => '解锁以查看你的预算';

  @override
  String get confirmItsYou => '确认是你本人以更改应用锁';

  @override
  String get storedOnThisDevice => '你的支出保存在这台设备上。登录即可备份。';

  @override
  String get account => '账户';

  @override
  String get accountOptional => '账户是可选的。没有账户也能使用全部功能。';

  @override
  String get signIn => '登录';

  @override
  String get signOut => '退出登录';

  @override
  String get signedIn => '已登录';

  @override
  String get createAccount => '创建账户';

  @override
  String get noAccountYet => '还没有账户？立即创建';

  @override
  String get haveAnAccount => '已有账户？登录';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get passwordRules => '至少 6 个字符';

  @override
  String get confirmEmail => '验证你的邮箱';

  @override
  String codeSentTo(String email) => '我们已向 $email 发送验证码。请在下方输入以完成创建账户。';

  @override
  String get confirmationCode => '验证码';

  @override
  String get confirm => '确认';

  @override
  String get resendCode => '重新发送验证码';

  @override
  String get codeResent => '新的验证码已发送';

  @override
  String get useDifferentEmail => '使用其他邮箱';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get resetPassword => '重置密码';

  @override
  String resetCodeSentTo(String email) => '我们已向 $email 发送验证码。请输入验证码并为账户设置新密码。';

  @override
  String get newPassword => '新密码';

  @override
  String get saveNewPassword => '保存新密码';

  @override
  String get backToSignIn => '返回登录';

  @override
  String get backupHint => '备份后，你的支出会在账户中保留一份副本。恢复会把这份副本带回这部手机，不会删除手机上已有的内容。';

  @override
  String get backUpNow => '立即备份';

  @override
  String get autoBackup => '自动备份';

  @override
  String get autoBackupHint => '每次离开应用时，新的更改都会备份到你的账户。';

  @override
  String get restoreData => '恢复';

  @override
  String get backingUp => '正在备份…';

  @override
  String get restoring => '正在恢复…';

  @override
  String get backupDone => '备份完成';

  @override
  String get restoreDone => '恢复完成';

  @override
  String get neverSynced => '尚未备份';

  @override
  String lastSynced(String when) => '上次同步：$when';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteAccountTitle => '删除你的账户？';

  @override
  String get deleteAccountBody =>
      '这会永久删除你的账户及其中保存的支出备份，且无法撤销。这部手机上的支出会保留，你也可以继续在没有账户的情况下使用应用。';

  @override
  String get deletingAccount => '正在删除账户…';

  @override
  String get accountDeleted => '你的账户已删除';

  @override
  String get home => '首页';

  @override
  String get analyses => '分析';

  @override
  String get vsLastMonth => '与上月相比';

  @override
  String get noComparison => '上月无数据';

  @override
  String get dailySpending => '每日支出';

  @override
  String get dailyAverage => '日均';

  @override
  String get topDay => '最高的一天';

  @override
  String get byCategory => '按类别支出';

  @override
  String get noSpendingThisMonth => '本月还没有支出。';

  @override
  String get monthlyTrend => '近 6 个月';

  @override
  String lastMonthTotal(String amount) => '上月：$amount';

  @override
  String get budgets => '预算';

  @override
  String get monthlyBudget => '每月预算';

  @override
  String get setMonthlyBudget => '设置每月预算';

  @override
  String get setBudgetHint => '随时了解剩余额度，超支前收到提醒。';

  @override
  String get setBudget => '设置';

  @override
  String get editBudget => '编辑预算';

  @override
  String get removeBudget => '移除';

  @override
  String get save => '保存';

  @override
  String amountLeft(String amount) => '剩余 $amount';

  @override
  String amountOver(String amount) => '超出预算 $amount';

  @override
  String spentOfLimit(String spent, String limit) => '已用 $spent / $limit';

  @override
  String amountSpent(String amount) => '已用 $amount';

  @override
  String budgetUsed(String percent) => '已用预算 $percent';

  @override
  String get categoryBudgets => '类别预算';

  @override
  String get categoryBudgetsHint => '限制单个类别的支出。';

  @override
  String categoryBudgetTitle(String name) => '“$name”预算';

  @override
  String get setLimit => '设置上限';

  @override
  String get closeToLimit => '接近上限';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      '预算每月重复。支出超过 $nearing 时会提醒你，达到 $reached 时会再提醒一次。';

  @override
  String get budgetAlertTitle => '预算提醒';

  @override
  String get ok => '好';

  @override
  String get view => '查看';

  @override
  String monthlyBudgetNearing(String percent) => '你已用掉每月预算的 $percent';

  @override
  String get monthlyBudgetUsedUp => '你的每月预算已全部用完';

  @override
  String monthlyBudgetExceeded(String amount) => '你已超出每月预算 $amount';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      '你已用掉“$name”预算的 $percent';

  @override
  String categoryBudgetUsedUp(String name) => '你的“$name”预算已全部用完';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      '你已超出“$name”预算 $amount';

  @override
  String get dataManagement => '数据管理';

  @override
  String get dataManagementHint => '由你自己保管的文件。离线可用，无需账户。';

  @override
  String get backUpToFile => '备份我的数据';

  @override
  String get backUpToFileHint => '完整的备份文件，之后可以导入';

  @override
  String get exportCsv => '导出为 CSV';

  @override
  String get exportCsvHint => '用于 Excel 或 Google 表格';

  @override
  String get exportPdf => '导出为 PDF';

  @override
  String get exportPdfHint => '可阅读、打印或分享的报告';

  @override
  String get importData => '导入数据';

  @override
  String get importDataHint => '从备份文件恢复';

  @override
  String get preparingFile => '正在准备文件…';

  @override
  String get importingData => '正在导入…';

  @override
  String get fileSaved => '文件已保存';

  @override
  String get importDone => '导入完成';

  @override
  String get importNothingNew => '这部手机已包含备份中的全部内容';

  @override
  String get fileReady => '文件已准备好';

  @override
  String get shareFile => '分享';

  @override
  String get shareFileHint => 'WhatsApp、邮件、Google 云端硬盘等';

  @override
  String get saveToPhone => '保存到这部手机';

  @override
  String get saveToPhoneHint => '选择保存位置';

  @override
  String get importTitle => '导入此备份？';

  @override
  String get importMergeHint => '“合并”会保留手机上的所有内容并补上缺少的部分。记录不一致时，以较新的修改为准。';

  @override
  String get merge => '合并';

  @override
  String get replaceEverything => '全部替换';

  @override
  String get replaceTitle => '替换这部手机上的所有内容？';

  @override
  String get replaceBody => '手机上不在备份中的内容都会被删除，每条记录都将使用备份中的版本。此操作无法撤销。';

  @override
  String get replace => '替换';

  @override
  String get colDate => '日期';

  @override
  String get colMonth => '月份';

  @override
  String get colAmount => '金额';

  @override
  String get colNote => '备注';

  @override
  String get colId => 'ID';

  @override
  String get colCount => '笔数';

  @override
  String get colTotal => '合计';

  @override
  String get colShare => '占比';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get reportTitle => '我的预算：支出报告';

  @override
  String get reportPeriod => '期间';

  @override
  String get reportTotal => '总支出';

  @override
  String get reportMonthlyAverage => '月均';

  @override
  String get reportByMonth => '按月支出';

  @override
  String get reportAllExpenses => '全部支出';

  @override
  String get reportEmpty => '还没有支出记录。';

  @override
  String get reportPageTemplate => '第 {page} 页，共 {pages} 页';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)}和 ${categoryCount(categories)}'
        : '${expenseCount(expenses)}、${categoryCount(categories)}和 '
              '${personCount(people)}';
    return date == null ? '此备份包含 $contents。' : '$date 的备份：$contents。';
  }

  @override
  String categoryCount(int count) => '$count 个类别';

  @override
  String reportGenerated(String when) => '生成于 $when';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => '餐饮',
    'cat_transport' => '交通',
    'cat_bills' => '账单',
    'cat_shopping' => '购物',
    'cat_health' => '健康健身',
    'cat_entertainment' => '娱乐',
    'cat_work' => '工作',
    'cat_other' => '其他',
    'cat_salary' => '工资',
    'cat_freelance' => '自由职业',
    'cat_investments' => '投资',
    'cat_gifts' => '礼物',
    'cat_income_other' => '其他收入',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => '无法保存到这台设备，请重试。',
    FailureCode.notFound => '该项目已不存在。',
    FailureCode.unknown => '出了点问题。',
    FailureCode.amountRequired => '请输入大于零的金额。',
    FailureCode.amountTooLarge => '金额太大。',
    FailureCode.amountInvalid => '请输入有效金额。',
    FailureCode.categoryRequired => '请选择类别。',
    FailureCode.categoryNameRequired => '请为类别命名。',
    FailureCode.categoryNameTaken => '已有同名分类。',
    FailureCode.categoryNameTooLong => '名称不能超过 30 个字符。',
    FailureCode.categoryProtected => '此类别无法删除。',
    FailureCode.currencySymbolInvalid => '请使用 1 到 4 个字符。',
    FailureCode.network => '无法连接。请检查网络后重试。',
    FailureCode.emailInvalid => '请输入有效的邮箱地址。',
    FailureCode.passwordTooShort => '密码至少需要 6 个字符。',
    FailureCode.invalidCredentials => '邮箱或密码错误。',
    FailureCode.emailTaken => '该邮箱已注册账户。',
    FailureCode.emailNotConfirmed => '请先用我们发送的验证码验证邮箱。',
    FailureCode.codeInvalid => '验证码错误或已过期。',
    FailureCode.signInRequired => '请重新登录后再试一次。',
    FailureCode.syncOtherAccount => '这部手机上的数据已关联到另一个账户。',
    FailureCode.syncFailed => '无法与账户同步，请重试。',
    FailureCode.accountDeletionFailed => '无法删除账户，请重试。',
    FailureCode.backupNotRecognized => '此文件不是“我的预算”备份。',
    FailureCode.pastedNotRecognized =>
      '粘贴的文本不是应用能读取的数据。请复制 AI 的完整回复后重试，或让 AI 修正。',
    FailureCode.backupTooNew => '此备份来自更新版本的“我的预算”。请更新应用后重试。',
    FailureCode.backupDamaged => '备份文件已损坏，因此没有导入任何内容。',
    FailureCode.fileUnavailable => '无法打开该文件，请重新选择。',
    FailureCode.storageFull => '这部手机的可用空间不足。',
    FailureCode.exportFailed => '无法创建文件，请重试。',
    FailureCode.shareUnavailable => '无法打开分享菜单。',
    FailureCode.saveFailed => '无法保存文件，请重试。',
    FailureCode.tooManyAttempts => '尝试次数过多，请稍后再试。',
    FailureCode.titleRequired => '请输入名称。',
    FailureCode.titleTooLong => '名称不能超过 40 个字符。',
    FailureCode.dueDayInvalid => '请选择到期时间。',
    FailureCode.alreadyPaid => '这笔付款已记录。',
    FailureCode.personRequired => '请选择一个人。',
    FailureCode.personNameRequired => '请输入名字。',
    FailureCode.personNameTooLong => '名字不能超过 40 个字符。',
    FailureCode.phoneInvalid => '请输入有效的电话号码。',
    FailureCode.transactionSettled => '已结清的交易无法修改。',
    FailureCode.nothingToSettle => '没有需要结清的内容。',
    FailureCode.settlementAlreadyLogged => '这次结算已记入预算。',
  };

  @override
  String get expenseDeleted => '支出已删除';

  @override
  String get expenseRestored => '支出已恢复';

  @override
  String categoryAdded(String name) => '已添加“$name”';

  @override
  String get categoryUpdated => '类别已更新';

  @override
  String categoryDeleted(String name) => '已删除“$name”';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '已删除“$name”，${expenseCount(count)}已移至“其他”';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '已删除“$name”，${transactionCount(count)}已移至“其他收入”';

  @override
  String get expense => '支出';

  @override
  String get income => '收入';

  @override
  String get search => '搜索';

  @override
  String get searchHint => '搜索备注或金额';

  @override
  String get searchPrompt => '按备注或金额查找任意一笔记录，或按类型、类别和日期筛选。';

  @override
  String get noSearchResults => '没有匹配的记录';

  @override
  String get allTypes => '全部';

  @override
  String get anyCategory => '任意类别';

  @override
  String get anyDate => '任意日期';

  @override
  String get clearFilters => '清除筛选';

  @override
  String get transactionType => '支出还是收入';

  @override
  String get quickIncome => '快速记收入';

  @override
  String get newIncome => '新收入';

  @override
  String get editIncome => '编辑收入';

  @override
  String get addIncome => '添加收入';

  @override
  String get incomeNoteHint => '这笔钱从哪来？';

  @override
  String get totalIncome => '总收入';

  @override
  String get totalExpenses => '总支出';

  @override
  String get netBalance => '净余额';

  @override
  String get savingsRate => '储蓄率';

  @override
  String get savingsRateNoIncome => '添加收入即可查看储蓄率';

  @override
  String get expenseCategories => '支出类别';

  @override
  String get incomeCategories => '收入类别';

  @override
  String get deleteIncomeCategoryBody => '此类别中的收入将移至“其他收入”，不会删除任何内容。';

  @override
  String get incomeDeleted => '收入已删除';

  @override
  String get incomeRestored => '收入已恢复';

  @override
  String get colType => '类型';

  @override
  String transactionCount(int count) => '$count 笔交易';

  @override
  String get recurringPayments => '定期付款';

  @override
  String get newRecurring => '新定期付款';

  @override
  String get editRecurring => '编辑定期付款';

  @override
  String get addRecurring => '添加付款';

  @override
  String get recurringTitle => '名称';

  @override
  String get recurringTitleHint => '房租、Netflix、健身房…';

  @override
  String get amount => '金额';

  @override
  String get repeats => '重复';

  @override
  String get weekly => '每周';

  @override
  String get monthly => '每月';

  @override
  String get yearly => '每年';

  @override
  String get dueOn => '到期日';

  @override
  String get dueDayOfMonth => '每月几号';

  @override
  String get dueMonthLabel => '月份';

  @override
  String get dueDayLabel => '日期';

  @override
  String get shortMonthHint => '天数较少的月份会落在最后一天。';

  @override
  String get whenDue => '到期时';

  @override
  String get autoDeduct => '自动扣款';

  @override
  String get remindMe => '提醒我';

  @override
  String get autoDeductHint => '到期日自动记为一笔支出。';

  @override
  String get remindMeHint => '每笔付款记账前都会请你确认。';

  @override
  String get statusPaid => '已付';

  @override
  String get statusUpcoming => '即将到期';

  @override
  String get statusOverdue => '已逾期';

  @override
  String get markAsPaid => '标为已付';

  @override
  String get dueToday => '今天到期';

  @override
  String dueOnDate(String date) => '$date 到期';

  @override
  String nextDueOn(String date) => '下次：$date';

  @override
  String overdueSince(String date, int count) =>
      count <= 1 ? '$date 已到期' : '自 $date 起逾期 ${paymentCount(count)}';

  @override
  String everyWeekday(String weekday) => '每$weekday';

  @override
  String monthlyOnDay(String day) => '每月 $day 日';

  @override
  String yearlyOn(String date) => '每年 $date';

  @override
  String get monthlyAverage => '每月';

  @override
  String get monthlyAverageHint => '所有定期付款的月均金额';

  @override
  String get noRecurringYet => '还没有定期付款';

  @override
  String get noRecurringHint => '房租、账单和订阅只需添加一次。每个月你都能看到哪些已付、哪些还未付。';

  @override
  String get paymentsToConfirm => '待确认的付款';

  @override
  String get seeAll => '查看全部';

  @override
  String get deleteRecurringBody => '它将不再重复。已记录的付款会保留在你的交易中。';

  @override
  String recurringPaid(String name) => '“$name”已标为已付';

  @override
  String recurringReceived(String name) => '“$name”已标为已收到';

  @override
  String get statusReceived => '已收到';

  @override
  String get markAsReceived => '标为已收';

  @override
  String get autoAdd => '自动入账';

  @override
  String get autoAddHint => '到期日自动记为一笔收入。';

  @override
  String get monthlyIncomeAverage => '每月收入';

  @override
  String get recurringPaymentUndone => '已移除付款';

  @override
  String recurringAutoLogged(int count) => '已自动记录 $count 笔定期付款';

  @override
  String paymentCount(int count) => '$count 笔付款';

  @override
  String get colPaidThrough => '已付至';

  // People & debts

  @override
  String get people => '联系人';

  @override
  String get peopleAndDebts => '联系人与欠款';

  @override
  String get person => '联系人';

  @override
  String get personName => '名字';

  @override
  String get phone => '电话';

  @override
  String get phoneOptional => '电话（可选）';

  @override
  String get balance => '余额';

  @override
  String get colStatus => '状态';

  @override
  String get owesYou => '欠你';

  @override
  String get youOwe => '你欠';

  @override
  String get owedToYou => '别人欠你';

  @override
  String get settledUp => '已结清';

  @override
  String get iPaidForThem => '我替对方付了';

  @override
  String get theyPaidForMe => '对方替我付了';

  @override
  String get theyPaidYou => '对方付给你';

  @override
  String get youPaidThem => '你付给对方';

  @override
  String get openStatus => '未结清';

  @override
  String get settledStatus => '已结清';

  @override
  String get settledOn => '结清于';

  @override
  String get createdOn => '创建于';

  @override
  String get lastEdited => '上次编辑';

  @override
  String get colEdits => '编辑次数';

  @override
  String get activeTransactions => '未结清的交易';

  @override
  String get settledHistory => '结清记录';

  @override
  String get filterAll => '全部';

  @override
  String get filterOwedToMe => '欠我的';

  @override
  String get filterIOwe => '我欠的';

  @override
  String get filterSettled => '已结清';

  @override
  String get addPerson => '添加联系人';

  @override
  String get addPersonHint => '和你分摊费用的人';

  @override
  String get newPerson => '新联系人';

  @override
  String get editPerson => '编辑联系人';

  @override
  String get deletePerson => '删除联系人';

  @override
  String get quickTransaction => '快速记一笔';

  @override
  String get quickTransactionHint => '记录谁付了钱，对象为已添加的联系人';

  @override
  String get noPeopleYet => '还没有联系人';

  @override
  String get noPeopleHint => '添加和你分摊费用的人，随时知道谁欠谁。';

  @override
  String get nobodyHere => '没有符合此筛选条件的人。';

  @override
  String get addPersonFirst => '请先添加联系人。';

  @override
  String get newTransaction => '新交易';

  @override
  String get editTransaction => '编辑交易';

  @override
  String get transactionDetails => '交易详情';

  @override
  String get debtNoteHint => '用于什么？';

  @override
  String get changeHistory => '修改记录';

  @override
  String get edited => '已编辑';

  @override
  String get settleUp => '结清';

  @override
  String get settle => '结清';

  @override
  String get noDebtsYet => '还没有记录';

  @override
  String get noDebtsHint => '记下你替对方付的钱，或对方替你付的钱。';

  @override
  String get settleEven => '这些交易正好相互抵消，无需付款。';

  @override
  String get logSettlementTitle => '将这次结算记入每月预算？';

  @override
  String get loggedInBudget => '已记入预算';

  @override
  String get deleteTransactionTitle => '删除这笔交易？';

  @override
  String get deleteTransactionBody => '它将从与此人的余额中移除。';

  @override
  String get deletePersonBody => '此人的交易和结清记录也会被删除。已记入预算的内容会保留。';

  @override
  String get settledLocked => '已结清，无法再修改。';

  @override
  String get personUpdated => '联系人已更新';

  @override
  String get debtDeleted => '交易已删除';

  @override
  String get settledUpNotice => '已全部结清';

  @override
  String get settlementLogged => '已加入预算';

  @override
  String personOwesYou(String name) => '$name 欠你';

  @override
  String youOwePerson(String name) => '你欠 $name';

  @override
  String settledWith(String name) => '与 $name 已全部结清';

  @override
  String settleUpFor(String amount) => '结清 $amount';

  @override
  String settleTitle(String name) => '与 $name 结清？';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name 付给你 $amount 即可全部结清。';

  @override
  String settleYouPay(String name, String amount) =>
      '你付给 $name $amount 即可全部结清。';

  @override
  String settleMoves(int count) => '${transactionCount(count)}将移至结清记录。';

  @override
  String logSettlementIncome(String amount) =>
      '$amount 将作为收入记入“其他收入”。之后可以移到其他类别。';

  @override
  String logSettlementExpense(String amount) =>
      '$amount 将作为支出记入“其他”。之后可以移到其他类别。';

  @override
  String settlementNote(String name) => '与 $name 结算';

  @override
  String settledGroupTitle(String date) => '结清于 $date';

  @override
  String deletePersonTitle(String name) => '删除 $name？';

  @override
  String editedOn(String date) => '编辑于 $date';

  @override
  String wasValues(String values) => '原为：$values';

  @override
  String personCount(int count) => '$count 人';

  @override
  String get importFromAi => '从其他应用导入';

  @override
  String get importFromAiHint => '用 ChatGPT、Gemini、Claude 或任意 AI 转换你的数据';

  @override
  String get aiImportTitle => '从其他应用导入';

  @override
  String get aiImportIntro => 'AI 聊天可以把其他应用或表格中的数据转换成 My Budget 能导入的文件。';

  @override
  String get aiImportStep1 => '复制提示词。';

  @override
  String get aiImportStep2 => '把它粘贴到 ChatGPT、Gemini、Claude 或任意 AI，并附上或粘贴你的数据。';

  @override
  String get aiImportStep3 => '复制 AI 的回复并粘贴到这里，或保存为文件后选择该文件。';

  @override
  String get copyPrompt => '复制提示词';

  @override
  String get pasteAnswer => '粘贴回复';

  @override
  String get chooseFile => '选择文件';

  @override
  String get aiImportPrivacy => '你的数据会发送给你选择的 AI 服务。在任何更改之前，你会先看到将要导入的内容。';

  @override
  String get promptCopied => '已复制提示词';

  @override
  String get askTitle => '问问你的支出';

  @override
  String get askHint => '点一个问题查看答案。';

  @override
  String get askCompareMonths => '比较月份';

  @override
  String get askTopCategory => '最多的分类';

  @override
  String get askVsLastMonth => '与上月相比';

  @override
  String get askBiggestExpense => '最大一笔支出';

  @override
  String get askTopDay => '花费最多的一天';

  @override
  String get askWeekday => '花费最多的星期';

  @override
  String get askMonthEnd => '月底预估';

  @override
  String get askSaved => '我存钱了吗？';

  @override
  String get askBudgetLeft => '剩余预算';

  @override
  String get askHighestLowest => '最高和最低月份';

  @override
  String get askCount => '支出笔数';

  @override
  String get askTopIncome => '最大收入';

  @override
  String get otherCategories => '其他';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      '花费最多的是 $category：$amount（占本月 $percent）。';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month 比 $other 多花了 $amount（+$percent）。';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month 比 $other 少花了 $amount（−$percent）。';

  @override
  String answerSpentSame(String month, String other) => '$month 和 $other 花费相同。';

  @override
  String answerNothingIn(String month) => '$month 没有支出。';

  @override
  String answerRise(String category, String amount) =>
      '增长最多：$category（+$amount）。';

  @override
  String answerDrop(String category, String amount) =>
      '下降最多：$category（−$amount）。';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      '最大一笔支出：$category $amount（$date）。';

  @override
  String answerTopDay(String date, String amount) => '花费最多的一天：$date，共 $amount。';

  @override
  String answerWeekday(String weekday, String amount) =>
      '花费最多的星期：$weekday（本月 $amount）。';

  @override
  String answerMonthEnd(String amount, String average) =>
      '按此速度（每天约 $average），到月底将花费约 $amount。';

  @override
  String answerMonthTotal(String amount) => '本月已结束：共花费 $amount。';

  @override
  String answerSaved(String amount, String income) =>
      '在 $income 收入中存下了 $amount。';

  @override
  String answerOverspent(String amount) => '支出比收入多 $amount。';

  @override
  String get answerNoIncome => '本月没有收入记录。';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      '月度预算还剩 $amount（已用 $percent）。';

  @override
  String answerBudgetOver(String amount) => '已超出月度预算 $amount。';

  @override
  String get answerNoBudget => '你还没有设置月度预算。';

  @override
  String answerOverLimit(String names) => '超出限额：$names。';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => '最高月份：$high（$highAmount）。最低：$low（$lowAmount）。';

  @override
  String answerCount(int count, String average) =>
      '你记录了 ${expenseCount(count)}，平均每笔 $average。';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      '收入主要来自 $category：$amount（$percent）。';

  @override
  String? currencyName(String code) => switch (code) {
    'EGP' => '埃及镑',
    'USD' => '美元',
    'EUR' => '欧元',
    'SAR' => '沙特里亚尔',
    'AED' => '阿联酋迪拉姆',
    'KWD' => '科威特第纳尔',
    'QAR' => '卡塔尔里亚尔',
    'BHD' => '巴林第纳尔',
    'OMR' => '阿曼里亚尔',
    'JOD' => '约旦第纳尔',
    'IQD' => '伊拉克第纳尔',
    'LBP' => '黎巴嫩镑',
    'SYP' => '叙利亚镑',
    'YER' => '也门里亚尔',
    'SDG' => '苏丹镑',
    'LYD' => '利比亚第纳尔',
    'MAD' => '摩洛哥迪拉姆',
    'TND' => '突尼斯第纳尔',
    'DZD' => '阿尔及利亚第纳尔',
    'GBP' => '英镑',
    'TRY' => '土耳其里拉',
    'IRR' => '伊朗里亚尔',
    'PKR' => '巴基斯坦卢比',
    'INR' => '印度卢比',
    'RUB' => '俄罗斯卢布',
    'UAH' => '乌克兰格里夫纳',
    'PLN' => '波兰兹罗提',
    'CHF' => '瑞士法郎',
    'BRL' => '巴西雷亚尔',
    'CAD' => '加拿大元',
    'AUD' => '澳大利亚元',
    'CNY' => '人民币',
    'JPY' => '日元',
    'KRW' => '韩元',
    'IDR' => '印度尼西亚盾',
    'MYR' => '马来西亚林吉特',
    'VND' => '越南盾',
    'NGN' => '尼日利亚奈拉',
    _ => null,
  };
}
