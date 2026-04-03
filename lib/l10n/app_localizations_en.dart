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
  String get archivedAccountsTitle => 'Archived accounts';

  @override
  String get archivedAccountsEmptyTitle => 'No archived accounts';

  @override
  String get archivedAccountsEmptyBody =>
      'When you archive an account from Review, it will appear here. You can restore it anytime.';

  @override
  String get accountGroupPersonal => 'Personal';

  @override
  String get accountGroupIndividual => 'Individual';

  @override
  String get accountGroupEntity => 'Entity';

  @override
  String get restore => 'Restore';
}
