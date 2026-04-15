// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

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
  String get heroBalance => 'Balance';

  @override
  String get realBalance => 'Real balance';

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
  String get heroResetButton => 'Reset';

  @override
  String get fabScrollToTop => 'Back to top';

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
  String get persistenceErrorReloaded =>
      'Couldn’t save changes. Data was reloaded from storage.';
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
  String get clearDataTypeConfirm => '键入 DELETE 进行确认';

  @override
  String get clearDataTypeConfirmError => '准确键入 DELETE 以继续';

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
  String get persistenceErrorReloaded => '无法保存更改。数据已从存储中重新加载。';
}
