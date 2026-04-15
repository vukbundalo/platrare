// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bosnian (`bs`).
class AppLocalizationsBs extends AppLocalizations {
  AppLocalizationsBs([String locale = 'bs']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Plan';

  @override
  String get navTrack => 'Track';

  @override
  String get navReview => 'Pregled';

  @override
  String get cancel => 'Otkaži';

  @override
  String get delete => 'Izbriši';

  @override
  String get close => 'Zatvori';

  @override
  String get add => 'Dodaj';

  @override
  String get undo => 'Poništi';

  @override
  String get confirm => 'Potvrdi';

  @override
  String get restore => 'Vrati';

  @override
  String get heroIn => 'U';

  @override
  String get heroOut => 'Van';

  @override
  String get heroNet => 'Net';

  @override
  String get heroBalance => 'Balans';

  @override
  String get realBalance => 'Pravi balans';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Sakrij stanja u karticama sažetka';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Kada je uključeno, iznosi u Planu, Praćenju i Pregledu ostaju skriveni dok ne dodirnete ikonu oka na svakom tabu. Kada je isključeno, stanja su uvijek vidljiva.';

  @override
  String get heroBalancesShow => 'Prikaži stanja';

  @override
  String get heroBalancesHide => 'Sakrij stanja';

  @override
  String get semanticsHeroBalanceHidden => 'Stanje skriveno radi privatnosti';

  @override
  String get heroResetButton => 'Reset';

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
  String get txLabelExpense => 'EXPENSE';

  @override
  String get txLabelInvoice => 'FAKTURA';

  @override
  String get txLabelBill => 'BILL';

  @override
  String get txLabelAdvance => 'ADVANCE';

  @override
  String get txLabelSettlement => 'NASELJE';

  @override
  String get txLabelLoan => 'LOAN';

  @override
  String get txLabelCollection => 'COLLECTION';

  @override
  String get txLabelOffset => 'OFFSET';

  @override
  String get txLabelTransfer => 'TRANSFER';

  @override
  String get txLabelTransaction => 'TRANSAKCIJA';

  @override
  String get repeatNone => 'Nema ponavljanja';

  @override
  String get repeatDaily => 'Dnevno';

  @override
  String get repeatWeekly => 'Weekly';

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
      other: '$count sedmice',
      one: 'sedmicu',
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
      one: 'godinu',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Završava';

  @override
  String get repeatEndNever => 'Nikad';

  @override
  String get repeatEndOnDate => 'Na datum';

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
    return '$remaining od $total preostalih';
  }

  @override
  String get detailRepeatEvery => 'Ponovite svaki';

  @override
  String get detailEnds => 'Završava';

  @override
  String get detailEndsNever => 'Nikad';

  @override
  String detailEndsOnDate(String date) {
    return 'Dana $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Nakon $count puta';
  }

  @override
  String get detailProgress => 'Napredak';

  @override
  String get weekendNoChange => 'Nema promjene';

  @override
  String get weekendFriday => 'Prebacite se na petak';

  @override
  String get weekendMonday => 'Pređite na ponedeljak';

  @override
  String weekendQuestion(String day) {
    return 'Ako $day padne na vikend?';
  }

  @override
  String get dateToday => 'Danas';

  @override
  String get dateTomorrow => 'sutra';

  @override
  String get dateYesterday => 'Jučer';

  @override
  String get statsAllTime => 'Sve vreme';

  @override
  String get accountGroupPersonal => 'Personal';

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
      'Dodirnite dugme ispod da snimite svoju prvu transakciju.';

  @override
  String get emptyAddFirstAccountTx =>
      'Dodajte svoj prvi račun prije evidentiranja transakcija.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Dodajte svoj prvi račun prije planiranja transakcija.';

  @override
  String get emptyAddFirstAccountReview =>
      'Dodajte svoj prvi račun da počnete pratiti svoje finansije.';

  @override
  String get emptyAddTransaction => 'Dodaj transakciju';

  @override
  String get emptyAddAccount => 'Dodaj račun';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Još nema ličnih računa';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Lični računi su vaši novčanici i bankovni računi. Dodajte jedan za praćenje svakodnevnih prihoda i potrošnje.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'Još nema pojedinačnih računa';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Individualni računi prate novac sa određenim ljudima – dijeljene troškove, zajmove ili dugove. Dodajte račun za svaku osobu s kojom se obračunavate.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Još nema entitetskih računa';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Računi entiteta su za preduzeća, projekte ili organizacije. Koristite ih da držite poslovni novčani tok odvojen od vaših ličnih finansija.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Nema transakcija za primijenjene filtere';

  @override
  String get emptyNoTransactionsInHistory => 'Nema transakcija u istoriji';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Nema transakcija za $month';
  }

  @override
  String get emptyNoTransactionsForAccount => 'Nema transakcija za ovaj račun';

  @override
  String get trackTransactionDeleted => 'Transakcija je izbrisana';

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
    return 'Ova pojava je zakazana za $date. Biće zabeležen u istoriji sa današnjim datumom ($todayDate). Sljedeće pojavljivanje ostaje $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Ovo će primijeniti transakciju na vaše stvarno stanje na računu i premjestiti je u povijest.';

  @override
  String get planTransactionConfirmed => 'Transakcija potvrđena i primijenjena';

  @override
  String get planTransactionRemoved => 'Planirana transakcija je uklonjena';

  @override
  String get planRepeatingTitle => 'Ponavljanje transakcije';

  @override
  String get planRepeatingBody =>
      'Preskočite samo ovaj datum—serija se nastavlja sljedećim pojavljivanjem—ili izbrišite svaku preostalu pojavu iz svog plana.';

  @override
  String get planDeleteAll => 'Obriši sve';

  @override
  String get planSkipThisOnly => 'Samo ovo preskoči';

  @override
  String get planOccurrenceSkipped =>
      'Ova pojava je preskočena — sljedeća je zakazana';

  @override
  String get planNothingPlanned => 'Za sada ništa nije planirano';

  @override
  String get planPlanBody => 'Planirajte nadolazeće transakcije.';

  @override
  String get planAddPlan => 'Dodaj plan';

  @override
  String get planNoPlannedForFilters =>
      'Nema planiranih transakcija za primijenjene filtere';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Nema planiranih transakcija u $month';
  }

  @override
  String get planOverdue => 'zakasnio';

  @override
  String get planPlannedTransaction => 'Planirana transakcija';

  @override
  String get discardTitle => 'Odbaciti promjene?';

  @override
  String get discardBody =>
      'Imate nesačuvane promjene. Biće izgubljeni ako sada odete.';

  @override
  String get keepEditing => 'Nastavite sa uređivanjem';

  @override
  String get discard => 'Odbaci';

  @override
  String get newTransactionTitle => 'Nova transakcija';

  @override
  String get editTransactionTitle => 'Uredi transakciju';

  @override
  String get transactionUpdated => 'Transakcija je ažurirana';

  @override
  String get sectionAccounts => 'Računi';

  @override
  String get labelFrom => 'Od';

  @override
  String get labelTo => 'To';

  @override
  String get sectionCategory => 'Kategorija';

  @override
  String get sectionAttachments => 'Prilozi';

  @override
  String get labelNote => 'Napomena';

  @override
  String get hintOptionalDescription => 'Opcioni opis';

  @override
  String get updateTransaction => 'Ažuriraj transakciju';

  @override
  String get saveTransaction => 'Sačuvaj transakciju';

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
      'Unesite tačan iznos koji prima odredišni račun. Ovo zaključava stvarni kurs koji se koristi.';

  @override
  String get attachTakePhoto => 'Fotografiraj';

  @override
  String get attachTakePhotoSub => 'Koristite kameru da snimite račun';

  @override
  String get attachChooseGallery => 'Odaberite iz galerije';

  @override
  String get attachChooseGallerySub =>
      'Odaberite fotografije iz svoje biblioteke';

  @override
  String get attachBrowseFiles => 'Pregledaj fajlove';

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
  String get updatePlan => 'Ažurirajte plan';

  @override
  String get addToPlan => 'Dodaj u plan';

  @override
  String get labelRepeat => 'Ponovi';

  @override
  String get selectPlannedDate => 'Odaberite planirani datum';

  @override
  String get balancesAsOfToday => 'Stanje na današnji dan';

  @override
  String get projectedBalancesForTomorrow => 'Predviđeno stanje za sutra';

  @override
  String projectedBalancesForDate(String date) {
    return 'Predviđeno stanje za $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name prima ($currency)';
  }

  @override
  String get destHelper =>
      'Procijenjeni iznos odredišta. Tačna stopa je zaključana prilikom potvrde.';

  @override
  String get descriptionOptional => 'Opis (opcionalno)';

  @override
  String get detailTransactionTitle => 'Transakcija';

  @override
  String get detailPlannedTitle => 'Planirano';

  @override
  String get detailConfirmTransaction => 'Potvrdite transakciju';

  @override
  String get detailDate => 'Datum';

  @override
  String get detailFrom => 'Od';

  @override
  String get detailTo => 'To';

  @override
  String get detailCategory => 'Kategorija';

  @override
  String get detailNote => 'Napomena';

  @override
  String get detailDestinationAmount => 'Odredišni iznos';

  @override
  String get detailExchangeRate => 'Kurs';

  @override
  String get detailRepeats => 'Ponavlja';

  @override
  String get detailDayOfMonth => 'Dan u mjesecu';

  @override
  String get detailWeekends => 'Vikendi';

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
  String get settingsTitle => 'Postavke';

  @override
  String get settingsSectionDisplay => 'Display';

  @override
  String get settingsSectionLanguage => 'Jezik';

  @override
  String get settingsSectionCategories => 'Kategorije';

  @override
  String get settingsSectionAccounts => 'Računi';

  @override
  String get settingsSectionPreferences => 'Preferences';

  @override
  String get settingsSectionManage => 'Upravljaj';

  @override
  String get settingsBaseCurrency => 'Domaća valuta';

  @override
  String get settingsSecondaryCurrency => 'Sekundarna valuta';

  @override
  String get settingsCategories => 'Kategorije';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount prihod · $expenseCount rashod';
  }

  @override
  String get settingsArchivedAccounts => 'Arhivirani nalozi';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Trenutno nema — arhivirajte iz uređivanja računa kada stanje bude jasno';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count skriveno od pregleda i birača';
  }

  @override
  String get settingsSectionData => 'Podaci';

  @override
  String get settingsSectionPrivacy => 'O';

  @override
  String get settingsPrivacyPolicyTitle => 'Politika privatnosti';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Kako Platrare rukuje vašim podacima.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Kursevi: aplikacija preuzima kurseve javnih valuta putem interneta. Vaši računi i transakcije se nikada ne šalju.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Nije moguće učitati politiku privatnosti.';

  @override
  String get settingsPrivacyRetry => 'Pokušajte ponovo';

  @override
  String get settingsSoftwareVersionTitle => 'Verzija softvera';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Izdanje, dijagnostika i legalnost';

  @override
  String get aboutScreenTitle => 'O';

  @override
  String get aboutAppTagline =>
      'Knjiga, novčani tok i planiranje u jednom radnom prostoru.';

  @override
  String get aboutDescriptionBody =>
      'Platrare čuva račune, transakcije i planove na vašem uređaju. Izvezite šifrirane sigurnosne kopije kada vam zatreba kopija na drugom mjestu. Kursevi koriste samo podatke javnog tržišta; vaša knjiga nije učitana.';

  @override
  String get aboutVersionLabel => 'Verzija';

  @override
  String get aboutBuildLabel => 'Build';

  @override
  String get aboutCopySupportDetails => 'Kopirajte detalje podrške';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Otvara cijeli dokument o politici unutar aplikacije.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Locale';

  @override
  String get settingsSupportInfoCopied => 'Kopirano u međuspremnik';

  @override
  String get settingsVerifyLedger => 'Provjeri podatke';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Provjerite da li stanje na računu odgovara vašoj historiji transakcija';

  @override
  String get settingsDataExportTitle => 'Izvezi sigurnosnu kopiju';

  @override
  String get settingsDataExportSubtitle =>
      'Sačuvajte kao .zip ili šifrirani .platrare sa svim podacima i prilozima';

  @override
  String get settingsDataImportTitle => 'Vrati iz sigurnosne kopije';

  @override
  String get settingsDataImportSubtitle =>
      'Zamijenite trenutne podatke iz Platrare .zip ili .platrare sigurnosne kopije';

  @override
  String get backupExportDialogTitle => 'Zaštitite ovu sigurnosnu kopiju';

  @override
  String get backupExportDialogBody =>
      'Preporučuje se jaka lozinka, posebno ako pohranjujete datoteku u oblak. Za uvoz vam je potrebna ista lozinka.';

  @override
  String get backupExportPasswordLabel => 'Lozinka';

  @override
  String get backupExportPasswordConfirmLabel => 'Potvrdite lozinku';

  @override
  String get backupExportPasswordMismatch => 'Lozinke se ne podudaraju';

  @override
  String get backupExportPasswordEmpty =>
      'Unesite odgovarajuću lozinku ili izvezite bez šifriranja ispod.';

  @override
  String get backupExportPasswordTooShort =>
      'Lozinka mora imati najmanje 8 znakova.';

  @override
  String get backupExportSaveToDevice => 'Sačuvaj na uređaj';

  @override
  String get backupExportShareToCloud => 'Dijeli (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Izvoz bez enkripcije';

  @override
  String get backupExportSkipWarningTitle => 'Izvoz bez enkripcije?';

  @override
  String get backupExportSkipWarningBody =>
      'Svako ko ima pristup datoteci može čitati vaše podatke. Koristite ovo samo za lokalne kopije koje kontrolirate.';

  @override
  String get backupExportSkipWarningConfirm => 'Izvoz nešifrovan';

  @override
  String get backupImportPasswordTitle => 'Šifrovana sigurnosna kopija';

  @override
  String get backupImportPasswordBody =>
      'Unesite lozinku koju ste koristili prilikom izvoza.';

  @override
  String get backupImportPasswordLabel => 'Lozinka';

  @override
  String get backupImportPreviewTitle => 'Sažetak rezervne kopije';

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
    return '$accounts računi · $transactions transakcije · $planned planirane · $attachments priložene datoteke · $income kategorije prihoda · $expense kategorije troškova';
  }

  @override
  String get backupImportPreviewContinue => 'Nastavi';

  @override
  String get settingsBackupWrongPassword => 'Pogrešna lozinka';

  @override
  String get settingsBackupChecksumMismatch =>
      'Sigurnosna kopija nije uspjela provjeru integriteta';

  @override
  String get settingsBackupCorruptFile =>
      'Nevažeća ili oštećena datoteka sigurnosne kopije';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Za sigurnosnu kopiju potrebna je novija verzija aplikacije';

  @override
  String get settingsDataImportConfirmTitle => 'Zamijeniti trenutne podatke?';

  @override
  String get settingsDataImportConfirmBody =>
      'Ovo će zamijeniti vaše tekuće račune, transakcije, planirane transakcije, kategorije i uvezene priloge sa sadržajem odabrane sigurnosne kopije. Ova radnja se ne može poništiti.';

  @override
  String get settingsDataImportConfirmAction => 'Zamijenite podatke';

  @override
  String get settingsDataImportDone => 'Podaci su uspješno vraćeni';

  @override
  String get settingsDataImportInvalidFile =>
      'Ova datoteka nije važeća sigurnosna kopija Platrarea';

  @override
  String get settingsDataImportFailed => 'Uvoz nije uspio';

  @override
  String get settingsDataExportDoneTitle => 'Izvezena rezervna kopija';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Sigurnosna kopija sačuvana na:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Otvorite fajl';

  @override
  String get settingsDataExportFailed => 'Izvoz nije uspio';

  @override
  String get ledgerVerifyDialogTitle => 'Verifikacija glavne knjige';

  @override
  String get ledgerVerifyAllMatch => 'Svi računi se poklapaju.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Nepodudarnosti';

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
  String get settingsLanguageSubtitleSystem => 'Slijede postavke sistema';

  @override
  String get settingsLanguageSubtitleEnglish => 'engleski';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'srpski (latinica)';

  @override
  String get settingsLanguagePickerTitle => 'Jezik aplikacije';

  @override
  String get settingsLanguageOptionSystem => 'Zadana postavka sistema';

  @override
  String get settingsLanguageOptionEnglish => 'engleski';

  @override
  String get settingsLanguageOptionSerbianLatin => 'srpski (latinica)';

  @override
  String get settingsSectionAppearance => 'Izgled';

  @override
  String get settingsSectionSecurity => 'Sigurnost';

  @override
  String get settingsSecurityEnableLock =>
      'Zaključajte aplikaciju na otvorenom';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Zahtijevaj biometrijsko otključavanje ili PIN kada se aplikacija otvori';

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
  String get settingsSecuritySetPin => 'Postavite PIN';

  @override
  String get settingsSecurityChangePin => 'Promijenite PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Koristite PIN kao rezervni ako biometrijski nije dostupan';

  @override
  String get settingsSecurityRemovePin => 'Uklonite PIN';

  @override
  String get securitySetPinTitle => 'Postavite PIN za aplikaciju';

  @override
  String get securityPinLabel => 'PIN kod';

  @override
  String get securityConfirmPinLabel => 'Potvrdite PIN kod';

  @override
  String get securityPinMustBe4Digits => 'PIN mora imati najmanje 4 cifre';

  @override
  String get securityPinMismatch => 'PIN kodovi se ne poklapaju';

  @override
  String get securityRemovePinTitle => 'Ukloniti PIN?';

  @override
  String get securityRemovePinBody =>
      'Biometrijsko otključavanje se i dalje može koristiti ako je dostupno.';

  @override
  String get securityUnlockTitle => 'Aplikacija zaključana';

  @override
  String get securityUnlockSubtitle =>
      'Otključajte pomoću Face ID-a, otiska prsta ili PIN-a.';

  @override
  String get securityUnlockWithPin => 'Otključajte PIN-om';

  @override
  String get securityTryBiometric => 'Probajte biometrijsko otključavanje';

  @override
  String get securityPinIncorrect => 'Netačan PIN, pokušajte ponovo';

  @override
  String get securityBiometricReason => 'Autentifikujte da otvorite aplikaciju';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitleSystem => 'Slijede postavke sistema';

  @override
  String get settingsThemeSubtitleLight => 'Light';

  @override
  String get settingsThemeSubtitleDark => 'Dark';

  @override
  String get settingsThemePickerTitle => 'Tema';

  @override
  String get settingsThemeOptionSystem => 'Zadana postavka sistema';

  @override
  String get settingsThemeOptionLight => 'Light';

  @override
  String get settingsThemeOptionDark => 'Dark';

  @override
  String get archivedAccountsTitle => 'Arhivirani nalozi';

  @override
  String get archivedAccountsEmptyTitle => 'Nema arhiviranih naloga';

  @override
  String get archivedAccountsEmptyBody =>
      'Stanje u knjigama i prekoračenje moraju biti nula. Arhivirajte iz opcija naloga u Pregledu.';

  @override
  String get categoriesTitle => 'Kategorije';

  @override
  String get newCategoryTitle => 'Nova kategorija';

  @override
  String get categoryNameLabel => 'Naziv kategorije';

  @override
  String get deleteCategoryTitle => 'Izbrisati kategoriju?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" će biti uklonjeno sa liste.';
  }

  @override
  String get categoryIncome => 'Prihodi';

  @override
  String get categoryExpense => 'Troškovi';

  @override
  String get categoryAdd => 'Dodaj';

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
    return '$type sačuvano • $amount';
  }

  @override
  String get tooltipSettings => 'Postavke';

  @override
  String get tooltipAddAccount => 'Dodaj račun';

  @override
  String get tooltipRemoveAccount => 'Ukloni račun';

  @override
  String get accountNameTaken =>
      'Već imate nalog sa ovim imenom i identifikatorom (aktivan ili arhiviran). Promijenite ime ili identifikator.';

  @override
  String get groupDescPersonal => 'Vaši vlastiti novčanici i bankovni računi';

  @override
  String get groupDescIndividuals => 'Porodica, prijatelji, pojedinci';

  @override
  String get groupDescEntities => 'Subjekti, komunalna preduzeća, organizacije';

  @override
  String get cannotArchiveTitle => 'Još nije moguće arhivirati';

  @override
  String get cannotArchiveBody =>
      'Arhiva je dostupna samo kada su stanje knjige i limit prekoračenja efektivno nula.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Arhiva je dostupna samo kada su stanje knjige i limit prekoračenja efektivno nula. Prvo prilagodite knjigu ili objekat.';

  @override
  String get archiveAccountTitle => 'Arhivirati račun?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planiranih transakcija referišu ovaj račun.',
      one: '1 planirana transakcija referiše ovaj račun.',
    );
    return '$_temp0 Uklonite ih kako bi plan bio usklađen s arhiviranim računom.';
  }

  @override
  String get removeAndArchive => 'Ukloni planirano i arhiviraj';

  @override
  String get archiveBody =>
      'Račun će biti skriven od birača pregleda, praćenja i plana. Možete ga vratiti iz postavki.';

  @override
  String get archiveAction => 'Arhiva';

  @override
  String get archiveInstead => 'Umjesto toga arhivirajte';

  @override
  String get cannotDeleteTitle => 'Nije moguće izbrisati račun';

  @override
  String get cannotDeleteBodyShort =>
      'Ovaj račun se pojavljuje u vašoj historiji praćenja. Najprije uklonite ili ponovno dodijelite te transakcije ili arhivirajte račun ako je stanje izbrisano.';

  @override
  String get cannotDeleteBodyHistory =>
      'Ovaj račun se pojavljuje u vašoj historiji praćenja. Brisanjem bi se prekinula ta istorija – prvo uklonite ili ponovo dodijelite te transakcije.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Ovaj račun se pojavljuje u vašoj historiji praćenja, tako da se ne može izbrisati. Umjesto toga, možete ga arhivirati ako su stanje u knjigama i prekoračenje obrisani – bit će skriven sa lista, ali historija ostaje netaknuta.';

  @override
  String get deleteAccountTitle => 'Izbrisati račun?';

  @override
  String get deleteAccountBodyPermanent =>
      'Ovaj račun će biti trajno uklonjen.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count planiranih transakcija referišu ovaj račun i biće obrisane.',
      one: '1 planirana transakcija referiše ovaj račun i biće obrisana.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Obriši sve';

  @override
  String get editAccountTitle => 'Uredi račun';

  @override
  String get newAccountTitle => 'Novi račun';

  @override
  String get labelAccountName => 'Naziv računa';

  @override
  String get labelAccountIdentifier => 'Identifikator (opcionalno)';

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
  String get searchAccountIcons => 'Search icons by name…';

  @override
  String get accountIconSearchNoMatches => 'No icons match that search.';

  @override
  String get accountUseInitialLetter => 'Početno slovo';

  @override
  String get accountUseDefaultColor => 'Grupa utakmica';

  @override
  String get labelRealBalance => 'Pravi balans';

  @override
  String get labelOverdraftLimit => 'Ograničenje prekoračenja / avansa';

  @override
  String get labelCurrency => 'Valuta';

  @override
  String get saveChanges => 'Sačuvaj promjene';

  @override
  String get addAccountAction => 'Dodaj račun';

  @override
  String get removeAccountSheetTitle => 'Ukloni račun';

  @override
  String get deletePermanently => 'Izbriši trajno';

  @override
  String get deletePermanentlySubtitle =>
      'Moguće samo kada se ovaj račun ne koristi u Track. Planirane stavke se mogu ukloniti kao dio brisanja.';

  @override
  String get archiveOptionSubtitle =>
      'Sakrij od recenzija i birača. Vratite bilo kada iz Postavka. Zahtijeva nulti saldo i prekoračenje.';

  @override
  String get archivedBannerText =>
      'Ovaj račun je arhiviran. Ostaje u vašim podacima, ali je skriven od lista i birača.';

  @override
  String get balanceAdjustedTitle => 'Balans je podešen u Track';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Stvarno stanje je ažurirano sa $previous na $current $symbol.\n\nTransakcija usklađivanja stanja je kreirana u Track (History) kako bi knjiga bila dosljedna.\n\n• Stvarno stanje odražava stvarni iznos na ovom računu.\n• Proverite istoriju za unos podešavanja.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Podešavanje balansa';

  @override
  String get descriptionBalanceCorrection => 'Korekcija ravnoteže';

  @override
  String get descriptionOpeningBalance => 'Početni bilans';

  @override
  String get reviewStatsModeStatistics => 'Statistika';

  @override
  String get reviewStatsModeComparison => 'Poređenje';

  @override
  String get statsUncategorized => 'Uncategorized';

  @override
  String get statsNoCategories =>
      'Nema kategorija u odabranim periodima za poređenje.';

  @override
  String get statsNoTransactions => 'Nema transakcija';

  @override
  String get statsSpendingInCategory => 'Potrošnja u ovoj kategoriji';

  @override
  String get statsIncomeInCategory => 'Prihodi u ovoj kategoriji';

  @override
  String get statsDifference => 'Razlika (B vs A):';

  @override
  String get statsNoExpensesMonth => 'Bez troškova ovog mjeseca';

  @override
  String get statsNoExpensesAll => 'Nema evidentiranih troškova';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Nema troškova u posljednjih $period';
  }

  @override
  String get statsTotalSpent => 'Ukupno potrošeno';

  @override
  String get statsNoExpensesThisPeriod => 'Bez troškova u ovom periodu';

  @override
  String get statsNoIncomeMonth => 'Nema prihoda ovog mjeseca';

  @override
  String get statsNoIncomeAll => 'Nema evidentiranih prihoda';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Nema prihoda u posljednjih $period';
  }

  @override
  String get statsTotalReceived => 'Ukupno primljeno';

  @override
  String get statsNoIncomeThisPeriod => 'Nema prihoda u ovom periodu';

  @override
  String get catSalary => 'Plata';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catConsulting => 'Konsalting';

  @override
  String get catGift => 'Poklon';

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
  String get catSideHustle => 'Side hustle';

  @override
  String get catSaleOfGoods => 'Prodaja robe';

  @override
  String get catOther => 'Ostalo';

  @override
  String get catGroceries => 'Namirnice';

  @override
  String get catDining => 'Dining';

  @override
  String get catTransport => 'Transport';

  @override
  String get catUtilities => 'Komunalne usluge';

  @override
  String get catHousing => 'Stanovanje';

  @override
  String get catHealthcare => 'Zdravstvo';

  @override
  String get catEntertainment => 'Zabava';

  @override
  String get catShopping => 'Kupovina';

  @override
  String get catTravel => 'Putovanja';

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
  String get catKids => 'Djeca';

  @override
  String get catCharity => 'Charity';

  @override
  String get catCoffee => 'Kafa';

  @override
  String get catGifts => 'Pokloni';

  @override
  String semanticsProjectionDate(String date) {
    return 'Datum projekcije $date. Dodirnite dvaput da odaberete datum';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Predviđeni lični bilans $amount';
  }

  @override
  String get statsEmptyTitle => 'Još nema transakcija';

  @override
  String get statsEmptySubtitle =>
      'Nema podataka o potrošnji za odabrani raspon.';

  @override
  String get semanticsShowProjections =>
      'Prikaži projektovana stanja po računu';

  @override
  String get semanticsHideProjections => 'Sakrij projektovana stanja po računu';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Show account balances for this day';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Hide account balances for this day';

  @override
  String get semanticsDateAllTime =>
      'Datum: cijelo vrijeme — dodirnite za promjenu načina rada';

  @override
  String semanticsDateMode(String mode) {
    return 'Datum: $mode — dodirnite za promjenu načina rada';
  }

  @override
  String get semanticsDateThisMonth =>
      'Datum: ovaj mjesec — dodirnite za mjesec, sedmicu, godinu ili cijelo vrijeme';

  @override
  String get semanticsTxTypeCycle =>
      'Vrsta transakcije: ciklus svih, prihod, rashod, transfer';

  @override
  String get semanticsAccountFilter => 'Filter računa';

  @override
  String get semanticsAlreadyFiltered => 'Već filtrirano prema ovom računu';

  @override
  String get semanticsCategoryFilter => 'Filter kategorije';

  @override
  String get semanticsSortToggle =>
      'Sortiraj: prvo uključite najnovije ili najstarije';

  @override
  String get semanticsFiltersDisabled =>
      'Filteri liste su onemogućeni dok gledate budući datum projekcije. Očistite projekcije za korištenje filtera.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Filteri liste su onemogućeni. Prvo dodajte račun.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Filteri liste su onemogućeni. Prvo dodajte planiranu transakciju.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Filteri liste su onemogućeni. Prvo snimite transakciju.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Kontrole odjeljaka i valute su onemogućene. Prvo dodajte račun.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Datum projekcije i kvar bilansa su onemogućeni. Prvo dodajte račun i planiranu transakciju.';

  @override
  String get semanticsReorderAccountHint =>
      'Dugo pritisnite, a zatim prevucite da promijenite redoslijed unutar ove grupe';

  @override
  String get semanticsChartStyle => 'Stil grafikona';

  @override
  String get semanticsChartStyleUnavailable =>
      'Stil grafikona (nedostupno u načinu poređenja)';

  @override
  String semanticsPeriod(String label) {
    return 'Razdoblje: $label';
  }

  @override
  String get trackSearchHint => 'Pretražite opis, kategoriju, račun…';

  @override
  String get trackSearchClear => 'Obriši pretragu';

  @override
  String get settingsExchangeRatesTitle => 'Devizni kursevi';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Posljednje ažurirano: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Korištenje vanmrežnih ili paketnih tarifa — dodirnite za osvježavanje';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Ažurirani kursevi';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Nije moguće ažurirati tečajeve. Provjerite svoju vezu.';

  @override
  String get settingsClearData => 'Obriši podatke';

  @override
  String get settingsClearDataSubtitle => 'Trajno uklonite odabrane podatke';

  @override
  String get clearDataTitle => 'Obriši podatke';

  @override
  String get clearDataTransactions => 'Istorija transakcija';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transakcije · stanje računa resetirano na nulu';
  }

  @override
  String get clearDataPlanned => 'Planirane transakcije';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count planirane stavke';
  }

  @override
  String get clearDataAccounts => 'Računi';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count računi · također briše historiju i plan';
  }

  @override
  String get clearDataCategories => 'Kategorije';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count kategorije · zamijenjene zadanim';
  }

  @override
  String get clearDataPreferences => 'Preferences';

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
      'Odabrani podaci će biti trajno izbrisani. Prvo izvezite sigurnosnu kopiju ako vam zatreba kasnije.';

  @override
  String get clearDataTypeConfirm => 'Unesite DELETE za potvrdu';

  @override
  String get clearDataTypeConfirmError => 'Upišite DELETE tačno da nastavite';

  @override
  String get clearDataPinTitle => 'Potvrdite PIN-om';

  @override
  String get clearDataPinBody =>
      'Unesite PIN aplikacije da autorizujete ovu radnju.';

  @override
  String get clearDataPinIncorrect => 'Netačan PIN';

  @override
  String get clearDataDone => 'Odabrani podaci su obrisani';

  @override
  String get autoBackupTitle => 'Automatski dnevni backup';

  @override
  String autoBackupLastAt(String date) {
    return 'Zadnja sigurnosna kopija $date';
  }

  @override
  String get autoBackupNeverRun => 'Još nema rezervne kopije';

  @override
  String get autoBackupShareTitle => 'Sačuvaj u oblak';

  @override
  String get autoBackupShareSubtitle =>
      'Otpremite najnoviju sigurnosnu kopiju na iCloud Drive, Google Drive ili bilo koju aplikaciju';

  @override
  String get autoBackupCloudReminder =>
      'Automatsko pravljenje rezervne kopije spremno — sačuvajte je u oblaku radi zaštite van uređaja';

  @override
  String get autoBackupCloudReminderAction => 'Dijeli';

  @override
  String get persistenceErrorReloaded =>
      'Nije moguće sačuvati promjene. Podaci su ponovo učitani iz skladišta.';
}
