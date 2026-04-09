import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sr'),
    Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Platrare'**
  String get appTitle;

  /// No description provided for @navPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get navPlan;

  /// No description provided for @navTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get navTrack;

  /// No description provided for @navReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get navReview;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @heroIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get heroIn;

  /// No description provided for @heroOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get heroOut;

  /// No description provided for @heroNet.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get heroNet;

  /// No description provided for @heroBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get heroBalance;

  /// No description provided for @realBalance.
  ///
  /// In en, this message translates to:
  /// **'Real balance'**
  String get realBalance;

  /// No description provided for @filterClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get filterClearFilters;

  /// No description provided for @filterClearProjections.
  ///
  /// In en, this message translates to:
  /// **'Clear projections'**
  String get filterClearProjections;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterAllAccounts.
  ///
  /// In en, this message translates to:
  /// **'All accounts'**
  String get filterAllAccounts;

  /// No description provided for @filterAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get filterAllCategories;

  /// No description provided for @txLabelIncome.
  ///
  /// In en, this message translates to:
  /// **'INCOME'**
  String get txLabelIncome;

  /// No description provided for @txLabelExpense.
  ///
  /// In en, this message translates to:
  /// **'EXPENSE'**
  String get txLabelExpense;

  /// No description provided for @txLabelInvoice.
  ///
  /// In en, this message translates to:
  /// **'INVOICE'**
  String get txLabelInvoice;

  /// No description provided for @txLabelBill.
  ///
  /// In en, this message translates to:
  /// **'BILL'**
  String get txLabelBill;

  /// No description provided for @txLabelAdvance.
  ///
  /// In en, this message translates to:
  /// **'ADVANCE'**
  String get txLabelAdvance;

  /// No description provided for @txLabelSettlement.
  ///
  /// In en, this message translates to:
  /// **'SETTLEMENT'**
  String get txLabelSettlement;

  /// No description provided for @txLabelLoan.
  ///
  /// In en, this message translates to:
  /// **'LOAN'**
  String get txLabelLoan;

  /// No description provided for @txLabelCollection.
  ///
  /// In en, this message translates to:
  /// **'COLLECTION'**
  String get txLabelCollection;

  /// No description provided for @txLabelOffset.
  ///
  /// In en, this message translates to:
  /// **'OFFSET'**
  String get txLabelOffset;

  /// No description provided for @txLabelTransfer.
  ///
  /// In en, this message translates to:
  /// **'TRANSFER'**
  String get txLabelTransfer;

  /// No description provided for @txLabelTransaction.
  ///
  /// In en, this message translates to:
  /// **'TRANSACTION'**
  String get txLabelTransaction;

  /// No description provided for @repeatNone.
  ///
  /// In en, this message translates to:
  /// **'No repeat'**
  String get repeatNone;

  /// No description provided for @repeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get repeatMonthly;

  /// No description provided for @repeatYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get repeatYearly;

  /// No description provided for @repeatEveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get repeatEveryLabel;

  /// No description provided for @repeatEveryDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day} other{{count} days}}'**
  String repeatEveryDays(int count);

  /// No description provided for @repeatEveryWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{week} other{{count} weeks}}'**
  String repeatEveryWeeks(int count);

  /// No description provided for @repeatEveryMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{month} other{{count} months}}'**
  String repeatEveryMonths(int count);

  /// No description provided for @repeatEveryYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{year} other{{count} years}}'**
  String repeatEveryYears(int count);

  /// No description provided for @repeatEndLabel.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get repeatEndLabel;

  /// No description provided for @repeatEndNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get repeatEndNever;

  /// No description provided for @repeatEndOnDate.
  ///
  /// In en, this message translates to:
  /// **'On date'**
  String get repeatEndOnDate;

  /// No description provided for @repeatEndAfterCount.
  ///
  /// In en, this message translates to:
  /// **'After {count} times'**
  String repeatEndAfterCount(int count);

  /// No description provided for @repeatEndPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick end date'**
  String get repeatEndPickDate;

  /// No description provided for @repeatEndTimes.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get repeatEndTimes;

  /// No description provided for @repeatSummaryEvery.
  ///
  /// In en, this message translates to:
  /// **'Every {count} {unit}'**
  String repeatSummaryEvery(int count, String unit);

  /// No description provided for @repeatSummaryUntil.
  ///
  /// In en, this message translates to:
  /// **'until {date}'**
  String repeatSummaryUntil(String date);

  /// No description provided for @repeatSummaryTimes.
  ///
  /// In en, this message translates to:
  /// **'{count} times'**
  String repeatSummaryTimes(int count);

  /// No description provided for @repeatSummaryTimesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining} of {total} remaining'**
  String repeatSummaryTimesRemaining(int remaining, int total);

  /// No description provided for @detailRepeatEvery.
  ///
  /// In en, this message translates to:
  /// **'Repeat every'**
  String get detailRepeatEvery;

  /// No description provided for @detailEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get detailEnds;

  /// No description provided for @detailEndsNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get detailEndsNever;

  /// No description provided for @detailEndsOnDate.
  ///
  /// In en, this message translates to:
  /// **'On {date}'**
  String detailEndsOnDate(String date);

  /// No description provided for @detailEndsAfterCount.
  ///
  /// In en, this message translates to:
  /// **'After {count} times'**
  String detailEndsAfterCount(int count);

  /// No description provided for @detailProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get detailProgress;

  /// No description provided for @weekendNoChange.
  ///
  /// In en, this message translates to:
  /// **'No change'**
  String get weekendNoChange;

  /// No description provided for @weekendFriday.
  ///
  /// In en, this message translates to:
  /// **'Move to Friday'**
  String get weekendFriday;

  /// No description provided for @weekendMonday.
  ///
  /// In en, this message translates to:
  /// **'Move to Monday'**
  String get weekendMonday;

  /// No description provided for @weekendQuestion.
  ///
  /// In en, this message translates to:
  /// **'If the {day} falls on a weekend?'**
  String weekendQuestion(String day);

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dateTomorrow;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @statsAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get statsAllTime;

  /// No description provided for @accountGroupPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get accountGroupPersonal;

  /// No description provided for @accountGroupIndividual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get accountGroupIndividual;

  /// No description provided for @accountGroupEntity.
  ///
  /// In en, this message translates to:
  /// **'Entity'**
  String get accountGroupEntity;

  /// No description provided for @accountSectionIndividuals.
  ///
  /// In en, this message translates to:
  /// **'Individuals'**
  String get accountSectionIndividuals;

  /// No description provided for @accountSectionEntities.
  ///
  /// In en, this message translates to:
  /// **'Entities'**
  String get accountSectionEntities;

  /// No description provided for @emptyNoTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get emptyNoTransactionsYet;

  /// No description provided for @emptyNoAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get emptyNoAccountsYet;

  /// No description provided for @emptyRecordFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to record your first transaction.'**
  String get emptyRecordFirstTransaction;

  /// No description provided for @emptyAddFirstAccountTx.
  ///
  /// In en, this message translates to:
  /// **'Add your first account before recording transactions.'**
  String get emptyAddFirstAccountTx;

  /// No description provided for @emptyAddFirstAccountPlan.
  ///
  /// In en, this message translates to:
  /// **'Add your first account before planning transactions.'**
  String get emptyAddFirstAccountPlan;

  /// No description provided for @emptyAddFirstAccountReview.
  ///
  /// In en, this message translates to:
  /// **'Add your first account to start tracking your finances.'**
  String get emptyAddFirstAccountReview;

  /// No description provided for @emptyAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get emptyAddTransaction;

  /// No description provided for @emptyAddAccount.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get emptyAddAccount;

  /// No description provided for @reviewEmptyGroupPersonalTitle.
  ///
  /// In en, this message translates to:
  /// **'No personal accounts yet'**
  String get reviewEmptyGroupPersonalTitle;

  /// No description provided for @reviewEmptyGroupPersonalBody.
  ///
  /// In en, this message translates to:
  /// **'Personal accounts are your own wallets and bank accounts. Add one to track everyday income and spending.'**
  String get reviewEmptyGroupPersonalBody;

  /// No description provided for @reviewEmptyGroupIndividualsTitle.
  ///
  /// In en, this message translates to:
  /// **'No individual accounts yet'**
  String get reviewEmptyGroupIndividualsTitle;

  /// No description provided for @reviewEmptyGroupIndividualsBody.
  ///
  /// In en, this message translates to:
  /// **'Individual accounts track money with specific people—shared costs, loans, or IOUs. Add an account for each person you settle with.'**
  String get reviewEmptyGroupIndividualsBody;

  /// No description provided for @reviewEmptyGroupEntitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'No entity accounts yet'**
  String get reviewEmptyGroupEntitiesTitle;

  /// No description provided for @reviewEmptyGroupEntitiesBody.
  ///
  /// In en, this message translates to:
  /// **'Entity accounts are for businesses, projects, or organizations. Use them to keep business cash flow separate from your personal finances.'**
  String get reviewEmptyGroupEntitiesBody;

  /// No description provided for @emptyNoTransactionsForFilters.
  ///
  /// In en, this message translates to:
  /// **'No transactions for applied filters'**
  String get emptyNoTransactionsForFilters;

  /// No description provided for @emptyNoTransactionsInHistory.
  ///
  /// In en, this message translates to:
  /// **'No transactions in history'**
  String get emptyNoTransactionsInHistory;

  /// No description provided for @emptyNoTransactionsForMonth.
  ///
  /// In en, this message translates to:
  /// **'No transactions for {month}'**
  String emptyNoTransactionsForMonth(String month);

  /// No description provided for @emptyNoTransactionsForAccount.
  ///
  /// In en, this message translates to:
  /// **'No transactions for this account'**
  String get emptyNoTransactionsForAccount;

  /// No description provided for @trackTransactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get trackTransactionDeleted;

  /// No description provided for @trackDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction?'**
  String get trackDeleteTitle;

  /// No description provided for @trackDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This will reverse the account balance changes.'**
  String get trackDeleteBody;

  /// No description provided for @trackTransaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get trackTransaction;

  /// No description provided for @planConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm transaction?'**
  String get planConfirmTitle;

  /// No description provided for @planConfirmBodyEarly.
  ///
  /// In en, this message translates to:
  /// **'This occurrence is scheduled for {date}. It will be recorded in History with today’s date ({todayDate}). The next occurrence remains on {nextDate}.'**
  String planConfirmBodyEarly(String date, String todayDate, String nextDate);

  /// No description provided for @planConfirmBodyNormal.
  ///
  /// In en, this message translates to:
  /// **'This will apply the transaction to your real account balances and move it to History.'**
  String get planConfirmBodyNormal;

  /// No description provided for @planTransactionConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Transaction confirmed and applied'**
  String get planTransactionConfirmed;

  /// No description provided for @planTransactionRemoved.
  ///
  /// In en, this message translates to:
  /// **'Planned transaction removed'**
  String get planTransactionRemoved;

  /// No description provided for @planRepeatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeating transaction'**
  String get planRepeatingTitle;

  /// No description provided for @planRepeatingBody.
  ///
  /// In en, this message translates to:
  /// **'Skip only this date—the series continues with the next occurrence—or delete every remaining occurrence from your plan.'**
  String get planRepeatingBody;

  /// No description provided for @planDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get planDeleteAll;

  /// No description provided for @planSkipThisOnly.
  ///
  /// In en, this message translates to:
  /// **'Skip this only'**
  String get planSkipThisOnly;

  /// No description provided for @planOccurrenceSkipped.
  ///
  /// In en, this message translates to:
  /// **'This occurrence skipped — next one scheduled'**
  String get planOccurrenceSkipped;

  /// No description provided for @planNothingPlanned.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned for now'**
  String get planNothingPlanned;

  /// No description provided for @planPlanBody.
  ///
  /// In en, this message translates to:
  /// **'Plan upcoming transactions.'**
  String get planPlanBody;

  /// No description provided for @planAddPlan.
  ///
  /// In en, this message translates to:
  /// **'Add plan'**
  String get planAddPlan;

  /// No description provided for @planNoPlannedForFilters.
  ///
  /// In en, this message translates to:
  /// **'No planned transactions for applied filters'**
  String get planNoPlannedForFilters;

  /// No description provided for @planNoPlannedInMonth.
  ///
  /// In en, this message translates to:
  /// **'No planned transactions in {month}'**
  String planNoPlannedInMonth(String month);

  /// No description provided for @planOverdue.
  ///
  /// In en, this message translates to:
  /// **'overdue'**
  String get planOverdue;

  /// No description provided for @planPlannedTransaction.
  ///
  /// In en, this message translates to:
  /// **'Planned transaction'**
  String get planPlannedTransaction;

  /// No description provided for @discardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardTitle;

  /// No description provided for @discardBody.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. They will be lost if you leave now.'**
  String get discardBody;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @newTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'New Transaction'**
  String get newTransactionTitle;

  /// No description provided for @editTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransactionTitle;

  /// No description provided for @transactionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Transaction updated'**
  String get transactionUpdated;

  /// No description provided for @sectionAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get sectionAccounts;

  /// No description provided for @labelFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get labelFrom;

  /// No description provided for @labelTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get labelTo;

  /// No description provided for @sectionCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get sectionCategory;

  /// No description provided for @sectionAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get sectionAttachments;

  /// No description provided for @labelNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get labelNote;

  /// No description provided for @hintOptionalDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional description'**
  String get hintOptionalDescription;

  /// No description provided for @updateTransaction.
  ///
  /// In en, this message translates to:
  /// **'Update Transaction'**
  String get updateTransaction;

  /// No description provided for @saveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get saveTransaction;

  /// No description provided for @selectAccount.
  ///
  /// In en, this message translates to:
  /// **'Select account'**
  String get selectAccount;

  /// No description provided for @selectAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Account'**
  String get selectAccountTitle;

  /// No description provided for @noAccountsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No accounts available'**
  String get noAccountsAvailable;

  /// No description provided for @amountReceivedBy.
  ///
  /// In en, this message translates to:
  /// **'Amount received by {name} ({currency})'**
  String amountReceivedBy(String name, String currency);

  /// No description provided for @amountReceivedHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter the exact amount the destination account receives. This locks the real exchange rate used.'**
  String get amountReceivedHelper;

  /// No description provided for @attachTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get attachTakePhoto;

  /// No description provided for @attachTakePhotoSub.
  ///
  /// In en, this message translates to:
  /// **'Use camera to capture a receipt'**
  String get attachTakePhotoSub;

  /// No description provided for @attachChooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get attachChooseGallery;

  /// No description provided for @attachChooseGallerySub.
  ///
  /// In en, this message translates to:
  /// **'Select photos from your library'**
  String get attachChooseGallerySub;

  /// No description provided for @attachBrowseFiles.
  ///
  /// In en, this message translates to:
  /// **'Browse files'**
  String get attachBrowseFiles;

  /// No description provided for @attachBrowseFilesSub.
  ///
  /// In en, this message translates to:
  /// **'Attach PDFs, documents or other files'**
  String get attachBrowseFilesSub;

  /// No description provided for @attachButton.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get attachButton;

  /// No description provided for @editPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Plan'**
  String get editPlanTitle;

  /// No description provided for @planTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Transaction'**
  String get planTransactionTitle;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// No description provided for @updatePlan.
  ///
  /// In en, this message translates to:
  /// **'Update Plan'**
  String get updatePlan;

  /// No description provided for @addToPlan.
  ///
  /// In en, this message translates to:
  /// **'Add to Plan'**
  String get addToPlan;

  /// No description provided for @labelRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get labelRepeat;

  /// No description provided for @selectPlannedDate.
  ///
  /// In en, this message translates to:
  /// **'Select planned date'**
  String get selectPlannedDate;

  /// No description provided for @balancesAsOfToday.
  ///
  /// In en, this message translates to:
  /// **'Balances as of today'**
  String get balancesAsOfToday;

  /// No description provided for @projectedBalancesForTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Projected balances for tomorrow'**
  String get projectedBalancesForTomorrow;

  /// No description provided for @projectedBalancesForDate.
  ///
  /// In en, this message translates to:
  /// **'Projected balances for {date}'**
  String projectedBalancesForDate(String date);

  /// No description provided for @destReceivesLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} receives ({currency})'**
  String destReceivesLabel(String name, String currency);

  /// No description provided for @destHelper.
  ///
  /// In en, this message translates to:
  /// **'Estimated destination amount. Exact rate is locked at confirmation.'**
  String get destHelper;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @detailTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get detailTransactionTitle;

  /// No description provided for @detailPlannedTitle.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get detailPlannedTitle;

  /// No description provided for @detailConfirmTransaction.
  ///
  /// In en, this message translates to:
  /// **'Confirm transaction'**
  String get detailConfirmTransaction;

  /// No description provided for @detailDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get detailDate;

  /// No description provided for @detailFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get detailFrom;

  /// No description provided for @detailTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get detailTo;

  /// No description provided for @detailCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get detailCategory;

  /// No description provided for @detailNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get detailNote;

  /// No description provided for @detailDestinationAmount.
  ///
  /// In en, this message translates to:
  /// **'Destination amount'**
  String get detailDestinationAmount;

  /// No description provided for @detailExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate'**
  String get detailExchangeRate;

  /// No description provided for @detailRepeats.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get detailRepeats;

  /// No description provided for @detailDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get detailDayOfMonth;

  /// No description provided for @detailWeekends.
  ///
  /// In en, this message translates to:
  /// **'Weekends'**
  String get detailWeekends;

  /// No description provided for @detailAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get detailAttachments;

  /// No description provided for @detailFileCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file} other{{count} files}}'**
  String detailFileCount(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsSectionDisplay;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsSectionCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get settingsSectionCategories;

  /// No description provided for @settingsSectionAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get settingsSectionAccounts;

  /// No description provided for @settingsBaseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Base currency'**
  String get settingsBaseCurrency;

  /// No description provided for @settingsSecondaryCurrency.
  ///
  /// In en, this message translates to:
  /// **'Secondary display currency'**
  String get settingsSecondaryCurrency;

  /// No description provided for @settingsCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get settingsCategories;

  /// No description provided for @settingsCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{incomeCount} income · {expenseCount} expense'**
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount);

  /// No description provided for @settingsArchivedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Archived accounts'**
  String get settingsArchivedAccounts;

  /// No description provided for @settingsArchivedAccountsSubtitleZero.
  ///
  /// In en, this message translates to:
  /// **'None right now — archive from account edit when balance is clear'**
  String get settingsArchivedAccountsSubtitleZero;

  /// No description provided for @settingsArchivedAccountsSubtitleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} hidden from Review and pickers'**
  String settingsArchivedAccountsSubtitleCount(int count);

  /// No description provided for @settingsSectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsSectionData;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsPrivacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyPolicyTitle;

  /// No description provided for @settingsPrivacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How Platrare handles your data. Opens in your browser.'**
  String get settingsPrivacyPolicySubtitle;

  /// No description provided for @settingsPrivacyFxDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates: the app fetches public currency rates over the internet. Your accounts and transactions are never sent.'**
  String get settingsPrivacyFxDisclosure;

  /// No description provided for @settingsPrivacyOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link'**
  String get settingsPrivacyOpenFailed;

  /// No description provided for @settingsCopySupportInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy support info'**
  String get settingsCopySupportInfoTitle;

  /// No description provided for @settingsCopySupportInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App version and build for bug reports'**
  String get settingsCopySupportInfoSubtitle;

  /// No description provided for @settingsSupportInfoCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get settingsSupportInfoCopied;

  /// No description provided for @settingsVerifyLedger.
  ///
  /// In en, this message translates to:
  /// **'Verify ledger'**
  String get settingsVerifyLedger;

  /// No description provided for @settingsVerifyLedgerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Replay transactions and compare to stored balances'**
  String get settingsVerifyLedgerSubtitle;

  /// No description provided for @settingsDataExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export data backup'**
  String get settingsDataExportTitle;

  /// No description provided for @settingsDataExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save as .zip (plain) or .platrare (password-protected) with ledger data and attachments'**
  String get settingsDataExportSubtitle;

  /// No description provided for @settingsDataImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import data backup'**
  String get settingsDataImportTitle;

  /// No description provided for @settingsDataImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from a Platrare .zip or encrypted .platrare backup'**
  String get settingsDataImportSubtitle;

  /// No description provided for @backupExportDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect this backup'**
  String get backupExportDialogTitle;

  /// No description provided for @backupExportDialogBody.
  ///
  /// In en, this message translates to:
  /// **'A strong password is recommended, especially if you store the file in the cloud. You need the same password to import.'**
  String get backupExportDialogBody;

  /// No description provided for @backupExportPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get backupExportPasswordLabel;

  /// No description provided for @backupExportPasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get backupExportPasswordConfirmLabel;

  /// No description provided for @backupExportPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get backupExportPasswordMismatch;

  /// No description provided for @backupExportPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a matching password, or export without encryption below.'**
  String get backupExportPasswordEmpty;

  /// No description provided for @backupExportWithoutEncryption.
  ///
  /// In en, this message translates to:
  /// **'Export without encryption'**
  String get backupExportWithoutEncryption;

  /// No description provided for @backupExportSkipWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Export without encryption?'**
  String get backupExportSkipWarningTitle;

  /// No description provided for @backupExportSkipWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Anyone with access to the file can read your data. Use this only for local copies you control.'**
  String get backupExportSkipWarningBody;

  /// No description provided for @backupExportSkipWarningConfirm.
  ///
  /// In en, this message translates to:
  /// **'Export unencrypted'**
  String get backupExportSkipWarningConfirm;

  /// No description provided for @backupImportPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup'**
  String get backupImportPasswordTitle;

  /// No description provided for @backupImportPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the password you used when exporting.'**
  String get backupImportPasswordBody;

  /// No description provided for @backupImportPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get backupImportPasswordLabel;

  /// No description provided for @backupImportPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup summary'**
  String get backupImportPreviewTitle;

  /// No description provided for @backupImportPreviewVersion.
  ///
  /// In en, this message translates to:
  /// **'App version: {version}'**
  String backupImportPreviewVersion(String version);

  /// No description provided for @backupImportPreviewExported.
  ///
  /// In en, this message translates to:
  /// **'Exported: {date}'**
  String backupImportPreviewExported(String date);

  /// No description provided for @backupImportPreviewCounts.
  ///
  /// In en, this message translates to:
  /// **'{accounts} accounts · {transactions} transactions · {planned} planned · {attachments} attachment files · {income} income categories · {expense} expense categories'**
  String backupImportPreviewCounts(
    int accounts,
    int transactions,
    int planned,
    int attachments,
    int income,
    int expense,
  );

  /// No description provided for @backupImportPreviewContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get backupImportPreviewContinue;

  /// No description provided for @settingsBackupWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get settingsBackupWrongPassword;

  /// No description provided for @settingsBackupChecksumMismatch.
  ///
  /// In en, this message translates to:
  /// **'Backup failed integrity check'**
  String get settingsBackupChecksumMismatch;

  /// No description provided for @settingsBackupCorruptFile.
  ///
  /// In en, this message translates to:
  /// **'Invalid or damaged backup file'**
  String get settingsBackupCorruptFile;

  /// No description provided for @settingsBackupUnsupportedVersion.
  ///
  /// In en, this message translates to:
  /// **'Backup needs a newer app version'**
  String get settingsBackupUnsupportedVersion;

  /// No description provided for @settingsDataImportConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Import and overwrite current data?'**
  String get settingsDataImportConfirmTitle;

  /// No description provided for @settingsDataImportConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will replace your current accounts, transactions, planned transactions, categories, and imported attachments with the contents of the selected backup. This action cannot be undone.'**
  String get settingsDataImportConfirmBody;

  /// No description provided for @settingsDataImportConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Import and overwrite'**
  String get settingsDataImportConfirmAction;

  /// No description provided for @settingsDataImportDone.
  ///
  /// In en, this message translates to:
  /// **'Backup imported successfully'**
  String get settingsDataImportDone;

  /// No description provided for @settingsDataImportInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'This file is not a valid Platrare backup'**
  String get settingsDataImportInvalidFile;

  /// No description provided for @settingsDataImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get settingsDataImportFailed;

  /// No description provided for @settingsDataExportDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup exported'**
  String get settingsDataExportDoneTitle;

  /// No description provided for @settingsDataExportDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Backup saved to:\n{path}'**
  String settingsDataExportDoneBody(String path);

  /// No description provided for @settingsDataOpenExportFile.
  ///
  /// In en, this message translates to:
  /// **'Open file'**
  String get settingsDataOpenExportFile;

  /// No description provided for @settingsDataExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get settingsDataExportFailed;

  /// No description provided for @ledgerVerifyDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Ledger verification'**
  String get ledgerVerifyDialogTitle;

  /// No description provided for @ledgerVerifyAllMatch.
  ///
  /// In en, this message translates to:
  /// **'All accounts match.'**
  String get ledgerVerifyAllMatch;

  /// No description provided for @ledgerVerifyMismatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Mismatches'**
  String get ledgerVerifyMismatchesTitle;

  /// No description provided for @ledgerVerifyMismatchDetails.
  ///
  /// In en, this message translates to:
  /// **'{accountName}\nStored: {stored}\nReplay: {replayed}\nDifference: {diff}'**
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  );

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitleSystem.
  ///
  /// In en, this message translates to:
  /// **'Following system settings'**
  String get settingsLanguageSubtitleSystem;

  /// No description provided for @settingsLanguageSubtitleEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageSubtitleEnglish;

  /// No description provided for @settingsLanguageSubtitleSerbianLatin.
  ///
  /// In en, this message translates to:
  /// **'Serbian (Latin)'**
  String get settingsLanguageSubtitleSerbianLatin;

  /// No description provided for @settingsLanguagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguagePickerTitle;

  /// No description provided for @settingsLanguageOptionSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageOptionSystem;

  /// No description provided for @settingsLanguageOptionEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageOptionEnglish;

  /// No description provided for @settingsLanguageOptionSerbianLatin.
  ///
  /// In en, this message translates to:
  /// **'Serbian (Latin)'**
  String get settingsLanguageOptionSerbianLatin;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSectionSecurity;

  /// No description provided for @settingsSecurityEnableLock.
  ///
  /// In en, this message translates to:
  /// **'Lock app on open'**
  String get settingsSecurityEnableLock;

  /// No description provided for @settingsSecurityEnableLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require biometric unlock or PIN when app opens'**
  String get settingsSecurityEnableLockSubtitle;

  /// No description provided for @settingsSecuritySetPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get settingsSecuritySetPin;

  /// No description provided for @settingsSecurityChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get settingsSecurityChangePin;

  /// No description provided for @settingsSecurityPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use a PIN as fallback if biometric is unavailable'**
  String get settingsSecurityPinSubtitle;

  /// No description provided for @settingsSecurityRemovePin.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get settingsSecurityRemovePin;

  /// No description provided for @securitySetPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Set app PIN'**
  String get securitySetPinTitle;

  /// No description provided for @securityPinLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get securityPinLabel;

  /// No description provided for @securityConfirmPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN code'**
  String get securityConfirmPinLabel;

  /// No description provided for @securityPinMustBe4Digits.
  ///
  /// In en, this message translates to:
  /// **'PIN must have at least 4 digits'**
  String get securityPinMustBe4Digits;

  /// No description provided for @securityPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PIN codes do not match'**
  String get securityPinMismatch;

  /// No description provided for @securityRemovePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN?'**
  String get securityRemovePinTitle;

  /// No description provided for @securityRemovePinBody.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock can still be used if available.'**
  String get securityRemovePinBody;

  /// No description provided for @securityUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'App locked'**
  String get securityUnlockTitle;

  /// No description provided for @securityUnlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Face ID, fingerprint, or PIN.'**
  String get securityUnlockSubtitle;

  /// No description provided for @securityUnlockWithPin.
  ///
  /// In en, this message translates to:
  /// **'Unlock with PIN'**
  String get securityUnlockWithPin;

  /// No description provided for @securityTryBiometric.
  ///
  /// In en, this message translates to:
  /// **'Try biometric unlock'**
  String get securityTryBiometric;

  /// No description provided for @securityPinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN, try again'**
  String get securityPinIncorrect;

  /// No description provided for @securityBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to open your app'**
  String get securityBiometricReason;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSubtitleSystem.
  ///
  /// In en, this message translates to:
  /// **'Following system settings'**
  String get settingsThemeSubtitleSystem;

  /// No description provided for @settingsThemeSubtitleLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeSubtitleLight;

  /// No description provided for @settingsThemeSubtitleDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeSubtitleDark;

  /// No description provided for @settingsThemePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemePickerTitle;

  /// No description provided for @settingsThemeOptionSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeOptionSystem;

  /// No description provided for @settingsThemeOptionLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeOptionLight;

  /// No description provided for @settingsThemeOptionDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeOptionDark;

  /// No description provided for @archivedAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Archived accounts'**
  String get archivedAccountsTitle;

  /// No description provided for @archivedAccountsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No archived accounts'**
  String get archivedAccountsEmptyTitle;

  /// No description provided for @archivedAccountsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When you archive an account from Review, it will appear here. You can restore it anytime.'**
  String get archivedAccountsEmptyBody;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @newCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategoryTitle;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryNameLabel;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryBody.
  ///
  /// In en, this message translates to:
  /// **'\"{category}\" will be removed from the list.'**
  String deleteCategoryBody(String category);

  /// No description provided for @categoryIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get categoryIncome;

  /// No description provided for @categoryExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get categoryExpense;

  /// No description provided for @categoryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get categoryAdd;

  /// No description provided for @searchCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Search currencies…'**
  String get searchCurrencies;

  /// No description provided for @period1M.
  ///
  /// In en, this message translates to:
  /// **'1M'**
  String get period1M;

  /// No description provided for @period3M.
  ///
  /// In en, this message translates to:
  /// **'3M'**
  String get period3M;

  /// No description provided for @period6M.
  ///
  /// In en, this message translates to:
  /// **'6M'**
  String get period6M;

  /// No description provided for @period1Y.
  ///
  /// In en, this message translates to:
  /// **'1Y'**
  String get period1Y;

  /// No description provided for @periodAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get periodAll;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'category'**
  String get categoryLabel;

  /// No description provided for @categoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'categories'**
  String get categoriesLabel;

  /// No description provided for @transactionSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'{type} saved  •  {amount}'**
  String transactionSavedMessage(String type, String amount);

  /// No description provided for @tooltipSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tooltipSettings;

  /// No description provided for @tooltipAddAccount.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get tooltipAddAccount;

  /// No description provided for @tooltipRemoveAccount.
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get tooltipRemoveAccount;

  /// No description provided for @accountNameTaken.
  ///
  /// In en, this message translates to:
  /// **'You already have an account with this name and identifier (active or archived). Change the name or identifier.'**
  String get accountNameTaken;

  /// No description provided for @groupDescPersonal.
  ///
  /// In en, this message translates to:
  /// **'Your own wallets & bank accounts'**
  String get groupDescPersonal;

  /// No description provided for @groupDescIndividuals.
  ///
  /// In en, this message translates to:
  /// **'Family, friends, individuals'**
  String get groupDescIndividuals;

  /// No description provided for @groupDescEntities.
  ///
  /// In en, this message translates to:
  /// **'Entities, utilities, organisations'**
  String get groupDescEntities;

  /// No description provided for @cannotArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot archive yet'**
  String get cannotArchiveTitle;

  /// No description provided for @cannotArchiveBody.
  ///
  /// In en, this message translates to:
  /// **'Archive is only available when the book balance and overdraft limit are both effectively zero.'**
  String get cannotArchiveBody;

  /// No description provided for @cannotArchiveBodyAdjust.
  ///
  /// In en, this message translates to:
  /// **'Archive is only available when the book balance and overdraft limit are both effectively zero. Adjust the ledger or facility first.'**
  String get cannotArchiveBodyAdjust;

  /// No description provided for @archiveAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive account?'**
  String get archiveAccountTitle;

  /// No description provided for @archiveWithPlannedBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 planned transaction references this account.} other{{count} planned transactions reference this account.}} Remove them to keep your plan consistent with an archived account.'**
  String archiveWithPlannedBody(int count);

  /// No description provided for @removeAndArchive.
  ///
  /// In en, this message translates to:
  /// **'Remove planned & archive'**
  String get removeAndArchive;

  /// No description provided for @archiveBody.
  ///
  /// In en, this message translates to:
  /// **'The account will be hidden from Review, Track, and Plan pickers. You can restore it from Settings.'**
  String get archiveBody;

  /// No description provided for @archiveAction.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveAction;

  /// No description provided for @archiveInstead.
  ///
  /// In en, this message translates to:
  /// **'Archive instead'**
  String get archiveInstead;

  /// No description provided for @cannotDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete account'**
  String get cannotDeleteTitle;

  /// No description provided for @cannotDeleteBodyShort.
  ///
  /// In en, this message translates to:
  /// **'This account appears in your Track history. Remove or reassign those transactions first, or archive the account if the balance is cleared.'**
  String get cannotDeleteBodyShort;

  /// No description provided for @cannotDeleteBodyHistory.
  ///
  /// In en, this message translates to:
  /// **'This account appears in your Track history. Deleting would break that history—remove or reassign those transactions first.'**
  String get cannotDeleteBodyHistory;

  /// No description provided for @cannotDeleteBodySuggestArchive.
  ///
  /// In en, this message translates to:
  /// **'This account appears in your Track history, so it cannot be deleted. You can archive it instead if the book balance and overdraft are cleared—it will be hidden from lists but history stays intact.'**
  String get cannotDeleteBodySuggestArchive;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBodyPermanent.
  ///
  /// In en, this message translates to:
  /// **'This account will be removed permanently.'**
  String get deleteAccountBodyPermanent;

  /// No description provided for @deleteWithPlannedBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 planned transaction references this account and will also be deleted.} other{{count} planned transactions reference this account and will also be deleted.}}'**
  String deleteWithPlannedBody(int count);

  /// No description provided for @deleteAllAndDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAllAndDelete;

  /// No description provided for @editAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccountTitle;

  /// No description provided for @newAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newAccountTitle;

  /// No description provided for @labelAccountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get labelAccountName;

  /// No description provided for @labelAccountIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Identifier (optional)'**
  String get labelAccountIdentifier;

  /// No description provided for @accountAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Icon & color'**
  String get accountAppearanceSection;

  /// No description provided for @accountPickIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose icon'**
  String get accountPickIcon;

  /// No description provided for @accountPickColor.
  ///
  /// In en, this message translates to:
  /// **'Choose color'**
  String get accountPickColor;

  /// No description provided for @accountIconSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Account icon'**
  String get accountIconSheetTitle;

  /// No description provided for @accountColorSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Account color'**
  String get accountColorSheetTitle;

  /// No description provided for @accountUseInitialLetter.
  ///
  /// In en, this message translates to:
  /// **'Initial letter'**
  String get accountUseInitialLetter;

  /// No description provided for @accountUseDefaultColor.
  ///
  /// In en, this message translates to:
  /// **'Match group'**
  String get accountUseDefaultColor;

  /// No description provided for @labelRealBalance.
  ///
  /// In en, this message translates to:
  /// **'Real balance'**
  String get labelRealBalance;

  /// No description provided for @labelOverdraftLimit.
  ///
  /// In en, this message translates to:
  /// **'Overdraft / advance limit'**
  String get labelOverdraftLimit;

  /// No description provided for @labelCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get labelCurrency;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @addAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccountAction;

  /// No description provided for @removeAccountSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get removeAccountSheetTitle;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanently;

  /// No description provided for @deletePermanentlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only possible when this account is not used in Track. Planned items can be removed as part of delete.'**
  String get deletePermanentlySubtitle;

  /// No description provided for @archiveOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide from Review and pickers. Restore anytime from Settings. Requires zero balance and overdraft.'**
  String get archiveOptionSubtitle;

  /// No description provided for @archivedBannerText.
  ///
  /// In en, this message translates to:
  /// **'This account is archived. It stays in your data but is hidden from lists and pickers.'**
  String get archivedBannerText;

  /// No description provided for @balanceAdjustedTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance adjusted in Track'**
  String get balanceAdjustedTitle;

  /// No description provided for @balanceAdjustedBody.
  ///
  /// In en, this message translates to:
  /// **'Real balance was updated from {previous} to {current} {symbol}.\n\nA balance adjustment transaction was created in Track (History) to keep the ledger consistent.\n\n• Real balance reflects the actual amount in this account.\n• Check History for the adjustment entry.'**
  String balanceAdjustedBody(String previous, String current, String symbol);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @categoryBalanceAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Balance adjustment'**
  String get categoryBalanceAdjustment;

  /// No description provided for @descriptionBalanceCorrection.
  ///
  /// In en, this message translates to:
  /// **'Balance correction'**
  String get descriptionBalanceCorrection;

  /// No description provided for @descriptionOpeningBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get descriptionOpeningBalance;

  /// No description provided for @statsUncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get statsUncategorized;

  /// No description provided for @statsNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories in the selected periods for comparison.'**
  String get statsNoCategories;

  /// No description provided for @statsNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get statsNoTransactions;

  /// No description provided for @statsSpendingInCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending in this category'**
  String get statsSpendingInCategory;

  /// No description provided for @statsIncomeInCategory.
  ///
  /// In en, this message translates to:
  /// **'Income in this category'**
  String get statsIncomeInCategory;

  /// No description provided for @statsDifference.
  ///
  /// In en, this message translates to:
  /// **'Difference (B vs A): '**
  String get statsDifference;

  /// No description provided for @statsNoExpensesMonth.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month'**
  String get statsNoExpensesMonth;

  /// No description provided for @statsNoExpensesAll.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded'**
  String get statsNoExpensesAll;

  /// No description provided for @statsNoExpensesPeriod.
  ///
  /// In en, this message translates to:
  /// **'No expenses in the last {period}'**
  String statsNoExpensesPeriod(String period);

  /// No description provided for @statsTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get statsTotalSpent;

  /// No description provided for @statsNoExpensesThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'No expenses in this period'**
  String get statsNoExpensesThisPeriod;

  /// No description provided for @statsNoIncomeMonth.
  ///
  /// In en, this message translates to:
  /// **'No income this month'**
  String get statsNoIncomeMonth;

  /// No description provided for @statsNoIncomeAll.
  ///
  /// In en, this message translates to:
  /// **'No income recorded'**
  String get statsNoIncomeAll;

  /// No description provided for @statsNoIncomePeriod.
  ///
  /// In en, this message translates to:
  /// **'No income in the last {period}'**
  String statsNoIncomePeriod(String period);

  /// No description provided for @statsTotalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total received'**
  String get statsTotalReceived;

  /// No description provided for @statsNoIncomeThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'No income in this period'**
  String get statsNoIncomeThisPeriod;

  /// No description provided for @catSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get catSalary;

  /// No description provided for @catFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get catFreelance;

  /// No description provided for @catConsulting.
  ///
  /// In en, this message translates to:
  /// **'Consulting'**
  String get catConsulting;

  /// No description provided for @catGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get catGift;

  /// No description provided for @catRental.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get catRental;

  /// No description provided for @catDividends.
  ///
  /// In en, this message translates to:
  /// **'Dividends'**
  String get catDividends;

  /// No description provided for @catRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get catRefund;

  /// No description provided for @catBonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get catBonus;

  /// No description provided for @catInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get catInterest;

  /// No description provided for @catSideHustle.
  ///
  /// In en, this message translates to:
  /// **'Side hustle'**
  String get catSideHustle;

  /// No description provided for @catSaleOfGoods.
  ///
  /// In en, this message translates to:
  /// **'Sale of goods'**
  String get catSaleOfGoods;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @catGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get catGroceries;

  /// No description provided for @catDining.
  ///
  /// In en, this message translates to:
  /// **'Dining'**
  String get catDining;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get catUtilities;

  /// No description provided for @catHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get catHousing;

  /// No description provided for @catHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get catHealthcare;

  /// No description provided for @catEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get catEntertainment;

  /// No description provided for @catShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get catTravel;

  /// No description provided for @catEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get catEducation;

  /// No description provided for @catSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get catSubscriptions;

  /// No description provided for @catInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get catInsurance;

  /// No description provided for @catFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get catFuel;

  /// No description provided for @catGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get catGym;

  /// No description provided for @catPets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get catPets;

  /// No description provided for @catKids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get catKids;

  /// No description provided for @catCharity.
  ///
  /// In en, this message translates to:
  /// **'Charity'**
  String get catCharity;

  /// No description provided for @catCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get catCoffee;

  /// No description provided for @catGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get catGifts;

  /// No description provided for @semanticsProjectionDate.
  ///
  /// In en, this message translates to:
  /// **'Projection date {date}. Double tap to choose date'**
  String semanticsProjectionDate(String date);

  /// No description provided for @semanticsProjectedBalance.
  ///
  /// In en, this message translates to:
  /// **'Projected personal balance {amount}'**
  String semanticsProjectedBalance(String amount);

  /// No description provided for @statsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get statsEmptyTitle;

  /// No description provided for @statsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your spending statistics will appear here'**
  String get statsEmptySubtitle;

  /// No description provided for @semanticsShowProjections.
  ///
  /// In en, this message translates to:
  /// **'Show projected balances by account'**
  String get semanticsShowProjections;

  /// No description provided for @semanticsHideProjections.
  ///
  /// In en, this message translates to:
  /// **'Hide projected balances by account'**
  String get semanticsHideProjections;

  /// No description provided for @semanticsDateAllTime.
  ///
  /// In en, this message translates to:
  /// **'Date: all time — tap to change mode'**
  String get semanticsDateAllTime;

  /// No description provided for @semanticsDateMode.
  ///
  /// In en, this message translates to:
  /// **'Date: {mode} — tap to change mode'**
  String semanticsDateMode(String mode);

  /// No description provided for @semanticsDateThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Date: this month — tap for month, week, year, or all time'**
  String get semanticsDateThisMonth;

  /// No description provided for @semanticsTxTypeCycle.
  ///
  /// In en, this message translates to:
  /// **'Transaction type: cycle all, income, expense, transfer'**
  String get semanticsTxTypeCycle;

  /// No description provided for @semanticsAccountFilter.
  ///
  /// In en, this message translates to:
  /// **'Account filter'**
  String get semanticsAccountFilter;

  /// No description provided for @semanticsAlreadyFiltered.
  ///
  /// In en, this message translates to:
  /// **'Already filtered to this account'**
  String get semanticsAlreadyFiltered;

  /// No description provided for @semanticsCategoryFilter.
  ///
  /// In en, this message translates to:
  /// **'Category filter'**
  String get semanticsCategoryFilter;

  /// No description provided for @semanticsSortToggle.
  ///
  /// In en, this message translates to:
  /// **'Sort: toggle newest or oldest first'**
  String get semanticsSortToggle;

  /// No description provided for @semanticsFiltersDisabled.
  ///
  /// In en, this message translates to:
  /// **'List filters disabled while viewing a future projection date. Clear projections to use filters.'**
  String get semanticsFiltersDisabled;

  /// No description provided for @semanticsFiltersDisabledNeedAccount.
  ///
  /// In en, this message translates to:
  /// **'List filters disabled. Add an account first.'**
  String get semanticsFiltersDisabledNeedAccount;

  /// No description provided for @semanticsFiltersDisabledNeedPlannedTransaction.
  ///
  /// In en, this message translates to:
  /// **'List filters disabled. Add a planned transaction first.'**
  String get semanticsFiltersDisabledNeedPlannedTransaction;

  /// No description provided for @semanticsFiltersDisabledNeedRecordedTransaction.
  ///
  /// In en, this message translates to:
  /// **'List filters disabled. Record a transaction first.'**
  String get semanticsFiltersDisabledNeedRecordedTransaction;

  /// No description provided for @semanticsReviewSectionChipsDisabledNeedAccount.
  ///
  /// In en, this message translates to:
  /// **'Section and currency controls disabled. Add an account first.'**
  String get semanticsReviewSectionChipsDisabledNeedAccount;

  /// No description provided for @semanticsPlanProjectionControlsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Projection date and balance breakdown disabled. Add an account and a planned transaction first.'**
  String get semanticsPlanProjectionControlsDisabled;

  /// No description provided for @semanticsReorderAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Long press, then drag to reorder within this group'**
  String get semanticsReorderAccountHint;

  /// No description provided for @semanticsChartStyle.
  ///
  /// In en, this message translates to:
  /// **'Chart style'**
  String get semanticsChartStyle;

  /// No description provided for @semanticsChartStyleUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Chart style (unavailable in comparison mode)'**
  String get semanticsChartStyleUnavailable;

  /// No description provided for @semanticsPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period: {label}'**
  String semanticsPeriod(String label);

  /// No description provided for @trackSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search description, category, account…'**
  String get trackSearchHint;

  /// No description provided for @trackSearchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get trackSearchClear;

  /// No description provided for @settingsExchangeRatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates'**
  String get settingsExchangeRatesTitle;

  /// No description provided for @settingsExchangeRatesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String settingsExchangeRatesUpdated(String time);

  /// No description provided for @settingsExchangeRatesNeverUpdated.
  ///
  /// In en, this message translates to:
  /// **'Using offline or bundled rates — tap to refresh'**
  String get settingsExchangeRatesNeverUpdated;

  /// No description provided for @settingsExchangeRatesSource.
  ///
  /// In en, this message translates to:
  /// **'ECB'**
  String get settingsExchangeRatesSource;

  /// No description provided for @persistenceErrorReloaded.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save changes. Data was reloaded from storage.'**
  String get persistenceErrorReloaded;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'sr':
      {
        switch (locale.scriptCode) {
          case 'Latn':
            return AppLocalizationsSrLatn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
