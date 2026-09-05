// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Plan';

  @override
  String get navTrack => 'Spoor';

  @override
  String get navReview => 'Beoordeling';

  @override
  String get cancel => 'Annuleren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get close => 'Dichtbij';

  @override
  String get add => 'Toevoegen';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get restore => 'Herstellen';

  @override
  String get heroIn => 'In';

  @override
  String get heroOut => 'Uit';

  @override
  String get heroNet => 'Netto';

  @override
  String get widgetLowestPoint => 'Laagste punt';

  @override
  String get widgetProjected => 'Prognose';

  @override
  String get widgetHorizonIn7Days => 'Over 7 dagen';

  @override
  String get widgetHorizonEndOfMonth => 'Einde maand';

  @override
  String get widgetMetricAccount => 'Rekeningsaldo';

  @override
  String get widgetQuickAdd => 'Snel toevoegen';

  @override
  String get widgetStale => 'Mogelijk verouderd';

  @override
  String get widgetOpenToStart => 'Open Platrare om rekeningen toe te voegen';

  @override
  String get widgetDueToday => 'Vandaag verschuldigd';

  @override
  String get widgetDescQuickAdd =>
      'Voeg met één tik een transactie of plan toe.';

  @override
  String get widgetNameNumbers => 'Saldo';

  @override
  String get widgetDescNumbers =>
      'Toon één getal: besteedbaar, nettowaarde of je laagste punt deze maand.';

  @override
  String get widgetConfigMetric => 'Waarde';

  @override
  String get widgetConfigHorizon => 'Horizon';

  @override
  String widgetSiriAddTransaction(String appName) {
    return 'Een transactie toevoegen in $appName';
  }

  @override
  String widgetSiriAddPlanned(String appName) {
    return 'Een geplande transactie toevoegen in $appName';
  }

  @override
  String get settingsWidgetAmountsTitle => 'Bedragen tonen in widgets';

  @override
  String get settingsWidgetAmountsSubtitle =>
      'Widgets op het beginscherm zijn zichtbaar zonder de app te ontgrendelen. Met appvergrendeling aan blijven bedragen verborgen, tenzij je dit inschakelt.';

  @override
  String get heroBalance => 'Evenwicht';

  @override
  String get realBalance => 'Echt evenwicht';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Saldi verbergen in overzichtskaarten';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Wanneer ingeschakeld, blijven de bedragen in Plan, Bijhouden en Overzicht gemaskeerd totdat u op het oogpictogram op elk tabblad tikt. Wanneer uitgeschakeld, zijn saldi altijd zichtbaar.';

  @override
  String get heroBalancesShow => 'Saldi weergeven';

  @override
  String get heroBalancesHide => 'Saldi verbergen';

  @override
  String get semanticsHeroBalanceHidden => 'Saldo verborgen voor privacy';

  @override
  String get heroResetButton => 'Opnieuw instellen';

  @override
  String get fabScrollToTop => 'Terug naar boven';

  @override
  String get fabPickProjectionDate => 'Projectiedatum kiezen';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterAllAccounts => 'Alle rekeningen';

  @override
  String get filterAllCategories => 'Alle categorieën';

  @override
  String get txLabelIncome => 'INKOMEN';

  @override
  String get txLabelExpense => 'KOSTEN';

  @override
  String get txLabelInvoice => 'FACTUUR';

  @override
  String get txLabelBill => 'REKENING';

  @override
  String get txLabelAdvance => 'VOORSCHOT';

  @override
  String get txLabelSettlement => 'AFREKENING';

  @override
  String get txLabelLoan => 'LENING';

  @override
  String get txLabelCollection => 'INNING';

  @override
  String get txLabelOffset => 'VERREKENING';

  @override
  String get txLabelTransfer => 'OVERBOEKING';

  @override
  String get txLabelTransaction => 'TRANSACTIE';

  @override
  String get repeatNone => 'Niet herhalen';

  @override
  String get repeatDaily => 'Dagelijks';

  @override
  String get repeatWeekly => 'Wekelijks';

  @override
  String get repeatMonthly => 'Maandelijks';

  @override
  String get repeatYearly => 'Jaarlijks';

  @override
  String get repeatEveryLabel => 'Elke';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: 'dag',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weken',
      one: 'week',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count maanden',
      one: 'maand',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jaar',
      one: 'jaar',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Eindigt';

  @override
  String get repeatEndNever => 'Nooit';

  @override
  String get repeatEndOnDate => 'Op datum';

  @override
  String repeatEndAfterCount(int count) {
    return 'Na $count keer';
  }

  @override
  String get repeatEndAfterChoice => 'Na een aantal keer';

  @override
  String get repeatEndPickDate => 'Kies einddatum';

  @override
  String get repeatEndTimes => 'keer';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Elke $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'tot $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count keer';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining van $total resterend';
  }

  @override
  String get detailRepeatEvery => 'Herhaal elke';

  @override
  String get detailEnds => 'Eindigt';

  @override
  String get detailEndsNever => 'Nooit';

  @override
  String detailEndsOnDate(String date) {
    return 'Op $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Na $count keer';
  }

  @override
  String get detailProgress => 'Voortgang';

  @override
  String get weekendNoChange => 'Niet verplaatsen';

  @override
  String get weekendFriday => 'Naar vrijdag';

  @override
  String get weekendMonday => 'Naar maandag';

  @override
  String weekendQuestion(String day) {
    return 'Als de $day in het weekend valt?';
  }

  @override
  String get dateToday => 'Vandaag';

  @override
  String get dateTomorrow => 'Morgen';

  @override
  String get dateYesterday => 'Gisteren';

  @override
  String get statsAllTime => 'Altijd';

  @override
  String get accountGroupPersonal => 'Persoonlijk';

  @override
  String get accountGroupIndividual => 'Persoon';

  @override
  String get accountGroupEntity => 'Organisatie';

  @override
  String get accountSectionIndividuals => 'Personen';

  @override
  String get accountSectionEntities => 'Organisaties';

  @override
  String get emptyNoTransactionsYet => 'Nog geen transacties';

  @override
  String get emptyNoAccountsYet => 'Nog geen rekeningen';

  @override
  String get emptyRecordFirstTransaction =>
      'Tik op de knop hieronder om je eerste transactie vast te leggen.';

  @override
  String get emptyAddFirstAccountTx =>
      'Voeg eerst een rekening toe voordat je transacties vastlegt.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Voeg eerst een rekening toe voordat je transacties plant.';

  @override
  String get emptyAddFirstAccountReview =>
      'Voeg je eerste rekening toe om je financiën bij te houden.';

  @override
  String get emptyAddTransaction => 'Transactie toevoegen';

  @override
  String get emptyAddAccount => 'Rekening toevoegen';

  @override
  String get reviewEmptyGroupPersonalTitle =>
      'Nog geen persoonlijke rekeningen';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Persoonlijke rekeningen zijn je eigen portemonnees en bankrekeningen. Voeg er een toe om dagelijkse inkomsten en uitgaven bij te houden.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'Nog geen persoonsrekeningen';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Persoonsrekeningen volgen geld met specifieke mensen: gedeelde kosten, leningen of schuldbekentenissen. Voeg een rekening toe voor iedereen met wie je afrekent.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Nog geen organisatierekeningen';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Organisatierekeningen zijn voor bedrijven, projecten of organisaties. Gebruik ze om zakelijke geldstromen gescheiden te houden van je persoonlijke financiën.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Geen transacties voor de gekozen filters';

  @override
  String get emptyNoTransactionsInHistory =>
      'Geen transacties in de geschiedenis';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Geen transacties in $month';
  }

  @override
  String get emptyNoTransactionsForAccount =>
      'Geen transacties voor deze rekening';

  @override
  String get trackTransactionDeleted => 'Transactie verwijderd';

  @override
  String get trackDeleteTitle => 'Transactie verwijderen?';

  @override
  String get trackDeleteBody =>
      'Dit maakt de wijzigingen in het rekeningsaldo ongedaan.';

  @override
  String get trackTransaction => 'Transactie';

  @override
  String get planConfirmTitle => 'Transactie bevestigen?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Deze gebeurtenis is gepland voor $date. Het wordt opgenomen in de Geschiedenis met de datum van vandaag ($todayDate). Het volgende exemplaar blijft op $nextDate staan.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Hierdoor wordt de transactie toegepast op uw echte rekeningsaldi en wordt deze naar Geschiedenis verplaatst.';

  @override
  String get planTransactionConfirmed => 'Transactie bevestigd en toegepast';

  @override
  String get planTransactionRemoved => 'Geplande transactie verwijderd';

  @override
  String get planRepeatingTitle => 'Herhaalde transactie';

  @override
  String get planRepeatingBody =>
      'Sla alleen deze datum over (de serie gaat verder met de volgende gebeurtenis) of verwijder elke resterende gebeurtenis uit uw plan.';

  @override
  String get planDeleteAll => 'Alles verwijderen';

  @override
  String get planSkipThisOnly => 'Sla dit alleen over';

  @override
  String get planOccurrenceSkipped =>
      'Deze gebeurtenis is overgeslagen; de volgende is gepland';

  @override
  String get planNothingPlanned => 'Voorlopig niets gepland';

  @override
  String get planPlanBody => 'Plan komende transacties.';

  @override
  String get planAddPlan => 'Abonnement toevoegen';

  @override
  String get planNoPlannedForFilters =>
      'Geen geplande transacties voor toegepaste filters';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Geen geplande transacties in $month';
  }

  @override
  String get planOverdue => 'verlopen';

  @override
  String get planPlannedTransaction => 'Geplande transactie';

  @override
  String get discardTitle => 'Wijzigingen weggooien?';

  @override
  String get discardBody =>
      'U heeft niet-opgeslagen wijzigingen. Als je nu weggaat, gaan ze verloren.';

  @override
  String get keepEditing => 'Blijf bewerken';

  @override
  String get discard => 'Verwijderen';

  @override
  String get newTransactionTitle => 'Nieuwe transactie';

  @override
  String get editTransactionTitle => 'Transactie bewerken';

  @override
  String get transactionUpdated => 'Transactie bijgewerkt';

  @override
  String get sectionAccounts => 'Rekeningen';

  @override
  String get labelFrom => 'Van';

  @override
  String get labelTo => 'Naar';

  @override
  String get sectionCategory => 'Categorie';

  @override
  String get sectionAttachments => 'Bijlagen';

  @override
  String get labelNote => 'Opmerking';

  @override
  String get hintOptionalDescription => 'Optionele beschrijving';

  @override
  String get updateTransaction => 'Transactie bijwerken';

  @override
  String get saveTransaction => 'Transactie opslaan';

  @override
  String get selectAccount => 'Selecteer rekening';

  @override
  String get selectAccountTitle => 'Selecteer Account';

  @override
  String get noAccountsAvailable => 'Geen accounts beschikbaar';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Bedrag ontvangen door $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Voer het exacte bedrag in dat de bestemmingsrekening ontvangt. Hierdoor wordt de gebruikte reële wisselkoers vergrendeld.';

  @override
  String get attachTakePhoto => 'Maak een foto';

  @override
  String get attachTakePhotoSub =>
      'Gebruik de camera om een ​​bon vast te leggen';

  @override
  String get attachChooseGallery => 'Kies uit galerij';

  @override
  String get attachChooseGallerySub => 'Selecteer foto\'s uit uw bibliotheek';

  @override
  String get attachBrowseFiles => 'Blader door bestanden';

  @override
  String get attachBrowseFilesSub =>
      'Voeg PDF\'s, documenten of andere bestanden toe';

  @override
  String get attachButton => 'Bijvoegen';

  @override
  String get editPlanTitle => 'Plan bewerken';

  @override
  String get planTransactionTitle => 'Plantransactie';

  @override
  String get tapToSelect => 'Tik om te selecteren';

  @override
  String get updatePlan => 'Plan bijwerken';

  @override
  String get addToPlan => 'Toevoegen aan abonnement';

  @override
  String get labelRepeat => 'Herhalen';

  @override
  String get selectPlannedDate => 'Selecteer geplande datum';

  @override
  String get balancesAsOfToday => 'Saldo\'s vanaf vandaag';

  @override
  String get projectedBalancesForTomorrow => 'Geprojecteerde saldi voor morgen';

  @override
  String projectedBalancesForDate(String date) {
    return 'Geprojecteerde saldi voor $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name ontvangt ($currency)';
  }

  @override
  String get destHelper =>
      'Geschatte bestemmingsbedrag. Het exacte tarief wordt vergrendeld bij bevestiging.';

  @override
  String get descriptionOptional => 'Beschrijving (optioneel)';

  @override
  String get detailTransactionTitle => 'Transactie';

  @override
  String get detailPlannedTitle => 'Gepland';

  @override
  String get detailConfirmTransaction => 'Transactie bevestigen';

  @override
  String get detailDate => 'Datum';

  @override
  String get detailFrom => 'Van';

  @override
  String get detailTo => 'Naar';

  @override
  String get detailCategory => 'Categorie';

  @override
  String get detailNote => 'Opmerking';

  @override
  String get detailDestinationAmount => 'Bestemmingsbedrag';

  @override
  String get detailExchangeRate => 'Wisselkoers';

  @override
  String get detailRepeats => 'Herhalingen';

  @override
  String get detailDayOfMonth => 'Dag van de maand';

  @override
  String get detailWeekends => 'Weekenden';

  @override
  String get detailAttachments => 'Bijlagen';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bestanden',
      one: '1 bestand',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingsSectionDisplay => 'Weergave';

  @override
  String get settingsSectionLanguage => 'Taal';

  @override
  String get settingsSectionCategories => 'Categorieën';

  @override
  String get settingsSectionAccounts => 'Rekeningen';

  @override
  String get settingsSectionPreferences => 'Voorkeuren';

  @override
  String get settingsSectionManage => 'Beheren';

  @override
  String get settingsBaseCurrency => 'Eigen valuta';

  @override
  String get settingsSecondaryCurrency => 'Secundaire valuta';

  @override
  String get settingsCategories => 'Categorieën';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount inkomsten · $expenseCount uitgaven';
  }

  @override
  String get settingsArchivedAccounts => 'Gearchiveerde accounts';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Momenteel geen. Archief van accountbewerking wanneer het saldo duidelijk is';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count verborgen voor beoordeling en kiezers';
  }

  @override
  String get settingsSectionData => 'Gegevens';

  @override
  String get settingsSectionPrivacy => 'Over';

  @override
  String get settingsPrivacyPolicyTitle => 'Privacybeleid';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Hoe Platrare met uw gegevens omgaat.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Wisselkoersen: de app haalt openbare valutakoersen op via internet. Uw rekeningen en transacties worden nooit verzonden.';

  @override
  String get settingsPrivacyOpenFailed => 'Kan het privacybeleid niet laden.';

  @override
  String get settingsPrivacyRetry => 'Probeer het opnieuw';

  @override
  String get settingsSoftwareVersionTitle => 'Softwareversie';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Vrijgave, diagnostiek en juridisch';

  @override
  String get aboutScreenTitle => 'Over';

  @override
  String get aboutAppTagline =>
      'Grootboek, cashflow en planning in één werkruimte.';

  @override
  String get aboutDescriptionBody =>
      'Platrare bewaart accounts, transacties en plannen op uw apparaat. Exporteer gecodeerde back-ups wanneer u ergens anders een kopie nodig heeft. Wisselkoersen maken uitsluitend gebruik van openbare marktgegevens; uw grootboek is niet geüpload.';

  @override
  String get aboutVersionLabel => 'Versie';

  @override
  String get aboutBuildLabel => 'Bouwen';

  @override
  String get aboutCopySupportDetails => 'Kopieer ondersteuningsgegevens';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Opent het volledige in-app-beleidsdocument.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Lokaal';

  @override
  String get settingsSupportInfoCopied => 'Gekopieerd naar klembord';

  @override
  String get settingsVerifyLedger => 'Gegevens verifiëren';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Controleer of het rekeningsaldo overeenkomt met uw transactiegeschiedenis';

  @override
  String get settingsDataExportTitle => 'Back-up exporteren';

  @override
  String get settingsDataExportSubtitle =>
      'Opslaan als .zip of gecodeerd .platrare met alle gegevens en bijlagen';

  @override
  String get settingsDataImportTitle => 'Herstellen vanaf back-up';

  @override
  String get settingsDataImportSubtitle =>
      'Vervang huidige gegevens van een Platrare .zip- of .platrare-back-up';

  @override
  String get backupExportDialogTitle => 'Bescherm deze back-up';

  @override
  String get backupExportDialogBody =>
      'Een sterk wachtwoord is aan te raden, zeker als je het bestand in de cloud opslaat. Voor het importeren heeft u hetzelfde wachtwoord nodig.';

  @override
  String get backupExportPasswordLabel => 'Wachtwoord';

  @override
  String get backupExportPasswordConfirmLabel => 'Bevestig wachtwoord';

  @override
  String get backupExportPasswordMismatch => 'Wachtwoorden komen niet overeen';

  @override
  String get backupExportPasswordEmpty =>
      'Voer een bijbehorend wachtwoord in, of exporteer hieronder zonder encryptie.';

  @override
  String get backupExportPasswordTooShort =>
      'Wachtwoord moet minimaal 8 tekens lang zijn.';

  @override
  String get backupExportSaveToDevice => 'Opslaan op apparaat';

  @override
  String get backupExportShareToCloud => 'Delen (iCloud, Drive...)';

  @override
  String get backupExportWithoutEncryption => 'Exporteren zonder encryptie';

  @override
  String get backupExportSkipWarningTitle => 'Exporteren zonder encryptie?';

  @override
  String get backupExportSkipWarningBody =>
      'Iedereen met toegang tot het bestand kan uw gegevens lezen. Gebruik dit alleen voor lokale kopieën die u beheert.';

  @override
  String get backupExportSkipWarningConfirm => 'Onversleuteld exporteren';

  @override
  String get backupImportPasswordTitle => 'Gecodeerde back-up';

  @override
  String get backupImportPasswordBody =>
      'Voer het wachtwoord in dat u bij het exporteren hebt gebruikt.';

  @override
  String get backupImportPasswordLabel => 'Wachtwoord';

  @override
  String get backupImportPreviewTitle => 'Back-upoverzicht';

  @override
  String backupImportPreviewVersion(String version) {
    return 'App-versie: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Geëxporteerd: $date';
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
    return '$accounts rekeningen · $transactions transacties · $planned gepland · $attachments bijlagebestanden · $income inkomenscategorieën · $expense onkostencategorieën';
  }

  @override
  String get backupImportPreviewContinue => 'Doorgaan';

  @override
  String get settingsBackupWrongPassword => 'Verkeerd wachtwoord';

  @override
  String get settingsBackupChecksumMismatch =>
      'Back-up mislukte integriteitscontrole';

  @override
  String get settingsBackupCorruptFile =>
      'Ongeldig of beschadigd back-upbestand';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Back-up heeft een nieuwere app-versie nodig';

  @override
  String get settingsDataImportConfirmTitle => 'Huidige gegevens vervangen?';

  @override
  String get settingsDataImportConfirmBody =>
      'Hiermee worden uw huidige rekeningen, transacties, geplande transacties, categorieën en geïmporteerde bijlagen vervangen door de inhoud van de geselecteerde back-up. Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get settingsDataImportConfirmAction => 'Gegevens vervangen';

  @override
  String get settingsDataImportDone => 'Gegevens hersteld';

  @override
  String get settingsDataImportInvalidFile =>
      'Dit bestand is geen geldige Platrare-back-up';

  @override
  String get settingsDataImportFailed => 'Importeren is mislukt';

  @override
  String get settingsDataExportDoneTitle => 'Back-up geëxporteerd';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Back-up opgeslagen op:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Bestand openen';

  @override
  String get settingsDataExportFailed => 'Exporteren is mislukt';

  @override
  String get settingsCsvExportTitle => 'Exporteren als CSV';

  @override
  String get settingsCsvExportSubtitle =>
      'Je transacties als spreadsheetbestand';

  @override
  String get settingsCsvExportFailed => 'CSV-export mislukt';

  @override
  String get settingsCsvImportTitle => 'Importeren uit CSV';

  @override
  String get settingsCsvImportSubtitle =>
      'Voeg transacties toe uit een spreadsheet — er wordt niets vervangen';

  @override
  String get settingsCsvTemplateTitle => 'CSV-sjabloon ophalen';

  @override
  String get settingsCsvTemplateSubtitle =>
      'Een voorbeeldbestand om je oude gegevens in te plakken';

  @override
  String get csvTemplateInstruction1 =>
      'Vervang de voorbeeldrijen hieronder door je eigen gegevens en importeer dit bestand daarna via Instellingen.';

  @override
  String get csvTemplateInstruction2 =>
      'date en amount zijn verplicht. Schrijf datums als YYYY-MM-DD en bedragen als positief getal.';

  @override
  String get csvTemplateInstruction3 =>
      'type kan income, expense, transfer, invoice, bill, advance, settlement, loan, collection of offset zijn. Laat het leeg om de app het uit de rekeningen te laten afleiden.';

  @override
  String get csvTemplateInstruction4 =>
      'Rekeningen en categorieën die nog niet bestaan worden automatisch aangemaakt. Regels die met # beginnen worden genegeerd.';

  @override
  String get csvImportPreviewTitle => 'Transacties importeren';

  @override
  String csvImportPreviewCounts(int importable, int total) {
    return '$importable van $total rijen worden toegevoegd';
  }

  @override
  String csvImportPreviewNewAccounts(String names) {
    return 'Nieuwe rekeningen: $names';
  }

  @override
  String csvImportPreviewNewCategories(String names) {
    return 'Nieuwe categorieën: $names';
  }

  @override
  String csvImportPreviewDuplicates(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rijen bestaan al',
      one: '1 rij bestaat al',
    );
    return '$_temp0';
  }

  @override
  String get csvImportPreviewSkipDuplicates => 'Rijen overslaan die al bestaan';

  @override
  String csvImportPreviewIssuesTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rijen konden niet worden gelezen',
      one: '1 rij kon niet worden gelezen',
    );
    return '$_temp0';
  }

  @override
  String csvImportPreviewIssueLine(int line, String reason) {
    return 'Regel $line: $reason';
  }

  @override
  String csvImportPreviewIssueMore(int count) {
    return '…en nog $count';
  }

  @override
  String get csvImportPreviewDateStyleTitle =>
      'Datums als 03/04/2026 zijn dubbelzinnig. Hoe moeten ze worden gelezen?';

  @override
  String get csvImportPreviewDateStyleDayFirst => 'Dag eerst (3 april)';

  @override
  String get csvImportPreviewDateStyleMonthFirst => 'Maand eerst (4 maart)';

  @override
  String get csvImportPreviewNothing =>
      'Geen enkele rij in dit bestand kan worden geïmporteerd.';

  @override
  String get csvImportPreviewConfirm => 'Importeren';

  @override
  String get csvRowProblemDate => 'ongeldige of ontbrekende datum';

  @override
  String get csvRowProblemAmount => 'ongeldig of ontbrekend bedrag';

  @override
  String get csvRowProblemAccount => 'ongeldige of ontbrekende rekening';

  @override
  String get csvRowProblemType => 'onbekend transactietype';

  @override
  String csvImportDone(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transacties geïmporteerd',
      one: '1 transactie geïmporteerd',
    );
    return '$_temp0';
  }

  @override
  String get csvImportFailedNoColumns =>
      'Geen herkende kolommen. Begin met het CSV-sjabloon.';

  @override
  String csvImportFailedMissingColumn(String column) {
    return 'Het bestand heeft geen kolom \"$column\".';
  }

  @override
  String get csvImportFailedEmpty => 'Dit bestand bevat geen gegevensrijen.';

  @override
  String csvImportFailedTooManyRows(int rows, int max) {
    return 'Dit bestand heeft $rows rijen; de limiet is $max.';
  }

  @override
  String get csvImportFailed => 'CSV-import mislukt';

  @override
  String get ledgerVerifyDialogTitle => 'Grootboekverificatie';

  @override
  String get ledgerVerifyAllMatch => 'Alle accounts komen overeen.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Afwijkingen';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nOpgeslagen: $stored\nHerhaling: $replayed\nVerschil: $diff';
  }

  @override
  String get settingsLanguage => 'App-taal';

  @override
  String get settingsLanguageSubtitleSystem => 'Systeeminstellingen volgen';

  @override
  String get settingsLanguageSubtitleEnglish => 'Engels';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Servisch (Latijn)';

  @override
  String get settingsLanguagePickerTitle => 'App-taal';

  @override
  String get settingsLanguageOptionSystem => 'Systeemstandaard';

  @override
  String get settingsLanguageOptionEnglish => 'Engels';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Servisch (Latijn)';

  @override
  String get settingsSectionAppearance => 'Verschijning';

  @override
  String get settingsSectionSecurity => 'Beveiliging';

  @override
  String get settingsSecurityEnableLock => 'App vergrendelen bij openen';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Biometrische ontgrendeling of pincode vereisen wanneer de app wordt geopend';

  @override
  String get settingsSecurityLockDelayTitle =>
      'Opnieuw vergrendelen na achtergrond';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      'Hoe lang de app op de achtergrond kan blijven voordat ontgrendeling opnieuw vereist is. Onmiddellijk is het sterkst.';

  @override
  String get settingsSecurityLockDelayImmediate => 'Onmiddellijk';

  @override
  String get settingsSecurityLockDelay30s => '30 seconden';

  @override
  String get settingsSecurityLockDelay1m => '1 minuut';

  @override
  String get settingsSecurityLockDelay5m => '5 minuten';

  @override
  String get settingsSecuritySetPin => 'Pincode instellen';

  @override
  String get settingsSecurityChangePin => 'Wijzig pincode';

  @override
  String get settingsSecurityPinSubtitle =>
      'Gebruik een pincode als reserve als biometrie niet beschikbaar is';

  @override
  String get settingsSecurityRemovePin => 'Pincode verwijderen';

  @override
  String get securitySetPinTitle => 'App-pincode instellen';

  @override
  String get securityPinLabel => 'Pincode';

  @override
  String get securityConfirmPinLabel => 'Bevestig de pincode';

  @override
  String get securityPinMustBe4Digits =>
      'De pincode moet minimaal 4 cijfers bevatten';

  @override
  String get securityPinMismatch => 'Pincodes komen niet overeen';

  @override
  String get securityRemovePinTitle => 'Pincode verwijderen?';

  @override
  String get securityRemovePinBody =>
      'Biometrische ontgrendeling kan nog steeds worden gebruikt, indien beschikbaar.';

  @override
  String get securityUnlockTitle => 'App vergrendeld';

  @override
  String get securityUnlockSubtitle =>
      'Ontgrendel met Face ID, vingerafdruk of pincode.';

  @override
  String get securityUnlockWithPin => 'Ontgrendel met pincode';

  @override
  String get securityTryBiometric => 'Probeer biometrische ontgrendeling';

  @override
  String get securityPinIncorrect => 'Onjuiste pincode, probeer het opnieuw';

  @override
  String securityTooManyAttempts(int seconds) {
    return 'Te veel pogingen. Probeer het over $seconds s opnieuw';
  }

  @override
  String get securityBiometricReason => 'Verifieer om uw app te openen';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get settingsThemeSubtitleSystem => 'Systeeminstellingen volgen';

  @override
  String get settingsThemeSubtitleLight => 'Licht';

  @override
  String get settingsThemeSubtitleDark => 'Donker';

  @override
  String get settingsThemePickerTitle => 'Thema';

  @override
  String get settingsThemeOptionSystem => 'Systeemstandaard';

  @override
  String get settingsThemeOptionLight => 'Licht';

  @override
  String get settingsThemeOptionDark => 'Donker';

  @override
  String get archivedAccountsTitle => 'Gearchiveerde accounts';

  @override
  String get archivedAccountsEmptyTitle => 'Geen gearchiveerde accounts';

  @override
  String get archivedAccountsEmptyBody =>
      'Boeksaldo en rood staan ​​moeten nul zijn. Archiveer vanuit accountopties in Review.';

  @override
  String get categoriesTitle => 'Categorieën';

  @override
  String get newCategoryTitle => 'Nieuwe categorie';

  @override
  String get categoryNameLabel => 'Categorienaam';

  @override
  String get deleteCategoryTitle => 'Categorie verwijderen?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" wordt uit de lijst verwijderd.';
  }

  @override
  String get categoryIncome => 'Inkomen';

  @override
  String get categoryExpense => 'Kosten';

  @override
  String get categoryAdd => 'Toevoegen';

  @override
  String get editCategoryTitle => 'Categorie bewerken';

  @override
  String get categorySave => 'Opslaan';

  @override
  String get categoryRenameAction => 'Hernoemen';

  @override
  String get categoryDuplicateName =>
      'Er bestaat al een categorie met deze naam.';

  @override
  String get categoryInUseTitle => 'Categorie in gebruik';

  @override
  String categoryInUseBody(String category, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transacties',
      one: '1 transactie',
    );
    return '\"$category\" wordt gebruikt door $_temp0. Deze kan niet worden verwijderd, maar wel hernoemd — alle gekoppelde transacties worden automatisch bijgewerkt.';
  }

  @override
  String get searchCurrencies => 'Valuta zoeken...';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1J';

  @override
  String get periodAll => 'ALLE';

  @override
  String get categoryLabel => 'categorie';

  @override
  String get categoriesLabel => 'categorieën';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type opgeslagen • $amount';
  }

  @override
  String get tooltipSettings => 'Instellingen';

  @override
  String get tooltipAddAccount => 'Account toevoegen';

  @override
  String get tooltipRemoveAccount => 'Account verwijderen';

  @override
  String get accountNameTaken =>
      'U heeft al een account met deze naam en identificatie (actief of gearchiveerd). Wijzig de naam of identificatie.';

  @override
  String get groupDescPersonal => 'Uw eigen portemonnee en bankrekeningen';

  @override
  String get groupDescIndividuals => 'Familie, vrienden, individuen';

  @override
  String get groupDescEntities => 'Entiteiten, nutsbedrijven, organisaties';

  @override
  String get cannotArchiveTitle => 'Kan nog niet archiveren';

  @override
  String get cannotArchiveBody =>
      'Archief is alleen beschikbaar als zowel het boeksaldo als de roodstandlimiet feitelijk nul zijn.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Archief is alleen beschikbaar als zowel het boeksaldo als de roodstandlimiet feitelijk nul zijn. Pas eerst het grootboek of de faciliteit aan.';

  @override
  String get archiveAccountTitle => 'Account archiveren?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geplande transacties verwijzen naar deze rekening.',
      one: '1 geplande transactie verwijst naar deze rekening.',
    );
    return '$_temp0 Verwijder ze om je plan consistent te houden met een gearchiveerde rekening.';
  }

  @override
  String get removeAndArchive => 'Gepland verwijderen en archiveren';

  @override
  String get archiveBody =>
      'Het account wordt verborgen voor de kiezers Review, Track en Plan. Je kunt het herstellen via Instellingen.';

  @override
  String get archiveAction => 'Archief';

  @override
  String get archiveInstead => 'Archiveer in plaats daarvan';

  @override
  String get cannotDeleteTitle => 'Kan account niet verwijderen';

  @override
  String get cannotDeleteBodyShort =>
      'Dit account verschijnt in je trackgeschiedenis. Verwijder deze transacties eerst of wijs deze opnieuw toe, of archiveer de rekening als het saldo is vereffend.';

  @override
  String get cannotDeleteBodyHistory =>
      'Dit account verschijnt in je trackgeschiedenis. Verwijderen zou die geschiedenis doorbreken; verwijder eerst die transacties of wijs ze opnieuw toe.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Dit account verschijnt in je trackgeschiedenis en kan dus niet worden verwijderd. U kunt het in plaats daarvan archiveren als het boeksaldo en het rood staan ​​zijn gewist. Het wordt verborgen in lijsten, maar de geschiedenis blijft intact.';

  @override
  String get deleteAccountTitle => 'Account verwijderen?';

  @override
  String get deleteAccountBodyPermanent =>
      'Dit account wordt definitief verwijderd.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count geplande transacties verwijzen naar deze rekening en worden ook verwijderd.',
      one:
          '1 geplande transactie verwijst naar deze rekening en wordt ook verwijderd.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Alles verwijderen';

  @override
  String get editAccountTitle => 'Account bewerken';

  @override
  String get newAccountTitle => 'Nieuw account';

  @override
  String get labelAccountName => 'Accountnaam';

  @override
  String get labelAccountIdentifier => 'Identificatie (optioneel)';

  @override
  String get accountAppearanceSection => 'Icoon & kleur';

  @override
  String get accountPickIcon => 'Kies icoon';

  @override
  String get accountPickColor => 'Kies kleur';

  @override
  String get accountIconSheetTitle => 'Accountpictogram';

  @override
  String get accountColorSheetTitle => 'Accountkleur';

  @override
  String get searchAccountIcons => 'Pictogrammen op naam zoeken…';

  @override
  String get accountIconSearchNoMatches =>
      'Geen pictogrammen komen overeen met die zoekopdracht.';

  @override
  String get accountUseInitialLetter => 'Eerste brief';

  @override
  String get accountUseDefaultColor => 'Match groep';

  @override
  String get labelRealBalance => 'Echt evenwicht';

  @override
  String get labelOverdraftLimit => 'Rekening-courantkrediet/voorschotlimiet';

  @override
  String get labelCurrency => 'Munteenheid';

  @override
  String get saveChanges => 'Wijzigingen opslaan';

  @override
  String get addAccountAction => 'Account toevoegen';

  @override
  String get removeAccountSheetTitle => 'Account verwijderen';

  @override
  String get deletePermanently => 'Permanent verwijderen';

  @override
  String get deletePermanentlySubtitle =>
      'Alleen mogelijk als dit account niet in Track wordt gebruikt. Geplande artikelen kunnen worden verwijderd als onderdeel van het verwijderen.';

  @override
  String get archiveOptionSubtitle =>
      'Verbergen voor beoordeling en pickers. Herstel op elk gewenst moment via Instellingen. Vereist een nulsaldo en rood staan.';

  @override
  String get archivedBannerText =>
      'Dit account is gearchiveerd. Het blijft in uw gegevens, maar is verborgen in lijsten en kiezers.';

  @override
  String get balanceAdjustedTitle => 'Balans aangepast in Track';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Het werkelijke saldo is bijgewerkt van $previous naar $current $symbol.\n\nEr is een saldoaanpassingstransactie aangemaakt in Track (Geschiedenis) om het grootboek consistent te houden.\n\n• Het werkelijke saldo weerspiegelt het werkelijke bedrag op deze rekening.\n• Controleer Geschiedenis voor de correctie-invoer.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Balansaanpassing';

  @override
  String get descriptionBalanceCorrection => 'Saldo correctie';

  @override
  String get descriptionOpeningBalance => 'Openingssaldo';

  @override
  String get reviewStatsModeStatistics => 'Statistieken';

  @override
  String get reviewStatsModeComparison => 'Vergelijking';

  @override
  String get statsUncategorized => 'Niet gecategoriseerd';

  @override
  String get statsNoCategories =>
      'Geen categorieën in de geselecteerde periodes ter vergelijking.';

  @override
  String get statsNoTransactions => 'Geen transacties';

  @override
  String get statsSpendingInCategory => 'Uitgaven in deze categorie';

  @override
  String get statsIncomeInCategory => 'Inkomen in deze categorie';

  @override
  String get statsDifference => 'Verschil (B versus A):';

  @override
  String get statsNoExpensesMonth => 'Geen uitgaven deze maand';

  @override
  String get statsNoExpensesAll => 'Geen kosten geregistreerd';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Geen uitgaven in de afgelopen $period';
  }

  @override
  String get statsTotalSpent => 'Totaal uitgegeven';

  @override
  String get statsNoExpensesThisPeriod => 'Geen kosten in deze periode';

  @override
  String get statsNoIncomeMonth => 'Geen inkomsten deze maand';

  @override
  String get statsNoIncomeAll => 'Geen inkomen geregistreerd';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Geen inkomsten in de afgelopen $period';
  }

  @override
  String get statsTotalReceived => 'Totaal ontvangen';

  @override
  String get statsNoIncomeThisPeriod => 'Geen inkomsten in deze periode';

  @override
  String get catSalary => 'Salaris';

  @override
  String get catFreelance => 'Freelancer';

  @override
  String get catConsulting => 'Advies';

  @override
  String get catGift => 'Geschenk';

  @override
  String get catRental => 'Verhuur';

  @override
  String get catDividends => 'Dividenden';

  @override
  String get catRefund => 'Terugbetaling';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catInterest => 'Interesse';

  @override
  String get catSideHustle => 'Zij drukte';

  @override
  String get catSaleOfGoods => 'Verkoop van goederen';

  @override
  String get catOther => 'Ander';

  @override
  String get catGroceries => 'Boodschappen';

  @override
  String get catDining => 'Dineren';

  @override
  String get catTransport => 'Vervoer';

  @override
  String get catUtilities => 'Nutsvoorzieningen';

  @override
  String get catHousing => 'Huisvesting';

  @override
  String get catHealthcare => 'Gezondheidszorg';

  @override
  String get catEntertainment => 'Amusement';

  @override
  String get catShopping => 'Winkelen';

  @override
  String get catTravel => 'Reis';

  @override
  String get catEducation => 'Onderwijs';

  @override
  String get catSubscriptions => 'Abonnementen';

  @override
  String get catInsurance => 'Verzekering';

  @override
  String get catFuel => 'Brandstof';

  @override
  String get catGym => 'Sportschool';

  @override
  String get catPets => 'Huisdieren';

  @override
  String get catKids => 'Kinderen';

  @override
  String get catCharity => 'Goed doel';

  @override
  String get catCoffee => 'Koffie';

  @override
  String get catGifts => 'Geschenken';

  @override
  String semanticsProjectionDate(String date) {
    return 'Projectiedatum $date. Dubbeltik om een ​​datum te kiezen';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Geprojecteerd persoonlijk saldo $amount';
  }

  @override
  String get statsEmptyTitle => 'Nog geen transacties';

  @override
  String get statsEmptySubtitle =>
      'Geen bestedingsgegevens voor het geselecteerde bereik.';

  @override
  String get semanticsShowProjections =>
      'Toon geprojecteerde saldi per rekening';

  @override
  String get semanticsHideProjections =>
      'Verberg geprojecteerde saldi per rekening';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Accountsaldi voor deze dag weergeven';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Accountsaldi voor deze dag verbergen';

  @override
  String get semanticsDateAllTime =>
      'Datum: altijd — tik om de modus te wijzigen';

  @override
  String semanticsDateMode(String mode) {
    return 'Datum: $mode — tik om de modus te wijzigen';
  }

  @override
  String get semanticsDateThisMonth =>
      'Datum: deze maand: tik voor maand, week, jaar of altijd';

  @override
  String get semanticsTxTypeCycle =>
      'Transactietype: alles doorlopen, inkomsten, uitgaven, overdracht';

  @override
  String get semanticsAccountFilter => 'Accountfilter';

  @override
  String get semanticsAlreadyFiltered => 'Al gefilterd op dit account';

  @override
  String get semanticsCategoryFilter => 'Categoriefilter';

  @override
  String get semanticsSortToggle =>
      'Sorteren: schakel nieuwste of oudste eerst';

  @override
  String get semanticsFiltersDisabled =>
      'Lijstfilters uitgeschakeld tijdens het bekijken van een toekomstige projectiedatum. Duidelijke projecties om filters te gebruiken.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Lijstfilters uitgeschakeld. Voeg eerst een account toe.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Lijstfilters uitgeschakeld. Voeg eerst een geplande transactie toe.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Lijstfilters uitgeschakeld. Registreer eerst een transactie.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Sectie- en valutabediening uitgeschakeld. Voeg eerst een account toe.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Projectiedatum en uitsplitsing van het saldo zijn uitgeschakeld. Voeg eerst een account en een geplande transactie toe.';

  @override
  String get semanticsReorderAccountHint =>
      'Houd ingedrukt en sleep vervolgens om de volgorde binnen deze groep te wijzigen';

  @override
  String get semanticsChartStyle => 'Grafiekstijl';

  @override
  String get semanticsChartStyleUnavailable =>
      'Diagramstijl (niet beschikbaar in vergelijkingsmodus)';

  @override
  String semanticsPeriod(String label) {
    return 'Periode: $label';
  }

  @override
  String get trackSearchHint => 'Zoek beschrijving, categorie, account…';

  @override
  String get trackSearchClear => 'Duidelijke zoekopdracht';

  @override
  String get settingsExchangeRatesTitle => 'Wisselkoersen';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Laatst bijgewerkt: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Gebruik offline of gebundelde tarieven: tik om te vernieuwen';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Wisselkoersen bijgewerkt';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Kan de wisselkoersen niet bijwerken. Controleer uw verbinding.';

  @override
  String get settingsClearData => 'Gegevens wissen';

  @override
  String get settingsClearDataSubtitle =>
      'Verwijder geselecteerde gegevens definitief';

  @override
  String get clearDataTitle => 'Gegevens wissen';

  @override
  String get clearDataTransactions => 'Transactiegeschiedenis';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transacties · rekeningsaldi worden gereset naar nul';
  }

  @override
  String get clearDataPlanned => 'Geplande transacties';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count geplande artikelen';
  }

  @override
  String get clearDataAccounts => 'Rekeningen';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count accounts · wist ook de geschiedenis en het plan';
  }

  @override
  String get clearDataCategories => 'Categorieën';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count categorieën · vervangen door standaardwaarden';
  }

  @override
  String get clearDataPreferences => 'Voorkeuren';

  @override
  String get clearDataPreferencesSubtitle =>
      'Reset valuta, thema en taal naar de standaardwaarden';

  @override
  String get clearDataSecurity => 'App-vergrendeling en pincode';

  @override
  String get clearDataSecuritySubtitle =>
      'Schakel app-vergrendeling uit en verwijder de pincode';

  @override
  String get clearDataConfirmButton => 'Wis geselecteerd';

  @override
  String get clearDataConfirmTitle => 'Dit kan niet ongedaan worden gemaakt';

  @override
  String get clearDataConfirmBody =>
      'De geselecteerde gegevens worden permanent verwijderd. Exporteer eerst een back-up als u deze later nodig heeft.';

  @override
  String get clearDataTypeConfirm => 'Typ VERWIJDER om te bevestigen';

  @override
  String get clearDataTypeConfirmError =>
      'Typ VERWIJDER precies om door te gaan';

  @override
  String get clearDataPinTitle => 'Bevestig met pincode';

  @override
  String get clearDataPinBody =>
      'Voer uw app-pincode in om deze actie te autoriseren.';

  @override
  String get clearDataPinIncorrect => 'Onjuiste pincode';

  @override
  String get clearDataDone => 'Geselecteerde gegevens gewist';

  @override
  String get autoBackupTitle => 'Automatische dagelijkse back-up';

  @override
  String autoBackupLastAt(String date) {
    return 'Laatste back-up $date';
  }

  @override
  String get autoBackupNeverRun => 'Nog geen back-up';

  @override
  String get autoBackupShareTitle => 'Opslaan in de cloud';

  @override
  String get autoBackupShareSubtitle =>
      'Upload de nieuwste back-up naar iCloud Drive, Google Drive of een andere app';

  @override
  String get autoBackupCloudReminder =>
      'Klaar voor automatische back-up: sla het op in de cloud voor bescherming buiten het apparaat';

  @override
  String get autoBackupCloudReminderAction => 'Delen';

  @override
  String get settingsBackupReminderTitle => 'Back-upherinnering';

  @override
  String get settingsBackupReminderSubtitle =>
      'In-app banner als u veel transacties toevoegt zonder een handmatige back-up te exporteren.';

  @override
  String get settingsBackupReminderThresholdTitle => 'Transactiedrempel';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return 'Herinner na $count nieuwe transacties sinds uw laatste handmatige export.';
  }

  @override
  String get settingsBackupReminderThresholdInvalid =>
      'Voer een geheel getal in van 1 tot 500.';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '\"Later herinneren\" verbergt de banner totdat u $n meer transacties toevoegt.';
  }

  @override
  String get backupReminderBannerTitle => 'Een back-up exporteren?';

  @override
  String backupReminderBannerBody(int count) {
    return 'U heeft $count transacties toegevoegd sinds uw laatste handmatige export.';
  }

  @override
  String get backupReminderRemindLater => 'Later herinneren';

  @override
  String get backupExportLedgerVerifyTitle => 'Grootboekcontrole voor back-up';

  @override
  String get backupExportLedgerVerifyInfo =>
      'Vergelijkt het opgeslagen saldo van elk account met een volledige herhaling van uw geschiedenis. U kunt een back-up exporteren ongeacht het resultaat; afwijkingen zijn informatief.';

  @override
  String get backupExportLedgerVerifyContinue => 'Doorgaan naar back-up';

  @override
  String get persistenceErrorReloaded =>
      'Kan wijzigingen niet opslaan. Gegevens zijn opnieuw geladen uit de opslag.';

  @override
  String get helpTooltip => 'Hulp';

  @override
  String get helpNext => 'Volgende';

  @override
  String get helpBack => 'Terug';

  @override
  String get helpDone => 'Klaar';

  @override
  String get helpSkip => 'Overslaan';

  @override
  String get helpTrackHeroTitle => 'Totalen en filters';

  @override
  String get helpTrackHeroBody =>
      'Deze kaart telt inkomsten en uitgaven op voor de lijst eronder. De chips filteren op rekening, categorie en type; de datumchip wisselt tussen dag, week, maand en jaar; de pijl draait de sortering om.';

  @override
  String get helpTrackListTitle => 'Je geschiedenis';

  @override
  String get helpTrackListBody =>
      'Vastgelegde transacties, gegroepeerd per dag. Tik op een transactie om die te bekijken of te bewerken, en gebruik zoeken om een specifieke invoer te vinden.';

  @override
  String get helpTrackFabTitle => 'Transactie toevoegen';

  @override
  String get helpTrackFabBody =>
      'Leg vast wat er binnenkomt, eruit gaat of tussen je rekeningen wordt overgeboekt.';

  @override
  String get helpSettingsTitle => 'Instellingen';

  @override
  String get helpSettingsBody =>
      'Valuta’s, taal, thema, beveiliging, back-ups en rekeningbeheer vind je hier.';

  @override
  String get helpPlanHeroTitle => 'Prognose';

  @override
  String get helpPlanHeroBody =>
      'Je persoonlijke en netto saldo op de gekozen datum. De chips eronder filteren de geplande transacties.';

  @override
  String get helpPlanListTitle => 'Geplande transacties';

  @override
  String get helpPlanListBody =>
      'Verwachte inkomsten, uitgaven en overboekingen. Tik op een item om het te bewerken; de chips bovenaan filteren deze lijst.';

  @override
  String get helpPlanFabTitle => 'Plan toevoegen';

  @override
  String get helpPlanFabBody =>
      'Plan een verwachte transactie, ook terugkerend.';

  @override
  String get helpPlanProjectionFabTitle => 'Kijk vooruit';

  @override
  String get helpPlanProjectionFabBody =>
      'Tik op de wereldbol om een toekomstige datum te kiezen en je verwachte saldi te zien — geplande transacties tot die datum worden meegenomen. Je kunt ook op de datum in de kaart bovenaan tikken.';

  @override
  String get helpReviewHeroTitle => 'Vermogen';

  @override
  String get helpReviewHeroBody =>
      'Je persoonlijke saldo en netto vermogen in één oogopslag. Tik op de bedragen om te wisselen tussen je basis- en tweede valuta.';

  @override
  String get helpReviewSectionsTitle => 'Secties';

  @override
  String get helpReviewSectionsBody =>
      'Veeg naar links en rechts — of tik op de chips — om te wisselen tussen persoonlijke rekeningen, personen, organisaties en statistieken.';

  @override
  String get helpReviewAccountsTitle => 'Rekeningen';

  @override
  String get helpReviewAccountsBody =>
      'Elke kaart toont een rekening en het saldo. Tik erop om de volledige geschiedenis te openen.';

  @override
  String get helpReviewFabTitle => 'Rekening toevoegen';

  @override
  String get helpReviewFabBody =>
      'Maak rekeningen voor contant geld, kaarten en spaargeld, of voor personen en bedrijven die je volgt.';

  @override
  String get helpSettingsSecurityTitle => 'Beveiliging';

  @override
  String get helpSettingsSecurityBody =>
      'Vergrendel de app achter de schermvergrendeling van je toestel en kies hoe snel die opnieuw vergrendelt.';

  @override
  String get helpSettingsPreferencesTitle => 'Voorkeuren';

  @override
  String get helpSettingsPreferencesBody =>
      'Taal, thema, valuta’s en andere dagelijkse opties.';

  @override
  String get helpSettingsDataTitle => 'Je gegevens';

  @override
  String get helpSettingsDataBody =>
      'Exporteer versleutelde back-ups, importeer ze op een ander toestel en stel automatische back-ups in. Je gegevens blijven op dit toestel tenzij je ze exporteert.';

  @override
  String get helpSettingsManageTitle => 'Beheren';

  @override
  String get helpSettingsManageBody =>
      'Bewerk rekeningen en hernoem categorieën — wijzigingen gelden overal in de app.';

  @override
  String get helpTxAccountsTitle => 'Van en Naar';

  @override
  String get helpTxAccountsBody =>
      'Kies waar het geld vandaan komt en waar het naartoe gaat. Alleen Van: uitgave. Alleen Naar: inkomsten. Allebei: een overboeking tussen rekeningen.';

  @override
  String get helpTxDetailsTitle => 'Bedrag en details';

  @override
  String get helpTxDetailsBody =>
      'Voer het bedrag in en voeg een categorie, notitie of bijlage toe zodat je de invoer later makkelijk terugvindt.';

  @override
  String get helpTxDateTitle => 'Datum';

  @override
  String get helpTxDateBody =>
      'Tik hier om de dag van de transactie te wijzigen.';

  @override
  String get helpPlannedDateTitle => 'Geplande datum';

  @override
  String get helpPlannedDateBody =>
      'Tik hier om te kiezen wanneer dit moet gebeuren. Een plan kan zich ook herhalen volgens een schema dat jij kiest.';

  @override
  String get helpPlannedProjectionTitle => 'Geprognosticeerde saldi';

  @override
  String get helpPlannedProjectionBody =>
      'De rekeningkiezers tonen het verwachte saldo van elke rekening op de geplande datum, zodat je ziet welk plan een rekening rood zou laten staan.';

  @override
  String get settingsPlannedRemindersTitle => 'Planherinneringen';

  @override
  String get settingsPlannedRemindersSubtitle =>
      'Meldt wanneer een geplande transactie vervalt. Werkt volledig offline — niets verlaat je apparaat.';

  @override
  String get settingsPlannedRemindersTimeTitle => 'Herinneringstijd';

  @override
  String get settingsPlannedRemindersLeadTitle => 'Vooraf melden';

  @override
  String get settingsPlannedRemindersLeadOnDay => 'Op de vervaldag';

  @override
  String settingsPlannedRemindersLeadDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen van tevoren',
      one: '1 dag van tevoren',
    );
    return '$_temp0';
  }

  @override
  String get settingsPlannedRemindersPermissionDenied =>
      'Meldingen zijn uitgeschakeld voor Platrare. Sta ze toe in de systeeminstellingen om herinneringen te ontvangen.';

  @override
  String get plannedReminderChannelName =>
      'Herinneringen voor geplande transacties';

  @override
  String get plannedReminderChannelDescription =>
      'Meldingen voor aankomende geplande transacties.';

  @override
  String get plannedReminderFallbackTitle => 'Geplande transactie';

  @override
  String get plannedReminderDueToday => 'Vervalt vandaag';

  @override
  String get plannedReminderDueTomorrow => 'Vervalt morgen';

  @override
  String plannedReminderDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vervalt over $count dagen',
    );
    return '$_temp0';
  }

  @override
  String get aboutContactSupport => 'Contact opnemen met support';

  @override
  String get aboutSupportEmailCopied => 'E-mailadres van support gekopieerd';

  @override
  String get onboardingWelcomeTitle => 'Welkom bij Platrare';

  @override
  String get onboardingWelcomeBody =>
      'Je geld blijft op dit apparaat. Geen account, geen advertenties, geen tracking.';

  @override
  String get onboardingPlanBody =>
      'Plan komende en terugkerende betalingen en zie waar je saldi naartoe gaan.';

  @override
  String get onboardingTrackBody =>
      'Leg inkomsten, uitgaven, overboekingen en wat je leent of verschuldigd bent vast.';

  @override
  String get onboardingReviewBody =>
      'Statistieken, vergelijkingen en geschiedenis voor je rekeningen, de mensen met wie je afrekent en bedrijven.';

  @override
  String get onboardingCurrencyLabel => 'Basisvaluta';

  @override
  String get onboardingCurrencyHint =>
      'Voorgesteld op basis van je apparaattaal. Later te wijzigen in Instellingen.';

  @override
  String get onboardingStart => 'Aan de slag';

  @override
  String get onboardingTour => 'Leid me rond';

  @override
  String get clearDataConfirmWord => 'VERWIJDER';
}
