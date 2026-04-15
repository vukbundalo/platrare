// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'بلاترار';

  @override
  String get navPlan => 'يخطط';

  @override
  String get navTrack => 'مسار';

  @override
  String get navReview => 'مراجعة';

  @override
  String get cancel => 'يلغي';

  @override
  String get delete => 'يمسح';

  @override
  String get close => 'يغلق';

  @override
  String get add => 'يضيف';

  @override
  String get undo => 'تراجع';

  @override
  String get confirm => 'يتأكد';

  @override
  String get restore => 'يعيد';

  @override
  String get heroIn => 'في';

  @override
  String get heroOut => 'خارج';

  @override
  String get heroNet => 'شبكة';

  @override
  String get heroBalance => 'توازن';

  @override
  String get realBalance => 'التوازن الحقيقي';

  @override
  String get settingsHideHeroBalancesTitle => 'إخفاء الأرصدة في بطاقات الملخص';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'عند التفعيل، تبقى المبالغ في الخطة والتتبع والمراجعة مخفية حتى تضغط على أيقونة العين في كل تبويب. عند الإيقاف، تكون الأرصدة مرئية دائماً.';

  @override
  String get heroBalancesShow => 'إظهار الأرصدة';

  @override
  String get heroBalancesHide => 'إخفاء الأرصدة';

  @override
  String get semanticsHeroBalanceHidden => 'الرصيد مخفي للخصوصية';

  @override
  String get heroResetButton => 'إعادة ضبط';

  @override
  String get fabScrollToTop => 'للأعلى';

  @override
  String get filterAll => 'الجميع';

  @override
  String get filterAllAccounts => 'جميع الحسابات';

  @override
  String get filterAllCategories => 'جميع الفئات';

  @override
  String get txLabelIncome => 'دخل';

  @override
  String get txLabelExpense => 'النفقات';

  @override
  String get txLabelInvoice => 'فاتورة';

  @override
  String get txLabelBill => 'فاتورة';

  @override
  String get txLabelAdvance => 'يتقدم';

  @override
  String get txLabelSettlement => 'مستعمرة';

  @override
  String get txLabelLoan => 'يُقرض';

  @override
  String get txLabelCollection => 'مجموعة';

  @override
  String get txLabelOffset => 'إزاحة';

  @override
  String get txLabelTransfer => 'تحويل';

  @override
  String get txLabelTransaction => 'عملية';

  @override
  String get repeatNone => 'لا تكرار';

  @override
  String get repeatDaily => 'يوميًا';

  @override
  String get repeatWeekly => 'أسبوعي';

  @override
  String get repeatMonthly => 'شهريا';

  @override
  String get repeatYearly => 'سنوي';

  @override
  String get repeatEveryLabel => 'كل';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أيام',
      one: 'يوم',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أسابيع',
      one: 'أسبوع',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أشهر',
      one: 'شهر',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سنوات',
      one: 'سنة',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'ينتهي';

  @override
  String get repeatEndNever => 'أبداً';

  @override
  String get repeatEndOnDate => 'في موعد';

  @override
  String repeatEndAfterCount(int count) {
    return 'بعد $count مرات';
  }

  @override
  String get repeatEndAfterChoice => 'بعد عدد من المرات';

  @override
  String get repeatEndPickDate => 'اختر تاريخ الانتهاء';

  @override
  String get repeatEndTimes => 'مرات';

  @override
  String repeatSummaryEvery(String unit) {
    return 'كل $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'حتى $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count مرات';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining من $total المتبقي';
  }

  @override
  String get detailRepeatEvery => 'كرر كل';

  @override
  String get detailEnds => 'ينتهي';

  @override
  String get detailEndsNever => 'أبداً';

  @override
  String detailEndsOnDate(String date) {
    return 'على $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'بعد $count مرات';
  }

  @override
  String get detailProgress => 'تقدم';

  @override
  String get weekendNoChange => 'لا تغيير';

  @override
  String get weekendFriday => 'الانتقال إلى الجمعة';

  @override
  String get weekendMonday => 'الانتقال إلى يوم الاثنين';

  @override
  String weekendQuestion(String day) {
    return 'إذا كان $day يقع في عطلة نهاية الأسبوع؟';
  }

  @override
  String get dateToday => 'اليوم';

  @override
  String get dateTomorrow => 'غداً';

  @override
  String get dateYesterday => 'أمس';

  @override
  String get statsAllTime => 'كل الوقت';

  @override
  String get accountGroupPersonal => 'شخصي';

  @override
  String get accountGroupIndividual => 'فردي';

  @override
  String get accountGroupEntity => 'كيان';

  @override
  String get accountSectionIndividuals => 'فرادى';

  @override
  String get accountSectionEntities => 'الكيانات';

  @override
  String get emptyNoTransactionsYet => 'لا توجد معاملات حتى الآن';

  @override
  String get emptyNoAccountsYet => 'لا توجد حسابات حتى الآن';

  @override
  String get emptyRecordFirstTransaction =>
      'اضغط على الزر أدناه لتسجيل معاملتك الأولى.';

  @override
  String get emptyAddFirstAccountTx =>
      'قم بإضافة حسابك الأول قبل تسجيل المعاملات.';

  @override
  String get emptyAddFirstAccountPlan =>
      'قم بإضافة حسابك الأول قبل التخطيط للمعاملات.';

  @override
  String get emptyAddFirstAccountReview =>
      'قم بإضافة حسابك الأول لبدء تتبع أموالك.';

  @override
  String get emptyAddTransaction => 'إضافة المعاملة';

  @override
  String get emptyAddAccount => 'إضافة حساب';

  @override
  String get reviewEmptyGroupPersonalTitle => 'لا توجد حسابات شخصية حتى الآن';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'الحسابات الشخصية هي محافظك الخاصة وحساباتك المصرفية. أضف واحدًا لتتبع الدخل والإنفاق اليومي.';

  @override
  String get reviewEmptyGroupIndividualsTitle =>
      'لا توجد حسابات فردية حتى الآن';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'تقوم الحسابات الفردية بتتبع الأموال مع أشخاص محددين - التكاليف المشتركة أو القروض أو سندات الدين. أضف حسابًا لكل شخص تستقر معه.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'لا توجد حسابات كيان حتى الآن';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'حسابات الكيان مخصصة للشركات أو المشاريع أو المؤسسات. استخدمها لفصل التدفق النقدي التجاري عن أموالك الشخصية.';

  @override
  String get emptyNoTransactionsForFilters =>
      'لا توجد معاملات للمرشحات المطبقة';

  @override
  String get emptyNoTransactionsInHistory => 'لا توجد معاملات في التاريخ';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'لا توجد معاملات لـ $month';
  }

  @override
  String get emptyNoTransactionsForAccount => 'لا توجد معاملات لهذا الحساب';

  @override
  String get trackTransactionDeleted => 'تم حذف المعاملة';

  @override
  String get trackDeleteTitle => 'هل تريد حذف المعاملة؟';

  @override
  String get trackDeleteBody => 'سيؤدي هذا إلى عكس التغييرات في رصيد الحساب.';

  @override
  String get trackTransaction => 'عملية';

  @override
  String get planConfirmTitle => 'تأكيد المعاملة؟';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'تمت جدولة هذا الحدث لـ $date. سيتم تسجيله في التاريخ بتاريخ اليوم ($todayDate). يبقى الحدث التالي على $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'سيؤدي هذا إلى تطبيق المعاملة على أرصدة حسابك الحقيقية ونقلها إلى السجل.';

  @override
  String get planTransactionConfirmed => 'تم تأكيد المعاملة وتطبيقها';

  @override
  String get planTransactionRemoved => 'تمت إزالة المعاملة المخططة';

  @override
  String get planRepeatingTitle => 'تكرار المعاملة';

  @override
  String get planRepeatingBody =>
      'قم بتخطي هذا التاريخ فقط - تستمر السلسلة مع التكرار التالي - أو احذف كل التكرار المتبقي من خطتك.';

  @override
  String get planDeleteAll => 'احذف الكل';

  @override
  String get planSkipThisOnly => 'تخطي هذا فقط';

  @override
  String get planOccurrenceSkipped =>
      'تم تخطي هذا الحدث — تمت جدولة الحدث التالي';

  @override
  String get planNothingPlanned => 'لا شيء مخطط له في الوقت الراهن';

  @override
  String get planPlanBody => 'التخطيط للمعاملات القادمة.';

  @override
  String get planAddPlan => 'أضف خطة';

  @override
  String get planNoPlannedForFilters =>
      'لا توجد معاملات مخططة للمرشحات المطبقة';

  @override
  String planNoPlannedInMonth(String month) {
    return 'لا توجد معاملات مخطط لها في $month';
  }

  @override
  String get planOverdue => 'تأخرت';

  @override
  String get planPlannedTransaction => 'الصفقة المخططة';

  @override
  String get discardTitle => 'هل تريد تجاهل التغييرات؟';

  @override
  String get discardBody =>
      'لديك تغييرات غير محفوظة. سوف يضيعون إذا غادرت الآن.';

  @override
  String get keepEditing => 'استمر في التحرير';

  @override
  String get discard => 'تجاهل';

  @override
  String get newTransactionTitle => 'معاملة جديدة';

  @override
  String get editTransactionTitle => 'تحرير المعاملة';

  @override
  String get transactionUpdated => 'تم تحديث المعاملة';

  @override
  String get sectionAccounts => 'الحسابات';

  @override
  String get labelFrom => 'من';

  @override
  String get labelTo => 'ل';

  @override
  String get sectionCategory => 'فئة';

  @override
  String get sectionAttachments => 'المرفقات';

  @override
  String get labelNote => 'ملحوظة';

  @override
  String get hintOptionalDescription => 'وصف اختياري';

  @override
  String get updateTransaction => 'تحديث المعاملة';

  @override
  String get saveTransaction => 'حفظ المعاملة';

  @override
  String get selectAccount => 'اختر الحساب';

  @override
  String get selectAccountTitle => 'حدد الحساب';

  @override
  String get noAccountsAvailable => 'لا توجد حسابات متاحة';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'المبلغ المستلم بواسطة $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'أدخل المبلغ الدقيق الذي يتلقاه حساب الوجهة. وهذا يقفل سعر الصرف الحقيقي المستخدم.';

  @override
  String get attachTakePhoto => 'التقط صورة';

  @override
  String get attachTakePhotoSub => 'استخدم الكاميرا لالتقاط إيصال';

  @override
  String get attachChooseGallery => 'اختر من المعرض';

  @override
  String get attachChooseGallerySub => 'حدد الصور من مكتبتك';

  @override
  String get attachBrowseFiles => 'تصفح الملفات';

  @override
  String get attachBrowseFilesSub =>
      'إرفاق ملفات PDF أو المستندات أو الملفات الأخرى';

  @override
  String get attachButton => 'نعلق';

  @override
  String get editPlanTitle => 'تحرير الخطة';

  @override
  String get planTransactionTitle => 'صفقة الخطة';

  @override
  String get tapToSelect => 'انقر للتحديد';

  @override
  String get updatePlan => 'تحديث الخطة';

  @override
  String get addToPlan => 'أضف إلى الخطة';

  @override
  String get labelRepeat => 'يكرر';

  @override
  String get selectPlannedDate => 'حدد التاريخ المخطط';

  @override
  String get balancesAsOfToday => 'الرصيد اعتبارا من اليوم';

  @override
  String get projectedBalancesForTomorrow => 'الأرصدة المتوقعة ليوم غد';

  @override
  String projectedBalancesForDate(String date) {
    return 'الأرصدة المتوقعة لـ $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name يستقبل ($currency)';
  }

  @override
  String get destHelper =>
      'المبلغ المقصود المقدر. يتم تأمين السعر الدقيق عند التأكيد.';

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String get detailTransactionTitle => 'عملية';

  @override
  String get detailPlannedTitle => 'المخطط لها';

  @override
  String get detailConfirmTransaction => 'تأكيد المعاملة';

  @override
  String get detailDate => 'تاريخ';

  @override
  String get detailFrom => 'من';

  @override
  String get detailTo => 'ل';

  @override
  String get detailCategory => 'فئة';

  @override
  String get detailNote => 'ملحوظة';

  @override
  String get detailDestinationAmount => 'مبلغ الوجهة';

  @override
  String get detailExchangeRate => 'سعر الصرف';

  @override
  String get detailRepeats => 'يكرر';

  @override
  String get detailDayOfMonth => 'يوم من الشهر';

  @override
  String get detailWeekends => 'عطلات نهاية الأسبوع';

  @override
  String get detailAttachments => 'المرفقات';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملفات',
      one: 'ملف واحد',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'إعدادات';

  @override
  String get settingsSectionDisplay => 'عرض';

  @override
  String get settingsSectionLanguage => 'لغة';

  @override
  String get settingsSectionCategories => 'فئات';

  @override
  String get settingsSectionAccounts => 'الحسابات';

  @override
  String get settingsSectionPreferences => 'التفضيلات';

  @override
  String get settingsSectionManage => 'يدير';

  @override
  String get settingsBaseCurrency => 'العملة الرئيسية';

  @override
  String get settingsSecondaryCurrency => 'العملة الثانوية';

  @override
  String get settingsCategories => 'فئات';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount الدخل · $expenseCount المصاريف';
  }

  @override
  String get settingsArchivedAccounts => 'الحسابات المؤرشفة';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'لا يوجد أي شيء الآن — أرشفة من تعديل الحساب عندما يكون الرصيد واضحًا';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count مخفي عن المراجعة والملتقطين';
  }

  @override
  String get settingsSectionData => 'بيانات';

  @override
  String get settingsSectionPrivacy => 'عن';

  @override
  String get settingsPrivacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get settingsPrivacyPolicySubtitle => 'كيف يتعامل Platrare مع بياناتك.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'أسعار الصرف: يجلب التطبيق أسعار العملات العامة عبر الإنترنت. لا يتم إرسال حساباتك ومعاملاتك أبدًا.';

  @override
  String get settingsPrivacyOpenFailed => 'لا يمكن تحميل سياسة الخصوصية.';

  @override
  String get settingsPrivacyRetry => 'حاول ثانية';

  @override
  String get settingsSoftwareVersionTitle => 'نسخة البرنامج';

  @override
  String get settingsSoftwareVersionSubtitle => 'الإصدار والتشخيص والقانونية';

  @override
  String get aboutScreenTitle => 'عن';

  @override
  String get aboutAppTagline =>
      'دفتر الأستاذ والتدفق النقدي والتخطيط في مساحة عمل واحدة.';

  @override
  String get aboutDescriptionBody =>
      'يحتفظ Platrare بالحسابات والمعاملات والخطط على جهازك. قم بتصدير النسخ الاحتياطية المشفرة عندما تحتاج إلى نسخة في مكان آخر. تستخدم أسعار الصرف بيانات السوق العامة فقط؛ لم يتم تحميل دفتر الأستاذ الخاص بك.';

  @override
  String get aboutVersionLabel => 'إصدار';

  @override
  String get aboutBuildLabel => 'يبني';

  @override
  String get aboutCopySupportDetails => 'نسخ تفاصيل الدعم';

  @override
  String get aboutOpenPrivacySubtitle =>
      'يفتح مستند السياسة الكامل داخل التطبيق.';

  @override
  String get aboutSupportBundleLocaleLabel => 'لغة';

  @override
  String get settingsSupportInfoCopied => 'تم النسخ إلى الحافظة';

  @override
  String get settingsVerifyLedger => 'التحقق من البيانات';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'تأكد من تطابق أرصدة الحسابات مع سجل معاملاتك';

  @override
  String get settingsDataExportTitle => 'تصدير النسخة الاحتياطية';

  @override
  String get settingsDataExportSubtitle =>
      'احفظه بتنسيق .zip أو .platrare المشفر مع كافة البيانات والمرفقات';

  @override
  String get settingsDataImportTitle => 'استعادة من النسخة الاحتياطية';

  @override
  String get settingsDataImportSubtitle =>
      'استبدل البيانات الحالية من نسخة احتياطية Platrare .zip أو .platrare';

  @override
  String get backupExportDialogTitle => 'حماية هذه النسخة الاحتياطية';

  @override
  String get backupExportDialogBody =>
      'يوصى باستخدام كلمة مرور قوية، خاصة إذا قمت بتخزين الملف في السحابة. أنت بحاجة إلى نفس كلمة المرور للاستيراد.';

  @override
  String get backupExportPasswordLabel => 'كلمة المرور';

  @override
  String get backupExportPasswordConfirmLabel => 'تأكيد كلمة المرور';

  @override
  String get backupExportPasswordMismatch => 'كلمات المرور غير متطابقة';

  @override
  String get backupExportPasswordEmpty =>
      'أدخل كلمة مرور مطابقة، أو قم بالتصدير بدون تشفير أدناه.';

  @override
  String get backupExportPasswordTooShort =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.';

  @override
  String get backupExportSaveToDevice => 'حفظ على الجهاز';

  @override
  String get backupExportShareToCloud => 'المشاركة (iCloud، Drive...)';

  @override
  String get backupExportWithoutEncryption => 'تصدير بدون تشفير';

  @override
  String get backupExportSkipWarningTitle => 'تصدير بدون تشفير؟';

  @override
  String get backupExportSkipWarningBody =>
      'يمكن لأي شخص لديه حق الوصول إلى الملف قراءة بياناتك. استخدم هذا فقط للنسخ المحلية التي تتحكم فيها.';

  @override
  String get backupExportSkipWarningConfirm => 'تصدير غير مشفرة';

  @override
  String get backupImportPasswordTitle => 'نسخة احتياطية مشفرة';

  @override
  String get backupImportPasswordBody =>
      'أدخل كلمة المرور التي استخدمتها عند التصدير.';

  @override
  String get backupImportPasswordLabel => 'كلمة المرور';

  @override
  String get backupImportPreviewTitle => 'ملخص النسخ الاحتياطي';

  @override
  String backupImportPreviewVersion(String version) {
    return 'إصدار التطبيق: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'تم التصدير: $date';
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
    return '$accounts حسابات · $transactions المعاملات · $planned المخطط لها · $attachments ملفات المرفقات · $income فئات الدخل · $expense فئات النفقات';
  }

  @override
  String get backupImportPreviewContinue => 'يكمل';

  @override
  String get settingsBackupWrongPassword => 'كلمة مرور خاطئة';

  @override
  String get settingsBackupChecksumMismatch =>
      'فشل النسخ الاحتياطي في التحقق من التكامل';

  @override
  String get settingsBackupCorruptFile =>
      'ملف النسخ الاحتياطي غير صالح أو تالف';

  @override
  String get settingsBackupUnsupportedVersion =>
      'يحتاج النسخ الاحتياطي إلى إصدار أحدث من التطبيق';

  @override
  String get settingsDataImportConfirmTitle =>
      'هل تريد استبدال البيانات الحالية؟';

  @override
  String get settingsDataImportConfirmBody =>
      'سيؤدي هذا إلى استبدال حساباتك الحالية ومعاملاتك ومعاملاتك المخططة والفئات والمرفقات المستوردة بمحتويات النسخة الاحتياطية المحددة. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get settingsDataImportConfirmAction => 'استبدال البيانات';

  @override
  String get settingsDataImportDone => 'تمت استعادة البيانات بنجاح';

  @override
  String get settingsDataImportInvalidFile =>
      'هذا الملف ليس نسخة احتياطية صالحة لـ Platrare';

  @override
  String get settingsDataImportFailed => 'فشل الاستيراد';

  @override
  String get settingsDataExportDoneTitle => 'تم تصدير النسخة الاحتياطية';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'تم حفظ النسخة الاحتياطية في:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'افتح الملف';

  @override
  String get settingsDataExportFailed => 'فشل التصدير';

  @override
  String get ledgerVerifyDialogTitle => 'التحقق من دفتر الأستاذ';

  @override
  String get ledgerVerifyAllMatch => 'جميع الحسابات متطابقة.';

  @override
  String get ledgerVerifyMismatchesTitle => 'عدم التطابق';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nالمخزنة: $stored\nإعادة: $replayed\nالفرق: $diff';
  }

  @override
  String get settingsLanguage => 'لغة التطبيق';

  @override
  String get settingsLanguageSubtitleSystem => 'بعد إعدادات النظام';

  @override
  String get settingsLanguageSubtitleEnglish => 'إنجليزي';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'الصربية (اللاتينية)';

  @override
  String get settingsLanguagePickerTitle => 'لغة التطبيق';

  @override
  String get settingsLanguageOptionSystem => 'الافتراضي للنظام';

  @override
  String get settingsLanguageOptionEnglish => 'إنجليزي';

  @override
  String get settingsLanguageOptionSerbianLatin => 'الصربية (اللاتينية)';

  @override
  String get settingsSectionAppearance => 'مظهر';

  @override
  String get settingsSectionSecurity => 'حماية';

  @override
  String get settingsSecurityEnableLock => 'قفل التطبيق مفتوحا';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'يتطلب فتح القفل البيومتري أو رقم التعريف الشخصي عند فتح التطبيق';

  @override
  String get settingsSecuritySetPin => 'تعيين رقم التعريف الشخصي';

  @override
  String get settingsSecurityChangePin => 'تغيير رقم التعريف الشخصي';

  @override
  String get settingsSecurityPinSubtitle =>
      'استخدم رقم التعريف الشخصي كإجراء احتياطي في حالة عدم توفر القياسات الحيوية';

  @override
  String get settingsSecurityRemovePin => 'قم بإزالة رقم التعريف الشخصي';

  @override
  String get securitySetPinTitle => 'تعيين رقم التعريف الشخصي للتطبيق';

  @override
  String get securityPinLabel => 'رمز التعريف الشخصي';

  @override
  String get securityConfirmPinLabel => 'تأكيد رمز PIN';

  @override
  String get securityPinMustBe4Digits =>
      'يجب أن يتكون رقم التعريف الشخصي من 4 أرقام على الأقل';

  @override
  String get securityPinMismatch => 'رموز PIN غير متطابقة';

  @override
  String get securityRemovePinTitle => 'هل تريد إزالة رقم التعريف الشخصي؟';

  @override
  String get securityRemovePinBody =>
      'لا يزال من الممكن استخدام فتح القفل البيومتري إذا كان ذلك متاحًا.';

  @override
  String get securityUnlockTitle => 'التطبيق مغلق';

  @override
  String get securityUnlockSubtitle =>
      'افتح القفل باستخدام Face ID أو بصمة الإصبع أو PIN.';

  @override
  String get securityUnlockWithPin => 'فتح القفل باستخدام رقم التعريف الشخصي';

  @override
  String get securityTryBiometric => 'حاول فتح القفل البيومتري';

  @override
  String get securityPinIncorrect =>
      'رقم التعريف الشخصي غير صحيح، حاول مرة أخرى';

  @override
  String get securityBiometricReason => 'قم بالمصادقة لفتح التطبيق الخاص بك';

  @override
  String get settingsTheme => 'سمة';

  @override
  String get settingsThemeSubtitleSystem => 'بعد إعدادات النظام';

  @override
  String get settingsThemeSubtitleLight => 'ضوء';

  @override
  String get settingsThemeSubtitleDark => 'مظلم';

  @override
  String get settingsThemePickerTitle => 'سمة';

  @override
  String get settingsThemeOptionSystem => 'الافتراضي للنظام';

  @override
  String get settingsThemeOptionLight => 'ضوء';

  @override
  String get settingsThemeOptionDark => 'مظلم';

  @override
  String get archivedAccountsTitle => 'الحسابات المؤرشفة';

  @override
  String get archivedAccountsEmptyTitle => 'لا توجد حسابات مؤرشفة';

  @override
  String get archivedAccountsEmptyBody =>
      'يجب أن يكون الرصيد الدفتري والسحب على المكشوف صفراً. الأرشفة من خيارات الحساب في المراجعة.';

  @override
  String get categoriesTitle => 'فئات';

  @override
  String get newCategoryTitle => 'فئة جديدة';

  @override
  String get categoryNameLabel => 'اسم الفئة';

  @override
  String get deleteCategoryTitle => 'هل تريد حذف الفئة؟';

  @override
  String deleteCategoryBody(String category) {
    return 'ستتم إزالة \"$category\" من القائمة.';
  }

  @override
  String get categoryIncome => 'دخل';

  @override
  String get categoryExpense => 'حساب';

  @override
  String get categoryAdd => 'يضيف';

  @override
  String get searchCurrencies => 'بحث عن العملات...';

  @override
  String get period1M => '1 م';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6 م';

  @override
  String get period1Y => '1Y';

  @override
  String get periodAll => 'الجميع';

  @override
  String get categoryLabel => 'فئة';

  @override
  String get categoriesLabel => 'فئات';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type تم الحفظ • $amount';
  }

  @override
  String get tooltipSettings => 'إعدادات';

  @override
  String get tooltipAddAccount => 'إضافة حساب';

  @override
  String get tooltipRemoveAccount => 'إزالة الحساب';

  @override
  String get accountNameTaken =>
      'لديك بالفعل حساب بهذا الاسم والمعرف (نشط أو مؤرشف). تغيير الاسم أو المعرف.';

  @override
  String get groupDescPersonal => 'محافظك الخاصة وحساباتك المصرفية';

  @override
  String get groupDescIndividuals => 'العائلة، الأصدقاء، الأفراد';

  @override
  String get groupDescEntities => 'الكيانات والمرافق والمنظمات';

  @override
  String get cannotArchiveTitle => 'لا يمكن الأرشفة بعد';

  @override
  String get cannotArchiveBody =>
      'لا يتوفر الأرشيف إلا عندما يكون الرصيد الدفتري وحد السحب على المكشوف صفرًا فعليًا.';

  @override
  String get cannotArchiveBodyAdjust =>
      'لا يتوفر الأرشيف إلا عندما يكون الرصيد الدفتري وحد السحب على المكشوف صفرًا فعليًا. اضبط دفتر الأستاذ أو المنشأة أولاً.';

  @override
  String get archiveAccountTitle => 'أرشيف الحساب؟';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات مخططة تشير إلى هذا الحساب.',
      one: 'معاملة مخططة واحدة تشير إلى هذا الحساب.',
    );
    return '$_temp0 أزلها للحفاظ على تناسق خطتك مع حساب مؤرشف.';
  }

  @override
  String get removeAndArchive => 'إزالة المخطط والأرشيف';

  @override
  String get archiveBody =>
      'سيتم إخفاء الحساب عن منتقي المراجعة والتتبع والخطة. يمكنك استعادته من الإعدادات.';

  @override
  String get archiveAction => 'أرشيف';

  @override
  String get archiveInstead => 'الأرشيف بدلا من ذلك';

  @override
  String get cannotDeleteTitle => 'لا يمكن حذف الحساب';

  @override
  String get cannotDeleteBodyShort =>
      'يظهر هذا الحساب في سجل المسار الخاص بك. قم بإزالة تلك المعاملات أو إعادة تعيينها أولاً، أو أرشفة الحساب إذا تمت تصفية الرصيد.';

  @override
  String get cannotDeleteBodyHistory =>
      'يظهر هذا الحساب في سجل المسار الخاص بك. سيؤدي الحذف إلى كسر هذا السجل — قم بإزالة تلك المعاملات أو إعادة تعيينها أولاً.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'يظهر هذا الحساب في سجل المسار الخاص بك، لذا لا يمكن حذفه. يمكنك أرشفته بدلاً من ذلك إذا تمت تصفية رصيد الكتاب والسحب على المكشوف - فسيتم إخفاؤه من القوائم ولكن التاريخ سيظل كما هو.';

  @override
  String get deleteAccountTitle => 'هل تريد حذف الحساب؟';

  @override
  String get deleteAccountBodyPermanent => 'ستتم إزالة هذا الحساب نهائيًا.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات مخططة تشير إلى هذا الحساب وسيتم حذفها أيضًا.',
      one: 'معاملة مخططة واحدة تشير إلى هذا الحساب وسيتم حذفها أيضًا.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'احذف الكل';

  @override
  String get editAccountTitle => 'تحرير الحساب';

  @override
  String get newAccountTitle => 'حساب جديد';

  @override
  String get labelAccountName => 'إسم الحساب';

  @override
  String get labelAccountIdentifier => 'المعرف (اختياري)';

  @override
  String get accountAppearanceSection => 'أيقونة ولون';

  @override
  String get accountPickIcon => 'اختر أيقونة';

  @override
  String get accountPickColor => 'اختر اللون';

  @override
  String get accountIconSheetTitle => 'رمز الحساب';

  @override
  String get accountColorSheetTitle => 'لون الحساب';

  @override
  String get accountUseInitialLetter => 'الرسالة الأولية';

  @override
  String get accountUseDefaultColor => 'مباراة المجموعة';

  @override
  String get labelRealBalance => 'التوازن الحقيقي';

  @override
  String get labelOverdraftLimit => 'السحب على المكشوف / الحد المسبق';

  @override
  String get labelCurrency => 'عملة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get addAccountAction => 'إضافة حساب';

  @override
  String get removeAccountSheetTitle => 'إزالة الحساب';

  @override
  String get deletePermanently => 'حذف نهائيا';

  @override
  String get deletePermanentlySubtitle =>
      'ممكن فقط عندما لا يتم استخدام هذا الحساب في المسار. يمكن إزالة العناصر المخططة كجزء من الحذف.';

  @override
  String get archiveOptionSubtitle =>
      'إخفاء من المراجعة والملتقطين. استعادة في أي وقت من الإعدادات. يتطلب رصيد صفر والسحب على المكشوف.';

  @override
  String get archivedBannerText =>
      'تم أرشفة هذا الحساب. ويظل موجودًا في بياناتك ولكنه مخفي من القوائم والملتقطين.';

  @override
  String get balanceAdjustedTitle => 'تم تعديل الرصيد في المسار';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'تم تحديث الرصيد الحقيقي من $previous إلى $current $symbol.\n\nتم إنشاء معاملة تسوية الرصيد في التعقب (السجل) للحفاظ على اتساق دفتر الأستاذ.\n\n• الرصيد الحقيقي يعكس المبلغ الفعلي في هذا الحساب.\n• التحقق من التاريخ لإدخال التعديل.';
  }

  @override
  String get ok => 'نعم';

  @override
  String get categoryBalanceAdjustment => 'تعديل الرصيد';

  @override
  String get descriptionBalanceCorrection => 'تصحيح الرصيد';

  @override
  String get descriptionOpeningBalance => 'الرصيد الافتتاحي';

  @override
  String get reviewStatsModeStatistics => 'إحصائيات';

  @override
  String get reviewStatsModeComparison => 'مقارنة';

  @override
  String get statsUncategorized => 'غير مصنف';

  @override
  String get statsNoCategories => 'لا توجد فئات في الفترات المحددة للمقارنة.';

  @override
  String get statsNoTransactions => 'لا معاملات';

  @override
  String get statsSpendingInCategory => 'الإنفاق في هذه الفئة';

  @override
  String get statsIncomeInCategory => 'الدخل في هذه الفئة';

  @override
  String get statsDifference => 'الفرق (ب مقابل أ):';

  @override
  String get statsNoExpensesMonth => 'لا يوجد مصاريف هذا الشهر';

  @override
  String get statsNoExpensesAll => 'لم يتم تسجيل أي نفقات';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'لا يوجد مصاريف في الأخير $period';
  }

  @override
  String get statsTotalSpent => 'إجمالي ما تم إنفاقه';

  @override
  String get statsNoExpensesThisPeriod => 'لا توجد نفقات في هذه الفترة';

  @override
  String get statsNoIncomeMonth => 'لا يوجد دخل هذا الشهر';

  @override
  String get statsNoIncomeAll => 'لم يتم تسجيل أي دخل';

  @override
  String statsNoIncomePeriod(String period) {
    return 'لا دخل في الماضي $period';
  }

  @override
  String get statsTotalReceived => 'إجمالي المستلمة';

  @override
  String get statsNoIncomeThisPeriod => 'لا يوجد دخل في هذه الفترة';

  @override
  String get catSalary => 'مرتب';

  @override
  String get catFreelance => 'مستقل';

  @override
  String get catConsulting => 'استشارات';

  @override
  String get catGift => 'هدية';

  @override
  String get catRental => 'تأجير';

  @override
  String get catDividends => 'توزيعات الأرباح';

  @override
  String get catRefund => 'استرداد';

  @override
  String get catBonus => 'علاوة';

  @override
  String get catInterest => 'اهتمام';

  @override
  String get catSideHustle => 'صخب الجانب';

  @override
  String get catSaleOfGoods => 'بيع البضائع';

  @override
  String get catOther => 'آخر';

  @override
  String get catGroceries => 'بقالة';

  @override
  String get catDining => 'تناول الطعام';

  @override
  String get catTransport => 'ينقل';

  @override
  String get catUtilities => 'المرافق';

  @override
  String get catHousing => 'السكن';

  @override
  String get catHealthcare => 'الرعاية الصحية';

  @override
  String get catEntertainment => 'ترفيه';

  @override
  String get catShopping => 'التسوق';

  @override
  String get catTravel => 'يسافر';

  @override
  String get catEducation => 'تعليم';

  @override
  String get catSubscriptions => 'الاشتراكات';

  @override
  String get catInsurance => 'تأمين';

  @override
  String get catFuel => 'وقود';

  @override
  String get catGym => 'نادي رياضي';

  @override
  String get catPets => 'حيوانات أليفة';

  @override
  String get catKids => 'أطفال';

  @override
  String get catCharity => 'صدقة';

  @override
  String get catCoffee => 'قهوة';

  @override
  String get catGifts => 'الهدايا';

  @override
  String semanticsProjectionDate(String date) {
    return 'تاريخ العرض $date. انقر مرّتين لاختيار التاريخ';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'الرصيد الشخصي المتوقع $amount';
  }

  @override
  String get statsEmptyTitle => 'لا توجد معاملات حتى الآن';

  @override
  String get statsEmptySubtitle => 'لا توجد بيانات الإنفاق للنطاق المحدد.';

  @override
  String get semanticsShowProjections => 'عرض الأرصدة المتوقعة حسب الحساب';

  @override
  String get semanticsHideProjections => 'إخفاء الأرصدة المتوقعة حسب الحساب';

  @override
  String get semanticsDateAllTime => 'التاريخ: طوال الوقت — انقر لتغيير الوضع';

  @override
  String semanticsDateMode(String mode) {
    return 'التاريخ: $mode — انقر لتغيير الوضع';
  }

  @override
  String get semanticsDateThisMonth =>
      'التاريخ: هذا الشهر - اضغط على الشهر أو الأسبوع أو السنة أو كل الأوقات';

  @override
  String get semanticsTxTypeCycle =>
      'نوع المعاملة: دورة الكل، الدخل، النفقات، التحويل';

  @override
  String get semanticsAccountFilter => 'مرشح الحساب';

  @override
  String get semanticsAlreadyFiltered => 'تمت تصفيته بالفعل لهذا الحساب';

  @override
  String get semanticsCategoryFilter => 'مرشح الفئة';

  @override
  String get semanticsSortToggle =>
      'الفرز: قم بالتبديل بين الأحدث والأقدم أولاً';

  @override
  String get semanticsFiltersDisabled =>
      'تم تعطيل عوامل تصفية القائمة أثناء عرض تاريخ العرض المستقبلي. توقعات واضحة لاستخدام المرشحات.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'تم تعطيل عوامل تصفية القائمة. أضف حسابًا أولاً.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'تم تعطيل عوامل تصفية القائمة. أضف معاملة مخططة أولاً.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'تم تعطيل عوامل تصفية القائمة. قم بتسجيل المعاملة أولاً.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'تم تعطيل ضوابط القسم والعملة. أضف حسابًا أولاً.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'تم تعطيل تاريخ الإسقاط وتفاصيل الرصيد. أضف حسابًا ومعاملة مخططة أولاً.';

  @override
  String get semanticsReorderAccountHint =>
      'اضغط لفترة طويلة، ثم اسحب لإعادة الترتيب داخل هذه المجموعة';

  @override
  String get semanticsChartStyle => 'نمط الرسم البياني';

  @override
  String get semanticsChartStyleUnavailable =>
      'نمط الرسم البياني (غير متوفر في وضع المقارنة)';

  @override
  String semanticsPeriod(String label) {
    return 'الفترة: $label';
  }

  @override
  String get trackSearchHint => 'وصف البحث والفئة والحساب ...';

  @override
  String get trackSearchClear => 'مسح البحث';

  @override
  String get settingsExchangeRatesTitle => 'أسعار الصرف';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'آخر تحديث: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'استخدام الأسعار غير المتصلة بالإنترنت أو المجمعة — انقر للتحديث';

  @override
  String get settingsExchangeRatesSource => 'البنك المركزي الأوروبي';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'تم تحديث أسعار الصرف';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'لا يمكن تحديث أسعار الصرف. تحقق من اتصالك.';

  @override
  String get settingsClearData => 'مسح البيانات';

  @override
  String get settingsClearDataSubtitle => 'إزالة البيانات المحددة بشكل دائم';

  @override
  String get clearDataTitle => 'مسح البيانات';

  @override
  String get clearDataTransactions => 'تاريخ المعاملات';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count المعاملات · إعادة ضبط أرصدة الحسابات إلى الصفر';
  }

  @override
  String get clearDataPlanned => 'المعاملات المخططة';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count العناصر المخططة';
  }

  @override
  String get clearDataAccounts => 'الحسابات';

  @override
  String clearDataAccountsSubtitle(int count) {
    return 'حسابات $count · يقوم أيضًا بمسح السجل والخطة';
  }

  @override
  String get clearDataCategories => 'فئات';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count الفئات · تم استبدالها بالإعدادات الافتراضية';
  }

  @override
  String get clearDataPreferences => 'التفضيلات';

  @override
  String get clearDataPreferencesSubtitle =>
      'إعادة تعيين العملة والموضوع واللغة إلى الإعدادات الافتراضية';

  @override
  String get clearDataSecurity => 'قفل التطبيق ورقم التعريف الشخصي';

  @override
  String get clearDataSecuritySubtitle =>
      'قم بتعطيل قفل التطبيق وإزالة رمز PIN';

  @override
  String get clearDataConfirmButton => 'مسح المحدد';

  @override
  String get clearDataConfirmTitle => 'لا يمكن التراجع عن هذا';

  @override
  String get clearDataConfirmBody =>
      'سيتم حذف البيانات المحددة نهائيًا. قم بتصدير نسخة احتياطية أولاً إذا كنت قد تحتاجها لاحقًا.';

  @override
  String get clearDataTypeConfirm => 'اكتب DELETE للتأكيد';

  @override
  String get clearDataTypeConfirmError => 'اكتب DELETE بالضبط للمتابعة';

  @override
  String get clearDataPinTitle => 'قم بالتأكيد باستخدام رقم التعريف الشخصي';

  @override
  String get clearDataPinBody =>
      'أدخل رقم التعريف الشخصي للتطبيق الخاص بك للسماح بهذا الإجراء.';

  @override
  String get clearDataPinIncorrect => 'رقم التعريف الشخصي غير صحيح';

  @override
  String get clearDataDone => 'تم مسح البيانات المحددة';

  @override
  String get autoBackupTitle => 'النسخ الاحتياطي اليومي التلقائي';

  @override
  String autoBackupLastAt(String date) {
    return 'آخر نسخة احتياطية $date';
  }

  @override
  String get autoBackupNeverRun => 'لا يوجد نسخة احتياطية حتى الآن';

  @override
  String get autoBackupShareTitle => 'حفظ إلى السحابة';

  @override
  String get autoBackupShareSubtitle =>
      'قم بتحميل أحدث نسخة احتياطية إلى iCloud Drive أو Google Drive أو أي تطبيق';

  @override
  String get autoBackupCloudReminder =>
      'النسخ الاحتياطي التلقائي جاهز - احفظه على السحابة للحماية خارج الجهاز';

  @override
  String get autoBackupCloudReminderAction => 'يشارك';

  @override
  String get persistenceErrorReloaded =>
      'تعذر حفظ التغييرات. تم إعادة تحميل البيانات من التخزين.';
}
