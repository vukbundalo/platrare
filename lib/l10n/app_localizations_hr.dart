// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Plan';

  @override
  String get navTrack => 'Staza';

  @override
  String get navReview => 'Pregled';

  @override
  String get cancel => 'Otkazati';

  @override
  String get delete => 'Izbrisati';

  @override
  String get close => 'Zatvoriti';

  @override
  String get add => 'Dodati';

  @override
  String get undo => 'Poništi';

  @override
  String get confirm => 'Potvrdi';

  @override
  String get restore => 'Vratiti';

  @override
  String get heroIn => 'U';

  @override
  String get heroOut => 'Van';

  @override
  String get heroNet => 'Neto';

  @override
  String get heroBalance => 'Ravnoteža';

  @override
  String get realBalance => 'Prava ravnoteža';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Sakrij stanja u karticama sažetka';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Kada je uključeno, iznosi u Planu, Praćenju i Pregledu ostaju skriveni dok ne dodirnete ikonu oka na svakoj kartici. Kada je isključeno, stanja su uvijek vidljiva.';

  @override
  String get heroBalancesShow => 'Prikaži stanja';

  @override
  String get heroBalancesHide => 'Sakrij stanja';

  @override
  String get semanticsHeroBalanceHidden => 'Stanje skriveno radi privatnosti';

  @override
  String get heroResetButton => 'Resetiraj';

  @override
  String get fabScrollToTop => 'Na vrh';

  @override
  String get filterAll => 'Sve';

  @override
  String get filterAllAccounts => 'Svi računi';

  @override
  String get filterAllCategories => 'Sve kategorije';

  @override
  String get txLabelIncome => 'PRIHOD';

  @override
  String get txLabelExpense => 'TROŠAK';

  @override
  String get txLabelInvoice => 'DOSTAVNICA';

  @override
  String get txLabelBill => 'RAČUN';

  @override
  String get txLabelAdvance => 'UNAPRIJED';

  @override
  String get txLabelSettlement => 'NASELJE';

  @override
  String get txLabelLoan => 'ZAJAM';

  @override
  String get txLabelCollection => 'KOLEKCIJA';

  @override
  String get txLabelOffset => 'OFFSET';

  @override
  String get txLabelTransfer => 'PRIJENOS';

  @override
  String get txLabelTransaction => 'TRANSAKCIJA';

  @override
  String get repeatNone => 'Bez ponavljanja';

  @override
  String get repeatDaily => 'Dnevno';

  @override
  String get repeatWeekly => 'Tjedni';

  @override
  String get repeatMonthly => 'Mjesečno';

  @override
  String get repeatYearly => 'Godišnje';

  @override
  String get repeatEveryLabel => 'Svaki';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dana',
      one: 'dan',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tjedna',
      one: 'tjedan',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mjeseci',
      one: 'mjesec',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count godine',
      one: 'godina',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Završava';

  @override
  String get repeatEndNever => 'Nikada';

  @override
  String get repeatEndOnDate => 'Na dan';

  @override
  String repeatEndAfterCount(int count) {
    return 'Nakon $count puta';
  }

  @override
  String get repeatEndAfterChoice => 'Nakon određenog broja puta';

  @override
  String get repeatEndPickDate => 'Odaberite datum završetka';

  @override
  String get repeatEndTimes => 'puta';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Svaki $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'do $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count puta';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return 'Preostalo $remaining od $total';
  }

  @override
  String get detailRepeatEvery => 'Ponovite svaki';

  @override
  String get detailEnds => 'Završava';

  @override
  String get detailEndsNever => 'Nikada';

  @override
  String detailEndsOnDate(String date) {
    return 'Na $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Nakon $count puta';
  }

  @override
  String get detailProgress => 'Napredak';

  @override
  String get weekendNoChange => 'Bez promjene';

  @override
  String get weekendFriday => 'Premjestite na petak';

  @override
  String get weekendMonday => 'Premjestiti na ponedjeljak';

  @override
  String weekendQuestion(String day) {
    return 'Ako $day pada vikend?';
  }

  @override
  String get dateToday => 'Danas';

  @override
  String get dateTomorrow => 'Sutra';

  @override
  String get dateYesterday => 'Jučer';

  @override
  String get statsAllTime => 'Sve vrijeme';

  @override
  String get accountGroupPersonal => 'Osobno';

  @override
  String get accountGroupIndividual => 'Pojedinac';

  @override
  String get accountGroupEntity => 'Entitet';

  @override
  String get accountSectionIndividuals => 'Pojedinci';

  @override
  String get accountSectionEntities => 'Entiteti';

  @override
  String get emptyNoTransactionsYet => 'Još nema transakcija';

  @override
  String get emptyNoAccountsYet => 'Još nema računa';

  @override
  String get emptyRecordFirstTransaction =>
      'Dodirnite gumb ispod da biste zabilježili svoju prvu transakciju.';

  @override
  String get emptyAddFirstAccountTx =>
      'Dodajte svoj prvi račun prije snimanja transakcija.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Dodajte svoj prvi račun prije planiranja transakcija.';

  @override
  String get emptyAddFirstAccountReview =>
      'Dodajte svoj prvi račun da biste počeli pratiti svoje financije.';

  @override
  String get emptyAddTransaction => 'Dodaj transakciju';

  @override
  String get emptyAddAccount => 'Dodaj račun';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Još nema osobnih računa';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Osobni računi su vaši vlastiti novčanici i bankovni računi. Dodajte jedan za praćenje svakodnevnih prihoda i potrošnje.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'Još nema pojedinačnih računa';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Individualni računi prate novac s određenim ljudima—zajednički troškovi, zajmovi ili dugovnice. Dodajte račun za svaku osobu s kojom se obračunate.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Još nema računa entiteta';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Računi entiteta namijenjeni su tvrtkama, projektima ili organizacijama. Koristite ih kako biste poslovni novčani tok odvojili od osobnih financija.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Nema transakcija za primijenjene filtre';

  @override
  String get emptyNoTransactionsInHistory => 'Nema transakcija u povijesti';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Nema transakcija za $month';
  }

  @override
  String get emptyNoTransactionsForAccount => 'Nema transakcija za ovaj račun';

  @override
  String get trackTransactionDeleted => 'Transakcija izbrisana';

  @override
  String get trackDeleteTitle => 'Izbrisati transakciju?';

  @override
  String get trackDeleteBody => 'Ovo će poništiti promjene stanja računa.';

  @override
  String get trackTransaction => 'Transakcija';

  @override
  String get planConfirmTitle => 'Potvrditi transakciju?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Ovaj događaj zakazan je za $date. Bit će zabilježeno u povijesti s današnjim datumom ($todayDate). Sljedeće pojavljivanje ostaje na $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Ovo će primijeniti transakciju na vaše stvarno stanje računa i premjestiti je u Povijest.';

  @override
  String get planTransactionConfirmed => 'Transakcija potvrđena i primijenjena';

  @override
  String get planTransactionRemoved => 'Planirana transakcija uklonjena';

  @override
  String get planRepeatingTitle => 'Transakcija koja se ponavlja';

  @override
  String get planRepeatingBody =>
      'Preskočite samo ovaj datum—serija se nastavlja sa sljedećim pojavljivanjem—ili izbrišite svako preostalo pojavljivanje iz svog plana.';

  @override
  String get planDeleteAll => 'Izbriši sve';

  @override
  String get planSkipThisOnly => 'Preskoči samo ovo';

  @override
  String get planOccurrenceSkipped =>
      'Ova pojava preskočena — sljedeća je zakazana';

  @override
  String get planNothingPlanned => 'Za sada ništa planirano';

  @override
  String get planPlanBody => 'Planirajte nadolazeće transakcije.';

  @override
  String get planAddPlan => 'Dodaj plan';

  @override
  String get planNoPlannedForFilters =>
      'Nema planiranih transakcija za primijenjene filtre';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Nema planiranih transakcija u $month';
  }

  @override
  String get planOverdue => 'zakašnjeli';

  @override
  String get planPlannedTransaction => 'Planirana transakcija';

  @override
  String get discardTitle => 'Odbaciti promjene?';

  @override
  String get discardBody =>
      'Imate nespremljene promjene. Bit će izgubljeni ako sada odete.';

  @override
  String get keepEditing => 'Nastavi uređivati';

  @override
  String get discard => 'Odbaci';

  @override
  String get newTransactionTitle => 'Nova transakcija';

  @override
  String get editTransactionTitle => 'Uredi transakciju';

  @override
  String get transactionUpdated => 'Transakcija ažurirana';

  @override
  String get sectionAccounts => 'Računi';

  @override
  String get labelFrom => 'Iz';

  @override
  String get labelTo => 'Do';

  @override
  String get sectionCategory => 'Kategorija';

  @override
  String get sectionAttachments => 'Prilozi';

  @override
  String get labelNote => 'Bilješka';

  @override
  String get hintOptionalDescription => 'Opcijski opis';

  @override
  String get updateTransaction => 'Ažuriraj transakciju';

  @override
  String get saveTransaction => 'Spremi transakciju';

  @override
  String get selectAccount => 'Odaberite račun';

  @override
  String get selectAccountTitle => 'Odaberite Račun';

  @override
  String get noAccountsAvailable => 'Nema dostupnih računa';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Iznos koji je primio $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Unesite točan iznos koji prima odredišni račun. Ovo zaključava korišteni stvarni tečaj.';

  @override
  String get attachTakePhoto => 'Snimite fotografiju';

  @override
  String get attachTakePhotoSub => 'Upotrijebite kameru za snimanje računa';

  @override
  String get attachChooseGallery => 'Odaberite iz galerije';

  @override
  String get attachChooseGallerySub =>
      'Odaberite fotografije iz svoje biblioteke';

  @override
  String get attachBrowseFiles => 'Pregledajte datoteke';

  @override
  String get attachBrowseFilesSub =>
      'Priložite PDF-ove, dokumente ili druge datoteke';

  @override
  String get attachButton => 'Priložiti';

  @override
  String get editPlanTitle => 'Uredi plan';

  @override
  String get planTransactionTitle => 'Plan transakcije';

  @override
  String get tapToSelect => 'Dodirnite za odabir';

  @override
  String get updatePlan => 'Ažuriraj plan';

  @override
  String get addToPlan => 'Dodaj u plan';

  @override
  String get labelRepeat => 'Ponoviti';

  @override
  String get selectPlannedDate => 'Odaberite planirani datum';

  @override
  String get balancesAsOfToday => 'Današnja stanja';

  @override
  String get projectedBalancesForTomorrow => 'Predviđena stanja za sutra';

  @override
  String projectedBalancesForDate(String date) {
    return 'Predviđena stanja za $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name prima ($currency)';
  }

  @override
  String get destHelper =>
      'Procijenjeni odredišni iznos. Točna stopa je zaključana pri potvrdi.';

  @override
  String get descriptionOptional => 'Opis (nije obavezno)';

  @override
  String get detailTransactionTitle => 'Transakcija';

  @override
  String get detailPlannedTitle => 'Planirano';

  @override
  String get detailConfirmTransaction => 'Potvrdite transakciju';

  @override
  String get detailDate => 'Datum';

  @override
  String get detailFrom => 'Iz';

  @override
  String get detailTo => 'Do';

  @override
  String get detailCategory => 'Kategorija';

  @override
  String get detailNote => 'Bilješka';

  @override
  String get detailDestinationAmount => 'Odredišni iznos';

  @override
  String get detailExchangeRate => 'Tečaj';

  @override
  String get detailRepeats => 'Ponavlja se';

  @override
  String get detailDayOfMonth => 'Dan u mjesecu';

  @override
  String get detailWeekends => 'Vikendom';

  @override
  String get detailAttachments => 'Prilozi';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count datoteka',
      one: '1 datoteka',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'postavke';

  @override
  String get settingsSectionDisplay => 'Prikaz';

  @override
  String get settingsSectionLanguage => 'Jezik';

  @override
  String get settingsSectionCategories => 'kategorije';

  @override
  String get settingsSectionAccounts => 'Računi';

  @override
  String get settingsSectionPreferences => 'Postavke';

  @override
  String get settingsSectionManage => 'Upravljati';

  @override
  String get settingsBaseCurrency => 'Domaća valuta';

  @override
  String get settingsSecondaryCurrency => 'Sekundarna valuta';

  @override
  String get settingsCategories => 'kategorije';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount prihod · $expenseCount rashod';
  }

  @override
  String get settingsArchivedAccounts => 'Arhivirani računi';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Trenutačno ništa — arhivirajte iz uređivanja računa kada stanje bude jasno';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count skriveno od Pregleda i birača';
  }

  @override
  String get settingsSectionData => 'Podaci';

  @override
  String get settingsSectionPrivacy => 'Oko';

  @override
  String get settingsPrivacyPolicyTitle => 'Politika privatnosti';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Kako Platrare postupa s vašim podacima.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Devizni tečajevi: aplikacija dohvaća javne tečajeve valuta putem interneta. Vaši računi i transakcije nikada se ne šalju.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Nije moguće učitati pravila privatnosti.';

  @override
  String get settingsPrivacyRetry => 'Pokušajte ponovno';

  @override
  String get settingsSoftwareVersionTitle => 'Verzija softvera';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Otpuštanje, dijagnostika i pravni';

  @override
  String get aboutScreenTitle => 'Oko';

  @override
  String get aboutAppTagline =>
      'Glavna knjiga, tijek novca i planiranje u jednom radnom prostoru.';

  @override
  String get aboutDescriptionBody =>
      'Platrare čuva račune, transakcije i planove na vašem uređaju. Izvezite šifrirane sigurnosne kopije kada trebate kopiju negdje drugdje. Tečajne liste koriste samo podatke javnog tržišta; vaša knjiga nije učitana.';

  @override
  String get aboutVersionLabel => 'Verzija';

  @override
  String get aboutBuildLabel => 'Izgraditi';

  @override
  String get aboutCopySupportDetails => 'Kopiraj detalje podrške';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Otvara cijeli dokument s pravilima unutar aplikacije.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Lokalitet';

  @override
  String get settingsSupportInfoCopied => 'Kopirano u međuspremnik';

  @override
  String get settingsVerifyLedger => 'Provjerite podatke';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Provjerite odgovaraju li stanja računa vašoj povijesti transakcija';

  @override
  String get settingsDataExportTitle => 'Izvoz sigurnosne kopije';

  @override
  String get settingsDataExportSubtitle =>
      'Spremite kao .zip ili šifrirani .platrare sa svim podacima i privicima';

  @override
  String get settingsDataImportTitle => 'Vrati iz sigurnosne kopije';

  @override
  String get settingsDataImportSubtitle =>
      'Zamijenite trenutne podatke iz sigurnosne kopije Platrare .zip ili .platrare';

  @override
  String get backupExportDialogTitle => 'Zaštitite ovu sigurnosnu kopiju';

  @override
  String get backupExportDialogBody =>
      'Preporuča se snažna zaporka, posebno ako datoteku pohranjujete u oblak. Za uvoz vam je potrebna ista lozinka.';

  @override
  String get backupExportPasswordLabel => 'Lozinka';

  @override
  String get backupExportPasswordConfirmLabel => 'Potvrdite lozinku';

  @override
  String get backupExportPasswordMismatch => 'Lozinke se ne podudaraju';

  @override
  String get backupExportPasswordEmpty =>
      'U nastavku unesite odgovarajuću lozinku ili izvezite bez enkripcije.';

  @override
  String get backupExportPasswordTooShort =>
      'Lozinka mora imati najmanje 8 znakova.';

  @override
  String get backupExportSaveToDevice => 'Spremi na uređaj';

  @override
  String get backupExportShareToCloud => 'Dijeli (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Izvoz bez enkripcije';

  @override
  String get backupExportSkipWarningTitle => 'Izvoz bez enkripcije?';

  @override
  String get backupExportSkipWarningBody =>
      'Svatko tko ima pristup datoteci može čitati vaše podatke. Koristite ovo samo za lokalne kopije koje kontrolirate.';

  @override
  String get backupExportSkipWarningConfirm => 'Izvoz nekriptiran';

  @override
  String get backupImportPasswordTitle => 'Šifrirana sigurnosna kopija';

  @override
  String get backupImportPasswordBody =>
      'Unesite lozinku koju ste koristili prilikom izvoza.';

  @override
  String get backupImportPasswordLabel => 'Lozinka';

  @override
  String get backupImportPreviewTitle => 'Sažetak sigurnosne kopije';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Verzija aplikacije: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Izvezeno: $date';
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
    return '$accounts računi · $transactions transakcije · $planned planirane · $attachments datoteke privitka · $income kategorije prihoda · $expense kategorije rashoda';
  }

  @override
  String get backupImportPreviewContinue => 'Nastaviti';

  @override
  String get settingsBackupWrongPassword => 'Pogrešna lozinka';

  @override
  String get settingsBackupChecksumMismatch =>
      'Provjera integriteta sigurnosne kopije nije uspjela';

  @override
  String get settingsBackupCorruptFile =>
      'Nevažeća ili oštećena datoteka sigurnosne kopije';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Sigurnosna kopija treba noviju verziju aplikacije';

  @override
  String get settingsDataImportConfirmTitle => 'Zamijeniti trenutne podatke?';

  @override
  String get settingsDataImportConfirmBody =>
      'Ovo će zamijeniti vaše tekuće račune, transakcije, planirane transakcije, kategorije i uvezene privitke sadržajem odabrane sigurnosne kopije. Ova se radnja ne može poništiti.';

  @override
  String get settingsDataImportConfirmAction => 'Zamijeni podatke';

  @override
  String get settingsDataImportDone => 'Podaci su uspješno vraćeni';

  @override
  String get settingsDataImportInvalidFile =>
      'Ova datoteka nije valjana Platrare sigurnosna kopija';

  @override
  String get settingsDataImportFailed => 'Uvoz nije uspio';

  @override
  String get settingsDataExportDoneTitle => 'Sigurnosna kopija je izvezena';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Sigurnosna kopija spremljena na:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Otvori datoteku';

  @override
  String get settingsDataExportFailed => 'Izvoz nije uspio';

  @override
  String get ledgerVerifyDialogTitle => 'Provjera glavne knjige';

  @override
  String get ledgerVerifyAllMatch => 'Svi računi odgovaraju.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Neusklađenosti';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nPohranjeno: $stored\nRepriza: $replayed\nRazlika: $diff';
  }

  @override
  String get settingsLanguage => 'Jezik aplikacije';

  @override
  String get settingsLanguageSubtitleSystem => 'Slijede postavke sustava';

  @override
  String get settingsLanguageSubtitleEnglish => 'engleski';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'srpski (latinica)';

  @override
  String get settingsLanguagePickerTitle => 'Jezik aplikacije';

  @override
  String get settingsLanguageOptionSystem => 'Zadana vrijednost sustava';

  @override
  String get settingsLanguageOptionEnglish => 'engleski';

  @override
  String get settingsLanguageOptionSerbianLatin => 'srpski (latinica)';

  @override
  String get settingsSectionAppearance => 'Izgled';

  @override
  String get settingsSectionSecurity => 'Sigurnost';

  @override
  String get settingsSecurityEnableLock => 'Zaključaj aplikaciju pri otvaranju';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Zahtijevaj biometrijsko otključavanje ili PIN kada se aplikacija otvori';

  @override
  String get settingsSecuritySetPin => 'Postavite PIN';

  @override
  String get settingsSecurityChangePin => 'Promjena PIN-a';

  @override
  String get settingsSecurityPinSubtitle =>
      'Koristite PIN kao zamjenu ako biometrijski podaci nisu dostupni';

  @override
  String get settingsSecurityRemovePin => 'Ukloni PIN';

  @override
  String get securitySetPinTitle => 'Postavite PIN aplikacije';

  @override
  String get securityPinLabel => 'PIN kod';

  @override
  String get securityConfirmPinLabel => 'Potvrdite PIN kod';

  @override
  String get securityPinMustBe4Digits => 'PIN mora imati najmanje 4 znamenke';

  @override
  String get securityPinMismatch => 'PIN kodovi se ne podudaraju';

  @override
  String get securityRemovePinTitle => 'Ukloniti PIN?';

  @override
  String get securityRemovePinBody =>
      'Biometrijsko otključavanje i dalje se može koristiti ako je dostupno.';

  @override
  String get securityUnlockTitle => 'Aplikacija zaključana';

  @override
  String get securityUnlockSubtitle =>
      'Otključajte pomoću Face ID-a, otiska prsta ili PIN-a.';

  @override
  String get securityUnlockWithPin => 'Otključajte PIN-om';

  @override
  String get securityTryBiometric => 'Isprobajte biometrijsko otključavanje';

  @override
  String get securityPinIncorrect => 'Netočan PIN, pokušajte ponovno';

  @override
  String get securityBiometricReason =>
      'Autentificirajte se da biste otvorili svoju aplikaciju';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitleSystem => 'Slijede postavke sustava';

  @override
  String get settingsThemeSubtitleLight => 'Svjetlo';

  @override
  String get settingsThemeSubtitleDark => 'tamno';

  @override
  String get settingsThemePickerTitle => 'Tema';

  @override
  String get settingsThemeOptionSystem => 'Zadana vrijednost sustava';

  @override
  String get settingsThemeOptionLight => 'Svjetlo';

  @override
  String get settingsThemeOptionDark => 'tamno';

  @override
  String get archivedAccountsTitle => 'Arhivirani računi';

  @override
  String get archivedAccountsEmptyTitle => 'Nema arhiviranih računa';

  @override
  String get archivedAccountsEmptyBody =>
      'Knjigovodstveno stanje i prekoračenje moraju biti nula. Arhiviraj iz opcija računa u pregledu.';

  @override
  String get categoriesTitle => 'kategorije';

  @override
  String get newCategoryTitle => 'Nova kategorija';

  @override
  String get categoryNameLabel => 'Naziv kategorije';

  @override
  String get deleteCategoryTitle => 'Izbrisati kategoriju?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" bit će uklonjen s popisa.';
  }

  @override
  String get categoryIncome => 'Prihod';

  @override
  String get categoryExpense => 'Trošak';

  @override
  String get categoryAdd => 'Dodati';

  @override
  String get searchCurrencies => 'Traži valute…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1Y';

  @override
  String get periodAll => 'SVE';

  @override
  String get categoryLabel => 'kategorija';

  @override
  String get categoriesLabel => 'kategorije';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type spremljeno • $amount';
  }

  @override
  String get tooltipSettings => 'postavke';

  @override
  String get tooltipAddAccount => 'Dodaj račun';

  @override
  String get tooltipRemoveAccount => 'Ukloni račun';

  @override
  String get accountNameTaken =>
      'Već imate račun s ovim imenom i identifikatorom (aktivan ili arhiviran). Promijenite ime ili identifikator.';

  @override
  String get groupDescPersonal => 'Vaši vlastiti novčanici i bankovni računi';

  @override
  String get groupDescIndividuals => 'Obitelj, prijatelji, pojedinci';

  @override
  String get groupDescEntities => 'Subjekti, komunalna poduzeća, organizacije';

  @override
  String get cannotArchiveTitle => 'Još nije moguće arhivirati';

  @override
  String get cannotArchiveBody =>
      'Arhiva je dostupna samo kada su knjižno stanje i ograničenje prekoračenja efektivno jednaki nuli.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Arhiva je dostupna samo kada su knjižno stanje i ograničenje prekoračenja efektivno jednaki nuli. Najprije namjestite glavnu knjigu ili uređaj.';

  @override
  String get archiveAccountTitle => 'Arhivirati račun?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planiranih transakcija referencira ovaj račun.',
      one: '1 planirana transakcija referencira ovaj račun.',
    );
    return '$_temp0 Uklonite ih kako bi plan bio usklađen s arhiviranim računom.';
  }

  @override
  String get removeAndArchive => 'Ukloni planirano i arhiviraj';

  @override
  String get archiveBody =>
      'Račun će biti skriven od birača pregleda, praćenja i plana. Možete ga vratiti u postavkama.';

  @override
  String get archiveAction => 'Arhiva';

  @override
  String get archiveInstead => 'Umjesto toga arhivirajte';

  @override
  String get cannotDeleteTitle => 'Nije moguće izbrisati račun';

  @override
  String get cannotDeleteBodyShort =>
      'Ovaj se račun pojavljuje u vašoj povijesti staze. Prvo uklonite ili ponovno dodijelite te transakcije ili arhivirajte račun ako je stanje izbrisano.';

  @override
  String get cannotDeleteBodyHistory =>
      'Ovaj se račun pojavljuje u vašoj povijesti staze. Brisanje bi prekinulo tu povijest - prvo uklonite ili ponovno dodijelite te transakcije.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Ovaj se račun pojavljuje u vašoj povijesti staze, pa se ne može izbrisati. Umjesto toga možete ga arhivirati ako su knjigovodstveno stanje i prekoračenje izbrisani—bit će skriven s popisa, ali povijest ostaje netaknuta.';

  @override
  String get deleteAccountTitle => 'Izbrisati račun?';

  @override
  String get deleteAccountBodyPermanent =>
      'Ovaj će račun biti trajno uklonjen.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count planiranih transakcija referencira ovaj račun i bit će obrisane.',
      one: '1 planirana transakcija referencira ovaj račun i bit će obrisana.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Izbriši sve';

  @override
  String get editAccountTitle => 'Uredi račun';

  @override
  String get newAccountTitle => 'Novi račun';

  @override
  String get labelAccountName => 'Naziv računa';

  @override
  String get labelAccountIdentifier => 'Identifikator (neobavezno)';

  @override
  String get accountAppearanceSection => 'Ikona i boja';

  @override
  String get accountPickIcon => 'Odaberite ikonu';

  @override
  String get accountPickColor => 'Odaberite boju';

  @override
  String get accountIconSheetTitle => 'Ikona računa';

  @override
  String get accountColorSheetTitle => 'Boja računa';

  @override
  String get accountUseInitialLetter => 'Početno slovo';

  @override
  String get accountUseDefaultColor => 'Skupina podudaranja';

  @override
  String get labelRealBalance => 'Prava ravnoteža';

  @override
  String get labelOverdraftLimit => 'Ograničenje prekoračenja / akontacije';

  @override
  String get labelCurrency => 'Valuta';

  @override
  String get saveChanges => 'Spremi promjene';

  @override
  String get addAccountAction => 'Dodaj račun';

  @override
  String get removeAccountSheetTitle => 'Ukloni račun';

  @override
  String get deletePermanently => 'Izbriši trajno';

  @override
  String get deletePermanentlySubtitle =>
      'Moguće samo kada se ovaj račun ne koristi u Tracku. Planirane stavke mogu se ukloniti kao dio brisanja.';

  @override
  String get archiveOptionSubtitle =>
      'Sakrij iz Pregleda i birača. Vratite bilo kada iz postavki. Zahtijeva nulti saldo i prekoračenje.';

  @override
  String get archivedBannerText =>
      'Ovaj račun je arhiviran. Ostaje u vašim podacima, ali je skriven od popisa i birača.';

  @override
  String get balanceAdjustedTitle => 'Ravnoteža podešena u Tracku';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Stvarni saldo je ažuriran sa $previous na $current $symbol.\n\nTransakcija prilagodbe stanja stvorena je u Track (History) kako bi glavna knjiga bila dosljedna.\n\n• Stvarno stanje odražava stvarni iznos na ovom računu.\n• Provjerite povijest za unos podešavanja.';
  }

  @override
  String get ok => 'U REDU';

  @override
  String get categoryBalanceAdjustment => 'Podešavanje ravnoteže';

  @override
  String get descriptionBalanceCorrection => 'Korekcija ravnoteže';

  @override
  String get descriptionOpeningBalance => 'Početno stanje';

  @override
  String get reviewStatsModeStatistics => 'Statistika';

  @override
  String get reviewStatsModeComparison => 'Usporedba';

  @override
  String get statsUncategorized => 'Nekategorizirano';

  @override
  String get statsNoCategories =>
      'Nema kategorija u odabranim razdobljima za usporedbu.';

  @override
  String get statsNoTransactions => 'Nema transakcija';

  @override
  String get statsSpendingInCategory => 'Potrošnja u ovoj kategoriji';

  @override
  String get statsIncomeInCategory => 'Prihod u ovoj kategoriji';

  @override
  String get statsDifference => 'Razlika (B naspram A):';

  @override
  String get statsNoExpensesMonth => 'Ovaj mjesec nema troškova';

  @override
  String get statsNoExpensesAll => 'Nema evidentiranih troškova';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Nema troškova u prošlom $period';
  }

  @override
  String get statsTotalSpent => 'Ukupno potrošeno';

  @override
  String get statsNoExpensesThisPeriod => 'Nema troškova u ovom razdoblju';

  @override
  String get statsNoIncomeMonth => 'Ovaj mjesec nema prihoda';

  @override
  String get statsNoIncomeAll => 'Nema evidentiranih prihoda';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Nema prihoda u posljednjem $period';
  }

  @override
  String get statsTotalReceived => 'Ukupno primljeno';

  @override
  String get statsNoIncomeThisPeriod => 'Nema prihoda u ovom razdoblju';

  @override
  String get catSalary => 'Plaća';

  @override
  String get catFreelance => 'Honorarac';

  @override
  String get catConsulting => 'Savjetovanje';

  @override
  String get catGift => 'Dar';

  @override
  String get catRental => 'Iznajmljivanje';

  @override
  String get catDividends => 'Dividende';

  @override
  String get catRefund => 'Povrat novca';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catInterest => 'Interes';

  @override
  String get catSideHustle => 'Gužva sa strane';

  @override
  String get catSaleOfGoods => 'Prodaja robe';

  @override
  String get catOther => 'ostalo';

  @override
  String get catGroceries => 'Namirnice';

  @override
  String get catDining => 'Blagovaonica';

  @override
  String get catTransport => 'Prijevoz';

  @override
  String get catUtilities => 'Komunalije';

  @override
  String get catHousing => 'Kućište';

  @override
  String get catHealthcare => 'zdravstvo';

  @override
  String get catEntertainment => 'Zabava';

  @override
  String get catShopping => 'Kupovina';

  @override
  String get catTravel => 'Putovati';

  @override
  String get catEducation => 'Obrazovanje';

  @override
  String get catSubscriptions => 'Pretplate';

  @override
  String get catInsurance => 'Osiguranje';

  @override
  String get catFuel => 'Gorivo';

  @override
  String get catGym => 'teretana';

  @override
  String get catPets => 'Kućni ljubimci';

  @override
  String get catKids => 'djeca';

  @override
  String get catCharity => 'milosrđe';

  @override
  String get catCoffee => 'Kava';

  @override
  String get catGifts => 'Pokloni';

  @override
  String semanticsProjectionDate(String date) {
    return 'Datum projekcije $date. Dodirnite dvaput za odabir datuma';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Predviđena osobna ravnoteža $amount';
  }

  @override
  String get statsEmptyTitle => 'Još nema transakcija';

  @override
  String get statsEmptySubtitle =>
      'Nema podataka o potrošnji za odabrani raspon.';

  @override
  String get semanticsShowProjections => 'Prikaži predviđena stanja po računu';

  @override
  String get semanticsHideProjections => 'Sakrij predviđena stanja po računu';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Show account balances for this day';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Hide account balances for this day';

  @override
  String get semanticsDateAllTime =>
      'Datum: cijelo vrijeme — dodirnite za promjenu načina';

  @override
  String semanticsDateMode(String mode) {
    return 'Datum: $mode — dodirnite za promjenu načina';
  }

  @override
  String get semanticsDateThisMonth =>
      'Datum: ovaj mjesec — dodirnite za mjesec, tjedan, godinu ili cijelo vrijeme';

  @override
  String get semanticsTxTypeCycle =>
      'Vrsta transakcije: ciklus sve, prihod, rashod, prijenos';

  @override
  String get semanticsAccountFilter => 'Filtar računa';

  @override
  String get semanticsAlreadyFiltered => 'Već je filtriran na ovaj račun';

  @override
  String get semanticsCategoryFilter => 'Filter kategorije';

  @override
  String get semanticsSortToggle =>
      'Sortiraj: izmjeni prvo najnovije ili najstarije';

  @override
  String get semanticsFiltersDisabled =>
      'Filtri popisa onemogućeni su tijekom pregleda budućeg datuma projekcije. Očistite projekcije za korištenje filtara.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Filtri popisa onemogućeni. Najprije dodajte račun.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Filtri popisa onemogućeni. Prvo dodajte planiranu transakciju.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Filtri popisa onemogućeni. Najprije snimite transakciju.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Kontrole sekcija i valuta onemogućene. Najprije dodajte račun.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Datum projekcije i raščlamba stanja onemogućeni. Prvo dodajte račun i planiranu transakciju.';

  @override
  String get semanticsReorderAccountHint =>
      'Dugo pritisnite, a zatim povucite za promjenu redoslijeda unutar ove grupe';

  @override
  String get semanticsChartStyle => 'Stil grafikona';

  @override
  String get semanticsChartStyleUnavailable =>
      'Stil grafikona (nije dostupno u načinu usporedbe)';

  @override
  String semanticsPeriod(String label) {
    return 'Razdoblje: $label';
  }

  @override
  String get trackSearchHint => 'Pretraži opis, kategoriju, račun…';

  @override
  String get trackSearchClear => 'Očisti pretragu';

  @override
  String get settingsExchangeRatesTitle => 'Tečajna lista';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Zadnje ažuriranje: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Korištenje izvanmrežnih ili skupnih cijena — dodirnite za osvježavanje';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Tečajna lista ažurirana';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Nije moguće ažurirati tečajeve. Provjerite vezu.';

  @override
  String get settingsClearData => 'Obriši podatke';

  @override
  String get settingsClearDataSubtitle => 'Trajno uklonite odabrane podatke';

  @override
  String get clearDataTitle => 'Obriši podatke';

  @override
  String get clearDataTransactions => 'Povijest transakcija';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transakcije · stanje računa resetirano na nulu';
  }

  @override
  String get clearDataPlanned => 'Planirane transakcije';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count planirani predmeti';
  }

  @override
  String get clearDataAccounts => 'Računi';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count računi · također briše povijest i plan';
  }

  @override
  String get clearDataCategories => 'kategorije';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count kategorije · zamijenjene sa zadanim';
  }

  @override
  String get clearDataPreferences => 'Postavke';

  @override
  String get clearDataPreferencesSubtitle =>
      'Vratite valutu, temu i jezik na zadane vrijednosti';

  @override
  String get clearDataSecurity => 'Zaključavanje aplikacije i PIN';

  @override
  String get clearDataSecuritySubtitle =>
      'Onemogućite zaključavanje aplikacije i uklonite PIN';

  @override
  String get clearDataConfirmButton => 'Obriši odabrano';

  @override
  String get clearDataConfirmTitle => 'Ovo se ne može poništiti';

  @override
  String get clearDataConfirmBody =>
      'Odabrani podaci bit će trajno izbrisani. Najprije izvezite sigurnosnu kopiju ako vam zatreba kasnije.';

  @override
  String get clearDataTypeConfirm => 'Upišite DELETE za potvrdu';

  @override
  String get clearDataTypeConfirmError => 'Točno upišite DELETE za nastavak';

  @override
  String get clearDataPinTitle => 'Potvrdite PIN-om';

  @override
  String get clearDataPinBody =>
      'Unesite PIN aplikacije da biste odobrili ovu radnju.';

  @override
  String get clearDataPinIncorrect => 'Netočan PIN';

  @override
  String get clearDataDone => 'Odabrani podaci izbrisani';

  @override
  String get autoBackupTitle => 'Automatsko dnevno sigurnosno kopiranje';

  @override
  String autoBackupLastAt(String date) {
    return 'Zadnja sigurnosna kopija $date';
  }

  @override
  String get autoBackupNeverRun => 'Još nema sigurnosne kopije';

  @override
  String get autoBackupShareTitle => 'Spremi u oblak';

  @override
  String get autoBackupShareSubtitle =>
      'Prenesite najnoviju sigurnosnu kopiju na iCloud Drive, Google Drive ili bilo koju aplikaciju';

  @override
  String get autoBackupCloudReminder =>
      'Automatsko sigurnosno kopiranje spremno — spremite ga u oblak za zaštitu izvan uređaja';

  @override
  String get autoBackupCloudReminderAction => 'Podijeli';

  @override
  String get persistenceErrorReloaded =>
      'Nije moguće spremiti promjene. Podaci su ponovno učitani iz pohrane.';
}
