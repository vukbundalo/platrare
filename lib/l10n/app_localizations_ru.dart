// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Платраре';

  @override
  String get navPlan => 'План';

  @override
  String get navTrack => 'Отслеживать';

  @override
  String get navReview => 'Обзор';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get close => 'Закрывать';

  @override
  String get add => 'Добавлять';

  @override
  String get undo => 'Отменить';

  @override
  String get confirm => 'Подтверждать';

  @override
  String get restore => 'Восстановить';

  @override
  String get heroIn => 'В';

  @override
  String get heroOut => 'Вне';

  @override
  String get heroNet => 'Сеть';

  @override
  String get heroBalance => 'Баланс';

  @override
  String get realBalance => 'Реальный баланс';

  @override
  String get heroResetButton => 'Перезагрузить';

  @override
  String get fabScrollToTop => 'Наверх';

  @override
  String get filterAll => 'Все';

  @override
  String get filterAllAccounts => 'Все аккаунты';

  @override
  String get filterAllCategories => 'Все категории';

  @override
  String get txLabelIncome => 'ДОХОД';

  @override
  String get txLabelExpense => 'РАСХОД';

  @override
  String get txLabelInvoice => 'СЧЕТ';

  @override
  String get txLabelBill => 'СЧЕТ';

  @override
  String get txLabelAdvance => 'ПРОДВИГАТЬ';

  @override
  String get txLabelSettlement => 'УРЕГУЛИРОВАНИЕ';

  @override
  String get txLabelLoan => 'ЗАЕМ';

  @override
  String get txLabelCollection => 'КОЛЛЕКЦИЯ';

  @override
  String get txLabelOffset => 'КОМПЕНСИРОВАТЬ';

  @override
  String get txLabelTransfer => 'ПЕРЕДАЧА';

  @override
  String get txLabelTransaction => 'СДЕЛКА';

  @override
  String get repeatNone => 'Нет повтора';

  @override
  String get repeatDaily => 'Ежедневно';

  @override
  String get repeatWeekly => 'Еженедельно';

  @override
  String get repeatMonthly => 'Ежемесячно';

  @override
  String get repeatYearly => 'Ежегодно';

  @override
  String get repeatEveryLabel => 'Каждый';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      one: 'день',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count недели',
      one: 'неделя',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count месяца',
      one: 'месяц',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count года',
      one: 'год',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Заканчивается';

  @override
  String get repeatEndNever => 'Никогда';

  @override
  String get repeatEndOnDate => 'Дата';

  @override
  String repeatEndAfterCount(int count) {
    return 'Через $count раз';
  }

  @override
  String get repeatEndPickDate => 'Выберите дату окончания';

  @override
  String get repeatEndTimes => 'раз';

  @override
  String repeatSummaryEvery(int count, String unit) {
    return 'Каждые $count $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'до $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count раз';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining из $total осталось';
  }

  @override
  String get detailRepeatEvery => 'Повторяйте каждые';

  @override
  String get detailEnds => 'Заканчивается';

  @override
  String get detailEndsNever => 'Никогда';

  @override
  String detailEndsOnDate(String date) {
    return 'На $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Через $count раз';
  }

  @override
  String get detailProgress => 'Прогресс';

  @override
  String get weekendNoChange => 'Без изменений';

  @override
  String get weekendFriday => 'Перенесемся на пятницу';

  @override
  String get weekendMonday => 'Перенести на понедельник';

  @override
  String weekendQuestion(String day) {
    return 'Если $day выпадает на выходные?';
  }

  @override
  String get dateToday => 'Сегодня';

  @override
  String get dateTomorrow => 'Завтра';

  @override
  String get dateYesterday => 'Вчера';

  @override
  String get statsAllTime => 'Все время';

  @override
  String get accountGroupPersonal => 'Персональный';

  @override
  String get accountGroupIndividual => 'Индивидуальный';

  @override
  String get accountGroupEntity => 'Сущность';

  @override
  String get accountSectionIndividuals => 'Частные лица';

  @override
  String get accountSectionEntities => 'Сущности';

  @override
  String get emptyNoTransactionsYet => 'Транзакций пока нет';

  @override
  String get emptyNoAccountsYet => 'Аккаунтов пока нет';

  @override
  String get emptyRecordFirstTransaction =>
      'Нажмите кнопку ниже, чтобы записать свою первую транзакцию.';

  @override
  String get emptyAddFirstAccountTx =>
      'Добавьте свою первую учетную запись перед записью транзакций.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Добавьте свою первую учетную запись, прежде чем планировать транзакции.';

  @override
  String get emptyAddFirstAccountReview =>
      'Добавьте свою первую учетную запись, чтобы начать отслеживать свои финансы.';

  @override
  String get emptyAddTransaction => 'Добавить транзакцию';

  @override
  String get emptyAddAccount => 'Добавить аккаунт';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Пока нет личных аккаунтов';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Личные счета — это ваши собственные кошельки и банковские счета. Добавьте один, чтобы отслеживать ежедневные доходы и расходы.';

  @override
  String get reviewEmptyGroupIndividualsTitle =>
      'Индивидуальных аккаунтов пока нет.';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Индивидуальные счета отслеживают деньги конкретных людей — общие затраты, кредиты или долговые расписки. Добавьте учетную запись для каждого человека, с которым вы рассчитываетесь.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Счетов юридических лиц пока нет';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Счета сущностей предназначены для предприятий, проектов или организаций. Используйте их, чтобы отделить коммерческие денежные потоки от ваших личных финансов.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Нет транзакций для примененных фильтров';

  @override
  String get emptyNoTransactionsInHistory => 'Нет транзакций в истории';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Нет транзакций для $month';
  }

  @override
  String get emptyNoTransactionsForAccount => 'Для этого счета нет транзакций';

  @override
  String get trackTransactionDeleted => 'Транзакция удалена';

  @override
  String get trackDeleteTitle => 'Удалить транзакцию?';

  @override
  String get trackDeleteBody => 'Это отменит изменения баланса счета.';

  @override
  String get trackTransaction => 'Сделка';

  @override
  String get planConfirmTitle => 'Подтвердить транзакцию?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Это событие запланировано на $date. Оно будет записано в истории с сегодняшней датой ($todayDate). Следующее событие остается на $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Это применит транзакцию к остаткам вашего реального счета и переместит ее в историю.';

  @override
  String get planTransactionConfirmed => 'Транзакция подтверждена и применена';

  @override
  String get planTransactionRemoved => 'Запланированная транзакция удалена.';

  @override
  String get planRepeatingTitle => 'Повторяющаяся транзакция';

  @override
  String get planRepeatingBody =>
      'Пропустите только эту дату — серия продолжится со следующего события — или удалите все оставшиеся события из своего плана.';

  @override
  String get planDeleteAll => 'Удалить все';

  @override
  String get planSkipThisOnly => 'Пропустить только это';

  @override
  String get planOccurrenceSkipped =>
      'Это событие пропущено — следующее запланировано';

  @override
  String get planNothingPlanned => 'На данный момент ничего не запланировано';

  @override
  String get planPlanBody => 'Планируйте предстоящие транзакции.';

  @override
  String get planAddPlan => 'Добавить план';

  @override
  String get planNoPlannedForFilters =>
      'Нет запланированных транзакций для примененных фильтров';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Нет запланированных транзакций в $month';
  }

  @override
  String get planOverdue => 'просроченный';

  @override
  String get planPlannedTransaction => 'Планируемая транзакция';

  @override
  String get discardTitle => 'Отменить изменения?';

  @override
  String get discardBody =>
      'У вас есть несохраненные изменения. Они потеряются, если вы уйдете сейчас.';

  @override
  String get keepEditing => 'Продолжайте редактировать';

  @override
  String get discard => 'Отменить';

  @override
  String get newTransactionTitle => 'Новая транзакция';

  @override
  String get editTransactionTitle => 'Редактировать транзакцию';

  @override
  String get transactionUpdated => 'Транзакция обновлена';

  @override
  String get sectionAccounts => 'Счета';

  @override
  String get labelFrom => 'От';

  @override
  String get labelTo => 'К';

  @override
  String get sectionCategory => 'Категория';

  @override
  String get sectionAttachments => 'Вложения';

  @override
  String get labelNote => 'Примечание';

  @override
  String get hintOptionalDescription => 'Дополнительное описание';

  @override
  String get updateTransaction => 'Обновить транзакцию';

  @override
  String get saveTransaction => 'Сохранить транзакцию';

  @override
  String get selectAccount => 'Выберите аккаунт';

  @override
  String get selectAccountTitle => 'Выберите учетную запись';

  @override
  String get noAccountsAvailable => 'Нет доступных аккаунтов';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Сумма, полученная $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Введите точную сумму, которую получает целевой счет. Это фиксирует используемый реальный обменный курс.';

  @override
  String get attachTakePhoto => 'Сфотографироваться';

  @override
  String get attachTakePhotoSub => 'Используйте камеру, чтобы запечатлеть чек';

  @override
  String get attachChooseGallery => 'Выбрать из галереи';

  @override
  String get attachChooseGallerySub =>
      'Выберите фотографии из своей библиотеки';

  @override
  String get attachBrowseFiles => 'Просмотр файлов';

  @override
  String get attachBrowseFilesSub =>
      'Прикрепляйте PDF-файлы, документы или другие файлы';

  @override
  String get attachButton => 'Прикреплять';

  @override
  String get editPlanTitle => 'Редактировать план';

  @override
  String get planTransactionTitle => 'Планировать транзакцию';

  @override
  String get tapToSelect => 'Нажмите, чтобы выбрать';

  @override
  String get updatePlan => 'Обновить план';

  @override
  String get addToPlan => 'Добавить в план';

  @override
  String get labelRepeat => 'Повторить';

  @override
  String get selectPlannedDate => 'Выберите запланированную дату';

  @override
  String get balancesAsOfToday => 'Остатки на сегодняшний день';

  @override
  String get projectedBalancesForTomorrow => 'Прогнозируемые остатки на завтра';

  @override
  String projectedBalancesForDate(String date) {
    return 'Прогнозируемые остатки для $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name получает ($currency)';
  }

  @override
  String get destHelper =>
      'Ориентировочная сумма назначения. Точная ставка фиксируется при подтверждении.';

  @override
  String get descriptionOptional => 'Описание (необязательно)';

  @override
  String get detailTransactionTitle => 'Сделка';

  @override
  String get detailPlannedTitle => 'Планируется';

  @override
  String get detailConfirmTransaction => 'Подтвердить транзакцию';

  @override
  String get detailDate => 'Дата';

  @override
  String get detailFrom => 'От';

  @override
  String get detailTo => 'К';

  @override
  String get detailCategory => 'Категория';

  @override
  String get detailNote => 'Примечание';

  @override
  String get detailDestinationAmount => 'Сумма назначения';

  @override
  String get detailExchangeRate => 'Обменный курс';

  @override
  String get detailRepeats => 'Повторы';

  @override
  String get detailDayOfMonth => 'День месяца';

  @override
  String get detailWeekends => 'Выходные';

  @override
  String get detailAttachments => 'Вложения';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count файла',
      one: '1 файл',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionDisplay => 'Отображать';

  @override
  String get settingsSectionLanguage => 'Язык';

  @override
  String get settingsSectionCategories => 'Категории';

  @override
  String get settingsSectionAccounts => 'Счета';

  @override
  String get settingsSectionPreferences => 'Предпочтения';

  @override
  String get settingsSectionManage => 'Управлять';

  @override
  String get settingsBaseCurrency => 'Домашняя валюта';

  @override
  String get settingsSecondaryCurrency => 'Вторичная валюта';

  @override
  String get settingsCategories => 'Категории';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount доход · $expenseCount расход';
  }

  @override
  String get settingsArchivedAccounts => 'Архивированные аккаунты';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Сейчас нет — архив из редактирования аккаунта, когда баланс чист';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count скрыт от просмотра и сборщиков';
  }

  @override
  String get settingsSectionData => 'Данные';

  @override
  String get settingsSectionPrivacy => 'О';

  @override
  String get settingsPrivacyPolicyTitle => 'Политика конфиденциальности';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Как Platrare обрабатывает ваши данные.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Курсы валют: приложение считывает общедоступные курсы валют через Интернет. Ваши счета и транзакции никогда не отправляются.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Не удалось загрузить политику конфиденциальности.';

  @override
  String get settingsPrivacyRetry => 'Попробуйте еще раз';

  @override
  String get settingsSoftwareVersionTitle => 'Версия программного обеспечения';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Выпуск, диагностика и юридическая информация';

  @override
  String get aboutScreenTitle => 'О';

  @override
  String get aboutAppTagline =>
      'Книга учета, движение денежных средств и планирование в одном рабочем пространстве.';

  @override
  String get aboutDescriptionBody =>
      'Platrare хранит счета, транзакции и планы на вашем устройстве. Экспортируйте зашифрованные резервные копии, когда вам понадобится копия в другом месте. В обменных курсах используются только данные публичного рынка; ваш реестр не загружен.';

  @override
  String get aboutVersionLabel => 'Версия';

  @override
  String get aboutBuildLabel => 'Строить';

  @override
  String get aboutCopySupportDetails => 'Скопировать сведения о поддержке';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Открывает полный документ политики в приложении.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Языковой стандарт';

  @override
  String get settingsSupportInfoCopied => 'Скопировано в буфер обмена';

  @override
  String get settingsVerifyLedger => 'Проверьте данные';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Убедитесь, что остатки на счетах соответствуют вашей истории транзакций.';

  @override
  String get settingsDataExportTitle => 'Экспортировать резервную копию';

  @override
  String get settingsDataExportSubtitle =>
      'Сохраните в формате .zip или зашифрованном .platrare со всеми данными и вложениями.';

  @override
  String get settingsDataImportTitle => 'Восстановление из резервной копии';

  @override
  String get settingsDataImportSubtitle =>
      'Замените текущие данные из резервной копии Platrare .zip или .platrare.';

  @override
  String get backupExportDialogTitle => 'Защитите эту резервную копию';

  @override
  String get backupExportDialogBody =>
      'Рекомендуется использовать надежный пароль, особенно если вы храните файл в облаке. Для импорта вам понадобится тот же пароль.';

  @override
  String get backupExportPasswordLabel => 'Пароль';

  @override
  String get backupExportPasswordConfirmLabel => 'Подтвердите пароль';

  @override
  String get backupExportPasswordMismatch => 'Пароли не совпадают';

  @override
  String get backupExportPasswordEmpty =>
      'Введите соответствующий пароль или экспортируйте данные без шифрования ниже.';

  @override
  String get backupExportPasswordTooShort =>
      'Пароль должен быть не менее 8 символов.';

  @override
  String get backupExportSaveToDevice => 'Сохранить на устройство';

  @override
  String get backupExportShareToCloud => 'Поделиться (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Экспорт без шифрования';

  @override
  String get backupExportSkipWarningTitle => 'Экспортировать без шифрования?';

  @override
  String get backupExportSkipWarningBody =>
      'Любой, у кого есть доступ к файлу, может прочитать ваши данные. Используйте это только для локальных копий, которыми вы управляете.';

  @override
  String get backupExportSkipWarningConfirm =>
      'Экспортировать в незашифрованном виде';

  @override
  String get backupImportPasswordTitle => 'Зашифрованное резервное копирование';

  @override
  String get backupImportPasswordBody =>
      'Введите пароль, который вы использовали при экспорте.';

  @override
  String get backupImportPasswordLabel => 'Пароль';

  @override
  String get backupImportPreviewTitle => 'Сводка резервного копирования';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Версия приложения: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Экспортировано: $date';
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
    return '$accounts счета · $transactions транзакции · $planned запланированные · $attachments вложенные файлы · $income категории доходов · $expense категории расходов';
  }

  @override
  String get backupImportPreviewContinue => 'Продолжать';

  @override
  String get settingsBackupWrongPassword => 'Неправильный пароль';

  @override
  String get settingsBackupChecksumMismatch =>
      'Не удалось проверить целостность резервной копии';

  @override
  String get settingsBackupCorruptFile =>
      'Неверный или поврежденный файл резервной копии';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Для резервного копирования требуется более новая версия приложения.';

  @override
  String get settingsDataImportConfirmTitle => 'Заменить текущие данные?';

  @override
  String get settingsDataImportConfirmBody =>
      'Ваши текущие счета, транзакции, запланированные транзакции, категории и импортированные вложения будут заменены содержимым выбранной резервной копии. Это действие невозможно отменить.';

  @override
  String get settingsDataImportConfirmAction => 'Заменить данные';

  @override
  String get settingsDataImportDone => 'Данные успешно восстановлены';

  @override
  String get settingsDataImportInvalidFile =>
      'Этот файл не является действительной резервной копией Platrare.';

  @override
  String get settingsDataImportFailed => 'Импорт не удался';

  @override
  String get settingsDataExportDoneTitle => 'Резервная копия экспортирована.';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Резервная копия сохранена в:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Открыть файл';

  @override
  String get settingsDataExportFailed => 'Экспорт не удался';

  @override
  String get ledgerVerifyDialogTitle => 'Проверка бухгалтерской книги';

  @override
  String get ledgerVerifyAllMatch => 'Все аккаунты совпадают.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Несоответствия';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nСохранено: $stored\nПовтор: $replayed\nРазница: $diff';
  }

  @override
  String get settingsLanguage => 'Язык приложения';

  @override
  String get settingsLanguageSubtitleSystem => 'Следующие настройки системы';

  @override
  String get settingsLanguageSubtitleEnglish => 'Английский';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Сербский (латиница)';

  @override
  String get settingsLanguagePickerTitle => 'Язык приложения';

  @override
  String get settingsLanguageOptionSystem => 'Система по умолчанию';

  @override
  String get settingsLanguageOptionEnglish => 'Английский';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Сербский (латиница)';

  @override
  String get settingsSectionAppearance => 'Появление';

  @override
  String get settingsSectionSecurity => 'Безопасность';

  @override
  String get settingsSecurityEnableLock =>
      'Блокировать приложение при открытии';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Требовать биометрическую разблокировку или PIN-код при открытии приложения';

  @override
  String get settingsSecuritySetPin => 'Установить PIN-код';

  @override
  String get settingsSecurityChangePin => 'Изменить ПИН-код';

  @override
  String get settingsSecurityPinSubtitle =>
      'Используйте PIN-код в качестве запасного варианта, если биометрические данные недоступны.';

  @override
  String get settingsSecurityRemovePin => 'Удалить PIN-код';

  @override
  String get securitySetPinTitle => 'Установить PIN-код приложения';

  @override
  String get securityPinLabel => 'ПИН-код';

  @override
  String get securityConfirmPinLabel => 'Подтвердите PIN-код';

  @override
  String get securityPinMustBe4Digits =>
      'PIN-код должен содержать не менее 4 цифр.';

  @override
  String get securityPinMismatch => 'ПИН-коды не совпадают';

  @override
  String get securityRemovePinTitle => 'Удалить PIN-код?';

  @override
  String get securityRemovePinBody =>
      'Биометрическую разблокировку по-прежнему можно использовать, если она доступна.';

  @override
  String get securityUnlockTitle => 'Приложение заблокировано';

  @override
  String get securityUnlockSubtitle =>
      'Разблокируйте с помощью Face ID, отпечатка пальца или PIN-кода.';

  @override
  String get securityUnlockWithPin => 'Разблокировать с помощью PIN-кода';

  @override
  String get securityTryBiometric => 'Попробуйте биометрическую разблокировку';

  @override
  String get securityPinIncorrect => 'Неверный PIN-код, попробуйте еще раз.';

  @override
  String get securityBiometricReason =>
      'Пройдите аутентификацию, чтобы открыть приложение';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeSubtitleSystem => 'Следующие настройки системы';

  @override
  String get settingsThemeSubtitleLight => 'Свет';

  @override
  String get settingsThemeSubtitleDark => 'Темный';

  @override
  String get settingsThemePickerTitle => 'Тема';

  @override
  String get settingsThemeOptionSystem => 'Система по умолчанию';

  @override
  String get settingsThemeOptionLight => 'Свет';

  @override
  String get settingsThemeOptionDark => 'Темный';

  @override
  String get archivedAccountsTitle => 'Архивированные аккаунты';

  @override
  String get archivedAccountsEmptyTitle => 'Нет заархивированных аккаунтов';

  @override
  String get archivedAccountsEmptyBody =>
      'Баланс книги и овердрафт должны быть равны нулю. Архив из параметров аккаунта в Обзоре.';

  @override
  String get categoriesTitle => 'Категории';

  @override
  String get newCategoryTitle => 'Новая категория';

  @override
  String get categoryNameLabel => 'Название категории';

  @override
  String get deleteCategoryTitle => 'Удалить категорию?';

  @override
  String deleteCategoryBody(String category) {
    return '«$category» будет удален из списка.';
  }

  @override
  String get categoryIncome => 'Доход';

  @override
  String get categoryExpense => 'Расход';

  @override
  String get categoryAdd => 'Добавлять';

  @override
  String get searchCurrencies => 'Поиск валют…';

  @override
  String get period1M => '1М';

  @override
  String get period3M => '3М';

  @override
  String get period6M => '6М';

  @override
  String get period1Y => '1 год';

  @override
  String get periodAll => 'ВСЕ';

  @override
  String get categoryLabel => 'категория';

  @override
  String get categoriesLabel => 'категории';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type сохранено • $amount';
  }

  @override
  String get tooltipSettings => 'Настройки';

  @override
  String get tooltipAddAccount => 'Добавить аккаунт';

  @override
  String get tooltipRemoveAccount => 'Удалить аккаунт';

  @override
  String get accountNameTaken =>
      'У вас уже есть аккаунт с таким именем и идентификатором (активный или заархивированный). Измените имя или идентификатор.';

  @override
  String get groupDescPersonal =>
      'Ваши собственные кошельки и банковские счета';

  @override
  String get groupDescIndividuals => 'Семья, друзья, отдельные лица';

  @override
  String get groupDescEntities =>
      'Субъекты, коммунальные предприятия, организации';

  @override
  String get cannotArchiveTitle => 'Пока не могу заархивировать';

  @override
  String get cannotArchiveBody =>
      'Архив доступен только в том случае, если баланс книги и лимит овердрафта фактически равны нулю.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Архив доступен только в том случае, если баланс книги и лимит овердрафта фактически равны нулю. Сначала настройте бухгалтерскую книгу или объект.';

  @override
  String get archiveAccountTitle => 'Архив аккаунта?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запланированных операций ссылаются на этот счёт.',
      one: '1 запланированная операция ссылается на этот счёт.',
    );
    return '$_temp0 Удалите их, чтобы план соответствовал архивному счёту.';
  }

  @override
  String get removeAndArchive => 'Удалить запланированное и заархивировать';

  @override
  String get archiveBody =>
      'Учетная запись будет скрыта от средств выбора «Просмотр», «Отслеживание» и «План». Вы можете восстановить его из настроек.';

  @override
  String get archiveAction => 'Архив';

  @override
  String get archiveInstead => 'Вместо этого архивируйте';

  @override
  String get cannotDeleteTitle => 'Не могу удалить аккаунт';

  @override
  String get cannotDeleteBodyShort =>
      'Эта учетная запись появится в вашей истории треков. Сначала удалите или переназначьте эти транзакции или заархивируйте учетную запись, если баланс очищен.';

  @override
  String get cannotDeleteBodyHistory =>
      'Эта учетная запись появится в вашей истории треков. Удаление нарушит эту историю — сначала удалите или переназначьте эти транзакции.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Эта учетная запись отображается в вашей истории треков, поэтому ее нельзя удалить. Вместо этого вы можете заархивировать его, если баланс книги и овердрафт очищены — он будет скрыт из списков, но история останется нетронутой.';

  @override
  String get deleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountBodyPermanent =>
      'Эта учетная запись будет удалена навсегда.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count запланированных операций ссылаются на этот счёт и также будут удалены.',
      one:
          '1 запланированная операция ссылается на этот счёт и также будет удалена.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Удалить все';

  @override
  String get editAccountTitle => 'Редактировать аккаунт';

  @override
  String get newAccountTitle => 'Новая учетная запись';

  @override
  String get labelAccountName => 'Имя учетной записи';

  @override
  String get labelAccountIdentifier => 'Идентификатор (необязательно)';

  @override
  String get accountAppearanceSection => 'Значок и цвет';

  @override
  String get accountPickIcon => 'Выберите значок';

  @override
  String get accountPickColor => 'Выберите цвет';

  @override
  String get accountIconSheetTitle => 'Значок учетной записи';

  @override
  String get accountColorSheetTitle => 'Цвет аккаунта';

  @override
  String get accountUseInitialLetter => 'Начальная буква';

  @override
  String get accountUseDefaultColor => 'Группа совпадений';

  @override
  String get labelRealBalance => 'Реальный баланс';

  @override
  String get labelOverdraftLimit => 'Овердрафт/лимит аванса';

  @override
  String get labelCurrency => 'Валюта';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get addAccountAction => 'Добавить аккаунт';

  @override
  String get removeAccountSheetTitle => 'Удалить аккаунт';

  @override
  String get deletePermanently => 'Удалить навсегда';

  @override
  String get deletePermanentlySubtitle =>
      'Возможно только в том случае, если эта учетная запись не используется в Track. Запланированные элементы можно удалить в рамках удаления.';

  @override
  String get archiveOptionSubtitle =>
      'Скрыть от просмотра и сборщиков. Восстановление в любое время из настроек. Требуется нулевой баланс и овердрафт.';

  @override
  String get archivedBannerText =>
      'Этот аккаунт заархивирован. Он остается в ваших данных, но скрыт от списков и средств выбора.';

  @override
  String get balanceAdjustedTitle => 'Баланс скорректирован в Track';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Реальный баланс обновлен с $previous на $current $symbol.\n\nТранзакция корректировки баланса была создана в разделе «Отслеживание» (история), чтобы обеспечить согласованность бухгалтерской книги.\n\n• Реальный баланс отражает фактическую сумму на этом счете.\n• Проверьте историю на наличие записи о корректировке.';
  }

  @override
  String get ok => 'ХОРОШО';

  @override
  String get categoryBalanceAdjustment => 'Регулировка баланса';

  @override
  String get descriptionBalanceCorrection => 'Коррекция баланса';

  @override
  String get descriptionOpeningBalance => 'Начальный баланс';

  @override
  String get reviewStatsModeStatistics => 'Статистика';

  @override
  String get reviewStatsModeComparison => 'Сравнение';

  @override
  String get statsUncategorized => 'Без категории';

  @override
  String get statsNoCategories =>
      'Нет категорий в выбранных периодах для сравнения.';

  @override
  String get statsNoTransactions => 'Нет транзакций';

  @override
  String get statsSpendingInCategory => 'Расходы в этой категории';

  @override
  String get statsIncomeInCategory => 'Доход в этой категории';

  @override
  String get statsDifference => 'Разница (Б против А):';

  @override
  String get statsNoExpensesMonth => 'Никаких расходов в этом месяце';

  @override
  String get statsNoExpensesAll => 'Расходы не зафиксированы';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Никаких расходов за последний $period';
  }

  @override
  String get statsTotalSpent => 'Всего потрачено';

  @override
  String get statsNoExpensesThisPeriod => 'Никаких расходов в этот период';

  @override
  String get statsNoIncomeMonth => 'В этом месяце дохода нет';

  @override
  String get statsNoIncomeAll => 'Доход не зафиксирован';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Нет дохода за последний $period';
  }

  @override
  String get statsTotalReceived => 'Всего получено';

  @override
  String get statsNoIncomeThisPeriod => 'Нет дохода в этот период';

  @override
  String get catSalary => 'Зарплата';

  @override
  String get catFreelance => 'Внештатный';

  @override
  String get catConsulting => 'Консалтинг';

  @override
  String get catGift => 'Подарок';

  @override
  String get catRental => 'Аренда';

  @override
  String get catDividends => 'Дивиденды';

  @override
  String get catRefund => 'Возвращать деньги';

  @override
  String get catBonus => 'Бонус';

  @override
  String get catInterest => 'Интерес';

  @override
  String get catSideHustle => 'Подработка';

  @override
  String get catSaleOfGoods => 'Продажа товаров';

  @override
  String get catOther => 'Другой';

  @override
  String get catGroceries => 'Продукты питания';

  @override
  String get catDining => 'Столовая';

  @override
  String get catTransport => 'Транспорт';

  @override
  String get catUtilities => 'Утилиты';

  @override
  String get catHousing => 'Жилье';

  @override
  String get catHealthcare => 'Здравоохранение';

  @override
  String get catEntertainment => 'Развлечение';

  @override
  String get catShopping => 'Шоппинг';

  @override
  String get catTravel => 'Путешествовать';

  @override
  String get catEducation => 'Образование';

  @override
  String get catSubscriptions => 'Подписки';

  @override
  String get catInsurance => 'Страхование';

  @override
  String get catFuel => 'Топливо';

  @override
  String get catGym => 'Спортзал';

  @override
  String get catPets => 'Домашние животные';

  @override
  String get catKids => 'Дети';

  @override
  String get catCharity => 'Благотворительность';

  @override
  String get catCoffee => 'Кофе';

  @override
  String get catGifts => 'Подарки';

  @override
  String semanticsProjectionDate(String date) {
    return 'Дата прогноза $date. Нажмите дважды, чтобы выбрать дату';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Прогнозируемый личный баланс $amount';
  }

  @override
  String get statsEmptyTitle => 'Транзакций пока нет';

  @override
  String get statsEmptySubtitle =>
      'Нет данных о расходах для выбранного диапазона.';

  @override
  String get semanticsShowProjections =>
      'Показать прогнозируемые остатки по счетам';

  @override
  String get semanticsHideProjections =>
      'Скрыть прогнозируемые остатки по счетам';

  @override
  String get semanticsDateAllTime =>
      'Дата: все время — нажмите, чтобы изменить режим';

  @override
  String semanticsDateMode(String mode) {
    return 'Дата: $mode — нажмите, чтобы изменить режим.';
  }

  @override
  String get semanticsDateThisMonth =>
      'Дата: в этом месяце — нажмите, чтобы выбрать месяц, неделю, год или все время.';

  @override
  String get semanticsTxTypeCycle =>
      'Тип транзакции: цикл все, доход, расход, перевод';

  @override
  String get semanticsAccountFilter => 'Фильтр аккаунта';

  @override
  String get semanticsAlreadyFiltered => 'Уже отфильтровано для этого аккаунта';

  @override
  String get semanticsCategoryFilter => 'Фильтр категории';

  @override
  String get semanticsSortToggle =>
      'Сортировать: сначала переключать самые новые или самые старые';

  @override
  String get semanticsFiltersDisabled =>
      'Фильтры списка отключены при просмотре будущей даты прогноза. Очистите прогнозы, чтобы использовать фильтры.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Фильтры списка отключены. Сначала добавьте учетную запись.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Фильтры списка отключены. Сначала добавьте запланированную транзакцию.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Фильтры списка отключены. Сначала запишите транзакцию.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Раздел и валютный контроль отключены. Сначала добавьте учетную запись.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Дата прогноза и разбивка баланса отключены. Сначала добавьте учетную запись и запланированную транзакцию.';

  @override
  String get semanticsReorderAccountHint =>
      'Нажмите и удерживайте, затем перетащите, чтобы изменить порядок в этой группе.';

  @override
  String get semanticsChartStyle => 'Стиль диаграммы';

  @override
  String get semanticsChartStyleUnavailable =>
      'Стиль диаграммы (недоступен в режиме сравнения)';

  @override
  String semanticsPeriod(String label) {
    return 'Период: $label';
  }

  @override
  String get trackSearchHint => 'Поиск по описанию, категории, аккаунту…';

  @override
  String get trackSearchClear => 'Очистить поиск';

  @override
  String get settingsExchangeRatesTitle => 'Курсы валют';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Последнее обновление: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Использование офлайн-тарифов или пакетных тарифов — нажмите, чтобы обновить.';

  @override
  String get settingsExchangeRatesSource => 'ЕЦБ';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Курсы валют обновлены';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Не удалось обновить курсы валют. Проверьте свое соединение.';

  @override
  String get settingsClearData => 'Очистить данные';

  @override
  String get settingsClearDataSubtitle => 'Удалить выбранные данные навсегда';

  @override
  String get clearDataTitle => 'Очистить данные';

  @override
  String get clearDataTransactions => 'История транзакций';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count транзакции · балансы счетов обнуляются';
  }

  @override
  String get clearDataPlanned => 'Планируемые транзакции';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count запланированные элементы';
  }

  @override
  String get clearDataAccounts => 'Счета';

  @override
  String clearDataAccountsSubtitle(int count) {
    return 'Аккаунты $count · также очищает историю и план';
  }

  @override
  String get clearDataCategories => 'Категории';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return 'Категории $count · заменены значениями по умолчанию';
  }

  @override
  String get clearDataPreferences => 'Предпочтения';

  @override
  String get clearDataPreferencesSubtitle =>
      'Сбросить валюту, тему и язык к значениям по умолчанию.';

  @override
  String get clearDataSecurity => 'Блокировка приложения и PIN-код';

  @override
  String get clearDataSecuritySubtitle =>
      'Отключить блокировку приложения и удалить PIN-код';

  @override
  String get clearDataConfirmButton => 'Очистить выбранное';

  @override
  String get clearDataConfirmTitle => 'Это нельзя отменить';

  @override
  String get clearDataConfirmBody =>
      'Выбранные данные будут удалены без возможности восстановления. Сначала экспортируйте резервную копию, если она может понадобиться вам позже.';

  @override
  String get clearDataTypeConfirm => 'Введите DELETE для подтверждения.';

  @override
  String get clearDataTypeConfirmError => 'Введите DELETE, чтобы продолжить.';

  @override
  String get clearDataPinTitle => 'Подтвердите с помощью PIN-кода';

  @override
  String get clearDataPinBody =>
      'Введите PIN-код вашего приложения, чтобы авторизовать это действие.';

  @override
  String get clearDataPinIncorrect => 'Неправильный PIN-код';

  @override
  String get clearDataDone => 'Выбранные данные удалены';

  @override
  String get autoBackupTitle =>
      'Автоматическое ежедневное резервное копирование';

  @override
  String autoBackupLastAt(String date) {
    return 'Последняя резервная копия $date';
  }

  @override
  String get autoBackupNeverRun => 'Резервной копии пока нет';

  @override
  String get autoBackupShareTitle => 'Сохранить в облако';

  @override
  String get autoBackupShareSubtitle =>
      'Загрузите последнюю резервную копию на iCloud Drive, Google Drive или любое приложение.';

  @override
  String get autoBackupCloudReminder =>
      'Готово к автоматическому резервному копированию — сохраните его в облаке для защиты вне устройства.';

  @override
  String get autoBackupCloudReminderAction => 'Поделиться';

  @override
  String get persistenceErrorReloaded =>
      'Не удалось сохранить изменения. Данные были перезагружены из хранилища.';
}
