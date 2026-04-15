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
  String get cancel => 'Otkaži';

  @override
  String get delete => 'Obriši';

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
  String get heroIn => 'Ulaz';

  @override
  String get heroOut => 'Izlaz';

  @override
  String get heroNet => 'Neto';

  @override
  String get heroBalance => 'Stanje';

  @override
  String get realBalance => 'Stvarno stanje';

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
  String get fabScrollToTop => 'Back to top';

  @override
  String get filterAll => 'Sve';

  @override
  String get filterAllAccounts => 'Svi računi';

  @override
  String get filterAllCategories => 'Sve kategorije';

  @override
  String get txLabelIncome => 'PRIHOD';

  @override
  String get txLabelExpense => 'RASHOD';

  @override
  String get txLabelInvoice => 'FAKTURA';

  @override
  String get txLabelBill => 'RAČUN';

  @override
  String get txLabelAdvance => 'AVANS';

  @override
  String get txLabelSettlement => 'PORAVNANJE';

  @override
  String get txLabelLoan => 'ZAJAM';

  @override
  String get txLabelCollection => 'NAPLATA';

  @override
  String get txLabelOffset => 'PREBIJANJE';

  @override
  String get txLabelTransfer => 'PRENOS';

  @override
  String get txLabelTransaction => 'TRANSAKCIJA';

  @override
  String get repeatNone => 'Bez ponavljanja';

  @override
  String get repeatDaily => 'Dnevno';

  @override
  String get repeatWeekly => 'Nedeljno';

  @override
  String get repeatMonthly => 'Mesečno';

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
      few: '$count dana',
      one: 'dan',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nedelja',
      few: '$count nedelje',
      one: 'nedelju',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meseci',
      few: '$count meseca',
      one: 'mesec',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count godina',
      few: '$count godine',
      one: 'godinu',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Završava se';

  @override
  String get repeatEndNever => 'Nikad';

  @override
  String get repeatEndOnDate => 'Na datum';

  @override
  String repeatEndAfterCount(int count) {
    return 'Posle $count puta';
  }

  @override
  String get repeatEndAfterChoice => 'Posle određenog broja puta';

  @override
  String get repeatEndPickDate => 'Izaberite krajnji datum';

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
    return '$remaining od $total preostalo';
  }

  @override
  String get detailRepeatEvery => 'Ponavlja se svaki';

  @override
  String get detailEnds => 'Završava se';

  @override
  String get detailEndsNever => 'Nikad';

  @override
  String detailEndsOnDate(String date) {
    return 'Na $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Posle $count puta';
  }

  @override
  String get detailProgress => 'Napredak';

  @override
  String get weekendNoChange => 'Bez promene';

  @override
  String get weekendFriday => 'Pomeri na petak';

  @override
  String get weekendMonday => 'Pomeri na ponedeljak';

  @override
  String weekendQuestion(String day) {
    return 'Ako $day. padne na vikend?';
  }

  @override
  String get dateToday => 'Danas';

  @override
  String get dateTomorrow => 'Sutra';

  @override
  String get dateYesterday => 'Juče';

  @override
  String get statsAllTime => 'Celo vreme';

  @override
  String get accountGroupPersonal => 'Lično';

  @override
  String get accountGroupIndividual => 'Pojedinac';

  @override
  String get accountGroupEntity => 'Entitet';

  @override
  String get accountSectionIndividuals => 'Pojedinci';

  @override
  String get accountSectionEntities => 'Entiteti';

  @override
  String get emptyNoTransactionsYet => 'Nema transakcija';

  @override
  String get emptyNoAccountsYet => 'Nema računa';

  @override
  String get emptyRecordFirstTransaction =>
      'Dodirnite dugme ispod da zabeležite prvu transakciju.';

  @override
  String get emptyAddFirstAccountTx =>
      'Dodajte prvi račun pre evidentiranja transakcija.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Dodajte prvi račun pre planiranja transakcija.';

  @override
  String get emptyAddFirstAccountReview =>
      'Dodajte prvi račun za praćenje finansija.';

  @override
  String get emptyAddTransaction => 'Dodaj transakciju';

  @override
  String get emptyAddAccount => 'Dodaj račun';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Još nema ličnih računa';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Lični računi su vaši novčanici i bankovni računi. Dodajte jedan da pratite svakodnevni prihod i rashod.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'Još nema računa pojedinaca';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Računi pojedinaca prate novac sa određenim osobama—zajednički troškovi, pozajmice ili dugovanja. Dodajte račun za svaku osobu sa kojom se obračunavate.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Još nema računa entiteta';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Računi entiteta su za firme, projekte ili organizacije. Koristite ih da poslovni novčani tok odvojite od ličnih finansija.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Nema transakcija za primenjene filtere';

  @override
  String get emptyNoTransactionsInHistory => 'Nema transakcija u istoriji';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Nema transakcija za $month';
  }

  @override
  String get emptyNoTransactionsForAccount => 'Nema transakcija za ovaj račun';

  @override
  String get trackTransactionDeleted => 'Transakcija obrisana';

  @override
  String get trackDeleteTitle => 'Obrisati transakciju?';

  @override
  String get trackDeleteBody => 'Ovo će poništiti promene stanja na računima.';

  @override
  String get trackTransaction => 'Transakcija';

  @override
  String get planConfirmTitle => 'Potvrditi transakciju?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Ova stavka je zakazana za $date. Biće evidentirana u Istoriji sa današnjim datumom ($todayDate). Sledeća stavka ostaje na $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Ovo će primeniti transakciju na stvarna stanja računa i premestiti je u Istoriju.';

  @override
  String get planTransactionConfirmed => 'Transakcija potvrđena i primenjena';

  @override
  String get planTransactionRemoved => 'Planirana transakcija uklonjena';

  @override
  String get planRepeatingTitle => 'Transakcija koja se ponavlja';

  @override
  String get planRepeatingBody =>
      'Preskoči samo ovaj datum — serija se nastavlja sa sledećom stavkom — ili obriši sve preostale stavke iz plana.';

  @override
  String get planDeleteAll => 'Obriši sve';

  @override
  String get planSkipThisOnly => 'Preskoči samo ovu';

  @override
  String get planOccurrenceSkipped => 'Stavka preskočena — sledeća zakazana';

  @override
  String get planNothingPlanned => 'Ništa nije planirano';

  @override
  String get planPlanBody => 'Planirajte buduće transakcije.';

  @override
  String get planAddPlan => 'Dodaj plan';

  @override
  String get planNoPlannedForFilters =>
      'Nema planiranih transakcija za primenjene filtere';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Nema planiranih transakcija u $month';
  }

  @override
  String get planOverdue => 'isteklo';

  @override
  String get planPlannedTransaction => 'Planirana transakcija';

  @override
  String get discardTitle => 'Odbaciti izmene?';

  @override
  String get discardBody =>
      'Imate nesačuvane izmene. Biće izgubljene ako napustite ovu stranicu.';

  @override
  String get keepEditing => 'Nastavi uređivanje';

  @override
  String get discard => 'Odbaci';

  @override
  String get newTransactionTitle => 'Nova transakcija';

  @override
  String get editTransactionTitle => 'Izmeni transakciju';

  @override
  String get transactionUpdated => 'Transakcija ažurirana';

  @override
  String get sectionAccounts => 'Računi';

  @override
  String get labelFrom => 'Od';

  @override
  String get labelTo => 'Ka';

  @override
  String get sectionCategory => 'Kategorija';

  @override
  String get sectionAttachments => 'Prilozi';

  @override
  String get labelNote => 'Beleška';

  @override
  String get hintOptionalDescription => 'Opcioni opis';

  @override
  String get updateTransaction => 'Ažuriraj transakciju';

  @override
  String get saveTransaction => 'Sačuvaj transakciju';

  @override
  String get selectAccount => 'Izaberite račun';

  @override
  String get selectAccountTitle => 'Izaberite račun';

  @override
  String get noAccountsAvailable => 'Nema dostupnih računa';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Iznos primljen od $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Unesite tačan iznos koji prima odredišni račun. Ovo zaključava korišćeni kurs.';

  @override
  String get attachTakePhoto => 'Slikaj';

  @override
  String get attachTakePhotoSub => 'Koristite kameru za snimanje računa';

  @override
  String get attachChooseGallery => 'Izaberi iz galerije';

  @override
  String get attachChooseGallerySub => 'Izaberite fotografije iz biblioteke';

  @override
  String get attachBrowseFiles => 'Pregledaj fajlove';

  @override
  String get attachBrowseFilesSub =>
      'Priložite PDF-ove, dokumente ili druge fajlove';

  @override
  String get attachButton => 'Priloži';

  @override
  String get editPlanTitle => 'Izmeni plan';

  @override
  String get planTransactionTitle => 'Planiraj transakciju';

  @override
  String get tapToSelect => 'Dodirnite za izbor';

  @override
  String get updatePlan => 'Ažuriraj plan';

  @override
  String get addToPlan => 'Dodaj u plan';

  @override
  String get labelRepeat => 'Ponavljanje';

  @override
  String get selectPlannedDate => 'Izaberite planirani datum';

  @override
  String get balancesAsOfToday => 'Stanja na današnji dan';

  @override
  String get projectedBalancesForTomorrow => 'Projektovana stanja za sutra';

  @override
  String projectedBalancesForDate(String date) {
    return 'Projektovana stanja za $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name prima ($currency)';
  }

  @override
  String get destHelper =>
      'Procenjeni odredišni iznos. Tačan kurs se zaključava pri potvrdi.';

  @override
  String get descriptionOptional => 'Opis (opciono)';

  @override
  String get detailTransactionTitle => 'Transakcija';

  @override
  String get detailPlannedTitle => 'Planirano';

  @override
  String get detailConfirmTransaction => 'Potvrdi transakciju';

  @override
  String get detailDate => 'Datum';

  @override
  String get detailFrom => 'Od';

  @override
  String get detailTo => 'Ka';

  @override
  String get detailCategory => 'Kategorija';

  @override
  String get detailNote => 'Beleška';

  @override
  String get detailDestinationAmount => 'Odredišni iznos';

  @override
  String get detailExchangeRate => 'Kurs';

  @override
  String get detailRepeats => 'Ponavlja se';

  @override
  String get detailDayOfMonth => 'Dan u mesecu';

  @override
  String get detailWeekends => 'Vikendi';

  @override
  String get detailAttachments => 'Prilozi';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fajlova',
      few: '$count fajla',
      one: '1 fajl',
    );
    return '$_temp0';
  }

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
  String get settingsSectionPreferences => 'Podešavanja';

  @override
  String get settingsSectionManage => 'Upravljanje';

  @override
  String get settingsBaseCurrency => 'Osnovna valuta';

  @override
  String get settingsSecondaryCurrency => 'Sekundarna valuta';

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
  String get settingsSectionData => 'Podaci';

  @override
  String get settingsSectionPrivacy => 'O aplikaciji';

  @override
  String get settingsPrivacyPolicyTitle => 'Politika privatnosti';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Kako Platrare tretira vaše podatke.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Kursna lista: aplikacija preuzima javne kurseve preko interneta. Vaši računi i transakcije se ne šalju.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Nije moguće učitati politiku privatnosti.';

  @override
  String get settingsPrivacyRetry => 'Pokušaj ponovo';

  @override
  String get settingsSoftwareVersionTitle => 'Verzija softvera';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Izdanje, dijagnostika i pravni dokumenti';

  @override
  String get aboutScreenTitle => 'O aplikaciji';

  @override
  String get aboutAppTagline =>
      'Knjiga, novčani tok i planiranje na jednom mestu.';

  @override
  String get aboutDescriptionBody =>
      'Platrare čuva račune, transakcije i planove na vašem uređaju. Šifrovane rezervne kopije izvezite kada vam treba kopija i drugde. Kursna lista koristi samo javne podatke; vaša knjiga se ne otprema.';

  @override
  String get aboutVersionLabel => 'Verzija';

  @override
  String get aboutBuildLabel => 'Build';

  @override
  String get aboutCopySupportDetails => 'Kopiraj podatke za podršku';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Otvara pun tekst politike u aplikaciji.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Lokalizacija';

  @override
  String get settingsSupportInfoCopied => 'Kopirano u ostavu';

  @override
  String get settingsVerifyLedger => 'Provjeri podatke';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Provjeri da li se stanja računa poklapaju s istorijom transakcija';

  @override
  String get settingsDataExportTitle => 'Izvezi rezervnu kopiju';

  @override
  String get settingsDataExportSubtitle =>
      'Sačuvaj kao .zip ili šifrovani .platrare sa svim podacima i prilozima';

  @override
  String get settingsDataImportTitle => 'Vrati iz rezervne kopije';

  @override
  String get settingsDataImportSubtitle =>
      'Zamijeni trenutne podatke iz Platrare .zip ili .platrare fajla';

  @override
  String get backupExportDialogTitle => 'Zaštitite ovu rezervnu kopiju';

  @override
  String get backupExportDialogBody =>
      'Preporučena je jaka lozinka, posebno ako čuvate fajl u oblaku. Ista lozinka je potrebna za uvoz.';

  @override
  String get backupExportPasswordLabel => 'Lozinka';

  @override
  String get backupExportPasswordConfirmLabel => 'Potvrdi lozinku';

  @override
  String get backupExportPasswordMismatch => 'Lozinke se ne poklapaju';

  @override
  String get backupExportPasswordEmpty =>
      'Unesite podudarajuće lozinke ili izvezite bez šifrovanja ispod.';

  @override
  String get backupExportPasswordTooShort =>
      'Lozinka mora imati najmanje 8 znakova.';

  @override
  String get backupExportSaveToDevice => 'Sačuvaj na uređaju';

  @override
  String get backupExportShareToCloud => 'Podijeli (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Izvezi bez šifrovanja';

  @override
  String get backupExportSkipWarningTitle => 'Izvesti bez šifrovanja?';

  @override
  String get backupExportSkipWarningBody =>
      'Svako ko ima pristup fajlu može pročitati podatke. Koristite samo za lokalne kopije koje kontrolišete.';

  @override
  String get backupExportSkipWarningConfirm => 'Izvezi nešifrovano';

  @override
  String get backupImportPasswordTitle => 'Šifrovana rezerva';

  @override
  String get backupImportPasswordBody =>
      'Unesite lozinku koju ste koristili pri izvozu.';

  @override
  String get backupImportPasswordLabel => 'Lozinka';

  @override
  String get backupImportPreviewTitle => 'Pregled rezerve';

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
    return '$accounts računa · $transactions transakcija · $planned planiranih · $attachments priloga · $income kategorija prihoda · $expense kategorija rashoda';
  }

  @override
  String get backupImportPreviewContinue => 'Dalje';

  @override
  String get settingsBackupWrongPassword => 'Pogrešna lozinka';

  @override
  String get settingsBackupChecksumMismatch =>
      'Provera integriteta rezerve nije uspela';

  @override
  String get settingsBackupCorruptFile => 'Nevažeći ili oštećen fajl rezerve';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Rezerva zahteva noviju verziju aplikacije';

  @override
  String get settingsDataImportConfirmTitle => 'Zamijeniti trenutne podatke?';

  @override
  String get settingsDataImportConfirmBody =>
      'Ovo će zameniti vaše trenutne račune, transakcije, planirane transakcije, kategorije i uvezene priloge sadržajem iz izabrane rezerve. Ovu radnju nije moguće poništiti.';

  @override
  String get settingsDataImportConfirmAction => 'Zamijeni podatke';

  @override
  String get settingsDataImportDone => 'Podaci su uspješno vraćeni';

  @override
  String get settingsDataImportInvalidFile =>
      'Izabrani fajl nije validna Platrare rezervna kopija';

  @override
  String get settingsDataImportFailed => 'Uvoz nije uspeo';

  @override
  String get settingsDataExportDoneTitle => 'Rezervna kopija je izvezena';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Rezervna kopija je sačuvana na:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Otvori fajl';

  @override
  String get settingsDataExportFailed => 'Izvoz nije uspeo';

  @override
  String get ledgerVerifyDialogTitle => 'Provera knjige';

  @override
  String get ledgerVerifyAllMatch => 'Sva stanja se poklapaju.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Razlike';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nSačuvano: $stored\nPonovo: $replayed\nRazlika: $diff';
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
  String get settingsSectionAppearance => 'Izgled';

  @override
  String get settingsSectionSecurity => 'Sigurnost';

  @override
  String get settingsSecurityEnableLock => 'Zaključaj aplikaciju pri otvaranju';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Traži biometriju ili PIN kada se aplikacija otvori';

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
  String get settingsSecuritySetPin => 'Postavi PIN';

  @override
  String get settingsSecurityChangePin => 'Promeni PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Koristi PIN kao rezervu ako biometrija nije dostupna';

  @override
  String get settingsSecurityRemovePin => 'Ukloni PIN';

  @override
  String get securitySetPinTitle => 'Postavi PIN aplikacije';

  @override
  String get securityPinLabel => 'PIN kod';

  @override
  String get securityConfirmPinLabel => 'Potvrdi PIN kod';

  @override
  String get securityPinMustBe4Digits => 'PIN mora imati najmanje 4 cifre';

  @override
  String get securityPinMismatch => 'PIN kodovi se ne poklapaju';

  @override
  String get securityRemovePinTitle => 'Ukloniti PIN?';

  @override
  String get securityRemovePinBody =>
      'Biometrijsko otključavanje i dalje može da se koristi ako je dostupno.';

  @override
  String get securityUnlockTitle => 'Aplikacija je zaključana';

  @override
  String get securityUnlockSubtitle =>
      'Otključaj pomoću Face ID-a, otiska prsta ili PIN-a.';

  @override
  String get securityUnlockWithPin => 'Otključaj PIN-om';

  @override
  String get securityTryBiometric => 'Pokušaj biometrijsko otključavanje';

  @override
  String get securityPinIncorrect => 'Pogrešan PIN, pokušaj ponovo';

  @override
  String get securityBiometricReason =>
      'Potvrdi identitet za otvaranje aplikacije';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitleSystem => 'Prati podešavanja sistema';

  @override
  String get settingsThemeSubtitleLight => 'Svetla';

  @override
  String get settingsThemeSubtitleDark => 'Tamna';

  @override
  String get settingsThemePickerTitle => 'Tema';

  @override
  String get settingsThemeOptionSystem => 'Podrazumevano (sistem)';

  @override
  String get settingsThemeOptionLight => 'Svetla';

  @override
  String get settingsThemeOptionDark => 'Tamna';

  @override
  String get archivedAccountsTitle => 'Arhivirani računi';

  @override
  String get archivedAccountsEmptyTitle => 'Nema arhiviranih računa';

  @override
  String get archivedAccountsEmptyBody =>
      'Knjigovodstveni saldo i prekoračenje moraju biti nula; arhiviranje je u opcijama računa u Pregledu.';

  @override
  String get categoriesTitle => 'Kategorije';

  @override
  String get newCategoryTitle => 'Nova kategorija';

  @override
  String get categoryNameLabel => 'Naziv kategorije';

  @override
  String get deleteCategoryTitle => 'Obrisati kategoriju?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" će biti uklonjena sa liste.';
  }

  @override
  String get categoryIncome => 'Prihod';

  @override
  String get categoryExpense => 'Rashod';

  @override
  String get categoryAdd => 'Dodaj';

  @override
  String get searchCurrencies => 'Pretraži valute…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1G';

  @override
  String get periodAll => 'SVE';

  @override
  String get categoryLabel => 'kategorija';

  @override
  String get categoriesLabel => 'kategorije';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type — sačuvano  •  $amount';
  }

  @override
  String get tooltipSettings => 'Podešavanja';

  @override
  String get tooltipAddAccount => 'Dodaj račun';

  @override
  String get tooltipRemoveAccount => 'Ukloni račun';

  @override
  String get accountNameTaken =>
      'Račun sa ovim imenom i identifikatorom već postoji (aktivan ili arhiviran). Promenite naziv ili identifikator.';

  @override
  String get groupDescPersonal => 'Vaši novčanici i bankovni računi';

  @override
  String get groupDescIndividuals => 'Porodica, prijatelji, pojedinci';

  @override
  String get groupDescEntities => 'Entiteti, komunalije, organizacije';

  @override
  String get cannotArchiveTitle => 'Arhiviranje nije moguće';

  @override
  String get cannotArchiveBody =>
      'Arhiviranje je dostupno samo kada su stanje i limit prekoračenja na nuli.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Arhiviranje je dostupno samo kada su stanje i limit prekoračenja na nuli. Prvo podesite knjiženje ili limit.';

  @override
  String get archiveAccountTitle => 'Arhivirati račun?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planiranih transakcija koristi ovaj račun.',
      few: '$count planirane transakcije koriste ovaj račun.',
      one: '1 planirana transakcija koristi ovaj račun.',
    );
    return '$_temp0 Uklonite ih da plan bude usklađen sa arhiviranim računom.';
  }

  @override
  String get removeAndArchive => 'Ukloni planirane i arhiviraj';

  @override
  String get archiveBody =>
      'Račun će biti sakriven iz Pregleda, Evidencije i biranja. Možete ga vratiti iz Podešavanja.';

  @override
  String get archiveAction => 'Arhiviraj';

  @override
  String get archiveInstead => 'Arhiviraj umesto toga';

  @override
  String get cannotDeleteTitle => 'Brisanje nije moguće';

  @override
  String get cannotDeleteBodyShort =>
      'Ovaj račun se pojavljuje u Evidenciji. Uklonite ili preraspodelite te transakcije, ili arhivirajte račun ako je stanje raščišćeno.';

  @override
  String get cannotDeleteBodyHistory =>
      'Ovaj račun se pojavljuje u Evidenciji. Brisanje bi narušilo istoriju — uklonite ili preraspodelite te transakcije.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Ovaj račun se pojavljuje u Evidenciji i ne može se obrisati. Možete ga arhivirati ako su stanje i limit prekoračenja na nuli — biće sakriven sa lista ali istorija ostaje netaknuta.';

  @override
  String get deleteAccountTitle => 'Obrisati račun?';

  @override
  String get deleteAccountBodyPermanent =>
      'Ovaj račun će biti trajno uklonjen.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count planiranih transakcija koristi ovaj račun i biće takođe obrisane.',
      few:
          '$count planirane transakcije koriste ovaj račun i biće takođe obrisane.',
      one: '1 planirana transakcija koristi ovaj račun i biće takođe obrisana.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Obriši sve';

  @override
  String get editAccountTitle => 'Izmeni račun';

  @override
  String get newAccountTitle => 'Novi račun';

  @override
  String get labelAccountName => 'Naziv računa';

  @override
  String get labelAccountIdentifier => 'Identifikator (opciono)';

  @override
  String get accountAppearanceSection => 'Ikonica i boja';

  @override
  String get accountPickIcon => 'Izaberi ikonicu';

  @override
  String get accountPickColor => 'Izaberi boju';

  @override
  String get accountIconSheetTitle => 'Ikonica računa';

  @override
  String get accountColorSheetTitle => 'Boja računa';

  @override
  String get searchAccountIcons => 'Search icons by name…';

  @override
  String get accountIconSearchNoMatches => 'No icons match that search.';

  @override
  String get accountUseInitialLetter => 'Inicijal';

  @override
  String get accountUseDefaultColor => 'Kao grupa';

  @override
  String get labelRealBalance => 'Stvarno stanje';

  @override
  String get labelOverdraftLimit => 'Limit prekoračenja / avansa';

  @override
  String get labelCurrency => 'Valuta';

  @override
  String get saveChanges => 'Sačuvaj izmene';

  @override
  String get addAccountAction => 'Dodaj račun';

  @override
  String get removeAccountSheetTitle => 'Ukloni račun';

  @override
  String get deletePermanently => 'Trajno obriši';

  @override
  String get deletePermanentlySubtitle =>
      'Moguće samo kada se račun ne koristi u Evidenciji. Planirane stavke se mogu ukloniti pri brisanju.';

  @override
  String get archiveOptionSubtitle =>
      'Sakrij iz Pregleda i biranja. Vrati bilo kada iz Podešavanja. Zahteva nulto stanje i limit.';

  @override
  String get archivedBannerText =>
      'Ovaj račun je arhiviran. Ostaje u vašim podacima ali je sakriven sa lista i iz biranja.';

  @override
  String get balanceAdjustedTitle => 'Stanje podešeno u Evidenciji';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Stvarno stanje je ažurirano sa $previous na $current $symbol.\n\nTransakcija za podešavanje stanja je kreirana u Evidenciji (Istorija) radi konzistentnosti knjiženja.\n\n• Stvarno stanje odražava stvarni iznos na ovom računu.\n• Proverite Istoriju za stavku podešavanja.';
  }

  @override
  String get ok => 'U redu';

  @override
  String get categoryBalanceAdjustment => 'Korekcija stanja';

  @override
  String get descriptionBalanceCorrection => 'Korekcija bilansa';

  @override
  String get descriptionOpeningBalance => 'Početno stanje';

  @override
  String get reviewStatsModeStatistics => 'Statistika';

  @override
  String get reviewStatsModeComparison => 'Poređenje';

  @override
  String get statsUncategorized => 'Nekategorisano';

  @override
  String get statsNoCategories =>
      'Nema kategorija u izabranim periodima za poređenje.';

  @override
  String get statsNoTransactions => 'Nema transakcija';

  @override
  String get statsSpendingInCategory => 'Potrošnja u ovoj kategoriji';

  @override
  String get statsIncomeInCategory => 'Prihod u ovoj kategoriji';

  @override
  String get statsDifference => 'Razlika (B vs A): ';

  @override
  String get statsNoExpensesMonth => 'Nema rashoda ovog meseca';

  @override
  String get statsNoExpensesAll => 'Nema evidentiranih rashoda';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Nema rashoda u poslednjih $period';
  }

  @override
  String get statsTotalSpent => 'Ukupno potrošeno';

  @override
  String get statsNoExpensesThisPeriod => 'Nema rashoda u ovom periodu';

  @override
  String get statsNoIncomeMonth => 'Nema prihoda ovog meseca';

  @override
  String get statsNoIncomeAll => 'Nema evidentiranih prihoda';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Nema prihoda u poslednjih $period';
  }

  @override
  String get statsTotalReceived => 'Ukupno primljeno';

  @override
  String get statsNoIncomeThisPeriod => 'Nema prihoda u ovom periodu';

  @override
  String get catSalary => 'Plata';

  @override
  String get catFreelance => 'Slobodni posao';

  @override
  String get catConsulting => 'Konsalting';

  @override
  String get catGift => 'Poklon';

  @override
  String get catRental => 'Iznajmljivanje';

  @override
  String get catDividends => 'Dividende';

  @override
  String get catRefund => 'Povrat';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catInterest => 'Kamata';

  @override
  String get catSideHustle => 'Dopunski posao';

  @override
  String get catSaleOfGoods => 'Prodaja robe';

  @override
  String get catOther => 'Ostalo';

  @override
  String get catGroceries => 'Namirnice';

  @override
  String get catDining => 'Ishrana';

  @override
  String get catTransport => 'Prevoz';

  @override
  String get catUtilities => 'Komunalije';

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
  String get catGym => 'Teretana';

  @override
  String get catPets => 'Kućni ljubimci';

  @override
  String get catKids => 'Deca';

  @override
  String get catCharity => 'Dobročinstvo';

  @override
  String get catCoffee => 'Kafa';

  @override
  String get catGifts => 'Pokloni';

  @override
  String semanticsProjectionDate(String date) {
    return 'Datum projekcije $date. Dvaput dodirnite za izbor datuma';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Projektovano lično stanje $amount';
  }

  @override
  String get statsEmptyTitle => 'Još nema transakcija';

  @override
  String get statsEmptySubtitle =>
      'Nema podataka o potrošnji za izabrani period.';

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
      'Datum: celo vreme — dodirnite za promenu režima';

  @override
  String semanticsDateMode(String mode) {
    return 'Datum: $mode — dodirnite za promenu režima';
  }

  @override
  String get semanticsDateThisMonth =>
      'Datum: ovaj mesec — dodirnite za mesec, nedelju, godinu ili celo vreme';

  @override
  String get semanticsTxTypeCycle =>
      'Tip transakcije: sve, prihod, rashod, prenos';

  @override
  String get semanticsAccountFilter => 'Filter računa';

  @override
  String get semanticsAlreadyFiltered => 'Već filtrirano na ovaj račun';

  @override
  String get semanticsCategoryFilter => 'Filter kategorije';

  @override
  String get semanticsSortToggle => 'Sortiranje: najnovije ili najstarije prvo';

  @override
  String get semanticsFiltersDisabled =>
      'Filteri liste su onemogućeni dok gledate budući datum projekcije. Uklonite projekcije da koristite filtere.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Filteri liste su onemogućeni. Prvo dodajte nalog.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Filteri liste su onemogućeni. Prvo dodajte planiranu transakciju.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Filteri liste su onemogućeni. Prvo evidentirajte transakciju.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Kontrole za odeljak i valutu su onemogućene. Prvo dodajte nalog.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Datum projekcije i detalji stanja su onemogućeni. Prvo dodajte nalog i planiranu transakciju.';

  @override
  String get semanticsReorderAccountHint =>
      'Dugi pritisak, zatim prevucite da promenite redosled u ovoj grupi';

  @override
  String get semanticsChartStyle => 'Stil grafikona';

  @override
  String get semanticsChartStyleUnavailable =>
      'Stil grafikona (nedostupno u režimu poređenja)';

  @override
  String semanticsPeriod(String label) {
    return 'Period: $label';
  }

  @override
  String get trackSearchHint => 'Pretraga opisa, kategorije, računa…';

  @override
  String get trackSearchClear => 'Obriši pretragu';

  @override
  String get settingsExchangeRatesTitle => 'Kursna lista';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Posljednje ažuriranje: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Koriste se ugrađeni ili keširani kursevi — dodirnite za osvježavanje';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Kursna lista ažurirana';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Nije moguće ažurirati kursnu listu. Provjerite vezu.';

  @override
  String get settingsClearData => 'Brisanje podataka';

  @override
  String get settingsClearDataSubtitle => 'Trajno ukloni odabrane podatke';

  @override
  String get clearDataTitle => 'Brisanje podataka';

  @override
  String get clearDataTransactions => 'Historija transakcija';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transakcija · stanja računa se postavljaju na nulu';
  }

  @override
  String get clearDataPlanned => 'Planirane transakcije';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count planiranih stavki';
  }

  @override
  String get clearDataAccounts => 'Računi';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count računa · briše i historiju i plan';
  }

  @override
  String get clearDataCategories => 'Kategorije';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count kategorija · zamjenjuje se podrazumijevanim';
  }

  @override
  String get clearDataPreferences => 'Podešavanja';

  @override
  String get clearDataPreferencesSubtitle =>
      'Vraća valutu, temu i jezik na podrazumijevane vrijednosti';

  @override
  String get clearDataSecurity => 'Zaključavanje i PIN';

  @override
  String get clearDataSecuritySubtitle =>
      'Isključuje zaključavanje i briše PIN';

  @override
  String get clearDataConfirmButton => 'Obriši odabrano';

  @override
  String get clearDataConfirmTitle => 'Ova radnja se ne može poništiti';

  @override
  String get clearDataConfirmBody =>
      'Odabrani podaci bit će trajno obrisani. Napravite backup ako će vam trebati.';

  @override
  String get clearDataTypeConfirm => 'Upišite DELETE za potvrdu';

  @override
  String get clearDataTypeConfirmError =>
      'Upišite DELETE tačno kako bi nastavili';

  @override
  String get clearDataPinTitle => 'Potvrdite PIN-om';

  @override
  String get clearDataPinBody => 'Unesite PIN aplikacije za autorizaciju.';

  @override
  String get clearDataPinIncorrect => 'Pogrešan PIN';

  @override
  String get clearDataDone => 'Odabrani podaci su obrisani';

  @override
  String get autoBackupTitle => 'Automatska dnevna rezervna kopija';

  @override
  String autoBackupLastAt(String date) {
    return 'Poslednja kopija $date';
  }

  @override
  String get autoBackupNeverRun => 'Još nema kopije';

  @override
  String get autoBackupShareTitle => 'Sačuvaj u oblak';

  @override
  String get autoBackupShareSubtitle =>
      'Pošalji poslednju kopiju na iCloud Drive, Google Drive ili drugu aplikaciju';

  @override
  String get autoBackupCloudReminder =>
      'Automatska kopija je spremna — sačuvajte je u oblaku za zaštitu van uređaja';

  @override
  String get autoBackupCloudReminderAction => 'Podeli';

  @override
  String get persistenceErrorReloaded =>
      'Чување није успело. Подаци су поново учитани.';
}

/// The translations for Serbian, using the Cyrillic script (`sr_Cyrl`).
class AppLocalizationsSrCyrl extends AppLocalizationsSr {
  AppLocalizationsSrCyrl() : super('sr_Cyrl');

  @override
  String get appTitle => 'Платраре';

  @override
  String get navPlan => 'План';

  @override
  String get navTrack => 'Евиденција';

  @override
  String get navReview => 'Преглед';

  @override
  String get cancel => 'Откажи';

  @override
  String get delete => 'Обриши';

  @override
  String get close => 'Затвори';

  @override
  String get add => 'Додај';

  @override
  String get undo => 'Поништи';

  @override
  String get confirm => 'Потврди';

  @override
  String get restore => 'Врати';

  @override
  String get heroIn => 'Улаз';

  @override
  String get heroOut => 'Излаз';

  @override
  String get heroNet => 'Нето';

  @override
  String get heroBalance => 'Стање';

  @override
  String get realBalance => 'Стварно стање';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Сакриј стања у картицама сажетка';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Када је укључено, износи у Плану, Праћењу и Прегледу остају скривени dok не додирнете икону ока на сваком табу. Када је искључено, стања су увек видљива.';

  @override
  String get heroBalancesShow => 'Прикажи стања';

  @override
  String get heroBalancesHide => 'Сакриј стања';

  @override
  String get semanticsHeroBalanceHidden => 'Стање скривено ради приватности';

  @override
  String get heroResetButton => 'Ресет';

  @override
  String get fabScrollToTop => 'На врх';

  @override
  String get filterAll => 'Све';

  @override
  String get filterAllAccounts => 'Сви рачуни';

  @override
  String get filterAllCategories => 'Све категорије';

  @override
  String get txLabelIncome => 'ПРИХОД';

  @override
  String get txLabelExpense => 'РАСХОД';

  @override
  String get txLabelInvoice => 'ФАКТУРА';

  @override
  String get txLabelBill => 'РАЧУН';

  @override
  String get txLabelAdvance => 'АВАНС';

  @override
  String get txLabelSettlement => 'ПОРАВНАЊЕ';

  @override
  String get txLabelLoan => 'ЗАЈАМ';

  @override
  String get txLabelCollection => 'НАПЛАТА';

  @override
  String get txLabelOffset => 'ПРЕБИЈАЊЕ';

  @override
  String get txLabelTransfer => 'ПРЕНОС';

  @override
  String get txLabelTransaction => 'ТРАНСАКЦИЈА';

  @override
  String get repeatNone => 'Без понављања';

  @override
  String get repeatDaily => 'Дневно';

  @override
  String get repeatWeekly => 'Недељно';

  @override
  String get repeatMonthly => 'Месечно';

  @override
  String get repeatYearly => 'Годишње';

  @override
  String get repeatEveryLabel => 'Сваки';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дана',
      few: '$count дана',
      one: 'дан',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count недеља',
      few: '$count недеље',
      one: 'недељу',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count месеци',
      few: '$count месеца',
      one: 'месец',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count година',
      few: '$count године',
      one: 'годину',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Завршава се';

  @override
  String get repeatEndNever => 'Никад';

  @override
  String get repeatEndOnDate => 'На датум';

  @override
  String repeatEndAfterCount(int count) {
    return 'После $count пута';
  }

  @override
  String get repeatEndAfterChoice => 'После одређеног броја пута';

  @override
  String get repeatEndPickDate => 'Изаберите крајњи датум';

  @override
  String get repeatEndTimes => 'пута';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Сваки $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'до $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count пута';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining од $total преостало';
  }

  @override
  String get detailRepeatEvery => 'Понавља се сваки';

  @override
  String get detailEnds => 'Завршава се';

  @override
  String get detailEndsNever => 'Никад';

  @override
  String detailEndsOnDate(String date) {
    return 'На $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'После $count пута';
  }

  @override
  String get detailProgress => 'Напредак';

  @override
  String get weekendNoChange => 'Без промене';

  @override
  String get weekendFriday => 'Помери на петак';

  @override
  String get weekendMonday => 'Помери на понедељак';

  @override
  String weekendQuestion(String day) {
    return 'Ако $day. падне на викенд?';
  }

  @override
  String get dateToday => 'Данас';

  @override
  String get dateTomorrow => 'Сутра';

  @override
  String get dateYesterday => 'Јуче';

  @override
  String get statsAllTime => 'Цело време';

  @override
  String get accountGroupPersonal => 'Лично';

  @override
  String get accountGroupIndividual => 'Појединац';

  @override
  String get accountGroupEntity => 'Ентитет';

  @override
  String get accountSectionIndividuals => 'Појединци';

  @override
  String get accountSectionEntities => 'Ентитети';

  @override
  String get emptyNoTransactionsYet => 'Нема трансакција';

  @override
  String get emptyNoAccountsYet => 'Нема рачуна';

  @override
  String get emptyRecordFirstTransaction =>
      'Додирните дугме испод да забележите прву трансакцију.';

  @override
  String get emptyAddFirstAccountTx =>
      'Додајте први рачун пре евидентирања трансакција.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Додајте први рачун пре планирања трансакција.';

  @override
  String get emptyAddFirstAccountReview =>
      'Додајте први рачун за праћење финансија.';

  @override
  String get emptyAddTransaction => 'Додај трансакцију';

  @override
  String get emptyAddAccount => 'Додај рачун';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Још нема личних рачуна';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Лични рачуни су ваши новчаници и банковни рачуни. Додајте један да пратите свакодневни приход и расход.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'Још нема рачуна појединаца';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Рачуни појединаца прате новац са одређеним особама—заједнички трошкови, позајмице или дуговања. Додајте рачун за сваку особу са којом се обрачунавате.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Још нема рачуна ентитета';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Рачуни ентитета су за фирме, пројекте или организације. Користите их да пословни новчани ток одвојите од личних финансија.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Нема трансакција за примењене филтере';

  @override
  String get emptyNoTransactionsInHistory => 'Нема трансакција у историји';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Нема трансакција за $month';
  }

  @override
  String get emptyNoTransactionsForAccount => 'Нема трансакција за овај рачун';

  @override
  String get trackTransactionDeleted => 'Трансакција обрисана';

  @override
  String get trackDeleteTitle => 'Обрисати трансакцију?';

  @override
  String get trackDeleteBody => 'Ово ће поништити промене стања на рачунима.';

  @override
  String get trackTransaction => 'Трансакција';

  @override
  String get planConfirmTitle => 'Потврдити трансакцију?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Ова ставка је заказана за $date. Биће евидентирана у Историји са данашњим датумом ($todayDate). Следећа ставка остаје на $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Ово ће применити трансакцију на стварна стања рачуна и преместити је у Историју.';

  @override
  String get planTransactionConfirmed => 'Трансакција потврђена и примењена';

  @override
  String get planTransactionRemoved => 'Планирана трансакција уклоњена';

  @override
  String get planRepeatingTitle => 'Трансакција која се понавља';

  @override
  String get planRepeatingBody =>
      'Прескочи само овај датум — серија се наставља са следећом ставком — или обриши све преостале ставке из плана.';

  @override
  String get planDeleteAll => 'Обриши све';

  @override
  String get planSkipThisOnly => 'Прескочи само ову';

  @override
  String get planOccurrenceSkipped => 'Ставка прескочена — следећа заказана';

  @override
  String get planNothingPlanned => 'Ништа није планирано';

  @override
  String get planPlanBody => 'Планирајте будуће трансакције.';

  @override
  String get planAddPlan => 'Додај план';

  @override
  String get planNoPlannedForFilters =>
      'Нема планираних трансакција за примењене филтере';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Нема планираних трансакција у $month';
  }

  @override
  String get planOverdue => 'истекло';

  @override
  String get planPlannedTransaction => 'Планирана трансакција';

  @override
  String get discardTitle => 'Одбацити измене?';

  @override
  String get discardBody =>
      'Имате несачуване измене. Биће изгубљене ако напустите ову страницу.';

  @override
  String get keepEditing => 'Настави уређивање';

  @override
  String get discard => 'Одбаци';

  @override
  String get newTransactionTitle => 'Нова трансакција';

  @override
  String get editTransactionTitle => 'Измени трансакцију';

  @override
  String get transactionUpdated => 'Трансакција ажурирана';

  @override
  String get sectionAccounts => 'Рачуни';

  @override
  String get labelFrom => 'Од';

  @override
  String get labelTo => 'Ка';

  @override
  String get sectionCategory => 'Категорија';

  @override
  String get sectionAttachments => 'Прилози';

  @override
  String get labelNote => 'Белешка';

  @override
  String get hintOptionalDescription => 'Опциони опис';

  @override
  String get updateTransaction => 'Ажурирај трансакцију';

  @override
  String get saveTransaction => 'Сачувај трансакцију';

  @override
  String get selectAccount => 'Изаберите рачун';

  @override
  String get selectAccountTitle => 'Изаберите рачун';

  @override
  String get noAccountsAvailable => 'Нема доступних рачуна';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Износ примљен од $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Унесите тачан износ који прима одредишни рачун. Ово закључава коришћени курс.';

  @override
  String get attachTakePhoto => 'Сликај';

  @override
  String get attachTakePhotoSub => 'Користите камеру за снимање рачуна';

  @override
  String get attachChooseGallery => 'Изабери из галерије';

  @override
  String get attachChooseGallerySub => 'Изаберите фотографије из библиотеке';

  @override
  String get attachBrowseFiles => 'Прегледај фајлове';

  @override
  String get attachBrowseFilesSub =>
      'Приложите ПДФ-ове, документе или друге фајлове';

  @override
  String get attachButton => 'Приложи';

  @override
  String get editPlanTitle => 'Измени план';

  @override
  String get planTransactionTitle => 'Планирај трансакцију';

  @override
  String get tapToSelect => 'Додирните за избор';

  @override
  String get updatePlan => 'Ажурирај план';

  @override
  String get addToPlan => 'Додај у план';

  @override
  String get labelRepeat => 'Понављање';

  @override
  String get selectPlannedDate => 'Изаберите планирани датум';

  @override
  String get balancesAsOfToday => 'Стања на данашњи дан';

  @override
  String get projectedBalancesForTomorrow => 'Пројектована стања за сутра';

  @override
  String projectedBalancesForDate(String date) {
    return 'Пројектована стања за $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name прима ($currency)';
  }

  @override
  String get destHelper =>
      'Процењени одредишни износ. Тачан курс се закључава при потврди.';

  @override
  String get descriptionOptional => 'Опис (опционо)';

  @override
  String get detailTransactionTitle => 'Трансакција';

  @override
  String get detailPlannedTitle => 'Планирано';

  @override
  String get detailConfirmTransaction => 'Потврди трансакцију';

  @override
  String get detailDate => 'Датум';

  @override
  String get detailFrom => 'Од';

  @override
  String get detailTo => 'Ка';

  @override
  String get detailCategory => 'Категорија';

  @override
  String get detailNote => 'Белешка';

  @override
  String get detailDestinationAmount => 'Одредишни износ';

  @override
  String get detailExchangeRate => 'Курс';

  @override
  String get detailRepeats => 'Понавља се';

  @override
  String get detailDayOfMonth => 'Дан у месецу';

  @override
  String get detailWeekends => 'Викенди';

  @override
  String get detailAttachments => 'Прилози';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фајлова',
      few: '$count фајла',
      one: '1 фајл',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Подешавања';

  @override
  String get settingsSectionDisplay => 'Приказ';

  @override
  String get settingsSectionLanguage => 'Језик';

  @override
  String get settingsSectionCategories => 'Категорије';

  @override
  String get settingsSectionAccounts => 'Рачуни';

  @override
  String get settingsSectionPreferences => 'Подешавања';

  @override
  String get settingsSectionManage => 'Управљање';

  @override
  String get settingsBaseCurrency => 'Основна валута';

  @override
  String get settingsSecondaryCurrency => 'Секундарна валута';

  @override
  String get settingsCategories => 'Категорије';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount прихода · $expenseCount расхода';
  }

  @override
  String get settingsArchivedAccounts => 'Архивирани рачуни';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Тренутно нема — архивирај из измене рачуна када је салдо нула';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count сакривено из прегледа и бирања';
  }

  @override
  String get settingsSectionData => 'Подаци';

  @override
  String get settingsSectionPrivacy => 'О апликацији';

  @override
  String get settingsPrivacyPolicyTitle => 'Политика приватности';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Како Платраре третира ваше податке.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Курсна листа: апликација преузима јавне курсеве преко интернета. Ваши рачуни и трансакције се не шаљу.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Није могуће учитати политику приватности.';

  @override
  String get settingsPrivacyRetry => 'Покушај поново';

  @override
  String get settingsSoftwareVersionTitle => 'Верзија софтвера';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Издање, дијагностика и правни документи';

  @override
  String get aboutScreenTitle => 'О апликацији';

  @override
  String get aboutAppTagline =>
      'Књига, новчани ток и планирање на једном месту.';

  @override
  String get aboutDescriptionBody =>
      'Платраре чува рачуне, трансакције и планове на вашем уређају. Шифроване резервне копије извезите када вам треба копија и другде. Курсна листа користи само јавне податке; ваша књига се не отпрема.';

  @override
  String get aboutVersionLabel => 'Верзија';

  @override
  String get aboutBuildLabel => 'Буилд';

  @override
  String get aboutCopySupportDetails => 'Копирај податке за подршку';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Отвара пун текст политике у апликацији.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Локализација';

  @override
  String get settingsSupportInfoCopied => 'Копирано у оставу';

  @override
  String get settingsVerifyLedger => 'Провјери податке';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Провјери да ли се стања рачуна поклапају с историјом трансакција';

  @override
  String get settingsDataExportTitle => 'Извези резервну копију';

  @override
  String get settingsDataExportSubtitle =>
      'Сачувај као .зип или шифровани .платраре са свим подацима и прилозима';

  @override
  String get settingsDataImportTitle => 'Врати из резервне копије';

  @override
  String get settingsDataImportSubtitle =>
      'Замијени тренутне податке из Платраре .зип или .платраре фајла';

  @override
  String get backupExportDialogTitle => 'Заштитите ову резервну копију';

  @override
  String get backupExportDialogBody =>
      'Препоручена је јака лозинка, посебно ако чувате фајл у облаку. Иста лозинка је потребна за увоз.';

  @override
  String get backupExportPasswordLabel => 'Лозинка';

  @override
  String get backupExportPasswordConfirmLabel => 'Потврди лозинку';

  @override
  String get backupExportPasswordMismatch => 'Лозинке се не поклапају';

  @override
  String get backupExportPasswordEmpty =>
      'Унесите подударајуће лозинке или извезите без шифровања испод.';

  @override
  String get backupExportPasswordTooShort =>
      'Лозинка мора имати најмање 8 знакова.';

  @override
  String get backupExportSaveToDevice => 'Сачувај на уређају';

  @override
  String get backupExportShareToCloud => 'Подијели (иЦлоуд, Дриве…)';

  @override
  String get backupExportWithoutEncryption => 'Извези без шифровања';

  @override
  String get backupExportSkipWarningTitle => 'Извести без шифровања?';

  @override
  String get backupExportSkipWarningBody =>
      'Свако ко има приступ фајлу може прочитати податке. Користите само за локалне копије које контролишете.';

  @override
  String get backupExportSkipWarningConfirm => 'Извези нешифровано';

  @override
  String get backupImportPasswordTitle => 'Шифрована резерва';

  @override
  String get backupImportPasswordBody =>
      'Унесите лозинку коју сте користили при извозу.';

  @override
  String get backupImportPasswordLabel => 'Лозинка';

  @override
  String get backupImportPreviewTitle => 'Преглед резерве';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Верзија апликације: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Извезено: $date';
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
    return '$accounts рачуна · $transactions трансакција · $planned планираних · $attachments прилога · $income категорија прихода · $expense категорија расхода';
  }

  @override
  String get backupImportPreviewContinue => 'Даље';

  @override
  String get settingsBackupWrongPassword => 'Погрешна лозинка';

  @override
  String get settingsBackupChecksumMismatch =>
      'Провера интегритета резерве није успела';

  @override
  String get settingsBackupCorruptFile => 'Неважећи или оштећен фајл резерве';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Резерва захтева новију верзију апликације';

  @override
  String get settingsDataImportConfirmTitle => 'Замијенити тренутне податке?';

  @override
  String get settingsDataImportConfirmBody =>
      'Ово ће заменити ваше тренутне рачуне, трансакције, планиране трансакције, категорије и увезене прилоге садржајем из изабране резерве. Ову радњу није могуће поништити.';

  @override
  String get settingsDataImportConfirmAction => 'Замијени податке';

  @override
  String get settingsDataImportDone => 'Подаци су успјешно враћени';

  @override
  String get settingsDataImportInvalidFile =>
      'Изабрани фајл није валидна Платраре резервна копија';

  @override
  String get settingsDataImportFailed => 'Увоз није успео';

  @override
  String get settingsDataExportDoneTitle => 'Резервна копија је извезена';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Резервна копија је сачувана на:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Отвори фајл';

  @override
  String get settingsDataExportFailed => 'Извоз није успео';

  @override
  String get ledgerVerifyDialogTitle => 'Провера књиге';

  @override
  String get ledgerVerifyAllMatch => 'Сва стања се поклапају.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Разлике';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nСачувано: $stored\nПоново: $replayed\nРазлика: $diff';
  }

  @override
  String get settingsLanguage => 'Језик апликације';

  @override
  String get settingsLanguageSubtitleSystem => 'Прати подешавања система';

  @override
  String get settingsLanguageSubtitleEnglish => 'Енглески';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Српски (латиница)';

  @override
  String get settingsLanguagePickerTitle => 'Језик апликације';

  @override
  String get settingsLanguageOptionSystem => 'Подразумевано (систем)';

  @override
  String get settingsLanguageOptionEnglish => 'Енглески';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Српски (латиница)';

  @override
  String get settingsSectionAppearance => 'Изглед';

  @override
  String get settingsSectionSecurity => 'Сигурност';

  @override
  String get settingsSecurityEnableLock => 'Закључај апликацију при отварању';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Тражи биометрију или ПИН када се апликација отвори';

  @override
  String get settingsSecuritySetPin => 'Постави ПИН';

  @override
  String get settingsSecurityChangePin => 'Промени ПИН';

  @override
  String get settingsSecurityPinSubtitle =>
      'Користи ПИН као резерву ако биометрија није доступна';

  @override
  String get settingsSecurityRemovePin => 'Уклони ПИН';

  @override
  String get securitySetPinTitle => 'Постави ПИН апликације';

  @override
  String get securityPinLabel => 'ПИН код';

  @override
  String get securityConfirmPinLabel => 'Потврди ПИН код';

  @override
  String get securityPinMustBe4Digits => 'ПИН мора имати најмање 4 цифре';

  @override
  String get securityPinMismatch => 'ПИН кодови се не поклапају';

  @override
  String get securityRemovePinTitle => 'Уклонити ПИН?';

  @override
  String get securityRemovePinBody =>
      'Биометријско откључавање и даље може да се користи ако је доступно.';

  @override
  String get securityUnlockTitle => 'Апликација је закључана';

  @override
  String get securityUnlockSubtitle =>
      'Откључај помоћу Фаце ИД-а, отиска прста или ПИН-а.';

  @override
  String get securityUnlockWithPin => 'Откључај ПИН-ом';

  @override
  String get securityTryBiometric => 'Покушај биометријско откључавање';

  @override
  String get securityPinIncorrect => 'Погрешан ПИН, покушај поново';

  @override
  String get securityBiometricReason =>
      'Потврди идентитет за отварање апликације';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeSubtitleSystem => 'Прати подешавања система';

  @override
  String get settingsThemeSubtitleLight => 'Светла';

  @override
  String get settingsThemeSubtitleDark => 'Тамна';

  @override
  String get settingsThemePickerTitle => 'Тема';

  @override
  String get settingsThemeOptionSystem => 'Подразумевано (систем)';

  @override
  String get settingsThemeOptionLight => 'Светла';

  @override
  String get settingsThemeOptionDark => 'Тамна';

  @override
  String get archivedAccountsTitle => 'Архивирани рачуни';

  @override
  String get archivedAccountsEmptyTitle => 'Нема архивираних рачуна';

  @override
  String get archivedAccountsEmptyBody =>
      'Књиговодствени салдо и прекорачење морају бити нула; архивирање је у опцијама рачуна у Прегледу.';

  @override
  String get categoriesTitle => 'Категорије';

  @override
  String get newCategoryTitle => 'Нова категорија';

  @override
  String get categoryNameLabel => 'Назив категорије';

  @override
  String get deleteCategoryTitle => 'Обрисати категорију?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" ће бити уклоњена са листе.';
  }

  @override
  String get categoryIncome => 'Приход';

  @override
  String get categoryExpense => 'Расход';

  @override
  String get categoryAdd => 'Додај';

  @override
  String get searchCurrencies => 'Претражи валуте…';

  @override
  String get period1M => '1М';

  @override
  String get period3M => '3М';

  @override
  String get period6M => '6М';

  @override
  String get period1Y => '1Г';

  @override
  String get periodAll => 'СВЕ';

  @override
  String get categoryLabel => 'категорија';

  @override
  String get categoriesLabel => 'категорије';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type — сачувано  •  $amount';
  }

  @override
  String get tooltipSettings => 'Подешавања';

  @override
  String get tooltipAddAccount => 'Додај рачун';

  @override
  String get tooltipRemoveAccount => 'Уклони рачун';

  @override
  String get accountNameTaken =>
      'Рачун са овим именом и идентификатором већ постоји (активан или архивиран). Промените назив или идентификатор.';

  @override
  String get groupDescPersonal => 'Ваши новчаници и банковни рачуни';

  @override
  String get groupDescIndividuals => 'Породица, пријатељи, појединци';

  @override
  String get groupDescEntities => 'Ентитети, комуналије, организације';

  @override
  String get cannotArchiveTitle => 'Архивирање није могуће';

  @override
  String get cannotArchiveBody =>
      'Архивирање је доступно само када су стање и лимит прекорачења на нули.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Архивирање је доступно само када су стање и лимит прекорачења на нули. Прво подесите књижење или лимит.';

  @override
  String get archiveAccountTitle => 'Архивирати рачун?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count планираних трансакција користи овај рачун.',
      few: '$count планиране трансакције користе овај рачун.',
      one: '1 планирана трансакција користи овај рачун.',
    );
    return '$_temp0 Уклоните их да план буде усклађен са архивираним рачуном.';
  }

  @override
  String get removeAndArchive => 'Уклони планиране и архивирај';

  @override
  String get archiveBody =>
      'Рачун ће бити сакривен из Прегледа, Евиденције и бирања. Можете га вратити из Подешавања.';

  @override
  String get archiveAction => 'Архивирај';

  @override
  String get archiveInstead => 'Архивирај уместо тога';

  @override
  String get cannotDeleteTitle => 'Брисање није могуће';

  @override
  String get cannotDeleteBodyShort =>
      'Овај рачун се појављује у Евиденцији. Уклоните или прерасподелите те трансакције, или архивирајте рачун ако је стање рашчишћено.';

  @override
  String get cannotDeleteBodyHistory =>
      'Овај рачун се појављује у Евиденцији. Брисање би нарушило историју — уклоните или прерасподелите те трансакције.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Овај рачун се појављује у Евиденцији и не може се обрисати. Можете га архивирати ако су стање и лимит прекорачења на нули — биће сакривен са листа али историја остаје нетакнута.';

  @override
  String get deleteAccountTitle => 'Обрисати рачун?';

  @override
  String get deleteAccountBodyPermanent => 'Овај рачун ће бити трајно уклоњен.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count планираних трансакција користи овај рачун и биће такође обрисане.',
      few:
          '$count планиране трансакције користе овај рачун и биће такође обрисане.',
      one: '1 планирана трансакција користи овај рачун и биће такође обрисана.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Обриши све';

  @override
  String get editAccountTitle => 'Измени рачун';

  @override
  String get newAccountTitle => 'Нови рачун';

  @override
  String get labelAccountName => 'Назив рачуна';

  @override
  String get labelAccountIdentifier => 'Идентификатор (опционо)';

  @override
  String get accountAppearanceSection => 'Иконица и боја';

  @override
  String get accountPickIcon => 'Изабери иконицу';

  @override
  String get accountPickColor => 'Изабери боју';

  @override
  String get accountIconSheetTitle => 'Иконица рачуна';

  @override
  String get accountColorSheetTitle => 'Боја рачуна';

  @override
  String get accountUseInitialLetter => 'Иницијал';

  @override
  String get accountUseDefaultColor => 'Као група';

  @override
  String get labelRealBalance => 'Стварно стање';

  @override
  String get labelOverdraftLimit => 'Лимит прекорачења / аванса';

  @override
  String get labelCurrency => 'Валута';

  @override
  String get saveChanges => 'Сачувај измене';

  @override
  String get addAccountAction => 'Додај рачун';

  @override
  String get removeAccountSheetTitle => 'Уклони рачун';

  @override
  String get deletePermanently => 'Трајно обриши';

  @override
  String get deletePermanentlySubtitle =>
      'Могуће само када се рачун не користи у Евиденцији. Планиране ставке се могу уклонити при брисању.';

  @override
  String get archiveOptionSubtitle =>
      'Сакриј из Прегледа и бирања. Врати било када из Подешавања. Захтева нулто стање и лимит.';

  @override
  String get archivedBannerText =>
      'Овај рачун је архивиран. Остаје у вашим подацима али је сакривен са листа и из бирања.';

  @override
  String get balanceAdjustedTitle => 'Стање подешено у Евиденцији';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Стварно стање је ажурирано са $previous на $current $symbol.\n\nТрансакција за подешавање стања је креирана у Евиденцији (Историја) ради конзистентности књижења.\n\n• Стварно стање одражава стварни износ на овом рачуну.\n• Проверите Историју за ставку подешавања.';
  }

  @override
  String get ok => 'У реду';

  @override
  String get categoryBalanceAdjustment => 'Корекција стања';

  @override
  String get descriptionBalanceCorrection => 'Корекција биланса';

  @override
  String get descriptionOpeningBalance => 'Почетно стање';

  @override
  String get reviewStatsModeStatistics => 'Статистика';

  @override
  String get reviewStatsModeComparison => 'Поређење';

  @override
  String get statsUncategorized => 'Некатегорисано';

  @override
  String get statsNoCategories =>
      'Нема категорија у изабраним периодима за поређење.';

  @override
  String get statsNoTransactions => 'Нема трансакција';

  @override
  String get statsSpendingInCategory => 'Потрошња у овој категорији';

  @override
  String get statsIncomeInCategory => 'Приход у овој категорији';

  @override
  String get statsDifference => 'Разлика (Б вс А): ';

  @override
  String get statsNoExpensesMonth => 'Нема расхода овог месеца';

  @override
  String get statsNoExpensesAll => 'Нема евидентираних расхода';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Нема расхода у последњих $period';
  }

  @override
  String get statsTotalSpent => 'Укупно потрошено';

  @override
  String get statsNoExpensesThisPeriod => 'Нема расхода у овом периоду';

  @override
  String get statsNoIncomeMonth => 'Нема прихода овог месеца';

  @override
  String get statsNoIncomeAll => 'Нема евидентираних прихода';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Нема прихода у последњих $period';
  }

  @override
  String get statsTotalReceived => 'Укупно примљено';

  @override
  String get statsNoIncomeThisPeriod => 'Нема прихода у овом периоду';

  @override
  String get catSalary => 'Плата';

  @override
  String get catFreelance => 'Слободни посао';

  @override
  String get catConsulting => 'Консалтинг';

  @override
  String get catGift => 'Поклон';

  @override
  String get catRental => 'Изнајмљивање';

  @override
  String get catDividends => 'Дивиденде';

  @override
  String get catRefund => 'Поврат';

  @override
  String get catBonus => 'Бонус';

  @override
  String get catInterest => 'Камата';

  @override
  String get catSideHustle => 'Допунски посао';

  @override
  String get catSaleOfGoods => 'Продаја робе';

  @override
  String get catOther => 'Остало';

  @override
  String get catGroceries => 'Намирнице';

  @override
  String get catDining => 'Исхрана';

  @override
  String get catTransport => 'Превоз';

  @override
  String get catUtilities => 'Комуналије';

  @override
  String get catHousing => 'Становање';

  @override
  String get catHealthcare => 'Здравство';

  @override
  String get catEntertainment => 'Забава';

  @override
  String get catShopping => 'Куповина';

  @override
  String get catTravel => 'Путовања';

  @override
  String get catEducation => 'Образовање';

  @override
  String get catSubscriptions => 'Претплате';

  @override
  String get catInsurance => 'Осигурање';

  @override
  String get catFuel => 'Гориво';

  @override
  String get catGym => 'Теретана';

  @override
  String get catPets => 'Кућни љубимци';

  @override
  String get catKids => 'Деца';

  @override
  String get catCharity => 'Доброчинство';

  @override
  String get catCoffee => 'Кафа';

  @override
  String get catGifts => 'Поклони';

  @override
  String semanticsProjectionDate(String date) {
    return 'Датум пројекције $date. Двапут додирните за избор датума';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Пројектовано лично стање $amount';
  }

  @override
  String get statsEmptyTitle => 'Још нема трансакција';

  @override
  String get statsEmptySubtitle =>
      'Нема података о потрошњи за изабрани период.';

  @override
  String get semanticsShowProjections => 'Прикажи пројектована стања по рачуну';

  @override
  String get semanticsHideProjections => 'Сакриј пројектована стања по рачуну';

  @override
  String get semanticsDateAllTime =>
      'Датум: цело време — додирните за промену режима';

  @override
  String semanticsDateMode(String mode) {
    return 'Датум: $mode — додирните за промену режима';
  }

  @override
  String get semanticsDateThisMonth =>
      'Датум: овај месец — додирните за месец, недељу, годину или цело време';

  @override
  String get semanticsTxTypeCycle =>
      'Тип трансакције: све, приход, расход, пренос';

  @override
  String get semanticsAccountFilter => 'Филтер рачуна';

  @override
  String get semanticsAlreadyFiltered => 'Већ филтрирано на овај рачун';

  @override
  String get semanticsCategoryFilter => 'Филтер категорије';

  @override
  String get semanticsSortToggle => 'Сортирање: најновије или најстарије прво';

  @override
  String get semanticsFiltersDisabled =>
      'Филтери листе су онемогућени док гледате будући датум пројекције. Уклоните пројекције да користите филтере.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Филтери листе су онемогућени. Прво додајте налог.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Филтери листе су онемогућени. Прво додајте планирану трансакцију.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Филтери листе су онемогућени. Прво евидентирајте трансакцију.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Контроле за одељак и валуту су онемогућене. Прво додајте налог.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Датум пројекције и детаљи стања су онемогућени. Прво додајте налог и планирану трансакцију.';

  @override
  String get semanticsReorderAccountHint =>
      'Дуги притисак, затим превуците да промените редослед у овој групи';

  @override
  String get semanticsChartStyle => 'Стил графикона';

  @override
  String get semanticsChartStyleUnavailable =>
      'Стил графикона (недоступно у режиму поређења)';

  @override
  String semanticsPeriod(String label) {
    return 'Период: $label';
  }

  @override
  String get trackSearchHint => 'Претрага описа, категорије, рачуна…';

  @override
  String get trackSearchClear => 'Обриши претрагу';

  @override
  String get settingsExchangeRatesTitle => 'Курсна листа';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Посљедње ажурирање: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Користе се уграђени или кеширани курсеви — додирните за освјежавање';

  @override
  String get settingsExchangeRatesSource => 'ЕЦБ';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Курсна листа ажурирана';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Није могуће ажурирати курсну листу. Проверите везу.';

  @override
  String get settingsClearData => 'Брисање података';

  @override
  String get settingsClearDataSubtitle => 'Трајно уклони одабране податке';

  @override
  String get clearDataTitle => 'Брисање података';

  @override
  String get clearDataTransactions => 'Историја трансакција';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count трансакција · стања рачуна се постављају на нулу';
  }

  @override
  String get clearDataPlanned => 'Планиране трансакције';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count планираних ставки';
  }

  @override
  String get clearDataAccounts => 'Рачуни';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count рачуна · брише и историју и план';
  }

  @override
  String get clearDataCategories => 'Категорије';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count категорија · замењује се подразумеваним';
  }

  @override
  String get clearDataPreferences => 'Подешавања';

  @override
  String get clearDataPreferencesSubtitle =>
      'Враћа валуту, тему и језик на подразумеване вредности';

  @override
  String get clearDataSecurity => 'Закључавање и ПИН';

  @override
  String get clearDataSecuritySubtitle => 'Искључује закључавање и брише ПИН';

  @override
  String get clearDataConfirmButton => 'Обриши одабрано';

  @override
  String get clearDataConfirmTitle => 'Ова радња се не може поништити';

  @override
  String get clearDataConfirmBody =>
      'Одабрани подаци биће трајно обрисани. Направите бацкуп ако ће вам требати.';

  @override
  String get clearDataTypeConfirm => 'Упишите DELETE за потврду';

  @override
  String get clearDataTypeConfirmError =>
      'Упишите DELETE тачно како бисте наставили';

  @override
  String get clearDataPinTitle => 'Потврдите ПИН-ом';

  @override
  String get clearDataPinBody => 'Унесите ПИН апликације за ауторизацију.';

  @override
  String get clearDataPinIncorrect => 'Погрешан ПИН';

  @override
  String get clearDataDone => 'Одабрани подаци су обрисани';

  @override
  String get autoBackupTitle => 'Аутоматска дневна резервна копија';

  @override
  String autoBackupLastAt(String date) {
    return 'Последња копија $date';
  }

  @override
  String get autoBackupNeverRun => 'Још нема копије';

  @override
  String get autoBackupShareTitle => 'Сачувај у облак';

  @override
  String get autoBackupShareSubtitle =>
      'Пошаљи последњу копију на иЦлоуд Дриве, Гоогле Дриве или другу апликацију';

  @override
  String get autoBackupCloudReminder =>
      'Аутоматска копија је спремна — сачувајте је у облаку за заштиту ван уређаја';

  @override
  String get autoBackupCloudReminderAction => 'Подели';

  @override
  String get persistenceErrorReloaded =>
      'Чување није успело. Подаци су поново учитани.';
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
  String get cancel => 'Otkaži';

  @override
  String get delete => 'Obriši';

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
  String get heroIn => 'Ulaz';

  @override
  String get heroOut => 'Izlaz';

  @override
  String get heroNet => 'Neto';

  @override
  String get heroBalance => 'Stanje';

  @override
  String get realBalance => 'Stvarno stanje';

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
  String get fabScrollToTop => 'Back to top';

  @override
  String get filterAll => 'Sve';

  @override
  String get filterAllAccounts => 'Svi računi';

  @override
  String get filterAllCategories => 'Sve kategorije';

  @override
  String get txLabelIncome => 'PRIHOD';

  @override
  String get txLabelExpense => 'RASHOD';

  @override
  String get txLabelInvoice => 'FAKTURA';

  @override
  String get txLabelBill => 'RAČUN';

  @override
  String get txLabelAdvance => 'AVANS';

  @override
  String get txLabelSettlement => 'PORAVNANJE';

  @override
  String get txLabelLoan => 'ZAJAM';

  @override
  String get txLabelCollection => 'NAPLATA';

  @override
  String get txLabelOffset => 'PREBIJANJE';

  @override
  String get txLabelTransfer => 'PRENOS';

  @override
  String get txLabelTransaction => 'TRANSAKCIJA';

  @override
  String get repeatNone => 'Bez ponavljanja';

  @override
  String get repeatDaily => 'Dnevno';

  @override
  String get repeatWeekly => 'Nedeljno';

  @override
  String get repeatMonthly => 'Mesečno';

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
      few: '$count dana',
      one: 'dan',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nedelja',
      few: '$count nedelje',
      one: 'nedelju',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meseci',
      few: '$count meseca',
      one: 'mesec',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count godina',
      few: '$count godine',
      one: 'godinu',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Završava se';

  @override
  String get repeatEndNever => 'Nikad';

  @override
  String get repeatEndOnDate => 'Na datum';

  @override
  String repeatEndAfterCount(int count) {
    return 'Posle $count puta';
  }

  @override
  String get repeatEndAfterChoice => 'Posle određenog broja puta';

  @override
  String get repeatEndPickDate => 'Izaberite krajnji datum';

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
    return '$remaining od $total preostalo';
  }

  @override
  String get detailRepeatEvery => 'Ponavlja se svaki';

  @override
  String get detailEnds => 'Završava se';

  @override
  String get detailEndsNever => 'Nikad';

  @override
  String detailEndsOnDate(String date) {
    return 'Na $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Posle $count puta';
  }

  @override
  String get detailProgress => 'Napredak';

  @override
  String get weekendNoChange => 'Bez promene';

  @override
  String get weekendFriday => 'Pomeri na petak';

  @override
  String get weekendMonday => 'Pomeri na ponedeljak';

  @override
  String weekendQuestion(String day) {
    return 'Ako $day. padne na vikend?';
  }

  @override
  String get dateToday => 'Danas';

  @override
  String get dateTomorrow => 'Sutra';

  @override
  String get dateYesterday => 'Juče';

  @override
  String get statsAllTime => 'Celo vreme';

  @override
  String get accountGroupPersonal => 'Lično';

  @override
  String get accountGroupIndividual => 'Pojedinac';

  @override
  String get accountGroupEntity => 'Entitet';

  @override
  String get accountSectionIndividuals => 'Pojedinci';

  @override
  String get accountSectionEntities => 'Entiteti';

  @override
  String get emptyNoTransactionsYet => 'Nema transakcija';

  @override
  String get emptyNoAccountsYet => 'Nema računa';

  @override
  String get emptyRecordFirstTransaction =>
      'Dodirnite dugme ispod da zabeležite prvu transakciju.';

  @override
  String get emptyAddFirstAccountTx =>
      'Dodajte prvi račun pre evidentiranja transakcija.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Dodajte prvi račun pre planiranja transakcija.';

  @override
  String get emptyAddFirstAccountReview =>
      'Dodajte prvi račun za praćenje finansija.';

  @override
  String get emptyAddTransaction => 'Dodaj transakciju';

  @override
  String get emptyAddAccount => 'Dodaj račun';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Još nema ličnih računa';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Lični računi su vaši novčanici i bankovni računi. Dodajte jedan da pratite svakodnevni prihod i rashod.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'Još nema računa pojedinaca';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Računi pojedinaca prate novac sa određenim osobama—zajednički troškovi, pozajmice ili dugovanja. Dodajte račun za svaku osobu sa kojom se obračunavate.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Još nema računa entiteta';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Računi entiteta su za firme, projekte ili organizacije. Koristite ih da poslovni novčani tok odvojite od ličnih finansija.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Nema transakcija za primenjene filtere';

  @override
  String get emptyNoTransactionsInHistory => 'Nema transakcija u istoriji';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Nema transakcija za $month';
  }

  @override
  String get emptyNoTransactionsForAccount => 'Nema transakcija za ovaj račun';

  @override
  String get trackTransactionDeleted => 'Transakcija obrisana';

  @override
  String get trackDeleteTitle => 'Obrisati transakciju?';

  @override
  String get trackDeleteBody => 'Ovo će poništiti promene stanja na računima.';

  @override
  String get trackTransaction => 'Transakcija';

  @override
  String get planConfirmTitle => 'Potvrditi transakciju?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Ova stavka je zakazana za $date. Biće evidentirana u Istoriji sa današnjim datumom ($todayDate). Sledeća stavka ostaje na $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Ovo će primeniti transakciju na stvarna stanja računa i premestiti je u Istoriju.';

  @override
  String get planTransactionConfirmed => 'Transakcija potvrđena i primenjena';

  @override
  String get planTransactionRemoved => 'Planirana transakcija uklonjena';

  @override
  String get planRepeatingTitle => 'Transakcija koja se ponavlja';

  @override
  String get planRepeatingBody =>
      'Preskoči samo ovaj datum — serija se nastavlja sa sledećom stavkom — ili obriši sve preostale stavke iz plana.';

  @override
  String get planDeleteAll => 'Obriši sve';

  @override
  String get planSkipThisOnly => 'Preskoči samo ovu';

  @override
  String get planOccurrenceSkipped => 'Stavka preskočena — sledeća zakazana';

  @override
  String get planNothingPlanned => 'Ništa nije planirano';

  @override
  String get planPlanBody => 'Planirajte buduće transakcije.';

  @override
  String get planAddPlan => 'Dodaj plan';

  @override
  String get planNoPlannedForFilters =>
      'Nema planiranih transakcija za primenjene filtere';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Nema planiranih transakcija u $month';
  }

  @override
  String get planOverdue => 'isteklo';

  @override
  String get planPlannedTransaction => 'Planirana transakcija';

  @override
  String get discardTitle => 'Odbaciti izmene?';

  @override
  String get discardBody =>
      'Imate nesačuvane izmene. Biće izgubljene ako napustite ovu stranicu.';

  @override
  String get keepEditing => 'Nastavi uređivanje';

  @override
  String get discard => 'Odbaci';

  @override
  String get newTransactionTitle => 'Nova transakcija';

  @override
  String get editTransactionTitle => 'Izmeni transakciju';

  @override
  String get transactionUpdated => 'Transakcija ažurirana';

  @override
  String get sectionAccounts => 'Računi';

  @override
  String get labelFrom => 'Od';

  @override
  String get labelTo => 'Ka';

  @override
  String get sectionCategory => 'Kategorija';

  @override
  String get sectionAttachments => 'Prilozi';

  @override
  String get labelNote => 'Beleška';

  @override
  String get hintOptionalDescription => 'Opcioni opis';

  @override
  String get updateTransaction => 'Ažuriraj transakciju';

  @override
  String get saveTransaction => 'Sačuvaj transakciju';

  @override
  String get selectAccount => 'Izaberite račun';

  @override
  String get selectAccountTitle => 'Izaberite račun';

  @override
  String get noAccountsAvailable => 'Nema dostupnih računa';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Iznos primljen od $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Unesite tačan iznos koji prima odredišni račun. Ovo zaključava korišćeni kurs.';

  @override
  String get attachTakePhoto => 'Slikaj';

  @override
  String get attachTakePhotoSub => 'Koristite kameru za snimanje računa';

  @override
  String get attachChooseGallery => 'Izaberi iz galerije';

  @override
  String get attachChooseGallerySub => 'Izaberite fotografije iz biblioteke';

  @override
  String get attachBrowseFiles => 'Pregledaj fajlove';

  @override
  String get attachBrowseFilesSub =>
      'Priložite PDF-ove, dokumente ili druge fajlove';

  @override
  String get attachButton => 'Priloži';

  @override
  String get editPlanTitle => 'Izmeni plan';

  @override
  String get planTransactionTitle => 'Planiraj transakciju';

  @override
  String get tapToSelect => 'Dodirnite za izbor';

  @override
  String get updatePlan => 'Ažuriraj plan';

  @override
  String get addToPlan => 'Dodaj u plan';

  @override
  String get labelRepeat => 'Ponavljanje';

  @override
  String get selectPlannedDate => 'Izaberite planirani datum';

  @override
  String get balancesAsOfToday => 'Stanja na današnji dan';

  @override
  String get projectedBalancesForTomorrow => 'Projektovana stanja za sutra';

  @override
  String projectedBalancesForDate(String date) {
    return 'Projektovana stanja za $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name prima ($currency)';
  }

  @override
  String get destHelper =>
      'Procenjeni odredišni iznos. Tačan kurs se zaključava pri potvrdi.';

  @override
  String get descriptionOptional => 'Opis (opciono)';

  @override
  String get detailTransactionTitle => 'Transakcija';

  @override
  String get detailPlannedTitle => 'Planirano';

  @override
  String get detailConfirmTransaction => 'Potvrdi transakciju';

  @override
  String get detailDate => 'Datum';

  @override
  String get detailFrom => 'Od';

  @override
  String get detailTo => 'Ka';

  @override
  String get detailCategory => 'Kategorija';

  @override
  String get detailNote => 'Beleška';

  @override
  String get detailDestinationAmount => 'Odredišni iznos';

  @override
  String get detailExchangeRate => 'Kurs';

  @override
  String get detailRepeats => 'Ponavlja se';

  @override
  String get detailDayOfMonth => 'Dan u mesecu';

  @override
  String get detailWeekends => 'Vikendi';

  @override
  String get detailAttachments => 'Prilozi';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fajlova',
      few: '$count fajla',
      one: '1 fajl',
    );
    return '$_temp0';
  }

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
  String get settingsSectionPreferences => 'Podešavanja';

  @override
  String get settingsSectionManage => 'Upravljanje';

  @override
  String get settingsBaseCurrency => 'Osnovna valuta';

  @override
  String get settingsSecondaryCurrency => 'Sekundarna valuta';

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
  String get settingsSectionData => 'Podaci';

  @override
  String get settingsSectionPrivacy => 'O aplikaciji';

  @override
  String get settingsPrivacyPolicyTitle => 'Politika privatnosti';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Kako Platrare tretira vaše podatke.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Kursna lista: aplikacija preuzima javne kurseve preko interneta. Vaši računi i transakcije se ne šalju.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Nije moguće učitati politiku privatnosti.';

  @override
  String get settingsPrivacyRetry => 'Pokušaj ponovo';

  @override
  String get settingsSoftwareVersionTitle => 'Verzija softvera';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Izdanje, dijagnostika i pravni dokumenti';

  @override
  String get aboutScreenTitle => 'O aplikaciji';

  @override
  String get aboutAppTagline =>
      'Knjiga, novčani tok i planiranje na jednom mestu.';

  @override
  String get aboutDescriptionBody =>
      'Platrare čuva račune, transakcije i planove na vašem uređaju. Šifrovane rezervne kopije izvezite kada vam treba kopija i drugde. Kursna lista koristi samo javne podatke; vaša knjiga se ne otprema.';

  @override
  String get aboutVersionLabel => 'Verzija';

  @override
  String get aboutBuildLabel => 'Build';

  @override
  String get aboutCopySupportDetails => 'Kopiraj podatke za podršku';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Otvara pun tekst politike u aplikaciji.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Lokalizacija';

  @override
  String get settingsSupportInfoCopied => 'Kopirano u ostavu';

  @override
  String get settingsVerifyLedger => 'Provjeri podatke';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Provjeri da li se stanja računa poklapaju s istorijom transakcija';

  @override
  String get settingsDataExportTitle => 'Izvezi rezervnu kopiju';

  @override
  String get settingsDataExportSubtitle =>
      'Sačuvaj kao .zip ili šifrovani .platrare sa svim podacima i prilozima';

  @override
  String get settingsDataImportTitle => 'Vrati iz rezervne kopije';

  @override
  String get settingsDataImportSubtitle =>
      'Zamijeni trenutne podatke iz Platrare .zip ili .platrare fajla';

  @override
  String get backupExportDialogTitle => 'Zaštitite ovu rezervnu kopiju';

  @override
  String get backupExportDialogBody =>
      'Preporučena je jaka lozinka, posebno ako čuvate fajl u oblaku. Ista lozinka je potrebna za uvoz.';

  @override
  String get backupExportPasswordLabel => 'Lozinka';

  @override
  String get backupExportPasswordConfirmLabel => 'Potvrdi lozinku';

  @override
  String get backupExportPasswordMismatch => 'Lozinke se ne poklapaju';

  @override
  String get backupExportPasswordEmpty =>
      'Unesite podudarajuće lozinke ili izvezite bez šifrovanja ispod.';

  @override
  String get backupExportPasswordTooShort =>
      'Lozinka mora imati najmanje 8 znakova.';

  @override
  String get backupExportSaveToDevice => 'Sačuvaj na uređaju';

  @override
  String get backupExportShareToCloud => 'Podijeli (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Izvezi bez šifrovanja';

  @override
  String get backupExportSkipWarningTitle => 'Izvesti bez šifrovanja?';

  @override
  String get backupExportSkipWarningBody =>
      'Svako ko ima pristup fajlu može pročitati podatke. Koristite samo za lokalne kopije koje kontrolišete.';

  @override
  String get backupExportSkipWarningConfirm => 'Izvezi nešifrovano';

  @override
  String get backupImportPasswordTitle => 'Šifrovana rezerva';

  @override
  String get backupImportPasswordBody =>
      'Unesite lozinku koju ste koristili pri izvozu.';

  @override
  String get backupImportPasswordLabel => 'Lozinka';

  @override
  String get backupImportPreviewTitle => 'Pregled rezerve';

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
    return '$accounts računa · $transactions transakcija · $planned planiranih · $attachments priloga · $income kategorija prihoda · $expense kategorija rashoda';
  }

  @override
  String get backupImportPreviewContinue => 'Dalje';

  @override
  String get settingsBackupWrongPassword => 'Pogrešna lozinka';

  @override
  String get settingsBackupChecksumMismatch =>
      'Provera integriteta rezerve nije uspela';

  @override
  String get settingsBackupCorruptFile => 'Nevažeći ili oštećen fajl rezerve';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Rezerva zahteva noviju verziju aplikacije';

  @override
  String get settingsDataImportConfirmTitle => 'Zamijeniti trenutne podatke?';

  @override
  String get settingsDataImportConfirmBody =>
      'Ovo će zameniti vaše trenutne račune, transakcije, planirane transakcije, kategorije i uvezene priloge sadržajem iz izabrane rezerve. Ovu radnju nije moguće poništiti.';

  @override
  String get settingsDataImportConfirmAction => 'Zamijeni podatke';

  @override
  String get settingsDataImportDone => 'Podaci su uspješno vraćeni';

  @override
  String get settingsDataImportInvalidFile =>
      'Izabrani fajl nije validna Platrare rezervna kopija';

  @override
  String get settingsDataImportFailed => 'Uvoz nije uspeo';

  @override
  String get settingsDataExportDoneTitle => 'Rezervna kopija je izvezena';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Rezervna kopija je sačuvana na:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Otvori fajl';

  @override
  String get settingsDataExportFailed => 'Izvoz nije uspeo';

  @override
  String get ledgerVerifyDialogTitle => 'Provera knjige';

  @override
  String get ledgerVerifyAllMatch => 'Sva stanja se poklapaju.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Razlike';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nSačuvano: $stored\nPonovo: $replayed\nRazlika: $diff';
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
  String get settingsSectionAppearance => 'Izgled';

  @override
  String get settingsSectionSecurity => 'Sigurnost';

  @override
  String get settingsSecurityEnableLock => 'Zaključaj aplikaciju pri otvaranju';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Traži biometriju ili PIN kada se aplikacija otvori';

  @override
  String get settingsSecuritySetPin => 'Postavi PIN';

  @override
  String get settingsSecurityChangePin => 'Promeni PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Koristi PIN kao rezervu ako biometrija nije dostupna';

  @override
  String get settingsSecurityRemovePin => 'Ukloni PIN';

  @override
  String get securitySetPinTitle => 'Postavi PIN aplikacije';

  @override
  String get securityPinLabel => 'PIN kod';

  @override
  String get securityConfirmPinLabel => 'Potvrdi PIN kod';

  @override
  String get securityPinMustBe4Digits => 'PIN mora imati najmanje 4 cifre';

  @override
  String get securityPinMismatch => 'PIN kodovi se ne poklapaju';

  @override
  String get securityRemovePinTitle => 'Ukloniti PIN?';

  @override
  String get securityRemovePinBody =>
      'Biometrijsko otključavanje i dalje može da se koristi ako je dostupno.';

  @override
  String get securityUnlockTitle => 'Aplikacija je zaključana';

  @override
  String get securityUnlockSubtitle =>
      'Otključaj pomoću Face ID-a, otiska prsta ili PIN-a.';

  @override
  String get securityUnlockWithPin => 'Otključaj PIN-om';

  @override
  String get securityTryBiometric => 'Pokušaj biometrijsko otključavanje';

  @override
  String get securityPinIncorrect => 'Pogrešan PIN, pokušaj ponovo';

  @override
  String get securityBiometricReason =>
      'Potvrdi identitet za otvaranje aplikacije';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitleSystem => 'Prati podešavanja sistema';

  @override
  String get settingsThemeSubtitleLight => 'Svetla';

  @override
  String get settingsThemeSubtitleDark => 'Tamna';

  @override
  String get settingsThemePickerTitle => 'Tema';

  @override
  String get settingsThemeOptionSystem => 'Podrazumevano (sistem)';

  @override
  String get settingsThemeOptionLight => 'Svetla';

  @override
  String get settingsThemeOptionDark => 'Tamna';

  @override
  String get archivedAccountsTitle => 'Arhivirani računi';

  @override
  String get archivedAccountsEmptyTitle => 'Nema arhiviranih računa';

  @override
  String get archivedAccountsEmptyBody =>
      'Knjigovodstveni saldo i prekoračenje moraju biti nula; arhiviranje je u opcijama računa u Pregledu.';

  @override
  String get categoriesTitle => 'Kategorije';

  @override
  String get newCategoryTitle => 'Nova kategorija';

  @override
  String get categoryNameLabel => 'Naziv kategorije';

  @override
  String get deleteCategoryTitle => 'Obrisati kategoriju?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" će biti uklonjena sa liste.';
  }

  @override
  String get categoryIncome => 'Prihod';

  @override
  String get categoryExpense => 'Rashod';

  @override
  String get categoryAdd => 'Dodaj';

  @override
  String get searchCurrencies => 'Pretraži valute…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1G';

  @override
  String get periodAll => 'SVE';

  @override
  String get categoryLabel => 'kategorija';

  @override
  String get categoriesLabel => 'kategorije';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type — sačuvano  •  $amount';
  }

  @override
  String get tooltipSettings => 'Podešavanja';

  @override
  String get tooltipAddAccount => 'Dodaj račun';

  @override
  String get tooltipRemoveAccount => 'Ukloni račun';

  @override
  String get accountNameTaken =>
      'Račun sa ovim imenom i identifikatorom već postoji (aktivan ili arhiviran). Promenite naziv ili identifikator.';

  @override
  String get groupDescPersonal => 'Vaši novčanici i bankovni računi';

  @override
  String get groupDescIndividuals => 'Porodica, prijatelji, pojedinci';

  @override
  String get groupDescEntities => 'Entiteti, komunalije, organizacije';

  @override
  String get cannotArchiveTitle => 'Arhiviranje nije moguće';

  @override
  String get cannotArchiveBody =>
      'Arhiviranje je dostupno samo kada su stanje i limit prekoračenja na nuli.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Arhiviranje je dostupno samo kada su stanje i limit prekoračenja na nuli. Prvo podesite knjiženje ili limit.';

  @override
  String get archiveAccountTitle => 'Arhivirati račun?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planiranih transakcija koristi ovaj račun.',
      few: '$count planirane transakcije koriste ovaj račun.',
      one: '1 planirana transakcija koristi ovaj račun.',
    );
    return '$_temp0 Uklonite ih da plan bude usklađen sa arhiviranim računom.';
  }

  @override
  String get removeAndArchive => 'Ukloni planirane i arhiviraj';

  @override
  String get archiveBody =>
      'Račun će biti sakriven iz Pregleda, Evidencije i biranja. Možete ga vratiti iz Podešavanja.';

  @override
  String get archiveAction => 'Arhiviraj';

  @override
  String get archiveInstead => 'Arhiviraj umesto toga';

  @override
  String get cannotDeleteTitle => 'Brisanje nije moguće';

  @override
  String get cannotDeleteBodyShort =>
      'Ovaj račun se pojavljuje u Evidenciji. Uklonite ili preraspodelite te transakcije, ili arhivirajte račun ako je stanje raščišćeno.';

  @override
  String get cannotDeleteBodyHistory =>
      'Ovaj račun se pojavljuje u Evidenciji. Brisanje bi narušilo istoriju — uklonite ili preraspodelite te transakcije.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Ovaj račun se pojavljuje u Evidenciji i ne može se obrisati. Možete ga arhivirati ako su stanje i limit prekoračenja na nuli — biće sakriven sa lista ali istorija ostaje netaknuta.';

  @override
  String get deleteAccountTitle => 'Obrisati račun?';

  @override
  String get deleteAccountBodyPermanent =>
      'Ovaj račun će biti trajno uklonjen.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count planiranih transakcija koristi ovaj račun i biće takođe obrisane.',
      few:
          '$count planirane transakcije koriste ovaj račun i biće takođe obrisane.',
      one: '1 planirana transakcija koristi ovaj račun i biće takođe obrisana.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Obriši sve';

  @override
  String get editAccountTitle => 'Izmeni račun';

  @override
  String get newAccountTitle => 'Novi račun';

  @override
  String get labelAccountName => 'Naziv računa';

  @override
  String get labelAccountIdentifier => 'Identifikator (opciono)';

  @override
  String get accountAppearanceSection => 'Ikonica i boja';

  @override
  String get accountPickIcon => 'Izaberi ikonicu';

  @override
  String get accountPickColor => 'Izaberi boju';

  @override
  String get accountIconSheetTitle => 'Ikonica računa';

  @override
  String get accountColorSheetTitle => 'Boja računa';

  @override
  String get accountUseInitialLetter => 'Inicijal';

  @override
  String get accountUseDefaultColor => 'Kao grupa';

  @override
  String get labelRealBalance => 'Stvarno stanje';

  @override
  String get labelOverdraftLimit => 'Limit prekoračenja / avansa';

  @override
  String get labelCurrency => 'Valuta';

  @override
  String get saveChanges => 'Sačuvaj izmene';

  @override
  String get addAccountAction => 'Dodaj račun';

  @override
  String get removeAccountSheetTitle => 'Ukloni račun';

  @override
  String get deletePermanently => 'Trajno obriši';

  @override
  String get deletePermanentlySubtitle =>
      'Moguće samo kada se račun ne koristi u Evidenciji. Planirane stavke se mogu ukloniti pri brisanju.';

  @override
  String get archiveOptionSubtitle =>
      'Sakrij iz Pregleda i biranja. Vrati bilo kada iz Podešavanja. Zahteva nulto stanje i limit.';

  @override
  String get archivedBannerText =>
      'Ovaj račun je arhiviran. Ostaje u vašim podacima ali je sakriven sa lista i iz biranja.';

  @override
  String get balanceAdjustedTitle => 'Stanje podešeno u Evidenciji';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Stvarno stanje je ažurirano sa $previous na $current $symbol.\n\nTransakcija za podešavanje stanja je kreirana u Evidenciji (Istorija) radi konzistentnosti knjiženja.\n\n• Stvarno stanje odražava stvarni iznos na ovom računu.\n• Proverite Istoriju za stavku podešavanja.';
  }

  @override
  String get ok => 'U redu';

  @override
  String get categoryBalanceAdjustment => 'Korekcija stanja';

  @override
  String get descriptionBalanceCorrection => 'Korekcija bilansa';

  @override
  String get descriptionOpeningBalance => 'Početno stanje';

  @override
  String get reviewStatsModeStatistics => 'Statistika';

  @override
  String get reviewStatsModeComparison => 'Poređenje';

  @override
  String get statsUncategorized => 'Nekategorisano';

  @override
  String get statsNoCategories =>
      'Nema kategorija u izabranim periodima za poređenje.';

  @override
  String get statsNoTransactions => 'Nema transakcija';

  @override
  String get statsSpendingInCategory => 'Potrošnja u ovoj kategoriji';

  @override
  String get statsIncomeInCategory => 'Prihod u ovoj kategoriji';

  @override
  String get statsDifference => 'Razlika (B vs A): ';

  @override
  String get statsNoExpensesMonth => 'Nema rashoda ovog meseca';

  @override
  String get statsNoExpensesAll => 'Nema evidentiranih rashoda';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Nema rashoda u poslednjih $period';
  }

  @override
  String get statsTotalSpent => 'Ukupno potrošeno';

  @override
  String get statsNoExpensesThisPeriod => 'Nema rashoda u ovom periodu';

  @override
  String get statsNoIncomeMonth => 'Nema prihoda ovog meseca';

  @override
  String get statsNoIncomeAll => 'Nema evidentiranih prihoda';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Nema prihoda u poslednjih $period';
  }

  @override
  String get statsTotalReceived => 'Ukupno primljeno';

  @override
  String get statsNoIncomeThisPeriod => 'Nema prihoda u ovom periodu';

  @override
  String get catSalary => 'Plata';

  @override
  String get catFreelance => 'Slobodni posao';

  @override
  String get catConsulting => 'Konsalting';

  @override
  String get catGift => 'Poklon';

  @override
  String get catRental => 'Iznajmljivanje';

  @override
  String get catDividends => 'Dividende';

  @override
  String get catRefund => 'Povrat';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catInterest => 'Kamata';

  @override
  String get catSideHustle => 'Dopunski posao';

  @override
  String get catSaleOfGoods => 'Prodaja robe';

  @override
  String get catOther => 'Ostalo';

  @override
  String get catGroceries => 'Namirnice';

  @override
  String get catDining => 'Ishrana';

  @override
  String get catTransport => 'Prevoz';

  @override
  String get catUtilities => 'Komunalije';

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
  String get catGym => 'Teretana';

  @override
  String get catPets => 'Kućni ljubimci';

  @override
  String get catKids => 'Deca';

  @override
  String get catCharity => 'Dobročinstvo';

  @override
  String get catCoffee => 'Kafa';

  @override
  String get catGifts => 'Pokloni';

  @override
  String semanticsProjectionDate(String date) {
    return 'Datum projekcije $date. Dvaput dodirnite za izbor datuma';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Projektovano lično stanje $amount';
  }

  @override
  String get statsEmptyTitle => 'Još nema transakcija';

  @override
  String get statsEmptySubtitle =>
      'Nema podataka o potrošnji za izabrani period.';

  @override
  String get semanticsShowProjections =>
      'Prikaži projektovana stanja po računu';

  @override
  String get semanticsHideProjections => 'Sakrij projektovana stanja po računu';

  @override
  String get semanticsDateAllTime =>
      'Datum: celo vreme — dodirnite za promenu režima';

  @override
  String semanticsDateMode(String mode) {
    return 'Datum: $mode — dodirnite za promenu režima';
  }

  @override
  String get semanticsDateThisMonth =>
      'Datum: ovaj mesec — dodirnite za mesec, nedelju, godinu ili celo vreme';

  @override
  String get semanticsTxTypeCycle =>
      'Tip transakcije: sve, prihod, rashod, prenos';

  @override
  String get semanticsAccountFilter => 'Filter računa';

  @override
  String get semanticsAlreadyFiltered => 'Već filtrirano na ovaj račun';

  @override
  String get semanticsCategoryFilter => 'Filter kategorije';

  @override
  String get semanticsSortToggle => 'Sortiranje: najnovije ili najstarije prvo';

  @override
  String get semanticsFiltersDisabled =>
      'Filteri liste su onemogućeni dok gledate budući datum projekcije. Uklonite projekcije da koristite filtere.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Filteri liste su onemogućeni. Prvo dodajte nalog.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Filteri liste su onemogućeni. Prvo dodajte planiranu transakciju.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Filteri liste su onemogućeni. Prvo evidentirajte transakciju.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Kontrole za odeljak i valutu su onemogućene. Prvo dodajte nalog.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Datum projekcije i detalji stanja su onemogućeni. Prvo dodajte nalog i planiranu transakciju.';

  @override
  String get semanticsReorderAccountHint =>
      'Dugi pritisak, zatim prevucite da promenite redosled u ovoj grupi';

  @override
  String get semanticsChartStyle => 'Stil grafikona';

  @override
  String get semanticsChartStyleUnavailable =>
      'Stil grafikona (nedostupno u režimu poređenja)';

  @override
  String semanticsPeriod(String label) {
    return 'Period: $label';
  }

  @override
  String get trackSearchHint => 'Pretraga opisa, kategorije, računa…';

  @override
  String get trackSearchClear => 'Obriši pretragu';

  @override
  String get settingsExchangeRatesTitle => 'Kursna lista';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Posljednje ažuriranje: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Koriste se ugrađeni ili keširani kursevi — dodirnite za osvježavanje';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Kursna lista ažurirana';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Nije moguće ažurirati kursnu listu. Proverite vezu.';

  @override
  String get settingsClearData => 'Brisanje podataka';

  @override
  String get settingsClearDataSubtitle => 'Trajno ukloni odabrane podatke';

  @override
  String get clearDataTitle => 'Brisanje podataka';

  @override
  String get clearDataTransactions => 'Istorija transakcija';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transakcija · stanja računa se postavljaju na nulu';
  }

  @override
  String get clearDataPlanned => 'Planirane transakcije';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count planiranih stavki';
  }

  @override
  String get clearDataAccounts => 'Računi';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count računa · briše i istoriju i plan';
  }

  @override
  String get clearDataCategories => 'Kategorije';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count kategorija · zamenjuje se podrazumevanim';
  }

  @override
  String get clearDataPreferences => 'Podešavanja';

  @override
  String get clearDataPreferencesSubtitle =>
      'Vraća valutu, temu i jezik na podrazumevane vrednosti';

  @override
  String get clearDataSecurity => 'Zaključavanje i PIN';

  @override
  String get clearDataSecuritySubtitle =>
      'Isključuje zaključavanje i briše PIN';

  @override
  String get clearDataConfirmButton => 'Obriši odabrano';

  @override
  String get clearDataConfirmTitle => 'Ova radnja se ne može poništiti';

  @override
  String get clearDataConfirmBody =>
      'Odabrani podaci biće trajno obrisani. Napravite backup ako će vam trebati.';

  @override
  String get clearDataTypeConfirm => 'Upišite DELETE za potvrdu';

  @override
  String get clearDataTypeConfirmError =>
      'Upišite DELETE tačno kako biste nastavili';

  @override
  String get clearDataPinTitle => 'Potvrdite PIN-om';

  @override
  String get clearDataPinBody => 'Unesite PIN aplikacije za autorizaciju.';

  @override
  String get clearDataPinIncorrect => 'Pogrešan PIN';

  @override
  String get clearDataDone => 'Odabrani podaci su obrisani';

  @override
  String get autoBackupTitle => 'Automatska dnevna rezervna kopija';

  @override
  String autoBackupLastAt(String date) {
    return 'Poslednja kopija $date';
  }

  @override
  String get autoBackupNeverRun => 'Još nema kopije';

  @override
  String get autoBackupShareTitle => 'Sačuvaj u oblak';

  @override
  String get autoBackupShareSubtitle =>
      'Pošalji poslednju kopiju na iCloud Drive, Google Drive ili drugu aplikaciju';

  @override
  String get autoBackupCloudReminder =>
      'Automatska kopija je spremna — sačuvajte je u oblaku za zaštitu van uređaja';

  @override
  String get autoBackupCloudReminderAction => 'Podeli';

  @override
  String get persistenceErrorReloaded =>
      'Čuvanje nije uspelo. Podaci su ponovo učitani.';
}
