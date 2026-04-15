// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
  String get settingsHideHeroBalancesTitle =>
      'Ocultar saldos nos cartões de resumo';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Quando ativado, os valores no Plano, Rastreamento e Revisão ficam mascarados até tocar no ícone de olho em cada separador. Quando desativado, os saldos estão sempre visíveis.';

  @override
  String get heroBalancesShow => 'Mostrar saldos';

  @override
  String get heroBalancesHide => 'Ocultar saldos';

  @override
  String get semanticsHeroBalanceHidden => 'Saldo oculto por privacidade';

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
  String get settingsSecurityLockDelayTitle => 'Rebloqueio após segundo plano';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      'Por quanto tempo o app pode ficar fora do ecrã antes de exigir desbloqueio novamente. Imediatamente é a opção mais segura.';

  @override
  String get settingsSecurityLockDelayImmediate => 'Imediatamente';

  @override
  String get settingsSecurityLockDelay30s => '30 segundos';

  @override
  String get settingsSecurityLockDelay1m => '1 minuto';

  @override
  String get settingsSecurityLockDelay5m => '5 minutos';

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
  String get searchAccountIcons => 'Pesquisar ícones por nome…';

  @override
  String get accountIconSearchNoMatches =>
      'Nenhum ícone corresponde a essa pesquisa.';

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
  String get settingsBackupReminderTitle => 'Lembrete de cópia de segurança';

  @override
  String get settingsBackupReminderSubtitle =>
      'Banner no app se adicionar muitas transações sem exportar uma cópia de segurança manual.';

  @override
  String get settingsBackupReminderThresholdTitle => 'Limite de transações';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return 'Lembrar após $count novas transações desde a última exportação manual.';
  }

  @override
  String get settingsBackupReminderThresholdInvalid =>
      'Introduza um número inteiro de 1 a 500.';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '\"Lembrar depois\" oculta o banner até adicionar mais $n transações.';
  }

  @override
  String get backupReminderBannerTitle => 'Exportar cópia de segurança?';

  @override
  String backupReminderBannerBody(int count) {
    return 'Adicionou $count transações desde a última exportação manual.';
  }

  @override
  String get backupReminderRemindLater => 'Lembrar depois';

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
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Platar';

  @override
  String get navPlan => 'Plano';

  @override
  String get navTrack => 'Acompanhar';

  @override
  String get navReview => 'Análise';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get close => 'Fechar';

  @override
  String get add => 'Adicionar';

  @override
  String get undo => 'Desfazer';

  @override
  String get confirm => 'Confirmar';

  @override
  String get restore => 'Restaurar';

  @override
  String get heroIn => 'Em';

  @override
  String get heroOut => 'Fora';

  @override
  String get heroNet => 'Líquido';

  @override
  String get heroBalance => 'Equilíbrio';

  @override
  String get realBalance => 'Equilíbrio real';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Ocultar saldos nos cartões de resumo';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Quando ativado, os valores no Plano, Rastreamento e Revisão ficam mascarados até você tocar no ícone de olho em cada aba. Quando desativado, os saldos ficam sempre visíveis.';

  @override
  String get heroBalancesShow => 'Mostrar saldos';

  @override
  String get heroBalancesHide => 'Ocultar saldos';

  @override
  String get semanticsHeroBalanceHidden => 'Saldo oculto por privacidade';

  @override
  String get heroResetButton => 'Reiniciar';

  @override
  String get fabScrollToTop => 'Back to top';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterAllAccounts => 'Todas as contas';

  @override
  String get filterAllCategories => 'Todas as categorias';

  @override
  String get txLabelIncome => 'RENDA';

  @override
  String get txLabelExpense => 'DESPESA';

  @override
  String get txLabelInvoice => 'FATURA';

  @override
  String get txLabelBill => 'CONTA';

  @override
  String get txLabelAdvance => 'AVANÇAR';

  @override
  String get txLabelSettlement => 'POVOADO';

  @override
  String get txLabelLoan => 'EMPRÉSTIMO';

  @override
  String get txLabelCollection => 'COLEÇÃO';

  @override
  String get txLabelOffset => 'DESVIO';

  @override
  String get txLabelTransfer => 'TRANSFERIR';

  @override
  String get txLabelTransaction => 'TRANSAÇÃO';

  @override
  String get repeatNone => 'Sem repetição';

  @override
  String get repeatDaily => 'Diário';

  @override
  String get repeatWeekly => 'Semanalmente';

  @override
  String get repeatMonthly => 'Mensal';

  @override
  String get repeatYearly => 'Anual';

  @override
  String get repeatEveryLabel => 'Todo';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: 'dia',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: 'semana',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: 'mês',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anos',
      one: 'ano',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Termina';

  @override
  String get repeatEndNever => 'Nunca';

  @override
  String get repeatEndOnDate => 'Na data';

  @override
  String repeatEndAfterCount(int count) {
    return 'Depois de $count vezes';
  }

  @override
  String get repeatEndAfterChoice => 'Depois de um número de vezes';

  @override
  String get repeatEndPickDate => 'Escolha a data de término';

  @override
  String get repeatEndTimes => 'vezes';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Cada $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'até $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count vezes';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining de $total restante';
  }

  @override
  String get detailRepeatEvery => 'Repita cada';

  @override
  String get detailEnds => 'Termina';

  @override
  String get detailEndsNever => 'Nunca';

  @override
  String detailEndsOnDate(String date) {
    return 'Em $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Depois de $count vezes';
  }

  @override
  String get detailProgress => 'Progresso';

  @override
  String get weekendNoChange => 'Sem alteração';

  @override
  String get weekendFriday => 'Mudar para sexta-feira';

  @override
  String get weekendMonday => 'Mudar para segunda-feira';

  @override
  String weekendQuestion(String day) {
    return 'Se o $day cair em um fim de semana?';
  }

  @override
  String get dateToday => 'Hoje';

  @override
  String get dateTomorrow => 'Amanhã';

  @override
  String get dateYesterday => 'Ontem';

  @override
  String get statsAllTime => 'Todo o tempo';

  @override
  String get accountGroupPersonal => 'Pessoal';

  @override
  String get accountGroupIndividual => 'Individual';

  @override
  String get accountGroupEntity => 'Entidade';

  @override
  String get accountSectionIndividuals => 'Indivíduos';

  @override
  String get accountSectionEntities => 'Entidades';

  @override
  String get emptyNoTransactionsYet => 'Nenhuma transação ainda';

  @override
  String get emptyNoAccountsYet => 'Nenhuma conta ainda';

  @override
  String get emptyRecordFirstTransaction =>
      'Toque no botão abaixo para registrar sua primeira transação.';

  @override
  String get emptyAddFirstAccountTx =>
      'Adicione sua primeira conta antes de registrar as transações.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Adicione sua primeira conta antes de planejar transações.';

  @override
  String get emptyAddFirstAccountReview =>
      'Adicione sua primeira conta para começar a monitorar suas finanças.';

  @override
  String get emptyAddTransaction => 'Adicionar transação';

  @override
  String get emptyAddAccount => 'Adicionar conta';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Ainda não há contas pessoais';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'As contas pessoais são suas próprias carteiras e contas bancárias. Adicione um para monitorar receitas e gastos diários.';

  @override
  String get reviewEmptyGroupIndividualsTitle =>
      'Ainda não há contas individuais';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Contas individuais rastreiam dinheiro com pessoas específicas – custos compartilhados, empréstimos ou notas promissórias. Adicione uma conta para cada pessoa com quem você fizer acordos.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Nenhuma conta de entidade ainda';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'As contas de entidade são para empresas, projetos ou organizações. Use-os para manter o fluxo de caixa comercial separado de suas finanças pessoais.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Nenhuma transação para filtros aplicados';

  @override
  String get emptyNoTransactionsInHistory => 'Nenhuma transação no histórico';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Nenhuma transação para $month';
  }

  @override
  String get emptyNoTransactionsForAccount =>
      'Nenhuma transação para esta conta';

  @override
  String get trackTransactionDeleted => 'Transação excluída';

  @override
  String get trackDeleteTitle => 'Excluir transação?';

  @override
  String get trackDeleteBody =>
      'Isso reverterá as alterações no saldo da conta.';

  @override
  String get trackTransaction => 'Transação';

  @override
  String get planConfirmTitle => 'Confirmar transação?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Esta ocorrência está agendada para $date. Ficará registrado no Histórico com a data de hoje ($todayDate). A próxima ocorrência permanece em $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Isso aplicará a transação aos saldos reais de suas contas e a moverá para o Histórico.';

  @override
  String get planTransactionConfirmed => 'Transação confirmada e aplicada';

  @override
  String get planTransactionRemoved => 'Transação planejada removida';

  @override
  String get planRepeatingTitle => 'Repetindo transação';

  @override
  String get planRepeatingBody =>
      'Pule apenas esta data – a série continua com a próxima ocorrência – ou exclua todas as ocorrências restantes do seu plano.';

  @override
  String get planDeleteAll => 'Excluir tudo';

  @override
  String get planSkipThisOnly => 'Pule apenas isso';

  @override
  String get planOccurrenceSkipped =>
      'Esta ocorrência foi ignorada – próxima agendada';

  @override
  String get planNothingPlanned => 'Nada planejado por enquanto';

  @override
  String get planPlanBody => 'Planeje as próximas transações.';

  @override
  String get planAddPlan => 'Adicionar plano';

  @override
  String get planNoPlannedForFilters =>
      'Nenhuma transação planejada para filtros aplicados';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Nenhuma transação planejada em $month';
  }

  @override
  String get planOverdue => 'atrasado';

  @override
  String get planPlannedTransaction => 'Transação planejada';

  @override
  String get discardTitle => 'Descartar alterações?';

  @override
  String get discardBody =>
      'Você tem alterações não salvas. Eles estarão perdidos se você sair agora.';

  @override
  String get keepEditing => 'Continue editando';

  @override
  String get discard => 'Descartar';

  @override
  String get newTransactionTitle => 'Nova transação';

  @override
  String get editTransactionTitle => 'Editar transação';

  @override
  String get transactionUpdated => 'Transação atualizada';

  @override
  String get sectionAccounts => 'Contas';

  @override
  String get labelFrom => 'De';

  @override
  String get labelTo => 'Para';

  @override
  String get sectionCategory => 'Categoria';

  @override
  String get sectionAttachments => 'Anexos';

  @override
  String get labelNote => 'Observação';

  @override
  String get hintOptionalDescription => 'Descrição opcional';

  @override
  String get updateTransaction => 'Atualizar transação';

  @override
  String get saveTransaction => 'Salvar transação';

  @override
  String get selectAccount => 'Selecione a conta';

  @override
  String get selectAccountTitle => 'Selecione a conta';

  @override
  String get noAccountsAvailable => 'Nenhuma conta disponível';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Valor recebido por $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Insira o valor exato que a conta de destino recebe. Isto bloqueia a taxa de câmbio real utilizada.';

  @override
  String get attachTakePhoto => 'Tirar foto';

  @override
  String get attachTakePhotoSub => 'Use a câmera para capturar um recibo';

  @override
  String get attachChooseGallery => 'Escolha na galeria';

  @override
  String get attachChooseGallerySub => 'Selecione fotos da sua biblioteca';

  @override
  String get attachBrowseFiles => 'Navegar pelos arquivos';

  @override
  String get attachBrowseFilesSub =>
      'Anexe PDFs, documentos ou outros arquivos';

  @override
  String get attachButton => 'Anexar';

  @override
  String get editPlanTitle => 'Editar plano';

  @override
  String get planTransactionTitle => 'Planejar transação';

  @override
  String get tapToSelect => 'Toque para selecionar';

  @override
  String get updatePlan => 'Plano de atualização';

  @override
  String get addToPlan => 'Adicionar ao plano';

  @override
  String get labelRepeat => 'Repita';

  @override
  String get selectPlannedDate => 'Selecione a data planejada';

  @override
  String get balancesAsOfToday => 'Saldos a partir de hoje';

  @override
  String get projectedBalancesForTomorrow => 'Saldos projetados para amanhã';

  @override
  String projectedBalancesForDate(String date) {
    return 'Saldos projetados para $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name recebe ($currency)';
  }

  @override
  String get destHelper =>
      'Quantidade estimada de destino. A taxa exata é bloqueada na confirmação.';

  @override
  String get descriptionOptional => 'Descrição (opcional)';

  @override
  String get detailTransactionTitle => 'Transação';

  @override
  String get detailPlannedTitle => 'Planejado';

  @override
  String get detailConfirmTransaction => 'Confirmar transação';

  @override
  String get detailDate => 'Data';

  @override
  String get detailFrom => 'De';

  @override
  String get detailTo => 'Para';

  @override
  String get detailCategory => 'Categoria';

  @override
  String get detailNote => 'Observação';

  @override
  String get detailDestinationAmount => 'Valor de destino';

  @override
  String get detailExchangeRate => 'Taxa de câmbio';

  @override
  String get detailRepeats => 'Repete';

  @override
  String get detailDayOfMonth => 'Dia do mês';

  @override
  String get detailWeekends => 'Fins de semana';

  @override
  String get detailAttachments => 'Anexos';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ficheiros',
      one: '1 ficheiro',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionDisplay => 'Mostrar';

  @override
  String get settingsSectionLanguage => 'Linguagem';

  @override
  String get settingsSectionCategories => 'Categorias';

  @override
  String get settingsSectionAccounts => 'Contas';

  @override
  String get settingsSectionPreferences => 'Preferências';

  @override
  String get settingsSectionManage => 'Gerenciar';

  @override
  String get settingsBaseCurrency => 'Moeda local';

  @override
  String get settingsSecondaryCurrency => 'Moeda secundária';

  @override
  String get settingsCategories => 'Categorias';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount receita · $expenseCount despesa';
  }

  @override
  String get settingsArchivedAccounts => 'Contas arquivadas';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Nenhum no momento – arquivar da edição da conta quando o saldo estiver limpo';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count oculto da revisão e dos selecionadores';
  }

  @override
  String get settingsSectionData => 'Dados';

  @override
  String get settingsSectionPrivacy => 'Sobre';

  @override
  String get settingsPrivacyPolicyTitle => 'Política de Privacidade';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Como a Platrare trata seus dados.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Taxas de câmbio: o aplicativo busca taxas de câmbio públicas pela internet. Suas contas e transações nunca são enviadas.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Não foi possível carregar a política de privacidade.';

  @override
  String get settingsPrivacyRetry => 'Tente novamente';

  @override
  String get settingsSoftwareVersionTitle => 'Versão do software';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Liberação, diagnóstico e legal';

  @override
  String get aboutScreenTitle => 'Sobre';

  @override
  String get aboutAppTagline =>
      'Razão, fluxo de caixa e planejamento em um único espaço de trabalho.';

  @override
  String get aboutDescriptionBody =>
      'Platrare mantém contas, transações e planos no seu dispositivo. Exporte backups criptografados quando precisar de uma cópia em outro lugar. As taxas de câmbio utilizam apenas dados públicos do mercado; seu razão não foi carregado.';

  @override
  String get aboutVersionLabel => 'Versão';

  @override
  String get aboutBuildLabel => 'Construir';

  @override
  String get aboutCopySupportDetails => 'Copiar detalhes de suporte';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Abre o documento completo da política no aplicativo.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Localidade';

  @override
  String get settingsSupportInfoCopied =>
      'Copiado para a área de transferência';

  @override
  String get settingsVerifyLedger => 'Verifique os dados';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Verifique se os saldos das contas correspondem ao seu histórico de transações';

  @override
  String get settingsDataExportTitle => 'Exportar backup';

  @override
  String get settingsDataExportSubtitle =>
      'Salve como .zip ou .platrare criptografado com todos os dados e anexos';

  @override
  String get settingsDataImportTitle => 'Restaurar do backup';

  @override
  String get settingsDataImportSubtitle =>
      'Substitua os dados atuais de um backup Platrare .zip ou .platrare';

  @override
  String get backupExportDialogTitle => 'Proteja este backup';

  @override
  String get backupExportDialogBody =>
      'Recomenda-se uma senha forte, especialmente se você armazenar o arquivo na nuvem. Você precisa da mesma senha para importar.';

  @override
  String get backupExportPasswordLabel => 'Senha';

  @override
  String get backupExportPasswordConfirmLabel => 'Confirme sua senha';

  @override
  String get backupExportPasswordMismatch => 'As senhas não coincidem';

  @override
  String get backupExportPasswordEmpty =>
      'Insira uma senha correspondente ou exporte sem criptografia abaixo.';

  @override
  String get backupExportPasswordTooShort =>
      'A senha deve ter pelo menos 8 caracteres.';

  @override
  String get backupExportSaveToDevice => 'Salvar no dispositivo';

  @override
  String get backupExportShareToCloud => 'Compartilhar (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Exportar sem criptografia';

  @override
  String get backupExportSkipWarningTitle => 'Exportar sem criptografia?';

  @override
  String get backupExportSkipWarningBody =>
      'Qualquer pessoa com acesso ao arquivo pode ler seus dados. Use isto apenas para cópias locais que você controla.';

  @override
  String get backupExportSkipWarningConfirm => 'Exportar sem criptografia';

  @override
  String get backupImportPasswordTitle => 'Backup criptografado';

  @override
  String get backupImportPasswordBody =>
      'Digite a senha que você usou ao exportar.';

  @override
  String get backupImportPasswordLabel => 'Senha';

  @override
  String get backupImportPreviewTitle => 'Resumo de backup';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Versão do aplicativo: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Exportado: $date';
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
    return '$accounts contas · $transactions transações · $planned planejadas · $attachments arquivos anexos · $income categorias de receitas · $expense categorias de despesas';
  }

  @override
  String get backupImportPreviewContinue => 'Continuar';

  @override
  String get settingsBackupWrongPassword => 'Senha errada';

  @override
  String get settingsBackupChecksumMismatch =>
      'Falha no backup na verificação de integridade';

  @override
  String get settingsBackupCorruptFile =>
      'Arquivo de backup inválido ou danificado';

  @override
  String get settingsBackupUnsupportedVersion =>
      'O backup precisa de uma versão mais recente do aplicativo';

  @override
  String get settingsDataImportConfirmTitle => 'Substituir os dados atuais?';

  @override
  String get settingsDataImportConfirmBody =>
      'Isso substituirá suas contas correntes, transações, transações planejadas, categorias e anexos importados pelo conteúdo do backup selecionado. Esta ação não pode ser desfeita.';

  @override
  String get settingsDataImportConfirmAction => 'Substituir dados';

  @override
  String get settingsDataImportDone => 'Dados restaurados com sucesso';

  @override
  String get settingsDataImportInvalidFile =>
      'Este arquivo não é um backup válido do Platrare';

  @override
  String get settingsDataImportFailed => 'Falha na importação';

  @override
  String get settingsDataExportDoneTitle => 'Backup exportado';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Backup salvo em:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Abrir arquivo';

  @override
  String get settingsDataExportFailed => 'Falha na exportação';

  @override
  String get ledgerVerifyDialogTitle => 'Verificação do razão';

  @override
  String get ledgerVerifyAllMatch => 'Todas as contas correspondem.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Incompatibilidades';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nArmazenado: $stored\nRepetição: $replayed\nDiferença: $diff';
  }

  @override
  String get settingsLanguage => 'Idioma do aplicativo';

  @override
  String get settingsLanguageSubtitleSystem =>
      'Seguindo as configurações do sistema';

  @override
  String get settingsLanguageSubtitleEnglish => 'Inglês';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Sérvio (latim)';

  @override
  String get settingsLanguagePickerTitle => 'Idioma do aplicativo';

  @override
  String get settingsLanguageOptionSystem => 'Padrão do sistema';

  @override
  String get settingsLanguageOptionEnglish => 'Inglês';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Sérvio (latim)';

  @override
  String get settingsSectionAppearance => 'Aparência';

  @override
  String get settingsSectionSecurity => 'Segurança';

  @override
  String get settingsSecurityEnableLock => 'Bloquear aplicativo ao abrir';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Exigir desbloqueio biométrico ou PIN quando o aplicativo for aberto';

  @override
  String get settingsSecurityLockDelayTitle => 'Rebloqueio após segundo plano';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      'Por quanto tempo o app pode ficar fora da tela antes de exigir desbloqueio novamente. Imediatamente é a opção mais segura.';

  @override
  String get settingsSecurityLockDelayImmediate => 'Imediatamente';

  @override
  String get settingsSecurityLockDelay30s => '30 segundos';

  @override
  String get settingsSecurityLockDelay1m => '1 minuto';

  @override
  String get settingsSecurityLockDelay5m => '5 minutos';

  @override
  String get settingsSecuritySetPin => 'Definir PIN';

  @override
  String get settingsSecurityChangePin => 'Alterar PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Use um PIN como alternativa se a biometria não estiver disponível';

  @override
  String get settingsSecurityRemovePin => 'Remover PIN';

  @override
  String get securitySetPinTitle => 'Definir PIN do aplicativo';

  @override
  String get securityPinLabel => 'Código PIN';

  @override
  String get securityConfirmPinLabel => 'Confirmar código PIN';

  @override
  String get securityPinMustBe4Digits => 'O PIN deve ter pelo menos 4 dígitos';

  @override
  String get securityPinMismatch => 'Os códigos PIN não correspondem';

  @override
  String get securityRemovePinTitle => 'Remover PIN?';

  @override
  String get securityRemovePinBody =>
      'O desbloqueio biométrico ainda pode ser usado, se disponível.';

  @override
  String get securityUnlockTitle => 'Aplicativo bloqueado';

  @override
  String get securityUnlockSubtitle =>
      'Desbloqueie com Face ID, impressão digital ou PIN.';

  @override
  String get securityUnlockWithPin => 'Desbloquear com PIN';

  @override
  String get securityTryBiometric => 'Experimente o desbloqueio biométrico';

  @override
  String get securityPinIncorrect => 'PIN incorreto, tente novamente';

  @override
  String get securityBiometricReason => 'Autentique para abrir seu aplicativo';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitleSystem =>
      'Seguindo as configurações do sistema';

  @override
  String get settingsThemeSubtitleLight => 'Luz';

  @override
  String get settingsThemeSubtitleDark => 'Escuro';

  @override
  String get settingsThemePickerTitle => 'Tema';

  @override
  String get settingsThemeOptionSystem => 'Padrão do sistema';

  @override
  String get settingsThemeOptionLight => 'Luz';

  @override
  String get settingsThemeOptionDark => 'Escuro';

  @override
  String get archivedAccountsTitle => 'Contas arquivadas';

  @override
  String get archivedAccountsEmptyTitle => 'Nenhuma conta arquivada';

  @override
  String get archivedAccountsEmptyBody =>
      'O saldo contábil e o cheque especial devem ser zero. Arquivar das opções da conta em Revisão.';

  @override
  String get categoriesTitle => 'Categorias';

  @override
  String get newCategoryTitle => 'Nova categoria';

  @override
  String get categoryNameLabel => 'Nome da categoria';

  @override
  String get deleteCategoryTitle => 'Excluir categoria?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" será removido da lista.';
  }

  @override
  String get categoryIncome => 'Renda';

  @override
  String get categoryExpense => 'Despesa';

  @override
  String get categoryAdd => 'Adicionar';

  @override
  String get searchCurrencies => 'Pesquisar moedas…';

  @override
  String get period1M => '1 milhão';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6 milhões';

  @override
  String get period1Y => '1 ano';

  @override
  String get periodAll => 'TODOS';

  @override
  String get categoryLabel => 'categoria';

  @override
  String get categoriesLabel => 'categorias';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type salvo • $amount';
  }

  @override
  String get tooltipSettings => 'Configurações';

  @override
  String get tooltipAddAccount => 'Adicionar conta';

  @override
  String get tooltipRemoveAccount => 'Remover conta';

  @override
  String get accountNameTaken =>
      'Você já possui uma conta com este nome e identificador (ativa ou arquivada). Altere o nome ou identificador.';

  @override
  String get groupDescPersonal => 'Suas próprias carteiras e contas bancárias';

  @override
  String get groupDescIndividuals => 'Família, amigos, indivíduos';

  @override
  String get groupDescEntities => 'Entidades, serviços públicos, organizações';

  @override
  String get cannotArchiveTitle => 'Ainda não é possível arquivar';

  @override
  String get cannotArchiveBody =>
      'O arquivamento só está disponível quando o saldo contábil e o limite do cheque especial são efetivamente zero.';

  @override
  String get cannotArchiveBodyAdjust =>
      'O arquivamento só está disponível quando o saldo contábil e o limite do cheque especial são efetivamente zero. Ajuste o livro-razão ou instalação primeiro.';

  @override
  String get archiveAccountTitle => 'Arquivar conta?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transações planejadas referenciam esta conta.',
      one: '1 transação planejada referencia esta conta.',
    );
    return '$_temp0 Remova-as para manter seu plano consistente com uma conta arquivada.';
  }

  @override
  String get removeAndArchive => 'Remover planejado e arquivar';

  @override
  String get archiveBody =>
      'A conta ficará oculta dos seletores Revisar, Rastrear e Planejar. Você pode restaurá-lo em Configurações.';

  @override
  String get archiveAction => 'Arquivo';

  @override
  String get archiveInstead => 'Arquivar em vez disso';

  @override
  String get cannotDeleteTitle => 'Não é possível excluir a conta';

  @override
  String get cannotDeleteBodyShort =>
      'Esta conta aparece no seu histórico de trilhas. Remova ou reatribua essas transações primeiro ou arquive a conta se o saldo for compensado.';

  @override
  String get cannotDeleteBodyHistory =>
      'Esta conta aparece no seu histórico de trilhas. A exclusão quebraria esse histórico – remova ou reatribua essas transações primeiro.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Esta conta aparece no seu histórico de trilhas, portanto não pode ser excluída. Em vez disso, você pode arquivá-lo se o saldo contábil e o cheque especial forem compensados ​​– ele ficará oculto nas listas, mas o histórico permanecerá intacto.';

  @override
  String get deleteAccountTitle => 'Excluir conta?';

  @override
  String get deleteAccountBodyPermanent =>
      'Esta conta será removida permanentemente.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transações planejadas referenciam esta conta e também serão excluídas.',
      one:
          '1 transação planejada referencia esta conta e também será excluída.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Excluir tudo';

  @override
  String get editAccountTitle => 'Editar conta';

  @override
  String get newAccountTitle => 'Nova conta';

  @override
  String get labelAccountName => 'Nome da conta';

  @override
  String get labelAccountIdentifier => 'Identificador (opcional)';

  @override
  String get accountAppearanceSection => 'Ícone e cor';

  @override
  String get accountPickIcon => 'Escolha o ícone';

  @override
  String get accountPickColor => 'Escolha a cor';

  @override
  String get accountIconSheetTitle => 'Ícone da conta';

  @override
  String get accountColorSheetTitle => 'Cor da conta';

  @override
  String get searchAccountIcons => 'Pesquisar ícones por nome…';

  @override
  String get accountIconSearchNoMatches =>
      'Nenhum ícone corresponde a essa pesquisa.';

  @override
  String get accountUseInitialLetter => 'Carta inicial';

  @override
  String get accountUseDefaultColor => 'Grupo de correspondência';

  @override
  String get labelRealBalance => 'Equilíbrio real';

  @override
  String get labelOverdraftLimit => 'Limite de cheque especial/adiantamento';

  @override
  String get labelCurrency => 'Moeda';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get addAccountAction => 'Adicionar conta';

  @override
  String get removeAccountSheetTitle => 'Remover conta';

  @override
  String get deletePermanently => 'Excluir permanentemente';

  @override
  String get deletePermanentlySubtitle =>
      'Só é possível quando esta conta não é utilizada no Track. Os itens planejados podem ser removidos como parte da exclusão.';

  @override
  String get archiveOptionSubtitle =>
      'Ocultar da revisão e dos seletores. Restaure a qualquer momento em Configurações. Requer saldo zero e cheque especial.';

  @override
  String get archivedBannerText =>
      'Esta conta está arquivada. Ele permanece nos seus dados, mas fica oculto nas listas e seletores.';

  @override
  String get balanceAdjustedTitle => 'Saldo ajustado na trilha';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'O saldo real foi atualizado de $previous para $current $symbol.\n\nUma transação de ajuste de saldo foi criada em Acompanhar (Histórico) para manter o razão consistente.\n\n• O saldo real reflete o valor real desta conta.\n• Verifique o histórico para a entrada de ajuste.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Ajuste de saldo';

  @override
  String get descriptionBalanceCorrection => 'Correção de equilíbrio';

  @override
  String get descriptionOpeningBalance => 'Saldo inicial';

  @override
  String get reviewStatsModeStatistics => 'Estatísticas';

  @override
  String get reviewStatsModeComparison => 'Comparação';

  @override
  String get statsUncategorized => 'Sem categoria';

  @override
  String get statsNoCategories =>
      'Não há categorias nos períodos selecionados para comparação.';

  @override
  String get statsNoTransactions => 'Nenhuma transação';

  @override
  String get statsSpendingInCategory => 'Gastos nesta categoria';

  @override
  String get statsIncomeInCategory => 'Renda nesta categoria';

  @override
  String get statsDifference => 'Diferença (B vs A):';

  @override
  String get statsNoExpensesMonth => 'Sem despesas este mês';

  @override
  String get statsNoExpensesAll => 'Nenhuma despesa registrada';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Sem despesas no último $period';
  }

  @override
  String get statsTotalSpent => 'Total gasto';

  @override
  String get statsNoExpensesThisPeriod => 'Sem despesas neste período';

  @override
  String get statsNoIncomeMonth => 'Sem renda este mês';

  @override
  String get statsNoIncomeAll => 'Nenhuma receita registrada';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Nenhuma renda no último $period';
  }

  @override
  String get statsTotalReceived => 'Total recebido';

  @override
  String get statsNoIncomeThisPeriod => 'Sem renda neste período';

  @override
  String get catSalary => 'Salário';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catConsulting => 'Consultoria';

  @override
  String get catGift => 'Presente';

  @override
  String get catRental => 'Aluguel';

  @override
  String get catDividends => 'Dividendos';

  @override
  String get catRefund => 'Reembolso';

  @override
  String get catBonus => 'Bônus';

  @override
  String get catInterest => 'Interesse';

  @override
  String get catSideHustle => 'Agitação lateral';

  @override
  String get catSaleOfGoods => 'Venda de mercadorias';

  @override
  String get catOther => 'Outro';

  @override
  String get catGroceries => 'Mantimentos';

  @override
  String get catDining => 'Jantar';

  @override
  String get catTransport => 'Transporte';

  @override
  String get catUtilities => 'Utilitários';

  @override
  String get catHousing => 'Habitação';

  @override
  String get catHealthcare => 'Assistência médica';

  @override
  String get catEntertainment => 'Entretenimento';

  @override
  String get catShopping => 'Compras';

  @override
  String get catTravel => 'Viagem';

  @override
  String get catEducation => 'Educação';

  @override
  String get catSubscriptions => 'Assinaturas';

  @override
  String get catInsurance => 'Seguro';

  @override
  String get catFuel => 'Combustível';

  @override
  String get catGym => 'Academia';

  @override
  String get catPets => 'Animais de estimação';

  @override
  String get catKids => 'Crianças';

  @override
  String get catCharity => 'Caridade';

  @override
  String get catCoffee => 'Café';

  @override
  String get catGifts => 'Presentes';

  @override
  String semanticsProjectionDate(String date) {
    return 'Data de projeção $date. Toque duas vezes para escolher a data';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Saldo pessoal projetado $amount';
  }

  @override
  String get statsEmptyTitle => 'Nenhuma transação ainda';

  @override
  String get statsEmptySubtitle =>
      'Não há dados de gastos para o intervalo selecionado.';

  @override
  String get semanticsShowProjections => 'Mostrar saldos projetados por conta';

  @override
  String get semanticsHideProjections => 'Ocultar saldos projetados por conta';

  @override
  String get semanticsDateAllTime => 'Data: sempre – toque para alterar o modo';

  @override
  String semanticsDateMode(String mode) {
    return 'Data: $mode — toque para alterar o modo';
  }

  @override
  String get semanticsDateThisMonth =>
      'Data: este mês – toque para mês, semana, ano ou o tempo todo';

  @override
  String get semanticsTxTypeCycle =>
      'Tipo de transação: ciclo tudo, receita, despesa, transferência';

  @override
  String get semanticsAccountFilter => 'Filtro de conta';

  @override
  String get semanticsAlreadyFiltered => 'Já filtrado para esta conta';

  @override
  String get semanticsCategoryFilter => 'Filtro de categoria';

  @override
  String get semanticsSortToggle =>
      'Classificar: alterne o mais novo ou o mais antigo primeiro';

  @override
  String get semanticsFiltersDisabled =>
      'Filtros de lista desativados ao visualizar uma data de projeção futura. Limpe as projeções para usar filtros.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Filtros de lista desativados. Adicione uma conta primeiro.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Filtros de lista desativados. Adicione primeiro uma transação planejada.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Filtros de lista desativados. Registre uma transação primeiro.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Controles de seção e moeda desativados. Adicione uma conta primeiro.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Data de projeção e detalhamento de saldo desativados. Adicione uma conta e uma transação planejada primeiro.';

  @override
  String get semanticsReorderAccountHint =>
      'Mantenha pressionado e arraste para reordenar neste grupo';

  @override
  String get semanticsChartStyle => 'Estilo de gráfico';

  @override
  String get semanticsChartStyleUnavailable =>
      'Estilo de gráfico (indisponível no modo de comparação)';

  @override
  String semanticsPeriod(String label) {
    return 'Período: $label';
  }

  @override
  String get trackSearchHint => 'Descrição da pesquisa, categoria, conta…';

  @override
  String get trackSearchClear => 'Limpar pesquisa';

  @override
  String get settingsExchangeRatesTitle => 'Taxas de câmbio';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Última atualização: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Usando tarifas off-line ou agrupadas – toque para atualizar';

  @override
  String get settingsExchangeRatesSource => 'BCE';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Taxas de câmbio atualizadas';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Não foi possível atualizar as taxas de câmbio. Verifique sua conexão.';

  @override
  String get settingsClearData => 'Limpar dados';

  @override
  String get settingsClearDataSubtitle =>
      'Remover permanentemente os dados selecionados';

  @override
  String get clearDataTitle => 'Limpar dados';

  @override
  String get clearDataTransactions => 'Histórico de transações';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return 'Transações $count · saldos de contas zerados';
  }

  @override
  String get clearDataPlanned => 'Transações planejadas';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count itens planejados';
  }

  @override
  String get clearDataAccounts => 'Contas';

  @override
  String clearDataAccountsSubtitle(int count) {
    return 'contas $count · também limpa histórico e plano';
  }

  @override
  String get clearDataCategories => 'Categorias';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return 'Categorias $count · substituídas por padrões';
  }

  @override
  String get clearDataPreferences => 'Preferências';

  @override
  String get clearDataPreferencesSubtitle =>
      'Redefinir moeda, tema e idioma para os padrões';

  @override
  String get clearDataSecurity => 'Bloqueio de aplicativo e PIN';

  @override
  String get clearDataSecuritySubtitle =>
      'Desative o bloqueio de aplicativos e remova o PIN';

  @override
  String get clearDataConfirmButton => 'Limpar selecionado';

  @override
  String get clearDataConfirmTitle => 'Isso não pode ser desfeito';

  @override
  String get clearDataConfirmBody =>
      'Os dados selecionados serão excluídos permanentemente. Exporte um backup primeiro, se precisar dele mais tarde.';

  @override
  String get clearDataTypeConfirm => 'Digite DELETE para confirmar';

  @override
  String get clearDataTypeConfirmError =>
      'Digite DELETE exatamente para continuar';

  @override
  String get clearDataPinTitle => 'Confirme com PIN';

  @override
  String get clearDataPinBody =>
      'Insira o PIN do seu aplicativo para autorizar esta ação.';

  @override
  String get clearDataPinIncorrect => 'PIN incorreto';

  @override
  String get clearDataDone => 'Dados selecionados apagados';

  @override
  String get autoBackupTitle => 'Backup diário automático';

  @override
  String autoBackupLastAt(String date) {
    return 'Último backup $date';
  }

  @override
  String get autoBackupNeverRun => 'Ainda não há backup';

  @override
  String get autoBackupShareTitle => 'Salvar na nuvem';

  @override
  String get autoBackupShareSubtitle =>
      'Carregue o backup mais recente para iCloud Drive, Google Drive ou qualquer aplicativo';

  @override
  String get autoBackupCloudReminder =>
      'Pronto para backup automático – salve-o na nuvem para proteção fora do dispositivo';

  @override
  String get autoBackupCloudReminderAction => 'Compartilhar';

  @override
  String get settingsBackupReminderTitle => 'Lembrete de backup';

  @override
  String get settingsBackupReminderSubtitle =>
      'Banner no app se você adicionar muitas transações sem exportar um backup manual.';

  @override
  String get settingsBackupReminderThresholdTitle => 'Limite de transações';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return 'Lembrar após $count novas transações desde o último export manual.';
  }

  @override
  String get settingsBackupReminderThresholdInvalid =>
      'Insira um número inteiro de 1 a 500.';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '\"Lembrar depois\" oculta o banner até você adicionar mais $n transações.';
  }

  @override
  String get backupReminderBannerTitle => 'Exportar um backup?';

  @override
  String backupReminderBannerBody(int count) {
    return 'Você adicionou $count transações desde o último export manual.';
  }

  @override
  String get backupReminderRemindLater => 'Lembrar depois';

  @override
  String get persistenceErrorReloaded =>
      'Não foi possível salvar as alterações. Os dados foram recarregados do armazenamento.';
}
