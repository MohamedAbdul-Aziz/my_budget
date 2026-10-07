import '../../error/failures.dart';
import '../app_strings.dart';

/// Japanese. Counts take a counter word and no plural form.
class AppStringsJa extends AppStrings {
  const AppStringsJa();

  @override
  String get localeName => 'ja';

  @override
  String get appTitle => 'マイ予算';

  @override
  String get add => '追加';

  @override
  String get undo => '元に戻す';

  @override
  String get tryAgain => '再試行';

  @override
  String get nothingRecordedYet => 'まだ記録がありません';

  @override
  String get emptyMonthHint => '「追加」をタップして、今月最初の支出や収入を記録しましょう。';

  @override
  String get yourMonths => '月一覧';

  @override
  String spentIn(String month) => '$monthの支出';

  @override
  String expenseCount(int count) => '支出 $count 件';

  @override
  String get quickExpense => 'クイック支出';

  @override
  String get expenseSaved => '支出を保存しました';

  @override
  String get newExpense => '新しい支出';

  @override
  String get editExpense => '支出を編集';

  @override
  String get when => '日付';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get pickADate => '日付を選択';

  @override
  String get category => 'カテゴリ';

  @override
  String get noteOptional => 'メモ（任意）';

  @override
  String get noteHint => '何に使いましたか？';

  @override
  String get addExpense => '支出を追加';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get amountHint => '0';

  @override
  String get categories => 'カテゴリ';

  @override
  String get newCategory => '新しいカテゴリ';

  @override
  String get editCategory => 'カテゴリを編集';

  @override
  String get addCategory => 'カテゴリを追加';

  @override
  String get categoryName => '名前';

  @override
  String get color => '色';

  @override
  String get icon => 'アイコン';

  @override
  String get builtIn => '標準';

  @override
  String get custom => 'カスタム';

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String deleteCategoryTitle(String name) => '「$name」を削除しますか？';

  @override
  String get deleteCategoryBody => 'このカテゴリの支出は「その他」に移動します。何も削除されません。';

  @override
  String get settings => '設定';

  @override
  String get appearance => '外観';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get languageSystem => 'システム';

  @override
  String get currency => '通貨';

  @override
  String get currencySymbol => '記号';

  @override
  String get currencySymbolHint => 'すべての金額の横に表示されます';

  @override
  String get reminders => 'リマインダー';

  @override
  String get dailyReminder => '毎日のリマインダー';

  @override
  String get dailyReminderHint => '今日の支出を記録するためのお知らせ';

  @override
  String get reminderTime => '時刻';

  @override
  String get notificationsBlocked => 'このアプリの通知がオフになっています。端末の設定で許可してください。';

  @override
  String get reminderNotificationTitle => '今日の支出を記録しましょう';

  @override
  String get reminderNotificationBody => '少し時間をとって、今日使ったお金を追加しましょう。';

  @override
  String get security => 'セキュリティ';

  @override
  String get appLock => 'アプリロック';

  @override
  String get appLockHint => 'アプリを開くときに指紋・顔・画面ロックを求めます';

  @override
  String get appLockUnavailable => '先にこの端末で画面ロックを設定してください';

  @override
  String get unlock => 'ロック解除';

  @override
  String get unlockToContinue => 'ロックを解除して予算を表示';

  @override
  String get confirmItsYou => 'アプリロックを変更するには本人確認をしてください';

  @override
  String get storedOnThisDevice => '支出はこの端末に保存されています。バックアップするにはログインしてください。';

  @override
  String get account => 'アカウント';

  @override
  String get accountOptional => 'アカウントは任意です。なくてもすべての機能を使えます。';

  @override
  String get signIn => 'ログイン';

  @override
  String get signOut => 'ログアウト';

  @override
  String get signedIn => 'ログイン中';

  @override
  String get createAccount => 'アカウントを作成';

  @override
  String get noAccountYet => 'アカウントをお持ちでない方は作成';

  @override
  String get haveAnAccount => 'アカウントをお持ちの方はログイン';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get passwordRules => '6 文字以上';

  @override
  String get confirmEmail => 'メールアドレスを確認';

  @override
  String codeSentTo(String email) =>
      '$email にコードを送信しました。下に入力してアカウントの作成を完了してください。';

  @override
  String get confirmationCode => 'コード';

  @override
  String get confirm => '確認';

  @override
  String get resendCode => '新しいコードを送信';

  @override
  String get codeResent => '新しいコードを送信しました';

  @override
  String get useDifferentEmail => '別のメールアドレスを使う';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get resetPassword => 'パスワードの再設定';

  @override
  String resetCodeSentTo(String email) =>
      '$email にコードを送信しました。コードとアカウントの新しいパスワードを入力してください。';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get saveNewPassword => '新しいパスワードを保存';

  @override
  String get backToSignIn => 'ログインに戻る';

  @override
  String get backupHint =>
      'バックアップすると支出のコピーがアカウントに保存されます。復元すると、この端末にある記録を消さずにコピーを取り戻せます。';

  @override
  String get backUpNow => '今すぐバックアップ';

  @override
  String get autoBackup => '自動バックアップ';

  @override
  String get autoBackupHint => 'アプリを離れるたびに、新しい変更がアカウントにバックアップされます。';

  @override
  String get restoreData => '復元';

  @override
  String get backingUp => 'バックアップ中…';

  @override
  String get restoring => '復元中…';

  @override
  String get backupDone => 'バックアップが完了しました';

  @override
  String get restoreDone => '復元が完了しました';

  @override
  String get neverSynced => 'まだバックアップしていません';

  @override
  String lastSynced(String when) => '最終同期：$when';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get deleteAccountTitle => 'アカウントを削除しますか？';

  @override
  String get deleteAccountBody =>
      'アカウントと、そこに保存された支出のバックアップが完全に削除されます。元に戻すことはできません。この端末の支出は残り、アカウントなしでアプリを使い続けられます。';

  @override
  String get deletingAccount => 'アカウントを削除しています…';

  @override
  String get accountDeleted => 'アカウントを削除しました';

  @override
  String get home => 'ホーム';

  @override
  String get analyses => '分析';

  @override
  String get vsLastMonth => '先月との比較';

  @override
  String get noComparison => '先月のデータなし';

  @override
  String get dailySpending => '日別の支出';

  @override
  String get dailyAverage => '1 日平均';

  @override
  String get topDay => '最も多い日';

  @override
  String get byCategory => 'カテゴリ別の支出';

  @override
  String get noSpendingThisMonth => '今月の支出はまだありません。';

  @override
  String get monthlyTrend => '過去 6 か月';

  @override
  String lastMonthTotal(String amount) => '先月：$amount';

  @override
  String get budgets => '予算';

  @override
  String get monthlyBudget => '月間予算';

  @override
  String get setMonthlyBudget => '月間予算を設定';

  @override
  String get setBudgetHint => '残りの金額がわかり、使いすぎる前にお知らせします。';

  @override
  String get setBudget => '設定';

  @override
  String get editBudget => '予算を編集';

  @override
  String get removeBudget => '削除';

  @override
  String get save => '保存';

  @override
  String amountLeft(String amount) => '残り $amount';

  @override
  String amountOver(String amount) => '予算を $amount 超過';

  @override
  String spentOfLimit(String spent, String limit) => '$limit のうち $spent 使用';

  @override
  String amountSpent(String amount) => '$amount 使用';

  @override
  String budgetUsed(String percent) => '予算の $percent を使用';

  @override
  String get categoryBudgets => 'カテゴリ予算';

  @override
  String get categoryBudgetsHint => '1 つのカテゴリの支出に上限を設けます。';

  @override
  String categoryBudgetTitle(String name) => '「$name」の予算';

  @override
  String get setLimit => '上限を設定';

  @override
  String get closeToLimit => '上限に近いカテゴリ';

  @override
  String budgetsRepeatHint(String nearing, String reached) =>
      '予算は毎月繰り返されます。支出が $nearing を超えたときと、$reached に達したときにお知らせします。';

  @override
  String get budgetAlertTitle => '予算のお知らせ';

  @override
  String get ok => 'OK';

  @override
  String get view => '表示';

  @override
  String monthlyBudgetNearing(String percent) => '月間予算の $percent を使いました';

  @override
  String get monthlyBudgetUsedUp => '月間予算をすべて使いました';

  @override
  String monthlyBudgetExceeded(String amount) => '月間予算を $amount 超えています';

  @override
  String categoryBudgetNearing(String name, String percent) =>
      '「$name」の予算の $percent を使いました';

  @override
  String categoryBudgetUsedUp(String name) => '「$name」の予算をすべて使いました';

  @override
  String categoryBudgetExceeded(String name, String amount) =>
      '「$name」の予算を $amount 超えています';

  @override
  String get dataManagement => 'データ管理';

  @override
  String get dataManagementHint => '自分で保管するファイルです。オフラインでもアカウントなしでも使えます。';

  @override
  String get backUpToFile => 'データをバックアップ';

  @override
  String get backUpToFileHint => '後で読み込める完全なバックアップファイル';

  @override
  String get exportCsv => 'CSV で書き出す';

  @override
  String get exportCsvHint => 'Excel や Google スプレッドシート用';

  @override
  String get exportPdf => 'PDF で書き出す';

  @override
  String get exportPdfHint => '読む・印刷する・共有するためのレポート';

  @override
  String get importData => 'データを読み込む';

  @override
  String get importDataHint => 'バックアップファイルから復元';

  @override
  String get preparingFile => 'ファイルを準備しています…';

  @override
  String get importingData => '読み込み中…';

  @override
  String get fileSaved => 'ファイルを保存しました';

  @override
  String get importDone => '読み込みが完了しました';

  @override
  String get importNothingNew => 'この端末にはバックアップの内容がすべてありました';

  @override
  String get fileReady => 'ファイルの準備ができました';

  @override
  String get shareFile => '共有';

  @override
  String get shareFileHint => 'WhatsApp、メール、Google ドライブなど';

  @override
  String get saveToPhone => 'この端末に保存';

  @override
  String get saveToPhoneHint => '保存先を選ぶ';

  @override
  String get importTitle => 'このバックアップを読み込みますか？';

  @override
  String get importMergeHint =>
      '「結合」は端末上のデータをすべて残し、足りないものを追加します。内容が異なる記録は、新しい変更が優先されます。';

  @override
  String get merge => '結合';

  @override
  String get replaceEverything => 'すべて置き換える';

  @override
  String get replaceTitle => 'この端末のデータをすべて置き換えますか？';

  @override
  String get replaceBody =>
      'バックアップにないデータはこの端末から削除され、すべての記録がバックアップの内容になります。元に戻すことはできません。';

  @override
  String get replace => '置き換える';

  @override
  String get colDate => '日付';

  @override
  String get colMonth => '月';

  @override
  String get colAmount => '金額';

  @override
  String get colNote => 'メモ';

  @override
  String get colId => 'ID';

  @override
  String get colCount => '件数';

  @override
  String get colTotal => '合計';

  @override
  String get colShare => '割合';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get reportTitle => 'マイ予算：支出レポート';

  @override
  String get reportPeriod => '期間';

  @override
  String get reportTotal => '支出合計';

  @override
  String get reportMonthlyAverage => '月平均';

  @override
  String get reportByMonth => '月別の支出';

  @override
  String get reportAllExpenses => 'すべての支出';

  @override
  String get reportEmpty => 'まだ支出の記録がありません。';

  @override
  String get reportPageTemplate => '{page} / {pages} ページ';

  @override
  String importSummary(
    String? date,
    int expenses,
    int categories, {
    int people = 0,
  }) {
    final contents = people == 0
        ? '${expenseCount(expenses)}、${categoryCount(categories)}'
        : '${expenseCount(expenses)}、${categoryCount(categories)}、'
              '${personCount(people)}';
    return date == null ? 'このバックアップの内容：$contents。' : '$date のバックアップ：$contents。';
  }

  @override
  String categoryCount(int count) => 'カテゴリ $count 件';

  @override
  String reportGenerated(String when) => '$when 作成';

  @override
  String get showPassword => 'パスワードを表示';

  @override
  String get hidePassword => 'パスワードを隠す';

  @override
  String? defaultCategoryName(String id) => switch (id) {
    'cat_food' => '食費',
    'cat_transport' => '交通費',
    'cat_bills' => '公共料金',
    'cat_shopping' => '買い物',
    'cat_health' => '健康・フィットネス',
    'cat_entertainment' => '娯楽',
    'cat_work' => '仕事',
    'cat_other' => 'その他',
    'cat_salary' => '給与',
    'cat_freelance' => '副業',
    'cat_investments' => '投資',
    'cat_gifts' => '贈り物',
    'cat_income_other' => 'その他の収入',
    _ => null,
  };

  @override
  String failure(FailureCode code) => switch (code) {
    FailureCode.database => 'この端末に保存できませんでした。もう一度お試しください。',
    FailureCode.notFound => 'その項目はもう存在しません。',
    FailureCode.unknown => '問題が発生しました。',
    FailureCode.amountRequired => '0 より大きい金額を入力してください。',
    FailureCode.amountTooLarge => '金額が大きすぎます。',
    FailureCode.amountInvalid => '正しい金額を入力してください。',
    FailureCode.categoryRequired => 'カテゴリを選んでください。',
    FailureCode.categoryNameRequired => 'カテゴリに名前を付けてください。',
    FailureCode.categoryNameTooLong => '名前は 30 文字未満にしてください。',
    FailureCode.categoryProtected => 'このカテゴリは削除できません。',
    FailureCode.currencySymbolInvalid => '1〜4 文字で入力してください。',
    FailureCode.network => '接続できませんでした。インターネット接続を確認して、もう一度お試しください。',
    FailureCode.emailInvalid => '正しいメールアドレスを入力してください。',
    FailureCode.passwordTooShort => 'パスワードは 6 文字以上にしてください。',
    FailureCode.invalidCredentials => 'メールアドレスまたはパスワードが違います。',
    FailureCode.emailTaken => 'このメールアドレスのアカウントはすでにあります。',
    FailureCode.emailNotConfirmed => '先ほどお送りしたコードでメールアドレスを確認してください。',
    FailureCode.codeInvalid => 'コードが間違っているか、有効期限が切れています。',
    FailureCode.signInRequired => 'もう一度ログインしてからお試しください。',
    FailureCode.syncOtherAccount => 'この端末のデータは別のアカウントに紐づいています。',
    FailureCode.syncFailed => 'アカウントと同期できませんでした。もう一度お試しください。',
    FailureCode.accountDeletionFailed => 'アカウントを削除できませんでした。もう一度お試しください。',
    FailureCode.backupNotRecognized => 'このファイルはマイ予算のバックアップではありません。',
    FailureCode.backupTooNew =>
      'このバックアップは新しいバージョンのマイ予算で作成されました。アプリを更新してからお試しください。',
    FailureCode.backupDamaged => 'バックアップファイルが壊れているため、何も読み込まれませんでした。',
    FailureCode.fileUnavailable => 'ファイルを開けませんでした。もう一度選んでください。',
    FailureCode.storageFull => 'この端末の空き容量が足りません。',
    FailureCode.exportFailed => 'ファイルを作成できませんでした。もう一度お試しください。',
    FailureCode.shareUnavailable => '共有メニューを開けませんでした。',
    FailureCode.saveFailed => 'ファイルを保存できませんでした。もう一度お試しください。',
    FailureCode.tooManyAttempts => '試行回数が多すぎます。しばらくしてからお試しください。',
    FailureCode.titleRequired => '名前を付けてください。',
    FailureCode.titleTooLong => '名前は 40 文字未満にしてください。',
    FailureCode.dueDayInvalid => '支払日を選んでください。',
    FailureCode.alreadyPaid => 'その支払いはすでに記録されています。',
    FailureCode.personRequired => '相手を選んでください。',
    FailureCode.personNameRequired => '名前を入力してください。',
    FailureCode.personNameTooLong => '名前は 40 文字未満にしてください。',
    FailureCode.phoneInvalid => '正しい電話番号を入力してください。',
    FailureCode.transactionSettled => '精算済みの取引は変更できません。',
    FailureCode.nothingToSettle => '精算するものはありません。',
    FailureCode.settlementAlreadyLogged => 'この精算はすでに予算に記録されています。',
  };

  @override
  String get expenseDeleted => '支出を削除しました';

  @override
  String get expenseRestored => '支出を元に戻しました';

  @override
  String categoryAdded(String name) => '「$name」を追加しました';

  @override
  String get categoryUpdated => 'カテゴリを更新しました';

  @override
  String categoryDeleted(String name) => '「$name」を削除しました';

  @override
  String categoryDeletedWithMoves(String name, int count) =>
      '「$name」を削除し、${expenseCount(count)}を「その他」に移動しました';

  @override
  String incomeCategoryDeletedWithMoves(String name, int count) =>
      '「$name」を削除し、${transactionCount(count)}を「その他の収入」に移動しました';

  @override
  String get expense => '支出';

  @override
  String get income => '収入';

  @override
  String get search => '検索';

  @override
  String get searchHint => 'メモや金額で検索';

  @override
  String get searchPrompt => 'メモや金額で記録を探すか、種類・カテゴリ・日付で絞り込みます。';

  @override
  String get noSearchResults => '一致する記録はありません';

  @override
  String get allTypes => 'すべて';

  @override
  String get anyCategory => 'すべてのカテゴリ';

  @override
  String get anyDate => 'すべての日付';

  @override
  String get clearFilters => '絞り込みを解除';

  @override
  String get transactionType => '支出か収入か';

  @override
  String get quickIncome => 'クイック収入';

  @override
  String get newIncome => '新しい収入';

  @override
  String get editIncome => '収入を編集';

  @override
  String get addIncome => '収入を追加';

  @override
  String get incomeNoteHint => 'どこからの収入ですか？';

  @override
  String get totalIncome => '収入合計';

  @override
  String get totalExpenses => '支出合計';

  @override
  String get netBalance => '収支';

  @override
  String get savingsRate => '貯蓄率';

  @override
  String get savingsRateNoIncome => '収入を追加すると貯蓄率が表示されます';

  @override
  String get expenseCategories => '支出カテゴリ';

  @override
  String get incomeCategories => '収入カテゴリ';

  @override
  String get deleteIncomeCategoryBody => 'このカテゴリの収入は「その他の収入」に移動します。何も削除されません。';

  @override
  String get incomeDeleted => '収入を削除しました';

  @override
  String get incomeRestored => '収入を元に戻しました';

  @override
  String get colType => '種類';

  @override
  String transactionCount(int count) => '取引 $count 件';

  @override
  String get recurringPayments => '定期支払い';

  @override
  String get newRecurring => '新しい定期支払い';

  @override
  String get editRecurring => '定期支払いを編集';

  @override
  String get addRecurring => '支払いを追加';

  @override
  String get recurringTitle => '名前';

  @override
  String get recurringTitleHint => '家賃、Netflix、ジム…';

  @override
  String get amount => '金額';

  @override
  String get repeats => '繰り返し';

  @override
  String get weekly => '毎週';

  @override
  String get monthly => '毎月';

  @override
  String get yearly => '毎年';

  @override
  String get dueOn => '支払日';

  @override
  String get dueDayOfMonth => '毎月の日付';

  @override
  String get dueMonthLabel => '月';

  @override
  String get dueDayLabel => '日';

  @override
  String get shortMonthHint => '日数の少ない月は月末になります。';

  @override
  String get whenDue => '支払日になったら';

  @override
  String get autoDeduct => '自動引き落とし';

  @override
  String get remindMe => '通知する';

  @override
  String get autoDeductHint => '支払日に自動で支出として記録されます。';

  @override
  String get remindMeHint => '記録する前に、支払いごとに確認します。';

  @override
  String get statusPaid => '支払済み';

  @override
  String get statusUpcoming => '予定';

  @override
  String get statusOverdue => '期限切れ';

  @override
  String get markAsPaid => '支払済み';

  @override
  String get dueToday => '今日が支払日';

  @override
  String dueOnDate(String date) => '支払日 $date';

  @override
  String nextDueOn(String date) => '次回 $date';

  @override
  String overdueSince(String date, int count) =>
      count <= 1 ? '支払日は $date でした' : '$date から ${paymentCount(count)}が未払い';

  @override
  String everyWeekday(String weekday) => '毎週$weekday';

  @override
  String monthlyOnDay(String day) => '毎月 $day 日';

  @override
  String yearlyOn(String date) => '毎年 $date';

  @override
  String get monthlyAverage => '月あたり';

  @override
  String get monthlyAverageHint => 'すべての定期支払いの月平均';

  @override
  String get noRecurringYet => '定期支払いはまだありません';

  @override
  String get noRecurringHint => '家賃、公共料金、サブスクを一度登録するだけ。毎月、支払済みのものとまだのものがわかります。';

  @override
  String get paymentsToConfirm => '確認待ちの支払い';

  @override
  String get seeAll => 'すべて表示';

  @override
  String get deleteRecurringBody => '今後は繰り返されません。記録済みの支払いは取引に残ります。';

  @override
  String recurringPaid(String name) => '「$name」を支払済みにしました';

  @override
  String recurringReceived(String name) => '「$name」を受取済みにしました';

  @override
  String get statusReceived => '受取済み';

  @override
  String get markAsReceived => '受取済み';

  @override
  String get autoAdd => '自動で記録';

  @override
  String get autoAddHint => '予定日に自動で収入として記録されます。';

  @override
  String get monthlyIncomeAverage => '月あたりの収入';

  @override
  String get recurringPaymentUndone => '支払いを取り消しました';

  @override
  String recurringAutoLogged(int count) => '定期支払い $count 件を自動で記録しました';

  @override
  String paymentCount(int count) => '支払い $count 件';

  @override
  String get colPaidThrough => '支払済みの期限';

  // People & debts

  @override
  String get people => '相手';

  @override
  String get peopleAndDebts => '貸し借り';

  @override
  String get person => '相手';

  @override
  String get personName => '名前';

  @override
  String get phone => '電話番号';

  @override
  String get phoneOptional => '電話番号（任意）';

  @override
  String get balance => '残高';

  @override
  String get colStatus => '状態';

  @override
  String get owesYou => 'あなたへの借り';

  @override
  String get youOwe => 'あなたの借り';

  @override
  String get owedToYou => '貸している額';

  @override
  String get settledUp => '精算済み';

  @override
  String get iPaidForThem => '自分が立て替えた';

  @override
  String get theyPaidForMe => '相手が立て替えた';

  @override
  String get theyPaidYou => '相手から受け取った';

  @override
  String get youPaidThem => '相手に支払った';

  @override
  String get openStatus => '未精算';

  @override
  String get settledStatus => '精算済み';

  @override
  String get settledOn => '精算日';

  @override
  String get createdOn => '作成日';

  @override
  String get lastEdited => '最終編集';

  @override
  String get colEdits => '編集回数';

  @override
  String get activeTransactions => '未精算の取引';

  @override
  String get settledHistory => '精算履歴';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterOwedToMe => '貸し';

  @override
  String get filterIOwe => '借り';

  @override
  String get filterSettled => '精算済み';

  @override
  String get addPerson => '相手を追加';

  @override
  String get addPersonHint => '費用を分け合う相手';

  @override
  String get newPerson => '新しい相手';

  @override
  String get editPerson => '相手を編集';

  @override
  String get deletePerson => '相手を削除';

  @override
  String get quickTransaction => 'クイック取引';

  @override
  String get quickTransactionHint => '追加済みの相手と、どちらが払ったかを記録';

  @override
  String get noPeopleYet => 'まだ相手がいません';

  @override
  String get noPeopleHint => '費用を分け合う相手を追加すると、誰が誰にいくら借りているかを管理できます。';

  @override
  String get nobodyHere => 'この絞り込みに該当する相手はいません。';

  @override
  String get addPersonFirst => '先に相手を追加してください。';

  @override
  String get newTransaction => '新しい取引';

  @override
  String get editTransaction => '取引を編集';

  @override
  String get transactionDetails => '取引の詳細';

  @override
  String get debtNoteHint => '何の費用ですか？';

  @override
  String get changeHistory => '変更履歴';

  @override
  String get edited => '編集済み';

  @override
  String get settleUp => '精算する';

  @override
  String get settle => '精算';

  @override
  String get noDebtsYet => 'まだ記録がありません';

  @override
  String get noDebtsHint => '相手の分を立て替えた金額や、相手が立て替えてくれた金額を追加します。';

  @override
  String get settleEven => 'これらの取引は相殺されるため、お金のやり取りは不要です。';

  @override
  String get logSettlementTitle => 'この精算を月間予算に記録しますか？';

  @override
  String get loggedInBudget => '予算に記録済み';

  @override
  String get deleteTransactionTitle => 'この取引を削除しますか？';

  @override
  String get deleteTransactionBody => 'この相手との残高から取り除かれます。';

  @override
  String get deletePersonBody => 'この相手の取引と精算履歴も削除されます。予算に記録した分は残ります。';

  @override
  String get settledLocked => '精算済みのため、変更できません。';

  @override
  String get personUpdated => '相手を更新しました';

  @override
  String get debtDeleted => '取引を削除しました';

  @override
  String get settledUpNotice => 'すべて精算しました';

  @override
  String get settlementLogged => '予算に追加しました';

  @override
  String personOwesYou(String name) => '$name さんへの貸し';

  @override
  String youOwePerson(String name) => '$name さんへの借り';

  @override
  String settledWith(String name) => '$name さんとはすべて精算済み';

  @override
  String settleUpFor(String amount) => '$amount を精算';

  @override
  String settleTitle(String name) => '$name さんと精算しますか？';

  @override
  String settleTheyPay(String name, String amount) =>
      '$name さんがあなたに $amount 払うと、すべて精算されます。';

  @override
  String settleYouPay(String name, String amount) =>
      'あなたが $name さんに $amount 払うと、すべて精算されます。';

  @override
  String settleMoves(int count) => '${transactionCount(count)}が精算履歴に移動します。';

  @override
  String logSettlementIncome(String amount) =>
      '$amount が「その他の収入」に収入として追加されます。あとで別のカテゴリに移動できます。';

  @override
  String logSettlementExpense(String amount) =>
      '$amount が「その他」に支出として追加されます。あとで別のカテゴリに移動できます。';

  @override
  String settlementNote(String name) => '$name さんとの精算';

  @override
  String settledGroupTitle(String date) => '$date に精算';

  @override
  String deletePersonTitle(String name) => '$name さんを削除しますか？';

  @override
  String editedOn(String date) => '$date に編集';

  @override
  String wasValues(String values) => '変更前：$values';

  @override
  String personCount(int count) => '$count 人';

  @override
  String get askTitle => '支出について質問';

  @override
  String get askHint => '質問をタップすると答えが表示されます。';

  @override
  String get askCompareMonths => '月を比較';

  @override
  String get askTopCategory => '最多カテゴリ';

  @override
  String get askVsLastMonth => '先月との比較';

  @override
  String get askBiggestExpense => '最大の支出';

  @override
  String get askTopDay => '最も高い日';

  @override
  String get askWeekday => '最も使う曜日';

  @override
  String get askMonthEnd => '月末の予測';

  @override
  String get askSaved => '貯金できた？';

  @override
  String get askBudgetLeft => '残りの予算';

  @override
  String get askHighestLowest => '最高と最低の月';

  @override
  String get askCount => '支出の件数';

  @override
  String get askTopIncome => '最大の収入';

  @override
  String get otherCategories => 'その他';

  @override
  String answerTopCategory(String category, String amount, String percent) =>
      '最も使ったのは $category：$amount（今月の $percent）。';

  @override
  String answerSpentMore(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month は $other より $amount 多く使いました（+$percent）。';

  @override
  String answerSpentLess(
    String month,
    String other,
    String amount,
    String percent,
  ) => '$month は $other より $amount 少なく使いました（−$percent）。';

  @override
  String answerSpentSame(String month, String other) =>
      '$month と $other の支出は同じです。';

  @override
  String answerNothingIn(String month) => '$month の支出はありません。';

  @override
  String answerRise(String category, String amount) =>
      '最も増えた：$category（+$amount）。';

  @override
  String answerDrop(String category, String amount) =>
      '最も減った：$category（−$amount）。';

  @override
  String answerBiggestExpense(String amount, String category, String date) =>
      '最大の支出：$category で $amount（$date）。';

  @override
  String answerTopDay(String date, String amount) => '最も高い日：$date、$amount。';

  @override
  String answerWeekday(String weekday, String amount) =>
      '最も使う曜日：$weekday（今月 $amount）。';

  @override
  String answerMonthEnd(String amount, String average) =>
      'このペース（1日約 $average）だと、月末までに約 $amount になります。';

  @override
  String answerMonthTotal(String amount) => '今月は終了しました：合計 $amount。';

  @override
  String answerSaved(String amount, String income) =>
      '収入 $income のうち $amount を貯金しました。';

  @override
  String answerOverspent(String amount) => '収入より $amount 多く使いました。';

  @override
  String get answerNoIncome => '今月の収入はありません。';

  @override
  String answerBudgetLeft(String amount, String percent) =>
      '月の予算は残り $amount です（$percent 使用）。';

  @override
  String answerBudgetOver(String amount) => '月の予算を $amount 超えています。';

  @override
  String get answerNoBudget => '月の予算はまだ設定されていません。';

  @override
  String answerOverLimit(String names) => '上限超過：$names。';

  @override
  String answerHighestLowest(
    String high,
    String highAmount,
    String low,
    String lowAmount,
  ) => '最高の月：$high（$highAmount）。最低：$low（$lowAmount）。';

  @override
  String answerCount(int count, String average) =>
      '${expenseCount(count)}を記録、平均 $average。';

  @override
  String answerTopIncome(String category, String amount, String percent) =>
      '収入の多くは $category から：$amount（$percent）。';
}
