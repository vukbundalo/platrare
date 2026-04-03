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
  String get filterClearFilters => 'Ukloni filtere';

  @override
  String get filterClearProjections => 'Ukloni projekcije';

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
      'Kada arhivirate račun u Pregledu, pojaviće se ovde. Uvek ga možete vratiti.';

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
  String get tooltipSettings => 'Podešavanja';

  @override
  String get tooltipAddAccount => 'Dodaj račun';

  @override
  String get tooltipRemoveAccount => 'Ukloni račun';

  @override
  String get accountNameTaken =>
      'Račun sa ovim imenom već postoji (aktivan ili arhiviran). Izaberite drugi naziv.';

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
  String get semanticsChartStyle => 'Stil grafikona';

  @override
  String get semanticsChartStyleUnavailable =>
      'Stil grafikona (nedostupno u režimu poređenja)';

  @override
  String semanticsPeriod(String label) {
    return 'Period: $label';
  }
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
  String get filterClearFilters => 'Ukloni filtere';

  @override
  String get filterClearProjections => 'Ukloni projekcije';

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
      'Kada arhivirate račun u Pregledu, pojaviće se ovde. Uvek ga možete vratiti.';

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
  String get tooltipSettings => 'Podešavanja';

  @override
  String get tooltipAddAccount => 'Dodaj račun';

  @override
  String get tooltipRemoveAccount => 'Ukloni račun';

  @override
  String get accountNameTaken =>
      'Račun sa ovim imenom već postoji (aktivan ili arhiviran). Izaberite drugi naziv.';

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
  String get semanticsChartStyle => 'Stil grafikona';

  @override
  String get semanticsChartStyleUnavailable =>
      'Stil grafikona (nedostupno u režimu poređenja)';

  @override
  String semanticsPeriod(String label) {
    return 'Period: $label';
  }
}
