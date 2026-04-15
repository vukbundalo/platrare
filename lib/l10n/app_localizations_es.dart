// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Plan';

  @override
  String get navTrack => 'Historial';

  @override
  String get navReview => 'Análisis';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get close => 'Cerrar';

  @override
  String get add => 'Añadir';

  @override
  String get undo => 'Deshacer';

  @override
  String get confirm => 'Confirmar';

  @override
  String get restore => 'Restaurar';

  @override
  String get heroIn => 'Entradas';

  @override
  String get heroOut => 'Salidas';

  @override
  String get heroNet => 'Neto';

  @override
  String get heroBalance => 'Saldo';

  @override
  String get realBalance => 'Saldo real';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Ocultar saldos en las tarjetas de resumen';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Cuando está activado, los importes en Plan, Seguimiento y Revisión permanecen enmascarados hasta que toque el ícono del ojo en cada pestaña. Cuando está desactivado, los saldos siempre son visibles.';

  @override
  String get heroBalancesShow => 'Mostrar saldos';

  @override
  String get heroBalancesHide => 'Ocultar saldos';

  @override
  String get semanticsHeroBalanceHidden => 'Saldo oculto por privacidad';

  @override
  String get heroResetButton => 'Restablecer';

  @override
  String get fabScrollToTop => 'Volver arriba';

  @override
  String get filterAll => 'Todo';

  @override
  String get filterAllAccounts => 'Todas las cuentas';

  @override
  String get filterAllCategories => 'Todas las categorías';

  @override
  String get txLabelIncome => 'INGRESO';

  @override
  String get txLabelExpense => 'GASTO';

  @override
  String get txLabelInvoice => 'FACTURA';

  @override
  String get txLabelBill => 'RECIBO';

  @override
  String get txLabelAdvance => 'ANTICIPO';

  @override
  String get txLabelSettlement => 'LIQUIDACIÓN';

  @override
  String get txLabelLoan => 'PRÉSTAMO';

  @override
  String get txLabelCollection => 'COBRO';

  @override
  String get txLabelOffset => 'COMPENSACIÓN';

  @override
  String get txLabelTransfer => 'TRANSFERENCIA';

  @override
  String get txLabelTransaction => 'TRANSACCIÓN';

  @override
  String get repeatNone => 'Sin repetición';

  @override
  String get repeatDaily => 'Diario';

  @override
  String get repeatWeekly => 'Semanal';

  @override
  String get repeatMonthly => 'Mensual';

  @override
  String get repeatYearly => 'Anual';

  @override
  String get repeatEveryLabel => 'Cada';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: 'día',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: 'semana',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: 'mes',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count años',
      one: 'año',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Finaliza';

  @override
  String get repeatEndNever => 'Nunca';

  @override
  String get repeatEndOnDate => 'En fecha';

  @override
  String repeatEndAfterCount(int count) {
    return 'Después de $count veces';
  }

  @override
  String get repeatEndAfterChoice => 'Tras un número de veces';

  @override
  String get repeatEndPickDate => 'Seleccionar fecha de fin';

  @override
  String get repeatEndTimes => 'veces';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Cada $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'hasta $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count veces';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining de $total restantes';
  }

  @override
  String get detailRepeatEvery => 'Repetir cada';

  @override
  String get detailEnds => 'Finaliza';

  @override
  String get detailEndsNever => 'Nunca';

  @override
  String detailEndsOnDate(String date) {
    return 'El $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Después de $count veces';
  }

  @override
  String get detailProgress => 'Progreso';

  @override
  String get weekendNoChange => 'Sin cambio';

  @override
  String get weekendFriday => 'Mover al viernes';

  @override
  String get weekendMonday => 'Mover al lunes';

  @override
  String weekendQuestion(String day) {
    return '¿Si el $day cae en fin de semana?';
  }

  @override
  String get dateToday => 'Hoy';

  @override
  String get dateTomorrow => 'Mañana';

  @override
  String get dateYesterday => 'Ayer';

  @override
  String get statsAllTime => 'Todo el tiempo';

  @override
  String get accountGroupPersonal => 'Personal';

  @override
  String get accountGroupIndividual => 'Individual';

  @override
  String get accountGroupEntity => 'Entidad';

  @override
  String get accountSectionIndividuals => 'Personas';

  @override
  String get accountSectionEntities => 'Entidades';

  @override
  String get emptyNoTransactionsYet => 'Aún no hay transacciones';

  @override
  String get emptyNoAccountsYet => 'Aún no hay cuentas';

  @override
  String get emptyRecordFirstTransaction =>
      'Toca el botón de abajo para registrar tu primera transacción.';

  @override
  String get emptyAddFirstAccountTx =>
      'Añade tu primera cuenta antes de registrar transacciones.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Añade tu primera cuenta antes de planificar transacciones.';

  @override
  String get emptyAddFirstAccountReview =>
      'Añade tu primera cuenta para comenzar a seguir tus finanzas.';

  @override
  String get emptyAddTransaction => 'Añadir transacción';

  @override
  String get emptyAddAccount => 'Añadir cuenta';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Aún no hay cuentas personales';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Las cuentas personales son tus propias carteras y cuentas bancarias. Añade una para seguir ingresos y gastos del día a día.';

  @override
  String get reviewEmptyGroupIndividualsTitle =>
      'Aún no hay cuentas individuales';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Las cuentas individuales registran el dinero con personas específicas: gastos compartidos, préstamos o deudas. Añade una cuenta por cada persona con quien liquidas.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Aún no hay cuentas de entidades';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Las cuentas de entidades son para empresas, proyectos u organizaciones. Úsalas para mantener el flujo de caja empresarial separado de tus finanzas personales.';

  @override
  String get emptyNoTransactionsForFilters =>
      'No hay transacciones para los filtros aplicados';

  @override
  String get emptyNoTransactionsInHistory =>
      'No hay transacciones en el historial';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'No hay transacciones en $month';
  }

  @override
  String get emptyNoTransactionsForAccount =>
      'No hay transacciones para esta cuenta';

  @override
  String get trackTransactionDeleted => 'Transacción eliminada';

  @override
  String get trackDeleteTitle => '¿Eliminar transacción?';

  @override
  String get trackDeleteBody =>
      'Esto revertirá los cambios en el saldo de la cuenta.';

  @override
  String get trackTransaction => 'Transacción';

  @override
  String get planConfirmTitle => '¿Confirmar transacción?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Esta ocurrencia está programada para $date. Se registrará en el Historial con la fecha de hoy ($todayDate). La próxima ocurrencia permanece el $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Esto aplicará la transacción a los saldos reales de tu cuenta y la moverá al Historial.';

  @override
  String get planTransactionConfirmed => 'Transacción confirmada y aplicada';

  @override
  String get planTransactionRemoved => 'Transacción planificada eliminada';

  @override
  String get planRepeatingTitle => 'Transacción recurrente';

  @override
  String get planRepeatingBody =>
      'Omite solo esta fecha —la serie continúa con la siguiente ocurrencia— o elimina todas las ocurrencias restantes de tu plan.';

  @override
  String get planDeleteAll => 'Eliminar todas';

  @override
  String get planSkipThisOnly => 'Omitir solo esta';

  @override
  String get planOccurrenceSkipped =>
      'Esta ocurrencia omitida — la siguiente está programada';

  @override
  String get planNothingPlanned => 'Nada planificado por ahora';

  @override
  String get planPlanBody => 'Planifica transacciones futuras.';

  @override
  String get planAddPlan => 'Añadir plan';

  @override
  String get planNoPlannedForFilters =>
      'No hay transacciones planificadas para los filtros aplicados';

  @override
  String planNoPlannedInMonth(String month) {
    return 'No hay transacciones planificadas en $month';
  }

  @override
  String get planOverdue => 'vencido';

  @override
  String get planPlannedTransaction => 'Transacción planificada';

  @override
  String get discardTitle => '¿Descartar cambios?';

  @override
  String get discardBody =>
      'Tienes cambios sin guardar. Se perderán si sales ahora.';

  @override
  String get keepEditing => 'Seguir editando';

  @override
  String get discard => 'Descartar';

  @override
  String get newTransactionTitle => 'Nueva transacción';

  @override
  String get editTransactionTitle => 'Editar transacción';

  @override
  String get transactionUpdated => 'Transacción actualizada';

  @override
  String get sectionAccounts => 'Cuentas';

  @override
  String get labelFrom => 'De';

  @override
  String get labelTo => 'A';

  @override
  String get sectionCategory => 'Categoría';

  @override
  String get sectionAttachments => 'Adjuntos';

  @override
  String get labelNote => 'Nota';

  @override
  String get hintOptionalDescription => 'Descripción opcional';

  @override
  String get updateTransaction => 'Actualizar transacción';

  @override
  String get saveTransaction => 'Guardar transacción';

  @override
  String get selectAccount => 'Seleccionar cuenta';

  @override
  String get selectAccountTitle => 'Seleccionar cuenta';

  @override
  String get noAccountsAvailable => 'No hay cuentas disponibles';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Importe recibido por $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Introduce el importe exacto que recibe la cuenta de destino. Esto fija el tipo de cambio real utilizado.';

  @override
  String get attachTakePhoto => 'Tomar foto';

  @override
  String get attachTakePhotoSub => 'Usa la cámara para capturar un recibo';

  @override
  String get attachChooseGallery => 'Elegir de la galería';

  @override
  String get attachChooseGallerySub => 'Selecciona fotos de tu biblioteca';

  @override
  String get attachBrowseFiles => 'Explorar archivos';

  @override
  String get attachBrowseFilesSub =>
      'Adjunta PDFs, documentos u otros archivos';

  @override
  String get attachButton => 'Adjuntar';

  @override
  String get editPlanTitle => 'Editar plan';

  @override
  String get planTransactionTitle => 'Planificar transacción';

  @override
  String get tapToSelect => 'Toca para seleccionar';

  @override
  String get updatePlan => 'Actualizar plan';

  @override
  String get addToPlan => 'Añadir al plan';

  @override
  String get labelRepeat => 'Repetir';

  @override
  String get selectPlannedDate => 'Seleccionar fecha planificada';

  @override
  String get balancesAsOfToday => 'Saldos a fecha de hoy';

  @override
  String get projectedBalancesForTomorrow => 'Saldos proyectados para mañana';

  @override
  String projectedBalancesForDate(String date) {
    return 'Saldos proyectados para $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name recibe ($currency)';
  }

  @override
  String get destHelper =>
      'Importe estimado en destino. El tipo de cambio exacto se fija al confirmar.';

  @override
  String get descriptionOptional => 'Descripción (opcional)';

  @override
  String get detailTransactionTitle => 'Transacción';

  @override
  String get detailPlannedTitle => 'Planificada';

  @override
  String get detailConfirmTransaction => 'Confirmar transacción';

  @override
  String get detailDate => 'Fecha';

  @override
  String get detailFrom => 'De';

  @override
  String get detailTo => 'A';

  @override
  String get detailCategory => 'Categoría';

  @override
  String get detailNote => 'Nota';

  @override
  String get detailDestinationAmount => 'Importe en destino';

  @override
  String get detailExchangeRate => 'Tipo de cambio';

  @override
  String get detailRepeats => 'Se repite';

  @override
  String get detailDayOfMonth => 'Día del mes';

  @override
  String get detailWeekends => 'Fines de semana';

  @override
  String get detailAttachments => 'Adjuntos';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos',
      one: '1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionDisplay => 'Pantalla';

  @override
  String get settingsSectionLanguage => 'Idioma';

  @override
  String get settingsSectionCategories => 'Categorías';

  @override
  String get settingsSectionAccounts => 'Cuentas';

  @override
  String get settingsSectionPreferences => 'Preferencias';

  @override
  String get settingsSectionManage => 'Gestionar';

  @override
  String get settingsBaseCurrency => 'Moneda principal';

  @override
  String get settingsSecondaryCurrency => 'Moneda secundaria';

  @override
  String get settingsCategories => 'Categorías';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount ingresos · $expenseCount gastos';
  }

  @override
  String get settingsArchivedAccounts => 'Cuentas archivadas';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Ninguna por ahora — archiva desde la edición de cuenta cuando el saldo esté a cero';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count ocultas de Análisis y selectores';
  }

  @override
  String get settingsSectionData => 'Datos';

  @override
  String get settingsSectionPrivacy => 'Acerca de';

  @override
  String get settingsPrivacyPolicyTitle => 'Política de privacidad';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Cómo Platrare gestiona tus datos.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Tipos de cambio: la aplicación obtiene tasas de divisas públicas de internet. Tus cuentas y transacciones nunca se envían.';

  @override
  String get settingsPrivacyOpenFailed =>
      'No se pudo cargar la política de privacidad.';

  @override
  String get settingsPrivacyRetry => 'Reintentar';

  @override
  String get settingsSoftwareVersionTitle => 'Versión del software';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Versión, diagnósticos y avisos legales';

  @override
  String get aboutScreenTitle => 'Acerca de';

  @override
  String get aboutAppTagline =>
      'Libro mayor, flujo de caja y planificación en un solo espacio.';

  @override
  String get aboutDescriptionBody =>
      'Platrare guarda cuentas, transacciones y planes en tu dispositivo. Exporta copias de seguridad cifradas cuando necesites una copia en otro lugar. Los tipos de cambio solo usan datos públicos del mercado; tu libro mayor no se sube.';

  @override
  String get aboutVersionLabel => 'Versión';

  @override
  String get aboutBuildLabel => 'Compilación';

  @override
  String get aboutCopySupportDetails => 'Copiar detalles de soporte';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Abre el documento de política completo en la app.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Idioma del sistema';

  @override
  String get settingsSupportInfoCopied => 'Copiado al portapapeles';

  @override
  String get settingsVerifyLedger => 'Verificar datos';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Comprobar que los saldos de cuenta coinciden con el historial de transacciones';

  @override
  String get settingsDataExportTitle => 'Exportar copia de seguridad';

  @override
  String get settingsDataExportSubtitle =>
      'Guardar como .zip o .platrare cifrado con todos los datos y adjuntos';

  @override
  String get settingsDataImportTitle => 'Restaurar desde copia de seguridad';

  @override
  String get settingsDataImportSubtitle =>
      'Reemplazar los datos actuales desde una copia de seguridad .zip o .platrare de Platrare';

  @override
  String get backupExportDialogTitle => 'Proteger esta copia de seguridad';

  @override
  String get backupExportDialogBody =>
      'Se recomienda una contraseña segura, especialmente si guardas el archivo en la nube. Necesitarás la misma contraseña para importar.';

  @override
  String get backupExportPasswordLabel => 'Contraseña';

  @override
  String get backupExportPasswordConfirmLabel => 'Confirmar contraseña';

  @override
  String get backupExportPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get backupExportPasswordEmpty =>
      'Introduce una contraseña coincidente o exporta sin cifrado a continuación.';

  @override
  String get backupExportPasswordTooShort =>
      'La contraseña debe tener al menos 8 caracteres.';

  @override
  String get backupExportSaveToDevice => 'Guardar en el dispositivo';

  @override
  String get backupExportShareToCloud => 'Compartir (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Exportar sin cifrado';

  @override
  String get backupExportSkipWarningTitle => '¿Exportar sin cifrado?';

  @override
  String get backupExportSkipWarningBody =>
      'Cualquiera con acceso al archivo puede leer tus datos. Úsalo solo para copias locales que controles.';

  @override
  String get backupExportSkipWarningConfirm => 'Exportar sin cifrar';

  @override
  String get backupImportPasswordTitle => 'Copia de seguridad cifrada';

  @override
  String get backupImportPasswordBody =>
      'Introduce la contraseña que usaste al exportar.';

  @override
  String get backupImportPasswordLabel => 'Contraseña';

  @override
  String get backupImportPreviewTitle => 'Resumen de la copia de seguridad';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Versión de la app: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Exportado: $date';
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
    return '$accounts cuentas · $transactions transacciones · $planned planificadas · $attachments archivos adjuntos · $income categorías de ingresos · $expense categorías de gastos';
  }

  @override
  String get backupImportPreviewContinue => 'Continuar';

  @override
  String get settingsBackupWrongPassword => 'Contraseña incorrecta';

  @override
  String get settingsBackupChecksumMismatch =>
      'La copia de seguridad no superó la verificación de integridad';

  @override
  String get settingsBackupCorruptFile =>
      'Archivo de copia de seguridad no válido o dañado';

  @override
  String get settingsBackupUnsupportedVersion =>
      'La copia de seguridad requiere una versión más reciente de la app';

  @override
  String get settingsDataImportConfirmTitle =>
      '¿Reemplazar los datos actuales?';

  @override
  String get settingsDataImportConfirmBody =>
      'Esto reemplazará tus cuentas, transacciones, transacciones planificadas, categorías y adjuntos importados actuales con el contenido de la copia de seguridad seleccionada. Esta acción no se puede deshacer.';

  @override
  String get settingsDataImportConfirmAction => 'Reemplazar datos';

  @override
  String get settingsDataImportDone => 'Datos restaurados correctamente';

  @override
  String get settingsDataImportInvalidFile =>
      'Este archivo no es una copia de seguridad válida de Platrare';

  @override
  String get settingsDataImportFailed => 'Error al importar';

  @override
  String get settingsDataExportDoneTitle => 'Copia de seguridad exportada';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Copia de seguridad guardada en:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Abrir archivo';

  @override
  String get settingsDataExportFailed => 'Error al exportar';

  @override
  String get ledgerVerifyDialogTitle => 'Verificación del libro mayor';

  @override
  String get ledgerVerifyAllMatch => 'Todas las cuentas coinciden.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Discrepancias';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nAlmacenado: $stored\nReproducido: $replayed\nDiferencia: $diff';
  }

  @override
  String get settingsLanguage => 'Idioma de la app';

  @override
  String get settingsLanguageSubtitleSystem =>
      'Según la configuración del sistema';

  @override
  String get settingsLanguageSubtitleEnglish => 'English';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Serbian (Latin)';

  @override
  String get settingsLanguagePickerTitle => 'Idioma de la app';

  @override
  String get settingsLanguageOptionSystem => 'Por defecto del sistema';

  @override
  String get settingsLanguageOptionEnglish => 'English';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Serbian (Latin)';

  @override
  String get settingsSectionAppearance => 'Apariencia';

  @override
  String get settingsSectionSecurity => 'Seguridad';

  @override
  String get settingsSecurityEnableLock => 'Bloquear app al abrir';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Requerir desbloqueo biométrico o PIN al abrir la app';

  @override
  String get settingsSecuritySetPin => 'Establecer PIN';

  @override
  String get settingsSecurityChangePin => 'Cambiar PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Usa un PIN como alternativa si la biometría no está disponible';

  @override
  String get settingsSecurityRemovePin => 'Eliminar PIN';

  @override
  String get securitySetPinTitle => 'Establecer PIN de la app';

  @override
  String get securityPinLabel => 'Código PIN';

  @override
  String get securityConfirmPinLabel => 'Confirmar código PIN';

  @override
  String get securityPinMustBe4Digits => 'El PIN debe tener al menos 4 dígitos';

  @override
  String get securityPinMismatch => 'Los códigos PIN no coinciden';

  @override
  String get securityRemovePinTitle => '¿Eliminar PIN?';

  @override
  String get securityRemovePinBody =>
      'El desbloqueo biométrico aún puede usarse si está disponible.';

  @override
  String get securityUnlockTitle => 'App bloqueada';

  @override
  String get securityUnlockSubtitle =>
      'Desbloquea con Face ID, huella dactilar o PIN.';

  @override
  String get securityUnlockWithPin => 'Desbloquear con PIN';

  @override
  String get securityTryBiometric => 'Intentar desbloqueo biométrico';

  @override
  String get securityPinIncorrect => 'PIN incorrecto, inténtalo de nuevo';

  @override
  String get securityBiometricReason => 'Autentícate para abrir tu app';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitleSystem =>
      'Según la configuración del sistema';

  @override
  String get settingsThemeSubtitleLight => 'Claro';

  @override
  String get settingsThemeSubtitleDark => 'Oscuro';

  @override
  String get settingsThemePickerTitle => 'Tema';

  @override
  String get settingsThemeOptionSystem => 'Por defecto del sistema';

  @override
  String get settingsThemeOptionLight => 'Claro';

  @override
  String get settingsThemeOptionDark => 'Oscuro';

  @override
  String get archivedAccountsTitle => 'Cuentas archivadas';

  @override
  String get archivedAccountsEmptyTitle => 'No hay cuentas archivadas';

  @override
  String get archivedAccountsEmptyBody =>
      'El saldo contable y el descubierto deben ser cero. Archiva desde las opciones de cuenta en Análisis.';

  @override
  String get categoriesTitle => 'Categorías';

  @override
  String get newCategoryTitle => 'Nueva categoría';

  @override
  String get categoryNameLabel => 'Nombre de la categoría';

  @override
  String get deleteCategoryTitle => '¿Eliminar categoría?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" se eliminará de la lista.';
  }

  @override
  String get categoryIncome => 'Ingreso';

  @override
  String get categoryExpense => 'Gasto';

  @override
  String get categoryAdd => 'Añadir';

  @override
  String get searchCurrencies => 'Buscar divisas…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1A';

  @override
  String get periodAll => 'TODO';

  @override
  String get categoryLabel => 'categoría';

  @override
  String get categoriesLabel => 'categorías';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type guardada  •  $amount';
  }

  @override
  String get tooltipSettings => 'Ajustes';

  @override
  String get tooltipAddAccount => 'Añadir cuenta';

  @override
  String get tooltipRemoveAccount => 'Eliminar cuenta';

  @override
  String get accountNameTaken =>
      'Ya tienes una cuenta con este nombre e identificador (activa o archivada). Cambia el nombre o el identificador.';

  @override
  String get groupDescPersonal => 'Tus propias carteras y cuentas bancarias';

  @override
  String get groupDescIndividuals => 'Familia, amigos, personas';

  @override
  String get groupDescEntities => 'Entidades, servicios, organizaciones';

  @override
  String get cannotArchiveTitle => 'No se puede archivar aún';

  @override
  String get cannotArchiveBody =>
      'El archivo solo está disponible cuando el saldo contable y el límite de descubierto son efectivamente cero.';

  @override
  String get cannotArchiveBodyAdjust =>
      'El archivo solo está disponible cuando el saldo contable y el límite de descubierto son efectivamente cero. Ajusta primero el libro mayor o la facilidad.';

  @override
  String get archiveAccountTitle => '¿Archivar cuenta?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transacciones planificadas hacen referencia a esta cuenta.',
      one: '1 transacción planificada hace referencia a esta cuenta.',
    );
    return '$_temp0 Elimínalas para mantener tu plan coherente con una cuenta archivada.';
  }

  @override
  String get removeAndArchive => 'Eliminar planificadas y archivar';

  @override
  String get archiveBody =>
      'La cuenta se ocultará de los selectores de Análisis, Historial y Plan. Puedes restaurarla desde Ajustes.';

  @override
  String get archiveAction => 'Archivar';

  @override
  String get archiveInstead => 'Archivar en su lugar';

  @override
  String get cannotDeleteTitle => 'No se puede eliminar la cuenta';

  @override
  String get cannotDeleteBodyShort =>
      'Esta cuenta aparece en tu historial. Elimina o reasigna esas transacciones primero, o archiva la cuenta si el saldo está saldado.';

  @override
  String get cannotDeleteBodyHistory =>
      'Esta cuenta aparece en tu historial. Eliminarla rompería ese historial; elimina o reasigna esas transacciones primero.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Esta cuenta aparece en tu historial, por lo que no puede eliminarse. Puedes archivarla si el saldo contable y el descubierto están saldados; se ocultará de las listas pero el historial permanecerá intacto.';

  @override
  String get deleteAccountTitle => '¿Eliminar cuenta?';

  @override
  String get deleteAccountBodyPermanent =>
      'Esta cuenta se eliminará permanentemente.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count transacciones planificadas hacen referencia a esta cuenta y también se eliminarán.',
      one:
          '1 transacción planificada hace referencia a esta cuenta y también se eliminará.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Eliminar todas';

  @override
  String get editAccountTitle => 'Editar cuenta';

  @override
  String get newAccountTitle => 'Nueva cuenta';

  @override
  String get labelAccountName => 'Nombre de la cuenta';

  @override
  String get labelAccountIdentifier => 'Identificador (opcional)';

  @override
  String get accountAppearanceSection => 'Icono y color';

  @override
  String get accountPickIcon => 'Elegir icono';

  @override
  String get accountPickColor => 'Elegir color';

  @override
  String get accountIconSheetTitle => 'Icono de la cuenta';

  @override
  String get accountColorSheetTitle => 'Color de la cuenta';

  @override
  String get accountUseInitialLetter => 'Inicial';

  @override
  String get accountUseDefaultColor => 'Igualar grupo';

  @override
  String get labelRealBalance => 'Saldo real';

  @override
  String get labelOverdraftLimit => 'Límite de descubierto / anticipo';

  @override
  String get labelCurrency => 'Divisa';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get addAccountAction => 'Añadir cuenta';

  @override
  String get removeAccountSheetTitle => 'Eliminar cuenta';

  @override
  String get deletePermanently => 'Eliminar permanentemente';

  @override
  String get deletePermanentlySubtitle =>
      'Solo posible cuando esta cuenta no se usa en el Historial. Los elementos planificados pueden eliminarse como parte del proceso.';

  @override
  String get archiveOptionSubtitle =>
      'Ocultar de Análisis y selectores. Restaurar en cualquier momento desde Ajustes. Requiere saldo y descubierto a cero.';

  @override
  String get archivedBannerText =>
      'Esta cuenta está archivada. Permanece en tus datos pero está oculta de listas y selectores.';

  @override
  String get balanceAdjustedTitle => 'Saldo ajustado en Historial';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'El saldo real se actualizó de $previous a $current $symbol.\n\nSe creó una transacción de ajuste de saldo en el Historial para mantener la coherencia del libro mayor.\n\n• El saldo real refleja el importe real en esta cuenta.\n• Consulta el Historial para ver el asiento de ajuste.';
  }

  @override
  String get ok => 'Aceptar';

  @override
  String get categoryBalanceAdjustment => 'Ajuste de saldo';

  @override
  String get descriptionBalanceCorrection => 'Corrección de saldo';

  @override
  String get descriptionOpeningBalance => 'Saldo inicial';

  @override
  String get reviewStatsModeStatistics => 'Estadísticas';

  @override
  String get reviewStatsModeComparison => 'Comparación';

  @override
  String get statsUncategorized => 'Sin categoría';

  @override
  String get statsNoCategories =>
      'No hay categorías en los períodos seleccionados para comparar.';

  @override
  String get statsNoTransactions => 'No hay transacciones';

  @override
  String get statsSpendingInCategory => 'Gasto en esta categoría';

  @override
  String get statsIncomeInCategory => 'Ingreso en esta categoría';

  @override
  String get statsDifference => 'Diferencia (B vs A): ';

  @override
  String get statsNoExpensesMonth => 'No hay gastos este mes';

  @override
  String get statsNoExpensesAll => 'No hay gastos registrados';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'No hay gastos en los últimos $period';
  }

  @override
  String get statsTotalSpent => 'Total gastado';

  @override
  String get statsNoExpensesThisPeriod => 'No hay gastos en este período';

  @override
  String get statsNoIncomeMonth => 'No hay ingresos este mes';

  @override
  String get statsNoIncomeAll => 'No hay ingresos registrados';

  @override
  String statsNoIncomePeriod(String period) {
    return 'No hay ingresos en los últimos $period';
  }

  @override
  String get statsTotalReceived => 'Total recibido';

  @override
  String get statsNoIncomeThisPeriod => 'No hay ingresos en este período';

  @override
  String get catSalary => 'Salario';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catConsulting => 'Consultoría';

  @override
  String get catGift => 'Regalo';

  @override
  String get catRental => 'Alquiler';

  @override
  String get catDividends => 'Dividendos';

  @override
  String get catRefund => 'Reembolso';

  @override
  String get catBonus => 'Bono';

  @override
  String get catInterest => 'Intereses';

  @override
  String get catSideHustle => 'Ingresos extra';

  @override
  String get catSaleOfGoods => 'Venta de bienes';

  @override
  String get catOther => 'Otros';

  @override
  String get catGroceries => 'Supermercado';

  @override
  String get catDining => 'Restaurantes';

  @override
  String get catTransport => 'Transporte';

  @override
  String get catUtilities => 'Suministros';

  @override
  String get catHousing => 'Vivienda';

  @override
  String get catHealthcare => 'Salud';

  @override
  String get catEntertainment => 'Ocio';

  @override
  String get catShopping => 'Compras';

  @override
  String get catTravel => 'Viajes';

  @override
  String get catEducation => 'Educación';

  @override
  String get catSubscriptions => 'Suscripciones';

  @override
  String get catInsurance => 'Seguros';

  @override
  String get catFuel => 'Combustible';

  @override
  String get catGym => 'Gimnasio';

  @override
  String get catPets => 'Mascotas';

  @override
  String get catKids => 'Hijos';

  @override
  String get catCharity => 'Donaciones';

  @override
  String get catCoffee => 'Café';

  @override
  String get catGifts => 'Regalos';

  @override
  String semanticsProjectionDate(String date) {
    return 'Fecha de proyección $date. Doble toque para elegir fecha';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Saldo personal proyectado $amount';
  }

  @override
  String get statsEmptyTitle => 'Aún no hay transacciones';

  @override
  String get statsEmptySubtitle =>
      'No hay datos de gasto para el rango seleccionado.';

  @override
  String get semanticsShowProjections =>
      'Mostrar saldos proyectados por cuenta';

  @override
  String get semanticsHideProjections =>
      'Ocultar saldos proyectados por cuenta';

  @override
  String get semanticsDateAllTime =>
      'Fecha: todo el tiempo — toca para cambiar modo';

  @override
  String semanticsDateMode(String mode) {
    return 'Fecha: $mode — toca para cambiar modo';
  }

  @override
  String get semanticsDateThisMonth =>
      'Fecha: este mes — toca para mes, semana, año o todo el tiempo';

  @override
  String get semanticsTxTypeCycle =>
      'Tipo de transacción: ciclar todo, ingreso, gasto, transferencia';

  @override
  String get semanticsAccountFilter => 'Filtro de cuenta';

  @override
  String get semanticsAlreadyFiltered => 'Ya filtrado a esta cuenta';

  @override
  String get semanticsCategoryFilter => 'Filtro de categoría';

  @override
  String get semanticsSortToggle =>
      'Orden: alternar más reciente o más antiguo primero';

  @override
  String get semanticsFiltersDisabled =>
      'Filtros de lista desactivados mientras se ve una fecha de proyección futura. Borra las proyecciones para usar los filtros.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Filtros de lista desactivados. Añade primero una cuenta.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Filtros de lista desactivados. Añade primero una transacción planificada.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Filtros de lista desactivados. Registra primero una transacción.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Controles de sección y divisa desactivados. Añade primero una cuenta.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Fecha de proyección y desglose de saldo desactivados. Añade primero una cuenta y una transacción planificada.';

  @override
  String get semanticsReorderAccountHint =>
      'Mantén pulsado y arrastra para reordenar dentro de este grupo';

  @override
  String get semanticsChartStyle => 'Estilo de gráfico';

  @override
  String get semanticsChartStyleUnavailable =>
      'Estilo de gráfico (no disponible en modo comparación)';

  @override
  String semanticsPeriod(String label) {
    return 'Período: $label';
  }

  @override
  String get trackSearchHint => 'Buscar descripción, categoría, cuenta…';

  @override
  String get trackSearchClear => 'Limpiar búsqueda';

  @override
  String get settingsExchangeRatesTitle => 'Tipos de cambio';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Última actualización: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Usando tasas sin conexión o incluidas — toca para actualizar';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack =>
      'Tipos de cambio actualizados';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'No se pudieron actualizar los tipos de cambio. Comprueba tu conexión.';

  @override
  String get settingsClearData => 'Borrar datos';

  @override
  String get settingsClearDataSubtitle =>
      'Eliminar permanentemente los datos seleccionados';

  @override
  String get clearDataTitle => 'Borrar datos';

  @override
  String get clearDataTransactions => 'Historial de transacciones';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transacciones · saldos de cuenta restablecidos a cero';
  }

  @override
  String get clearDataPlanned => 'Transacciones planificadas';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count elementos planificados';
  }

  @override
  String get clearDataAccounts => 'Cuentas';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count cuentas · también borra el historial y el plan';
  }

  @override
  String get clearDataCategories => 'Categorías';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count categorías · sustituidas por las predeterminadas';
  }

  @override
  String get clearDataPreferences => 'Preferencias';

  @override
  String get clearDataPreferencesSubtitle =>
      'Restablecer divisa, tema e idioma a los valores predeterminados';

  @override
  String get clearDataSecurity => 'Bloqueo de app y PIN';

  @override
  String get clearDataSecuritySubtitle =>
      'Desactivar bloqueo de app y eliminar PIN';

  @override
  String get clearDataConfirmButton => 'Borrar seleccionados';

  @override
  String get clearDataConfirmTitle => 'Esta acción no se puede deshacer';

  @override
  String get clearDataConfirmBody =>
      'Los datos seleccionados se eliminarán permanentemente. Exporta una copia de seguridad primero si puedes necesitarlos más adelante.';

  @override
  String get clearDataTypeConfirm => 'Escribe DELETE para confirmar';

  @override
  String get clearDataTypeConfirmError =>
      'Escribe DELETE exactamente para continuar';

  @override
  String get clearDataPinTitle => 'Confirmar con PIN';

  @override
  String get clearDataPinBody =>
      'Introduce tu PIN de la app para autorizar esta acción.';

  @override
  String get clearDataPinIncorrect => 'PIN incorrecto';

  @override
  String get clearDataDone => 'Datos seleccionados borrados';

  @override
  String get autoBackupTitle => 'Copia de seguridad automática diaria';

  @override
  String autoBackupLastAt(String date) {
    return 'Última copia de seguridad $date';
  }

  @override
  String get autoBackupNeverRun => 'Aún no hay copia de seguridad';

  @override
  String get autoBackupShareTitle => 'Guardar en la nube';

  @override
  String get autoBackupShareSubtitle =>
      'Subir la última copia de seguridad a iCloud Drive, Google Drive o cualquier app';

  @override
  String get autoBackupCloudReminder =>
      'Copia de seguridad automática lista — guárdala en la nube para protección fuera del dispositivo';

  @override
  String get autoBackupCloudReminderAction => 'Compartir';

  @override
  String get persistenceErrorReloaded =>
      'No se pudieron guardar los cambios. Los datos se recargaron desde el almacenamiento.';
}
