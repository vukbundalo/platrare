// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Planera';

  @override
  String get navTrack => 'Spåra';

  @override
  String get navReview => 'Recension';

  @override
  String get cancel => 'Avboka';

  @override
  String get delete => 'Radera';

  @override
  String get close => 'Nära';

  @override
  String get add => 'Tillägga';

  @override
  String get undo => 'Ångra';

  @override
  String get confirm => 'Bekräfta';

  @override
  String get restore => 'Återställa';

  @override
  String get heroIn => 'I';

  @override
  String get heroOut => 'Ut';

  @override
  String get heroNet => 'Netto';

  @override
  String get heroBalance => 'Balans';

  @override
  String get realBalance => 'Riktig balans';

  @override
  String get settingsHideHeroBalancesTitle => 'Hide balances in summary cards';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'When on, amounts on Plan, Track, and Review stay masked until you tap the eye icon on each tab. When off, balances are always visible.';

  @override
  String get heroBalancesShow => 'Show balances';

  @override
  String get heroBalancesHide => 'Hide balances';

  @override
  String get semanticsHeroBalanceHidden => 'Balance hidden for privacy';

  @override
  String get heroResetButton => 'Återställa';

  @override
  String get fabScrollToTop => 'Till toppen';

  @override
  String get filterAll => 'Alla';

  @override
  String get filterAllAccounts => 'Alla konton';

  @override
  String get filterAllCategories => 'Alla kategorier';

  @override
  String get txLabelIncome => 'INKOMST';

  @override
  String get txLabelExpense => 'BEKOSTNAD';

  @override
  String get txLabelInvoice => 'FAKTURA';

  @override
  String get txLabelBill => 'FAKTURERA';

  @override
  String get txLabelAdvance => 'FÖRSKOTT';

  @override
  String get txLabelSettlement => 'LÖSNING';

  @override
  String get txLabelLoan => 'LÅN';

  @override
  String get txLabelCollection => 'SAMLING';

  @override
  String get txLabelOffset => 'OFFSET';

  @override
  String get txLabelTransfer => 'ÖVERFÖRA';

  @override
  String get txLabelTransaction => 'TRANSAKTION';

  @override
  String get repeatNone => 'Ingen upprepning';

  @override
  String get repeatDaily => 'Dagligen';

  @override
  String get repeatWeekly => 'Varje vecka';

  @override
  String get repeatMonthly => 'Månatlig';

  @override
  String get repeatYearly => 'Årlig';

  @override
  String get repeatEveryLabel => 'Varje';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagar',
      one: 'dag',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veckor',
      one: 'vecka',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count månader',
      one: 'månad',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count år',
      one: 'år',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Slutar';

  @override
  String get repeatEndNever => 'Aldrig';

  @override
  String get repeatEndOnDate => 'På dejt';

  @override
  String repeatEndAfterCount(int count) {
    return 'Efter $count gånger';
  }

  @override
  String get repeatEndAfterChoice => 'Efter ett visst antal gånger';

  @override
  String get repeatEndPickDate => 'Välj slutdatum';

  @override
  String get repeatEndTimes => 'gånger';

  @override
  String repeatSummaryEvery(int count, String unit) {
    return 'Varje $count $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'tills $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count gånger';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining av $total kvar';
  }

  @override
  String get detailRepeatEvery => 'Upprepa varje';

  @override
  String get detailEnds => 'Slutar';

  @override
  String get detailEndsNever => 'Aldrig';

  @override
  String detailEndsOnDate(String date) {
    return 'På $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Efter $count gånger';
  }

  @override
  String get detailProgress => 'Framsteg';

  @override
  String get weekendNoChange => 'Ingen förändring';

  @override
  String get weekendFriday => 'Flytta till fredag';

  @override
  String get weekendMonday => 'Flytta till måndag';

  @override
  String weekendQuestion(String day) {
    return 'Om $day infaller på en helg?';
  }

  @override
  String get dateToday => 'I dag';

  @override
  String get dateTomorrow => 'I morgon';

  @override
  String get dateYesterday => 'I går';

  @override
  String get statsAllTime => 'Hela tiden';

  @override
  String get accountGroupPersonal => 'Personlig';

  @override
  String get accountGroupIndividual => 'Enskild';

  @override
  String get accountGroupEntity => 'Enhet';

  @override
  String get accountSectionIndividuals => 'Individer';

  @override
  String get accountSectionEntities => 'Entiteter';

  @override
  String get emptyNoTransactionsYet => 'Inga transaktioner ännu';

  @override
  String get emptyNoAccountsYet => 'Inga konton ännu';

  @override
  String get emptyRecordFirstTransaction =>
      'Tryck på knappen nedan för att spela in din första transaktion.';

  @override
  String get emptyAddFirstAccountTx =>
      'Lägg till ditt första konto innan du registrerar transaktioner.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Lägg till ditt första konto innan du planerar transaktioner.';

  @override
  String get emptyAddFirstAccountReview =>
      'Lägg till ditt första konto för att börja spåra din ekonomi.';

  @override
  String get emptyAddTransaction => 'Lägg till transaktion';

  @override
  String get emptyAddAccount => 'Lägg till konto';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Inga personliga konton ännu';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Personliga konton är dina egna plånböcker och bankkonton. Lägg till en för att spåra dagliga inkomster och utgifter.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'Inga enskilda konton ännu';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Individuella konton spårar pengar med specifika personer – delade kostnader, lån eller IOU. Lägg till ett konto för varje person du gör upp med.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Inga enhetskonton ännu';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Enhetskonton är för företag, projekt eller organisationer. Använd dem för att hålla företagets kassaflöde åtskilt från din privatekonomi.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Inga transaktioner för tillämpade filter';

  @override
  String get emptyNoTransactionsInHistory => 'Inga transaktioner i historien';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Inga transaktioner för $month';
  }

  @override
  String get emptyNoTransactionsForAccount =>
      'Inga transaktioner för detta konto';

  @override
  String get trackTransactionDeleted => 'Transaktionen raderad';

  @override
  String get trackDeleteTitle => 'Ta bort transaktion?';

  @override
  String get trackDeleteBody =>
      'Detta kommer att återställa ändringarna i kontosaldot.';

  @override
  String get trackTransaction => 'Transaktion';

  @override
  String get planConfirmTitle => 'Bekräfta transaktionen?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Denna händelse är planerad till $date. Det kommer att registreras i historiken med dagens datum ($todayDate). Nästa händelse finns kvar på $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Detta kommer att tillämpa transaktionen på dina riktiga kontosaldon och flytta den till Historik.';

  @override
  String get planTransactionConfirmed =>
      'Transaktionen bekräftad och tillämpad';

  @override
  String get planTransactionRemoved => 'Planerad transaktion har tagits bort';

  @override
  String get planRepeatingTitle => 'Upprepad transaktion';

  @override
  String get planRepeatingBody =>
      'Hoppa bara över detta datum – serien fortsätter med nästa förekomst – eller ta bort alla återstående förekomster från din plan.';

  @override
  String get planDeleteAll => 'Ta bort alla';

  @override
  String get planSkipThisOnly => 'Hoppa bara över detta';

  @override
  String get planOccurrenceSkipped =>
      'Den här händelsen hoppade över — nästa schemalagd';

  @override
  String get planNothingPlanned => 'Inget planerat just nu';

  @override
  String get planPlanBody => 'Planera kommande transaktioner.';

  @override
  String get planAddPlan => 'Lägg till plan';

  @override
  String get planNoPlannedForFilters =>
      'Inga planerade transaktioner för tillämpade filter';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Inga planerade transaktioner i $month';
  }

  @override
  String get planOverdue => 'försenad';

  @override
  String get planPlannedTransaction => 'Planerad transaktion';

  @override
  String get discardTitle => 'Vill du ignorera ändringar?';

  @override
  String get discardBody =>
      'Du har osparade ändringar. De kommer att gå förlorade om du går nu.';

  @override
  String get keepEditing => 'Fortsätt redigera';

  @override
  String get discard => 'Kassera';

  @override
  String get newTransactionTitle => 'Ny transaktion';

  @override
  String get editTransactionTitle => 'Redigera transaktion';

  @override
  String get transactionUpdated => 'Transaktionen uppdaterad';

  @override
  String get sectionAccounts => 'konton';

  @override
  String get labelFrom => 'Från';

  @override
  String get labelTo => 'Till';

  @override
  String get sectionCategory => 'Kategori';

  @override
  String get sectionAttachments => 'Bilagor';

  @override
  String get labelNote => 'Notera';

  @override
  String get hintOptionalDescription => 'Valfri beskrivning';

  @override
  String get updateTransaction => 'Uppdatera transaktion';

  @override
  String get saveTransaction => 'Spara transaktion';

  @override
  String get selectAccount => 'Välj konto';

  @override
  String get selectAccountTitle => 'Välj Konto';

  @override
  String get noAccountsAvailable => 'Inga konton tillgängliga';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Belopp mottaget av $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Ange det exakta belopp som destinationskontot tar emot. Detta låser den använda reala växelkursen.';

  @override
  String get attachTakePhoto => 'Ta foto';

  @override
  String get attachTakePhotoSub => 'Använd kameran för att fånga ett kvitto';

  @override
  String get attachChooseGallery => 'Välj från galleri';

  @override
  String get attachChooseGallerySub => 'Välj foton från ditt bibliotek';

  @override
  String get attachBrowseFiles => 'Bläddra bland filer';

  @override
  String get attachBrowseFilesSub =>
      'Bifoga PDF-filer, dokument eller andra filer';

  @override
  String get attachButton => 'Bifoga';

  @override
  String get editPlanTitle => 'Redigera plan';

  @override
  String get planTransactionTitle => 'Planera transaktion';

  @override
  String get tapToSelect => 'Tryck för att välja';

  @override
  String get updatePlan => 'Uppdatera plan';

  @override
  String get addToPlan => 'Lägg till i plan';

  @override
  String get labelRepeat => 'Upprepa';

  @override
  String get selectPlannedDate => 'Välj planerat datum';

  @override
  String get balancesAsOfToday => 'Saldon från idag';

  @override
  String get projectedBalancesForTomorrow => 'Beräknade saldon för morgondagen';

  @override
  String projectedBalancesForDate(String date) {
    return 'Prognostiserade saldon för $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name tar emot ($currency)';
  }

  @override
  String get destHelper =>
      'Beräknat destinationsbelopp. Exakt kurs låses vid bekräftelse.';

  @override
  String get descriptionOptional => 'Beskrivning (valfritt)';

  @override
  String get detailTransactionTitle => 'Transaktion';

  @override
  String get detailPlannedTitle => 'Planerad';

  @override
  String get detailConfirmTransaction => 'Bekräfta transaktionen';

  @override
  String get detailDate => 'Datum';

  @override
  String get detailFrom => 'Från';

  @override
  String get detailTo => 'Till';

  @override
  String get detailCategory => 'Kategori';

  @override
  String get detailNote => 'Notera';

  @override
  String get detailDestinationAmount => 'Destinationsbelopp';

  @override
  String get detailExchangeRate => 'Växelkurs';

  @override
  String get detailRepeats => 'Upprepas';

  @override
  String get detailDayOfMonth => 'Dag i månaden';

  @override
  String get detailWeekends => 'Helger';

  @override
  String get detailAttachments => 'Bilagor';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filer',
      one: '1 fil',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsSectionDisplay => 'Visa';

  @override
  String get settingsSectionLanguage => 'Språk';

  @override
  String get settingsSectionCategories => 'Kategorier';

  @override
  String get settingsSectionAccounts => 'konton';

  @override
  String get settingsSectionPreferences => 'Inställningar';

  @override
  String get settingsSectionManage => 'Hantera';

  @override
  String get settingsBaseCurrency => 'Hemvaluta';

  @override
  String get settingsSecondaryCurrency => 'Sekundär valuta';

  @override
  String get settingsCategories => 'Kategorier';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount inkomst · $expenseCount kostnad';
  }

  @override
  String get settingsArchivedAccounts => 'Arkiverade konton';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Inga just nu – arkivera från kontoredigering när saldot är klart';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count dold från granskning och väljare';
  }

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsSectionPrivacy => 'Om';

  @override
  String get settingsPrivacyPolicyTitle => 'Integritetspolicy';

  @override
  String get settingsPrivacyPolicySubtitle => 'Hur Platrare hanterar din data.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Växelkurser: appen hämtar offentliga valutakurser över internet. Dina konton och transaktioner skickas aldrig.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Det gick inte att ladda sekretesspolicyn.';

  @override
  String get settingsPrivacyRetry => 'Försök igen';

  @override
  String get settingsSoftwareVersionTitle => 'Programvaruversion';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Release, diagnostik och juridiska';

  @override
  String get aboutScreenTitle => 'Om';

  @override
  String get aboutAppTagline =>
      'Reskontra, kassaflöde och planering i en arbetsyta.';

  @override
  String get aboutDescriptionBody =>
      'Platrare håller konton, transaktioner och planer på din enhet. Exportera krypterade säkerhetskopior när du behöver en kopia någon annanstans. Valutakurser använder endast offentlig marknadsdata; din reskontra laddas inte upp.';

  @override
  String get aboutVersionLabel => 'Version';

  @override
  String get aboutBuildLabel => 'Bygga';

  @override
  String get aboutCopySupportDetails => 'Kopiera supportinformation';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Öppnar hela policydokumentet i appen.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Plats';

  @override
  String get settingsSupportInfoCopied => 'Kopierade till urklipp';

  @override
  String get settingsVerifyLedger => 'Verifiera data';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Kontrollera att kontosaldon matchar din transaktionshistorik';

  @override
  String get settingsDataExportTitle => 'Exportera säkerhetskopia';

  @override
  String get settingsDataExportSubtitle =>
      'Spara som .zip eller krypterad .platrare med all data och bilagor';

  @override
  String get settingsDataImportTitle => 'Återställ från säkerhetskopia';

  @override
  String get settingsDataImportSubtitle =>
      'Ersätt aktuell data från en Platrare .zip eller .platrare backup';

  @override
  String get backupExportDialogTitle => 'Skydda denna säkerhetskopia';

  @override
  String get backupExportDialogBody =>
      'Ett starkt lösenord rekommenderas, särskilt om du lagrar filen i molnet. Du behöver samma lösenord för att importera.';

  @override
  String get backupExportPasswordLabel => 'Lösenord';

  @override
  String get backupExportPasswordConfirmLabel => 'Bekräfta lösenord';

  @override
  String get backupExportPasswordMismatch => 'Lösenord stämmer inte överens';

  @override
  String get backupExportPasswordEmpty =>
      'Ange ett matchande lösenord eller exportera utan kryptering nedan.';

  @override
  String get backupExportPasswordTooShort =>
      'Lösenordet måste vara minst 8 tecken.';

  @override
  String get backupExportSaveToDevice => 'Spara på enheten';

  @override
  String get backupExportShareToCloud => 'Dela (iCloud, Drive...)';

  @override
  String get backupExportWithoutEncryption => 'Exportera utan kryptering';

  @override
  String get backupExportSkipWarningTitle => 'Exportera utan kryptering?';

  @override
  String get backupExportSkipWarningBody =>
      'Alla som har tillgång till filen kan läsa dina data. Använd detta endast för lokala kopior som du kontrollerar.';

  @override
  String get backupExportSkipWarningConfirm => 'Exportera okrypterad';

  @override
  String get backupImportPasswordTitle => 'Krypterad backup';

  @override
  String get backupImportPasswordBody =>
      'Ange lösenordet du använde när du exporterade.';

  @override
  String get backupImportPasswordLabel => 'Lösenord';

  @override
  String get backupImportPreviewTitle => 'Säkerhetskopieringssammanfattning';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Appversion: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Exporterat: $date';
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
    return '$accounts konton · $transactions transaktioner · $planned planerade · $attachments bifogade filer · $income inkomstkategorier · $expense utgiftskategorier';
  }

  @override
  String get backupImportPreviewContinue => 'Fortsätta';

  @override
  String get settingsBackupWrongPassword => 'Fel lösenord';

  @override
  String get settingsBackupChecksumMismatch =>
      'Säkerhetskopieringen misslyckades integritetskontrollen';

  @override
  String get settingsBackupCorruptFile => 'Ogiltig eller skadad säkerhetskopia';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Säkerhetskopiering kräver en nyare appversion';

  @override
  String get settingsDataImportConfirmTitle => 'Ersätta nuvarande data?';

  @override
  String get settingsDataImportConfirmBody =>
      'Detta kommer att ersätta dina nuvarande konton, transaktioner, planerade transaktioner, kategorier och importerade bilagor med innehållet i den valda säkerhetskopian. Denna åtgärd kan inte ångras.';

  @override
  String get settingsDataImportConfirmAction => 'Byt ut data';

  @override
  String get settingsDataImportDone => 'Data har återställts';

  @override
  String get settingsDataImportInvalidFile =>
      'Den här filen är inte en giltig Platrare-säkerhetskopia';

  @override
  String get settingsDataImportFailed => 'Importen misslyckades';

  @override
  String get settingsDataExportDoneTitle => 'Backup exporterad';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Säkerhetskopieringen har sparats till:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Öppna filen';

  @override
  String get settingsDataExportFailed => 'Exporten misslyckades';

  @override
  String get ledgerVerifyDialogTitle => 'Ledger verifiering';

  @override
  String get ledgerVerifyAllMatch => 'Alla konton matchar.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Felmatchningar';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nLagrat: $stored\nRepris: $replayed\nSkillnad: $diff';
  }

  @override
  String get settingsLanguage => 'Appens språk';

  @override
  String get settingsLanguageSubtitleSystem => 'Följande systeminställningar';

  @override
  String get settingsLanguageSubtitleEnglish => 'engelska';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'serbiska (latin)';

  @override
  String get settingsLanguagePickerTitle => 'Appens språk';

  @override
  String get settingsLanguageOptionSystem => 'Systemstandard';

  @override
  String get settingsLanguageOptionEnglish => 'engelska';

  @override
  String get settingsLanguageOptionSerbianLatin => 'serbiska (latin)';

  @override
  String get settingsSectionAppearance => 'Utseende';

  @override
  String get settingsSectionSecurity => 'Säkerhet';

  @override
  String get settingsSecurityEnableLock => 'Lås appen på öppen';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Kräv biometrisk upplåsning eller PIN-kod när appen öppnas';

  @override
  String get settingsSecuritySetPin => 'Ställ in PIN-kod';

  @override
  String get settingsSecurityChangePin => 'Ändra PIN-kod';

  @override
  String get settingsSecurityPinSubtitle =>
      'Använd en PIN-kod som reserv om biometrisk inte är tillgänglig';

  @override
  String get settingsSecurityRemovePin => 'Ta bort PIN-koden';

  @override
  String get securitySetPinTitle => 'Ställ in app-PIN';

  @override
  String get securityPinLabel => 'PIN-kod';

  @override
  String get securityConfirmPinLabel => 'Bekräfta PIN-koden';

  @override
  String get securityPinMustBe4Digits =>
      'PIN-koden måste ha minst fyra siffror';

  @override
  String get securityPinMismatch => 'PIN-koderna stämmer inte överens';

  @override
  String get securityRemovePinTitle => 'Vill du ta bort PIN-koden?';

  @override
  String get securityRemovePinBody =>
      'Biometrisk upplåsning kan fortfarande användas om tillgängligt.';

  @override
  String get securityUnlockTitle => 'App låst';

  @override
  String get securityUnlockSubtitle =>
      'Lås upp med Face ID, fingeravtryck eller PIN-kod.';

  @override
  String get securityUnlockWithPin => 'Lås upp med PIN';

  @override
  String get securityTryBiometric => 'Prova biometrisk upplåsning';

  @override
  String get securityPinIncorrect => 'Fel PIN-kod, försök igen';

  @override
  String get securityBiometricReason => 'Autentisera för att öppna din app';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitleSystem => 'Följande systeminställningar';

  @override
  String get settingsThemeSubtitleLight => 'Ljus';

  @override
  String get settingsThemeSubtitleDark => 'Mörk';

  @override
  String get settingsThemePickerTitle => 'Tema';

  @override
  String get settingsThemeOptionSystem => 'Systemstandard';

  @override
  String get settingsThemeOptionLight => 'Ljus';

  @override
  String get settingsThemeOptionDark => 'Mörk';

  @override
  String get archivedAccountsTitle => 'Arkiverade konton';

  @override
  String get archivedAccountsEmptyTitle => 'Inga arkiverade konton';

  @override
  String get archivedAccountsEmptyBody =>
      'Bokfört saldo och övertrassering måste vara noll. Arkivera från kontoalternativ i Granska.';

  @override
  String get categoriesTitle => 'Kategorier';

  @override
  String get newCategoryTitle => 'Ny kategori';

  @override
  String get categoryNameLabel => 'Kategorinamn';

  @override
  String get deleteCategoryTitle => 'Ta bort kategori?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" kommer att tas bort från listan.';
  }

  @override
  String get categoryIncome => 'Inkomst';

  @override
  String get categoryExpense => 'Bekostnad';

  @override
  String get categoryAdd => 'Tillägga';

  @override
  String get searchCurrencies => 'Sök valutor...';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1Y';

  @override
  String get periodAll => 'ALLA';

  @override
  String get categoryLabel => 'kategori';

  @override
  String get categoriesLabel => 'kategorier';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type sparad • $amount';
  }

  @override
  String get tooltipSettings => 'Inställningar';

  @override
  String get tooltipAddAccount => 'Lägg till konto';

  @override
  String get tooltipRemoveAccount => 'Ta bort konto';

  @override
  String get accountNameTaken =>
      'Du har redan ett konto med detta namn och identifierare (aktivt eller arkiverat). Ändra namn eller identifierare.';

  @override
  String get groupDescPersonal => 'Dina egna plånböcker och bankkonton';

  @override
  String get groupDescIndividuals => 'Familj, vänner, individer';

  @override
  String get groupDescEntities => 'Enheter, verktyg, organisationer';

  @override
  String get cannotArchiveTitle => 'Kan inte arkivera ännu';

  @override
  String get cannotArchiveBody =>
      'Arkiv är endast tillgängligt när boksaldot och övertrasseringsgränsen båda är noll.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Arkiv är endast tillgängligt när boksaldot och övertrasseringsgränsen båda är noll. Justera huvudboken eller anläggningen först.';

  @override
  String get archiveAccountTitle => 'Arkivera konto?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planerade transaktioner refererar till detta konto.',
      one: '1 planerad transaktion refererar till detta konto.',
    );
    return '$_temp0 Ta bort dem för att hålla planen konsekvent med ett arkiverat konto.';
  }

  @override
  String get removeAndArchive => 'Ta bort planerat & arkivera';

  @override
  String get archiveBody =>
      'Kontot kommer att döljas från gransknings-, spårnings- och planväljare. Du kan återställa det från Inställningar.';

  @override
  String get archiveAction => 'Arkiv';

  @override
  String get archiveInstead => 'Arkivera istället';

  @override
  String get cannotDeleteTitle => 'Kan inte ta bort konto';

  @override
  String get cannotDeleteBodyShort =>
      'Det här kontot visas i din spårhistorik. Ta bort eller tilldela om dessa transaktioner först, eller arkivera kontot om saldot har rensats.';

  @override
  String get cannotDeleteBodyHistory =>
      'Det här kontot visas i din spårhistorik. Att ta bort skulle bryta den historiken – ta bort eller tilldela om transaktionerna först.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Det här kontot visas i din spårhistorik, så det kan inte raderas. Du kan arkivera det istället om boksaldot och övertrasseringen rensas – det kommer att döljas från listor men historiken förblir intakt.';

  @override
  String get deleteAccountTitle => 'Ta bort konto?';

  @override
  String get deleteAccountBodyPermanent =>
      'Detta konto kommer att tas bort permanent.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count planerade transaktioner refererar till detta konto och tas också bort.',
      one:
          '1 planerad transaktion refererar till detta konto och tas också bort.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Ta bort alla';

  @override
  String get editAccountTitle => 'Redigera konto';

  @override
  String get newAccountTitle => 'Nytt konto';

  @override
  String get labelAccountName => 'Kontonamn';

  @override
  String get labelAccountIdentifier => 'Identifierare (valfritt)';

  @override
  String get accountAppearanceSection => 'Ikon och färg';

  @override
  String get accountPickIcon => 'Välj ikon';

  @override
  String get accountPickColor => 'Välj färg';

  @override
  String get accountIconSheetTitle => 'Kontoikon';

  @override
  String get accountColorSheetTitle => 'Kontofärg';

  @override
  String get accountUseInitialLetter => 'Inledande brev';

  @override
  String get accountUseDefaultColor => 'Matchgrupp';

  @override
  String get labelRealBalance => 'Riktig balans';

  @override
  String get labelOverdraftLimit => 'Övertrassering/förskottsgräns';

  @override
  String get labelCurrency => 'Valuta';

  @override
  String get saveChanges => 'Spara ändringar';

  @override
  String get addAccountAction => 'Lägg till konto';

  @override
  String get removeAccountSheetTitle => 'Ta bort konto';

  @override
  String get deletePermanently => 'Ta bort permanent';

  @override
  String get deletePermanentlySubtitle =>
      'Endast möjligt när detta konto inte används i Track. Planerade objekt kan tas bort som en del av radering.';

  @override
  String get archiveOptionSubtitle =>
      'Dölj från granskning och väljare. Återställ när som helst från Inställningar. Kräver nollsaldo och övertrassering.';

  @override
  String get archivedBannerText =>
      'Detta konto är arkiverat. Det finns kvar i din data men döljs från listor och väljare.';

  @override
  String get balanceAdjustedTitle => 'Balans justerad i Track';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Verkligt saldo uppdaterades från $previous till $current $symbol.\n\nEn saldojusteringstransaktion skapades i Track (Historik) för att hålla redovisningen konsekvent.\n\n• Verkligt saldo återspeglar det faktiska beloppet på detta konto.\n• Kontrollera Historik för justeringsposten.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Balansjustering';

  @override
  String get descriptionBalanceCorrection => 'Balanskorrigering';

  @override
  String get descriptionOpeningBalance => 'Ingående balans';

  @override
  String get reviewStatsModeStatistics => 'Statistik';

  @override
  String get reviewStatsModeComparison => 'Jämförelse';

  @override
  String get statsUncategorized => 'Okategoriserad';

  @override
  String get statsNoCategories =>
      'Inga kategorier i de valda perioderna för jämförelse.';

  @override
  String get statsNoTransactions => 'Inga transaktioner';

  @override
  String get statsSpendingInCategory => 'Utgifter i denna kategori';

  @override
  String get statsIncomeInCategory => 'Inkomst i denna kategori';

  @override
  String get statsDifference => 'Skillnad (B vs A):';

  @override
  String get statsNoExpensesMonth => 'Inga utgifter denna månad';

  @override
  String get statsNoExpensesAll => 'Inga utgifter registrerade';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Inga utgifter under de senaste $period';
  }

  @override
  String get statsTotalSpent => 'Totalt spenderat';

  @override
  String get statsNoExpensesThisPeriod => 'Inga kostnader under denna period';

  @override
  String get statsNoIncomeMonth => 'Ingen inkomst denna månad';

  @override
  String get statsNoIncomeAll => 'Inga registrerade inkomster';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Ingen inkomst under den senaste $period';
  }

  @override
  String get statsTotalReceived => 'Totalt mottaget';

  @override
  String get statsNoIncomeThisPeriod => 'Ingen inkomst under denna period';

  @override
  String get catSalary => 'Lön';

  @override
  String get catFreelance => 'Frilans';

  @override
  String get catConsulting => 'Konsultverksamhet';

  @override
  String get catGift => 'Gåva';

  @override
  String get catRental => 'Uthyrning';

  @override
  String get catDividends => 'Utdelningar';

  @override
  String get catRefund => 'Återbetalning';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catInterest => 'Intressera';

  @override
  String get catSideHustle => 'Sido jäkt';

  @override
  String get catSaleOfGoods => 'Försäljning av varor';

  @override
  String get catOther => 'Andra';

  @override
  String get catGroceries => 'Specerier';

  @override
  String get catDining => 'Matsal';

  @override
  String get catTransport => 'Transport';

  @override
  String get catUtilities => 'Verktyg';

  @override
  String get catHousing => 'Hus';

  @override
  String get catHealthcare => 'Sjukvård';

  @override
  String get catEntertainment => 'Underhållning';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catTravel => 'Resa';

  @override
  String get catEducation => 'Utbildning';

  @override
  String get catSubscriptions => 'Prenumerationer';

  @override
  String get catInsurance => 'Försäkring';

  @override
  String get catFuel => 'Bränsle';

  @override
  String get catGym => 'Gym';

  @override
  String get catPets => 'Husdjur';

  @override
  String get catKids => 'Barn';

  @override
  String get catCharity => 'Välgörenhet';

  @override
  String get catCoffee => 'Kaffe';

  @override
  String get catGifts => 'Gåvor';

  @override
  String semanticsProjectionDate(String date) {
    return 'Projekteringsdatum $date. Dubbeltryck för att välja datum';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Beräknad personlig balans $amount';
  }

  @override
  String get statsEmptyTitle => 'Inga transaktioner ännu';

  @override
  String get statsEmptySubtitle =>
      'Ingen utgiftsdata för det valda intervallet.';

  @override
  String get semanticsShowProjections =>
      'Visa prognostiserade saldon per konto';

  @override
  String get semanticsHideProjections => 'Dölj beräknade saldon per konto';

  @override
  String get semanticsDateAllTime =>
      'Datum: hela tiden — tryck för att ändra läge';

  @override
  String semanticsDateMode(String mode) {
    return 'Datum: $mode — tryck för att ändra läge';
  }

  @override
  String get semanticsDateThisMonth =>
      'Datum: denna månad – tryck för månad, vecka, år eller hela tiden';

  @override
  String get semanticsTxTypeCycle =>
      'Transaktionstyp: cykla alla, inkomst, kostnad, överföring';

  @override
  String get semanticsAccountFilter => 'Kontofilter';

  @override
  String get semanticsAlreadyFiltered => 'Redan filtrerad till det här kontot';

  @override
  String get semanticsCategoryFilter => 'Kategorifilter';

  @override
  String get semanticsSortToggle =>
      'Sortera: växla mellan nyaste eller äldsta först';

  @override
  String get semanticsFiltersDisabled =>
      'Listfilter inaktiverade när du tittar på ett framtida projektionsdatum. Rensa projektioner för att använda filter.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Listfilter inaktiverade. Lägg till ett konto först.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Listfilter inaktiverade. Lägg till en planerad transaktion först.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Listfilter inaktiverade. Spela in en transaktion först.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Sektions- och valutakontroller inaktiverade. Lägg till ett konto först.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Prognosdatum och balansfördelning inaktiverade. Lägg till ett konto och en planerad transaktion först.';

  @override
  String get semanticsReorderAccountHint =>
      'Tryck länge och dra sedan för att ändra ordningen inom den här gruppen';

  @override
  String get semanticsChartStyle => 'Diagramstil';

  @override
  String get semanticsChartStyleUnavailable =>
      'Diagramstil (inte tillgänglig i jämförelseläge)';

  @override
  String semanticsPeriod(String label) {
    return 'Period: $label';
  }

  @override
  String get trackSearchHint => 'Sök beskrivning, kategori, konto...';

  @override
  String get trackSearchClear => 'Rensa sökning';

  @override
  String get settingsExchangeRatesTitle => 'Växelkurser';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Senast uppdaterad: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Använda offline- eller paketpriser – tryck för att uppdatera';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Växelkurser uppdaterade';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Det gick inte att uppdatera växelkurserna. Kontrollera din anslutning.';

  @override
  String get settingsClearData => 'Rensa data';

  @override
  String get settingsClearDataSubtitle => 'Ta bort markerade data permanent';

  @override
  String get clearDataTitle => 'Rensa data';

  @override
  String get clearDataTransactions => 'Transaktionshistorik';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transaktioner · kontosaldon nollställs';
  }

  @override
  String get clearDataPlanned => 'Planerade transaktioner';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count planerade objekt';
  }

  @override
  String get clearDataAccounts => 'konton';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count konton · rensar också historik och plan';
  }

  @override
  String get clearDataCategories => 'Kategorier';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count kategorier · ersatt med standardvärden';
  }

  @override
  String get clearDataPreferences => 'Inställningar';

  @override
  String get clearDataPreferencesSubtitle =>
      'Återställ valuta, tema och språk till standardinställningarna';

  @override
  String get clearDataSecurity => 'Applås & PIN-kod';

  @override
  String get clearDataSecuritySubtitle =>
      'Inaktivera applås och ta bort PIN-kod';

  @override
  String get clearDataConfirmButton => 'Rensa markerat';

  @override
  String get clearDataConfirmTitle => 'Detta kan inte ångras';

  @override
  String get clearDataConfirmBody =>
      'Den valda informationen kommer att raderas permanent. Exportera en säkerhetskopia först om du kan behöva den senare.';

  @override
  String get clearDataTypeConfirm => 'Skriv DELETE för att bekräfta';

  @override
  String get clearDataTypeConfirmError =>
      'Skriv DELETE exakt för att fortsätta';

  @override
  String get clearDataPinTitle => 'Bekräfta med PIN';

  @override
  String get clearDataPinBody =>
      'Ange din app-PIN för att godkänna denna åtgärd.';

  @override
  String get clearDataPinIncorrect => 'Felaktig PIN-kod';

  @override
  String get clearDataDone => 'Valda data raderade';

  @override
  String get autoBackupTitle => 'Automatisk daglig säkerhetskopiering';

  @override
  String autoBackupLastAt(String date) {
    return 'Senast säkerhetskopierades $date';
  }

  @override
  String get autoBackupNeverRun => 'Ingen backup ännu';

  @override
  String get autoBackupShareTitle => 'Spara till molnet';

  @override
  String get autoBackupShareSubtitle =>
      'Ladda upp senaste säkerhetskopian till iCloud Drive, Google Drive eller valfri app';

  @override
  String get autoBackupCloudReminder =>
      'Klar för automatisk säkerhetskopiering – spara den i molnet för skydd utanför enheten';

  @override
  String get autoBackupCloudReminderAction => 'Dela';

  @override
  String get persistenceErrorReloaded =>
      'Det gick inte att spara ändringarna. Data laddades om från lagringen.';
}
