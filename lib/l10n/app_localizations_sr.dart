// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Plan';

  @override
  String get navTrack => 'Evidencija';

  @override
  String get navReview => 'Pregled';

  @override
  String get settingsTitle => 'Podešavanja';

  @override
  String get settingsSectionDisplay => 'Prikaz';

  @override
  String get settingsSectionLanguage => 'Jezik';

  @override
  String get settingsSectionCategories => 'Kategorije';

  @override
  String get settingsSectionAccounts => 'Računi';

  @override
  String get settingsBaseCurrency => 'Osnovna valuta';

  @override
  String get settingsSecondaryCurrency => 'Sekundarna valuta za prikaz';

  @override
  String get settingsCategories => 'Kategorije';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount prihoda · $expenseCount rashoda';
  }

  @override
  String get settingsArchivedAccounts => 'Arhivirani računi';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Trenutno nema — arhiviraj iz izmene računa kada je saldo nula';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count sakriveno iz pregleda i biranja';
  }

  @override
  String get settingsLanguage => 'Jezik aplikacije';

  @override
  String get settingsLanguageSubtitleSystem => 'Prati podešavanja sistema';

  @override
  String get settingsLanguageSubtitleEnglish => 'Engleski';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Srpski (latinica)';

  @override
  String get settingsLanguagePickerTitle => 'Jezik aplikacije';

  @override
  String get settingsLanguageOptionSystem => 'Podrazumevano (sistem)';

  @override
  String get settingsLanguageOptionEnglish => 'Engleski';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Srpski (latinica)';

  @override
  String get archivedAccountsTitle => 'Arhivirani računi';

  @override
  String get archivedAccountsEmptyTitle => 'Nema arhiviranih računa';

  @override
  String get archivedAccountsEmptyBody =>
      'Kada arhiviraš račun u Pregledu, pojaviće se ovde. Uvek ga možeš vratiti.';

  @override
  String get accountGroupPersonal => 'Lično';

  @override
  String get accountGroupIndividual => 'Pojedinac';

  @override
  String get accountGroupEntity => 'Entitet';

  @override
  String get restore => 'Vrati';
}

/// The translations for Serbian, using the Latin script (`sr_Latn`).
class AppLocalizationsSrLatn extends AppLocalizationsSr {
  AppLocalizationsSrLatn() : super('sr_Latn');

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Plan';

  @override
  String get navTrack => 'Evidencija';

  @override
  String get navReview => 'Pregled';

  @override
  String get settingsTitle => 'Podešavanja';

  @override
  String get settingsSectionDisplay => 'Prikaz';

  @override
  String get settingsSectionLanguage => 'Jezik';

  @override
  String get settingsSectionCategories => 'Kategorije';

  @override
  String get settingsSectionAccounts => 'Računi';

  @override
  String get settingsBaseCurrency => 'Osnovna valuta';

  @override
  String get settingsSecondaryCurrency => 'Sekundarna valuta za prikaz';

  @override
  String get settingsCategories => 'Kategorije';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount prihoda · $expenseCount rashoda';
  }

  @override
  String get settingsArchivedAccounts => 'Arhivirani računi';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Trenutno nema — arhiviraj iz izmene računa kada je saldo nula';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count sakriveno iz pregleda i biranja';
  }

  @override
  String get settingsLanguage => 'Jezik aplikacije';

  @override
  String get settingsLanguageSubtitleSystem => 'Prati podešavanja sistema';

  @override
  String get settingsLanguageSubtitleEnglish => 'Engleski';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Srpski (latinica)';

  @override
  String get settingsLanguagePickerTitle => 'Jezik aplikacije';

  @override
  String get settingsLanguageOptionSystem => 'Podrazumevano (sistem)';

  @override
  String get settingsLanguageOptionEnglish => 'Engleski';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Srpski (latinica)';

  @override
  String get archivedAccountsTitle => 'Arhivirani računi';

  @override
  String get archivedAccountsEmptyTitle => 'Nema arhiviranih računa';

  @override
  String get archivedAccountsEmptyBody =>
      'Kada arhiviraš račun u Pregledu, pojaviće se ovde. Uvek ga možeš vratiti.';

  @override
  String get accountGroupPersonal => 'Lično';

  @override
  String get accountGroupIndividual => 'Pojedinac';

  @override
  String get accountGroupEntity => 'Entitet';

  @override
  String get restore => 'Vrati';
}
