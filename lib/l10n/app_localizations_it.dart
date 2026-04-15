// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Piano';

  @override
  String get navTrack => 'Traccia';

  @override
  String get navReview => 'Revisione';

  @override
  String get cancel => 'Cancellare';

  @override
  String get delete => 'Eliminare';

  @override
  String get close => 'Vicino';

  @override
  String get add => 'Aggiungere';

  @override
  String get undo => 'Disfare';

  @override
  String get confirm => 'Confermare';

  @override
  String get restore => 'Ripristinare';

  @override
  String get heroIn => 'In';

  @override
  String get heroOut => 'Fuori';

  @override
  String get heroNet => 'Netto';

  @override
  String get heroBalance => 'Bilancia';

  @override
  String get realBalance => 'Equilibrio reale';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Nascondi i saldi nelle schede di riepilogo';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Quando è attivo, gli importi in Piano, Traccia e Revisione rimangono mascherati finché non tocchi l\'icona dell\'occhio in ogni scheda. Quando è disattivo, i saldi sono sempre visibili.';

  @override
  String get heroBalancesShow => 'Mostra saldi';

  @override
  String get heroBalancesHide => 'Nascondi saldi';

  @override
  String get semanticsHeroBalanceHidden => 'Saldo nascosto per la privacy';

  @override
  String get heroResetButton => 'Reset';

  @override
  String get fabScrollToTop => 'Torna su';

  @override
  String get fabPickProjectionDate => 'Scegli data di proiezione';

  @override
  String get filterAll => 'Tutto';

  @override
  String get filterAllAccounts => 'Tutti i conti';

  @override
  String get filterAllCategories => 'Tutte le categorie';

  @override
  String get txLabelIncome => 'REDDITO';

  @override
  String get txLabelExpense => 'SPESE';

  @override
  String get txLabelInvoice => 'FATTURA';

  @override
  String get txLabelBill => 'CONTO';

  @override
  String get txLabelAdvance => 'ANTICIPO';

  @override
  String get txLabelSettlement => 'INSEDIAMENTO';

  @override
  String get txLabelLoan => 'PRESTITO';

  @override
  String get txLabelCollection => 'COLLEZIONE';

  @override
  String get txLabelOffset => 'OFFSET';

  @override
  String get txLabelTransfer => 'TRASFERIRE';

  @override
  String get txLabelTransaction => 'TRANSAZIONE';

  @override
  String get repeatNone => 'Nessuna ripetizione';

  @override
  String get repeatDaily => 'Quotidiano';

  @override
  String get repeatWeekly => 'Settimanale';

  @override
  String get repeatMonthly => 'Mensile';

  @override
  String get repeatYearly => 'Annuale';

  @override
  String get repeatEveryLabel => 'Ogni';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: 'giorno',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count settimane',
      one: 'settimana',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mesi',
      one: 'mese',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anni',
      one: 'anno',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Finisce';

  @override
  String get repeatEndNever => 'Mai';

  @override
  String get repeatEndOnDate => 'In data';

  @override
  String repeatEndAfterCount(int count) {
    return 'Dopo $count volte';
  }

  @override
  String get repeatEndAfterChoice => 'Dopo un certo numero di volte';

  @override
  String get repeatEndPickDate => 'Scegli la data di fine';

  @override
  String get repeatEndTimes => 'volte';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Ogni $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'fino al $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count volte';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining di $total rimanenti';
  }

  @override
  String get detailRepeatEvery => 'Ripeti ogni';

  @override
  String get detailEnds => 'Finisce';

  @override
  String get detailEndsNever => 'Mai';

  @override
  String detailEndsOnDate(String date) {
    return 'Il $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Dopo $count volte';
  }

  @override
  String get detailProgress => 'Progressi';

  @override
  String get weekendNoChange => 'Nessun cambiamento';

  @override
  String get weekendFriday => 'Spostarsi a venerdì';

  @override
  String get weekendMonday => 'Passare a lunedì';

  @override
  String weekendQuestion(String day) {
    return 'Se il $day cade in un fine settimana?';
  }

  @override
  String get dateToday => 'Oggi';

  @override
  String get dateTomorrow => 'Domani';

  @override
  String get dateYesterday => 'Ieri';

  @override
  String get statsAllTime => 'Tutto il tempo';

  @override
  String get accountGroupPersonal => 'Personale';

  @override
  String get accountGroupIndividual => 'Individuale';

  @override
  String get accountGroupEntity => 'Entità';

  @override
  String get accountSectionIndividuals => 'Individui';

  @override
  String get accountSectionEntities => 'Entità';

  @override
  String get emptyNoTransactionsYet => 'Nessuna transazione ancora';

  @override
  String get emptyNoAccountsYet => 'Nessun account ancora';

  @override
  String get emptyRecordFirstTransaction =>
      'Tocca il pulsante qui sotto per registrare la tua prima transazione.';

  @override
  String get emptyAddFirstAccountTx =>
      'Aggiungi il tuo primo account prima di registrare le transazioni.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Aggiungi il tuo primo account prima di pianificare le transazioni.';

  @override
  String get emptyAddFirstAccountReview =>
      'Aggiungi il tuo primo account per iniziare a monitorare le tue finanze.';

  @override
  String get emptyAddTransaction => 'Aggiungi transazione';

  @override
  String get emptyAddAccount => 'Aggiungi account';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Nessun account personale ancora';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'I conti personali sono i tuoi portafogli e conti bancari. Aggiungine uno per tenere traccia delle entrate e delle spese quotidiane.';

  @override
  String get reviewEmptyGroupIndividualsTitle =>
      'Nessun account individuale ancora';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'I conti individuali tengono traccia del denaro con persone specifiche: costi condivisi, prestiti o pagherò. Aggiungi un account per ogni persona con cui stabilisci.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Nessun account di entità ancora';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'I conti entità sono per aziende, progetti o organizzazioni. Usali per mantenere il flusso di cassa aziendale separato dalle tue finanze personali.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Nessuna transazione per i filtri applicati';

  @override
  String get emptyNoTransactionsInHistory =>
      'Nessuna transazione nella cronologia';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Nessuna transazione per $month';
  }

  @override
  String get emptyNoTransactionsForAccount =>
      'Nessuna transazione per questo conto';

  @override
  String get trackTransactionDeleted => 'Transazione eliminata';

  @override
  String get trackDeleteTitle => 'Eliminare la transazione?';

  @override
  String get trackDeleteBody =>
      'Ciò annullerà le modifiche al saldo del conto.';

  @override
  String get trackTransaction => 'Transazione';

  @override
  String get planConfirmTitle => 'Confermi la transazione?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Questo evento è previsto per $date. Verrà registrato nella Cronologia con la data odierna ($todayDate). L\'occorrenza successiva rimane su $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Ciò applicherà la transazione ai saldi del tuo conto reale e la sposterà nella Cronologia.';

  @override
  String get planTransactionConfirmed => 'Transazione confermata e applicata';

  @override
  String get planTransactionRemoved => 'Transazione pianificata rimossa';

  @override
  String get planRepeatingTitle => 'Transazione ripetuta';

  @override
  String get planRepeatingBody =>
      'Salta solo questa data (la serie continua con l\'evento successivo) oppure elimina ogni evento rimanente dal tuo piano.';

  @override
  String get planDeleteAll => 'Elimina tutto';

  @override
  String get planSkipThisOnly => 'Salta solo questo';

  @override
  String get planOccurrenceSkipped =>
      'Questo evento è stato saltato: il prossimo è programmato';

  @override
  String get planNothingPlanned => 'Niente di previsto per ora';

  @override
  String get planPlanBody => 'Pianifica le prossime transazioni.';

  @override
  String get planAddPlan => 'Aggiungi piano';

  @override
  String get planNoPlannedForFilters =>
      'Nessuna transazione pianificata per i filtri applicati';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Nessuna transazione pianificata in $month';
  }

  @override
  String get planOverdue => 'in ritardo';

  @override
  String get planPlannedTransaction => 'Transazione pianificata';

  @override
  String get discardTitle => 'Eliminare le modifiche?';

  @override
  String get discardBody =>
      'Sono presenti modifiche non salvate. Andranno perduti se te ne vai adesso.';

  @override
  String get keepEditing => 'Continua a modificare';

  @override
  String get discard => 'Scarta';

  @override
  String get newTransactionTitle => 'Nuova transazione';

  @override
  String get editTransactionTitle => 'Modifica transazione';

  @override
  String get transactionUpdated => 'Transazione aggiornata';

  @override
  String get sectionAccounts => 'Conti';

  @override
  String get labelFrom => 'Da';

  @override
  String get labelTo => 'A';

  @override
  String get sectionCategory => 'Categoria';

  @override
  String get sectionAttachments => 'Allegati';

  @override
  String get labelNote => 'Nota';

  @override
  String get hintOptionalDescription => 'Descrizione facoltativa';

  @override
  String get updateTransaction => 'Aggiorna transazione';

  @override
  String get saveTransaction => 'Salva transazione';

  @override
  String get selectAccount => 'Seleziona conto';

  @override
  String get selectAccountTitle => 'Seleziona Conto';

  @override
  String get noAccountsAvailable => 'Nessun account disponibile';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Importo ricevuto da $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Inserisci l\'importo esatto ricevuto dall\'account di destinazione. Ciò blocca il tasso di cambio reale utilizzato.';

  @override
  String get attachTakePhoto => 'Scatta una foto';

  @override
  String get attachTakePhotoSub =>
      'Utilizza la fotocamera per acquisire una ricevuta';

  @override
  String get attachChooseGallery => 'Scegli dalla galleria';

  @override
  String get attachChooseGallerySub => 'Seleziona le foto dalla tua libreria';

  @override
  String get attachBrowseFiles => 'Sfoglia i file';

  @override
  String get attachBrowseFilesSub => 'Allega PDF, documenti o altri file';

  @override
  String get attachButton => 'Allegare';

  @override
  String get editPlanTitle => 'Modifica piano';

  @override
  String get planTransactionTitle => 'Pianificare la transazione';

  @override
  String get tapToSelect => 'Tocca per selezionare';

  @override
  String get updatePlan => 'Aggiorna piano';

  @override
  String get addToPlan => 'Aggiungi al piano';

  @override
  String get labelRepeat => 'Ripetere';

  @override
  String get selectPlannedDate => 'Seleziona la data pianificata';

  @override
  String get balancesAsOfToday => 'Saldi ad oggi';

  @override
  String get projectedBalancesForTomorrow => 'Saldi previsti per domani';

  @override
  String projectedBalancesForDate(String date) {
    return 'Saldi previsti per $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name riceve ($currency)';
  }

  @override
  String get destHelper =>
      'Importo di destinazione stimato. La tariffa esatta è bloccata alla conferma.';

  @override
  String get descriptionOptional => 'Descrizione (facoltativa)';

  @override
  String get detailTransactionTitle => 'Transazione';

  @override
  String get detailPlannedTitle => 'Pianificato';

  @override
  String get detailConfirmTransaction => 'Conferma la transazione';

  @override
  String get detailDate => 'Data';

  @override
  String get detailFrom => 'Da';

  @override
  String get detailTo => 'A';

  @override
  String get detailCategory => 'Categoria';

  @override
  String get detailNote => 'Nota';

  @override
  String get detailDestinationAmount => 'Importo di destinazione';

  @override
  String get detailExchangeRate => 'Tasso di cambio';

  @override
  String get detailRepeats => 'Si ripete';

  @override
  String get detailDayOfMonth => 'Giorno del mese';

  @override
  String get detailWeekends => 'Fine settimana';

  @override
  String get detailAttachments => 'Allegati';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsSectionDisplay => 'Display';

  @override
  String get settingsSectionLanguage => 'Lingua';

  @override
  String get settingsSectionCategories => 'Categorie';

  @override
  String get settingsSectionAccounts => 'Conti';

  @override
  String get settingsSectionPreferences => 'Preferenze';

  @override
  String get settingsSectionManage => 'Maneggio';

  @override
  String get settingsBaseCurrency => 'Valuta domestica';

  @override
  String get settingsSecondaryCurrency => 'Valuta secondaria';

  @override
  String get settingsCategories => 'Categorie';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount entrate · $expenseCount spese';
  }

  @override
  String get settingsArchivedAccounts => 'Conti archiviati';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Nessuno al momento: archivia dalla modifica dell\'account quando il saldo è azzerato';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count nascosto da Revisione e selezionatori';
  }

  @override
  String get settingsSectionData => 'Dati';

  @override
  String get settingsSectionPrivacy => 'Di';

  @override
  String get settingsPrivacyPolicyTitle => 'Politica sulla riservatezza';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Come Platrare gestisce i tuoi dati.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Tassi di cambio: l\'app recupera i tassi di valuta pubblici su Internet. I tuoi conti e le tue transazioni non vengono mai inviati.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Impossibile caricare l\'informativa sulla privacy.';

  @override
  String get settingsPrivacyRetry => 'Riprova';

  @override
  String get settingsSoftwareVersionTitle => 'Versione del software';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Rilascio, diagnostica e legale';

  @override
  String get aboutScreenTitle => 'Di';

  @override
  String get aboutAppTagline =>
      'Registro, flusso di cassa e pianificazione in un unico spazio di lavoro.';

  @override
  String get aboutDescriptionBody =>
      'Platrare mantiene conti, transazioni e piani sul tuo dispositivo. Esporta backup crittografati quando ne hai bisogno di una copia altrove. I tassi di cambio utilizzano solo i dati del mercato pubblico; il tuo registro non è stato caricato.';

  @override
  String get aboutVersionLabel => 'Versione';

  @override
  String get aboutBuildLabel => 'Costruire';

  @override
  String get aboutCopySupportDetails => 'Copia i dettagli del supporto';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Apre il documento completo sulle norme in-app.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Locale';

  @override
  String get settingsSupportInfoCopied => 'Copiato negli appunti';

  @override
  String get settingsVerifyLedger => 'Verifica i dati';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Controlla che i saldi del conto corrispondano alla cronologia delle transazioni';

  @override
  String get settingsDataExportTitle => 'Esporta backup';

  @override
  String get settingsDataExportSubtitle =>
      'Salva come .zip o .platrare crittografato con tutti i dati e gli allegati';

  @override
  String get settingsDataImportTitle => 'Ripristina dal backup';

  @override
  String get settingsDataImportSubtitle =>
      'Sostituisci i dati correnti da un backup Platrare .zip o .platrare';

  @override
  String get backupExportDialogTitle => 'Proteggi questo backup';

  @override
  String get backupExportDialogBody =>
      'Si consiglia una password complessa, soprattutto se archivi il file nel cloud. Per l\'importazione è necessaria la stessa password.';

  @override
  String get backupExportPasswordLabel => 'Password';

  @override
  String get backupExportPasswordConfirmLabel => 'Conferma password';

  @override
  String get backupExportPasswordMismatch => 'Le password non corrispondono';

  @override
  String get backupExportPasswordEmpty =>
      'Inserisci una password corrispondente o esporta senza crittografia di seguito.';

  @override
  String get backupExportPasswordTooShort =>
      'La password deve contenere almeno 8 caratteri.';

  @override
  String get backupExportSaveToDevice => 'Salva sul dispositivo';

  @override
  String get backupExportShareToCloud => 'Condividi (iCloud, Drive...)';

  @override
  String get backupExportWithoutEncryption => 'Esporta senza crittografia';

  @override
  String get backupExportSkipWarningTitle => 'Esportare senza crittografia?';

  @override
  String get backupExportSkipWarningBody =>
      'Chiunque abbia accesso al file può leggere i tuoi dati. Utilizzalo solo per le copie locali che controlli.';

  @override
  String get backupExportSkipWarningConfirm => 'Esporta in chiaro';

  @override
  String get backupImportPasswordTitle => 'Backup crittografato';

  @override
  String get backupImportPasswordBody =>
      'Inserisci la password che hai utilizzato durante l\'esportazione.';

  @override
  String get backupImportPasswordLabel => 'Password';

  @override
  String get backupImportPreviewTitle => 'Riepilogo del backup';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Versione dell\'app: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Esportato: $date';
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
    return '$accounts conti · $transactions movimenti · $planned pianificati · $attachments file allegati · $income categorie di entrate · $expense categorie di spese';
  }

  @override
  String get backupImportPreviewContinue => 'Continuare';

  @override
  String get settingsBackupWrongPassword => 'Password errata';

  @override
  String get settingsBackupChecksumMismatch =>
      'Controllo dell\'integrità del backup non riuscito';

  @override
  String get settingsBackupCorruptFile =>
      'File di backup non valido o danneggiato';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Il backup richiede una versione più recente dell\'app';

  @override
  String get settingsDataImportConfirmTitle => 'Sostituire i dati attuali?';

  @override
  String get settingsDataImportConfirmBody =>
      'Ciò sostituirà i tuoi conti correnti, transazioni, transazioni pianificate, categorie e allegati importati con il contenuto del backup selezionato. Questa azione non può essere annullata.';

  @override
  String get settingsDataImportConfirmAction => 'Sostituisci i dati';

  @override
  String get settingsDataImportDone => 'Dati ripristinati con successo';

  @override
  String get settingsDataImportInvalidFile =>
      'Questo file non è un backup Platrare valido';

  @override
  String get settingsDataImportFailed => 'Importazione non riuscita';

  @override
  String get settingsDataExportDoneTitle => 'Backup esportato';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Backup salvato in:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Apri file';

  @override
  String get settingsDataExportFailed => 'Esportazione non riuscita';

  @override
  String get ledgerVerifyDialogTitle => 'Verifica del registro';

  @override
  String get ledgerVerifyAllMatch => 'Tutti gli account corrispondono.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Mancate corrispondenze';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nMemorizzato: $stored\nRiproduzione: $replayed\nDifferenza: $diff';
  }

  @override
  String get settingsLanguage => 'Lingua dell\'app';

  @override
  String get settingsLanguageSubtitleSystem =>
      'Seguendo le impostazioni di sistema';

  @override
  String get settingsLanguageSubtitleEnglish => 'Inglese';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Serbo (latino)';

  @override
  String get settingsLanguagePickerTitle => 'Lingua dell\'app';

  @override
  String get settingsLanguageOptionSystem => 'Predefinito del sistema';

  @override
  String get settingsLanguageOptionEnglish => 'Inglese';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Serbo (latino)';

  @override
  String get settingsSectionAppearance => 'Aspetto';

  @override
  String get settingsSectionSecurity => 'Sicurezza';

  @override
  String get settingsSecurityEnableLock => 'Blocca l\'app aperta';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Richiedi lo sblocco biometrico o il PIN all\'apertura dell\'app';

  @override
  String get settingsSecurityLockDelayTitle => 'Riblocca dopo l\'inattività';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      'Per quanto tempo l\'app può restare fuori schermo prima di richiedere nuovamente lo sblocco. Immediatamente è la più sicura.';

  @override
  String get settingsSecurityLockDelayImmediate => 'Immediatamente';

  @override
  String get settingsSecurityLockDelay30s => '30 secondi';

  @override
  String get settingsSecurityLockDelay1m => '1 minuto';

  @override
  String get settingsSecurityLockDelay5m => '5 minuti';

  @override
  String get settingsSecuritySetPin => 'Imposta il PIN';

  @override
  String get settingsSecurityChangePin => 'Cambia PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Utilizza un PIN come riserva se i dati biometrici non sono disponibili';

  @override
  String get settingsSecurityRemovePin => 'Rimuovi PIN';

  @override
  String get securitySetPinTitle => 'Imposta il PIN dell\'app';

  @override
  String get securityPinLabel => 'Codice PIN';

  @override
  String get securityConfirmPinLabel => 'Conferma il codice PIN';

  @override
  String get securityPinMustBe4Digits => 'Il PIN deve contenere almeno 4 cifre';

  @override
  String get securityPinMismatch => 'I codici PIN non corrispondono';

  @override
  String get securityRemovePinTitle => 'Rimuovere il PIN?';

  @override
  String get securityRemovePinBody =>
      'Lo sblocco biometrico può ancora essere utilizzato, se disponibile.';

  @override
  String get securityUnlockTitle => 'Applicazione bloccata';

  @override
  String get securityUnlockSubtitle =>
      'Sblocca con Face ID, impronta digitale o PIN.';

  @override
  String get securityUnlockWithPin => 'Sblocca con PIN';

  @override
  String get securityTryBiometric => 'Prova lo sblocco biometrico';

  @override
  String get securityPinIncorrect => 'PIN errato, riprova';

  @override
  String get securityBiometricReason => 'Autenticati per aprire la tua app';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitleSystem =>
      'Seguendo le impostazioni di sistema';

  @override
  String get settingsThemeSubtitleLight => 'Leggero';

  @override
  String get settingsThemeSubtitleDark => 'Buio';

  @override
  String get settingsThemePickerTitle => 'Tema';

  @override
  String get settingsThemeOptionSystem => 'Predefinito del sistema';

  @override
  String get settingsThemeOptionLight => 'Leggero';

  @override
  String get settingsThemeOptionDark => 'Buio';

  @override
  String get archivedAccountsTitle => 'Conti archiviati';

  @override
  String get archivedAccountsEmptyTitle => 'Nessun account archiviato';

  @override
  String get archivedAccountsEmptyBody =>
      'Il saldo contabile e lo scoperto devono essere pari a zero. Archivia dalle opzioni dell\'account in Revisione.';

  @override
  String get categoriesTitle => 'Categorie';

  @override
  String get newCategoryTitle => 'Nuova categoria';

  @override
  String get categoryNameLabel => 'Nome della categoria';

  @override
  String get deleteCategoryTitle => 'Eliminare la categoria?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" verrà rimosso dall\'elenco.';
  }

  @override
  String get categoryIncome => 'Reddito';

  @override
  String get categoryExpense => 'Spese';

  @override
  String get categoryAdd => 'Aggiungere';

  @override
  String get searchCurrencies => 'Cerca valute…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1 anno';

  @override
  String get periodAll => 'TUTTO';

  @override
  String get categoryLabel => 'categoria';

  @override
  String get categoriesLabel => 'categorie';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type salvato • $amount';
  }

  @override
  String get tooltipSettings => 'Impostazioni';

  @override
  String get tooltipAddAccount => 'Aggiungi account';

  @override
  String get tooltipRemoveAccount => 'Rimuovi conto';

  @override
  String get accountNameTaken =>
      'Hai già un account con questo nome e identificatore (attivo o archiviato). Modificare il nome o l\'identificatore.';

  @override
  String get groupDescPersonal => 'I tuoi portafogli e conti bancari';

  @override
  String get groupDescIndividuals => 'Famiglia, amici, individui';

  @override
  String get groupDescEntities => 'Enti, servizi pubblici, organizzazioni';

  @override
  String get cannotArchiveTitle => 'Impossibile ancora archiviare';

  @override
  String get cannotArchiveBody =>
      'L\'archivio è disponibile solo quando il saldo contabile e il limite di scoperto sono entrambi effettivamente pari a zero.';

  @override
  String get cannotArchiveBodyAdjust =>
      'L\'archivio è disponibile solo quando il saldo contabile e il limite di scoperto sono entrambi effettivamente pari a zero. Regola prima il registro o la struttura.';

  @override
  String get archiveAccountTitle => 'Account di archivio?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transazioni pianificate fanno riferimento a questo conto.',
      one: '1 transazione pianificata fa riferimento a questo conto.',
    );
    return '$_temp0 Rimuovile per mantenere il piano coerente con un conto archiviato.';
  }

  @override
  String get removeAndArchive => 'Rimuovi pianificato e archivia';

  @override
  String get archiveBody =>
      'L\'account verrà nascosto dai selettori Revisione, Traccia e Piano. Puoi ripristinarlo da Impostazioni.';

  @override
  String get archiveAction => 'Archivio';

  @override
  String get archiveInstead => 'Archivio invece';

  @override
  String get cannotDeleteTitle => 'Impossibile eliminare l\'account';

  @override
  String get cannotDeleteBodyShort =>
      'Questo account viene visualizzato nella cronologia delle tracce. Rimuovi o riassegna prima tali transazioni oppure archivia il conto se il saldo viene cancellato.';

  @override
  String get cannotDeleteBodyHistory =>
      'Questo account viene visualizzato nella cronologia delle tracce. L\'eliminazione interromperebbe quella cronologia: rimuovere o riassegnare prima quelle transazioni.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Questo account viene visualizzato nella cronologia delle tracce, quindi non può essere eliminato. Puoi invece archiviarlo se il saldo contabile e lo scoperto vengono cancellati: verrà nascosto dagli elenchi ma la cronologia rimarrà intatta.';

  @override
  String get deleteAccountTitle => 'Eliminare l\'account?';

  @override
  String get deleteAccountBodyPermanent =>
      'Questo account verrà rimosso definitivamente.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transazioni pianificate fanno riferimento a questo conto e verranno eliminate.',
      one:
          '1 transazione pianificata fa riferimento a questo conto e verrà eliminata.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Elimina tutto';

  @override
  String get editAccountTitle => 'Modifica account';

  @override
  String get newAccountTitle => 'Nuovo conto';

  @override
  String get labelAccountName => 'Nome utente';

  @override
  String get labelAccountIdentifier => 'Identificatore (facoltativo)';

  @override
  String get accountAppearanceSection => 'Icona e colore';

  @override
  String get accountPickIcon => 'Scegli l\'icona';

  @override
  String get accountPickColor => 'Scegli il colore';

  @override
  String get accountIconSheetTitle => 'Icona dell\'account';

  @override
  String get accountColorSheetTitle => 'Colore del conto';

  @override
  String get searchAccountIcons => 'Cerca icone per nome…';

  @override
  String get accountIconSearchNoMatches =>
      'Nessuna icona corrisponde a questa ricerca.';

  @override
  String get accountUseInitialLetter => 'Lettera iniziale';

  @override
  String get accountUseDefaultColor => 'Gruppo di partite';

  @override
  String get labelRealBalance => 'Equilibrio reale';

  @override
  String get labelOverdraftLimit => 'Limite di scoperto/anticipo';

  @override
  String get labelCurrency => 'Valuta';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get addAccountAction => 'Aggiungi account';

  @override
  String get removeAccountSheetTitle => 'Rimuovi conto';

  @override
  String get deletePermanently => 'Elimina definitivamente';

  @override
  String get deletePermanentlySubtitle =>
      'Possibile solo quando questo account non viene utilizzato in Traccia. Gli elementi pianificati possono essere rimossi come parte dell\'eliminazione.';

  @override
  String get archiveOptionSubtitle =>
      'Nascondi da revisione e selezionatori. Ripristina in qualsiasi momento dalle Impostazioni. Richiede saldo zero e scoperto.';

  @override
  String get archivedBannerText =>
      'Questo account è archiviato. Rimane nei tuoi dati ma è nascosto da elenchi e selettori.';

  @override
  String get balanceAdjustedTitle => 'Bilanciamento regolato in Traccia';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Il saldo reale è stato aggiornato da $previous a $current $symbol.\n\nUna transazione di rettifica del saldo è stata creata in Traccia (storia) per mantenere coerente la contabilità generale.\n\n• Il saldo reale riflette l\'importo effettivo in questo conto.\n• Controllare la cronologia per la voce di rettifica.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Regolazione dell\'equilibrio';

  @override
  String get descriptionBalanceCorrection => 'Correzione dell\'equilibrio';

  @override
  String get descriptionOpeningBalance => 'Saldo di apertura';

  @override
  String get reviewStatsModeStatistics => 'Statistiche';

  @override
  String get reviewStatsModeComparison => 'Confronto';

  @override
  String get statsUncategorized => 'Senza categoria';

  @override
  String get statsNoCategories =>
      'Nessuna categoria nei periodi selezionati per il confronto.';

  @override
  String get statsNoTransactions => 'Nessuna transazione';

  @override
  String get statsSpendingInCategory => 'Spesa in questa categoria';

  @override
  String get statsIncomeInCategory => 'Reddito in questa categoria';

  @override
  String get statsDifference => 'Differenza (B vs A):';

  @override
  String get statsNoExpensesMonth => 'Nessuna spesa questo mese';

  @override
  String get statsNoExpensesAll => 'Nessuna spesa registrata';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Nessuna spesa nell\'ultimo $period';
  }

  @override
  String get statsTotalSpent => 'Totale speso';

  @override
  String get statsNoExpensesThisPeriod => 'Nessuna spesa in questo periodo';

  @override
  String get statsNoIncomeMonth => 'Nessun reddito questo mese';

  @override
  String get statsNoIncomeAll => 'Nessun reddito registrato';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Nessun reddito nell\'ultimo $period';
  }

  @override
  String get statsTotalReceived => 'Totale ricevuto';

  @override
  String get statsNoIncomeThisPeriod => 'Nessun reddito in questo periodo';

  @override
  String get catSalary => 'Stipendio';

  @override
  String get catFreelance => 'Libero professionista';

  @override
  String get catConsulting => 'Consulenza';

  @override
  String get catGift => 'Regalo';

  @override
  String get catRental => 'Noleggio';

  @override
  String get catDividends => 'Dividendi';

  @override
  String get catRefund => 'Rimborso';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catInterest => 'Interesse';

  @override
  String get catSideHustle => 'Trambusto laterale';

  @override
  String get catSaleOfGoods => 'Vendita di merci';

  @override
  String get catOther => 'Altro';

  @override
  String get catGroceries => 'Generi alimentari';

  @override
  String get catDining => 'Pranzo';

  @override
  String get catTransport => 'Trasporto';

  @override
  String get catUtilities => 'Utilità';

  @override
  String get catHousing => 'Alloggiamento';

  @override
  String get catHealthcare => 'Assistenza sanitaria';

  @override
  String get catEntertainment => 'Divertimento';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catTravel => 'Viaggio';

  @override
  String get catEducation => 'Istruzione';

  @override
  String get catSubscriptions => 'Abbonamenti';

  @override
  String get catInsurance => 'Assicurazione';

  @override
  String get catFuel => 'Carburante';

  @override
  String get catGym => 'Palestra';

  @override
  String get catPets => 'Animali domestici';

  @override
  String get catKids => 'Bambini';

  @override
  String get catCharity => 'Beneficenza';

  @override
  String get catCoffee => 'Caffè';

  @override
  String get catGifts => 'Regali';

  @override
  String semanticsProjectionDate(String date) {
    return 'Data di proiezione $date. Tocca due volte per scegliere la data';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Saldo personale previsto $amount';
  }

  @override
  String get statsEmptyTitle => 'Nessuna transazione ancora';

  @override
  String get statsEmptySubtitle =>
      'Nessun dato di spesa per l\'intervallo selezionato.';

  @override
  String get semanticsShowProjections => 'Mostra i saldi previsti per conto';

  @override
  String get semanticsHideProjections => 'Nascondi i saldi previsti per conto';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Mostra i saldi dei conti per questo giorno';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Nascondi i saldi dei conti per questo giorno';

  @override
  String get semanticsDateAllTime =>
      'Data: sempre: tocca per cambiare modalità';

  @override
  String semanticsDateMode(String mode) {
    return 'Data: $mode: tocca per cambiare modalità';
  }

  @override
  String get semanticsDateThisMonth =>
      'Data: questo mese: tocca per mese, settimana, anno o tutto il tempo';

  @override
  String get semanticsTxTypeCycle =>
      'Tipo di transazione: ciclo tutto, entrate, spese, trasferimento';

  @override
  String get semanticsAccountFilter => 'Filtro dell\'account';

  @override
  String get semanticsAlreadyFiltered => 'Già filtrato per questo account';

  @override
  String get semanticsCategoryFilter => 'Filtro categoria';

  @override
  String get semanticsSortToggle =>
      'Ordina: alterna prima il più recente o il più vecchio';

  @override
  String get semanticsFiltersDisabled =>
      'Filtri elenco disabilitati durante la visualizzazione di una data di proiezione futura. Cancella proiezioni per utilizzare i filtri.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Filtri elenco disabilitati. Aggiungi prima un account.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Filtri elenco disabilitati. Aggiungi prima una transazione pianificata.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Filtri elenco disabilitati. Registra prima una transazione.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Controlli di sezione e valuta disabilitati. Aggiungi prima un account.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Data di proiezione e ripartizione del saldo disabilitati. Aggiungi prima un account e una transazione pianificata.';

  @override
  String get semanticsReorderAccountHint =>
      'Premi a lungo, quindi trascina per riordinare all\'interno di questo gruppo';

  @override
  String get semanticsChartStyle => 'Stile grafico';

  @override
  String get semanticsChartStyleUnavailable =>
      'Stile grafico (non disponibile in modalità confronto)';

  @override
  String semanticsPeriod(String label) {
    return 'Periodo: $label';
  }

  @override
  String get trackSearchHint =>
      'Descrizione della ricerca, categoria, account...';

  @override
  String get trackSearchClear => 'Cancella ricerca';

  @override
  String get settingsExchangeRatesTitle => 'Tassi di cambio';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Ultimo aggiornamento: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Utilizzo di tariffe offline o in bundle: tocca per aggiornare';

  @override
  String get settingsExchangeRatesSource => 'BCE';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Tassi di cambio aggiornati';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Impossibile aggiornare i tassi di cambio. Controlla la tua connessione.';

  @override
  String get settingsClearData => 'Cancella dati';

  @override
  String get settingsClearDataSubtitle =>
      'Rimuovi permanentemente i dati selezionati';

  @override
  String get clearDataTitle => 'Cancella dati';

  @override
  String get clearDataTransactions => 'Cronologia delle transazioni';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return 'Transazioni $count · saldi dei conti azzerati';
  }

  @override
  String get clearDataPlanned => 'Transazioni pianificate';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count articoli pianificati';
  }

  @override
  String get clearDataAccounts => 'Conti';

  @override
  String clearDataAccountsSubtitle(int count) {
    return 'Account $count · cancella anche la cronologia e il piano';
  }

  @override
  String get clearDataCategories => 'Categorie';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return 'Categorie $count · sostituite con valori predefiniti';
  }

  @override
  String get clearDataPreferences => 'Preferenze';

  @override
  String get clearDataPreferencesSubtitle =>
      'Ripristina valuta, tema e lingua ai valori predefiniti';

  @override
  String get clearDataSecurity => 'Blocco e PIN dell\'app';

  @override
  String get clearDataSecuritySubtitle =>
      'Disattiva il blocco dell\'app e rimuovi il PIN';

  @override
  String get clearDataConfirmButton => 'Cancella selezionato';

  @override
  String get clearDataConfirmTitle =>
      'Questa operazione non può essere annullata';

  @override
  String get clearDataConfirmBody =>
      'I dati selezionati verranno eliminati definitivamente. Esporta prima un backup se potresti averne bisogno in seguito.';

  @override
  String get clearDataTypeConfirm => 'Digita DELETE per confermare';

  @override
  String get clearDataTypeConfirmError =>
      'Digita DELETE esattamente per continuare';

  @override
  String get clearDataPinTitle => 'Conferma con PIN';

  @override
  String get clearDataPinBody =>
      'Inserisci il PIN dell\'app per autorizzare questa azione.';

  @override
  String get clearDataPinIncorrect => 'PIN errato';

  @override
  String get clearDataDone => 'Dati selezionati cancellati';

  @override
  String get autoBackupTitle => 'Backup giornaliero automatico';

  @override
  String autoBackupLastAt(String date) {
    return 'Ultimo backup $date';
  }

  @override
  String get autoBackupNeverRun => 'Nessun backup ancora';

  @override
  String get autoBackupShareTitle => 'Salva nel cloud';

  @override
  String get autoBackupShareSubtitle =>
      'Carica l\'ultimo backup su iCloud Drive, Google Drive o qualsiasi app';

  @override
  String get autoBackupCloudReminder =>
      'Predisposizione per il backup automatico: salvalo nel cloud per la protezione esterna al dispositivo';

  @override
  String get autoBackupCloudReminderAction => 'Condividi';

  @override
  String get settingsBackupReminderTitle => 'Promemoria backup';

  @override
  String get settingsBackupReminderSubtitle =>
      'Banner in-app se aggiungi molte transazioni senza esportare un backup manuale.';

  @override
  String get settingsBackupReminderThresholdTitle => 'Soglia transazioni';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return 'Ricorda dopo $count nuove transazioni dall\'ultimo esportazione manuale.';
  }

  @override
  String get settingsBackupReminderThresholdInvalid =>
      'Inserisci un numero intero da 1 a 500.';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '\"Ricorda più tardi\" nasconde il banner finché non aggiungi altre $n transazioni.';
  }

  @override
  String get backupReminderBannerTitle => 'Esportare un backup?';

  @override
  String backupReminderBannerBody(int count) {
    return 'Hai aggiunto $count transazioni dall\'ultimo esportazione manuale.';
  }

  @override
  String get backupReminderRemindLater => 'Ricorda più tardi';

  @override
  String get backupExportLedgerVerifyTitle =>
      'Verifica contabile prima del backup';

  @override
  String get backupExportLedgerVerifyInfo =>
      'Confronta il saldo memorizzato di ogni conto con una riproduzione completa della tua cronologia. Puoi esportare il backup in ogni caso; le discrepanze sono informative.';

  @override
  String get backupExportLedgerVerifyContinue => 'Continua con il backup';

  @override
  String get persistenceErrorReloaded =>
      'Impossibile salvare le modifiche. I dati sono stati ricaricati dalla memoria.';
}
