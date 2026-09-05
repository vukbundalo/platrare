// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Plan';

  @override
  String get navTrack => 'Track';

  @override
  String get navReview => 'Review';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get add => 'Add';

  @override
  String get undo => 'Undo';

  @override
  String get confirm => 'Confirm';

  @override
  String get restore => 'Restore';

  @override
  String get heroIn => 'In';

  @override
  String get heroOut => 'Out';

  @override
  String get heroNet => 'Net';

  @override
  String get widgetLowestPoint => 'Lowest point';

  @override
  String get widgetProjected => 'Projected';

  @override
  String get widgetHorizonIn7Days => 'In 7 days';

  @override
  String get widgetHorizonEndOfMonth => 'End of month';

  @override
  String get widgetMetricAccount => 'Account balance';

  @override
  String get widgetQuickAdd => 'Quick add';

  @override
  String get widgetStale => 'May be out of date';

  @override
  String get widgetOpenToStart => 'Open Platrare to add accounts';

  @override
  String get widgetDueToday => 'Due today';

  @override
  String get widgetDescQuickAdd => 'Add a transaction or a plan in one tap.';

  @override
  String get widgetNameNumbers => 'Balance';

  @override
  String get widgetDescNumbers =>
      'Show one figure: spendable, net worth, or your lowest point this month.';

  @override
  String get widgetConfigMetric => 'Metric';

  @override
  String get widgetConfigHorizon => 'Horizon';

  @override
  String widgetSiriAddTransaction(String appName) {
    return 'Add a transaction in $appName';
  }

  @override
  String widgetSiriAddPlanned(String appName) {
    return 'Add a planned transaction in $appName';
  }

  @override
  String get settingsWidgetAmountsTitle => 'Show amounts in widgets';

  @override
  String get settingsWidgetAmountsSubtitle =>
      'Home-screen widgets are visible without unlocking the app. While app lock is on, amounts stay masked unless you turn this on.';

  @override
  String get heroBalance => 'Balance';

  @override
  String get realBalance => 'Real balance';

  @override
  String get settingsHideHeroBalancesTitle => 'Hide balances in summary cards';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'When on, amounts on Plan, Track, and Review stay masked until you tap the eye icon on each tab. When off, balances are always visible.';

  @override
  String get heroBalancesShow => 'Show balances';

  @override
  String get heroBalancesHide => 'Hide balances';

  @override
  String get semanticsHeroBalanceHidden => 'Balance hidden for privacy';

  @override
  String get heroResetButton => 'Reset';

  @override
  String get fabScrollToTop => 'Back to top';

  @override
  String get fabPickProjectionDate => 'Choose projection date';

  @override
  String get filterAll => 'All';

  @override
  String get filterAllAccounts => 'All accounts';

  @override
  String get filterAllCategories => 'All categories';

  @override
  String get txLabelIncome => 'INCOME';

  @override
  String get txLabelExpense => 'EXPENSE';

  @override
  String get txLabelInvoice => 'INVOICE';

  @override
  String get txLabelBill => 'BILL';

  @override
  String get txLabelAdvance => 'ADVANCE';

  @override
  String get txLabelSettlement => 'SETTLEMENT';

  @override
  String get txLabelLoan => 'LOAN';

  @override
  String get txLabelCollection => 'COLLECTION';

  @override
  String get txLabelOffset => 'OFFSET';

  @override
  String get txLabelTransfer => 'TRANSFER';

  @override
  String get txLabelTransaction => 'TRANSACTION';

  @override
  String get repeatNone => 'No repeat';

  @override
  String get repeatDaily => 'Daily';

  @override
  String get repeatWeekly => 'Weekly';

  @override
  String get repeatMonthly => 'Monthly';

  @override
  String get repeatYearly => 'Yearly';

  @override
  String get repeatEveryLabel => 'Every';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: 'week',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: 'month',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: 'year',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Ends';

  @override
  String get repeatEndNever => 'Never';

  @override
  String get repeatEndOnDate => 'On date';

  @override
  String repeatEndAfterCount(int count) {
    return 'After $count times';
  }

  @override
  String get repeatEndAfterChoice => 'After a number of times';

  @override
  String get repeatEndPickDate => 'Pick end date';

  @override
  String get repeatEndTimes => 'times';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Every $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'until $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count times';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining of $total remaining';
  }

  @override
  String get detailRepeatEvery => 'Repeat every';

  @override
  String get detailEnds => 'Ends';

  @override
  String get detailEndsNever => 'Never';

  @override
  String detailEndsOnDate(String date) {
    return 'On $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'After $count times';
  }

  @override
  String get detailProgress => 'Progress';

  @override
  String get weekendNoChange => 'No change';

  @override
  String get weekendFriday => 'Move to Friday';

  @override
  String get weekendMonday => 'Move to Monday';

  @override
  String weekendQuestion(String day) {
    return 'If the $day falls on a weekend?';
  }

  @override
  String get dateToday => 'Today';

  @override
  String get dateTomorrow => 'Tomorrow';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get statsAllTime => 'All time';

  @override
  String get accountGroupPersonal => 'Personal';

  @override
  String get accountGroupIndividual => 'Individual';

  @override
  String get accountGroupEntity => 'Entity';

  @override
  String get accountSectionIndividuals => 'Individuals';

  @override
  String get accountSectionEntities => 'Entities';

  @override
  String get emptyNoTransactionsYet => 'No transactions yet';

  @override
  String get emptyNoAccountsYet => 'No accounts yet';

  @override
  String get emptyRecordFirstTransaction =>
      'Tap the button below to record your first transaction.';

  @override
  String get emptyAddFirstAccountTx =>
      'Add your first account before recording transactions.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Add your first account before planning transactions.';

  @override
  String get emptyAddFirstAccountReview =>
      'Add your first account to start tracking your finances.';

  @override
  String get emptyAddTransaction => 'Add transaction';

  @override
  String get emptyAddAccount => 'Add account';

  @override
  String get reviewEmptyGroupPersonalTitle => 'No personal accounts yet';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Personal accounts are your own wallets and bank accounts. Add one to track everyday income and spending.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'No individual accounts yet';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Individual accounts track money with specific people—shared costs, loans, or IOUs. Add an account for each person you settle with.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'No entity accounts yet';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Entity accounts are for businesses, projects, or organizations. Use them to keep business cash flow separate from your personal finances.';

  @override
  String get emptyNoTransactionsForFilters =>
      'No transactions for applied filters';

  @override
  String get emptyNoTransactionsInHistory => 'No transactions in history';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'No transactions for $month';
  }

  @override
  String get emptyNoTransactionsForAccount =>
      'No transactions for this account';

  @override
  String get trackTransactionDeleted => 'Transaction deleted';

  @override
  String get trackDeleteTitle => 'Delete transaction?';

  @override
  String get trackDeleteBody =>
      'This will reverse the account balance changes.';

  @override
  String get trackTransaction => 'Transaction';

  @override
  String get planConfirmTitle => 'Confirm transaction?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'This occurrence is scheduled for $date. It will be recorded in History with today’s date ($todayDate). The next occurrence remains on $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'This will apply the transaction to your real account balances and move it to History.';

  @override
  String get planTransactionConfirmed => 'Transaction confirmed and applied';

  @override
  String get planTransactionRemoved => 'Planned transaction removed';

  @override
  String get planRepeatingTitle => 'Repeating transaction';

  @override
  String get planRepeatingBody =>
      'Skip only this date—the series continues with the next occurrence—or delete every remaining occurrence from your plan.';

  @override
  String get planDeleteAll => 'Delete all';

  @override
  String get planSkipThisOnly => 'Skip this only';

  @override
  String get planOccurrenceSkipped =>
      'This occurrence skipped — next one scheduled';

  @override
  String get planNothingPlanned => 'Nothing planned for now';

  @override
  String get planPlanBody => 'Plan upcoming transactions.';

  @override
  String get planAddPlan => 'Add plan';

  @override
  String get planNoPlannedForFilters =>
      'No planned transactions for applied filters';

  @override
  String planNoPlannedInMonth(String month) {
    return 'No planned transactions in $month';
  }

  @override
  String get planOverdue => 'overdue';

  @override
  String get planPlannedTransaction => 'Planned transaction';

  @override
  String get discardTitle => 'Discard changes?';

  @override
  String get discardBody =>
      'You have unsaved changes. They will be lost if you leave now.';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String get discard => 'Discard';

  @override
  String get newTransactionTitle => 'New Transaction';

  @override
  String get editTransactionTitle => 'Edit Transaction';

  @override
  String get transactionUpdated => 'Transaction updated';

  @override
  String get sectionAccounts => 'Accounts';

  @override
  String get labelFrom => 'From';

  @override
  String get labelTo => 'To';

  @override
  String get sectionCategory => 'Category';

  @override
  String get sectionAttachments => 'Attachments';

  @override
  String get labelNote => 'Note';

  @override
  String get hintOptionalDescription => 'Optional description';

  @override
  String get updateTransaction => 'Update Transaction';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get selectAccount => 'Select account';

  @override
  String get selectAccountTitle => 'Select Account';

  @override
  String get noAccountsAvailable => 'No accounts available';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Amount received by $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Enter the exact amount the destination account receives. This locks the real exchange rate used.';

  @override
  String get attachTakePhoto => 'Take photo';

  @override
  String get attachTakePhotoSub => 'Use camera to capture a receipt';

  @override
  String get attachChooseGallery => 'Choose from gallery';

  @override
  String get attachChooseGallerySub => 'Select photos from your library';

  @override
  String get attachBrowseFiles => 'Browse files';

  @override
  String get attachBrowseFilesSub => 'Attach PDFs, documents or other files';

  @override
  String get attachButton => 'Attach';

  @override
  String get editPlanTitle => 'Edit Plan';

  @override
  String get planTransactionTitle => 'Plan Transaction';

  @override
  String get tapToSelect => 'Tap to select';

  @override
  String get updatePlan => 'Update Plan';

  @override
  String get addToPlan => 'Add to Plan';

  @override
  String get labelRepeat => 'Repeat';

  @override
  String get selectPlannedDate => 'Select planned date';

  @override
  String get balancesAsOfToday => 'Balances as of today';

  @override
  String get projectedBalancesForTomorrow => 'Projected balances for tomorrow';

  @override
  String projectedBalancesForDate(String date) {
    return 'Projected balances for $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name receives ($currency)';
  }

  @override
  String get destHelper =>
      'Estimated destination amount. Exact rate is locked at confirmation.';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get detailTransactionTitle => 'Transaction';

  @override
  String get detailPlannedTitle => 'Planned';

  @override
  String get detailConfirmTransaction => 'Confirm transaction';

  @override
  String get detailDate => 'Date';

  @override
  String get detailFrom => 'From';

  @override
  String get detailTo => 'To';

  @override
  String get detailCategory => 'Category';

  @override
  String get detailNote => 'Note';

  @override
  String get detailDestinationAmount => 'Destination amount';

  @override
  String get detailExchangeRate => 'Exchange rate';

  @override
  String get detailRepeats => 'Repeats';

  @override
  String get detailDayOfMonth => 'Day of month';

  @override
  String get detailWeekends => 'Weekends';

  @override
  String get detailAttachments => 'Attachments';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionDisplay => 'Display';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsSectionCategories => 'Categories';

  @override
  String get settingsSectionAccounts => 'Accounts';

  @override
  String get settingsSectionPreferences => 'Preferences';

  @override
  String get settingsSectionManage => 'Manage';

  @override
  String get settingsBaseCurrency => 'Home currency';

  @override
  String get settingsSecondaryCurrency => 'Secondary currency';

  @override
  String get settingsCategories => 'Categories';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount income · $expenseCount expense';
  }

  @override
  String get settingsArchivedAccounts => 'Archived accounts';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'None right now — archive from account edit when balance is clear';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count hidden from Review and pickers';
  }

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsSectionPrivacy => 'About';

  @override
  String get settingsPrivacyPolicyTitle => 'Privacy policy';

  @override
  String get settingsPrivacyPolicySubtitle => 'How Platrare handles your data.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Exchange rates: the app fetches public currency rates over the internet. Your accounts and transactions are never sent.';

  @override
  String get settingsPrivacyOpenFailed => 'Could not load the privacy policy.';

  @override
  String get settingsPrivacyRetry => 'Try again';

  @override
  String get settingsSoftwareVersionTitle => 'Software version';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Release, diagnostics, and legal';

  @override
  String get aboutScreenTitle => 'About';

  @override
  String get aboutAppTagline =>
      'Ledger, cashflow, and planning in one workspace.';

  @override
  String get aboutDescriptionBody =>
      'Platrare keeps accounts, transactions, and plans on your device. Export encrypted backups when you need a copy elsewhere. Exchange rates use public market data only; your ledger is not uploaded.';

  @override
  String get aboutVersionLabel => 'Version';

  @override
  String get aboutBuildLabel => 'Build';

  @override
  String get aboutCopySupportDetails => 'Copy support details';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Opens the full in-app policy document.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Locale';

  @override
  String get settingsSupportInfoCopied => 'Copied to clipboard';

  @override
  String get settingsVerifyLedger => 'Verify data';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Check that account balances match your transaction history';

  @override
  String get settingsDataExportTitle => 'Export backup';

  @override
  String get settingsDataExportSubtitle =>
      'Save as .zip or encrypted .platrare with all data and attachments';

  @override
  String get settingsDataImportTitle => 'Restore from backup';

  @override
  String get settingsDataImportSubtitle =>
      'Replace current data from a Platrare .zip or .platrare backup';

  @override
  String get backupExportDialogTitle => 'Protect this backup';

  @override
  String get backupExportDialogBody =>
      'A strong password is recommended, especially if you store the file in the cloud. You need the same password to import.';

  @override
  String get backupExportPasswordLabel => 'Password';

  @override
  String get backupExportPasswordConfirmLabel => 'Confirm password';

  @override
  String get backupExportPasswordMismatch => 'Passwords do not match';

  @override
  String get backupExportPasswordEmpty =>
      'Enter a matching password, or export without encryption below.';

  @override
  String get backupExportPasswordTooShort =>
      'Password must be at least 8 characters.';

  @override
  String get backupExportSaveToDevice => 'Save to device';

  @override
  String get backupExportShareToCloud => 'Share (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Export without encryption';

  @override
  String get backupExportSkipWarningTitle => 'Export without encryption?';

  @override
  String get backupExportSkipWarningBody =>
      'Anyone with access to the file can read your data. Use this only for local copies you control.';

  @override
  String get backupExportSkipWarningConfirm => 'Export unencrypted';

  @override
  String get backupImportPasswordTitle => 'Encrypted backup';

  @override
  String get backupImportPasswordBody =>
      'Enter the password you used when exporting.';

  @override
  String get backupImportPasswordLabel => 'Password';

  @override
  String get backupImportPreviewTitle => 'Backup summary';

  @override
  String backupImportPreviewVersion(String version) {
    return 'App version: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Exported: $date';
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
    return '$accounts accounts · $transactions transactions · $planned planned · $attachments attachment files · $income income categories · $expense expense categories';
  }

  @override
  String get backupImportPreviewContinue => 'Continue';

  @override
  String get settingsBackupWrongPassword => 'Wrong password';

  @override
  String get settingsBackupChecksumMismatch => 'Backup failed integrity check';

  @override
  String get settingsBackupCorruptFile => 'Invalid or damaged backup file';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Backup needs a newer app version';

  @override
  String get settingsDataImportConfirmTitle => 'Replace current data?';

  @override
  String get settingsDataImportConfirmBody =>
      'This will replace your current accounts, transactions, planned transactions, categories, and imported attachments with the contents of the selected backup. This action cannot be undone.';

  @override
  String get settingsDataImportConfirmAction => 'Replace data';

  @override
  String get settingsDataImportDone => 'Data restored successfully';

  @override
  String get settingsDataImportInvalidFile =>
      'This file is not a valid Platrare backup';

  @override
  String get settingsDataImportFailed => 'Import failed';

  @override
  String get settingsDataExportDoneTitle => 'Backup exported';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Backup saved to:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Open file';

  @override
  String get settingsDataExportFailed => 'Export failed';

  @override
  String get settingsCsvExportTitle => 'Export as CSV';

  @override
  String get settingsCsvExportSubtitle =>
      'Your transactions as a spreadsheet file';

  @override
  String get settingsCsvExportFailed => 'CSV export failed';

  @override
  String get settingsCsvImportTitle => 'Import from CSV';

  @override
  String get settingsCsvImportSubtitle =>
      'Add transactions from a spreadsheet — nothing is replaced';

  @override
  String get settingsCsvTemplateTitle => 'Get CSV template';

  @override
  String get settingsCsvTemplateSubtitle =>
      'An example file to paste your old data into';

  @override
  String get csvTemplateInstruction1 =>
      'Replace the example rows below with your own data, then import this file from Settings.';

  @override
  String get csvTemplateInstruction2 =>
      'date and amount are required. Write dates as YYYY-MM-DD and amounts as a positive number.';

  @override
  String get csvTemplateInstruction3 =>
      'type can be income, expense, transfer, invoice, bill, advance, settlement, loan, collection or offset. Leave it empty to let the app work it out from the accounts.';

  @override
  String get csvTemplateInstruction4 =>
      'Accounts and categories that do not exist yet are created for you. Lines starting with # are ignored.';

  @override
  String get csvImportPreviewTitle => 'Import transactions';

  @override
  String csvImportPreviewCounts(int importable, int total) {
    return '$importable of $total rows will be added';
  }

  @override
  String csvImportPreviewNewAccounts(String names) {
    return 'New accounts: $names';
  }

  @override
  String csvImportPreviewNewCategories(String names) {
    return 'New categories: $names';
  }

  @override
  String csvImportPreviewDuplicates(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows already exist',
      one: '1 row already exists',
    );
    return '$_temp0';
  }

  @override
  String get csvImportPreviewSkipDuplicates => 'Skip rows that already exist';

  @override
  String csvImportPreviewIssuesTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows could not be read',
      one: '1 row could not be read',
    );
    return '$_temp0';
  }

  @override
  String csvImportPreviewIssueLine(int line, String reason) {
    return 'Line $line: $reason';
  }

  @override
  String csvImportPreviewIssueMore(int count) {
    return '…and $count more';
  }

  @override
  String get csvImportPreviewDateStyleTitle =>
      'Dates like 03/04/2026 are ambiguous. How should they be read?';

  @override
  String get csvImportPreviewDateStyleDayFirst => 'Day first (03 April)';

  @override
  String get csvImportPreviewDateStyleMonthFirst => 'Month first (04 March)';

  @override
  String get csvImportPreviewNothing => 'No rows in this file can be imported.';

  @override
  String get csvImportPreviewConfirm => 'Import';

  @override
  String get csvRowProblemDate => 'invalid or missing date';

  @override
  String get csvRowProblemAmount => 'invalid or missing amount';

  @override
  String get csvRowProblemAccount => 'invalid or missing account';

  @override
  String get csvRowProblemType => 'unknown transaction type';

  @override
  String csvImportDone(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions imported',
      one: '1 transaction imported',
    );
    return '$_temp0';
  }

  @override
  String get csvImportFailedNoColumns =>
      'No recognised columns. Start from the CSV template.';

  @override
  String csvImportFailedMissingColumn(String column) {
    return 'The file has no \"$column\" column.';
  }

  @override
  String get csvImportFailedEmpty => 'This file has no data rows.';

  @override
  String csvImportFailedTooManyRows(int rows, int max) {
    return 'This file has $rows rows; the limit is $max.';
  }

  @override
  String get csvImportFailed => 'CSV import failed';

  @override
  String get ledgerVerifyDialogTitle => 'Ledger verification';

  @override
  String get ledgerVerifyAllMatch => 'All accounts match.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Mismatches';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nStored: $stored\nReplay: $replayed\nDifference: $diff';
  }

  @override
  String get settingsLanguage => 'App language';

  @override
  String get settingsLanguageSubtitleSystem => 'Following system settings';

  @override
  String get settingsLanguageSubtitleEnglish => 'English';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Serbian (Latin)';

  @override
  String get settingsLanguagePickerTitle => 'App language';

  @override
  String get settingsLanguageOptionSystem => 'System default';

  @override
  String get settingsLanguageOptionEnglish => 'English';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Serbian (Latin)';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsSectionSecurity => 'Security';

  @override
  String get settingsSecurityEnableLock => 'Lock app on open';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Require biometric unlock or PIN when app opens';

  @override
  String get settingsSecurityLockDelayTitle => 'Re-lock after background';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      'How long the app can stay off-screen before requiring unlock again. Immediately is the strongest.';

  @override
  String get settingsSecurityLockDelayImmediate => 'Immediately';

  @override
  String get settingsSecurityLockDelay30s => '30 seconds';

  @override
  String get settingsSecurityLockDelay1m => '1 minute';

  @override
  String get settingsSecurityLockDelay5m => '5 minutes';

  @override
  String get settingsSecuritySetPin => 'Set PIN';

  @override
  String get settingsSecurityChangePin => 'Change PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Use a PIN as fallback if biometric is unavailable';

  @override
  String get settingsSecurityRemovePin => 'Remove PIN';

  @override
  String get securitySetPinTitle => 'Set app PIN';

  @override
  String get securityPinLabel => 'PIN code';

  @override
  String get securityConfirmPinLabel => 'Confirm PIN code';

  @override
  String get securityPinMustBe4Digits => 'PIN must have at least 4 digits';

  @override
  String get securityPinMismatch => 'PIN codes do not match';

  @override
  String get securityRemovePinTitle => 'Remove PIN?';

  @override
  String get securityRemovePinBody =>
      'Biometric unlock can still be used if available.';

  @override
  String get securityUnlockTitle => 'App locked';

  @override
  String get securityUnlockSubtitle =>
      'Unlock with Face ID, fingerprint, or PIN.';

  @override
  String get securityUnlockWithPin => 'Unlock with PIN';

  @override
  String get securityTryBiometric => 'Try biometric unlock';

  @override
  String get securityPinIncorrect => 'Incorrect PIN, try again';

  @override
  String securityTooManyAttempts(int seconds) {
    return 'Too many attempts. Try again in $seconds s';
  }

  @override
  String get securityBiometricReason => 'Authenticate to open your app';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSubtitleSystem => 'Following system settings';

  @override
  String get settingsThemeSubtitleLight => 'Light';

  @override
  String get settingsThemeSubtitleDark => 'Dark';

  @override
  String get settingsThemePickerTitle => 'Theme';

  @override
  String get settingsThemeOptionSystem => 'System default';

  @override
  String get settingsThemeOptionLight => 'Light';

  @override
  String get settingsThemeOptionDark => 'Dark';

  @override
  String get archivedAccountsTitle => 'Archived accounts';

  @override
  String get archivedAccountsEmptyTitle => 'No archived accounts';

  @override
  String get archivedAccountsEmptyBody =>
      'Book balance and overdraft must be zero. Archive from account options in Review.';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get newCategoryTitle => 'New Category';

  @override
  String get categoryNameLabel => 'Category name';

  @override
  String get deleteCategoryTitle => 'Delete category?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" will be removed from the list.';
  }

  @override
  String get categoryIncome => 'Income';

  @override
  String get categoryExpense => 'Expense';

  @override
  String get categoryAdd => 'Add';

  @override
  String get editCategoryTitle => 'Edit Category';

  @override
  String get categorySave => 'Save';

  @override
  String get categoryRenameAction => 'Rename';

  @override
  String get categoryDuplicateName =>
      'A category with this name already exists.';

  @override
  String get categoryInUseTitle => 'Category in use';

  @override
  String categoryInUseBody(String category, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '\"$category\" is used by $_temp0. It can\'t be deleted, but it can be renamed — all linked transactions update automatically.';
  }

  @override
  String get searchCurrencies => 'Search currencies…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1Y';

  @override
  String get periodAll => 'ALL';

  @override
  String get categoryLabel => 'category';

  @override
  String get categoriesLabel => 'categories';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type saved  •  $amount';
  }

  @override
  String get tooltipSettings => 'Settings';

  @override
  String get tooltipAddAccount => 'Add account';

  @override
  String get tooltipRemoveAccount => 'Remove account';

  @override
  String get accountNameTaken =>
      'You already have an account with this name and identifier (active or archived). Change the name or identifier.';

  @override
  String get groupDescPersonal => 'Your own wallets & bank accounts';

  @override
  String get groupDescIndividuals => 'Family, friends, individuals';

  @override
  String get groupDescEntities => 'Entities, utilities, organisations';

  @override
  String get cannotArchiveTitle => 'Cannot archive yet';

  @override
  String get cannotArchiveBody =>
      'Archive is only available when the book balance and overdraft limit are both effectively zero.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Archive is only available when the book balance and overdraft limit are both effectively zero. Adjust the ledger or facility first.';

  @override
  String get archiveAccountTitle => 'Archive account?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planned transactions reference this account.',
      one: '1 planned transaction references this account.',
    );
    return '$_temp0 Remove them to keep your plan consistent with an archived account.';
  }

  @override
  String get removeAndArchive => 'Remove planned & archive';

  @override
  String get archiveBody =>
      'The account will be hidden from Review, Track, and Plan pickers. You can restore it from Settings.';

  @override
  String get archiveAction => 'Archive';

  @override
  String get archiveInstead => 'Archive instead';

  @override
  String get cannotDeleteTitle => 'Cannot delete account';

  @override
  String get cannotDeleteBodyShort =>
      'This account appears in your Track history. Remove or reassign those transactions first, or archive the account if the balance is cleared.';

  @override
  String get cannotDeleteBodyHistory =>
      'This account appears in your Track history. Deleting would break that history—remove or reassign those transactions first.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'This account appears in your Track history, so it cannot be deleted. You can archive it instead if the book balance and overdraft are cleared—it will be hidden from lists but history stays intact.';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountBodyPermanent =>
      'This account will be removed permanently.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count planned transactions reference this account and will also be deleted.',
      one:
          '1 planned transaction references this account and will also be deleted.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Delete all';

  @override
  String get editAccountTitle => 'Edit Account';

  @override
  String get newAccountTitle => 'New Account';

  @override
  String get labelAccountName => 'Account name';

  @override
  String get labelAccountIdentifier => 'Identifier (optional)';

  @override
  String get accountAppearanceSection => 'Icon & color';

  @override
  String get accountPickIcon => 'Choose icon';

  @override
  String get accountPickColor => 'Choose color';

  @override
  String get accountIconSheetTitle => 'Account icon';

  @override
  String get accountColorSheetTitle => 'Account color';

  @override
  String get searchAccountIcons => 'Search icons by name…';

  @override
  String get accountIconSearchNoMatches => 'No icons match that search.';

  @override
  String get accountUseInitialLetter => 'Initial letter';

  @override
  String get accountUseDefaultColor => 'Match group';

  @override
  String get labelRealBalance => 'Real balance';

  @override
  String get labelOverdraftLimit => 'Overdraft / advance limit';

  @override
  String get labelCurrency => 'Currency';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get addAccountAction => 'Add Account';

  @override
  String get removeAccountSheetTitle => 'Remove account';

  @override
  String get deletePermanently => 'Delete permanently';

  @override
  String get deletePermanentlySubtitle =>
      'Only possible when this account is not used in Track. Planned items can be removed as part of delete.';

  @override
  String get archiveOptionSubtitle =>
      'Hide from Review and pickers. Restore anytime from Settings. Requires zero balance and overdraft.';

  @override
  String get archivedBannerText =>
      'This account is archived. It stays in your data but is hidden from lists and pickers.';

  @override
  String get balanceAdjustedTitle => 'Balance adjusted in Track';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Real balance was updated from $previous to $current $symbol.\n\nA balance adjustment transaction was created in Track (History) to keep the ledger consistent.\n\n• Real balance reflects the actual amount in this account.\n• Check History for the adjustment entry.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Balance adjustment';

  @override
  String get descriptionBalanceCorrection => 'Balance correction';

  @override
  String get descriptionOpeningBalance => 'Opening balance';

  @override
  String get reviewStatsModeStatistics => 'Statistics';

  @override
  String get reviewStatsModeComparison => 'Comparison';

  @override
  String get statsUncategorized => 'Uncategorized';

  @override
  String get statsNoCategories =>
      'No categories in the selected periods for comparison.';

  @override
  String get statsNoTransactions => 'No transactions';

  @override
  String get statsSpendingInCategory => 'Spending in this category';

  @override
  String get statsIncomeInCategory => 'Income in this category';

  @override
  String get statsDifference => 'Difference (B vs A): ';

  @override
  String get statsNoExpensesMonth => 'No expenses this month';

  @override
  String get statsNoExpensesAll => 'No expenses recorded';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'No expenses in the last $period';
  }

  @override
  String get statsTotalSpent => 'Total spent';

  @override
  String get statsNoExpensesThisPeriod => 'No expenses in this period';

  @override
  String get statsNoIncomeMonth => 'No income this month';

  @override
  String get statsNoIncomeAll => 'No income recorded';

  @override
  String statsNoIncomePeriod(String period) {
    return 'No income in the last $period';
  }

  @override
  String get statsTotalReceived => 'Total received';

  @override
  String get statsNoIncomeThisPeriod => 'No income in this period';

  @override
  String get catSalary => 'Salary';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catConsulting => 'Consulting';

  @override
  String get catGift => 'Gift';

  @override
  String get catRental => 'Rental';

  @override
  String get catDividends => 'Dividends';

  @override
  String get catRefund => 'Refund';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catInterest => 'Interest';

  @override
  String get catSideHustle => 'Side hustle';

  @override
  String get catSaleOfGoods => 'Sale of goods';

  @override
  String get catOther => 'Other';

  @override
  String get catGroceries => 'Groceries';

  @override
  String get catDining => 'Dining';

  @override
  String get catTransport => 'Transport';

  @override
  String get catUtilities => 'Utilities';

  @override
  String get catHousing => 'Housing';

  @override
  String get catHealthcare => 'Healthcare';

  @override
  String get catEntertainment => 'Entertainment';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catTravel => 'Travel';

  @override
  String get catEducation => 'Education';

  @override
  String get catSubscriptions => 'Subscriptions';

  @override
  String get catInsurance => 'Insurance';

  @override
  String get catFuel => 'Fuel';

  @override
  String get catGym => 'Gym';

  @override
  String get catPets => 'Pets';

  @override
  String get catKids => 'Kids';

  @override
  String get catCharity => 'Charity';

  @override
  String get catCoffee => 'Coffee';

  @override
  String get catGifts => 'Gifts';

  @override
  String semanticsProjectionDate(String date) {
    return 'Projection date $date. Double tap to choose date';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Projected personal balance $amount';
  }

  @override
  String get statsEmptyTitle => 'No transactions yet';

  @override
  String get statsEmptySubtitle => 'No spending data for the selected range.';

  @override
  String get semanticsShowProjections => 'Show projected balances by account';

  @override
  String get semanticsHideProjections => 'Hide projected balances by account';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Show account balances for this day';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Hide account balances for this day';

  @override
  String get semanticsDateAllTime => 'Date: all time — tap to change mode';

  @override
  String semanticsDateMode(String mode) {
    return 'Date: $mode — tap to change mode';
  }

  @override
  String get semanticsDateThisMonth =>
      'Date: this month — tap for month, week, year, or all time';

  @override
  String get semanticsTxTypeCycle =>
      'Transaction type: cycle all, income, expense, transfer';

  @override
  String get semanticsAccountFilter => 'Account filter';

  @override
  String get semanticsAlreadyFiltered => 'Already filtered to this account';

  @override
  String get semanticsCategoryFilter => 'Category filter';

  @override
  String get semanticsSortToggle => 'Sort: toggle newest or oldest first';

  @override
  String get semanticsFiltersDisabled =>
      'List filters disabled while viewing a future projection date. Clear projections to use filters.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'List filters disabled. Add an account first.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'List filters disabled. Add a planned transaction first.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'List filters disabled. Record a transaction first.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Section and currency controls disabled. Add an account first.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Projection date and balance breakdown disabled. Add an account and a planned transaction first.';

  @override
  String get semanticsReorderAccountHint =>
      'Long press, then drag to reorder within this group';

  @override
  String get semanticsChartStyle => 'Chart style';

  @override
  String get semanticsChartStyleUnavailable =>
      'Chart style (unavailable in comparison mode)';

  @override
  String semanticsPeriod(String label) {
    return 'Period: $label';
  }

  @override
  String get trackSearchHint => 'Search description, category, account…';

  @override
  String get trackSearchClear => 'Clear search';

  @override
  String get settingsExchangeRatesTitle => 'Exchange rates';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Last updated: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Using offline or bundled rates — tap to refresh';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Exchange rates updated';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Could not update exchange rates. Check your connection.';

  @override
  String get settingsClearData => 'Clear data';

  @override
  String get settingsClearDataSubtitle => 'Permanently remove selected data';

  @override
  String get clearDataTitle => 'Clear data';

  @override
  String get clearDataTransactions => 'Transaction history';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transactions · account balances reset to zero';
  }

  @override
  String get clearDataPlanned => 'Planned transactions';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count planned items';
  }

  @override
  String get clearDataAccounts => 'Accounts';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count accounts · also clears history and plan';
  }

  @override
  String get clearDataCategories => 'Categories';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count categories · replaced with defaults';
  }

  @override
  String get clearDataPreferences => 'Preferences';

  @override
  String get clearDataPreferencesSubtitle =>
      'Reset currency, theme and language to defaults';

  @override
  String get clearDataSecurity => 'App lock & PIN';

  @override
  String get clearDataSecuritySubtitle => 'Disable app lock and remove PIN';

  @override
  String get clearDataConfirmButton => 'Clear selected';

  @override
  String get clearDataConfirmTitle => 'This cannot be undone';

  @override
  String get clearDataConfirmBody =>
      'The selected data will be permanently deleted. Export a backup first if you may need it later.';

  @override
  String get clearDataTypeConfirm => 'Type DELETE to confirm';

  @override
  String get clearDataTypeConfirmError => 'Type DELETE exactly to continue';

  @override
  String get clearDataPinTitle => 'Confirm with PIN';

  @override
  String get clearDataPinBody => 'Enter your app PIN to authorize this action.';

  @override
  String get clearDataPinIncorrect => 'Incorrect PIN';

  @override
  String get clearDataDone => 'Selected data cleared';

  @override
  String get autoBackupTitle => 'Automatic daily backup';

  @override
  String autoBackupLastAt(String date) {
    return 'Last backed up $date';
  }

  @override
  String get autoBackupNeverRun => 'No backup yet';

  @override
  String get autoBackupShareTitle => 'Save to cloud';

  @override
  String get autoBackupShareSubtitle =>
      'Upload latest backup to iCloud Drive, Google Drive or any app';

  @override
  String get autoBackupCloudReminder =>
      'Auto-backup ready — save it to cloud for off-device protection';

  @override
  String get autoBackupCloudReminderAction => 'Share';

  @override
  String get settingsBackupReminderTitle => 'Backup reminder';

  @override
  String get settingsBackupReminderSubtitle =>
      'In-app banner if you add many transactions without exporting a manual backup.';

  @override
  String get settingsBackupReminderThresholdTitle => 'Transaction threshold';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return 'Remind after $count new transactions since your last manual export.';
  }

  @override
  String get settingsBackupReminderThresholdInvalid =>
      'Enter a whole number from 1 to 500.';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '\"Remind later\" hides the banner until you add $n more transactions.';
  }

  @override
  String get backupReminderBannerTitle => 'Export a backup?';

  @override
  String backupReminderBannerBody(int count) {
    return 'You have added $count transactions since your last manual export.';
  }

  @override
  String get backupReminderRemindLater => 'Remind later';

  @override
  String get backupExportLedgerVerifyTitle => 'Ledger check before backup';

  @override
  String get backupExportLedgerVerifyInfo =>
      'This compares each account’s stored balance to a full replay of your history. You can export a backup either way; mismatches are informational.';

  @override
  String get backupExportLedgerVerifyContinue => 'Continue to backup';

  @override
  String get persistenceErrorReloaded =>
      'Couldn’t save changes. Data was reloaded from storage.';

  @override
  String get helpTooltip => 'Help';

  @override
  String get helpNext => 'Next';

  @override
  String get helpBack => 'Back';

  @override
  String get helpDone => 'Done';

  @override
  String get helpSkip => 'Skip';

  @override
  String get helpTrackHeroTitle => 'Totals and filters';

  @override
  String get helpTrackHeroBody =>
      'This card sums money in and out for the list below. The chips filter by account, category, and type; the date chip cycles day, week, month, and year; the arrow flips the sort order.';

  @override
  String get helpTrackListTitle => 'Your history';

  @override
  String get helpTrackListBody =>
      'Recorded transactions, grouped by day. Tap one to view or edit it, and use search to find a specific entry.';

  @override
  String get helpTrackFabTitle => 'Add a transaction';

  @override
  String get helpTrackFabBody =>
      'Record money coming in, going out, or moving between your accounts.';

  @override
  String get helpSettingsTitle => 'Settings';

  @override
  String get helpSettingsBody =>
      'Currencies, language, theme, security, backups, and account management live here.';

  @override
  String get helpPlanHeroTitle => 'Projection';

  @override
  String get helpPlanHeroBody =>
      'Your personal and net balances on the chosen date. The chips below filter the planned transactions.';

  @override
  String get helpPlanListTitle => 'Planned transactions';

  @override
  String get helpPlanListBody =>
      'Upcoming income, expenses, and transfers you expect. Tap one to edit it; the chips at the top filter this list.';

  @override
  String get helpPlanFabTitle => 'Add a plan';

  @override
  String get helpPlanFabBody =>
      'Schedule an expected transaction, including repeating ones.';

  @override
  String get helpPlanProjectionFabTitle => 'Project the future';

  @override
  String get helpPlanProjectionFabBody =>
      'Tap the globe to pick a future date and see projected balances — planned transactions up to that date are applied. You can also tap the date on the card above.';

  @override
  String get helpReviewHeroTitle => 'Net worth';

  @override
  String get helpReviewHeroBody =>
      'Your personal balance and net worth at a glance. Tap the amounts to switch between your base and secondary currency.';

  @override
  String get helpReviewSectionsTitle => 'Sections';

  @override
  String get helpReviewSectionsBody =>
      'Swipe left and right — or tap the chips — to move between personal accounts, individuals, entities, and statistics.';

  @override
  String get helpReviewAccountsTitle => 'Accounts';

  @override
  String get helpReviewAccountsBody =>
      'Each card shows an account and its balance. Tap one to open its full transaction history.';

  @override
  String get helpReviewFabTitle => 'Add an account';

  @override
  String get helpReviewFabBody =>
      'Create accounts for your cash, cards, and savings, or for people and businesses you track.';

  @override
  String get helpSettingsSecurityTitle => 'Security';

  @override
  String get helpSettingsSecurityBody =>
      'Lock the app behind your device’s screen lock and choose how quickly it locks again.';

  @override
  String get helpSettingsPreferencesTitle => 'Preferences';

  @override
  String get helpSettingsPreferencesBody =>
      'Language, theme, currencies, and other everyday options.';

  @override
  String get helpSettingsDataTitle => 'Your data';

  @override
  String get helpSettingsDataBody =>
      'Export encrypted backups, import them on another device, and tune automatic backups. Your data stays on this device unless you export it.';

  @override
  String get helpSettingsManageTitle => 'Manage';

  @override
  String get helpSettingsManageBody =>
      'Edit accounts and rename categories — changes apply everywhere in the app.';

  @override
  String get helpTxAccountsTitle => 'From and To';

  @override
  String get helpTxAccountsBody =>
      'Pick where the money comes from and where it goes. Only From: money out. Only To: money in. Both: a transfer between accounts.';

  @override
  String get helpTxDetailsTitle => 'Amount and details';

  @override
  String get helpTxDetailsBody =>
      'Enter the amount, then add a category, note, or attachment so the entry is easy to find later.';

  @override
  String get helpTxDateTitle => 'Date';

  @override
  String get helpTxDateBody =>
      'Tap here to change the day this transaction happened.';

  @override
  String get helpPlannedDateTitle => 'Due date';

  @override
  String get helpPlannedDateBody =>
      'Tap here to pick when this should happen. A plan can also repeat on a schedule you choose.';

  @override
  String get helpPlannedProjectionTitle => 'Projected balances';

  @override
  String get helpPlannedProjectionBody =>
      'The account pickers show each account’s projected balance on the due date, so you can spot a plan that would overdraw an account.';

  @override
  String get settingsPlannedRemindersTitle => 'Planned reminders';

  @override
  String get settingsPlannedRemindersSubtitle =>
      'Notifies you when a planned transaction is due. Works fully offline — nothing leaves your device.';

  @override
  String get settingsPlannedRemindersTimeTitle => 'Reminder time';

  @override
  String get settingsPlannedRemindersLeadTitle => 'Advance notice';

  @override
  String get settingsPlannedRemindersLeadOnDay => 'On the due date';

  @override
  String settingsPlannedRemindersLeadDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days before',
      one: '1 day before',
    );
    return '$_temp0';
  }

  @override
  String get settingsPlannedRemindersPermissionDenied =>
      'Notifications are turned off for Platrare. Allow them in system settings to receive reminders.';

  @override
  String get plannedReminderChannelName => 'Planned transaction reminders';

  @override
  String get plannedReminderChannelDescription =>
      'Notifications for upcoming planned transactions.';

  @override
  String get plannedReminderFallbackTitle => 'Planned transaction';

  @override
  String get plannedReminderDueToday => 'Due today';

  @override
  String get plannedReminderDueTomorrow => 'Due tomorrow';

  @override
  String plannedReminderDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Due in $count days',
    );
    return '$_temp0';
  }

  @override
  String get aboutContactSupport => 'Contact support';

  @override
  String get aboutSupportEmailCopied => 'Support email address copied';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Platrare';

  @override
  String get onboardingWelcomeBody =>
      'Your money stays on this device. No account, no ads, no tracking.';

  @override
  String get onboardingPlanBody =>
      'Schedule upcoming and repeating payments and see where your balances are heading.';

  @override
  String get onboardingTrackBody =>
      'Record income, expenses, transfers, and what you lend or owe.';

  @override
  String get onboardingReviewBody =>
      'Statistics, comparisons and history for your accounts, the people you settle with, and businesses.';

  @override
  String get onboardingCurrencyLabel => 'Base currency';

  @override
  String get onboardingCurrencyHint =>
      'Suggested from your device language. You can change it later in Settings.';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingTour => 'Show me around';

  @override
  String get clearDataConfirmWord => 'DELETE';

  @override
  String get planDeleteTitle => 'Delete planned transaction?';

  @override
  String get planDeleteBody =>
      'It will be removed from your plan. Your account balances are not affected.';
}
