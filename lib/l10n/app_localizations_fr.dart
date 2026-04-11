// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Plan';

  @override
  String get navTrack => 'Historique';

  @override
  String get navReview => 'Analyse';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get close => 'Fermer';

  @override
  String get add => 'Ajouter';

  @override
  String get undo => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get restore => 'Restaurer';

  @override
  String get heroIn => 'Entrées';

  @override
  String get heroOut => 'Sorties';

  @override
  String get heroNet => 'Net';

  @override
  String get heroBalance => 'Solde';

  @override
  String get realBalance => 'Solde réel';

  @override
  String get heroResetButton => 'Réinitialiser';

  @override
  String get fabScrollToTop => 'Haut de page';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterAllAccounts => 'Tous les comptes';

  @override
  String get filterAllCategories => 'Toutes les catégories';

  @override
  String get txLabelIncome => 'REVENU';

  @override
  String get txLabelExpense => 'DÉPENSE';

  @override
  String get txLabelInvoice => 'FACTURE';

  @override
  String get txLabelBill => 'NOTE';

  @override
  String get txLabelAdvance => 'AVANCE';

  @override
  String get txLabelSettlement => 'RÈGLEMENT';

  @override
  String get txLabelLoan => 'PRÊT';

  @override
  String get txLabelCollection => 'RECOUVREMENT';

  @override
  String get txLabelOffset => 'COMPENSATION';

  @override
  String get txLabelTransfer => 'VIREMENT';

  @override
  String get txLabelTransaction => 'TRANSACTION';

  @override
  String get repeatNone => 'Pas de répétition';

  @override
  String get repeatDaily => 'Quotidien';

  @override
  String get repeatWeekly => 'Hebdomadaire';

  @override
  String get repeatMonthly => 'Mensuel';

  @override
  String get repeatYearly => 'Annuel';

  @override
  String get repeatEveryLabel => 'Tous les';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: 'jour',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semaines',
      one: 'semaine',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mois',
      one: 'mois',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ans',
      one: 'an',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Se termine';

  @override
  String get repeatEndNever => 'Jamais';

  @override
  String get repeatEndOnDate => 'À la date';

  @override
  String repeatEndAfterCount(int count) {
    return 'Après $count fois';
  }

  @override
  String get repeatEndAfterChoice => 'Après un certain nombre de fois';

  @override
  String get repeatEndPickDate => 'Choisir la date de fin';

  @override
  String get repeatEndTimes => 'fois';

  @override
  String repeatSummaryEvery(int count, String unit) {
    return 'Tous les $count $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'jusqu\'au $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count fois';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining sur $total restants';
  }

  @override
  String get detailRepeatEvery => 'Répéter tous les';

  @override
  String get detailEnds => 'Se termine';

  @override
  String get detailEndsNever => 'Jamais';

  @override
  String detailEndsOnDate(String date) {
    return 'Le $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Après $count fois';
  }

  @override
  String get detailProgress => 'Progression';

  @override
  String get weekendNoChange => 'Aucun changement';

  @override
  String get weekendFriday => 'Déplacer au vendredi';

  @override
  String get weekendMonday => 'Déplacer au lundi';

  @override
  String weekendQuestion(String day) {
    return 'Si le $day tombe un week-end ?';
  }

  @override
  String get dateToday => 'Aujourd\'hui';

  @override
  String get dateTomorrow => 'Demain';

  @override
  String get dateYesterday => 'Hier';

  @override
  String get statsAllTime => 'Depuis le début';

  @override
  String get accountGroupPersonal => 'Personnel';

  @override
  String get accountGroupIndividual => 'Individuel';

  @override
  String get accountGroupEntity => 'Entité';

  @override
  String get accountSectionIndividuals => 'Personnes';

  @override
  String get accountSectionEntities => 'Entités';

  @override
  String get emptyNoTransactionsYet => 'Aucune transaction pour l\'instant';

  @override
  String get emptyNoAccountsYet => 'Aucun compte pour l\'instant';

  @override
  String get emptyRecordFirstTransaction =>
      'Appuyez sur le bouton ci-dessous pour enregistrer votre première transaction.';

  @override
  String get emptyAddFirstAccountTx =>
      'Ajoutez votre premier compte avant d\'enregistrer des transactions.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Ajoutez votre premier compte avant de planifier des transactions.';

  @override
  String get emptyAddFirstAccountReview =>
      'Ajoutez votre premier compte pour commencer à suivre vos finances.';

  @override
  String get emptyAddTransaction => 'Ajouter une transaction';

  @override
  String get emptyAddAccount => 'Ajouter un compte';

  @override
  String get reviewEmptyGroupPersonalTitle =>
      'Aucun compte personnel pour l\'instant';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Les comptes personnels sont vos propres portefeuilles et comptes bancaires. Ajoutez-en un pour suivre vos revenus et dépenses quotidiens.';

  @override
  String get reviewEmptyGroupIndividualsTitle =>
      'Aucun compte individuel pour l\'instant';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Les comptes individuels suivent l\'argent avec des personnes spécifiques : dépenses partagées, prêts ou dettes. Ajoutez un compte pour chaque personne avec qui vous réglez des comptes.';

  @override
  String get reviewEmptyGroupEntitiesTitle =>
      'Aucun compte d\'entité pour l\'instant';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Les comptes d\'entités sont destinés aux entreprises, projets ou organisations. Utilisez-les pour séparer la trésorerie professionnelle de vos finances personnelles.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Aucune transaction pour les filtres appliqués';

  @override
  String get emptyNoTransactionsInHistory =>
      'Aucune transaction dans l\'historique';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Aucune transaction en $month';
  }

  @override
  String get emptyNoTransactionsForAccount =>
      'Aucune transaction pour ce compte';

  @override
  String get trackTransactionDeleted => 'Transaction supprimée';

  @override
  String get trackDeleteTitle => 'Supprimer la transaction ?';

  @override
  String get trackDeleteBody =>
      'Cela annulera les modifications du solde du compte.';

  @override
  String get trackTransaction => 'Transaction';

  @override
  String get planConfirmTitle => 'Confirmer la transaction ?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Cette occurrence est prévue pour le $date. Elle sera enregistrée dans l\'Historique à la date d\'aujourd\'hui ($todayDate). La prochaine occurrence reste le $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Cela appliquera la transaction aux soldes réels de votre compte et la déplacera vers l\'Historique.';

  @override
  String get planTransactionConfirmed => 'Transaction confirmée et appliquée';

  @override
  String get planTransactionRemoved => 'Transaction planifiée supprimée';

  @override
  String get planRepeatingTitle => 'Transaction récurrente';

  @override
  String get planRepeatingBody =>
      'Ignorez uniquement cette date — la série continue avec l\'occurrence suivante — ou supprimez toutes les occurrences restantes de votre plan.';

  @override
  String get planDeleteAll => 'Tout supprimer';

  @override
  String get planSkipThisOnly => 'Ignorer seulement celle-ci';

  @override
  String get planOccurrenceSkipped =>
      'Cette occurrence ignorée — la suivante est planifiée';

  @override
  String get planNothingPlanned => 'Rien de planifié pour l\'instant';

  @override
  String get planPlanBody => 'Planifiez vos transactions à venir.';

  @override
  String get planAddPlan => 'Ajouter un plan';

  @override
  String get planNoPlannedForFilters =>
      'Aucune transaction planifiée pour les filtres appliqués';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Aucune transaction planifiée en $month';
  }

  @override
  String get planOverdue => 'en retard';

  @override
  String get planPlannedTransaction => 'Transaction planifiée';

  @override
  String get discardTitle => 'Abandonner les modifications ?';

  @override
  String get discardBody =>
      'Vous avez des modifications non enregistrées. Elles seront perdues si vous quittez maintenant.';

  @override
  String get keepEditing => 'Continuer l\'édition';

  @override
  String get discard => 'Annuler';

  @override
  String get newTransactionTitle => 'Nouvelle transaction';

  @override
  String get editTransactionTitle => 'Modifier la transaction';

  @override
  String get transactionUpdated => 'Transaction mise à jour';

  @override
  String get sectionAccounts => 'Comptes';

  @override
  String get labelFrom => 'De';

  @override
  String get labelTo => 'À';

  @override
  String get sectionCategory => 'Catégorie';

  @override
  String get sectionAttachments => 'Pièces jointes';

  @override
  String get labelNote => 'Note';

  @override
  String get hintOptionalDescription => 'Description facultative';

  @override
  String get updateTransaction => 'Mettre à jour la transaction';

  @override
  String get saveTransaction => 'Enregistrer la transaction';

  @override
  String get selectAccount => 'Sélectionner un compte';

  @override
  String get selectAccountTitle => 'Sélectionner un compte';

  @override
  String get noAccountsAvailable => 'Aucun compte disponible';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Montant reçu par $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Saisissez le montant exact reçu par le compte de destination. Cela fixe le taux de change réel utilisé.';

  @override
  String get attachTakePhoto => 'Prendre une photo';

  @override
  String get attachTakePhotoSub =>
      'Utiliser l\'appareil photo pour capturer un reçu';

  @override
  String get attachChooseGallery => 'Choisir dans la galerie';

  @override
  String get attachChooseGallerySub =>
      'Sélectionner des photos depuis votre bibliothèque';

  @override
  String get attachBrowseFiles => 'Parcourir les fichiers';

  @override
  String get attachBrowseFilesSub =>
      'Joindre des PDF, documents ou autres fichiers';

  @override
  String get attachButton => 'Joindre';

  @override
  String get editPlanTitle => 'Modifier le plan';

  @override
  String get planTransactionTitle => 'Planifier une transaction';

  @override
  String get tapToSelect => 'Appuyer pour sélectionner';

  @override
  String get updatePlan => 'Mettre à jour le plan';

  @override
  String get addToPlan => 'Ajouter au plan';

  @override
  String get labelRepeat => 'Répéter';

  @override
  String get selectPlannedDate => 'Sélectionner la date planifiée';

  @override
  String get balancesAsOfToday => 'Soldes à ce jour';

  @override
  String get projectedBalancesForTomorrow => 'Soldes projetés pour demain';

  @override
  String projectedBalancesForDate(String date) {
    return 'Soldes projetés pour le $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name reçoit ($currency)';
  }

  @override
  String get destHelper =>
      'Montant estimé à destination. Le taux exact est fixé à la confirmation.';

  @override
  String get descriptionOptional => 'Description (facultatif)';

  @override
  String get detailTransactionTitle => 'Transaction';

  @override
  String get detailPlannedTitle => 'Planifiée';

  @override
  String get detailConfirmTransaction => 'Confirmer la transaction';

  @override
  String get detailDate => 'Date';

  @override
  String get detailFrom => 'De';

  @override
  String get detailTo => 'À';

  @override
  String get detailCategory => 'Catégorie';

  @override
  String get detailNote => 'Note';

  @override
  String get detailDestinationAmount => 'Montant à destination';

  @override
  String get detailExchangeRate => 'Taux de change';

  @override
  String get detailRepeats => 'Répétitions';

  @override
  String get detailDayOfMonth => 'Jour du mois';

  @override
  String get detailWeekends => 'Week-ends';

  @override
  String get detailAttachments => 'Pièces jointes';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers',
      one: '1 fichier',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionDisplay => 'Affichage';

  @override
  String get settingsSectionLanguage => 'Langue';

  @override
  String get settingsSectionCategories => 'Catégories';

  @override
  String get settingsSectionAccounts => 'Comptes';

  @override
  String get settingsSectionPreferences => 'Préférences';

  @override
  String get settingsSectionManage => 'Gérer';

  @override
  String get settingsBaseCurrency => 'Devise principale';

  @override
  String get settingsSecondaryCurrency => 'Devise secondaire';

  @override
  String get settingsCategories => 'Catégories';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount revenus · $expenseCount dépenses';
  }

  @override
  String get settingsArchivedAccounts => 'Comptes archivés';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Aucun pour l\'instant — archiver depuis la modification du compte quand le solde est nul';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count masqués de l\'Analyse et des sélecteurs';
  }

  @override
  String get settingsSectionData => 'Données';

  @override
  String get settingsSectionPrivacy => 'À propos';

  @override
  String get settingsPrivacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Comment Platrare gère vos données.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Taux de change : l\'application récupère des taux de change publics sur internet. Vos comptes et transactions ne sont jamais envoyés.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Impossible de charger la politique de confidentialité.';

  @override
  String get settingsPrivacyRetry => 'Réessayer';

  @override
  String get settingsSoftwareVersionTitle => 'Version du logiciel';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Version, diagnostics et mentions légales';

  @override
  String get aboutScreenTitle => 'À propos';

  @override
  String get aboutAppTagline =>
      'Grand livre, trésorerie et planification en un seul espace.';

  @override
  String get aboutDescriptionBody =>
      'Platrare conserve comptes, transactions et plans sur votre appareil. Exportez des sauvegardes chiffrées quand vous avez besoin d\'une copie ailleurs. Les taux de change utilisent uniquement des données publiques ; votre grand livre n\'est pas téléchargé.';

  @override
  String get aboutVersionLabel => 'Version';

  @override
  String get aboutBuildLabel => 'Build';

  @override
  String get aboutCopySupportDetails => 'Copier les détails d\'assistance';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Ouvre le document de politique complet dans l\'app.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Langue du système';

  @override
  String get settingsSupportInfoCopied => 'Copié dans le presse-papiers';

  @override
  String get settingsVerifyLedger => 'Vérifier les données';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Vérifier que les soldes des comptes correspondent à l\'historique des transactions';

  @override
  String get settingsDataExportTitle => 'Exporter la sauvegarde';

  @override
  String get settingsDataExportSubtitle =>
      'Enregistrer en .zip ou .platrare chiffré avec toutes les données et pièces jointes';

  @override
  String get settingsDataImportTitle => 'Restaurer depuis une sauvegarde';

  @override
  String get settingsDataImportSubtitle =>
      'Remplacer les données actuelles depuis une sauvegarde .zip ou .platrare de Platrare';

  @override
  String get backupExportDialogTitle => 'Protéger cette sauvegarde';

  @override
  String get backupExportDialogBody =>
      'Un mot de passe fort est recommandé, surtout si vous stockez le fichier dans le cloud. Vous aurez besoin du même mot de passe pour importer.';

  @override
  String get backupExportPasswordLabel => 'Mot de passe';

  @override
  String get backupExportPasswordConfirmLabel => 'Confirmer le mot de passe';

  @override
  String get backupExportPasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get backupExportPasswordEmpty =>
      'Saisissez un mot de passe correspondant ou exportez sans chiffrement ci-dessous.';

  @override
  String get backupExportPasswordTooShort =>
      'Le mot de passe doit comporter au moins 8 caractères.';

  @override
  String get backupExportSaveToDevice => 'Enregistrer sur l\'appareil';

  @override
  String get backupExportShareToCloud => 'Partager (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Exporter sans chiffrement';

  @override
  String get backupExportSkipWarningTitle => 'Exporter sans chiffrement ?';

  @override
  String get backupExportSkipWarningBody =>
      'Toute personne ayant accès au fichier peut lire vos données. N\'utilisez ceci que pour des copies locales que vous contrôlez.';

  @override
  String get backupExportSkipWarningConfirm => 'Exporter sans chiffrer';

  @override
  String get backupImportPasswordTitle => 'Sauvegarde chiffrée';

  @override
  String get backupImportPasswordBody =>
      'Saisissez le mot de passe utilisé lors de l\'exportation.';

  @override
  String get backupImportPasswordLabel => 'Mot de passe';

  @override
  String get backupImportPreviewTitle => 'Résumé de la sauvegarde';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Version de l\'app : $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Exporté le : $date';
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
    return '$accounts comptes · $transactions transactions · $planned planifiées · $attachments pièces jointes · $income catégories de revenus · $expense catégories de dépenses';
  }

  @override
  String get backupImportPreviewContinue => 'Continuer';

  @override
  String get settingsBackupWrongPassword => 'Mot de passe incorrect';

  @override
  String get settingsBackupChecksumMismatch =>
      'La sauvegarde n\'a pas passé la vérification d\'intégrité';

  @override
  String get settingsBackupCorruptFile =>
      'Fichier de sauvegarde invalide ou endommagé';

  @override
  String get settingsBackupUnsupportedVersion =>
      'La sauvegarde nécessite une version plus récente de l\'app';

  @override
  String get settingsDataImportConfirmTitle =>
      'Remplacer les données actuelles ?';

  @override
  String get settingsDataImportConfirmBody =>
      'Cela remplacera vos comptes, transactions, transactions planifiées, catégories et pièces jointes importées actuels par le contenu de la sauvegarde sélectionnée. Cette action est irréversible.';

  @override
  String get settingsDataImportConfirmAction => 'Remplacer les données';

  @override
  String get settingsDataImportDone => 'Données restaurées avec succès';

  @override
  String get settingsDataImportInvalidFile =>
      'Ce fichier n\'est pas une sauvegarde Platrare valide';

  @override
  String get settingsDataImportFailed => 'Échec de l\'importation';

  @override
  String get settingsDataExportDoneTitle => 'Sauvegarde exportée';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Sauvegarde enregistrée dans :\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Ouvrir le fichier';

  @override
  String get settingsDataExportFailed => 'Échec de l\'exportation';

  @override
  String get ledgerVerifyDialogTitle => 'Vérification du grand livre';

  @override
  String get ledgerVerifyAllMatch => 'Tous les comptes correspondent.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Incohérences';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nStocké : $stored\nRejoué : $replayed\nDifférence : $diff';
  }

  @override
  String get settingsLanguage => 'Langue de l\'app';

  @override
  String get settingsLanguageSubtitleSystem => 'Selon les paramètres système';

  @override
  String get settingsLanguageSubtitleEnglish => 'English';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Serbian (Latin)';

  @override
  String get settingsLanguagePickerTitle => 'Langue de l\'app';

  @override
  String get settingsLanguageOptionSystem => 'Paramètre système';

  @override
  String get settingsLanguageOptionEnglish => 'English';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Serbian (Latin)';

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get settingsSectionSecurity => 'Sécurité';

  @override
  String get settingsSecurityEnableLock => 'Verrouiller l\'app à l\'ouverture';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Exiger un déverrouillage biométrique ou un PIN à l\'ouverture de l\'app';

  @override
  String get settingsSecuritySetPin => 'Définir le PIN';

  @override
  String get settingsSecurityChangePin => 'Modifier le PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Utiliser un PIN en secours si la biométrie n\'est pas disponible';

  @override
  String get settingsSecurityRemovePin => 'Supprimer le PIN';

  @override
  String get securitySetPinTitle => 'Définir le PIN de l\'app';

  @override
  String get securityPinLabel => 'Code PIN';

  @override
  String get securityConfirmPinLabel => 'Confirmer le code PIN';

  @override
  String get securityPinMustBe4Digits =>
      'Le PIN doit comporter au moins 4 chiffres';

  @override
  String get securityPinMismatch => 'Les codes PIN ne correspondent pas';

  @override
  String get securityRemovePinTitle => 'Supprimer le PIN ?';

  @override
  String get securityRemovePinBody =>
      'Le déverrouillage biométrique peut toujours être utilisé s\'il est disponible.';

  @override
  String get securityUnlockTitle => 'App verrouillée';

  @override
  String get securityUnlockSubtitle =>
      'Déverrouillez avec Face ID, empreinte ou PIN.';

  @override
  String get securityUnlockWithPin => 'Déverrouiller avec le PIN';

  @override
  String get securityTryBiometric => 'Essayer le déverrouillage biométrique';

  @override
  String get securityPinIncorrect => 'PIN incorrect, réessayez';

  @override
  String get securityBiometricReason =>
      'Authentifiez-vous pour ouvrir votre app';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSubtitleSystem => 'Selon les paramètres système';

  @override
  String get settingsThemeSubtitleLight => 'Clair';

  @override
  String get settingsThemeSubtitleDark => 'Sombre';

  @override
  String get settingsThemePickerTitle => 'Thème';

  @override
  String get settingsThemeOptionSystem => 'Paramètre système';

  @override
  String get settingsThemeOptionLight => 'Clair';

  @override
  String get settingsThemeOptionDark => 'Sombre';

  @override
  String get archivedAccountsTitle => 'Comptes archivés';

  @override
  String get archivedAccountsEmptyTitle => 'Aucun compte archivé';

  @override
  String get archivedAccountsEmptyBody =>
      'Le solde comptable et le découvert doivent être nuls. Archiver depuis les options du compte dans Analyse.';

  @override
  String get categoriesTitle => 'Catégories';

  @override
  String get newCategoryTitle => 'Nouvelle catégorie';

  @override
  String get categoryNameLabel => 'Nom de la catégorie';

  @override
  String get deleteCategoryTitle => 'Supprimer la catégorie ?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" sera supprimée de la liste.';
  }

  @override
  String get categoryIncome => 'Revenu';

  @override
  String get categoryExpense => 'Dépense';

  @override
  String get categoryAdd => 'Ajouter';

  @override
  String get searchCurrencies => 'Rechercher des devises…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1A';

  @override
  String get periodAll => 'TOUT';

  @override
  String get categoryLabel => 'catégorie';

  @override
  String get categoriesLabel => 'catégories';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type enregistrée  •  $amount';
  }

  @override
  String get tooltipSettings => 'Paramètres';

  @override
  String get tooltipAddAccount => 'Ajouter un compte';

  @override
  String get tooltipRemoveAccount => 'Supprimer un compte';

  @override
  String get accountNameTaken =>
      'Vous avez déjà un compte avec ce nom et cet identifiant (actif ou archivé). Modifiez le nom ou l\'identifiant.';

  @override
  String get groupDescPersonal =>
      'Vos propres portefeuilles et comptes bancaires';

  @override
  String get groupDescIndividuals => 'Famille, amis, personnes';

  @override
  String get groupDescEntities => 'Entités, services, organisations';

  @override
  String get cannotArchiveTitle => 'Archivage impossible pour l\'instant';

  @override
  String get cannotArchiveBody =>
      'L\'archivage n\'est disponible que lorsque le solde comptable et la limite de découvert sont effectivement nuls.';

  @override
  String get cannotArchiveBodyAdjust =>
      'L\'archivage n\'est disponible que lorsque le solde comptable et la limite de découvert sont effectivement nuls. Ajustez d\'abord le grand livre ou la facilité.';

  @override
  String get archiveAccountTitle => 'Archiver le compte ?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions planifiées font référence à ce compte.',
      one: '1 transaction planifiée fait référence à ce compte.',
    );
    return '$_temp0 Supprimez-les pour maintenir votre plan cohérent avec un compte archivé.';
  }

  @override
  String get removeAndArchive => 'Supprimer les planifiées et archiver';

  @override
  String get archiveBody =>
      'Le compte sera masqué des sélecteurs d\'Analyse, d\'Historique et de Plan. Vous pouvez le restaurer depuis Paramètres.';

  @override
  String get archiveAction => 'Archiver';

  @override
  String get archiveInstead => 'Archiver à la place';

  @override
  String get cannotDeleteTitle => 'Impossible de supprimer le compte';

  @override
  String get cannotDeleteBodyShort =>
      'Ce compte figure dans votre historique. Supprimez ou réaffectez d\'abord ces transactions, ou archivez le compte si le solde est soldé.';

  @override
  String get cannotDeleteBodyHistory =>
      'Ce compte figure dans votre historique. Sa suppression briserait cet historique — supprimez ou réaffectez d\'abord ces transactions.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Ce compte figure dans votre historique et ne peut donc pas être supprimé. Vous pouvez l\'archiver si le solde comptable et le découvert sont soldés — il sera masqué des listes mais l\'historique restera intact.';

  @override
  String get deleteAccountTitle => 'Supprimer le compte ?';

  @override
  String get deleteAccountBodyPermanent =>
      'Ce compte sera supprimé définitivement.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transactions planifiées font référence à ce compte et seront également supprimées.',
      one:
          '1 transaction planifiée fait référence à ce compte et sera également supprimée.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Tout supprimer';

  @override
  String get editAccountTitle => 'Modifier le compte';

  @override
  String get newAccountTitle => 'Nouveau compte';

  @override
  String get labelAccountName => 'Nom du compte';

  @override
  String get labelAccountIdentifier => 'Identifiant (facultatif)';

  @override
  String get accountAppearanceSection => 'Icône et couleur';

  @override
  String get accountPickIcon => 'Choisir une icône';

  @override
  String get accountPickColor => 'Choisir une couleur';

  @override
  String get accountIconSheetTitle => 'Icône du compte';

  @override
  String get accountColorSheetTitle => 'Couleur du compte';

  @override
  String get accountUseInitialLetter => 'Initiale';

  @override
  String get accountUseDefaultColor => 'Correspondre au groupe';

  @override
  String get labelRealBalance => 'Solde réel';

  @override
  String get labelOverdraftLimit => 'Limite de découvert / avance';

  @override
  String get labelCurrency => 'Devise';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get addAccountAction => 'Ajouter un compte';

  @override
  String get removeAccountSheetTitle => 'Supprimer le compte';

  @override
  String get deletePermanently => 'Supprimer définitivement';

  @override
  String get deletePermanentlySubtitle =>
      'Uniquement possible quand ce compte n\'est pas utilisé dans l\'Historique. Les éléments planifiés peuvent être supprimés dans le cadre de la suppression.';

  @override
  String get archiveOptionSubtitle =>
      'Masquer de l\'Analyse et des sélecteurs. Restaurer à tout moment depuis Paramètres. Nécessite un solde et un découvert nuls.';

  @override
  String get archivedBannerText =>
      'Ce compte est archivé. Il reste dans vos données mais est masqué des listes et sélecteurs.';

  @override
  String get balanceAdjustedTitle => 'Solde ajusté dans l\'Historique';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Le solde réel a été mis à jour de $previous à $current $symbol.\n\nUne transaction d\'ajustement de solde a été créée dans l\'Historique pour maintenir la cohérence du grand livre.\n\n• Le solde réel reflète le montant réel sur ce compte.\n• Consultez l\'Historique pour voir l\'écriture d\'ajustement.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Ajustement de solde';

  @override
  String get descriptionBalanceCorrection => 'Correction de solde';

  @override
  String get descriptionOpeningBalance => 'Solde d\'ouverture';

  @override
  String get reviewStatsModeStatistics => 'Statistiques';

  @override
  String get reviewStatsModeComparison => 'Comparaison';

  @override
  String get statsUncategorized => 'Non catégorisé';

  @override
  String get statsNoCategories =>
      'Aucune catégorie dans les périodes sélectionnées pour la comparaison.';

  @override
  String get statsNoTransactions => 'Aucune transaction';

  @override
  String get statsSpendingInCategory => 'Dépenses dans cette catégorie';

  @override
  String get statsIncomeInCategory => 'Revenus dans cette catégorie';

  @override
  String get statsDifference => 'Différence (B vs A) : ';

  @override
  String get statsNoExpensesMonth => 'Aucune dépense ce mois';

  @override
  String get statsNoExpensesAll => 'Aucune dépense enregistrée';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Aucune dépense au cours des $period derniers';
  }

  @override
  String get statsTotalSpent => 'Total dépensé';

  @override
  String get statsNoExpensesThisPeriod => 'Aucune dépense sur cette période';

  @override
  String get statsNoIncomeMonth => 'Aucun revenu ce mois';

  @override
  String get statsNoIncomeAll => 'Aucun revenu enregistré';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Aucun revenu au cours des $period derniers';
  }

  @override
  String get statsTotalReceived => 'Total reçu';

  @override
  String get statsNoIncomeThisPeriod => 'Aucun revenu sur cette période';

  @override
  String get catSalary => 'Salaire';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catConsulting => 'Conseil';

  @override
  String get catGift => 'Cadeau';

  @override
  String get catRental => 'Location';

  @override
  String get catDividends => 'Dividendes';

  @override
  String get catRefund => 'Remboursement';

  @override
  String get catBonus => 'Prime';

  @override
  String get catInterest => 'Intérêts';

  @override
  String get catSideHustle => 'Revenus annexes';

  @override
  String get catSaleOfGoods => 'Vente de biens';

  @override
  String get catOther => 'Autre';

  @override
  String get catGroceries => 'Courses';

  @override
  String get catDining => 'Restauration';

  @override
  String get catTransport => 'Transport';

  @override
  String get catUtilities => 'Services';

  @override
  String get catHousing => 'Logement';

  @override
  String get catHealthcare => 'Santé';

  @override
  String get catEntertainment => 'Loisirs';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catTravel => 'Voyages';

  @override
  String get catEducation => 'Éducation';

  @override
  String get catSubscriptions => 'Abonnements';

  @override
  String get catInsurance => 'Assurance';

  @override
  String get catFuel => 'Carburant';

  @override
  String get catGym => 'Salle de sport';

  @override
  String get catPets => 'Animaux';

  @override
  String get catKids => 'Enfants';

  @override
  String get catCharity => 'Dons';

  @override
  String get catCoffee => 'Café';

  @override
  String get catGifts => 'Cadeaux';

  @override
  String semanticsProjectionDate(String date) {
    return 'Date de projection $date. Double appui pour choisir la date';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Solde personnel projeté $amount';
  }

  @override
  String get statsEmptyTitle => 'Aucune transaction pour l\'instant';

  @override
  String get statsEmptySubtitle =>
      'Aucune donnée de dépense pour la plage sélectionnée.';

  @override
  String get semanticsShowProjections =>
      'Afficher les soldes projetés par compte';

  @override
  String get semanticsHideProjections =>
      'Masquer les soldes projetés par compte';

  @override
  String get semanticsDateAllTime =>
      'Date : depuis le début — appuyer pour changer de mode';

  @override
  String semanticsDateMode(String mode) {
    return 'Date : $mode — appuyer pour changer de mode';
  }

  @override
  String get semanticsDateThisMonth =>
      'Date : ce mois — appuyer pour mois, semaine, année ou tout';

  @override
  String get semanticsTxTypeCycle =>
      'Type de transaction : tout, revenu, dépense, virement';

  @override
  String get semanticsAccountFilter => 'Filtre de compte';

  @override
  String get semanticsAlreadyFiltered => 'Déjà filtré sur ce compte';

  @override
  String get semanticsCategoryFilter => 'Filtre de catégorie';

  @override
  String get semanticsSortToggle =>
      'Tri : basculer le plus récent ou le plus ancien en premier';

  @override
  String get semanticsFiltersDisabled =>
      'Filtres de liste désactivés lors de la visualisation d\'une date de projection future. Effacez les projections pour utiliser les filtres.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Filtres de liste désactivés. Ajoutez d\'abord un compte.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Filtres de liste désactivés. Ajoutez d\'abord une transaction planifiée.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Filtres de liste désactivés. Enregistrez d\'abord une transaction.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Contrôles de section et de devise désactivés. Ajoutez d\'abord un compte.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Date de projection et décomposition du solde désactivées. Ajoutez d\'abord un compte et une transaction planifiée.';

  @override
  String get semanticsReorderAccountHint =>
      'Appui long, puis glisser pour réorganiser dans ce groupe';

  @override
  String get semanticsChartStyle => 'Style de graphique';

  @override
  String get semanticsChartStyleUnavailable =>
      'Style de graphique (non disponible en mode comparaison)';

  @override
  String semanticsPeriod(String label) {
    return 'Période : $label';
  }

  @override
  String get trackSearchHint => 'Rechercher description, catégorie, compte…';

  @override
  String get trackSearchClear => 'Effacer la recherche';

  @override
  String get settingsExchangeRatesTitle => 'Taux de change';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Dernière mise à jour : $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Utilisation des taux hors ligne ou inclus — appuyer pour actualiser';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Taux de change mis à jour';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Impossible de mettre à jour les taux de change. Vérifiez votre connexion.';

  @override
  String get settingsClearData => 'Effacer les données';

  @override
  String get settingsClearDataSubtitle =>
      'Supprimer définitivement les données sélectionnées';

  @override
  String get clearDataTitle => 'Effacer les données';

  @override
  String get clearDataTransactions => 'Historique des transactions';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transactions · soldes des comptes remis à zéro';
  }

  @override
  String get clearDataPlanned => 'Transactions planifiées';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count éléments planifiés';
  }

  @override
  String get clearDataAccounts => 'Comptes';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count comptes · efface également l\'historique et le plan';
  }

  @override
  String get clearDataCategories => 'Catégories';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count catégories · remplacées par les valeurs par défaut';
  }

  @override
  String get clearDataPreferences => 'Préférences';

  @override
  String get clearDataPreferencesSubtitle =>
      'Réinitialiser la devise, le thème et la langue aux valeurs par défaut';

  @override
  String get clearDataSecurity => 'Verrouillage et PIN';

  @override
  String get clearDataSecuritySubtitle =>
      'Désactiver le verrouillage de l\'app et supprimer le PIN';

  @override
  String get clearDataConfirmButton => 'Effacer la sélection';

  @override
  String get clearDataConfirmTitle => 'Cette action est irréversible';

  @override
  String get clearDataConfirmBody =>
      'Les données sélectionnées seront supprimées définitivement. Exportez d\'abord une sauvegarde si vous pourriez en avoir besoin ultérieurement.';

  @override
  String get clearDataTypeConfirm => 'Tapez DELETE pour confirmer';

  @override
  String get clearDataTypeConfirmError =>
      'Tapez DELETE exactement pour continuer';

  @override
  String get clearDataPinTitle => 'Confirmer avec le PIN';

  @override
  String get clearDataPinBody =>
      'Saisissez votre PIN d\'application pour autoriser cette action.';

  @override
  String get clearDataPinIncorrect => 'PIN incorrect';

  @override
  String get clearDataDone => 'Données sélectionnées effacées';

  @override
  String get autoBackupTitle => 'Sauvegarde automatique quotidienne';

  @override
  String autoBackupLastAt(String date) {
    return 'Dernière sauvegarde le $date';
  }

  @override
  String get autoBackupNeverRun => 'Aucune sauvegarde pour l\'instant';

  @override
  String get autoBackupShareTitle => 'Enregistrer dans le cloud';

  @override
  String get autoBackupShareSubtitle =>
      'Télécharger la dernière sauvegarde sur iCloud Drive, Google Drive ou toute autre app';

  @override
  String get autoBackupCloudReminder =>
      'Sauvegarde automatique prête — enregistrez-la dans le cloud pour une protection hors appareil';

  @override
  String get autoBackupCloudReminderAction => 'Partager';

  @override
  String get persistenceErrorReloaded =>
      'Impossible d\'enregistrer les modifications. Les données ont été rechargées depuis le stockage.';
}
