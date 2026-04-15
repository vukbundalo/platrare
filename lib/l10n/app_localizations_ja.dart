// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'プラトラレ';

  @override
  String get navPlan => 'プラン';

  @override
  String get navTrack => '追跡';

  @override
  String get navReview => 'レビュー';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '消去';

  @override
  String get close => '近い';

  @override
  String get add => '追加';

  @override
  String get undo => '元に戻す';

  @override
  String get confirm => '確認する';

  @override
  String get restore => '復元する';

  @override
  String get heroIn => 'で';

  @override
  String get heroOut => '外';

  @override
  String get heroNet => 'ネット';

  @override
  String get heroBalance => 'バランス';

  @override
  String get realBalance => '実質残高';

  @override
  String get settingsHideHeroBalancesTitle => 'サマリーカードの残高を非表示にする';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'オンにすると、プラン、追跡、レビューの金額は各タブの目のアイコンをタップするまでマスクされます。オフにすると、残高は常に表示されます。';

  @override
  String get heroBalancesShow => '残高を表示';

  @override
  String get heroBalancesHide => '残高を非表示';

  @override
  String get semanticsHeroBalanceHidden => 'プライバシーのため残高は非表示';

  @override
  String get heroResetButton => 'リセット';

  @override
  String get fabScrollToTop => '先頭に戻る';

  @override
  String get filterAll => '全て';

  @override
  String get filterAllAccounts => 'すべてのアカウント';

  @override
  String get filterAllCategories => 'すべてのカテゴリー';

  @override
  String get txLabelIncome => '所得';

  @override
  String get txLabelExpense => '費用';

  @override
  String get txLabelInvoice => '請求書';

  @override
  String get txLabelBill => '請求書';

  @override
  String get txLabelAdvance => '前進';

  @override
  String get txLabelSettlement => '決済';

  @override
  String get txLabelLoan => 'ローン';

  @override
  String get txLabelCollection => 'コレクション';

  @override
  String get txLabelOffset => 'オフセット';

  @override
  String get txLabelTransfer => '移行';

  @override
  String get txLabelTransaction => '取引';

  @override
  String get repeatNone => 'リピートなし';

  @override
  String get repeatDaily => '毎日';

  @override
  String get repeatWeekly => '毎週';

  @override
  String get repeatMonthly => '毎月';

  @override
  String get repeatYearly => '毎年';

  @override
  String get repeatEveryLabel => '毎';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 日',
      one: '日',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 週間',
      one: '週間',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count か月',
      one: 'か月',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 年',
      one: '年',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => '終わり';

  @override
  String get repeatEndNever => '一度もない';

  @override
  String get repeatEndOnDate => 'デート中';

  @override
  String repeatEndAfterCount(int count) {
    return '$count回後';
  }

  @override
  String get repeatEndAfterChoice => '一定回数後';

  @override
  String get repeatEndPickDate => '終了日を選択してください';

  @override
  String get repeatEndTimes => '回';

  @override
  String repeatSummaryEvery(String unit) {
    return '$unitごと';
  }

  @override
  String repeatSummaryUntil(String date) {
    return '$dateまで';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count 回';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$total中$remainingが残っています';
  }

  @override
  String get detailRepeatEvery => '毎回繰り返す';

  @override
  String get detailEnds => '終わり';

  @override
  String get detailEndsNever => '一度もない';

  @override
  String detailEndsOnDate(String date) {
    return '$date に';
  }

  @override
  String detailEndsAfterCount(int count) {
    return '$count回後';
  }

  @override
  String get detailProgress => '進捗';

  @override
  String get weekendNoChange => '変化なし';

  @override
  String get weekendFriday => '金曜日に移動';

  @override
  String get weekendMonday => '月曜日に移動';

  @override
  String weekendQuestion(String day) {
    return '$day が週末の場合は?';
  }

  @override
  String get dateToday => '今日';

  @override
  String get dateTomorrow => '明日';

  @override
  String get dateYesterday => '昨日';

  @override
  String get statsAllTime => 'ずっと';

  @override
  String get accountGroupPersonal => '個人的';

  @override
  String get accountGroupIndividual => '個人';

  @override
  String get accountGroupEntity => '実在物';

  @override
  String get accountSectionIndividuals => '個人';

  @override
  String get accountSectionEntities => 'エンティティ';

  @override
  String get emptyNoTransactionsYet => 'まだ取引はありません';

  @override
  String get emptyNoAccountsYet => 'まだアカウントがありません';

  @override
  String get emptyRecordFirstTransaction => '下のボタンをタップして、最初の取引を記録します。';

  @override
  String get emptyAddFirstAccountTx => '取引を記録する前に、最初のアカウントを追加してください。';

  @override
  String get emptyAddFirstAccountPlan => '取引を計画する前に、最初のアカウントを追加してください。';

  @override
  String get emptyAddFirstAccountReview => '最初のアカウントを追加して、財務状況の追跡を開始します。';

  @override
  String get emptyAddTransaction => 'トランザクションの追加';

  @override
  String get emptyAddAccount => 'アカウントを追加';

  @override
  String get reviewEmptyGroupPersonalTitle => '個人アカウントはまだありません';

  @override
  String get reviewEmptyGroupPersonalBody =>
      '個人アカウントとは、あなた自身の財布や銀行口座のことです。毎日の収入と支出を追跡するには、1 つ追加します。';

  @override
  String get reviewEmptyGroupIndividualsTitle => '個人アカウントはまだありません';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      '個々のアカウントは、共有費用、ローン、借用書など、特定の人々とのお金を追跡します。決済する相手ごとにアカウントを追加します。';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'まだエンティティアカウントがありません';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'エンティティ アカウントは、ビジネス、プロジェクト、または組織用です。これらを使用して、ビジネスのキャッシュフローを個人の財務から切り離して管理します。';

  @override
  String get emptyNoTransactionsForFilters => '適用されたフィルターに対するトランザクションはありません';

  @override
  String get emptyNoTransactionsInHistory => '履歴に取引はありません';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return '$month の取引はありません';
  }

  @override
  String get emptyNoTransactionsForAccount => 'このアカウントでは取引はありません';

  @override
  String get trackTransactionDeleted => 'トランザクションが削除されました';

  @override
  String get trackDeleteTitle => 'トランザクションを削除しますか?';

  @override
  String get trackDeleteBody => 'これにより、アカウント残高の変更が取り消されます。';

  @override
  String get trackTransaction => '取引';

  @override
  String get planConfirmTitle => '取引を確認しますか?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'このイベントは $date に予定されています。今日の日付 ($todayDate) とともに履歴に​​記録されます。次の発生は $nextDate に残ります。';
  }

  @override
  String get planConfirmBodyNormal => 'これにより、トランザクションが実際の口座残高に適用され、履歴に移動されます。';

  @override
  String get planTransactionConfirmed => 'トランザクションが確認され、適用されました';

  @override
  String get planTransactionRemoved => '計画されたトランザクションが削除されました';

  @override
  String get planRepeatingTitle => '繰り返し取引';

  @override
  String get planRepeatingBody =>
      'この日付のみをスキップするか、シリーズは次の日付に続きます。または、残りの日付をすべて計画から削除します。';

  @override
  String get planDeleteAll => 'すべて削除';

  @override
  String get planSkipThisOnly => 'これだけはスキップしてください';

  @override
  String get planOccurrenceSkipped => 'このイベントはスキップされました - 次のイベントが予定されています';

  @override
  String get planNothingPlanned => '今のところ何も予定はありません';

  @override
  String get planPlanBody => '今後の取引を計画します。';

  @override
  String get planAddPlan => 'プランの追加';

  @override
  String get planNoPlannedForFilters => '適用されたフィルターに対して計画されたトランザクションはありません';

  @override
  String planNoPlannedInMonth(String month) {
    return '$month には予定されている取引はありません';
  }

  @override
  String get planOverdue => '期限を過ぎた';

  @override
  String get planPlannedTransaction => '予定されている取引';

  @override
  String get discardTitle => '変更を破棄しますか?';

  @override
  String get discardBody => '未保存の変更があります。今出発するとそれらは失われてしまいます。';

  @override
  String get keepEditing => '編集を続ける';

  @override
  String get discard => '破棄';

  @override
  String get newTransactionTitle => '新しいトランザクション';

  @override
  String get editTransactionTitle => 'トランザクションの編集';

  @override
  String get transactionUpdated => 'トランザクションが更新されました';

  @override
  String get sectionAccounts => 'アカウント';

  @override
  String get labelFrom => 'から';

  @override
  String get labelTo => 'に';

  @override
  String get sectionCategory => 'カテゴリ';

  @override
  String get sectionAttachments => '添付ファイル';

  @override
  String get labelNote => '注記';

  @override
  String get hintOptionalDescription => 'オプションの説明';

  @override
  String get updateTransaction => 'トランザクションの更新';

  @override
  String get saveTransaction => 'トランザクションの保存';

  @override
  String get selectAccount => 'アカウントの選択';

  @override
  String get selectAccountTitle => 'アカウントの選択';

  @override
  String get noAccountsAvailable => '利用可能なアカウントがありません';

  @override
  String amountReceivedBy(String name, String currency) {
    return '$name ($currency) までに受け取った金額';
  }

  @override
  String get amountReceivedHelper =>
      '宛先アカウントが受け取る正確な金額を入力します。これにより、使用される実際の為替レートがロックされます。';

  @override
  String get attachTakePhoto => '写真を撮る';

  @override
  String get attachTakePhotoSub => 'カメラを使用してレシートを撮影する';

  @override
  String get attachChooseGallery => 'ギャラリーから選ぶ';

  @override
  String get attachChooseGallerySub => 'ライブラリから写真を選択してください';

  @override
  String get attachBrowseFiles => 'ファイルを参照する';

  @override
  String get attachBrowseFilesSub => 'PDF、ドキュメント、またはその他のファイルを添付する';

  @override
  String get attachButton => '添付する';

  @override
  String get editPlanTitle => '計画の編集';

  @override
  String get planTransactionTitle => '計画トランザクション';

  @override
  String get tapToSelect => 'タップして選択します';

  @override
  String get updatePlan => '計画を更新する';

  @override
  String get addToPlan => 'プランに追加';

  @override
  String get labelRepeat => '繰り返す';

  @override
  String get selectPlannedDate => '予定日を選択してください';

  @override
  String get balancesAsOfToday => '本日時点の残高';

  @override
  String get projectedBalancesForTomorrow => '明日の予想残高';

  @override
  String projectedBalancesForDate(String date) {
    return '$date の予想残高';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name が ($currency) を受信します';
  }

  @override
  String get destHelper => '推定目的地金額。正確なレートは確認時にロックされます。';

  @override
  String get descriptionOptional => '説明 (オプション)';

  @override
  String get detailTransactionTitle => '取引';

  @override
  String get detailPlannedTitle => '計画済み';

  @override
  String get detailConfirmTransaction => '取引の確認';

  @override
  String get detailDate => '日付';

  @override
  String get detailFrom => 'から';

  @override
  String get detailTo => 'に';

  @override
  String get detailCategory => 'カテゴリ';

  @override
  String get detailNote => '注記';

  @override
  String get detailDestinationAmount => '宛先金額';

  @override
  String get detailExchangeRate => '為替レート';

  @override
  String get detailRepeats => '繰り返し';

  @override
  String get detailDayOfMonth => '月の日';

  @override
  String get detailWeekends => '週末';

  @override
  String get detailAttachments => '添付ファイル';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ファイル',
      one: '1 ファイル',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSectionDisplay => '画面';

  @override
  String get settingsSectionLanguage => '言語';

  @override
  String get settingsSectionCategories => 'カテゴリー';

  @override
  String get settingsSectionAccounts => 'アカウント';

  @override
  String get settingsSectionPreferences => '設定';

  @override
  String get settingsSectionManage => '管理';

  @override
  String get settingsBaseCurrency => '自国通貨';

  @override
  String get settingsSecondaryCurrency => '二次通貨';

  @override
  String get settingsCategories => 'カテゴリー';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount 収入 · $expenseCount 支出';
  }

  @override
  String get settingsArchivedAccounts => 'アーカイブされたアカウント';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      '現在はありません — 残高が明確になったらアカウント編集からアーカイブします';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count レビューとピッカーから非表示に';
  }

  @override
  String get settingsSectionData => 'データ';

  @override
  String get settingsSectionPrivacy => 'について';

  @override
  String get settingsPrivacyPolicyTitle => 'プライバシーポリシー';

  @override
  String get settingsPrivacyPolicySubtitle => 'Platrare によるデータの処理方法。';

  @override
  String get settingsPrivacyFxDisclosure =>
      '為替レート: アプリはインターネット経由で公的通貨レートを取得します。あなたのアカウントとトランザクションは決して送信されません。';

  @override
  String get settingsPrivacyOpenFailed => 'プライバシー ポリシーを読み込めませんでした。';

  @override
  String get settingsPrivacyRetry => 'もう一度やり直してください';

  @override
  String get settingsSoftwareVersionTitle => 'ソフトウェアバージョン';

  @override
  String get settingsSoftwareVersionSubtitle => 'リリース、診断、法的事項';

  @override
  String get aboutScreenTitle => 'について';

  @override
  String get aboutAppTagline => '元帳、キャッシュフロー、計画を 1 つのワークスペースで実行できます。';

  @override
  String get aboutDescriptionBody =>
      'Platrare はアカウント、トランザクション、プランをデバイス上に保存します。別の場所にコピーが必要な場合は、暗号化されたバックアップをエクスポートします。為替レートは公開市場データのみを使用します。台帳がアップロードされていません。';

  @override
  String get aboutVersionLabel => 'バージョン';

  @override
  String get aboutBuildLabel => '建てる';

  @override
  String get aboutCopySupportDetails => 'サポートの詳細をコピーする';

  @override
  String get aboutOpenPrivacySubtitle => '完全なアプリ内ポリシー文書を開きます。';

  @override
  String get aboutSupportBundleLocaleLabel => 'ロケール';

  @override
  String get settingsSupportInfoCopied => 'クリップボードにコピーされました';

  @override
  String get settingsVerifyLedger => 'データの検証';

  @override
  String get settingsVerifyLedgerSubtitle => '口座残高が取引履歴と一致していることを確認してください';

  @override
  String get settingsDataExportTitle => 'バックアップのエクスポート';

  @override
  String get settingsDataExportSubtitle =>
      'すべてのデータと添付ファイルを含む .zip または暗号化された .platrare として保存します';

  @override
  String get settingsDataImportTitle => 'バックアップから復元する';

  @override
  String get settingsDataImportSubtitle =>
      'Platrare .zip または .platrare バックアップから現在のデータを置き換えます';

  @override
  String get backupExportDialogTitle => 'このバックアップを保護する';

  @override
  String get backupExportDialogBody =>
      '特にファイルをクラウドに保存する場合は、強力なパスワードを使用することをお勧めします。インポートするには同じパスワードが必要です。';

  @override
  String get backupExportPasswordLabel => 'パスワード';

  @override
  String get backupExportPasswordConfirmLabel => 'パスワードを認証する';

  @override
  String get backupExportPasswordMismatch => 'パスワードが一致しません';

  @override
  String get backupExportPasswordEmpty => '一致するパスワードを入力するか、以下に暗号化せずにエクスポートします。';

  @override
  String get backupExportPasswordTooShort => 'パスワードは 8 文字以上である必要があります。';

  @override
  String get backupExportSaveToDevice => 'デバイスに保存';

  @override
  String get backupExportShareToCloud => '共有 (iCloud、ドライブなど)';

  @override
  String get backupExportWithoutEncryption => '暗号化せずにエクスポートする';

  @override
  String get backupExportSkipWarningTitle => '暗号化せずにエクスポートしますか?';

  @override
  String get backupExportSkipWarningBody =>
      'ファイルにアクセスできる人は誰でもデータを読み取ることができます。これは、あなたが管理するローカル コピーに対してのみ使用してください。';

  @override
  String get backupExportSkipWarningConfirm => '暗号化せずにエクスポートする';

  @override
  String get backupImportPasswordTitle => '暗号化されたバックアップ';

  @override
  String get backupImportPasswordBody => 'エクスポート時に使用したパスワードを入力します。';

  @override
  String get backupImportPasswordLabel => 'パスワード';

  @override
  String get backupImportPreviewTitle => 'バックアップの概要';

  @override
  String backupImportPreviewVersion(String version) {
    return 'アプリのバージョン: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'エクスポート済み: $date';
  }

  @override
  String backupImportPreviewCounts(
    int accounts,
    int transactions,
    int planned,
    int attachments,
    int income,
    int expense,
  ) {
    return '$accounts アカウント · $transactions トランザクション · $planned 計画済み · $attachments 添付ファイル · $income 収入カテゴリ · $expense 支出カテゴリ';
  }

  @override
  String get backupImportPreviewContinue => '続く';

  @override
  String get settingsBackupWrongPassword => 'パスワードが間違っています';

  @override
  String get settingsBackupChecksumMismatch => 'バックアップの整合性チェックに失敗しました';

  @override
  String get settingsBackupCorruptFile => 'バックアップファイルが無効または破損しています';

  @override
  String get settingsBackupUnsupportedVersion => 'バックアップには新しいアプリバージョンが必要です';

  @override
  String get settingsDataImportConfirmTitle => '現在のデータを置き換えますか?';

  @override
  String get settingsDataImportConfirmBody =>
      'これにより、現在のアカウント、トランザクション、計画されたトランザクション、カテゴリ、およびインポートされた添付ファイルが、選択したバックアップの内容に置き換えられます。この操作は元に戻すことができません。';

  @override
  String get settingsDataImportConfirmAction => 'データを置き換える';

  @override
  String get settingsDataImportDone => 'データは正常に復元されました';

  @override
  String get settingsDataImportInvalidFile =>
      'このファイルは有効な Platrare バックアップではありません';

  @override
  String get settingsDataImportFailed => 'インポートに失敗しました';

  @override
  String get settingsDataExportDoneTitle => 'バックアップがエクスポートされました';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'バックアップの保存場所:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'ファイルを開く';

  @override
  String get settingsDataExportFailed => 'エクスポートに失敗しました';

  @override
  String get ledgerVerifyDialogTitle => '台帳検証';

  @override
  String get ledgerVerifyAllMatch => 'すべてのアカウントが一致します。';

  @override
  String get ledgerVerifyMismatchesTitle => '不一致';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\n保存場所: $stored\nリプレイ: $replayed\n違い: $diff';
  }

  @override
  String get settingsLanguage => 'アプリ言語';

  @override
  String get settingsLanguageSubtitleSystem => '以下のシステム設定';

  @override
  String get settingsLanguageSubtitleEnglish => '英語';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'セルビア語 (ラテン語)';

  @override
  String get settingsLanguagePickerTitle => 'アプリ言語';

  @override
  String get settingsLanguageOptionSystem => 'システムのデフォルト';

  @override
  String get settingsLanguageOptionEnglish => '英語';

  @override
  String get settingsLanguageOptionSerbianLatin => 'セルビア語 (ラテン語)';

  @override
  String get settingsSectionAppearance => '外観';

  @override
  String get settingsSectionSecurity => '安全';

  @override
  String get settingsSecurityEnableLock => '開いたときにアプリをロックする';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'アプリを開くときに生体認証によるロック解除または PIN を要求する';

  @override
  String get settingsSecurityLockDelayTitle => 'バックグラウンド後に再ロック';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      '再度ロック解除が必要になるまでアプリが画面外にある時間。即時が最も強力です。';

  @override
  String get settingsSecurityLockDelayImmediate => '即時';

  @override
  String get settingsSecurityLockDelay30s => '30秒';

  @override
  String get settingsSecurityLockDelay1m => '1分';

  @override
  String get settingsSecurityLockDelay5m => '5分';

  @override
  String get settingsSecuritySetPin => '暗証番号を設定する';

  @override
  String get settingsSecurityChangePin => 'PINの変更';

  @override
  String get settingsSecurityPinSubtitle =>
      '生体認証が利用できない場合は、フォールバックとして PIN を使用する';

  @override
  String get settingsSecurityRemovePin => 'PIN を削除する';

  @override
  String get securitySetPinTitle => 'アプリのPINを設定する';

  @override
  String get securityPinLabel => 'PINコード';

  @override
  String get securityConfirmPinLabel => 'PINコードを確認する';

  @override
  String get securityPinMustBe4Digits => 'PIN は 4 桁以上である必要があります';

  @override
  String get securityPinMismatch => 'PINコードが一致しません';

  @override
  String get securityRemovePinTitle => 'PIN を削除しますか?';

  @override
  String get securityRemovePinBody => '利用可能な場合は、生体認証によるロック解除も引き続き使用できます。';

  @override
  String get securityUnlockTitle => 'アプリがロックされています';

  @override
  String get securityUnlockSubtitle => 'Face ID、指紋、または PIN でロックを解除します。';

  @override
  String get securityUnlockWithPin => 'PINでロックを解除する';

  @override
  String get securityTryBiometric => '生体認証によるロック解除を試す';

  @override
  String get securityPinIncorrect => 'PIN が間違っています。もう一度お試しください';

  @override
  String get securityBiometricReason => '認証してアプリを開く';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeSubtitleSystem => '以下のシステム設定';

  @override
  String get settingsThemeSubtitleLight => 'ライト';

  @override
  String get settingsThemeSubtitleDark => '暗い';

  @override
  String get settingsThemePickerTitle => 'テーマ';

  @override
  String get settingsThemeOptionSystem => 'システムのデフォルト';

  @override
  String get settingsThemeOptionLight => 'ライト';

  @override
  String get settingsThemeOptionDark => '暗い';

  @override
  String get archivedAccountsTitle => 'アーカイブされたアカウント';

  @override
  String get archivedAccountsEmptyTitle => 'アーカイブされたアカウントはありません';

  @override
  String get archivedAccountsEmptyBody =>
      '帳簿残高と当座貸越はゼロでなければなりません。レビューのアカウントからアーカイブするオプション。';

  @override
  String get categoriesTitle => 'カテゴリー';

  @override
  String get newCategoryTitle => '新しいカテゴリー';

  @override
  String get categoryNameLabel => 'カテゴリ名';

  @override
  String get deleteCategoryTitle => 'カテゴリを削除しますか?';

  @override
  String deleteCategoryBody(String category) {
    return '「$category」はリストから削除されます。';
  }

  @override
  String get categoryIncome => '所得';

  @override
  String get categoryExpense => '費用';

  @override
  String get categoryAdd => '追加';

  @override
  String get searchCurrencies => '通貨を検索…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1年';

  @override
  String get periodAll => '全て';

  @override
  String get categoryLabel => 'カテゴリ';

  @override
  String get categoriesLabel => 'カテゴリ';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type 保存しました • $amount';
  }

  @override
  String get tooltipSettings => '設定';

  @override
  String get tooltipAddAccount => 'アカウントを追加';

  @override
  String get tooltipRemoveAccount => 'アカウントを削除する';

  @override
  String get accountNameTaken =>
      'この名前と識別子のアカウント (アクティブまたはアーカイブ済み) がすでにあります。名前または識別子を変更します。';

  @override
  String get groupDescPersonal => '自分の財布と銀行口座';

  @override
  String get groupDescIndividuals => '家族、友人、個人';

  @override
  String get groupDescEntities => 'エンティティ、公益事業者、組織';

  @override
  String get cannotArchiveTitle => 'まだアーカイブできません';

  @override
  String get cannotArchiveBody => 'アーカイブは、帳簿残高と当座貸越限度額が両方とも実質的にゼロの場合にのみ使用できます。';

  @override
  String get cannotArchiveBodyAdjust =>
      'アーカイブは、帳簿残高と当座貸越限度額が両方とも実質的にゼロの場合にのみ使用できます。まず台帳または施設を調整します。';

  @override
  String get archiveAccountTitle => 'アーカイブアカウント?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の予定取引がこの口座を参照しています。',
      one: '1 件の予定取引がこの口座を参照しています。',
    );
    return '$_temp0 アーカイブされた口座と計画の整合性を保つために削除してください。';
  }

  @override
  String get removeAndArchive => '計画を削除してアーカイブする';

  @override
  String get archiveBody => 'アカウントはレビュー、追跡、および計画ピッカーから非表示になります。設定から復元できます。';

  @override
  String get archiveAction => 'アーカイブ';

  @override
  String get archiveInstead => '代わりにアーカイブする';

  @override
  String get cannotDeleteTitle => 'アカウントを削除できません';

  @override
  String get cannotDeleteBodyShort =>
      'このアカウントはトラック履歴に表示されます。まずそれらのトランザクションを削除または再割り当てするか、残高がクリアされている場合はアカウントをアーカイブします。';

  @override
  String get cannotDeleteBodyHistory =>
      'このアカウントはトラック履歴に表示されます。削除すると履歴が壊れます。最初にそれらのトランザクションを削除するか再割り当てしてください。';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'このアカウントはトラック履歴に表示されるため、削除できません。帳簿残高と当座貸越が解消された場合は、代わりにアーカイブすることができます。リストには表示されませんが、履歴はそのまま残ります。';

  @override
  String get deleteAccountTitle => 'アカウントを削除しますか?';

  @override
  String get deleteAccountBodyPermanent => 'このアカウントは完全に削除されます。';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の予定取引がこの口座を参照しており、削除されます。',
      one: '1 件の予定取引がこの口座を参照しており、削除されます。',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'すべて削除';

  @override
  String get editAccountTitle => 'アカウントの編集';

  @override
  String get newAccountTitle => '新しいアカウント';

  @override
  String get labelAccountName => 'アカウント名';

  @override
  String get labelAccountIdentifier => '識別子 (オプション)';

  @override
  String get accountAppearanceSection => 'アイコンと色';

  @override
  String get accountPickIcon => 'アイコンを選択';

  @override
  String get accountPickColor => '色を選択してください';

  @override
  String get accountIconSheetTitle => 'アカウントアイコン';

  @override
  String get accountColorSheetTitle => 'アカウントの色';

  @override
  String get searchAccountIcons => '名前でアイコンを検索…';

  @override
  String get accountIconSearchNoMatches => 'その検索に一致するアイコンはありません。';

  @override
  String get accountUseInitialLetter => '頭文字';

  @override
  String get accountUseDefaultColor => 'マッチグループ';

  @override
  String get labelRealBalance => '実質残高';

  @override
  String get labelOverdraftLimit => '当座貸越/前払い限度額';

  @override
  String get labelCurrency => '通貨';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get addAccountAction => 'アカウントの追加';

  @override
  String get removeAccountSheetTitle => 'アカウントを削除する';

  @override
  String get deletePermanently => '完全に削除';

  @override
  String get deletePermanentlySubtitle =>
      'このアカウントが Track で使用されていない場合にのみ可能です。計画されたアイテムは、削除の一部として削除できます。';

  @override
  String get archiveOptionSubtitle =>
      'レビューやピッカーから非表示にします。設定からいつでも復元できます。ゼロ残高と当座貸越が必要です。';

  @override
  String get archivedBannerText =>
      'このアカウントはアーカイブされています。データには残りますが、リストやピッカーには表示されません。';

  @override
  String get balanceAdjustedTitle => 'Trackでバランス調整';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return '実質残高が $previous から $current $symbol に更新されました。\n\n元帳の一貫性を保つために、残高調整トランザクションが追跡 (履歴) に作成されました。\n\n• 実際の残高は、このアカウントの実際の金額を反映します。\n• 調整エントリの履歴を確認します。';
  }

  @override
  String get ok => 'わかりました';

  @override
  String get categoryBalanceAdjustment => 'バランス調整';

  @override
  String get descriptionBalanceCorrection => 'バランス補正';

  @override
  String get descriptionOpeningBalance => '期首残高';

  @override
  String get reviewStatsModeStatistics => '統計';

  @override
  String get reviewStatsModeComparison => '比較';

  @override
  String get statsUncategorized => '未分類';

  @override
  String get statsNoCategories => '選択した期間には比較対象のカテゴリがありません。';

  @override
  String get statsNoTransactions => '取引なし';

  @override
  String get statsSpendingInCategory => 'このカテゴリーでの支出';

  @override
  String get statsIncomeInCategory => 'このカテゴリーの収入';

  @override
  String get statsDifference => '違い (B 対 A):';

  @override
  String get statsNoExpensesMonth => '今月は出費なし';

  @override
  String get statsNoExpensesAll => '経費は記録されていません';

  @override
  String statsNoExpensesPeriod(String period) {
    return '最後 $period には経費はかかりません';
  }

  @override
  String get statsTotalSpent => '支出総額';

  @override
  String get statsNoExpensesThisPeriod => 'この期間は経費はかかりません';

  @override
  String get statsNoIncomeMonth => '今月は収入がない';

  @override
  String get statsNoIncomeAll => '収入は記録されていない';

  @override
  String statsNoIncomePeriod(String period) {
    return '最後 $period は収入なし';
  }

  @override
  String get statsTotalReceived => '受け取った合計';

  @override
  String get statsNoIncomeThisPeriod => 'この期間は収入がない';

  @override
  String get catSalary => '給料';

  @override
  String get catFreelance => 'フリーランス';

  @override
  String get catConsulting => 'コンサルティング';

  @override
  String get catGift => '贈り物';

  @override
  String get catRental => 'レンタル';

  @override
  String get catDividends => '配当金';

  @override
  String get catRefund => '返金';

  @override
  String get catBonus => 'ボーナス';

  @override
  String get catInterest => '興味';

  @override
  String get catSideHustle => 'サイドハッスル';

  @override
  String get catSaleOfGoods => 'グッズの販売';

  @override
  String get catOther => '他の';

  @override
  String get catGroceries => '食料品';

  @override
  String get catDining => 'ダイニング';

  @override
  String get catTransport => '輸送';

  @override
  String get catUtilities => '公共事業';

  @override
  String get catHousing => 'ハウジング';

  @override
  String get catHealthcare => '健康管理';

  @override
  String get catEntertainment => 'エンターテインメント';

  @override
  String get catShopping => '買い物';

  @override
  String get catTravel => '旅行';

  @override
  String get catEducation => '教育';

  @override
  String get catSubscriptions => '定期購入';

  @override
  String get catInsurance => '保険';

  @override
  String get catFuel => '燃料';

  @override
  String get catGym => 'ジム';

  @override
  String get catPets => 'ペット';

  @override
  String get catKids => 'キッズ';

  @override
  String get catCharity => 'チャリティー';

  @override
  String get catCoffee => 'コーヒー';

  @override
  String get catGifts => 'ギフト';

  @override
  String semanticsProjectionDate(String date) {
    return '予測日 $date。ダブルタップして日付を選択します';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return '予測される個人残高 $amount';
  }

  @override
  String get statsEmptyTitle => 'まだ取引はありません';

  @override
  String get statsEmptySubtitle => '選択した範囲には支出データがありません。';

  @override
  String get semanticsShowProjections => '口座ごとに予想残高を表示';

  @override
  String get semanticsHideProjections => '口座ごとの予想残高を非表示にする';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Show account balances for this day';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Hide account balances for this day';

  @override
  String get semanticsDateAllTime => '日付: 常時 — タップしてモードを変更します';

  @override
  String semanticsDateMode(String mode) {
    return '日付: $mode — タップしてモードを変更します';
  }

  @override
  String get semanticsDateThisMonth => '日付: 今月 — 月、週、年、またはすべての期間をタップします';

  @override
  String get semanticsTxTypeCycle => '取引タイプ：サイクルオール、収入、支出、振替';

  @override
  String get semanticsAccountFilter => 'アカウントフィルター';

  @override
  String get semanticsAlreadyFiltered => 'すでにこのアカウントにフィルタリングされています';

  @override
  String get semanticsCategoryFilter => 'カテゴリフィルター';

  @override
  String get semanticsSortToggle => '並べ替え: 新しい順または古い順を切り替えます';

  @override
  String get semanticsFiltersDisabled =>
      '将来の予測日を表示しているときにリスト フィルターが無効になります。フィルターを使用するには投影をクリアします。';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'リストフィルターが無効になっています。まずアカウントを追加します。';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'リストフィルターが無効になっています。まず計画されたトランザクションを追加します。';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'リストフィルターが無効になっています。まずトランザクションを記録します。';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'セクションと通貨の管理が無効になっています。まずアカウントを追加します。';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      '予測日と残高の内訳は無効になっています。まずアカウントと計画されたトランザクションを追加します。';

  @override
  String get semanticsReorderAccountHint => '長押ししてからドラッグし、このグループ内で順序を変更します';

  @override
  String get semanticsChartStyle => 'グラフのスタイル';

  @override
  String get semanticsChartStyleUnavailable => 'グラフのスタイル (比較モードでは使用できません)';

  @override
  String semanticsPeriod(String label) {
    return '期間: $label';
  }

  @override
  String get trackSearchHint => '説明、カテゴリ、アカウントを検索…';

  @override
  String get trackSearchClear => '検索をクリア';

  @override
  String get settingsExchangeRatesTitle => '為替レート';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return '最終更新日: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'オフライン料金またはバンドル料金の使用 — タップして更新';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => '為替レートが更新されました';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      '為替レートを更新できませんでした。接続を確認してください。';

  @override
  String get settingsClearData => 'データのクリア';

  @override
  String get settingsClearDataSubtitle => '選択したデータを完全に削除します';

  @override
  String get clearDataTitle => 'データのクリア';

  @override
  String get clearDataTransactions => '取引履歴';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count 取引 · 口座残高がゼロにリセット';
  }

  @override
  String get clearDataPlanned => '計画的な取引';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count予定アイテム';
  }

  @override
  String get clearDataAccounts => 'アカウント';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count アカウント · 履歴とプランもクリアします';
  }

  @override
  String get clearDataCategories => 'カテゴリー';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count カテゴリ · デフォルトに置き換えられました';
  }

  @override
  String get clearDataPreferences => '設定';

  @override
  String get clearDataPreferencesSubtitle => '通貨、テーマ、言語をデフォルトにリセットする';

  @override
  String get clearDataSecurity => 'アプリロックとPIN';

  @override
  String get clearDataSecuritySubtitle => 'アプリロックを無効にしてPINを削除する';

  @override
  String get clearDataConfirmButton => '選択をクリア';

  @override
  String get clearDataConfirmTitle => 'これは元に戻すことはできません';

  @override
  String get clearDataConfirmBody =>
      '選択したデータは完全に削除されます。後で必要になる可能性がある場合は、最初にバックアップをエクスポートしてください。';

  @override
  String get clearDataTypeConfirm => '「DELETE」と入力して確認します';

  @override
  String get clearDataTypeConfirmError => '続行するには DELETE を正確に入力してください';

  @override
  String get clearDataPinTitle => 'PINで確認';

  @override
  String get clearDataPinBody => 'このアクションを承認するには、アプリの PIN を入力してください。';

  @override
  String get clearDataPinIncorrect => '間違ったPIN';

  @override
  String get clearDataDone => '選択したデータがクリアされました';

  @override
  String get autoBackupTitle => '毎日の自動バックアップ';

  @override
  String autoBackupLastAt(String date) {
    return '最後にバックアップしたのは $date';
  }

  @override
  String get autoBackupNeverRun => 'まだバックアップがありません';

  @override
  String get autoBackupShareTitle => 'クラウドに保存';

  @override
  String get autoBackupShareSubtitle =>
      '最新のバックアップを iCloud Drive、Google Drive、または任意のアプリにアップロード';

  @override
  String get autoBackupCloudReminder =>
      '自動バックアップの準備ができています - オフデバイス保護のためにクラウドに保存します';

  @override
  String get autoBackupCloudReminderAction => '共有';

  @override
  String get settingsBackupReminderTitle => 'バックアップリマインダー';

  @override
  String get settingsBackupReminderSubtitle =>
      '手動バックアップをエクスポートせずに多くの取引を追加した場合のアプリ内バナー。';

  @override
  String get settingsBackupReminderThresholdTitle => 'トランザクション閾値';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return '最後の手動エクスポートから$count件の新しい取引後にリマインド。';
  }

  @override
  String get settingsBackupReminderThresholdInvalid => '1から500の整数を入力してください。';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '「後でリマインド」は$n件の取引を追加するまでバナーを非表示にします。';
  }

  @override
  String get backupReminderBannerTitle => 'バックアップをエクスポートしますか？';

  @override
  String backupReminderBannerBody(int count) {
    return '最後の手動エクスポートから$count件の取引を追加しました。';
  }

  @override
  String get backupReminderRemindLater => '後でリマインド';

  @override
  String get backupExportLedgerVerifyTitle => 'Ledger check before backup';

  @override
  String get backupExportLedgerVerifyInfo =>
      'This compares each account’s stored balance to a full replay of your history. You can export a backup either way; mismatches are informational.';

  @override
  String get backupExportLedgerVerifyContinue => 'Continue to backup';

  @override
  String get persistenceErrorReloaded => '変更を保存できませんでした。データがストレージから再ロードされました。';
}
