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
  String get heroBalance => 'Balance';

  @override
  String get realBalance => 'Real balance';

  @override
  String get filterClearFilters => 'Clear filters';

  @override
  String get filterClearProjections => 'Clear projections';

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
  String get repeatEndPickDate => 'Pick end date';

  @override
  String get repeatEndTimes => 'times';

  @override
  String repeatSummaryEvery(int count, String unit) {
    return 'Every $count $unit';
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
  String get settingsBaseCurrency => 'Base currency';

  @override
  String get settingsSecondaryCurrency => 'Secondary display currency';

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
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsPrivacyPolicyTitle => 'Privacy policy';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'How Platrare handles your data. Shown here in the app.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Exchange rates: the app fetches public currency rates over the internet. Your accounts and transactions are never sent.';

  @override
  String get settingsPrivacyOpenFailed => 'Could not load the privacy policy.';

  @override
  String get settingsPrivacyRetry => 'Try again';

  @override
  String get settingsCopySupportInfoTitle => 'Copy support info';

  @override
  String get settingsCopySupportInfoSubtitle =>
      'App version and build for bug reports';

  @override
  String get settingsSupportInfoCopied => 'Copied to clipboard';

  @override
  String get settingsVerifyLedger => 'Verify ledger';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Replay transactions and compare to stored balances';

  @override
  String get settingsDataExportTitle => 'Export data backup';

  @override
  String get settingsDataExportSubtitle =>
      'Save as .zip (plain) or .platrare (password-protected) with ledger data and attachments';

  @override
  String get settingsDataImportTitle => 'Import data backup';

  @override
  String get settingsDataImportSubtitle =>
      'Restore from a Platrare .zip or encrypted .platrare backup';

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
  String get settingsDataImportConfirmTitle =>
      'Import and overwrite current data?';

  @override
  String get settingsDataImportConfirmBody =>
      'This will replace your current accounts, transactions, planned transactions, categories, and imported attachments with the contents of the selected backup. This action cannot be undone.';

  @override
  String get settingsDataImportConfirmAction => 'Import and overwrite';

  @override
  String get settingsDataImportDone => 'Backup imported successfully';

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
      'When you archive an account from Review, it will appear here. You can restore it anytime.';

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
  String get reviewUseBaseCurrency => 'Use base currency';

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
  String get statsEmptySubtitle => 'Your spending statistics will appear here';

  @override
  String get semanticsShowProjections => 'Show projected balances by account';

  @override
  String get semanticsHideProjections => 'Hide projected balances by account';

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
  String get persistenceErrorReloaded =>
      'Couldn’t save changes. Data was reloaded from storage.';
}
