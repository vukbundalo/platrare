// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '普拉特拉雷';

  @override
  String get navPlan => '计划';

  @override
  String get navTrack => '追踪';

  @override
  String get navReview => '审查';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get close => '关闭';

  @override
  String get add => '添加';

  @override
  String get undo => '撤消';

  @override
  String get confirm => '确认';

  @override
  String get restore => '恢复';

  @override
  String get heroIn => '在';

  @override
  String get heroOut => '出去';

  @override
  String get heroNet => '网';

  @override
  String get widgetLowestPoint => '最低点';

  @override
  String get widgetProjected => '预计';

  @override
  String get widgetHorizonIn7Days => '7 天后';

  @override
  String get widgetHorizonEndOfMonth => '月末';

  @override
  String get widgetMetricAccount => '账户余额';

  @override
  String get widgetQuickAdd => '快速添加';

  @override
  String get widgetStale => '可能不是最新';

  @override
  String get widgetOpenToStart => '打开 Platrare 添加账户';

  @override
  String get widgetDueToday => '今天到期';

  @override
  String get widgetDescQuickAdd => '一键添加交易或计划。';

  @override
  String get widgetNameNumbers => '余额';

  @override
  String get widgetDescNumbers => '显示一个数字：可用余额、净资产或本月最低点。';

  @override
  String get widgetConfigMetric => '指标';

  @override
  String get widgetConfigHorizon => '时间范围';

  @override
  String widgetSiriAddTransaction(String appName) {
    return '在 $appName 中添加交易';
  }

  @override
  String widgetSiriAddPlanned(String appName) {
    return '在 $appName 中添加计划交易';
  }

  @override
  String get settingsWidgetAmountsTitle => '在小组件中显示金额';

  @override
  String get settingsWidgetAmountsSubtitle =>
      '主屏幕小组件无需解锁应用即可查看。启用应用锁时，除非开启此项，否则金额将保持隐藏。';

  @override
  String get heroBalance => '平衡';

  @override
  String get realBalance => '实际余额';

  @override
  String get settingsHideHeroBalancesTitle => '在摘要卡片中隐藏余额';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      '开启后，计划、追踪和评审中的金额将保持隐藏，直到您点击每个标签上的眼睛图标。关闭后，余额始终可见。';

  @override
  String get heroBalancesShow => '显示余额';

  @override
  String get heroBalancesHide => '隐藏余额';

  @override
  String get semanticsHeroBalanceHidden => '余额已隐藏以保护隐私';

  @override
  String get heroResetButton => '重置';

  @override
  String get fabScrollToTop => '返回顶部';

  @override
  String get fabPickProjectionDate => '选择预测日期';

  @override
  String get filterAll => '全部';

  @override
  String get filterAllAccounts => '所有账户';

  @override
  String get filterAllCategories => '所有类别';

  @override
  String get txLabelIncome => '收入';

  @override
  String get txLabelExpense => '费用';

  @override
  String get txLabelInvoice => '发票';

  @override
  String get txLabelBill => '账单';

  @override
  String get txLabelAdvance => '进步';

  @override
  String get txLabelSettlement => '沉降';

  @override
  String get txLabelLoan => '贷款';

  @override
  String get txLabelCollection => '收藏';

  @override
  String get txLabelOffset => '抵消';

  @override
  String get txLabelTransfer => '转移';

  @override
  String get txLabelTransaction => '交易';

  @override
  String get repeatNone => '不重复';

  @override
  String get repeatDaily => '日常的';

  @override
  String get repeatWeekly => '每周';

  @override
  String get repeatMonthly => '每月';

  @override
  String get repeatYearly => '每年';

  @override
  String get repeatEveryLabel => '每一个';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
      one: '天',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 周',
      one: '周',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个月',
      one: '个月',
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
  String get repeatEndLabel => '结束';

  @override
  String get repeatEndNever => '绝不';

  @override
  String get repeatEndOnDate => '约会时';

  @override
  String repeatEndAfterCount(int count) {
    return '$count次后';
  }

  @override
  String get repeatEndAfterChoice => '若干次后';

  @override
  String get repeatEndPickDate => '选择结束日期';

  @override
  String get repeatEndTimes => '次';

  @override
  String repeatSummaryEvery(String unit) {
    return '每$unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return '直到$date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count次';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '剩余 $total 的 $remaining';
  }

  @override
  String get detailRepeatEvery => '重复每个';

  @override
  String get detailEnds => '结束';

  @override
  String get detailEndsNever => '绝不';

  @override
  String detailEndsOnDate(String date) {
    return '在$date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return '$count次后';
  }

  @override
  String get detailProgress => '进步';

  @override
  String get weekendNoChange => '没有变化';

  @override
  String get weekendFriday => '移至周五';

  @override
  String get weekendMonday => '移至星期一';

  @override
  String weekendQuestion(String day) {
    return '如果$day恰逢周末？';
  }

  @override
  String get dateToday => '今天';

  @override
  String get dateTomorrow => '明天';

  @override
  String get dateYesterday => '昨天';

  @override
  String get statsAllTime => '所有时间';

  @override
  String get accountGroupPersonal => '个人的';

  @override
  String get accountGroupIndividual => '个人';

  @override
  String get accountGroupEntity => '实体';

  @override
  String get accountSectionIndividuals => '个人';

  @override
  String get accountSectionEntities => '实体';

  @override
  String get emptyNoTransactionsYet => '还没有交易';

  @override
  String get emptyNoAccountsYet => '还没有账户';

  @override
  String get emptyRecordFirstTransaction => '点击下面的按钮记录您的第一笔交易。';

  @override
  String get emptyAddFirstAccountTx => '在记录交易之前添加您的第一个帐户。';

  @override
  String get emptyAddFirstAccountPlan => '在计划交易之前添加您的第一个帐户。';

  @override
  String get emptyAddFirstAccountReview => '添加您的第一个帐户以开始跟踪您的财务状况。';

  @override
  String get emptyAddTransaction => '添加交易';

  @override
  String get emptyAddAccount => '添加帐户';

  @override
  String get reviewEmptyGroupPersonalTitle => '还没有个人账户';

  @override
  String get reviewEmptyGroupPersonalBody => '个人账户是您自己的钱包和银行账户。添加一个来跟踪日常收入和支出。';

  @override
  String get reviewEmptyGroupIndividualsTitle => '还没有个人账户';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      '个人账户跟踪特定人员的资金情况——分担成本、贷款或欠条。为与您和解的每个人添加一个帐户。';

  @override
  String get reviewEmptyGroupEntitiesTitle => '还没有实体账户';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      '实体帐户适用于企业、项目或组织。使用它们将业务现金流与您的个人财务分开。';

  @override
  String get emptyNoTransactionsForFilters => '没有应用过滤器的交易';

  @override
  String get emptyNoTransactionsInHistory => '历史上没有交易记录';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return '$month 没有交易';
  }

  @override
  String get emptyNoTransactionsForAccount => '该账户没有任何交易';

  @override
  String get trackTransactionDeleted => '交易已删除';

  @override
  String get trackDeleteTitle => '删除交易？';

  @override
  String get trackDeleteBody => '这将扭转账户余额的变化。';

  @override
  String get trackTransaction => '交易';

  @override
  String get planConfirmTitle => '确认交易？';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return '此事件安排在$date。它将以今天的日期（$todayDate）记录在历史中。下一次发生仍发生在$nextDate。';
  }

  @override
  String get planConfirmBodyNormal => '这会将交易应用于您的真实账户余额并将其移至历史记录。';

  @override
  String get planTransactionConfirmed => '交易确认并应用';

  @override
  String get planTransactionRemoved => '计划交易已删除';

  @override
  String get planRepeatingTitle => '重复交易';

  @override
  String get planRepeatingBody => '仅跳过此日期 - 该系列继续下一个事件 - 或从计划中删除所有剩余的事件。';

  @override
  String get planDeleteAll => '全部删除';

  @override
  String get planSkipThisOnly => '仅跳过此部分';

  @override
  String get planOccurrenceSkipped => '已跳过此事件 — 已安排下一个事件';

  @override
  String get planNothingPlanned => '暂时没有计划';

  @override
  String get planPlanBody => '计划即将进行的交易。';

  @override
  String get planAddPlan => '添加计划';

  @override
  String get planNoPlannedForFilters => '没有针对所应用的过滤器的计划交易';

  @override
  String planNoPlannedInMonth(String month) {
    return '$month无计划交易';
  }

  @override
  String get planOverdue => '逾期的';

  @override
  String get planPlannedTransaction => '计划交易';

  @override
  String get discardTitle => '放弃更改？';

  @override
  String get discardBody => '您有未保存的更改。如果你现在离开，它们就会丢失。';

  @override
  String get keepEditing => '继续编辑';

  @override
  String get discard => '丢弃';

  @override
  String get newTransactionTitle => '新交易';

  @override
  String get editTransactionTitle => '编辑交易';

  @override
  String get transactionUpdated => '交易已更新';

  @override
  String get sectionAccounts => '账户';

  @override
  String get labelFrom => '从';

  @override
  String get labelTo => '到';

  @override
  String get sectionCategory => '类别';

  @override
  String get sectionAttachments => '附件';

  @override
  String get labelNote => '笔记';

  @override
  String get hintOptionalDescription => '可选描述';

  @override
  String get updateTransaction => '更新交易';

  @override
  String get saveTransaction => '保存交易';

  @override
  String get selectAccount => '选择账户';

  @override
  String get selectAccountTitle => '选择账户';

  @override
  String get noAccountsAvailable => '没有可用帐户';

  @override
  String amountReceivedBy(String name, String currency) {
    return '$name ($currency) 收到的金额';
  }

  @override
  String get amountReceivedHelper => '输入目标帐户收到的确切金额。这会锁定所使用的实际汇率。';

  @override
  String get attachTakePhoto => '拍照';

  @override
  String get attachTakePhotoSub => '使用相机拍摄收据';

  @override
  String get attachChooseGallery => '从画廊中选择';

  @override
  String get attachChooseGallerySub => '从您的图库中选择照片';

  @override
  String get attachBrowseFiles => '浏览文件';

  @override
  String get attachBrowseFilesSub => '附加 PDF、文档或其他文件';

  @override
  String get attachButton => '附';

  @override
  String get editPlanTitle => '编辑计划';

  @override
  String get planTransactionTitle => '计划交易';

  @override
  String get tapToSelect => '点击选择';

  @override
  String get updatePlan => '更新计划';

  @override
  String get addToPlan => '添加到计划';

  @override
  String get labelRepeat => '重复';

  @override
  String get selectPlannedDate => '选择计划日期';

  @override
  String get balancesAsOfToday => '截至今日的余额';

  @override
  String get projectedBalancesForTomorrow => '明天的预计余额';

  @override
  String projectedBalancesForDate(String date) {
    return '$date 的预计余额';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name 接收 ($currency)';
  }

  @override
  String get destHelper => '预计目的地金额。确切的汇率在确认时被锁定。';

  @override
  String get descriptionOptional => '说明（可选）';

  @override
  String get detailTransactionTitle => '交易';

  @override
  String get detailPlannedTitle => '计划';

  @override
  String get detailConfirmTransaction => '确认交易';

  @override
  String get detailDate => '日期';

  @override
  String get detailFrom => '从';

  @override
  String get detailTo => '到';

  @override
  String get detailCategory => '类别';

  @override
  String get detailNote => '笔记';

  @override
  String get detailDestinationAmount => '目的地金额';

  @override
  String get detailExchangeRate => '汇率';

  @override
  String get detailRepeats => '重复';

  @override
  String get detailDayOfMonth => '一个月中的哪一天';

  @override
  String get detailWeekends => '周末';

  @override
  String get detailAttachments => '附件';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个文件',
      one: '1 个文件',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionDisplay => '展示';

  @override
  String get settingsSectionLanguage => '语言';

  @override
  String get settingsSectionCategories => '类别';

  @override
  String get settingsSectionAccounts => '账户';

  @override
  String get settingsSectionPreferences => '偏好设置';

  @override
  String get settingsSectionManage => '管理';

  @override
  String get settingsBaseCurrency => '本国货币';

  @override
  String get settingsSecondaryCurrency => '次要货币';

  @override
  String get settingsCategories => '类别';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount 收入 · $expenseCount 支出';
  }

  @override
  String get settingsArchivedAccounts => '存档帐户';

  @override
  String get settingsArchivedAccountsSubtitleZero => '现在没有 - 当余额清晰时从帐户编辑存档';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count 对审阅和选择器隐藏';
  }

  @override
  String get settingsSectionData => '数据';

  @override
  String get settingsSectionPrivacy => '关于';

  @override
  String get settingsPrivacyPolicyTitle => '隐私政策';

  @override
  String get settingsPrivacyPolicySubtitle => 'Platrare 如何处理您的数据。';

  @override
  String get settingsPrivacyFxDisclosure =>
      '汇率：该应用程序通过互联网获取公共货币汇率。您的帐户和交易永远不会发送。';

  @override
  String get settingsPrivacyOpenFailed => '无法加载隐私政策。';

  @override
  String get settingsPrivacyRetry => '再试一次';

  @override
  String get settingsSoftwareVersionTitle => '软件版本';

  @override
  String get settingsSoftwareVersionSubtitle => '发布、诊断和法律';

  @override
  String get aboutScreenTitle => '关于';

  @override
  String get aboutAppTagline => '账本、现金流和规划在一个工作空间中进行。';

  @override
  String get aboutDescriptionBody =>
      'Platrare 在您的设备上保存账户、交易和计划。当您在其他地方需要副本时导出加密备份。汇率仅使用公开市场数据；您的分类帐尚未上传。';

  @override
  String get aboutVersionLabel => '版本';

  @override
  String get aboutBuildLabel => '建造';

  @override
  String get aboutCopySupportDetails => '复制支持详细信息';

  @override
  String get aboutOpenPrivacySubtitle => '打开完整的应用内政策文档。';

  @override
  String get aboutSupportBundleLocaleLabel => '语言环境';

  @override
  String get settingsSupportInfoCopied => '已复制到剪贴板';

  @override
  String get settingsVerifyLedger => '验证数据';

  @override
  String get settingsVerifyLedgerSubtitle => '检查账户余额是否与您的交易记录相符';

  @override
  String get settingsDataExportTitle => '导出备份';

  @override
  String get settingsDataExportSubtitle => '将所有数据和附件另存为 .zip 或加密的 .platrare';

  @override
  String get settingsDataImportTitle => '从备份恢复';

  @override
  String get settingsDataImportSubtitle =>
      '替换 Platrare .zip 或 .platrare 备份中的当前数据';

  @override
  String get backupExportDialogTitle => '保护此备份';

  @override
  String get backupExportDialogBody => '建议使用强密码，尤其是当您将文件存储在云中时。您需要相同的密码才能导入。';

  @override
  String get backupExportPasswordLabel => '密码';

  @override
  String get backupExportPasswordConfirmLabel => '确认密码';

  @override
  String get backupExportPasswordMismatch => '密码不匹配';

  @override
  String get backupExportPasswordEmpty => '输入匹配的密码，或在下面不加密地导出。';

  @override
  String get backupExportPasswordTooShort => '密码必须至少为 8 个字符。';

  @override
  String get backupExportSaveToDevice => '保存到设备';

  @override
  String get backupExportShareToCloud => '共享（iCloud、云端硬盘...）';

  @override
  String get backupExportWithoutEncryption => '不加密导出';

  @override
  String get backupExportSkipWarningTitle => '导出时不加密？';

  @override
  String get backupExportSkipWarningBody =>
      '任何有权访问该文件的人都可以读取您的数据。仅将其用于您控制的本地副本。';

  @override
  String get backupExportSkipWarningConfirm => '导出未加密';

  @override
  String get backupImportPasswordTitle => '加密备份';

  @override
  String get backupImportPasswordBody => '输入导出时使用的密码。';

  @override
  String get backupImportPasswordLabel => '密码';

  @override
  String get backupImportPreviewTitle => '备份摘要';

  @override
  String backupImportPreviewVersion(String version) {
    return '应用程序版本：$version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return '导出：$date';
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
    return '$accounts 账户 · $transactions 交易 · $planned 计划 · $attachments 附件文件 · $income 收入类别 · $expense 费用类别';
  }

  @override
  String get backupImportPreviewContinue => '继续';

  @override
  String get settingsBackupWrongPassword => '密码错误';

  @override
  String get settingsBackupChecksumMismatch => '备份完整性检查失败';

  @override
  String get settingsBackupCorruptFile => '备份文件无效或损坏';

  @override
  String get settingsBackupUnsupportedVersion => '备份需要更新的应用程序版本';

  @override
  String get settingsDataImportConfirmTitle => '替换当前数据？';

  @override
  String get settingsDataImportConfirmBody =>
      '这会将您的当前帐户、交易、计划交易、类别和导入的附件替换为所选备份的内容。此操作无法撤消。';

  @override
  String get settingsDataImportConfirmAction => '替换数据';

  @override
  String get settingsDataImportDone => '数据恢复成功';

  @override
  String get settingsDataImportInvalidFile => '该文件不是有效的 Platrare 备份';

  @override
  String get settingsDataImportFailed => '导入失败';

  @override
  String get settingsDataExportDoneTitle => '备份导出';

  @override
  String settingsDataExportDoneBody(String path) {
    return '备份保存至：\n$path';
  }

  @override
  String get settingsDataOpenExportFile => '打开文件';

  @override
  String get settingsDataExportFailed => '导出失败';

  @override
  String get settingsCsvExportTitle => '导出为 CSV';

  @override
  String get settingsCsvExportSubtitle => '将交易保存为电子表格文件';

  @override
  String get settingsCsvExportFailed => 'CSV 导出失败';

  @override
  String get settingsCsvImportTitle => '从 CSV 导入';

  @override
  String get settingsCsvImportSubtitle => '从电子表格添加交易 — 不会替换任何现有数据';

  @override
  String get settingsCsvTemplateTitle => '获取 CSV 模板';

  @override
  String get settingsCsvTemplateSubtitle => '用于粘贴旧数据的示例文件';

  @override
  String get csvTemplateInstruction1 => '请用你自己的数据替换下面的示例行，然后在设置中导入此文件。';

  @override
  String get csvTemplateInstruction2 =>
      'date 和 amount 为必填项。日期请写成 YYYY-MM-DD，金额请填正数。';

  @override
  String get csvTemplateInstruction3 =>
      'type 可以是 income、expense、transfer、invoice、bill、advance、settlement、loan、collection 或 offset。留空则由应用根据账户自动判断。';

  @override
  String get csvTemplateInstruction4 => '尚不存在的账户和分类会自动创建。以 # 开头的行会被忽略。';

  @override
  String get csvImportPreviewTitle => '导入交易';

  @override
  String csvImportPreviewCounts(int importable, int total) {
    return '将添加 $total 行中的 $importable 行';
  }

  @override
  String csvImportPreviewNewAccounts(String names) {
    return '新账户：$names';
  }

  @override
  String csvImportPreviewNewCategories(String names) {
    return '新分类：$names';
  }

  @override
  String csvImportPreviewDuplicates(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 行已存在',
    );
    return '$_temp0';
  }

  @override
  String get csvImportPreviewSkipDuplicates => '跳过已存在的行';

  @override
  String csvImportPreviewIssuesTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 行无法读取',
    );
    return '$_temp0';
  }

  @override
  String csvImportPreviewIssueLine(int line, String reason) {
    return '第 $line 行：$reason';
  }

  @override
  String csvImportPreviewIssueMore(int count) {
    return '…另有 $count 行';
  }

  @override
  String get csvImportPreviewDateStyleTitle => '像 03/04/2026 这样的日期含义不明确。应如何解读？';

  @override
  String get csvImportPreviewDateStyleDayFirst => '日在前（4 月 3 日）';

  @override
  String get csvImportPreviewDateStyleMonthFirst => '月在前（3 月 4 日）';

  @override
  String get csvImportPreviewNothing => '此文件中没有可导入的行。';

  @override
  String get csvImportPreviewConfirm => '导入';

  @override
  String get csvRowProblemDate => '日期无效或缺失';

  @override
  String get csvRowProblemAmount => '金额无效或缺失';

  @override
  String get csvRowProblemAccount => '账户无效或缺失';

  @override
  String get csvRowProblemType => '未知的交易类型';

  @override
  String csvImportDone(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已导入 $count 笔交易',
    );
    return '$_temp0';
  }

  @override
  String get csvImportFailedNoColumns => '未识别到任何列。请从 CSV 模板开始。';

  @override
  String csvImportFailedMissingColumn(String column) {
    return '文件中没有“$column”列。';
  }

  @override
  String get csvImportFailedEmpty => '此文件没有数据行。';

  @override
  String csvImportFailedTooManyRows(int rows, int max) {
    return '此文件有 $rows 行，上限为 $max 行。';
  }

  @override
  String get csvImportFailed => 'CSV 导入失败';

  @override
  String get ledgerVerifyDialogTitle => '账本验证';

  @override
  String get ledgerVerifyAllMatch => '所有帐户都匹配。';

  @override
  String get ledgerVerifyMismatchesTitle => '不匹配';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\n存储：$stored\n重播：$replayed\n差异：$diff';
  }

  @override
  String get settingsLanguage => '应用语言';

  @override
  String get settingsLanguageSubtitleSystem => '以下系统设置';

  @override
  String get settingsLanguageSubtitleEnglish => '英语';

  @override
  String get settingsLanguageSubtitleSerbianLatin => '塞尔维亚语（拉丁语）';

  @override
  String get settingsLanguagePickerTitle => '应用语言';

  @override
  String get settingsLanguageOptionSystem => '系统默认';

  @override
  String get settingsLanguageOptionEnglish => '英语';

  @override
  String get settingsLanguageOptionSerbianLatin => '塞尔维亚语（拉丁语）';

  @override
  String get settingsSectionAppearance => '外貌';

  @override
  String get settingsSectionSecurity => '安全';

  @override
  String get settingsSecurityEnableLock => '锁定应用程序打开状态';

  @override
  String get settingsSecurityEnableLockSubtitle => '应用程序打开时需要生物识别解锁或 PIN';

  @override
  String get settingsSecurityLockDelayTitle => '后台后重新锁定';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      '应用在屏幕外停留多久后才需要重新解锁。立即是最安全的选项。';

  @override
  String get settingsSecurityLockDelayImmediate => '立即';

  @override
  String get settingsSecurityLockDelay30s => '30秒';

  @override
  String get settingsSecurityLockDelay1m => '1分钟';

  @override
  String get settingsSecurityLockDelay5m => '5分钟';

  @override
  String get settingsSecuritySetPin => '设置密码';

  @override
  String get settingsSecurityChangePin => '更改密码';

  @override
  String get settingsSecurityPinSubtitle => '如果生物识别不可用，请使用 PIN 作为后备措施';

  @override
  String get settingsSecurityRemovePin => '删除 PIN 码';

  @override
  String get securitySetPinTitle => '设置应用程序 PIN';

  @override
  String get securityPinLabel => '密码';

  @override
  String get securityConfirmPinLabel => '确认 PIN 码';

  @override
  String get securityPinMustBe4Digits => 'PIN 码必须至少有 4 位数字';

  @override
  String get securityPinMismatch => 'PIN 码不匹配';

  @override
  String get securityRemovePinTitle => '删除 PIN 码？';

  @override
  String get securityRemovePinBody => '如果有的话，仍然可以使用生物识别解锁。';

  @override
  String get securityUnlockTitle => '应用程序已锁定';

  @override
  String get securityUnlockSubtitle => '使用面容 ID、指纹或 PIN 码解锁。';

  @override
  String get securityUnlockWithPin => '使用 PIN 码解锁';

  @override
  String get securityTryBiometric => '尝试生物识别解锁';

  @override
  String get securityPinIncorrect => 'PIN 码不正确，请重试';

  @override
  String securityTooManyAttempts(int seconds) {
    return '尝试次数过多。请在 $seconds 秒后重试';
  }

  @override
  String get securityBiometricReason => '进行身份验证以打开您的应用程序';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSubtitleSystem => '以下系统设置';

  @override
  String get settingsThemeSubtitleLight => '光';

  @override
  String get settingsThemeSubtitleDark => '黑暗的';

  @override
  String get settingsThemePickerTitle => '主题';

  @override
  String get settingsThemeOptionSystem => '系统默认';

  @override
  String get settingsThemeOptionLight => '光';

  @override
  String get settingsThemeOptionDark => '黑暗的';

  @override
  String get archivedAccountsTitle => '存档帐户';

  @override
  String get archivedAccountsEmptyTitle => '没有存档帐户';

  @override
  String get archivedAccountsEmptyBody => '账面余额和透支必须为零。从“审核”中的帐户选项存档。';

  @override
  String get categoriesTitle => '类别';

  @override
  String get newCategoryTitle => '新类别';

  @override
  String get categoryNameLabel => '类别名称';

  @override
  String get deleteCategoryTitle => '删除类别？';

  @override
  String deleteCategoryBody(String category) {
    return '“$category”将从列表中删除。';
  }

  @override
  String get categoryIncome => '收入';

  @override
  String get categoryExpense => '费用';

  @override
  String get categoryAdd => '添加';

  @override
  String get editCategoryTitle => '编辑类别';

  @override
  String get categorySave => '保存';

  @override
  String get categoryRenameAction => '重命名';

  @override
  String get categoryDuplicateName => '已存在同名类别。';

  @override
  String get categoryInUseTitle => '类别正在使用中';

  @override
  String categoryInUseBody(String category, num count) {
    return '“$category”正在被 $count 笔交易使用。无法删除，但可以重命名——所有关联交易将自动更新。';
  }

  @override
  String get searchCurrencies => '搜索货币...';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1年';

  @override
  String get periodAll => '全部';

  @override
  String get categoryLabel => '类别';

  @override
  String get categoriesLabel => '类别';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type 已保存 • $amount';
  }

  @override
  String get tooltipSettings => '设置';

  @override
  String get tooltipAddAccount => '添加帐户';

  @override
  String get tooltipRemoveAccount => '删除帐户';

  @override
  String get accountNameTaken => '您已经拥有一个具有此名称和标识符的帐户（活动或已存档）。更改名称或标识符。';

  @override
  String get groupDescPersonal => '您自己的钱包和银行账户';

  @override
  String get groupDescIndividuals => '家人、朋友、个人';

  @override
  String get groupDescEntities => '实体、公用事业、组织';

  @override
  String get cannotArchiveTitle => '还不能存档';

  @override
  String get cannotArchiveBody => '仅当账面余额和透支限额实际上均为零时，存档才可用。';

  @override
  String get cannotArchiveBodyAdjust => '仅当账面余额和透支限额实际上均为零时，存档才可用。首先调整分类账或设施。';

  @override
  String get archiveAccountTitle => '存档帐户？';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条计划交易引用了此账户。',
      one: '1 条计划交易引用了此账户。',
    );
    return '$_temp0 请删除它们，以使计划与已归档账户保持一致。';
  }

  @override
  String get removeAndArchive => '删除计划和存档';

  @override
  String get archiveBody => '该帐户将对“审阅”、“跟踪”和“计划”选择器隐藏。您可以从“设置”中恢复它。';

  @override
  String get archiveAction => '档案';

  @override
  String get archiveInstead => '改为存档';

  @override
  String get cannotDeleteTitle => '无法删除帐户';

  @override
  String get cannotDeleteBodyShort =>
      '该帐户出现在您的跟踪历史记录中。首先删除或重新分配这些交易，或者在余额已清除的情况下存档帐户。';

  @override
  String get cannotDeleteBodyHistory =>
      '该帐户出现在您的跟踪历史记录中。删除会破坏该历史记录——首先删除或重新分配这些事务。';

  @override
  String get cannotDeleteBodySuggestArchive =>
      '该帐户出现在您的跟踪历史记录中，因此无法删除。如果账面余额和透支已清除，您可以将其存档 - 它将从列表中隐藏，但历史记录保持不变。';

  @override
  String get deleteAccountTitle => '删除帐户？';

  @override
  String get deleteAccountBodyPermanent => '该帐户将被永久删除。';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条计划交易引用了此账户，也将被删除。',
      one: '1 条计划交易引用了此账户，也将被删除。',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => '全部删除';

  @override
  String get editAccountTitle => '编辑帐户';

  @override
  String get newAccountTitle => '新账户';

  @override
  String get labelAccountName => '帐户名称';

  @override
  String get labelAccountIdentifier => '标识符（可选）';

  @override
  String get accountAppearanceSection => '图标和颜色';

  @override
  String get accountPickIcon => '选择图标';

  @override
  String get accountPickColor => '选择颜色';

  @override
  String get accountIconSheetTitle => '帐户图标';

  @override
  String get accountColorSheetTitle => '帐号颜色';

  @override
  String get searchAccountIcons => '按名称搜索图标…';

  @override
  String get accountIconSearchNoMatches => '没有与该搜索匹配的图标。';

  @override
  String get accountUseInitialLetter => '首字母';

  @override
  String get accountUseDefaultColor => '比赛组';

  @override
  String get labelRealBalance => '实际余额';

  @override
  String get labelOverdraftLimit => '透支/预支限额';

  @override
  String get labelCurrency => '货币';

  @override
  String get saveChanges => '保存更改';

  @override
  String get addAccountAction => '添加账户';

  @override
  String get removeAccountSheetTitle => '删除帐户';

  @override
  String get deletePermanently => '永久删除';

  @override
  String get deletePermanentlySubtitle =>
      '仅当此帐户未在 Track 中使用时才可用。计划项目可以作为删除的一部分被删除。';

  @override
  String get archiveOptionSubtitle => '隐藏审阅和选择器。随时从“设置”恢复。需要零余额和透支。';

  @override
  String get archivedBannerText => '该帐户已存档。它保留在您的数据中，但对列表和选择器隐藏。';

  @override
  String get balanceAdjustedTitle => '轨道中的平衡调整';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return '实际余额从$previous更新为$current$symbol。\n\n在跟踪（历史记录）中创建了余额调整交易，以保持账本一致。\n\n• 实际余额反映该账户的实际金额。\n• 检查调整条目的历史记录。';
  }

  @override
  String get ok => '好的';

  @override
  String get categoryBalanceAdjustment => '平衡调整';

  @override
  String get descriptionBalanceCorrection => '平衡校正';

  @override
  String get descriptionOpeningBalance => '期初余额';

  @override
  String get reviewStatsModeStatistics => '统计数据';

  @override
  String get reviewStatsModeComparison => '比较';

  @override
  String get statsUncategorized => '未分类';

  @override
  String get statsNoCategories => '所选期间没有类别可供比较。';

  @override
  String get statsNoTransactions => '没有交易';

  @override
  String get statsSpendingInCategory => '此类别的支出';

  @override
  String get statsIncomeInCategory => '此类别的收入';

  @override
  String get statsDifference => '差异（B 与 A）：';

  @override
  String get statsNoExpensesMonth => '本月无任何开支';

  @override
  String get statsNoExpensesAll => '没有记录任何费用';

  @override
  String statsNoExpensesPeriod(String period) {
    return '过去$period没有任何费用';
  }

  @override
  String get statsTotalSpent => '总支出';

  @override
  String get statsNoExpensesThisPeriod => '此期间无任何费用';

  @override
  String get statsNoIncomeMonth => '这个月没有收入';

  @override
  String get statsNoIncomeAll => '没有收入记录';

  @override
  String statsNoIncomePeriod(String period) {
    return '过去$period没有收入';
  }

  @override
  String get statsTotalReceived => '收到总计';

  @override
  String get statsNoIncomeThisPeriod => '此期间无收入';

  @override
  String get catSalary => '薪水';

  @override
  String get catFreelance => '自由职业者';

  @override
  String get catConsulting => '咨询';

  @override
  String get catGift => '礼物';

  @override
  String get catRental => '出租';

  @override
  String get catDividends => '股息';

  @override
  String get catRefund => '退款';

  @override
  String get catBonus => '奖金';

  @override
  String get catInterest => '兴趣';

  @override
  String get catSideHustle => '副业';

  @override
  String get catSaleOfGoods => '商品销售';

  @override
  String get catOther => '其他';

  @override
  String get catGroceries => '杂货';

  @override
  String get catDining => '用餐';

  @override
  String get catTransport => '运输';

  @override
  String get catUtilities => '公用事业';

  @override
  String get catHousing => '住房';

  @override
  String get catHealthcare => '卫生保健';

  @override
  String get catEntertainment => '娱乐';

  @override
  String get catShopping => '购物';

  @override
  String get catTravel => '旅行';

  @override
  String get catEducation => '教育';

  @override
  String get catSubscriptions => '订阅';

  @override
  String get catInsurance => '保险';

  @override
  String get catFuel => '燃料';

  @override
  String get catGym => '健身房';

  @override
  String get catPets => '宠物';

  @override
  String get catKids => '孩子们';

  @override
  String get catCharity => '慈善事业';

  @override
  String get catCoffee => '咖啡';

  @override
  String get catGifts => '礼物';

  @override
  String semanticsProjectionDate(String date) {
    return '投影日期$date。双击选择日期';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return '预计个人余额$amount';
  }

  @override
  String get statsEmptyTitle => '还没有交易';

  @override
  String get statsEmptySubtitle => '所选范围内没有支出数据。';

  @override
  String get semanticsShowProjections => '按账户显示预计余额';

  @override
  String get semanticsHideProjections => '按账户隐藏预计余额';

  @override
  String get semanticsShowDayBalanceBreakdown => '显示本日账户余额';

  @override
  String get semanticsHideDayBalanceBreakdown => '隐藏本日账户余额';

  @override
  String get semanticsDateAllTime => '日期：所有时间 — 点击即可更改模式';

  @override
  String semanticsDateMode(String mode) {
    return '日期：$mode — 点击即可更改模式';
  }

  @override
  String get semanticsDateThisMonth => '日期：本月 — 点击月份、周、年或所有时间';

  @override
  String get semanticsTxTypeCycle => '交易类型：循环全部、收入、支出、转账';

  @override
  String get semanticsAccountFilter => '账户过滤器';

  @override
  String get semanticsAlreadyFiltered => '已过滤到此帐户';

  @override
  String get semanticsCategoryFilter => '类别过滤器';

  @override
  String get semanticsSortToggle => '排序：切换最新或最旧的优先';

  @override
  String get semanticsFiltersDisabled => '列出在查看未来投影日期时禁用的过滤器。清除投影以使用过滤器。';

  @override
  String get semanticsFiltersDisabledNeedAccount => '列表过滤器已禁用。首先添加一个帐户。';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      '列表过滤器已禁用。首先添加计划交易。';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      '列表过滤器已禁用。先记录一笔交易。';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      '部分和货币控制已禁用。首先添加一个帐户。';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      '预测日期和余额明细已禁用。首先添加账户和计划交易。';

  @override
  String get semanticsReorderAccountHint => '长按，然后拖动以在该组内重新排序';

  @override
  String get semanticsChartStyle => '图表样式';

  @override
  String get semanticsChartStyleUnavailable => '图表样式（比较模式下不可用）';

  @override
  String semanticsPeriod(String label) {
    return '期间：$label';
  }

  @override
  String get trackSearchHint => '搜索描述、类别、帐户...';

  @override
  String get trackSearchClear => '清除搜索';

  @override
  String get settingsExchangeRatesTitle => '汇率';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return '最后更新：$time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated => '使用离线或捆绑费率 — 点击刷新';

  @override
  String get settingsExchangeRatesSource => '欧洲央行';

  @override
  String get settingsExchangeRatesUpdatedSnack => '汇率已更新';

  @override
  String get settingsExchangeRatesUpdateFailed => '无法更新汇率。检查您的连接。';

  @override
  String get settingsClearData => '清除数据';

  @override
  String get settingsClearDataSubtitle => '永久删除选定的数据';

  @override
  String get clearDataTitle => '清除数据';

  @override
  String get clearDataTransactions => '交易记录';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count交易·账户余额清零';
  }

  @override
  String get clearDataPlanned => '计划交易';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count 计划项目';
  }

  @override
  String get clearDataAccounts => '账户';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count 账户 · 还清除历史记录和计划';
  }

  @override
  String get clearDataCategories => '类别';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count 类别 · 替换为默认值';
  }

  @override
  String get clearDataPreferences => '偏好设置';

  @override
  String get clearDataPreferencesSubtitle => '将货币、主题和语言重置为默认值';

  @override
  String get clearDataSecurity => '应用程序锁定和 PIN';

  @override
  String get clearDataSecuritySubtitle => '禁用应用程序锁定并删除 PIN';

  @override
  String get clearDataConfirmButton => '清除所选内容';

  @override
  String get clearDataConfirmTitle => '此操作无法撤消';

  @override
  String get clearDataConfirmBody => '所选数据将被永久删除。如果稍后需要，请先导出备份。';

  @override
  String get clearDataTypeConfirm => 'Type 删除 to confirm';

  @override
  String get clearDataTypeConfirmError => 'Type 删除 exactly to continue';

  @override
  String get clearDataPinTitle => '使用 PIN 码确认';

  @override
  String get clearDataPinBody => '输入您的应用程序 PIN 码以授权此操作。';

  @override
  String get clearDataPinIncorrect => 'PIN 码不正确';

  @override
  String get clearDataDone => '已清除所选数据';

  @override
  String get autoBackupTitle => '每日自动备份';

  @override
  String autoBackupLastAt(String date) {
    return '最后备份$date';
  }

  @override
  String get autoBackupNeverRun => '还没有备份';

  @override
  String get autoBackupShareTitle => '保存到云端';

  @override
  String get autoBackupShareSubtitle =>
      '将最新备份上传到 iCloud Drive、Google Drive 或任何应用程序';

  @override
  String get autoBackupCloudReminder => '自动备份就绪 - 将其保存到云端以实现设备外保护';

  @override
  String get autoBackupCloudReminderAction => '分享';

  @override
  String get settingsBackupReminderTitle => '备份提醒';

  @override
  String get settingsBackupReminderSubtitle => '如果您添加了许多交易而未导出手动备份，将显示应用内横幅。';

  @override
  String get settingsBackupReminderThresholdTitle => '交易阈值';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return '自上次手动导出后新增 $count 笔交易后提醒。';
  }

  @override
  String get settingsBackupReminderThresholdInvalid => '请输入1到500之间的整数。';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '\"稍后提醒\"会隐藏横幅，直到您再添加 $n 笔交易。';
  }

  @override
  String get backupReminderBannerTitle => '导出备份？';

  @override
  String backupReminderBannerBody(int count) {
    return '自上次手动导出以来，您已添加 $count 笔交易。';
  }

  @override
  String get backupReminderRemindLater => '稍后提醒';

  @override
  String get backupExportLedgerVerifyTitle => '备份前账本检查';

  @override
  String get backupExportLedgerVerifyInfo =>
      '将每个账户的存储余额与您完整的历史记录重播进行比较。无论如何您都可以导出备份；不一致仅供参考。';

  @override
  String get backupExportLedgerVerifyContinue => '继续备份';

  @override
  String get persistenceErrorReloaded => '无法保存更改。数据已从存储中重新加载。';

  @override
  String get helpTooltip => '帮助';

  @override
  String get helpNext => '下一步';

  @override
  String get helpBack => '上一步';

  @override
  String get helpDone => '完成';

  @override
  String get helpSkip => '跳过';

  @override
  String get helpTrackHeroTitle => '总额与筛选';

  @override
  String get helpTrackHeroBody =>
      '此卡片汇总下方列表的收支。筛选标签可按账户、类别和类型过滤；日期标签在日、周、月、年之间切换；箭头可反转排序。';

  @override
  String get helpTrackListTitle => '你的历史记录';

  @override
  String get helpTrackListBody => '已记录的交易按天分组。点按可查看或编辑，也可以用搜索找到特定记录。';

  @override
  String get helpTrackFabTitle => '添加交易';

  @override
  String get helpTrackFabBody => '记录收入、支出或账户之间的转账。';

  @override
  String get helpSettingsTitle => '设置';

  @override
  String get helpSettingsBody => '货币、语言、主题、安全、备份和账户管理都在这里。';

  @override
  String get helpPlanHeroTitle => '预测';

  @override
  String get helpPlanHeroBody => '所选日期的个人余额和净余额。下方的标签用于筛选计划交易。';

  @override
  String get helpPlanListTitle => '计划交易';

  @override
  String get helpPlanListBody => '预期的收入、支出和转账。点按可编辑；顶部的标签用于筛选此列表。';

  @override
  String get helpPlanFabTitle => '添加计划';

  @override
  String get helpPlanFabBody => '安排一笔预期交易，也可以设置重复。';

  @override
  String get helpPlanProjectionFabTitle => '预测未来';

  @override
  String get helpPlanProjectionFabBody =>
      '点按地球按钮选择未来日期即可查看预测余额——将应用截至该日期的计划交易。也可以点按上方卡片中的日期。';

  @override
  String get helpReviewHeroTitle => '净资产';

  @override
  String get helpReviewHeroBody => '一眼掌握个人余额和净资产。点按金额可在基础货币和第二货币之间切换。';

  @override
  String get helpReviewSectionsTitle => '分区';

  @override
  String get helpReviewSectionsBody => '左右滑动或点按标签，在个人账户、个人、机构和统计之间切换。';

  @override
  String get helpReviewAccountsTitle => '账户';

  @override
  String get helpReviewAccountsBody => '每张卡片显示一个账户及其余额。点按可打开完整交易历史。';

  @override
  String get helpReviewFabTitle => '添加账户';

  @override
  String get helpReviewFabBody => '为现金、银行卡和储蓄创建账户，也可以为你关注的个人和企业创建账户。';

  @override
  String get helpSettingsSecurityTitle => '安全';

  @override
  String get helpSettingsSecurityBody => '用设备的锁屏方式锁定应用，并选择重新锁定的速度。';

  @override
  String get helpSettingsPreferencesTitle => '偏好设置';

  @override
  String get helpSettingsPreferencesBody => '语言、主题、货币及其他日常选项。';

  @override
  String get helpSettingsDataTitle => '你的数据';

  @override
  String get helpSettingsDataBody =>
      '导出加密备份，在其他设备上导入，并调整自动备份。除非你导出，数据始终保留在本设备上。';

  @override
  String get helpSettingsManageTitle => '管理';

  @override
  String get helpSettingsManageBody => '编辑账户、重命名类别——更改会应用到整个应用。';

  @override
  String get helpTxAccountsTitle => '转出与转入';

  @override
  String get helpTxAccountsBody => '选择钱从哪里来、到哪里去。仅转出:支出。仅转入:收入。两者都选:账户间转账。';

  @override
  String get helpTxDetailsTitle => '金额与详情';

  @override
  String get helpTxDetailsBody => '输入金额，再添加类别、备注或附件，以便日后查找。';

  @override
  String get helpTxDateTitle => '日期';

  @override
  String get helpTxDateBody => '点按此处修改交易日期。';

  @override
  String get helpPlannedDateTitle => '预定日期';

  @override
  String get helpPlannedDateBody => '点按此处选择执行时间。计划也可以按你选择的周期重复。';

  @override
  String get helpPlannedProjectionTitle => '预测余额';

  @override
  String get helpPlannedProjectionBody =>
      '账户选择器会显示每个账户在预定日期的预测余额，帮你发现会导致透支的计划。';

  @override
  String get settingsPlannedRemindersTitle => '计划提醒';

  @override
  String get settingsPlannedRemindersSubtitle =>
      '在计划交易到期时通知您。完全离线运行——任何数据都不会离开您的设备。';

  @override
  String get settingsPlannedRemindersTimeTitle => '提醒时间';

  @override
  String get settingsPlannedRemindersLeadTitle => '提前提醒';

  @override
  String get settingsPlannedRemindersLeadOnDay => '到期当天';

  @override
  String settingsPlannedRemindersLeadDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '提前 $count 天',
    );
    return '$_temp0';
  }

  @override
  String get settingsPlannedRemindersPermissionDenied =>
      'Platrare 的通知已关闭。请在系统设置中允许通知以接收提醒。';

  @override
  String get plannedReminderChannelName => '计划交易提醒';

  @override
  String get plannedReminderChannelDescription => '即将到期的计划交易通知。';

  @override
  String get plannedReminderFallbackTitle => '计划交易';

  @override
  String get plannedReminderDueToday => '今天到期';

  @override
  String get plannedReminderDueTomorrow => '明天到期';

  @override
  String plannedReminderDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天后到期',
    );
    return '$_temp0';
  }

  @override
  String get aboutContactSupport => '联系支持';

  @override
  String get aboutSupportEmailCopied => '已复制支持邮箱地址';

  @override
  String get onboardingWelcomeTitle => '欢迎使用 Platrare';

  @override
  String get onboardingWelcomeBody => '您的资金数据只保存在此设备上。无需账户，没有广告，不做追踪。';

  @override
  String get onboardingPlanBody => '安排即将到来和定期的付款，查看余额走向。';

  @override
  String get onboardingTrackBody => '记录收入、支出、转账以及借出或欠下的款项。';

  @override
  String get onboardingReviewBody => '为您的账户、往来对象和企业提供统计、对比和历史记录。';

  @override
  String get onboardingCurrencyLabel => '基准货币';

  @override
  String get onboardingCurrencyHint => '根据设备语言推荐，之后可在设置中更改。';

  @override
  String get onboardingStart => '开始使用';

  @override
  String get onboardingTour => '带我了解一下';

  @override
  String get clearDataConfirmWord => '删除';

  @override
  String get planDeleteTitle => '删除计划交易？';

  @override
  String get planDeleteBody => '它将从计划中移除，账户余额不受影响。';

  @override
  String get semanticsPreviousPeriod => '上一期间';

  @override
  String get semanticsNextPeriod => '下一期间';

  @override
  String get semanticsSectionStatistics => '统计';

  @override
  String get semanticsCurrencyToggle => '切换显示货币';

  @override
  String get semanticsStatsSpent => '支出';

  @override
  String get semanticsStatsReceived => '收入';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get appTitle => '普拉特拉雷';

  @override
  String get navPlan => '计划';

  @override
  String get navTrack => '追踪';

  @override
  String get navReview => '审查';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get close => '关闭';

  @override
  String get add => '添加';

  @override
  String get undo => '撤消';

  @override
  String get confirm => '确认';

  @override
  String get restore => '恢复';

  @override
  String get heroIn => '在';

  @override
  String get heroOut => '出去';

  @override
  String get heroNet => '网';

  @override
  String get widgetLowestPoint => '最低点';

  @override
  String get widgetProjected => '预计';

  @override
  String get widgetHorizonIn7Days => '7 天后';

  @override
  String get widgetHorizonEndOfMonth => '月末';

  @override
  String get widgetMetricAccount => '账户余额';

  @override
  String get widgetQuickAdd => '快速添加';

  @override
  String get widgetStale => '可能不是最新';

  @override
  String get widgetOpenToStart => '打开 Platrare 添加账户';

  @override
  String get widgetDueToday => '今天到期';

  @override
  String get widgetDescQuickAdd => '一键添加交易或计划。';

  @override
  String get widgetNameNumbers => '余额';

  @override
  String get widgetDescNumbers => '显示一个数字：可用余额、净资产或本月最低点。';

  @override
  String get widgetConfigMetric => '指标';

  @override
  String get widgetConfigHorizon => '时间范围';

  @override
  String widgetSiriAddTransaction(String appName) {
    return '在 $appName 中添加交易';
  }

  @override
  String widgetSiriAddPlanned(String appName) {
    return '在 $appName 中添加计划交易';
  }

  @override
  String get settingsWidgetAmountsTitle => '在小组件中显示金额';

  @override
  String get settingsWidgetAmountsSubtitle =>
      '主屏幕小组件无需解锁应用即可查看。启用应用锁时，除非开启此项，否则金额将保持隐藏。';

  @override
  String get heroBalance => '平衡';

  @override
  String get realBalance => '实际余额';

  @override
  String get settingsHideHeroBalancesTitle => '在摘要卡片中隐藏余额';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      '开启后，计划、追踪和评审中的金额将保持隐藏，直到您点击每个标签上的眼睛图标。关闭后，余额始终可见。';

  @override
  String get heroBalancesShow => '显示余额';

  @override
  String get heroBalancesHide => '隐藏余额';

  @override
  String get semanticsHeroBalanceHidden => '余额已隐藏以保护隐私';

  @override
  String get heroResetButton => '重置';

  @override
  String get fabScrollToTop => '返回顶部';

  @override
  String get fabPickProjectionDate => '选择预测日期';

  @override
  String get filterAll => '全部';

  @override
  String get filterAllAccounts => '所有账户';

  @override
  String get filterAllCategories => '所有类别';

  @override
  String get txLabelIncome => '收入';

  @override
  String get txLabelExpense => '费用';

  @override
  String get txLabelInvoice => '发票';

  @override
  String get txLabelBill => '账单';

  @override
  String get txLabelAdvance => '进步';

  @override
  String get txLabelSettlement => '沉降';

  @override
  String get txLabelLoan => '贷款';

  @override
  String get txLabelCollection => '收藏';

  @override
  String get txLabelOffset => '抵消';

  @override
  String get txLabelTransfer => '转移';

  @override
  String get txLabelTransaction => '交易';

  @override
  String get repeatNone => '不重复';

  @override
  String get repeatDaily => '日常的';

  @override
  String get repeatWeekly => '每周';

  @override
  String get repeatMonthly => '每月';

  @override
  String get repeatYearly => '每年';

  @override
  String get repeatEveryLabel => '每一个';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
      one: '天',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 周',
      one: '周',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个月',
      one: '个月',
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
  String get repeatEndLabel => '结束';

  @override
  String get repeatEndNever => '绝不';

  @override
  String get repeatEndOnDate => '约会时';

  @override
  String repeatEndAfterCount(int count) {
    return '$count次后';
  }

  @override
  String get repeatEndAfterChoice => '若干次后';

  @override
  String get repeatEndPickDate => '选择结束日期';

  @override
  String get repeatEndTimes => '次';

  @override
  String repeatSummaryEvery(String unit) {
    return '每$unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return '直到$date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count次';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '剩余 $total 的 $remaining';
  }

  @override
  String get detailRepeatEvery => '重复每个';

  @override
  String get detailEnds => '结束';

  @override
  String get detailEndsNever => '绝不';

  @override
  String detailEndsOnDate(String date) {
    return '在$date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return '$count次后';
  }

  @override
  String get detailProgress => '进步';

  @override
  String get weekendNoChange => '没有变化';

  @override
  String get weekendFriday => '移至周五';

  @override
  String get weekendMonday => '移至星期一';

  @override
  String weekendQuestion(String day) {
    return '如果$day恰逢周末？';
  }

  @override
  String get dateToday => '今天';

  @override
  String get dateTomorrow => '明天';

  @override
  String get dateYesterday => '昨天';

  @override
  String get statsAllTime => '所有时间';

  @override
  String get accountGroupPersonal => '个人的';

  @override
  String get accountGroupIndividual => '个人';

  @override
  String get accountGroupEntity => '实体';

  @override
  String get accountSectionIndividuals => '个人';

  @override
  String get accountSectionEntities => '实体';

  @override
  String get emptyNoTransactionsYet => '还没有交易';

  @override
  String get emptyNoAccountsYet => '还没有账户';

  @override
  String get emptyRecordFirstTransaction => '点击下面的按钮记录您的第一笔交易。';

  @override
  String get emptyAddFirstAccountTx => '在记录交易之前添加您的第一个帐户。';

  @override
  String get emptyAddFirstAccountPlan => '在计划交易之前添加您的第一个帐户。';

  @override
  String get emptyAddFirstAccountReview => '添加您的第一个帐户以开始跟踪您的财务状况。';

  @override
  String get emptyAddTransaction => '添加交易';

  @override
  String get emptyAddAccount => '添加帐户';

  @override
  String get reviewEmptyGroupPersonalTitle => '还没有个人账户';

  @override
  String get reviewEmptyGroupPersonalBody => '个人账户是您自己的钱包和银行账户。添加一个来跟踪日常收入和支出。';

  @override
  String get reviewEmptyGroupIndividualsTitle => '还没有个人账户';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      '个人账户跟踪特定人员的资金情况——分担成本、贷款或欠条。为与您和解的每个人添加一个帐户。';

  @override
  String get reviewEmptyGroupEntitiesTitle => '还没有实体账户';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      '实体帐户适用于企业、项目或组织。使用它们将业务现金流与您的个人财务分开。';

  @override
  String get emptyNoTransactionsForFilters => '没有应用过滤器的交易';

  @override
  String get emptyNoTransactionsInHistory => '历史上没有交易记录';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return '$month 没有交易';
  }

  @override
  String get emptyNoTransactionsForAccount => '该账户没有任何交易';

  @override
  String get trackTransactionDeleted => '交易已删除';

  @override
  String get trackDeleteTitle => '删除交易？';

  @override
  String get trackDeleteBody => '这将扭转账户余额的变化。';

  @override
  String get trackTransaction => '交易';

  @override
  String get planConfirmTitle => '确认交易？';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return '此事件安排在$date。它将以今天的日期（$todayDate）记录在历史中。下一次发生仍发生在$nextDate。';
  }

  @override
  String get planConfirmBodyNormal => '这会将交易应用于您的真实账户余额并将其移至历史记录。';

  @override
  String get planTransactionConfirmed => '交易确认并应用';

  @override
  String get planTransactionRemoved => '计划交易已删除';

  @override
  String get planRepeatingTitle => '重复交易';

  @override
  String get planRepeatingBody => '仅跳过此日期 - 该系列继续下一个事件 - 或从计划中删除所有剩余的事件。';

  @override
  String get planDeleteAll => '全部删除';

  @override
  String get planSkipThisOnly => '仅跳过此部分';

  @override
  String get planOccurrenceSkipped => '已跳过此事件 — 已安排下一个事件';

  @override
  String get planNothingPlanned => '暂时没有计划';

  @override
  String get planPlanBody => '计划即将进行的交易。';

  @override
  String get planAddPlan => '添加计划';

  @override
  String get planNoPlannedForFilters => '没有针对所应用的过滤器的计划交易';

  @override
  String planNoPlannedInMonth(String month) {
    return '$month无计划交易';
  }

  @override
  String get planOverdue => '逾期的';

  @override
  String get planPlannedTransaction => '计划交易';

  @override
  String get discardTitle => '放弃更改？';

  @override
  String get discardBody => '您有未保存的更改。如果你现在离开，它们就会丢失。';

  @override
  String get keepEditing => '继续编辑';

  @override
  String get discard => '丢弃';

  @override
  String get newTransactionTitle => '新交易';

  @override
  String get editTransactionTitle => '编辑交易';

  @override
  String get transactionUpdated => '交易已更新';

  @override
  String get sectionAccounts => '账户';

  @override
  String get labelFrom => '从';

  @override
  String get labelTo => '到';

  @override
  String get sectionCategory => '类别';

  @override
  String get sectionAttachments => '附件';

  @override
  String get labelNote => '笔记';

  @override
  String get hintOptionalDescription => '可选描述';

  @override
  String get updateTransaction => '更新交易';

  @override
  String get saveTransaction => '保存交易';

  @override
  String get selectAccount => '选择账户';

  @override
  String get selectAccountTitle => '选择账户';

  @override
  String get noAccountsAvailable => '没有可用帐户';

  @override
  String amountReceivedBy(String name, String currency) {
    return '$name ($currency) 收到的金额';
  }

  @override
  String get amountReceivedHelper => '输入目标帐户收到的确切金额。这会锁定所使用的实际汇率。';

  @override
  String get attachTakePhoto => '拍照';

  @override
  String get attachTakePhotoSub => '使用相机拍摄收据';

  @override
  String get attachChooseGallery => '从画廊中选择';

  @override
  String get attachChooseGallerySub => '从您的图库中选择照片';

  @override
  String get attachBrowseFiles => '浏览文件';

  @override
  String get attachBrowseFilesSub => '附加 PDF、文档或其他文件';

  @override
  String get attachButton => '附';

  @override
  String get editPlanTitle => '编辑计划';

  @override
  String get planTransactionTitle => '计划交易';

  @override
  String get tapToSelect => '点击选择';

  @override
  String get updatePlan => '更新计划';

  @override
  String get addToPlan => '添加到计划';

  @override
  String get labelRepeat => '重复';

  @override
  String get selectPlannedDate => '选择计划日期';

  @override
  String get balancesAsOfToday => '截至今日的余额';

  @override
  String get projectedBalancesForTomorrow => '明天的预计余额';

  @override
  String projectedBalancesForDate(String date) {
    return '$date 的预计余额';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name 接收 ($currency)';
  }

  @override
  String get destHelper => '预计目的地金额。确切的汇率在确认时被锁定。';

  @override
  String get descriptionOptional => '说明（可选）';

  @override
  String get detailTransactionTitle => '交易';

  @override
  String get detailPlannedTitle => '计划';

  @override
  String get detailConfirmTransaction => '确认交易';

  @override
  String get detailDate => '日期';

  @override
  String get detailFrom => '从';

  @override
  String get detailTo => '到';

  @override
  String get detailCategory => '类别';

  @override
  String get detailNote => '笔记';

  @override
  String get detailDestinationAmount => '目的地金额';

  @override
  String get detailExchangeRate => '汇率';

  @override
  String get detailRepeats => '重复';

  @override
  String get detailDayOfMonth => '一个月中的哪一天';

  @override
  String get detailWeekends => '周末';

  @override
  String get detailAttachments => '附件';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个文件',
      one: '1 个文件',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionDisplay => '展示';

  @override
  String get settingsSectionLanguage => '语言';

  @override
  String get settingsSectionCategories => '类别';

  @override
  String get settingsSectionAccounts => '账户';

  @override
  String get settingsSectionPreferences => '偏好设置';

  @override
  String get settingsSectionManage => '管理';

  @override
  String get settingsBaseCurrency => '本国货币';

  @override
  String get settingsSecondaryCurrency => '次要货币';

  @override
  String get settingsCategories => '类别';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount 收入 · $expenseCount 支出';
  }

  @override
  String get settingsArchivedAccounts => '存档帐户';

  @override
  String get settingsArchivedAccountsSubtitleZero => '现在没有 - 当余额清晰时从帐户编辑存档';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count 对审阅和选择器隐藏';
  }

  @override
  String get settingsSectionData => '数据';

  @override
  String get settingsSectionPrivacy => '关于';

  @override
  String get settingsPrivacyPolicyTitle => '隐私政策';

  @override
  String get settingsPrivacyPolicySubtitle => 'Platrare 如何处理您的数据。';

  @override
  String get settingsPrivacyFxDisclosure =>
      '汇率：该应用程序通过互联网获取公共货币汇率。您的帐户和交易永远不会发送。';

  @override
  String get settingsPrivacyOpenFailed => '无法加载隐私政策。';

  @override
  String get settingsPrivacyRetry => '再试一次';

  @override
  String get settingsSoftwareVersionTitle => '软件版本';

  @override
  String get settingsSoftwareVersionSubtitle => '发布、诊断和法律';

  @override
  String get aboutScreenTitle => '关于';

  @override
  String get aboutAppTagline => '账本、现金流和规划在一个工作空间中进行。';

  @override
  String get aboutDescriptionBody =>
      'Platrare 在您的设备上保存账户、交易和计划。当您在其他地方需要副本时导出加密备份。汇率仅使用公开市场数据；您的分类帐尚未上传。';

  @override
  String get aboutVersionLabel => '版本';

  @override
  String get aboutBuildLabel => '建造';

  @override
  String get aboutCopySupportDetails => '复制支持详细信息';

  @override
  String get aboutOpenPrivacySubtitle => '打开完整的应用内政策文档。';

  @override
  String get aboutSupportBundleLocaleLabel => '语言环境';

  @override
  String get settingsSupportInfoCopied => '已复制到剪贴板';

  @override
  String get settingsVerifyLedger => '验证数据';

  @override
  String get settingsVerifyLedgerSubtitle => '检查账户余额是否与您的交易记录相符';

  @override
  String get settingsDataExportTitle => '导出备份';

  @override
  String get settingsDataExportSubtitle => '将所有数据和附件另存为 .zip 或加密的 .platrare';

  @override
  String get settingsDataImportTitle => '从备份恢复';

  @override
  String get settingsDataImportSubtitle =>
      '替换 Platrare .zip 或 .platrare 备份中的当前数据';

  @override
  String get backupExportDialogTitle => '保护此备份';

  @override
  String get backupExportDialogBody => '建议使用强密码，尤其是当您将文件存储在云中时。您需要相同的密码才能导入。';

  @override
  String get backupExportPasswordLabel => '密码';

  @override
  String get backupExportPasswordConfirmLabel => '确认密码';

  @override
  String get backupExportPasswordMismatch => '密码不匹配';

  @override
  String get backupExportPasswordEmpty => '输入匹配的密码，或在下面不加密地导出。';

  @override
  String get backupExportPasswordTooShort => '密码必须至少为 8 个字符。';

  @override
  String get backupExportSaveToDevice => '保存到设备';

  @override
  String get backupExportShareToCloud => '共享（iCloud、云端硬盘...）';

  @override
  String get backupExportWithoutEncryption => '不加密导出';

  @override
  String get backupExportSkipWarningTitle => '导出时不加密？';

  @override
  String get backupExportSkipWarningBody =>
      '任何有权访问该文件的人都可以读取您的数据。仅将其用于您控制的本地副本。';

  @override
  String get backupExportSkipWarningConfirm => '导出未加密';

  @override
  String get backupImportPasswordTitle => '加密备份';

  @override
  String get backupImportPasswordBody => '输入导出时使用的密码。';

  @override
  String get backupImportPasswordLabel => '密码';

  @override
  String get backupImportPreviewTitle => '备份摘要';

  @override
  String backupImportPreviewVersion(String version) {
    return '应用程序版本：$version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return '导出：$date';
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
    return '$accounts 账户 · $transactions 交易 · $planned 计划 · $attachments 附件文件 · $income 收入类别 · $expense 费用类别';
  }

  @override
  String get backupImportPreviewContinue => '继续';

  @override
  String get settingsBackupWrongPassword => '密码错误';

  @override
  String get settingsBackupChecksumMismatch => '备份完整性检查失败';

  @override
  String get settingsBackupCorruptFile => '备份文件无效或损坏';

  @override
  String get settingsBackupUnsupportedVersion => '备份需要更新的应用程序版本';

  @override
  String get settingsDataImportConfirmTitle => '替换当前数据？';

  @override
  String get settingsDataImportConfirmBody =>
      '这会将您的当前帐户、交易、计划交易、类别和导入的附件替换为所选备份的内容。此操作无法撤消。';

  @override
  String get settingsDataImportConfirmAction => '替换数据';

  @override
  String get settingsDataImportDone => '数据恢复成功';

  @override
  String get settingsDataImportInvalidFile => '该文件不是有效的 Platrare 备份';

  @override
  String get settingsDataImportFailed => '导入失败';

  @override
  String get settingsDataExportDoneTitle => '备份导出';

  @override
  String settingsDataExportDoneBody(String path) {
    return '备份保存至：\n$path';
  }

  @override
  String get settingsDataOpenExportFile => '打开文件';

  @override
  String get settingsDataExportFailed => '导出失败';

  @override
  String get settingsCsvExportTitle => '导出为 CSV';

  @override
  String get settingsCsvExportSubtitle => '将交易保存为电子表格文件';

  @override
  String get settingsCsvExportFailed => 'CSV 导出失败';

  @override
  String get settingsCsvImportTitle => '从 CSV 导入';

  @override
  String get settingsCsvImportSubtitle => '从电子表格添加交易 — 不会替换任何现有数据';

  @override
  String get settingsCsvTemplateTitle => '获取 CSV 模板';

  @override
  String get settingsCsvTemplateSubtitle => '用于粘贴旧数据的示例文件';

  @override
  String get csvTemplateInstruction1 => '请用你自己的数据替换下面的示例行，然后在设置中导入此文件。';

  @override
  String get csvTemplateInstruction2 =>
      'date 和 amount 为必填项。日期请写成 YYYY-MM-DD，金额请填正数。';

  @override
  String get csvTemplateInstruction3 =>
      'type 可以是 income、expense、transfer、invoice、bill、advance、settlement、loan、collection 或 offset。留空则由应用根据账户自动判断。';

  @override
  String get csvTemplateInstruction4 => '尚不存在的账户和分类会自动创建。以 # 开头的行会被忽略。';

  @override
  String get csvImportPreviewTitle => '导入交易';

  @override
  String csvImportPreviewCounts(int importable, int total) {
    return '将添加 $total 行中的 $importable 行';
  }

  @override
  String csvImportPreviewNewAccounts(String names) {
    return '新账户：$names';
  }

  @override
  String csvImportPreviewNewCategories(String names) {
    return '新分类：$names';
  }

  @override
  String csvImportPreviewDuplicates(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 行已存在',
    );
    return '$_temp0';
  }

  @override
  String get csvImportPreviewSkipDuplicates => '跳过已存在的行';

  @override
  String csvImportPreviewIssuesTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 行无法读取',
    );
    return '$_temp0';
  }

  @override
  String csvImportPreviewIssueLine(int line, String reason) {
    return '第 $line 行：$reason';
  }

  @override
  String csvImportPreviewIssueMore(int count) {
    return '…另有 $count 行';
  }

  @override
  String get csvImportPreviewDateStyleTitle => '像 03/04/2026 这样的日期含义不明确。应如何解读？';

  @override
  String get csvImportPreviewDateStyleDayFirst => '日在前（4 月 3 日）';

  @override
  String get csvImportPreviewDateStyleMonthFirst => '月在前（3 月 4 日）';

  @override
  String get csvImportPreviewNothing => '此文件中没有可导入的行。';

  @override
  String get csvImportPreviewConfirm => '导入';

  @override
  String get csvRowProblemDate => '日期无效或缺失';

  @override
  String get csvRowProblemAmount => '金额无效或缺失';

  @override
  String get csvRowProblemAccount => '账户无效或缺失';

  @override
  String get csvRowProblemType => '未知的交易类型';

  @override
  String csvImportDone(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已导入 $count 笔交易',
    );
    return '$_temp0';
  }

  @override
  String get csvImportFailedNoColumns => '未识别到任何列。请从 CSV 模板开始。';

  @override
  String csvImportFailedMissingColumn(String column) {
    return '文件中没有“$column”列。';
  }

  @override
  String get csvImportFailedEmpty => '此文件没有数据行。';

  @override
  String csvImportFailedTooManyRows(int rows, int max) {
    return '此文件有 $rows 行，上限为 $max 行。';
  }

  @override
  String get csvImportFailed => 'CSV 导入失败';

  @override
  String get ledgerVerifyDialogTitle => '账本验证';

  @override
  String get ledgerVerifyAllMatch => '所有帐户都匹配。';

  @override
  String get ledgerVerifyMismatchesTitle => '不匹配';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\n存储：$stored\n重播：$replayed\n差异：$diff';
  }

  @override
  String get settingsLanguage => '应用语言';

  @override
  String get settingsLanguageSubtitleSystem => '以下系统设置';

  @override
  String get settingsLanguageSubtitleEnglish => '英语';

  @override
  String get settingsLanguageSubtitleSerbianLatin => '塞尔维亚语（拉丁语）';

  @override
  String get settingsLanguagePickerTitle => '应用语言';

  @override
  String get settingsLanguageOptionSystem => '系统默认';

  @override
  String get settingsLanguageOptionEnglish => '英语';

  @override
  String get settingsLanguageOptionSerbianLatin => '塞尔维亚语（拉丁语）';

  @override
  String get settingsSectionAppearance => '外貌';

  @override
  String get settingsSectionSecurity => '安全';

  @override
  String get settingsSecurityEnableLock => '锁定应用程序打开状态';

  @override
  String get settingsSecurityEnableLockSubtitle => '应用程序打开时需要生物识别解锁或 PIN';

  @override
  String get settingsSecurityLockDelayTitle => '后台后重新锁定';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      '应用在屏幕外停留多久后才需要重新解锁。立即是最安全的选项。';

  @override
  String get settingsSecurityLockDelayImmediate => '立即';

  @override
  String get settingsSecurityLockDelay30s => '30秒';

  @override
  String get settingsSecurityLockDelay1m => '1分钟';

  @override
  String get settingsSecurityLockDelay5m => '5分钟';

  @override
  String get settingsSecuritySetPin => '设置密码';

  @override
  String get settingsSecurityChangePin => '更改密码';

  @override
  String get settingsSecurityPinSubtitle => '如果生物识别不可用，请使用 PIN 作为后备措施';

  @override
  String get settingsSecurityRemovePin => '删除 PIN 码';

  @override
  String get securitySetPinTitle => '设置应用程序 PIN';

  @override
  String get securityPinLabel => '密码';

  @override
  String get securityConfirmPinLabel => '确认 PIN 码';

  @override
  String get securityPinMustBe4Digits => 'PIN 码必须至少有 4 位数字';

  @override
  String get securityPinMismatch => 'PIN 码不匹配';

  @override
  String get securityRemovePinTitle => '删除 PIN 码？';

  @override
  String get securityRemovePinBody => '如果有的话，仍然可以使用生物识别解锁。';

  @override
  String get securityUnlockTitle => '应用程序已锁定';

  @override
  String get securityUnlockSubtitle => '使用面容 ID、指纹或 PIN 码解锁。';

  @override
  String get securityUnlockWithPin => '使用 PIN 码解锁';

  @override
  String get securityTryBiometric => '尝试生物识别解锁';

  @override
  String get securityPinIncorrect => 'PIN 码不正确，请重试';

  @override
  String securityTooManyAttempts(int seconds) {
    return '尝试次数过多。请在 $seconds 秒后重试';
  }

  @override
  String get securityBiometricReason => '进行身份验证以打开您的应用程序';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSubtitleSystem => '以下系统设置';

  @override
  String get settingsThemeSubtitleLight => '光';

  @override
  String get settingsThemeSubtitleDark => '黑暗的';

  @override
  String get settingsThemePickerTitle => '主题';

  @override
  String get settingsThemeOptionSystem => '系统默认';

  @override
  String get settingsThemeOptionLight => '光';

  @override
  String get settingsThemeOptionDark => '黑暗的';

  @override
  String get archivedAccountsTitle => '存档帐户';

  @override
  String get archivedAccountsEmptyTitle => '没有存档帐户';

  @override
  String get archivedAccountsEmptyBody => '账面余额和透支必须为零。从“审核”中的帐户选项存档。';

  @override
  String get categoriesTitle => '类别';

  @override
  String get newCategoryTitle => '新类别';

  @override
  String get categoryNameLabel => '类别名称';

  @override
  String get deleteCategoryTitle => '删除类别？';

  @override
  String deleteCategoryBody(String category) {
    return '“$category”将从列表中删除。';
  }

  @override
  String get categoryIncome => '收入';

  @override
  String get categoryExpense => '费用';

  @override
  String get categoryAdd => '添加';

  @override
  String get editCategoryTitle => '编辑类别';

  @override
  String get categorySave => '保存';

  @override
  String get categoryRenameAction => '重命名';

  @override
  String get categoryDuplicateName => '已存在同名类别。';

  @override
  String get categoryInUseTitle => '类别正在使用中';

  @override
  String categoryInUseBody(String category, num count) {
    return '“$category”正在被 $count 笔交易使用。无法删除，但可以重命名——所有关联交易将自动更新。';
  }

  @override
  String get searchCurrencies => '搜索货币...';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1年';

  @override
  String get periodAll => '全部';

  @override
  String get categoryLabel => '类别';

  @override
  String get categoriesLabel => '类别';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type 已保存 • $amount';
  }

  @override
  String get tooltipSettings => '设置';

  @override
  String get tooltipAddAccount => '添加帐户';

  @override
  String get tooltipRemoveAccount => '删除帐户';

  @override
  String get accountNameTaken => '您已经拥有一个具有此名称和标识符的帐户（活动或已存档）。更改名称或标识符。';

  @override
  String get groupDescPersonal => '您自己的钱包和银行账户';

  @override
  String get groupDescIndividuals => '家人、朋友、个人';

  @override
  String get groupDescEntities => '实体、公用事业、组织';

  @override
  String get cannotArchiveTitle => '还不能存档';

  @override
  String get cannotArchiveBody => '仅当账面余额和透支限额实际上均为零时，存档才可用。';

  @override
  String get cannotArchiveBodyAdjust => '仅当账面余额和透支限额实际上均为零时，存档才可用。首先调整分类账或设施。';

  @override
  String get archiveAccountTitle => '存档帐户？';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条计划交易引用了此账户。',
      one: '1 条计划交易引用了此账户。',
    );
    return '$_temp0 请删除它们，以使计划与已归档账户保持一致。';
  }

  @override
  String get removeAndArchive => '删除计划和存档';

  @override
  String get archiveBody => '该帐户将对“审阅”、“跟踪”和“计划”选择器隐藏。您可以从“设置”中恢复它。';

  @override
  String get archiveAction => '档案';

  @override
  String get archiveInstead => '改为存档';

  @override
  String get cannotDeleteTitle => '无法删除帐户';

  @override
  String get cannotDeleteBodyShort =>
      '该帐户出现在您的跟踪历史记录中。首先删除或重新分配这些交易，或者在余额已清除的情况下存档帐户。';

  @override
  String get cannotDeleteBodyHistory =>
      '该帐户出现在您的跟踪历史记录中。删除会破坏该历史记录——首先删除或重新分配这些事务。';

  @override
  String get cannotDeleteBodySuggestArchive =>
      '该帐户出现在您的跟踪历史记录中，因此无法删除。如果账面余额和透支已清除，您可以将其存档 - 它将从列表中隐藏，但历史记录保持不变。';

  @override
  String get deleteAccountTitle => '删除帐户？';

  @override
  String get deleteAccountBodyPermanent => '该帐户将被永久删除。';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条计划交易引用了此账户，也将被删除。',
      one: '1 条计划交易引用了此账户，也将被删除。',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => '全部删除';

  @override
  String get editAccountTitle => '编辑帐户';

  @override
  String get newAccountTitle => '新账户';

  @override
  String get labelAccountName => '帐户名称';

  @override
  String get labelAccountIdentifier => '标识符（可选）';

  @override
  String get accountAppearanceSection => '图标和颜色';

  @override
  String get accountPickIcon => '选择图标';

  @override
  String get accountPickColor => '选择颜色';

  @override
  String get accountIconSheetTitle => '帐户图标';

  @override
  String get accountColorSheetTitle => '帐号颜色';

  @override
  String get searchAccountIcons => '按名称搜索图标…';

  @override
  String get accountIconSearchNoMatches => '没有与该搜索匹配的图标。';

  @override
  String get accountUseInitialLetter => '首字母';

  @override
  String get accountUseDefaultColor => '比赛组';

  @override
  String get labelRealBalance => '实际余额';

  @override
  String get labelOverdraftLimit => '透支/预支限额';

  @override
  String get labelCurrency => '货币';

  @override
  String get saveChanges => '保存更改';

  @override
  String get addAccountAction => '添加账户';

  @override
  String get removeAccountSheetTitle => '删除帐户';

  @override
  String get deletePermanently => '永久删除';

  @override
  String get deletePermanentlySubtitle =>
      '仅当此帐户未在 Track 中使用时才可用。计划项目可以作为删除的一部分被删除。';

  @override
  String get archiveOptionSubtitle => '隐藏审阅和选择器。随时从“设置”恢复。需要零余额和透支。';

  @override
  String get archivedBannerText => '该帐户已存档。它保留在您的数据中，但对列表和选择器隐藏。';

  @override
  String get balanceAdjustedTitle => '轨道中的平衡调整';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return '实际余额从$previous更新为$current$symbol。\n\n在跟踪（历史记录）中创建了余额调整交易，以保持账本一致。\n\n• 实际余额反映该账户的实际金额。\n• 检查调整条目的历史记录。';
  }

  @override
  String get ok => '好的';

  @override
  String get categoryBalanceAdjustment => '平衡调整';

  @override
  String get descriptionBalanceCorrection => '平衡校正';

  @override
  String get descriptionOpeningBalance => '期初余额';

  @override
  String get reviewStatsModeStatistics => '统计数据';

  @override
  String get reviewStatsModeComparison => '比较';

  @override
  String get statsUncategorized => '未分类';

  @override
  String get statsNoCategories => '所选期间没有类别可供比较。';

  @override
  String get statsNoTransactions => '没有交易';

  @override
  String get statsSpendingInCategory => '此类别的支出';

  @override
  String get statsIncomeInCategory => '此类别的收入';

  @override
  String get statsDifference => '差异（B 与 A）：';

  @override
  String get statsNoExpensesMonth => '本月无任何开支';

  @override
  String get statsNoExpensesAll => '没有记录任何费用';

  @override
  String statsNoExpensesPeriod(String period) {
    return '过去$period没有任何费用';
  }

  @override
  String get statsTotalSpent => '总支出';

  @override
  String get statsNoExpensesThisPeriod => '此期间无任何费用';

  @override
  String get statsNoIncomeMonth => '这个月没有收入';

  @override
  String get statsNoIncomeAll => '没有收入记录';

  @override
  String statsNoIncomePeriod(String period) {
    return '过去$period没有收入';
  }

  @override
  String get statsTotalReceived => '收到总计';

  @override
  String get statsNoIncomeThisPeriod => '此期间无收入';

  @override
  String get catSalary => '薪水';

  @override
  String get catFreelance => '自由职业者';

  @override
  String get catConsulting => '咨询';

  @override
  String get catGift => '礼物';

  @override
  String get catRental => '出租';

  @override
  String get catDividends => '股息';

  @override
  String get catRefund => '退款';

  @override
  String get catBonus => '奖金';

  @override
  String get catInterest => '兴趣';

  @override
  String get catSideHustle => '副业';

  @override
  String get catSaleOfGoods => '商品销售';

  @override
  String get catOther => '其他';

  @override
  String get catGroceries => '杂货';

  @override
  String get catDining => '用餐';

  @override
  String get catTransport => '运输';

  @override
  String get catUtilities => '公用事业';

  @override
  String get catHousing => '住房';

  @override
  String get catHealthcare => '卫生保健';

  @override
  String get catEntertainment => '娱乐';

  @override
  String get catShopping => '购物';

  @override
  String get catTravel => '旅行';

  @override
  String get catEducation => '教育';

  @override
  String get catSubscriptions => '订阅';

  @override
  String get catInsurance => '保险';

  @override
  String get catFuel => '燃料';

  @override
  String get catGym => '健身房';

  @override
  String get catPets => '宠物';

  @override
  String get catKids => '孩子们';

  @override
  String get catCharity => '慈善事业';

  @override
  String get catCoffee => '咖啡';

  @override
  String get catGifts => '礼物';

  @override
  String semanticsProjectionDate(String date) {
    return '投影日期$date。双击选择日期';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return '预计个人余额$amount';
  }

  @override
  String get statsEmptyTitle => '还没有交易';

  @override
  String get statsEmptySubtitle => '所选范围内没有支出数据。';

  @override
  String get semanticsShowProjections => '按账户显示预计余额';

  @override
  String get semanticsHideProjections => '按账户隐藏预计余额';

  @override
  String get semanticsShowDayBalanceBreakdown => '显示本日账户余额';

  @override
  String get semanticsHideDayBalanceBreakdown => '隐藏本日账户余额';

  @override
  String get semanticsDateAllTime => '日期：所有时间 — 点击即可更改模式';

  @override
  String semanticsDateMode(String mode) {
    return '日期：$mode — 点击即可更改模式';
  }

  @override
  String get semanticsDateThisMonth => '日期：本月 — 点击月份、周、年或所有时间';

  @override
  String get semanticsTxTypeCycle => '交易类型：循环全部、收入、支出、转账';

  @override
  String get semanticsAccountFilter => '账户过滤器';

  @override
  String get semanticsAlreadyFiltered => '已过滤到此帐户';

  @override
  String get semanticsCategoryFilter => '类别过滤器';

  @override
  String get semanticsSortToggle => '排序：切换最新或最旧的优先';

  @override
  String get semanticsFiltersDisabled => '列出在查看未来投影日期时禁用的过滤器。清除投影以使用过滤器。';

  @override
  String get semanticsFiltersDisabledNeedAccount => '列表过滤器已禁用。首先添加一个帐户。';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      '列表过滤器已禁用。首先添加计划交易。';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      '列表过滤器已禁用。先记录一笔交易。';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      '部分和货币控制已禁用。首先添加一个帐户。';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      '预测日期和余额明细已禁用。首先添加账户和计划交易。';

  @override
  String get semanticsReorderAccountHint => '长按，然后拖动以在该组内重新排序';

  @override
  String get semanticsChartStyle => '图表样式';

  @override
  String get semanticsChartStyleUnavailable => '图表样式（比较模式下不可用）';

  @override
  String semanticsPeriod(String label) {
    return '期间：$label';
  }

  @override
  String get trackSearchHint => '搜索描述、类别、帐户...';

  @override
  String get trackSearchClear => '清除搜索';

  @override
  String get settingsExchangeRatesTitle => '汇率';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return '最后更新：$time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated => '使用离线或捆绑费率 — 点击刷新';

  @override
  String get settingsExchangeRatesSource => '欧洲央行';

  @override
  String get settingsExchangeRatesUpdatedSnack => '汇率已更新';

  @override
  String get settingsExchangeRatesUpdateFailed => '无法更新汇率。检查您的连接。';

  @override
  String get settingsClearData => '清除数据';

  @override
  String get settingsClearDataSubtitle => '永久删除选定的数据';

  @override
  String get clearDataTitle => '清除数据';

  @override
  String get clearDataTransactions => '交易记录';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count交易·账户余额清零';
  }

  @override
  String get clearDataPlanned => '计划交易';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count 计划项目';
  }

  @override
  String get clearDataAccounts => '账户';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count 账户 · 还清除历史记录和计划';
  }

  @override
  String get clearDataCategories => '类别';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count 类别 · 替换为默认值';
  }

  @override
  String get clearDataPreferences => '偏好设置';

  @override
  String get clearDataPreferencesSubtitle => '将货币、主题和语言重置为默认值';

  @override
  String get clearDataSecurity => '应用程序锁定和 PIN';

  @override
  String get clearDataSecuritySubtitle => '禁用应用程序锁定并删除 PIN';

  @override
  String get clearDataConfirmButton => '清除所选内容';

  @override
  String get clearDataConfirmTitle => '此操作无法撤消';

  @override
  String get clearDataConfirmBody => '所选数据将被永久删除。如果稍后需要，请先导出备份。';

  @override
  String get clearDataTypeConfirm => '键入 删除 进行确认';

  @override
  String get clearDataTypeConfirmError => '准确键入 删除 以继续';

  @override
  String get clearDataPinTitle => '使用 PIN 码确认';

  @override
  String get clearDataPinBody => '输入您的应用程序 PIN 码以授权此操作。';

  @override
  String get clearDataPinIncorrect => 'PIN 码不正确';

  @override
  String get clearDataDone => '已清除所选数据';

  @override
  String get autoBackupTitle => '每日自动备份';

  @override
  String autoBackupLastAt(String date) {
    return '最后备份$date';
  }

  @override
  String get autoBackupNeverRun => '还没有备份';

  @override
  String get autoBackupShareTitle => '保存到云端';

  @override
  String get autoBackupShareSubtitle =>
      '将最新备份上传到 iCloud Drive、Google Drive 或任何应用程序';

  @override
  String get autoBackupCloudReminder => '自动备份就绪 - 将其保存到云端以实现设备外保护';

  @override
  String get autoBackupCloudReminderAction => '分享';

  @override
  String get settingsBackupReminderTitle => '备份提醒';

  @override
  String get settingsBackupReminderSubtitle => '如果您添加了许多交易而未导出手动备份，将显示应用内横幅。';

  @override
  String get settingsBackupReminderThresholdTitle => '交易阈值';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return '自上次手动导出后新增 $count 笔交易后提醒。';
  }

  @override
  String get settingsBackupReminderThresholdInvalid => '请输入1到500之间的整数。';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '\"稍后提醒\"会隐藏横幅，直到您再添加 $n 笔交易。';
  }

  @override
  String get backupReminderBannerTitle => '导出备份？';

  @override
  String backupReminderBannerBody(int count) {
    return '自上次手动导出以来，您已添加 $count 笔交易。';
  }

  @override
  String get backupReminderRemindLater => '稍后提醒';

  @override
  String get backupExportLedgerVerifyTitle => '备份前账本检查';

  @override
  String get backupExportLedgerVerifyInfo =>
      '将每个账户的存储余额与您完整的历史记录重播进行比较。无论如何您都可以导出备份；不一致仅供参考。';

  @override
  String get backupExportLedgerVerifyContinue => '继续备份';

  @override
  String get persistenceErrorReloaded => '无法保存更改。数据已从存储中重新加载。';

  @override
  String get helpTooltip => '帮助';

  @override
  String get helpNext => '下一步';

  @override
  String get helpBack => '上一步';

  @override
  String get helpDone => '完成';

  @override
  String get helpSkip => '跳过';

  @override
  String get helpTrackHeroTitle => '总额与筛选';

  @override
  String get helpTrackHeroBody =>
      '此卡片汇总下方列表的收支。筛选标签可按账户、类别和类型过滤；日期标签在日、周、月、年之间切换；箭头可反转排序。';

  @override
  String get helpTrackListTitle => '你的历史记录';

  @override
  String get helpTrackListBody => '已记录的交易按天分组。点按可查看或编辑，也可以用搜索找到特定记录。';

  @override
  String get helpTrackFabTitle => '添加交易';

  @override
  String get helpTrackFabBody => '记录收入、支出或账户之间的转账。';

  @override
  String get helpSettingsTitle => '设置';

  @override
  String get helpSettingsBody => '货币、语言、主题、安全、备份和账户管理都在这里。';

  @override
  String get helpPlanHeroTitle => '预测';

  @override
  String get helpPlanHeroBody => '所选日期的个人余额和净余额。下方的标签用于筛选计划交易。';

  @override
  String get helpPlanListTitle => '计划交易';

  @override
  String get helpPlanListBody => '预期的收入、支出和转账。点按可编辑；顶部的标签用于筛选此列表。';

  @override
  String get helpPlanFabTitle => '添加计划';

  @override
  String get helpPlanFabBody => '安排一笔预期交易，也可以设置重复。';

  @override
  String get helpPlanProjectionFabTitle => '预测未来';

  @override
  String get helpPlanProjectionFabBody =>
      '点按地球按钮选择未来日期即可查看预测余额——将应用截至该日期的计划交易。也可以点按上方卡片中的日期。';

  @override
  String get helpReviewHeroTitle => '净资产';

  @override
  String get helpReviewHeroBody => '一眼掌握个人余额和净资产。点按金额可在基础货币和第二货币之间切换。';

  @override
  String get helpReviewSectionsTitle => '分区';

  @override
  String get helpReviewSectionsBody => '左右滑动或点按标签，在个人账户、个人、机构和统计之间切换。';

  @override
  String get helpReviewAccountsTitle => '账户';

  @override
  String get helpReviewAccountsBody => '每张卡片显示一个账户及其余额。点按可打开完整交易历史。';

  @override
  String get helpReviewFabTitle => '添加账户';

  @override
  String get helpReviewFabBody => '为现金、银行卡和储蓄创建账户，也可以为你关注的个人和企业创建账户。';

  @override
  String get helpSettingsSecurityTitle => '安全';

  @override
  String get helpSettingsSecurityBody => '用设备的锁屏方式锁定应用，并选择重新锁定的速度。';

  @override
  String get helpSettingsPreferencesTitle => '偏好设置';

  @override
  String get helpSettingsPreferencesBody => '语言、主题、货币及其他日常选项。';

  @override
  String get helpSettingsDataTitle => '你的数据';

  @override
  String get helpSettingsDataBody =>
      '导出加密备份，在其他设备上导入，并调整自动备份。除非你导出，数据始终保留在本设备上。';

  @override
  String get helpSettingsManageTitle => '管理';

  @override
  String get helpSettingsManageBody => '编辑账户、重命名类别——更改会应用到整个应用。';

  @override
  String get helpTxAccountsTitle => '转出与转入';

  @override
  String get helpTxAccountsBody => '选择钱从哪里来、到哪里去。仅转出:支出。仅转入:收入。两者都选:账户间转账。';

  @override
  String get helpTxDetailsTitle => '金额与详情';

  @override
  String get helpTxDetailsBody => '输入金额，再添加类别、备注或附件，以便日后查找。';

  @override
  String get helpTxDateTitle => '日期';

  @override
  String get helpTxDateBody => '点按此处修改交易日期。';

  @override
  String get helpPlannedDateTitle => '预定日期';

  @override
  String get helpPlannedDateBody => '点按此处选择执行时间。计划也可以按你选择的周期重复。';

  @override
  String get helpPlannedProjectionTitle => '预测余额';

  @override
  String get helpPlannedProjectionBody =>
      '账户选择器会显示每个账户在预定日期的预测余额，帮你发现会导致透支的计划。';

  @override
  String get settingsPlannedRemindersTitle => '计划提醒';

  @override
  String get settingsPlannedRemindersSubtitle =>
      '在计划交易到期时通知您。完全离线运行——任何数据都不会离开您的设备。';

  @override
  String get settingsPlannedRemindersTimeTitle => '提醒时间';

  @override
  String get settingsPlannedRemindersLeadTitle => '提前提醒';

  @override
  String get settingsPlannedRemindersLeadOnDay => '到期当天';

  @override
  String settingsPlannedRemindersLeadDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '提前 $count 天',
    );
    return '$_temp0';
  }

  @override
  String get settingsPlannedRemindersPermissionDenied =>
      'Platrare 的通知已关闭。请在系统设置中允许通知以接收提醒。';

  @override
  String get plannedReminderChannelName => '计划交易提醒';

  @override
  String get plannedReminderChannelDescription => '即将到期的计划交易通知。';

  @override
  String get plannedReminderFallbackTitle => '计划交易';

  @override
  String get plannedReminderDueToday => '今天到期';

  @override
  String get plannedReminderDueTomorrow => '明天到期';

  @override
  String plannedReminderDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天后到期',
    );
    return '$_temp0';
  }

  @override
  String get aboutContactSupport => '联系支持';

  @override
  String get aboutSupportEmailCopied => '已复制支持邮箱地址';

  @override
  String get onboardingWelcomeTitle => '欢迎使用 Platrare';

  @override
  String get onboardingWelcomeBody => '您的资金数据只保存在此设备上。无需账户，没有广告，不做追踪。';

  @override
  String get onboardingPlanBody => '安排即将到来和定期的付款，查看余额走向。';

  @override
  String get onboardingTrackBody => '记录收入、支出、转账以及借出或欠下的款项。';

  @override
  String get onboardingReviewBody => '为您的账户、往来对象和企业提供统计、对比和历史记录。';

  @override
  String get onboardingCurrencyLabel => '基准货币';

  @override
  String get onboardingCurrencyHint => '根据设备语言推荐，之后可在设置中更改。';

  @override
  String get onboardingStart => '开始使用';

  @override
  String get onboardingTour => '带我了解一下';

  @override
  String get clearDataConfirmWord => '删除';

  @override
  String get planDeleteTitle => '删除计划交易？';

  @override
  String get planDeleteBody => '它将从计划中移除，账户余额不受影响。';

  @override
  String get semanticsPreviousPeriod => '上一期间';

  @override
  String get semanticsNextPeriod => '下一期间';

  @override
  String get semanticsSectionStatistics => '统计';

  @override
  String get semanticsCurrencyToggle => '切换显示货币';

  @override
  String get semanticsStatsSpent => '支出';

  @override
  String get semanticsStatsReceived => '收入';
}
