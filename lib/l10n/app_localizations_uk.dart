// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'План';

  @override
  String get navTrack => 'Історія';

  @override
  String get navReview => 'Огляд';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get close => 'Закрити';

  @override
  String get add => 'Додати';

  @override
  String get undo => 'Скасувати';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get restore => 'Відновити';

  @override
  String get heroIn => 'Доходи';

  @override
  String get heroOut => 'Витрати';

  @override
  String get heroNet => 'Нетто';

  @override
  String get widgetLowestPoint => 'Мінімум';

  @override
  String get widgetProjected => 'Прогноз';

  @override
  String get widgetHorizonIn7Days => 'Через 7 днів';

  @override
  String get widgetHorizonEndOfMonth => 'Кінець місяця';

  @override
  String get widgetMetricAccount => 'Баланс рахунку';

  @override
  String get widgetQuickAdd => 'Швидке додавання';

  @override
  String get widgetStale => 'Дані можуть бути застарілими';

  @override
  String get widgetOpenToStart => 'Відкрийте Platrare, щоб додати рахунки';

  @override
  String get widgetDueToday => 'Сьогодні';

  @override
  String get widgetDescQuickAdd => 'Додайте операцію або план одним дотиком.';

  @override
  String get widgetNameNumbers => 'Баланс';

  @override
  String get widgetDescNumbers =>
      'Покажіть одне число: доступно, чисті активи або мінімум цього місяця.';

  @override
  String get widgetConfigMetric => 'Показник';

  @override
  String get widgetConfigHorizon => 'Горизонт';

  @override
  String widgetSiriAddTransaction(String appName) {
    return 'Додати операцію в $appName';
  }

  @override
  String widgetSiriAddPlanned(String appName) {
    return 'Додати заплановану операцію в $appName';
  }

  @override
  String get settingsWidgetAmountsTitle => 'Показувати суми у віджетах';

  @override
  String get settingsWidgetAmountsSubtitle =>
      'Віджети на екрані «Дім» видно без розблокування застосунку. Коли блокування ввімкнено, суми приховані, якщо не ввімкнути цей параметр.';

  @override
  String get heroBalance => 'Баланс';

  @override
  String get realBalance => 'Реальний баланс';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Приховати баланси в підсумкових картках';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Коли увімкнено, суми в Плані, Відстеженні та Огляді залишаються прихованими, доки ви не торкнетеся значка ока на кожній вкладці. Коли вимкнено, баланси завжди видимі.';

  @override
  String get heroBalancesShow => 'Показати баланси';

  @override
  String get heroBalancesHide => 'Приховати баланси';

  @override
  String get semanticsHeroBalanceHidden =>
      'Баланс прихований для конфіденційності';

  @override
  String get heroResetButton => 'Скинути';

  @override
  String get fabScrollToTop => 'На початок';

  @override
  String get fabPickProjectionDate => 'Вибрати дату прогнозу';

  @override
  String get filterAll => 'Усі';

  @override
  String get filterAllAccounts => 'Усі рахунки';

  @override
  String get filterAllCategories => 'Усі категорії';

  @override
  String get txLabelIncome => 'ДОХІД';

  @override
  String get txLabelExpense => 'ВИТРАТА';

  @override
  String get txLabelInvoice => 'РАХУНОК-ФАКТУРА';

  @override
  String get txLabelBill => 'РАХУНОК';

  @override
  String get txLabelAdvance => 'АВАНС';

  @override
  String get txLabelSettlement => 'РОЗРАХУНОК';

  @override
  String get txLabelLoan => 'ПОЗИКА';

  @override
  String get txLabelCollection => 'СТЯГНЕННЯ';

  @override
  String get txLabelOffset => 'ЗАЛІК';

  @override
  String get txLabelTransfer => 'ПЕРЕКАЗ';

  @override
  String get txLabelTransaction => 'ТРАНЗАКЦІЯ';

  @override
  String get repeatNone => 'Без повторення';

  @override
  String get repeatDaily => 'Щодня';

  @override
  String get repeatWeekly => 'Щотижня';

  @override
  String get repeatMonthly => 'Щомісяця';

  @override
  String get repeatYearly => 'Щороку';

  @override
  String get repeatEveryLabel => 'Кожні';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дні',
      one: 'день',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тижні',
      one: 'тиждень',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count місяці',
      one: 'місяць',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count роки',
      one: 'рік',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Закінчується';

  @override
  String get repeatEndNever => 'Ніколи';

  @override
  String get repeatEndOnDate => 'На дату';

  @override
  String repeatEndAfterCount(int count) {
    return 'Після $count разів';
  }

  @override
  String get repeatEndAfterChoice => 'Після певної кількості разів';

  @override
  String get repeatEndPickDate => 'Вибрати дату завершення';

  @override
  String get repeatEndTimes => 'разів';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Кожні $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'до $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count разів';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining з $total залишилося';
  }

  @override
  String get detailRepeatEvery => 'Повторювати кожні';

  @override
  String get detailEnds => 'Закінчується';

  @override
  String get detailEndsNever => 'Ніколи';

  @override
  String detailEndsOnDate(String date) {
    return '$date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Після $count разів';
  }

  @override
  String get detailProgress => 'Прогрес';

  @override
  String get weekendNoChange => 'Без змін';

  @override
  String get weekendFriday => 'Перенести на п\'ятницю';

  @override
  String get weekendMonday => 'Перенести на понеділок';

  @override
  String weekendQuestion(String day) {
    return 'Якщо $day припадає на вихідний?';
  }

  @override
  String get dateToday => 'Сьогодні';

  @override
  String get dateTomorrow => 'Завтра';

  @override
  String get dateYesterday => 'Вчора';

  @override
  String get statsAllTime => 'За весь час';

  @override
  String get accountGroupPersonal => 'Особистий';

  @override
  String get accountGroupIndividual => 'Індивідуальний';

  @override
  String get accountGroupEntity => 'Організація';

  @override
  String get accountSectionIndividuals => 'Фізичні особи';

  @override
  String get accountSectionEntities => 'Організації';

  @override
  String get emptyNoTransactionsYet => 'Транзакцій ще немає';

  @override
  String get emptyNoAccountsYet => 'Рахунків ще немає';

  @override
  String get emptyRecordFirstTransaction =>
      'Натисніть кнопку нижче, щоб записати першу транзакцію.';

  @override
  String get emptyAddFirstAccountTx =>
      'Додайте перший рахунок перед записом транзакцій.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Додайте перший рахунок, перш ніж планувати транзакції.';

  @override
  String get emptyAddFirstAccountReview =>
      'Додайте перший рахунок, щоб почати відстежувати фінанси.';

  @override
  String get emptyAddTransaction => 'Додати транзакцію';

  @override
  String get emptyAddAccount => 'Додати рахунок';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Особистих рахунків ще немає';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Особисті рахунки — це ваші власні гаманці та банківські рахунки. Додайте один, щоб відстежувати щоденні доходи та витрати.';

  @override
  String get reviewEmptyGroupIndividualsTitle =>
      'Індивідуальних рахунків ще немає';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Індивідуальні рахунки відстежують гроші з конкретними людьми — спільні витрати, позики чи борги. Додайте рахунок для кожної людини, з якою ви розраховуєтесь.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Рахунків організацій ще немає';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Рахунки організацій призначені для підприємств, проєктів або установ. Використовуйте їх, щоб відокремити грошові потоки бізнесу від особистих фінансів.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Немає транзакцій для застосованих фільтрів';

  @override
  String get emptyNoTransactionsInHistory => 'В історії немає транзакцій';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Немає транзакцій за $month';
  }

  @override
  String get emptyNoTransactionsForAccount =>
      'Немає транзакцій для цього рахунку';

  @override
  String get trackTransactionDeleted => 'Транзакцію видалено';

  @override
  String get trackDeleteTitle => 'Видалити транзакцію?';

  @override
  String get trackDeleteBody => 'Це скасує зміни балансу рахунку.';

  @override
  String get trackTransaction => 'Транзакція';

  @override
  String get planConfirmTitle => 'Підтвердити транзакцію?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Ця подія заплановано на $date. Вона буде записана в Історію з датою сьогодні ($todayDate). Наступна подія залишається на $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Це застосує транзакцію до реальних балансів рахунків і перемістить її до Історії.';

  @override
  String get planTransactionConfirmed =>
      'Транзакцію підтверджено та застосовано';

  @override
  String get planTransactionRemoved => 'Заплановану транзакцію видалено';

  @override
  String get planRepeatingTitle => 'Повторювана транзакція';

  @override
  String get planRepeatingBody =>
      'Пропустіть лише цю дату — серія продовжується з наступною подією — або видаліть усі залишкові події з плану.';

  @override
  String get planDeleteAll => 'Видалити всі';

  @override
  String get planSkipThisOnly => 'Пропустити лише цю';

  @override
  String get planOccurrenceSkipped =>
      'Цю подію пропущено — наступна заплановано';

  @override
  String get planNothingPlanned => 'Нічого не заплановано';

  @override
  String get planPlanBody => 'Плануйте майбутні транзакції.';

  @override
  String get planAddPlan => 'Додати план';

  @override
  String get planNoPlannedForFilters =>
      'Немає запланованих транзакцій для застосованих фільтрів';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Немає запланованих транзакцій у $month';
  }

  @override
  String get planOverdue => 'прострочено';

  @override
  String get planPlannedTransaction => 'Запланована транзакція';

  @override
  String get discardTitle => 'Скасувати зміни?';

  @override
  String get discardBody =>
      'У вас є незбережені зміни. Вони будуть втрачені, якщо вийти зараз.';

  @override
  String get keepEditing => 'Продовжити редагування';

  @override
  String get discard => 'Скасувати';

  @override
  String get newTransactionTitle => 'Нова транзакція';

  @override
  String get editTransactionTitle => 'Редагувати транзакцію';

  @override
  String get transactionUpdated => 'Транзакцію оновлено';

  @override
  String get sectionAccounts => 'Рахунки';

  @override
  String get labelFrom => 'Від';

  @override
  String get labelTo => 'До';

  @override
  String get sectionCategory => 'Категорія';

  @override
  String get sectionAttachments => 'Вкладення';

  @override
  String get labelNote => 'Примітка';

  @override
  String get hintOptionalDescription => 'Необов\'язковий опис';

  @override
  String get updateTransaction => 'Оновити транзакцію';

  @override
  String get saveTransaction => 'Зберегти транзакцію';

  @override
  String get selectAccount => 'Вибрати рахунок';

  @override
  String get selectAccountTitle => 'Вибрати рахунок';

  @override
  String get noAccountsAvailable => 'Немає доступних рахунків';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Сума, отримана $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Введіть точну суму, яку отримує рахунок призначення. Це фіксує реальний використаний курс обміну.';

  @override
  String get attachTakePhoto => 'Сфотографувати';

  @override
  String get attachTakePhotoSub => 'Використати камеру для фото чека';

  @override
  String get attachChooseGallery => 'Вибрати з галереї';

  @override
  String get attachChooseGallerySub => 'Вибрати фото з бібліотеки';

  @override
  String get attachBrowseFiles => 'Переглянути файли';

  @override
  String get attachBrowseFilesSub => 'Прикріпити PDF, документи або інші файли';

  @override
  String get attachButton => 'Прикріпити';

  @override
  String get editPlanTitle => 'Редагувати план';

  @override
  String get planTransactionTitle => 'Запланувати транзакцію';

  @override
  String get tapToSelect => 'Торкніться для вибору';

  @override
  String get updatePlan => 'Оновити план';

  @override
  String get addToPlan => 'Додати до плану';

  @override
  String get labelRepeat => 'Повторення';

  @override
  String get selectPlannedDate => 'Вибрати заплановану дату';

  @override
  String get balancesAsOfToday => 'Баланси на сьогодні';

  @override
  String get projectedBalancesForTomorrow => 'Прогнозовані баланси на завтра';

  @override
  String projectedBalancesForDate(String date) {
    return 'Прогнозовані баланси на $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name отримує ($currency)';
  }

  @override
  String get destHelper =>
      'Орієнтовна сума призначення. Точний курс фіксується при підтвердженні.';

  @override
  String get descriptionOptional => 'Опис (необов\'язково)';

  @override
  String get detailTransactionTitle => 'Транзакція';

  @override
  String get detailPlannedTitle => 'Заплановано';

  @override
  String get detailConfirmTransaction => 'Підтвердити транзакцію';

  @override
  String get detailDate => 'Дата';

  @override
  String get detailFrom => 'Від';

  @override
  String get detailTo => 'До';

  @override
  String get detailCategory => 'Категорія';

  @override
  String get detailNote => 'Примітка';

  @override
  String get detailDestinationAmount => 'Сума призначення';

  @override
  String get detailExchangeRate => 'Курс обміну';

  @override
  String get detailRepeats => 'Повторення';

  @override
  String get detailDayOfMonth => 'День місяця';

  @override
  String get detailWeekends => 'Вихідні';

  @override
  String get detailAttachments => 'Вкладення';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count файли',
      one: '1 файл',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsSectionDisplay => 'Відображення';

  @override
  String get settingsSectionLanguage => 'Мова';

  @override
  String get settingsSectionCategories => 'Категорії';

  @override
  String get settingsSectionAccounts => 'Рахунки';

  @override
  String get settingsSectionPreferences => 'Параметри';

  @override
  String get settingsSectionManage => 'Керування';

  @override
  String get settingsBaseCurrency => 'Основна валюта';

  @override
  String get settingsSecondaryCurrency => 'Додаткова валюта';

  @override
  String get settingsCategories => 'Категорії';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount доходів · $expenseCount витрат';
  }

  @override
  String get settingsArchivedAccounts => 'Архівні рахунки';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Наразі немає — архівуйте з налаштувань рахунку, коли баланс нульовий';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count приховано з Огляду та списків вибору';
  }

  @override
  String get settingsSectionData => 'Дані';

  @override
  String get settingsSectionPrivacy => 'Про програму';

  @override
  String get settingsPrivacyPolicyTitle => 'Політика конфіденційності';

  @override
  String get settingsPrivacyPolicySubtitle => 'Як Platrare обробляє ваші дані.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Курси валют: програма отримує публічні курси з інтернету. Ваші рахунки та транзакції ніколи не передаються.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Не вдалося завантажити політику конфіденційності.';

  @override
  String get settingsPrivacyRetry => 'Спробувати ще';

  @override
  String get settingsSoftwareVersionTitle => 'Версія програми';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Випуск, діагностика та правова інформація';

  @override
  String get aboutScreenTitle => 'Про програму';

  @override
  String get aboutAppTagline =>
      'Бухгалтерська книга, грошовий потік і планування в одному просторі.';

  @override
  String get aboutDescriptionBody =>
      'Platrare зберігає рахунки, транзакції та плани на вашому пристрої. Експортуйте зашифровані резервні копії, коли потрібна копія деінде. Курси валют використовують лише публічні ринкові дані; ваша бухгалтерська книга не завантажується.';

  @override
  String get aboutVersionLabel => 'Версія';

  @override
  String get aboutBuildLabel => 'Збірка';

  @override
  String get aboutCopySupportDetails => 'Скопіювати дані підтримки';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Відкриває повний документ політики в програмі.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Мова системи';

  @override
  String get settingsSupportInfoCopied => 'Скопійовано до буфера обміну';

  @override
  String get settingsVerifyLedger => 'Перевірити дані';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Перевірити відповідність балансів рахунків та історії транзакцій';

  @override
  String get settingsDataExportTitle => 'Експортувати резервну копію';

  @override
  String get settingsDataExportSubtitle =>
      'Зберегти як .zip або зашифрований .platrare з усіма даними та вкладеннями';

  @override
  String get settingsDataImportTitle => 'Відновити з резервної копії';

  @override
  String get settingsDataImportSubtitle =>
      'Замінити поточні дані з резервної копії .zip або .platrare Platrare';

  @override
  String get backupExportDialogTitle => 'Захистити цю резервну копію';

  @override
  String get backupExportDialogBody =>
      'Рекомендується надійний пароль, особливо якщо файл зберігається в хмарі. Для імпорту знадобиться той самий пароль.';

  @override
  String get backupExportPasswordLabel => 'Пароль';

  @override
  String get backupExportPasswordConfirmLabel => 'Підтвердити пароль';

  @override
  String get backupExportPasswordMismatch => 'Паролі не збігаються';

  @override
  String get backupExportPasswordEmpty =>
      'Введіть відповідний пароль або експортуйте без шифрування нижче.';

  @override
  String get backupExportPasswordTooShort =>
      'Пароль має містити щонайменше 8 символів.';

  @override
  String get backupExportSaveToDevice => 'Зберегти на пристрій';

  @override
  String get backupExportShareToCloud => 'Поділитися (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Експортувати без шифрування';

  @override
  String get backupExportSkipWarningTitle => 'Експортувати без шифрування?';

  @override
  String get backupExportSkipWarningBody =>
      'Будь-хто, хто має доступ до файлу, зможе прочитати ваші дані. Використовуйте лише для локальних копій під вашим контролем.';

  @override
  String get backupExportSkipWarningConfirm => 'Експортувати без шифрування';

  @override
  String get backupImportPasswordTitle => 'Зашифрована резервна копія';

  @override
  String get backupImportPasswordBody =>
      'Введіть пароль, який використовувався під час експорту.';

  @override
  String get backupImportPasswordLabel => 'Пароль';

  @override
  String get backupImportPreviewTitle => 'Зведення резервної копії';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Версія програми: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Експортовано: $date';
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
    return '$accounts рахунків · $transactions транзакцій · $planned запланованих · $attachments вкладень · $income категорій доходів · $expense категорій витрат';
  }

  @override
  String get backupImportPreviewContinue => 'Продовжити';

  @override
  String get settingsBackupWrongPassword => 'Невірний пароль';

  @override
  String get settingsBackupChecksumMismatch =>
      'Резервна копія не пройшла перевірку цілісності';

  @override
  String get settingsBackupCorruptFile =>
      'Недійсний або пошкоджений файл резервної копії';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Для відновлення потрібна новіша версія програми';

  @override
  String get settingsDataImportConfirmTitle => 'Замінити поточні дані?';

  @override
  String get settingsDataImportConfirmBody =>
      'Це замінить ваші поточні рахунки, транзакції, заплановані транзакції, категорії та імпортовані вкладення вмістом обраної резервної копії. Цю дію не можна скасувати.';

  @override
  String get settingsDataImportConfirmAction => 'Замінити дані';

  @override
  String get settingsDataImportDone => 'Дані успішно відновлено';

  @override
  String get settingsDataImportInvalidFile =>
      'Цей файл не є дійсною резервною копією Platrare';

  @override
  String get settingsDataImportFailed => 'Помилка імпорту';

  @override
  String get settingsDataExportDoneTitle => 'Резервну копію експортовано';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Резервну копію збережено:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Відкрити файл';

  @override
  String get settingsDataExportFailed => 'Помилка експорту';

  @override
  String get settingsCsvExportTitle => 'Експорт у CSV';

  @override
  String get settingsCsvExportSubtitle => 'Ваші транзакції у вигляді таблиці';

  @override
  String get settingsCsvExportFailed => 'Не вдалося експортувати CSV';

  @override
  String get settingsCsvImportTitle => 'Імпорт із CSV';

  @override
  String get settingsCsvImportSubtitle =>
      'Додайте транзакції з таблиці — нічого не замінюється';

  @override
  String get settingsCsvTemplateTitle => 'Отримати шаблон CSV';

  @override
  String get settingsCsvTemplateSubtitle =>
      'Приклад файлу, куди можна вставити старі дані';

  @override
  String get csvTemplateInstruction1 =>
      'Замініть приклади рядків нижче своїми даними, а потім імпортуйте цей файл у налаштуваннях.';

  @override
  String get csvTemplateInstruction2 =>
      'Поля date і amount обов\'язкові. Дати пишіть як YYYY-MM-DD, суми — додатним числом.';

  @override
  String get csvTemplateInstruction3 =>
      'Поле type може бути income, expense, transfer, invoice, bill, advance, settlement, loan, collection або offset. Залиште порожнім, щоб застосунок визначив тип за рахунками.';

  @override
  String get csvTemplateInstruction4 =>
      'Рахунки та категорії, яких ще немає, створюються автоматично. Рядки, що починаються з #, ігноруються.';

  @override
  String get csvImportPreviewTitle => 'Імпорт транзакцій';

  @override
  String csvImportPreviewCounts(int importable, int total) {
    return 'Буде додано $importable рядків із $total';
  }

  @override
  String csvImportPreviewNewAccounts(String names) {
    return 'Нові рахунки: $names';
  }

  @override
  String csvImportPreviewNewCategories(String names) {
    return 'Нові категорії: $names';
  }

  @override
  String csvImportPreviewDuplicates(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count рядки вже існують',
      many: '$count рядків уже існують',
      few: '$count рядки вже існують',
      one: '$count рядок уже існує',
    );
    return '$_temp0';
  }

  @override
  String get csvImportPreviewSkipDuplicates => 'Пропускати рядки, які вже є';

  @override
  String csvImportPreviewIssuesTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не вдалося прочитати $count рядки',
      many: 'Не вдалося прочитати $count рядків',
      few: 'Не вдалося прочитати $count рядки',
      one: 'Не вдалося прочитати $count рядок',
    );
    return '$_temp0';
  }

  @override
  String csvImportPreviewIssueLine(int line, String reason) {
    return 'Рядок $line: $reason';
  }

  @override
  String csvImportPreviewIssueMore(int count) {
    return '…і ще $count';
  }

  @override
  String get csvImportPreviewDateStyleTitle =>
      'Дати на кшталт 03/04/2026 неоднозначні. Як їх читати?';

  @override
  String get csvImportPreviewDateStyleDayFirst => 'Спочатку день (3 квітня)';

  @override
  String get csvImportPreviewDateStyleMonthFirst =>
      'Спочатку місяць (4 березня)';

  @override
  String get csvImportPreviewNothing =>
      'Жоден рядок цього файлу не можна імпортувати.';

  @override
  String get csvImportPreviewConfirm => 'Імпортувати';

  @override
  String get csvRowProblemDate => 'недійсна або відсутня дата';

  @override
  String get csvRowProblemAmount => 'недійсна або відсутня сума';

  @override
  String get csvRowProblemAccount => 'недійсний або відсутній рахунок';

  @override
  String get csvRowProblemType => 'невідомий тип транзакції';

  @override
  String csvImportDone(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Імпортовано $count транзакції',
      many: 'Імпортовано $count транзакцій',
      few: 'Імпортовано $count транзакції',
      one: 'Імпортовано $count транзакцію',
    );
    return '$_temp0';
  }

  @override
  String get csvImportFailedNoColumns =>
      'Не розпізнано жодного стовпця. Почніть із шаблону CSV.';

  @override
  String csvImportFailedMissingColumn(String column) {
    return 'У файлі немає стовпця \"$column\".';
  }

  @override
  String get csvImportFailedEmpty => 'У цьому файлі немає рядків із даними.';

  @override
  String csvImportFailedTooManyRows(int rows, int max) {
    return 'У файлі $rows рядків, а межа — $max.';
  }

  @override
  String get csvImportFailed => 'Не вдалося імпортувати CSV';

  @override
  String get ledgerVerifyDialogTitle => 'Перевірка бухгалтерської книги';

  @override
  String get ledgerVerifyAllMatch => 'Усі рахунки збігаються.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Розбіжності';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nЗбережено: $stored\nВідтворено: $replayed\nРізниця: $diff';
  }

  @override
  String get settingsLanguage => 'Мова програми';

  @override
  String get settingsLanguageSubtitleSystem =>
      'Відповідно до системних налаштувань';

  @override
  String get settingsLanguageSubtitleEnglish => 'English';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Serbian (Latin)';

  @override
  String get settingsLanguagePickerTitle => 'Мова програми';

  @override
  String get settingsLanguageOptionSystem => 'Системна за замовчуванням';

  @override
  String get settingsLanguageOptionEnglish => 'English';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Serbian (Latin)';

  @override
  String get settingsSectionAppearance => 'Зовнішній вигляд';

  @override
  String get settingsSectionSecurity => 'Безпека';

  @override
  String get settingsSecurityEnableLock => 'Блокувати програму при відкритті';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Вимагати біометричне розблокування або PIN при відкритті програми';

  @override
  String get settingsSecurityLockDelayTitle =>
      'Повторне блокування при згортанні';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      'Як довго програма може бути поза екраном, перш ніж знову вимагатиме розблокування. Негайно — найбезпечніший варіант.';

  @override
  String get settingsSecurityLockDelayImmediate => 'Негайно';

  @override
  String get settingsSecurityLockDelay30s => '30 секунд';

  @override
  String get settingsSecurityLockDelay1m => '1 хвилина';

  @override
  String get settingsSecurityLockDelay5m => '5 хвилин';

  @override
  String get settingsSecuritySetPin => 'Встановити PIN';

  @override
  String get settingsSecurityChangePin => 'Змінити PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Використовувати PIN як резерв, якщо біометрія недоступна';

  @override
  String get settingsSecurityRemovePin => 'Видалити PIN';

  @override
  String get securitySetPinTitle => 'Встановити PIN програми';

  @override
  String get securityPinLabel => 'PIN-код';

  @override
  String get securityConfirmPinLabel => 'Підтвердити PIN-код';

  @override
  String get securityPinMustBe4Digits => 'PIN має містити щонайменше 4 цифри';

  @override
  String get securityPinMismatch => 'PIN-коди не збігаються';

  @override
  String get securityRemovePinTitle => 'Видалити PIN?';

  @override
  String get securityRemovePinBody =>
      'Біометричне розблокування залишається доступним, якщо підтримується.';

  @override
  String get securityUnlockTitle => 'Програму заблоковано';

  @override
  String get securityUnlockSubtitle =>
      'Розблокуйте за допомогою Face ID, відбитка пальця або PIN.';

  @override
  String get securityUnlockWithPin => 'Розблокувати за допомогою PIN';

  @override
  String get securityTryBiometric => 'Спробувати біометричне розблокування';

  @override
  String get securityPinIncorrect => 'Невірний PIN, спробуйте ще';

  @override
  String securityTooManyAttempts(int seconds) {
    return 'Забагато спроб. Повторіть через $seconds с';
  }

  @override
  String get securityBiometricReason =>
      'Автентифікуйтесь для відкриття програми';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeSubtitleSystem =>
      'Відповідно до системних налаштувань';

  @override
  String get settingsThemeSubtitleLight => 'Світла';

  @override
  String get settingsThemeSubtitleDark => 'Темна';

  @override
  String get settingsThemePickerTitle => 'Тема';

  @override
  String get settingsThemeOptionSystem => 'Системна за замовчуванням';

  @override
  String get settingsThemeOptionLight => 'Світла';

  @override
  String get settingsThemeOptionDark => 'Темна';

  @override
  String get archivedAccountsTitle => 'Архівні рахунки';

  @override
  String get archivedAccountsEmptyTitle => 'Немає архівних рахунків';

  @override
  String get archivedAccountsEmptyBody =>
      'Балансова сума та овердрафт мають бути нульовими. Архівуйте з параметрів рахунку в Огляді.';

  @override
  String get categoriesTitle => 'Категорії';

  @override
  String get newCategoryTitle => 'Нова категорія';

  @override
  String get categoryNameLabel => 'Назва категорії';

  @override
  String get deleteCategoryTitle => 'Видалити категорію?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" буде видалено зі списку.';
  }

  @override
  String get categoryIncome => 'Дохід';

  @override
  String get categoryExpense => 'Витрата';

  @override
  String get categoryAdd => 'Додати';

  @override
  String get editCategoryTitle => 'Редагувати категорію';

  @override
  String get categorySave => 'Зберегти';

  @override
  String get categoryRenameAction => 'Перейменувати';

  @override
  String get categoryDuplicateName => 'Категорія з такою назвою вже існує.';

  @override
  String get categoryInUseTitle => 'Категорія використовується';

  @override
  String categoryInUseBody(String category, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count транзакціях',
      many: '$count транзакціях',
      few: '$count транзакціях',
      one: '$count транзакції',
    );
    return '«$category» використовується в $_temp0. Її не можна видалити, але можна перейменувати — усі пов\'язані транзакції оновляться автоматично.';
  }

  @override
  String get searchCurrencies => 'Пошук валют…';

  @override
  String get period1M => '1М';

  @override
  String get period3M => '3М';

  @override
  String get period6M => '6М';

  @override
  String get period1Y => '1Р';

  @override
  String get periodAll => 'УСЕ';

  @override
  String get categoryLabel => 'категорія';

  @override
  String get categoriesLabel => 'категорії';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type збережено  •  $amount';
  }

  @override
  String get tooltipSettings => 'Налаштування';

  @override
  String get tooltipAddAccount => 'Додати рахунок';

  @override
  String get tooltipRemoveAccount => 'Видалити рахунок';

  @override
  String get accountNameTaken =>
      'У вас вже є рахунок з такою назвою та ідентифікатором (активний або архівний). Змініть назву або ідентифікатор.';

  @override
  String get groupDescPersonal => 'Власні гаманці та банківські рахунки';

  @override
  String get groupDescIndividuals => 'Сім\'я, друзі, фізичні особи';

  @override
  String get groupDescEntities => 'Організації, комунальні служби, установи';

  @override
  String get cannotArchiveTitle => 'Поки що не можна архівувати';

  @override
  String get cannotArchiveBody =>
      'Архівування доступне лише тоді, коли балансова сума та ліміт овердрафту фактично нульові.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Архівування доступне лише тоді, коли балансова сума та ліміт овердрафту фактично нульові. Спочатку відкоригуйте книгу або ліміт.';

  @override
  String get archiveAccountTitle => 'Архівувати рахунок?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запланованих транзакцій посилаються на цей рахунок.',
      one: '1 запланована транзакція посилається на цей рахунок.',
    );
    return '$_temp0 Видаліть їх, щоб план залишався узгодженим з архівним рахунком.';
  }

  @override
  String get removeAndArchive => 'Видалити заплановані й архівувати';

  @override
  String get archiveBody =>
      'Рахунок буде приховано з Огляду, Історії та Плану. Відновити можна в Налаштуваннях.';

  @override
  String get archiveAction => 'Архівувати';

  @override
  String get archiveInstead => 'Архівувати натомість';

  @override
  String get cannotDeleteTitle => 'Не можна видалити рахунок';

  @override
  String get cannotDeleteBodyShort =>
      'Цей рахунок фігурує в Історії. Спочатку видаліть або перепризначте ці транзакції, або архівуйте рахунок, якщо баланс нульовий.';

  @override
  String get cannotDeleteBodyHistory =>
      'Цей рахунок фігурує в Історії. Видалення порушить цю історію — спочатку видаліть або перепризначте ці транзакції.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Цей рахунок фігурує в Історії, тому його не можна видалити. Ви можете архівувати його, якщо балансова сума та овердрафт нульові — він буде прихований зі списків, але історія залишиться.';

  @override
  String get deleteAccountTitle => 'Видалити рахунок?';

  @override
  String get deleteAccountBodyPermanent =>
      'Цей рахунок буде видалено назавжди.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count запланованих транзакцій посилаються на цей рахунок і також будуть видалені.',
      one:
          '1 запланована транзакція посилається на цей рахунок і також буде видалена.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Видалити всі';

  @override
  String get editAccountTitle => 'Редагувати рахунок';

  @override
  String get newAccountTitle => 'Новий рахунок';

  @override
  String get labelAccountName => 'Назва рахунку';

  @override
  String get labelAccountIdentifier => 'Ідентифікатор (необов\'язково)';

  @override
  String get accountAppearanceSection => 'Значок і колір';

  @override
  String get accountPickIcon => 'Вибрати значок';

  @override
  String get accountPickColor => 'Вибрати колір';

  @override
  String get accountIconSheetTitle => 'Значок рахунку';

  @override
  String get accountColorSheetTitle => 'Колір рахунку';

  @override
  String get searchAccountIcons => 'Пошук значків за назвою…';

  @override
  String get accountIconSearchNoMatches =>
      'Немає значків, що відповідають цьому пошуку.';

  @override
  String get accountUseInitialLetter => 'Перша літера';

  @override
  String get accountUseDefaultColor => 'Колір групи';

  @override
  String get labelRealBalance => 'Реальний баланс';

  @override
  String get labelOverdraftLimit => 'Ліміт овердрафту / авансу';

  @override
  String get labelCurrency => 'Валюта';

  @override
  String get saveChanges => 'Зберегти зміни';

  @override
  String get addAccountAction => 'Додати рахунок';

  @override
  String get removeAccountSheetTitle => 'Видалити рахунок';

  @override
  String get deletePermanently => 'Видалити назавжди';

  @override
  String get deletePermanentlySubtitle =>
      'Можливо лише якщо цей рахунок не використовується в Історії. Заплановані елементи можна видалити разом із рахунком.';

  @override
  String get archiveOptionSubtitle =>
      'Приховати з Огляду та списків вибору. Відновити будь-коли в Налаштуваннях. Потрібен нульовий баланс та овердрафт.';

  @override
  String get archivedBannerText =>
      'Цей рахунок архівовано. Він залишається у ваших даних, але прихований зі списків і списків вибору.';

  @override
  String get balanceAdjustedTitle => 'Баланс скориговано в Історії';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Реальний баланс оновлено з $previous до $current $symbol.\n\nУ Історії створено транзакцію коригування балансу для збереження узгодженості книги.\n\n• Реальний баланс відображає фактичну суму на цьому рахунку.\n• Перевірте Історію для перегляду запису коригування.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Коригування балансу';

  @override
  String get descriptionBalanceCorrection => 'Коригування балансу';

  @override
  String get descriptionOpeningBalance => 'Початковий баланс';

  @override
  String get reviewStatsModeStatistics => 'Статистика';

  @override
  String get reviewStatsModeComparison => 'Порівняння';

  @override
  String get statsUncategorized => 'Без категорії';

  @override
  String get statsNoCategories =>
      'Немає категорій у вибраних періодах для порівняння.';

  @override
  String get statsNoTransactions => 'Немає транзакцій';

  @override
  String get statsSpendingInCategory => 'Витрати в цій категорії';

  @override
  String get statsIncomeInCategory => 'Доходи в цій категорії';

  @override
  String get statsDifference => 'Різниця (B vs A): ';

  @override
  String get statsNoExpensesMonth => 'Витрат цього місяця немає';

  @override
  String get statsNoExpensesAll => 'Витрат не зафіксовано';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Витрат за останні $period немає';
  }

  @override
  String get statsTotalSpent => 'Загалом витрачено';

  @override
  String get statsNoExpensesThisPeriod => 'Витрат за цей період немає';

  @override
  String get statsNoIncomeMonth => 'Доходів цього місяця немає';

  @override
  String get statsNoIncomeAll => 'Доходів не зафіксовано';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Доходів за останні $period немає';
  }

  @override
  String get statsTotalReceived => 'Загалом отримано';

  @override
  String get statsNoIncomeThisPeriod => 'Доходів за цей період немає';

  @override
  String get catSalary => 'Зарплата';

  @override
  String get catFreelance => 'Фриланс';

  @override
  String get catConsulting => 'Консультації';

  @override
  String get catGift => 'Подарунок';

  @override
  String get catRental => 'Оренда';

  @override
  String get catDividends => 'Дивіденди';

  @override
  String get catRefund => 'Повернення';

  @override
  String get catBonus => 'Бонус';

  @override
  String get catInterest => 'Відсотки';

  @override
  String get catSideHustle => 'Додатковий заробіток';

  @override
  String get catSaleOfGoods => 'Продаж товарів';

  @override
  String get catOther => 'Інше';

  @override
  String get catGroceries => 'Продукти';

  @override
  String get catDining => 'Харчування';

  @override
  String get catTransport => 'Транспорт';

  @override
  String get catUtilities => 'Комунальні послуги';

  @override
  String get catHousing => 'Житло';

  @override
  String get catHealthcare => 'Охорона здоров\'я';

  @override
  String get catEntertainment => 'Розваги';

  @override
  String get catShopping => 'Шопінг';

  @override
  String get catTravel => 'Подорожі';

  @override
  String get catEducation => 'Освіта';

  @override
  String get catSubscriptions => 'Підписки';

  @override
  String get catInsurance => 'Страхування';

  @override
  String get catFuel => 'Паливо';

  @override
  String get catGym => 'Спортзал';

  @override
  String get catPets => 'Домашні тварини';

  @override
  String get catKids => 'Діти';

  @override
  String get catCharity => 'Благодійність';

  @override
  String get catCoffee => 'Кава';

  @override
  String get catGifts => 'Подарунки';

  @override
  String semanticsProjectionDate(String date) {
    return 'Дата прогнозу $date. Подвійний дотик для вибору дати';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Прогнозований особистий баланс $amount';
  }

  @override
  String get statsEmptyTitle => 'Транзакцій ще немає';

  @override
  String get statsEmptySubtitle =>
      'Немає даних про витрати для вибраного діапазону.';

  @override
  String get semanticsShowProjections =>
      'Показати прогнозовані баланси по рахунках';

  @override
  String get semanticsHideProjections =>
      'Приховати прогнозовані баланси по рахунках';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Показати баланси рахунків за цей день';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Приховати баланси рахунків за цей день';

  @override
  String get semanticsDateAllTime =>
      'Дата: за весь час — торкніться для зміни режиму';

  @override
  String semanticsDateMode(String mode) {
    return 'Дата: $mode — торкніться для зміни режиму';
  }

  @override
  String get semanticsDateThisMonth =>
      'Дата: цей місяць — торкніться для вибору місяця, тижня, року або всього часу';

  @override
  String get semanticsTxTypeCycle =>
      'Тип транзакції: усі, дохід, витрата, переказ';

  @override
  String get semanticsAccountFilter => 'Фільтр рахунків';

  @override
  String get semanticsAlreadyFiltered => 'Вже відфільтровано за цим рахунком';

  @override
  String get semanticsCategoryFilter => 'Фільтр категорій';

  @override
  String get semanticsSortToggle =>
      'Сортування: перемикати від найновіших або найстаріших';

  @override
  String get semanticsFiltersDisabled =>
      'Фільтри списку вимкнено під час перегляду майбутньої дати прогнозу. Очистіть прогнози для використання фільтрів.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Фільтри списку вимкнено. Спочатку додайте рахунок.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Фільтри списку вимкнено. Спочатку додайте заплановану транзакцію.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Фільтри списку вимкнено. Спочатку запишіть транзакцію.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Елементи розділу та валюти вимкнено. Спочатку додайте рахунок.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Дата прогнозу та деталізація балансу вимкнені. Спочатку додайте рахунок і заплановану транзакцію.';

  @override
  String get semanticsReorderAccountHint =>
      'Утримуйте, потім перетягніть для зміни порядку в цій групі';

  @override
  String get semanticsChartStyle => 'Стиль діаграми';

  @override
  String get semanticsChartStyleUnavailable =>
      'Стиль діаграми (недоступно в режимі порівняння)';

  @override
  String semanticsPeriod(String label) {
    return 'Період: $label';
  }

  @override
  String get trackSearchHint => 'Пошук за описом, категорією, рахунком…';

  @override
  String get trackSearchClear => 'Очистити пошук';

  @override
  String get settingsExchangeRatesTitle => 'Курси валют';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Останнє оновлення: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Використовуються офлайн або вбудовані курси — торкніться для оновлення';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Курси валют оновлено';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Не вдалося оновити курси валют. Перевірте з\'єднання.';

  @override
  String get settingsClearData => 'Очистити дані';

  @override
  String get settingsClearDataSubtitle => 'Назавжди видалити вибрані дані';

  @override
  String get clearDataTitle => 'Очистити дані';

  @override
  String get clearDataTransactions => 'Історія транзакцій';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count транзакцій · баланси рахунків скинуто до нуля';
  }

  @override
  String get clearDataPlanned => 'Заплановані транзакції';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count запланованих елементів';
  }

  @override
  String get clearDataAccounts => 'Рахунки';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count рахунків · також очищає Історію та План';
  }

  @override
  String get clearDataCategories => 'Категорії';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count категорій · замінено стандартними';
  }

  @override
  String get clearDataPreferences => 'Параметри';

  @override
  String get clearDataPreferencesSubtitle =>
      'Скинути валюту, тему та мову до стандартних значень';

  @override
  String get clearDataSecurity => 'Блокування та PIN';

  @override
  String get clearDataSecuritySubtitle =>
      'Вимкнути блокування програми та видалити PIN';

  @override
  String get clearDataConfirmButton => 'Очистити вибране';

  @override
  String get clearDataConfirmTitle => 'Цю дію не можна скасувати';

  @override
  String get clearDataConfirmBody =>
      'Вибрані дані буде назавжди видалено. Спочатку експортуйте резервну копію, якщо вона може знадобитися пізніше.';

  @override
  String get clearDataTypeConfirm => 'Введіть ВИДАЛИТИ для підтвердження';

  @override
  String get clearDataTypeConfirmError => 'Введіть ВИДАЛИТИ, щоб продовжити';

  @override
  String get clearDataPinTitle => 'Підтвердити PIN-кодом';

  @override
  String get clearDataPinBody =>
      'Введіть PIN-код програми для авторизації цієї дії.';

  @override
  String get clearDataPinIncorrect => 'Невірний PIN-код';

  @override
  String get clearDataDone => 'Вибрані дані очищено';

  @override
  String get autoBackupTitle => 'Автоматичне щоденне резервне копіювання';

  @override
  String autoBackupLastAt(String date) {
    return 'Останнє резервне копіювання $date';
  }

  @override
  String get autoBackupNeverRun => 'Резервної копії ще немає';

  @override
  String get autoBackupShareTitle => 'Зберегти в хмарі';

  @override
  String get autoBackupShareSubtitle =>
      'Завантажити останню резервну копію на iCloud Drive, Google Drive або будь-яку іншу програму';

  @override
  String get autoBackupCloudReminder =>
      'Автоматичне резервне копіювання готове — збережіть у хмарі для захисту поза пристроєм';

  @override
  String get autoBackupCloudReminderAction => 'Поділитися';

  @override
  String get settingsBackupReminderTitle => 'Нагадування про резервну копію';

  @override
  String get settingsBackupReminderSubtitle =>
      'Банер у програмі, якщо ви додаєте багато транзакцій без експорту ручної резервної копії.';

  @override
  String get settingsBackupReminderThresholdTitle => 'Поріг транзакцій';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return 'Нагадати після $count нових транзакцій з моменту останнього ручного експорту.';
  }

  @override
  String get settingsBackupReminderThresholdInvalid =>
      'Введіть ціле число від 1 до 500.';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '«Нагадати пізніше» приховує банер, доки ви не додасте ще $n транзакцій.';
  }

  @override
  String get backupReminderBannerTitle => 'Експортувати резервну копію?';

  @override
  String backupReminderBannerBody(int count) {
    return 'Ви додали $count транзакцій з моменту останнього ручного експорту.';
  }

  @override
  String get backupReminderRemindLater => 'Нагадати пізніше';

  @override
  String get backupExportLedgerVerifyTitle =>
      'Перевірка журналу перед резервним копіюванням';

  @override
  String get backupExportLedgerVerifyInfo =>
      'Порівнює збережений баланс кожного рахунку з повним відтворенням історії. Ви можете експортувати резервну копію в будь-якому випадку; розбіжності мають інформаційний характер.';

  @override
  String get backupExportLedgerVerifyContinue =>
      'Перейти до резервного копіювання';

  @override
  String get persistenceErrorReloaded =>
      'Не вдалося зберегти зміни. Дані перезавантажено зі сховища.';

  @override
  String get helpTooltip => 'Довідка';

  @override
  String get helpNext => 'Далі';

  @override
  String get helpBack => 'Назад';

  @override
  String get helpDone => 'Готово';

  @override
  String get helpSkip => 'Пропустити';

  @override
  String get helpTrackHeroTitle => 'Підсумки та фільтри';

  @override
  String get helpTrackHeroBody =>
      'Ця картка підсумовує надходження й витрати за списком нижче. Чипи фільтрують за рахунком, категорією і типом; чип дати перемикає день, тиждень, місяць і рік; стрілка змінює порядок сортування.';

  @override
  String get helpTrackListTitle => 'Ваша історія';

  @override
  String get helpTrackListBody =>
      'Записані операції, згруповані за днями. Торкніться операції, щоб переглянути або змінити її, а пошук допоможе знайти потрібний запис.';

  @override
  String get helpTrackFabTitle => 'Додати операцію';

  @override
  String get helpTrackFabBody =>
      'Записуйте надходження, витрати та перекази між вашими рахунками.';

  @override
  String get helpSettingsTitle => 'Налаштування';

  @override
  String get helpSettingsBody =>
      'Валюти, мова, тема, безпека, резервні копії та керування рахунками — усе тут.';

  @override
  String get helpPlanHeroTitle => 'Прогноз';

  @override
  String get helpPlanHeroBody =>
      'Ваш особистий і чистий баланс на обрану дату. Чипи нижче фільтрують заплановані операції.';

  @override
  String get helpPlanListTitle => 'Заплановані операції';

  @override
  String get helpPlanListBody =>
      'Очікувані доходи, витрати й перекази. Торкніться запису, щоб змінити його; чипи вгорі фільтрують цей список.';

  @override
  String get helpPlanFabTitle => 'Додати план';

  @override
  String get helpPlanFabBody =>
      'Заплануйте очікувану операцію, зокрема повторювану.';

  @override
  String get helpPlanProjectionFabTitle => 'Прогноз на майбутнє';

  @override
  String get helpPlanProjectionFabBody =>
      'Торкніться глобуса, щоб вибрати майбутню дату й побачити прогнозовані баланси — враховуються заплановані операції до цієї дати. Також можна торкнутися дати на картці вгорі.';

  @override
  String get helpReviewHeroTitle => 'Статки';

  @override
  String get helpReviewHeroBody =>
      'Ваш особистий баланс і чисті статки одним поглядом. Торкніться сум, щоб перемкнутися між основною та додатковою валютою.';

  @override
  String get helpReviewSectionsTitle => 'Розділи';

  @override
  String get helpReviewSectionsBody =>
      'Гортайте вліво та вправо — або торкайтеся чипів — щоб переходити між особистими рахунками, людьми, організаціями та статистикою.';

  @override
  String get helpReviewAccountsTitle => 'Рахунки';

  @override
  String get helpReviewAccountsBody =>
      'Кожна картка показує рахунок і його баланс. Торкніться, щоб відкрити повну історію операцій.';

  @override
  String get helpReviewFabTitle => 'Додати рахунок';

  @override
  String get helpReviewFabBody =>
      'Створюйте рахунки для готівки, карток і заощаджень, а також для людей і компаній, за якими стежите.';

  @override
  String get helpSettingsSecurityTitle => 'Безпека';

  @override
  String get helpSettingsSecurityBody =>
      'Заблокуйте застосунок блокуванням екрана пристрою та виберіть, як швидко він блокується знову.';

  @override
  String get helpSettingsPreferencesTitle => 'Уподобання';

  @override
  String get helpSettingsPreferencesBody =>
      'Мова, тема, валюти та інші повсякденні параметри.';

  @override
  String get helpSettingsDataTitle => 'Ваші дані';

  @override
  String get helpSettingsDataBody =>
      'Експортуйте зашифровані резервні копії, імпортуйте їх на іншому пристрої та налаштовуйте автоматичні копії. Дані не залишають цей пристрій, доки ви їх не експортуєте.';

  @override
  String get helpSettingsManageTitle => 'Керування';

  @override
  String get helpSettingsManageBody =>
      'Редагуйте рахунки та перейменовуйте категорії — зміни діють у всьому застосунку.';

  @override
  String get helpTxAccountsTitle => 'Звідки та Куди';

  @override
  String get helpTxAccountsBody =>
      'Виберіть, звідки надходять гроші та куди йдуть. Лише Звідки — витрата. Лише Куди — дохід. Обидва — переказ між рахунками.';

  @override
  String get helpTxDetailsTitle => 'Сума й деталі';

  @override
  String get helpTxDetailsBody =>
      'Введіть суму, а потім додайте категорію, нотатку чи вкладення, щоб запис було легко знайти.';

  @override
  String get helpTxDateTitle => 'Дата';

  @override
  String get helpTxDateBody => 'Торкніться тут, щоб змінити день операції.';

  @override
  String get helpPlannedDateTitle => 'Термін';

  @override
  String get helpPlannedDateBody =>
      'Торкніться тут, щоб вибрати, коли це має статися. План також може повторюватися за обраним розкладом.';

  @override
  String get helpPlannedProjectionTitle => 'Прогнозовані баланси';

  @override
  String get helpPlannedProjectionBody =>
      'Вибір рахунків показує прогнозований баланс кожного рахунку на дату терміну — так видно план, який завів би рахунок у мінус.';

  @override
  String get settingsPlannedRemindersTitle => 'Нагадування про плани';

  @override
  String get settingsPlannedRemindersSubtitle =>
      'Сповіщає, коли настає термін запланованої операції. Працює повністю офлайн — дані не залишають пристрій.';

  @override
  String get settingsPlannedRemindersTimeTitle => 'Час нагадування';

  @override
  String get settingsPlannedRemindersLeadTitle => 'Завчасність';

  @override
  String get settingsPlannedRemindersLeadOnDay => 'У день терміну';

  @override
  String settingsPlannedRemindersLeadDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'За $count дня',
      many: 'За $count днів',
      few: 'За $count дні',
      one: 'За $count день',
    );
    return '$_temp0';
  }

  @override
  String get settingsPlannedRemindersPermissionDenied =>
      'Сповіщення для Platrare вимкнено. Дозвольте їх у налаштуваннях системи, щоб отримувати нагадування.';

  @override
  String get plannedReminderChannelName =>
      'Нагадування про заплановані операції';

  @override
  String get plannedReminderChannelDescription =>
      'Сповіщення про майбутні заплановані операції.';

  @override
  String get plannedReminderFallbackTitle => 'Запланована операція';

  @override
  String get plannedReminderDueToday => 'Термін сьогодні';

  @override
  String get plannedReminderDueTomorrow => 'Термін завтра';

  @override
  String plannedReminderDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Термін через $count дня',
      many: 'Термін через $count днів',
      few: 'Термін через $count дні',
      one: 'Термін через $count день',
    );
    return '$_temp0';
  }

  @override
  String get aboutContactSupport => 'Звʼязатися з підтримкою';

  @override
  String get aboutSupportEmailCopied => 'Адресу пошти підтримки скопійовано';

  @override
  String get onboardingWelcomeTitle => 'Вітаємо в Platrare';

  @override
  String get onboardingWelcomeBody =>
      'Ваші гроші залишаються на цьому пристрої. Без облікового запису, без реклами, без стеження.';

  @override
  String get onboardingPlanBody =>
      'Плануйте майбутні та повторювані платежі й дивіться, куди рухаються ваші баланси.';

  @override
  String get onboardingTrackBody =>
      'Записуйте доходи, витрати, перекази й те, що ви позичаєте або винні.';

  @override
  String get onboardingReviewBody =>
      'Статистика, порівняння та історія за вашими рахунками, людьми, з якими ви розраховуєтесь, і компаніями.';

  @override
  String get onboardingCurrencyLabel => 'Основна валюта';

  @override
  String get onboardingCurrencyHint =>
      'Запропоновано за мовою пристрою. Пізніше її можна змінити в налаштуваннях.';

  @override
  String get onboardingStart => 'Почати';

  @override
  String get onboardingTour => 'Покажіть застосунок';

  @override
  String get clearDataConfirmWord => 'ВИДАЛИТИ';

  @override
  String get planDeleteTitle => 'Видалити заплановану операцію?';

  @override
  String get planDeleteBody =>
      'Її буде вилучено з плану. Баланси ваших рахунків не зміняться.';

  @override
  String get semanticsPreviousPeriod => 'Попередній період';

  @override
  String get semanticsNextPeriod => 'Наступний період';

  @override
  String get semanticsSectionStatistics => 'Статистика';

  @override
  String get semanticsCurrencyToggle => 'Змінити валюту відображення';

  @override
  String get semanticsStatsSpent => 'Витрачено';

  @override
  String get semanticsStatsReceived => 'Отримано';

  @override
  String get ledgerVerifyRecalculate => 'Перерахувати за історією';

  @override
  String ledgerVerifyRecalculated(int count) {
    return 'Перераховано баланси $count рахунків за історією';
  }
}
