// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Planen';

  @override
  String get navTrack => 'Schiene';

  @override
  String get navReview => 'Rezension';

  @override
  String get cancel => 'Stornieren';

  @override
  String get delete => 'Löschen';

  @override
  String get close => 'Schließen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get undo => 'Rückgängig machen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get heroIn => 'In';

  @override
  String get heroOut => 'Aus';

  @override
  String get heroNet => 'Netto';

  @override
  String get heroBalance => 'Gleichgewicht';

  @override
  String get realBalance => 'Echtes Gleichgewicht';

  @override
  String get heroResetButton => 'Zurücksetzen';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterAllAccounts => 'Alle Konten';

  @override
  String get filterAllCategories => 'Alle Kategorien';

  @override
  String get txLabelIncome => 'EINKOMMEN';

  @override
  String get txLabelExpense => 'KOSTEN';

  @override
  String get txLabelInvoice => 'RECHNUNG';

  @override
  String get txLabelBill => 'RECHNUNG';

  @override
  String get txLabelAdvance => 'VORAUSZAHLUNG';

  @override
  String get txLabelSettlement => 'SIEDLUNG';

  @override
  String get txLabelLoan => 'DARLEHEN';

  @override
  String get txLabelCollection => 'SAMMLUNG';

  @override
  String get txLabelOffset => 'OFFSET';

  @override
  String get txLabelTransfer => 'ÜBERWEISEN';

  @override
  String get txLabelTransaction => 'TRANSAKTION';

  @override
  String get repeatNone => 'Keine Wiederholung';

  @override
  String get repeatDaily => 'Täglich';

  @override
  String get repeatWeekly => 'Wöchentlich';

  @override
  String get repeatMonthly => 'Monatlich';

  @override
  String get repeatYearly => 'Jährlich';

  @override
  String get repeatEveryLabel => 'Jeder';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: 'Tag',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wochen',
      one: 'Woche',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Monate',
      one: 'Monat',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jahre',
      one: 'Jahr',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Endet';

  @override
  String get repeatEndNever => 'Niemals';

  @override
  String get repeatEndOnDate => 'Am Datum';

  @override
  String repeatEndAfterCount(int count) {
    return 'Nach $count Zeiten';
  }

  @override
  String get repeatEndPickDate => 'Wählen Sie das Enddatum';

  @override
  String get repeatEndTimes => 'mal';

  @override
  String repeatSummaryEvery(int count, String unit) {
    return 'Jeden $count $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'bis $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count Mal';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining von $total übrig';
  }

  @override
  String get detailRepeatEvery => 'Wiederholen Sie alle';

  @override
  String get detailEnds => 'Endet';

  @override
  String get detailEndsNever => 'Niemals';

  @override
  String detailEndsOnDate(String date) {
    return 'Auf $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Nach $count Zeiten';
  }

  @override
  String get detailProgress => 'Fortschritt';

  @override
  String get weekendNoChange => 'Keine Änderung';

  @override
  String get weekendFriday => 'Auf Freitag verschieben';

  @override
  String get weekendMonday => 'Auf Montag verschieben';

  @override
  String weekendQuestion(String day) {
    return 'Wenn der $day auf ein Wochenende fällt?';
  }

  @override
  String get dateToday => 'Heute';

  @override
  String get dateTomorrow => 'Morgen';

  @override
  String get dateYesterday => 'Gestern';

  @override
  String get statsAllTime => 'Alle Zeiten';

  @override
  String get accountGroupPersonal => 'Persönlich';

  @override
  String get accountGroupIndividual => 'Person';

  @override
  String get accountGroupEntity => 'Juristische Person';

  @override
  String get accountSectionIndividuals => 'Einzelpersonen';

  @override
  String get accountSectionEntities => 'Entitäten';

  @override
  String get emptyNoTransactionsYet => 'Noch keine Transaktionen';

  @override
  String get emptyNoAccountsYet => 'Noch keine Konten';

  @override
  String get emptyRecordFirstTransaction =>
      'Tippen Sie auf die Schaltfläche unten, um Ihre erste Transaktion aufzuzeichnen.';

  @override
  String get emptyAddFirstAccountTx =>
      'Fügen Sie Ihr erstes Konto hinzu, bevor Sie Transaktionen aufzeichnen.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Fügen Sie Ihr erstes Konto hinzu, bevor Sie Transaktionen planen.';

  @override
  String get emptyAddFirstAccountReview =>
      'Fügen Sie Ihr erstes Konto hinzu, um mit der Verfolgung Ihrer Finanzen zu beginnen.';

  @override
  String get emptyAddTransaction => 'Transaktion hinzufügen';

  @override
  String get emptyAddAccount => 'Konto hinzufügen';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Noch keine persönlichen Konten';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Persönliche Konten sind Ihre eigenen Geldbörsen und Bankkonten. Fügen Sie eine hinzu, um die täglichen Einnahmen und Ausgaben zu verfolgen.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'Noch keine Einzelkonten';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Auf Einzelkonten wird das Geld bestimmter Personen erfasst – geteilte Kosten, Kredite oder Schuldscheine. Fügen Sie für jede Person, mit der Sie abrechnen, ein Konto hinzu.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Noch keine Unternehmenskonten';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Entitätskonten gelten für Unternehmen, Projekte oder Organisationen. Nutzen Sie sie, um den geschäftlichen Cashflow von Ihren persönlichen Finanzen zu trennen.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Keine Transaktionen für angewendete Filter';

  @override
  String get emptyNoTransactionsInHistory =>
      'Keine Transaktionen in der Geschichte';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Keine Transaktionen für $month';
  }

  @override
  String get emptyNoTransactionsForAccount =>
      'Keine Transaktionen für dieses Konto';

  @override
  String get trackTransactionDeleted => 'Transaktion gelöscht';

  @override
  String get trackDeleteTitle => 'Transaktion löschen?';

  @override
  String get trackDeleteBody =>
      'Dadurch werden die Änderungen des Kontostands rückgängig gemacht.';

  @override
  String get trackTransaction => 'Transaktion';

  @override
  String get planConfirmTitle => 'Transaktion bestätigen?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Dieses Ereignis ist für $date geplant. Es wird im Verlauf mit dem heutigen Datum ($todayDate) aufgezeichnet. Das nächste Vorkommen bleibt auf $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Dadurch wird die Transaktion auf Ihren tatsächlichen Kontostand angewendet und in den Verlauf verschoben.';

  @override
  String get planTransactionConfirmed => 'Transaktion bestätigt und angewendet';

  @override
  String get planTransactionRemoved => 'Geplante Transaktion entfernt';

  @override
  String get planRepeatingTitle => 'Wiederholte Transaktion';

  @override
  String get planRepeatingBody =>
      'Überspringen Sie nur dieses Datum – die Serie wird mit dem nächsten Termin fortgesetzt – oder löschen Sie alle verbleibenden Termine aus Ihrem Plan.';

  @override
  String get planDeleteAll => 'Alles löschen';

  @override
  String get planSkipThisOnly => 'Überspringen Sie nur dies';

  @override
  String get planOccurrenceSkipped =>
      'Dieser Vorfall wurde übersprungen – der nächste ist geplant';

  @override
  String get planNothingPlanned => 'Im Moment ist nichts geplant';

  @override
  String get planPlanBody => 'Planen Sie bevorstehende Transaktionen.';

  @override
  String get planAddPlan => 'Plan hinzufügen';

  @override
  String get planNoPlannedForFilters =>
      'Keine geplanten Transaktionen für angewendete Filter';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Keine geplanten Transaktionen in $month';
  }

  @override
  String get planOverdue => 'überfällig';

  @override
  String get planPlannedTransaction => 'Geplante Transaktion';

  @override
  String get discardTitle => 'Änderungen verwerfen?';

  @override
  String get discardBody =>
      'Sie haben nicht gespeicherte Änderungen. Sie gehen verloren, wenn Sie jetzt gehen.';

  @override
  String get keepEditing => 'Bearbeiten Sie weiter';

  @override
  String get discard => 'Verwerfen';

  @override
  String get newTransactionTitle => 'Neue Transaktion';

  @override
  String get editTransactionTitle => 'Transaktion bearbeiten';

  @override
  String get transactionUpdated => 'Transaktion aktualisiert';

  @override
  String get sectionAccounts => 'Konten';

  @override
  String get labelFrom => 'Aus';

  @override
  String get labelTo => 'Zu';

  @override
  String get sectionCategory => 'Kategorie';

  @override
  String get sectionAttachments => 'Anhänge';

  @override
  String get labelNote => 'Notiz';

  @override
  String get hintOptionalDescription => 'Optionale Beschreibung';

  @override
  String get updateTransaction => 'Transaktion aktualisieren';

  @override
  String get saveTransaction => 'Transaktion speichern';

  @override
  String get selectAccount => 'Konto auswählen';

  @override
  String get selectAccountTitle => 'Wählen Sie Konto aus';

  @override
  String get noAccountsAvailable => 'Keine Konten verfügbar';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Von $name ($currency) erhaltener Betrag';
  }

  @override
  String get amountReceivedHelper =>
      'Geben Sie den genauen Betrag ein, den das Zielkonto erhält. Dadurch wird der tatsächlich verwendete Wechselkurs gesperrt.';

  @override
  String get attachTakePhoto => 'Machen Sie ein Foto';

  @override
  String get attachTakePhotoSub =>
      'Verwenden Sie die Kamera, um eine Quittung aufzunehmen';

  @override
  String get attachChooseGallery => 'Wählen Sie aus der Galerie';

  @override
  String get attachChooseGallerySub =>
      'Wählen Sie Fotos aus Ihrer Bibliothek aus';

  @override
  String get attachBrowseFiles => 'Durchsuchen Sie Dateien';

  @override
  String get attachBrowseFilesSub =>
      'Hängen Sie PDFs, Dokumente oder andere Dateien an';

  @override
  String get attachButton => 'Befestigen';

  @override
  String get editPlanTitle => 'Plan bearbeiten';

  @override
  String get planTransactionTitle => 'Transaktion planen';

  @override
  String get tapToSelect => 'Zum Auswählen tippen';

  @override
  String get updatePlan => 'Update-Plan';

  @override
  String get addToPlan => 'Zum Plan hinzufügen';

  @override
  String get labelRepeat => 'Wiederholen';

  @override
  String get selectPlannedDate => 'Geplantes Datum auswählen';

  @override
  String get balancesAsOfToday => 'Stand heute';

  @override
  String get projectedBalancesForTomorrow =>
      'Voraussichtliche Salden für morgen';

  @override
  String projectedBalancesForDate(String date) {
    return 'Voraussichtliche Salden für $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name empfängt ($currency)';
  }

  @override
  String get destHelper =>
      'Geschätzter Zielbetrag. Der genaue Preis wird bei der Bestätigung gesperrt.';

  @override
  String get descriptionOptional => 'Beschreibung (optional)';

  @override
  String get detailTransactionTitle => 'Transaktion';

  @override
  String get detailPlannedTitle => 'Geplant';

  @override
  String get detailConfirmTransaction => 'Bestätigen Sie die Transaktion';

  @override
  String get detailDate => 'Datum';

  @override
  String get detailFrom => 'Aus';

  @override
  String get detailTo => 'Zu';

  @override
  String get detailCategory => 'Kategorie';

  @override
  String get detailNote => 'Notiz';

  @override
  String get detailDestinationAmount => 'Zielbetrag';

  @override
  String get detailExchangeRate => 'Wechselkurs';

  @override
  String get detailRepeats => 'Wiederholt';

  @override
  String get detailDayOfMonth => 'Tag des Monats';

  @override
  String get detailWeekends => 'Wochenenden';

  @override
  String get detailAttachments => 'Anhänge';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien',
      one: '1 Datei',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionDisplay => 'Anzeige';

  @override
  String get settingsSectionLanguage => 'Sprache';

  @override
  String get settingsSectionCategories => 'Kategorien';

  @override
  String get settingsSectionAccounts => 'Konten';

  @override
  String get settingsSectionPreferences => 'Präferenzen';

  @override
  String get settingsSectionManage => 'Verwalten';

  @override
  String get settingsBaseCurrency => 'Heimatwährung';

  @override
  String get settingsSecondaryCurrency => 'Sekundärwährung';

  @override
  String get settingsCategories => 'Kategorien';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount Einnahmen · $expenseCount Ausgaben';
  }

  @override
  String get settingsArchivedAccounts => 'Archivierte Konten';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Im Moment keine – aus der Kontobearbeitung archivieren, wenn der Kontostand klar ist';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count vor Überprüfung und Auswahl verborgen';
  }

  @override
  String get settingsSectionData => 'Daten';

  @override
  String get settingsSectionPrivacy => 'Um';

  @override
  String get settingsPrivacyPolicyTitle => 'Datenschutzrichtlinie';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Wie Platrare mit Ihren Daten umgeht.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Wechselkurse: Die App ruft öffentliche Wechselkurse über das Internet ab. Ihre Konten und Transaktionen werden niemals gesendet.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Die Datenschutzrichtlinie konnte nicht geladen werden.';

  @override
  String get settingsPrivacyRetry => 'Versuchen Sie es erneut';

  @override
  String get settingsSoftwareVersionTitle => 'Softwareversion';

  @override
  String get settingsSoftwareVersionSubtitle => 'Freigabe, Diagnose und Recht';

  @override
  String get aboutScreenTitle => 'Um';

  @override
  String get aboutAppTagline =>
      'Hauptbuch, Cashflow und Planung in einem Arbeitsbereich.';

  @override
  String get aboutDescriptionBody =>
      'Platrare speichert Konten, Transaktionen und Pläne auf Ihrem Gerät. Exportieren Sie verschlüsselte Backups, wenn Sie an anderer Stelle eine Kopie benötigen. Für Wechselkurse werden ausschließlich öffentliche Marktdaten verwendet. Ihr Hauptbuch wurde nicht hochgeladen.';

  @override
  String get aboutVersionLabel => 'Version';

  @override
  String get aboutBuildLabel => 'Bauen';

  @override
  String get aboutCopySupportDetails => 'Supportdetails kopieren';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Öffnet das vollständige In-App-Richtliniendokument.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Gebietsschema';

  @override
  String get settingsSupportInfoCopied => 'In die Zwischenablage kopiert';

  @override
  String get settingsVerifyLedger => 'Daten überprüfen';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Überprüfen Sie, ob der Kontostand mit Ihrem Transaktionsverlauf übereinstimmt';

  @override
  String get settingsDataExportTitle => 'Backup exportieren';

  @override
  String get settingsDataExportSubtitle =>
      'Speichern Sie es als .zip oder verschlüsseltes .platrare mit allen Daten und Anhängen';

  @override
  String get settingsDataImportTitle => 'Aus Backup wiederherstellen';

  @override
  String get settingsDataImportSubtitle =>
      'Ersetzen Sie aktuelle Daten aus einem Platrare .zip- oder .platrare-Backup';

  @override
  String get backupExportDialogTitle => 'Schützen Sie dieses Backup';

  @override
  String get backupExportDialogBody =>
      'Ein sicheres Passwort wird empfohlen, insbesondere wenn Sie die Datei in der Cloud speichern. Für den Import benötigen Sie dasselbe Passwort.';

  @override
  String get backupExportPasswordLabel => 'Passwort';

  @override
  String get backupExportPasswordConfirmLabel => 'Passwort bestätigen';

  @override
  String get backupExportPasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get backupExportPasswordEmpty =>
      'Geben Sie ein passendes Passwort ein oder exportieren Sie unten ohne Verschlüsselung.';

  @override
  String get backupExportPasswordTooShort =>
      'Das Passwort muss mindestens 8 Zeichen lang sein.';

  @override
  String get backupExportSaveToDevice => 'Auf Gerät speichern';

  @override
  String get backupExportShareToCloud => 'Teilen (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Export ohne Verschlüsselung';

  @override
  String get backupExportSkipWarningTitle =>
      'Ohne Verschlüsselung exportieren?';

  @override
  String get backupExportSkipWarningBody =>
      'Jeder, der Zugriff auf die Datei hat, kann Ihre Daten lesen. Verwenden Sie dies nur für lokale Kopien, die Sie kontrollieren.';

  @override
  String get backupExportSkipWarningConfirm => 'Unverschlüsselt exportieren';

  @override
  String get backupImportPasswordTitle => 'Verschlüsseltes Backup';

  @override
  String get backupImportPasswordBody =>
      'Geben Sie das Passwort ein, das Sie beim Exportieren verwendet haben.';

  @override
  String get backupImportPasswordLabel => 'Passwort';

  @override
  String get backupImportPreviewTitle => 'Backup-Zusammenfassung';

  @override
  String backupImportPreviewVersion(String version) {
    return 'App-Version: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Exportiert: $date';
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
    return '$accounts Konten · $transactions Transaktionen · $planned geplant · $attachments Anhangsdateien · $income Einkommenskategorien · $expense Ausgabenkategorien';
  }

  @override
  String get backupImportPreviewContinue => 'Weitermachen';

  @override
  String get settingsBackupWrongPassword => 'Falsches Passwort';

  @override
  String get settingsBackupChecksumMismatch =>
      'Die Integritätsprüfung der Sicherung ist fehlgeschlagen';

  @override
  String get settingsBackupCorruptFile =>
      'Ungültige oder beschädigte Sicherungsdatei';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Für die Sicherung ist eine neuere App-Version erforderlich';

  @override
  String get settingsDataImportConfirmTitle => 'Aktuelle Daten ersetzen?';

  @override
  String get settingsDataImportConfirmBody =>
      'Dadurch werden Ihre aktuellen Konten, Transaktionen, geplanten Transaktionen, Kategorien und importierten Anhänge durch den Inhalt des ausgewählten Backups ersetzt. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get settingsDataImportConfirmAction => 'Daten ersetzen';

  @override
  String get settingsDataImportDone => 'Daten erfolgreich wiederhergestellt';

  @override
  String get settingsDataImportInvalidFile =>
      'Diese Datei ist kein gültiges Platrare-Backup';

  @override
  String get settingsDataImportFailed => 'Der Import ist fehlgeschlagen';

  @override
  String get settingsDataExportDoneTitle => 'Backup exportiert';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Backup gespeichert unter:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Datei öffnen';

  @override
  String get settingsDataExportFailed => 'Der Export ist fehlgeschlagen';

  @override
  String get ledgerVerifyDialogTitle => 'Überprüfung des Hauptbuchs';

  @override
  String get ledgerVerifyAllMatch => 'Alle Konten stimmen überein.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Nichtübereinstimmungen';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nGespeichert: $stored\nWiederholung: $replayed\nUnterschied: $diff';
  }

  @override
  String get settingsLanguage => 'App-Sprache';

  @override
  String get settingsLanguageSubtitleSystem => 'Folgende Systemeinstellungen';

  @override
  String get settingsLanguageSubtitleEnglish => 'Englisch';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Serbisch (Latein)';

  @override
  String get settingsLanguagePickerTitle => 'App-Sprache';

  @override
  String get settingsLanguageOptionSystem => 'Systemstandard';

  @override
  String get settingsLanguageOptionEnglish => 'Englisch';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Serbisch (Latein)';

  @override
  String get settingsSectionAppearance => 'Aussehen';

  @override
  String get settingsSectionSecurity => 'Sicherheit';

  @override
  String get settingsSecurityEnableLock => 'App beim Öffnen sperren';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Beim Öffnen der App ist eine biometrische Entsperrung oder eine PIN erforderlich';

  @override
  String get settingsSecuritySetPin => 'PIN festlegen';

  @override
  String get settingsSecurityChangePin => 'PIN ändern';

  @override
  String get settingsSecurityPinSubtitle =>
      'Verwenden Sie eine PIN als Ersatz, wenn biometrische Daten nicht verfügbar sind';

  @override
  String get settingsSecurityRemovePin => 'PIN entfernen';

  @override
  String get securitySetPinTitle => 'App-PIN festlegen';

  @override
  String get securityPinLabel => 'PIN-Code';

  @override
  String get securityConfirmPinLabel => 'PIN-Code bestätigen';

  @override
  String get securityPinMustBe4Digits =>
      'Die PIN muss mindestens 4 Ziffern haben';

  @override
  String get securityPinMismatch => 'PIN-Codes stimmen nicht überein';

  @override
  String get securityRemovePinTitle => 'PIN entfernen?';

  @override
  String get securityRemovePinBody =>
      'Die biometrische Entsperrung kann weiterhin verwendet werden, sofern verfügbar.';

  @override
  String get securityUnlockTitle => 'App gesperrt';

  @override
  String get securityUnlockSubtitle =>
      'Entsperren mit Face ID, Fingerabdruck oder PIN.';

  @override
  String get securityUnlockWithPin => 'Mit PIN entsperren';

  @override
  String get securityTryBiometric =>
      'Versuchen Sie es mit biometrischer Entsperrung';

  @override
  String get securityPinIncorrect => 'Falsche PIN, versuchen Sie es erneut';

  @override
  String get securityBiometricReason =>
      'Authentifizieren Sie sich, um Ihre App zu öffnen';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get settingsThemeSubtitleSystem => 'Folgende Systemeinstellungen';

  @override
  String get settingsThemeSubtitleLight => 'Licht';

  @override
  String get settingsThemeSubtitleDark => 'Dunkel';

  @override
  String get settingsThemePickerTitle => 'Thema';

  @override
  String get settingsThemeOptionSystem => 'Systemstandard';

  @override
  String get settingsThemeOptionLight => 'Licht';

  @override
  String get settingsThemeOptionDark => 'Dunkel';

  @override
  String get archivedAccountsTitle => 'Archivierte Konten';

  @override
  String get archivedAccountsEmptyTitle => 'Keine archivierten Konten';

  @override
  String get archivedAccountsEmptyBody =>
      'Der Buchsaldo und der Überziehungskredit müssen Null sein. Archivieren von Kontooptionen in Review.';

  @override
  String get categoriesTitle => 'Kategorien';

  @override
  String get newCategoryTitle => 'Neue Kategorie';

  @override
  String get categoryNameLabel => 'Kategoriename';

  @override
  String get deleteCategoryTitle => 'Kategorie löschen?';

  @override
  String deleteCategoryBody(String category) {
    return '„$category“ wird aus der Liste entfernt.';
  }

  @override
  String get categoryIncome => 'Einkommen';

  @override
  String get categoryExpense => 'Kosten';

  @override
  String get categoryAdd => 'Hinzufügen';

  @override
  String get searchCurrencies => 'Währungen suchen…';

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
  String get categoryLabel => 'Kategorie';

  @override
  String get categoriesLabel => 'Kategorien';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type gespeichert • $amount';
  }

  @override
  String get tooltipSettings => 'Einstellungen';

  @override
  String get tooltipAddAccount => 'Konto hinzufügen';

  @override
  String get tooltipRemoveAccount => 'Konto entfernen';

  @override
  String get accountNameTaken =>
      'Sie haben bereits ein Konto mit diesem Namen und dieser Kennung (aktiv oder archiviert). Ändern Sie den Namen oder die Kennung.';

  @override
  String get groupDescPersonal => 'Ihre eigenen Geldbörsen und Bankkonten';

  @override
  String get groupDescIndividuals => 'Familie, Freunde, Einzelpersonen';

  @override
  String get groupDescEntities =>
      'Körperschaften, Versorgungsunternehmen, Organisationen';

  @override
  String get cannotArchiveTitle => 'Kann noch nicht archiviert werden';

  @override
  String get cannotArchiveBody =>
      'Das Archiv ist nur verfügbar, wenn sowohl der Buchsaldo als auch das Überziehungslimit effektiv Null sind.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Das Archiv ist nur verfügbar, wenn sowohl der Buchsaldo als auch das Überziehungslimit effektiv Null sind. Passen Sie zuerst das Hauptbuch oder die Einrichtung an.';

  @override
  String get archiveAccountTitle => 'Archivkonto?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geplante Transaktionen verweisen auf dieses Konto.',
      one: '1 geplante Transaktion verweist auf dieses Konto.',
    );
    return '$_temp0 Entfernen Sie sie, damit Ihr Plan mit einem archivierten Konto konsistent bleibt.';
  }

  @override
  String get removeAndArchive => 'Geplant entfernen und archivieren';

  @override
  String get archiveBody =>
      'Das Konto wird für die Überprüfungs-, Nachverfolgungs- und Planauswahl ausgeblendet. Sie können es über die Einstellungen wiederherstellen.';

  @override
  String get archiveAction => 'Archiv';

  @override
  String get archiveInstead => 'Stattdessen archivieren';

  @override
  String get cannotDeleteTitle => 'Konto kann nicht gelöscht werden';

  @override
  String get cannotDeleteBodyShort =>
      'Dieses Konto wird in Ihrem Trackverlauf angezeigt. Entfernen Sie diese Transaktionen zuerst oder weisen Sie sie neu zu oder archivieren Sie das Konto, wenn der Saldo ausgeglichen ist.';

  @override
  String get cannotDeleteBodyHistory =>
      'Dieses Konto wird in Ihrem Trackverlauf angezeigt. Durch das Löschen würde dieser Verlauf zerstört. Entfernen Sie zuerst diese Transaktionen oder weisen Sie sie neu zu.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Dieses Konto wird in Ihrem Trackverlauf angezeigt und kann daher nicht gelöscht werden. Sie können es stattdessen archivieren, wenn der Buchsaldo und der Überziehungskredit gelöscht werden – es wird aus den Listen ausgeblendet, der Verlauf bleibt jedoch erhalten.';

  @override
  String get deleteAccountTitle => 'Konto löschen?';

  @override
  String get deleteAccountBodyPermanent =>
      'Dieses Konto wird dauerhaft entfernt.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count geplante Transaktionen verweisen auf dieses Konto und werden ebenfalls gelöscht.',
      one:
          '1 geplante Transaktion verweist auf dieses Konto und wird ebenfalls gelöscht.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Alles löschen';

  @override
  String get editAccountTitle => 'Konto bearbeiten';

  @override
  String get newAccountTitle => 'Neues Konto';

  @override
  String get labelAccountName => 'Kontoname';

  @override
  String get labelAccountIdentifier => 'Bezeichner (optional)';

  @override
  String get accountAppearanceSection => 'Symbol und Farbe';

  @override
  String get accountPickIcon => 'Symbol auswählen';

  @override
  String get accountPickColor => 'Wählen Sie Farbe';

  @override
  String get accountIconSheetTitle => 'Kontosymbol';

  @override
  String get accountColorSheetTitle => 'Kontofarbe';

  @override
  String get accountUseInitialLetter => 'Anfangsbuchstabe';

  @override
  String get accountUseDefaultColor => 'Match-Gruppe';

  @override
  String get labelRealBalance => 'Echtes Gleichgewicht';

  @override
  String get labelOverdraftLimit => 'Überziehungs-/Vorschusslimit';

  @override
  String get labelCurrency => 'Währung';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get addAccountAction => 'Konto hinzufügen';

  @override
  String get removeAccountSheetTitle => 'Konto entfernen';

  @override
  String get deletePermanently => 'Dauerhaft löschen';

  @override
  String get deletePermanentlySubtitle =>
      'Nur möglich, wenn dieses Konto nicht in Track verwendet wird. Geplante Elemente können im Rahmen des Löschvorgangs entfernt werden.';

  @override
  String get archiveOptionSubtitle =>
      'Vor Rezension und Auswahl verbergen. Über die Einstellungen jederzeit wiederherstellbar. Erfordert einen Nullsaldo und einen Überziehungskredit.';

  @override
  String get archivedBannerText =>
      'Dieses Konto ist archiviert. Es verbleibt in Ihren Daten, ist jedoch vor Listen und Auswahlfunktionen verborgen.';

  @override
  String get balanceAdjustedTitle => 'Balance im Track angepasst';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Der tatsächliche Kontostand wurde von $previous auf $current $symbol aktualisiert.\n\nUm das Hauptbuch konsistent zu halten, wurde in „Track“ (Verlauf) eine Saldoanpassungstransaktion erstellt.\n\n• Der tatsächliche Kontostand spiegelt den tatsächlichen Betrag auf diesem Konto wider.\n• Überprüfen Sie den Verlauf auf den Anpassungseintrag.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Balance-Anpassung';

  @override
  String get descriptionBalanceCorrection => 'Balance-Korrektur';

  @override
  String get descriptionOpeningBalance => 'Eröffnungsbilanz';

  @override
  String get reviewStatsModeStatistics => 'Statistiken';

  @override
  String get reviewStatsModeComparison => 'Vergleich';

  @override
  String get statsUncategorized => 'Nicht kategorisiert';

  @override
  String get statsNoCategories =>
      'Keine Kategorien in den ausgewählten Zeiträumen zum Vergleich.';

  @override
  String get statsNoTransactions => 'Keine Transaktionen';

  @override
  String get statsSpendingInCategory => 'Ausgaben in dieser Kategorie';

  @override
  String get statsIncomeInCategory => 'Einkommen in dieser Kategorie';

  @override
  String get statsDifference => 'Unterschied (B vs. A):';

  @override
  String get statsNoExpensesMonth => 'Keine Ausgaben in diesem Monat';

  @override
  String get statsNoExpensesAll => 'Keine Ausgaben erfasst';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Keine Ausgaben im letzten $period';
  }

  @override
  String get statsTotalSpent => 'Gesamtausgaben';

  @override
  String get statsNoExpensesThisPeriod => 'Keine Ausgaben in diesem Zeitraum';

  @override
  String get statsNoIncomeMonth => 'Kein Einkommen in diesem Monat';

  @override
  String get statsNoIncomeAll => 'Kein Einkommen erfasst';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Kein Einkommen im letzten $period';
  }

  @override
  String get statsTotalReceived => 'Insgesamt erhalten';

  @override
  String get statsNoIncomeThisPeriod => 'Kein Einkommen in diesem Zeitraum';

  @override
  String get catSalary => 'Gehalt';

  @override
  String get catFreelance => 'Freiberuflich';

  @override
  String get catConsulting => 'Beratung';

  @override
  String get catGift => 'Geschenk';

  @override
  String get catRental => 'Vermietung';

  @override
  String get catDividends => 'Dividenden';

  @override
  String get catRefund => 'Erstattung';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catInterest => 'Interesse';

  @override
  String get catSideHustle => 'Nebenbeschäftigung';

  @override
  String get catSaleOfGoods => 'Verkauf von Waren';

  @override
  String get catOther => 'Andere';

  @override
  String get catGroceries => 'Lebensmittel';

  @override
  String get catDining => 'Essen';

  @override
  String get catTransport => 'Transport';

  @override
  String get catUtilities => 'Dienstprogramme';

  @override
  String get catHousing => 'Gehäuse';

  @override
  String get catHealthcare => 'Gesundheitspflege';

  @override
  String get catEntertainment => 'Unterhaltung';

  @override
  String get catShopping => 'Einkaufen';

  @override
  String get catTravel => 'Reisen';

  @override
  String get catEducation => 'Ausbildung';

  @override
  String get catSubscriptions => 'Abonnements';

  @override
  String get catInsurance => 'Versicherung';

  @override
  String get catFuel => 'Kraftstoff';

  @override
  String get catGym => 'Fitnessstudio';

  @override
  String get catPets => 'Haustiere';

  @override
  String get catKids => 'Kinder';

  @override
  String get catCharity => 'Wohltätigkeit';

  @override
  String get catCoffee => 'Kaffee';

  @override
  String get catGifts => 'Geschenke';

  @override
  String semanticsProjectionDate(String date) {
    return 'Projektionsdatum $date. Doppeltippen, um das Datum auszuwählen';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Voraussichtlicher persönlicher Kontostand $amount';
  }

  @override
  String get statsEmptyTitle => 'Noch keine Transaktionen';

  @override
  String get statsEmptySubtitle =>
      'Keine Ausgabendaten für den ausgewählten Bereich.';

  @override
  String get semanticsShowProjections =>
      'Zeigen Sie die prognostizierten Salden nach Konto an';

  @override
  String get semanticsHideProjections =>
      'Verstecken Sie die prognostizierten Salden nach Konto';

  @override
  String get semanticsDateAllTime =>
      'Datum: Gesamtzeit – tippen Sie, um den Modus zu ändern';

  @override
  String semanticsDateMode(String mode) {
    return 'Datum: $mode – tippen Sie, um den Modus zu ändern';
  }

  @override
  String get semanticsDateThisMonth =>
      'Datum: diesen Monat – tippen Sie für Monat, Woche, Jahr oder alle Zeiten';

  @override
  String get semanticsTxTypeCycle =>
      'Transaktionstyp: Alles durchlaufen, Einnahmen, Ausgaben, Überweisung';

  @override
  String get semanticsAccountFilter => 'Kontofilter';

  @override
  String get semanticsAlreadyFiltered => 'Bereits auf dieses Konto gefiltert';

  @override
  String get semanticsCategoryFilter => 'Kategoriefilter';

  @override
  String get semanticsSortToggle =>
      'Sortieren: Neuestes oder Ältestes zuerst umschalten';

  @override
  String get semanticsFiltersDisabled =>
      'Listenfilter deaktiviert, während ein zukünftiges Projektionsdatum angezeigt wird. Löschen Sie Projektionen, um Filter zu verwenden.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Listenfilter deaktiviert. Fügen Sie zuerst ein Konto hinzu.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Listenfilter deaktiviert. Fügen Sie zunächst eine geplante Transaktion hinzu.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Listenfilter deaktiviert. Erfassen Sie zunächst eine Transaktion.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Abschnitts- und Währungskontrollen deaktiviert. Fügen Sie zuerst ein Konto hinzu.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Projektionsdatum und Saldoaufschlüsselung deaktiviert. Fügen Sie zunächst ein Konto und eine geplante Transaktion hinzu.';

  @override
  String get semanticsReorderAccountHint =>
      'Drücken Sie lange und ziehen Sie dann, um die Reihenfolge innerhalb dieser Gruppe neu zu bestimmen';

  @override
  String get semanticsChartStyle => 'Diagrammstil';

  @override
  String get semanticsChartStyleUnavailable =>
      'Diagrammstil (im Vergleichsmodus nicht verfügbar)';

  @override
  String semanticsPeriod(String label) {
    return 'Zeitraum: $label';
  }

  @override
  String get trackSearchHint => 'Suchbeschreibung, Kategorie, Konto…';

  @override
  String get trackSearchClear => 'Suche löschen';

  @override
  String get settingsExchangeRatesTitle => 'Wechselkurse';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Letzte Aktualisierung: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Offline- oder Pakettarife verwenden – zum Aktualisieren tippen';

  @override
  String get settingsExchangeRatesSource => 'EZB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Wechselkurse aktualisiert';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Wechselkurse konnten nicht aktualisiert werden. Überprüfen Sie Ihre Verbindung.';

  @override
  String get settingsClearData => 'Daten löschen';

  @override
  String get settingsClearDataSubtitle =>
      'Ausgewählte Daten dauerhaft entfernen';

  @override
  String get clearDataTitle => 'Daten löschen';

  @override
  String get clearDataTransactions => 'Transaktionsverlauf';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count Transaktionen · Kontostände auf Null zurückgesetzt';
  }

  @override
  String get clearDataPlanned => 'Geplante Transaktionen';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count geplante Artikel';
  }

  @override
  String get clearDataAccounts => 'Konten';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count-Konten · Löscht auch den Verlauf und den Plan';
  }

  @override
  String get clearDataCategories => 'Kategorien';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count Kategorien · durch Standardwerte ersetzt';
  }

  @override
  String get clearDataPreferences => 'Präferenzen';

  @override
  String get clearDataPreferencesSubtitle =>
      'Setzen Sie Währung, Thema und Sprache auf die Standardeinstellungen zurück';

  @override
  String get clearDataSecurity => 'App-Sperre und PIN';

  @override
  String get clearDataSecuritySubtitle =>
      'Deaktivieren Sie die App-Sperre und entfernen Sie die PIN';

  @override
  String get clearDataConfirmButton => 'Ausgewählte löschen';

  @override
  String get clearDataConfirmTitle =>
      'Dies kann nicht rückgängig gemacht werden';

  @override
  String get clearDataConfirmBody =>
      'Die ausgewählten Daten werden dauerhaft gelöscht. Exportieren Sie zunächst ein Backup, falls Sie es später benötigen.';

  @override
  String get clearDataTypeConfirm => 'Geben Sie zur Bestätigung DELETE ein';

  @override
  String get clearDataTypeConfirmError =>
      'Geben Sie genau DELETE ein, um fortzufahren';

  @override
  String get clearDataPinTitle => 'Mit PIN bestätigen';

  @override
  String get clearDataPinBody =>
      'Geben Sie Ihre App-PIN ein, um diese Aktion zu autorisieren.';

  @override
  String get clearDataPinIncorrect => 'Falsche PIN';

  @override
  String get clearDataDone => 'Ausgewählte Daten gelöscht';

  @override
  String get autoBackupTitle => 'Automatische tägliche Sicherung';

  @override
  String autoBackupLastAt(String date) {
    return 'Zuletzt gesichert $date';
  }

  @override
  String get autoBackupNeverRun => 'Noch kein Backup';

  @override
  String get autoBackupShareTitle => 'In der Cloud speichern';

  @override
  String get autoBackupShareSubtitle =>
      'Laden Sie das neueste Backup auf iCloud Drive, Google Drive oder eine beliebige App hoch';

  @override
  String get autoBackupCloudReminder =>
      'Bereit für automatisches Backup – speichern Sie es in der Cloud, um es auch außerhalb des Geräts zu schützen';

  @override
  String get autoBackupCloudReminderAction => 'Aktie';

  @override
  String get persistenceErrorReloaded =>
      'Änderungen konnten nicht gespeichert werden. Daten wurden aus dem Speicher neu geladen.';
}
