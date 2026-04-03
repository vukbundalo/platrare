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

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;
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
