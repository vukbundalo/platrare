// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'प्लाटरे';

  @override
  String get navPlan => 'योजना';

  @override
  String get navTrack => 'रास्ता';

  @override
  String get navReview => 'समीक्षा';

  @override
  String get cancel => 'रद्द करना';

  @override
  String get delete => 'मिटाना';

  @override
  String get close => 'बंद करना';

  @override
  String get add => 'जोड़ना';

  @override
  String get undo => 'पूर्ववत';

  @override
  String get confirm => 'पुष्टि करना';

  @override
  String get restore => 'पुनर्स्थापित करना';

  @override
  String get heroIn => 'में';

  @override
  String get heroOut => 'बाहर';

  @override
  String get heroNet => 'जाल';

  @override
  String get heroBalance => 'संतुलन';

  @override
  String get realBalance => 'वास्तविक संतुलन';

  @override
  String get settingsHideHeroBalancesTitle =>
      'सारांश कार्डों में शेष राशि छुपाएं';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'जब चालू हो, तो योजना, ट्रैक और समीक्षा में राशियां छुपी रहती हैं जब तक आप प्रत्येक टैब पर आंख के आइकन को टैप नहीं करते। जब बंद हो, तो शेष राशि हमेशा दिखती हैं।';

  @override
  String get heroBalancesShow => 'शेष राशि दिखाएं';

  @override
  String get heroBalancesHide => 'शेष राशि छुपाएं';

  @override
  String get semanticsHeroBalanceHidden => 'गोपनीयता के लिए शेष राशि छुपी है';

  @override
  String get heroResetButton => 'रीसेट करें';

  @override
  String get fabScrollToTop => 'ऊपर जाएं';

  @override
  String get fabPickProjectionDate => 'Choose projection date';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterAllAccounts => 'सभी खाते';

  @override
  String get filterAllCategories => 'सभी श्रेणियां';

  @override
  String get txLabelIncome => 'आय';

  @override
  String get txLabelExpense => 'व्यय';

  @override
  String get txLabelInvoice => 'चालान';

  @override
  String get txLabelBill => 'बिल';

  @override
  String get txLabelAdvance => 'अग्रिम';

  @override
  String get txLabelSettlement => 'निपटान';

  @override
  String get txLabelLoan => 'ऋृण';

  @override
  String get txLabelCollection => 'संग्रह';

  @override
  String get txLabelOffset => 'ओफ़्सेट';

  @override
  String get txLabelTransfer => 'स्थानांतरण';

  @override
  String get txLabelTransaction => 'लेन-देन';

  @override
  String get repeatNone => 'कोई दोहराना नहीं';

  @override
  String get repeatDaily => 'दैनिक';

  @override
  String get repeatWeekly => 'साप्ताहिक';

  @override
  String get repeatMonthly => 'महीने के';

  @override
  String get repeatYearly => 'सालाना';

  @override
  String get repeatEveryLabel => 'प्रत्येक';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: 'दिन',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सप्ताह',
      one: 'सप्ताह',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महीने',
      one: 'महीना',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count साल',
      one: 'साल',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'समाप्त होता है';

  @override
  String get repeatEndNever => 'कभी नहीं';

  @override
  String get repeatEndOnDate => 'दिनांक पर';

  @override
  String repeatEndAfterCount(int count) {
    return '$count बार के बाद';
  }

  @override
  String get repeatEndAfterChoice => 'कई बार के बाद';

  @override
  String get repeatEndPickDate => 'समाप्ति तिथि चुनें';

  @override
  String get repeatEndTimes => 'टाइम्स';

  @override
  String repeatSummaryEvery(String unit) {
    return 'हर $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return '$date तक';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count बार';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$total में से $remaining शेष';
  }

  @override
  String get detailRepeatEvery => 'प्रत्येक को दोहराएँ';

  @override
  String get detailEnds => 'समाप्त होता है';

  @override
  String get detailEndsNever => 'कभी नहीं';

  @override
  String detailEndsOnDate(String date) {
    return '$date पर';
  }

  @override
  String detailEndsAfterCount(int count) {
    return '$count बार के बाद';
  }

  @override
  String get detailProgress => 'प्रगति';

  @override
  String get weekendNoChange => 'कोई परिवर्तन नहीं होता है';

  @override
  String get weekendFriday => 'शुक्रवार को जाएँ';

  @override
  String get weekendMonday => 'सोमवार की ओर बढ़ें';

  @override
  String weekendQuestion(String day) {
    return 'यदि $day सप्ताहांत पर पड़ता है?';
  }

  @override
  String get dateToday => 'आज';

  @override
  String get dateTomorrow => 'कल';

  @override
  String get dateYesterday => 'कल';

  @override
  String get statsAllTime => 'पूरे समय';

  @override
  String get accountGroupPersonal => 'निजी';

  @override
  String get accountGroupIndividual => 'व्यक्ति';

  @override
  String get accountGroupEntity => 'इकाई';

  @override
  String get accountSectionIndividuals => 'व्यक्तियों';

  @override
  String get accountSectionEntities => 'इकाइयां,';

  @override
  String get emptyNoTransactionsYet => 'अभी तक कोई लेन-देन नहीं';

  @override
  String get emptyNoAccountsYet => 'अभी तक कोई खाता नहीं';

  @override
  String get emptyRecordFirstTransaction =>
      'अपना पहला लेनदेन रिकॉर्ड करने के लिए नीचे दिए गए बटन पर टैप करें।';

  @override
  String get emptyAddFirstAccountTx =>
      'लेनदेन रिकॉर्ड करने से पहले अपना पहला खाता जोड़ें।';

  @override
  String get emptyAddFirstAccountPlan =>
      'लेन-देन की योजना बनाने से पहले अपना पहला खाता जोड़ें।';

  @override
  String get emptyAddFirstAccountReview =>
      'अपने वित्त पर नज़र रखने के लिए अपना पहला खाता जोड़ें।';

  @override
  String get emptyAddTransaction => 'लेन-देन जोड़ें';

  @override
  String get emptyAddAccount => 'खाता जोड़ें';

  @override
  String get reviewEmptyGroupPersonalTitle => 'अभी तक कोई व्यक्तिगत खाता नहीं';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'व्यक्तिगत खाते आपके अपने बटुए और बैंक खाते हैं। रोजमर्रा की आय और खर्च पर नज़र रखने के लिए एक जोड़ें।';

  @override
  String get reviewEmptyGroupIndividualsTitle =>
      'अभी तक कोई व्यक्तिगत खाता नहीं';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'व्यक्तिगत खाते विशिष्ट लोगों-साझा लागत, ऋण, या IOUs के साथ धन को ट्रैक करते हैं। प्रत्येक व्यक्ति के लिए एक खाता जोड़ें जिसके साथ आप समझौता करते हैं।';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'अभी तक कोई इकाई खाता नहीं है';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'इकाई खाते व्यवसायों, परियोजनाओं या संगठनों के लिए हैं। व्यावसायिक नकदी प्रवाह को अपने व्यक्तिगत वित्त से अलग रखने के लिए उनका उपयोग करें।';

  @override
  String get emptyNoTransactionsForFilters =>
      'लागू फ़िल्टर के लिए कोई लेन-देन नहीं';

  @override
  String get emptyNoTransactionsInHistory => 'इतिहास में कोई लेन-देन नहीं';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return '$month के लिए कोई लेनदेन नहीं';
  }

  @override
  String get emptyNoTransactionsForAccount => 'इस खाते के लिए कोई लेनदेन नहीं';

  @override
  String get trackTransactionDeleted => 'लेन-देन हटा दिया गया';

  @override
  String get trackDeleteTitle => 'लेन-देन हटाएँ?';

  @override
  String get trackDeleteBody => 'इससे खाते की शेष राशि में परिवर्तन उलट जाएगा।';

  @override
  String get trackTransaction => 'लेन-देन';

  @override
  String get planConfirmTitle => 'लेनदेन की पुष्टि करें?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'यह घटना $date के लिए निर्धारित है। यह आज की तारीख ($todayDate) के साथ इतिहास में दर्ज हो जाएगा। अगली घटना $nextDate पर बनी हुई है।';
  }

  @override
  String get planConfirmBodyNormal =>
      'यह लेनदेन को आपके वास्तविक खाते की शेष राशि पर लागू करेगा और इसे इतिहास में ले जाएगा।';

  @override
  String get planTransactionConfirmed =>
      'लेन-देन की पुष्टि की गई और आवेदन किया गया';

  @override
  String get planTransactionRemoved => 'नियोजित लेन-देन हटा दिया गया';

  @override
  String get planRepeatingTitle => 'बार-बार लेन-देन';

  @override
  String get planRepeatingBody =>
      'केवल इस तिथि को छोड़ें—श्रृंखला अगली घटना के साथ जारी रहती है—या अपनी योजना से प्रत्येक शेष घटना को हटा दें।';

  @override
  String get planDeleteAll => 'सभी हटा दो';

  @override
  String get planSkipThisOnly => 'इसे ही छोड़ दें';

  @override
  String get planOccurrenceSkipped =>
      'यह घटना छोड़ दी गई - अगली घटना शेड्यूल की गई';

  @override
  String get planNothingPlanned => 'फिलहाल कुछ भी योजना नहीं बनाई गई है';

  @override
  String get planPlanBody => 'आगामी लेनदेन की योजना बनाएं.';

  @override
  String get planAddPlan => 'योजना जोड़ें';

  @override
  String get planNoPlannedForFilters =>
      'लागू फ़िल्टर के लिए कोई नियोजित लेनदेन नहीं';

  @override
  String planNoPlannedInMonth(String month) {
    return '$month में कोई नियोजित लेनदेन नहीं';
  }

  @override
  String get planOverdue => 'अतिदेय';

  @override
  String get planPlannedTransaction => 'नियोजित लेन-देन';

  @override
  String get discardTitle => 'परिवर्तनों को निरस्त करें?';

  @override
  String get discardBody =>
      'आपके पास सहेजे नहीं गए परिवर्तन हैं. यदि आप अभी चले गए तो वे खो जाएंगे।';

  @override
  String get keepEditing => 'संपादन करते रहें';

  @override
  String get discard => 'खारिज करें';

  @override
  String get newTransactionTitle => 'नया लेन-देन';

  @override
  String get editTransactionTitle => 'लेन-देन संपादित करें';

  @override
  String get transactionUpdated => 'लेन-देन अद्यतन किया गया';

  @override
  String get sectionAccounts => 'हिसाब किताब';

  @override
  String get labelFrom => 'से';

  @override
  String get labelTo => 'को';

  @override
  String get sectionCategory => 'वर्ग';

  @override
  String get sectionAttachments => 'संलग्नक';

  @override
  String get labelNote => 'टिप्पणी';

  @override
  String get hintOptionalDescription => 'वैकल्पिक विवरण';

  @override
  String get updateTransaction => 'लेन-देन अद्यतन करें';

  @override
  String get saveTransaction => 'लेन-देन सहेजें';

  @override
  String get selectAccount => 'खाता चुनें';

  @override
  String get selectAccountTitle => 'खाता चुनें';

  @override
  String get noAccountsAvailable => 'कोई खाता उपलब्ध नहीं';

  @override
  String amountReceivedBy(String name, String currency) {
    return '$name द्वारा प्राप्त राशि ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'गंतव्य खाते को प्राप्त होने वाली सटीक राशि दर्ज करें। यह प्रयुक्त वास्तविक विनिमय दर को लॉक कर देता है।';

  @override
  String get attachTakePhoto => 'फोटो लो';

  @override
  String get attachTakePhotoSub =>
      'रसीद कैप्चर करने के लिए कैमरे का उपयोग करें';

  @override
  String get attachChooseGallery => 'गैलरी से चयन करो';

  @override
  String get attachChooseGallerySub => 'अपनी लाइब्रेरी से फ़ोटो चुनें';

  @override
  String get attachBrowseFiles => 'फ़ाइलों को ब्राउज़ करें';

  @override
  String get attachBrowseFilesSub =>
      'पीडीएफ़, दस्तावेज़ या अन्य फ़ाइलें संलग्न करें';

  @override
  String get attachButton => 'संलग्न करना';

  @override
  String get editPlanTitle => 'योजना संपादित करें';

  @override
  String get planTransactionTitle => 'लेन-देन की योजना बनाएं';

  @override
  String get tapToSelect => 'चुनने के लिए टैप करें';

  @override
  String get updatePlan => 'अद्यतन योजना';

  @override
  String get addToPlan => 'योजना में जोड़ें';

  @override
  String get labelRepeat => 'दोहराना';

  @override
  String get selectPlannedDate => 'नियोजित तिथि चुनें';

  @override
  String get balancesAsOfToday => 'आज तक शेष';

  @override
  String get projectedBalancesForTomorrow => 'कल के लिए अनुमानित शेष राशि';

  @override
  String projectedBalancesForDate(String date) {
    return '$date के लिए अनुमानित शेष';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name प्राप्त करता है ($currency)';
  }

  @override
  String get destHelper =>
      'अनुमानित गंतव्य राशि. पुष्टिकरण पर सटीक दर लॉक कर दी जाती है।';

  @override
  String get descriptionOptional => 'विवरण (वैकल्पिक)';

  @override
  String get detailTransactionTitle => 'लेन-देन';

  @override
  String get detailPlannedTitle => 'की योजना बनाई';

  @override
  String get detailConfirmTransaction => 'लेन-देन की पुष्टि करें';

  @override
  String get detailDate => 'तारीख';

  @override
  String get detailFrom => 'से';

  @override
  String get detailTo => 'को';

  @override
  String get detailCategory => 'वर्ग';

  @override
  String get detailNote => 'टिप्पणी';

  @override
  String get detailDestinationAmount => 'गंतव्य राशि';

  @override
  String get detailExchangeRate => 'विनिमय दर';

  @override
  String get detailRepeats => 'पुनर्प्रसारण';

  @override
  String get detailDayOfMonth => 'महीने का दिन';

  @override
  String get detailWeekends => 'सप्ताहांत';

  @override
  String get detailAttachments => 'संलग्नक';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें',
      one: '1 फ़ाइल',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsSectionDisplay => 'प्रदर्शन';

  @override
  String get settingsSectionLanguage => 'भाषा';

  @override
  String get settingsSectionCategories => 'श्रेणियाँ';

  @override
  String get settingsSectionAccounts => 'हिसाब किताब';

  @override
  String get settingsSectionPreferences => 'प्राथमिकताएँ';

  @override
  String get settingsSectionManage => 'प्रबंधित करना';

  @override
  String get settingsBaseCurrency => 'घरेलू मुद्रा';

  @override
  String get settingsSecondaryCurrency => 'द्वितीयक मुद्रा';

  @override
  String get settingsCategories => 'श्रेणियाँ';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount आय · $expenseCount व्यय';
  }

  @override
  String get settingsArchivedAccounts => 'संग्रहीत खाते';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'अभी कोई नहीं - शेष राशि स्पष्ट होने पर खाते से संग्रह संपादित करें';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count समीक्षा और पिकर से छिपा हुआ';
  }

  @override
  String get settingsSectionData => 'डेटा';

  @override
  String get settingsSectionPrivacy => 'के बारे में';

  @override
  String get settingsPrivacyPolicyTitle => 'गोपनीयता नीति';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'प्लाटारे आपके डेटा को कैसे संभालता है।';

  @override
  String get settingsPrivacyFxDisclosure =>
      'विनिमय दरें: ऐप इंटरनेट पर सार्वजनिक मुद्रा दरें प्राप्त करता है। आपके खाते और लेन-देन कभी नहीं भेजे जाते.';

  @override
  String get settingsPrivacyOpenFailed => 'गोपनीयता नीति लोड नहीं की जा सकी.';

  @override
  String get settingsPrivacyRetry => 'पुनः प्रयास करें';

  @override
  String get settingsSoftwareVersionTitle => 'सॉफ़्टवेयर संस्करण';

  @override
  String get settingsSoftwareVersionSubtitle => 'रिहाई, निदान और कानूनी';

  @override
  String get aboutScreenTitle => 'के बारे में';

  @override
  String get aboutAppTagline =>
      'एक ही कार्यक्षेत्र में खाता बही, नकदी प्रवाह और योजना।';

  @override
  String get aboutDescriptionBody =>
      'प्लैटरेरे आपके डिवाइस पर खाते, लेनदेन और योजनाएं रखता है। जब आपको कहीं और प्रतिलिपि की आवश्यकता हो तो एन्क्रिप्टेड बैकअप निर्यात करें। विनिमय दरें केवल सार्वजनिक बाज़ार डेटा का उपयोग करती हैं; आपका खाता-बही अपलोड नहीं है.';

  @override
  String get aboutVersionLabel => 'संस्करण';

  @override
  String get aboutBuildLabel => 'निर्माण';

  @override
  String get aboutCopySupportDetails => 'समर्थन विवरण कॉपी करें';

  @override
  String get aboutOpenPrivacySubtitle =>
      'संपूर्ण इन-ऐप नीति दस्तावेज़ खोलता है.';

  @override
  String get aboutSupportBundleLocaleLabel => 'स्थान';

  @override
  String get settingsSupportInfoCopied => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get settingsVerifyLedger => 'डेटा सत्यापित करें';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'जांचें कि खाते की शेष राशि आपके लेनदेन इतिहास से मेल खाती है';

  @override
  String get settingsDataExportTitle => 'बैकअप निर्यात करें';

  @override
  String get settingsDataExportSubtitle =>
      'सभी डेटा और अनुलग्नकों के साथ .zip या एन्क्रिप्टेड .platrare के रूप में सहेजें';

  @override
  String get settingsDataImportTitle => 'बैकअप से पुनर्स्थापित करें';

  @override
  String get settingsDataImportSubtitle =>
      'वर्तमान डेटा को प्लैटरे .zip या .platrare बैकअप से बदलें';

  @override
  String get backupExportDialogTitle => 'इस बैकअप को सुरक्षित रखें';

  @override
  String get backupExportDialogBody =>
      'एक मजबूत पासवर्ड की अनुशंसा की जाती है, खासकर यदि आप फ़ाइल को क्लाउड में संग्रहीत करते हैं। आयात करने के लिए आपको वही पासवर्ड चाहिए.';

  @override
  String get backupExportPasswordLabel => 'पासवर्ड';

  @override
  String get backupExportPasswordConfirmLabel => 'पासवर्ड की पुष्टि कीजिये';

  @override
  String get backupExportPasswordMismatch => 'सांकेतिक शब्द मेल नहीं खाते';

  @override
  String get backupExportPasswordEmpty =>
      'एक मेल खाता पासवर्ड दर्ज करें, या नीचे एन्क्रिप्शन के बिना निर्यात करें।';

  @override
  String get backupExportPasswordTooShort =>
      'पासवर्ड कम से कम 8 वर्णों का होना चाहिए।';

  @override
  String get backupExportSaveToDevice => 'डिवाइस में सहेजें';

  @override
  String get backupExportShareToCloud => 'साझा करें (आईक्लाउड, ड्राइव…)';

  @override
  String get backupExportWithoutEncryption =>
      'एन्क्रिप्शन के बिना निर्यात करें';

  @override
  String get backupExportSkipWarningTitle =>
      'एन्क्रिप्शन के बिना निर्यात करें?';

  @override
  String get backupExportSkipWarningBody =>
      'फ़ाइल तक पहुंच रखने वाला कोई भी व्यक्ति आपका डेटा पढ़ सकता है। इसका उपयोग केवल उन स्थानीय प्रतियों के लिए करें जिन्हें आप नियंत्रित करते हैं।';

  @override
  String get backupExportSkipWarningConfirm => 'अनएन्क्रिप्टेड निर्यात करें';

  @override
  String get backupImportPasswordTitle => 'एन्क्रिप्टेड बैकअप';

  @override
  String get backupImportPasswordBody =>
      'वह पासवर्ड दर्ज करें जिसका उपयोग आपने निर्यात करते समय किया था।';

  @override
  String get backupImportPasswordLabel => 'पासवर्ड';

  @override
  String get backupImportPreviewTitle => 'बैकअप सारांश';

  @override
  String backupImportPreviewVersion(String version) {
    return 'ऐप संस्करण: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'निर्यातित: $date';
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
    return '$accounts खाते · $transactions लेनदेन · $planned योजनाबद्ध · $attachments अनुलग्नक फ़ाइलें · $income आय श्रेणियां · $expense व्यय श्रेणियां';
  }

  @override
  String get backupImportPreviewContinue => 'जारी रखना';

  @override
  String get settingsBackupWrongPassword => 'ग़लत पासवर्ड';

  @override
  String get settingsBackupChecksumMismatch => 'बैकअप अखंडता जांच विफल रही';

  @override
  String get settingsBackupCorruptFile => 'अमान्य या क्षतिग्रस्त बैकअप फ़ाइल';

  @override
  String get settingsBackupUnsupportedVersion =>
      'बैकअप के लिए एक नए ऐप संस्करण की आवश्यकता है';

  @override
  String get settingsDataImportConfirmTitle => 'वर्तमान डेटा बदलें?';

  @override
  String get settingsDataImportConfirmBody =>
      'यह आपके चालू खातों, लेनदेन, नियोजित लेनदेन, श्रेणियों और आयातित अनुलग्नकों को चयनित बैकअप की सामग्री से बदल देगा। इस एक्शन को वापस नहीं किया जा सकता।';

  @override
  String get settingsDataImportConfirmAction => 'डेटा बदलें';

  @override
  String get settingsDataImportDone => 'डेटा सफलतापूर्वक पुनर्स्थापित किया गया';

  @override
  String get settingsDataImportInvalidFile =>
      'यह फ़ाइल वैध प्लैटरे बैकअप नहीं है';

  @override
  String get settingsDataImportFailed => 'आयात विफल';

  @override
  String get settingsDataExportDoneTitle => 'बैकअप निर्यात किया गया';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'बैकअप यहां सहेजा गया:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'खुली फाइल';

  @override
  String get settingsDataExportFailed => 'निर्यात विफल';

  @override
  String get ledgerVerifyDialogTitle => 'बही सत्यापन';

  @override
  String get ledgerVerifyAllMatch => 'सभी खाते मेल खाते हैं.';

  @override
  String get ledgerVerifyMismatchesTitle => 'बेमेल';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nसंग्रहित: $stored\nपुनः चलाएँ: $replayed\nअंतर: $diff';
  }

  @override
  String get settingsLanguage => 'ऐप भाषा';

  @override
  String get settingsLanguageSubtitleSystem => 'निम्नलिखित सिस्टम सेटिंग्स';

  @override
  String get settingsLanguageSubtitleEnglish => 'अंग्रेज़ी';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'सर्बियाई (लैटिन)';

  @override
  String get settingsLanguagePickerTitle => 'ऐप भाषा';

  @override
  String get settingsLanguageOptionSystem => 'प्रणालीगत चूक';

  @override
  String get settingsLanguageOptionEnglish => 'अंग्रेज़ी';

  @override
  String get settingsLanguageOptionSerbianLatin => 'सर्बियाई (लैटिन)';

  @override
  String get settingsSectionAppearance => 'उपस्थिति';

  @override
  String get settingsSectionSecurity => 'सुरक्षा';

  @override
  String get settingsSecurityEnableLock => 'लॉक ऐप खुला';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'ऐप खुलने पर बायोमेट्रिक अनलॉक या पिन की आवश्यकता होगी';

  @override
  String get settingsSecurityLockDelayTitle =>
      'बैकग्राउंड के बाद पुनः लॉक करें';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      'ऐप कितनी देर तक स्क्रीन से दूर रह सकता है, इससे पहले कि फिर से अनलॉक की आवश्यकता हो। तुरंत सबसे मजबूत है।';

  @override
  String get settingsSecurityLockDelayImmediate => 'तुरंत';

  @override
  String get settingsSecurityLockDelay30s => '30 सेकंड';

  @override
  String get settingsSecurityLockDelay1m => '1 मिनट';

  @override
  String get settingsSecurityLockDelay5m => '5 मिनट';

  @override
  String get settingsSecuritySetPin => 'पिन सेट करें';

  @override
  String get settingsSecurityChangePin => 'पिन बदलें';

  @override
  String get settingsSecurityPinSubtitle =>
      'यदि बायोमेट्रिक अनुपलब्ध है तो फ़ॉलबैक के रूप में पिन का उपयोग करें';

  @override
  String get settingsSecurityRemovePin => 'पिन निकालें';

  @override
  String get securitySetPinTitle => 'ऐप पिन सेट करें';

  @override
  String get securityPinLabel => 'पिन कोड';

  @override
  String get securityConfirmPinLabel => 'पिन कोड की पुष्टि करें';

  @override
  String get securityPinMustBe4Digits => 'पिन में कम से कम 4 अंक होने चाहिए';

  @override
  String get securityPinMismatch => 'पिन कोड मेल नहीं खाते';

  @override
  String get securityRemovePinTitle => 'पिन निकालें?';

  @override
  String get securityRemovePinBody =>
      'यदि उपलब्ध हो तो बायोमेट्रिक अनलॉक का अभी भी उपयोग किया जा सकता है।';

  @override
  String get securityUnlockTitle => 'ऐप लॉक हो गया';

  @override
  String get securityUnlockSubtitle =>
      'फेस आईडी, फिंगरप्रिंट या पिन से अनलॉक करें।';

  @override
  String get securityUnlockWithPin => 'पिन से अनलॉक करें';

  @override
  String get securityTryBiometric => 'बायोमेट्रिक अनलॉक का प्रयास करें';

  @override
  String get securityPinIncorrect => 'ग़लत पिन, पुनः प्रयास करें';

  @override
  String get securityBiometricReason => 'अपना ऐप खोलने के लिए प्रमाणित करें';

  @override
  String get settingsTheme => 'विषय';

  @override
  String get settingsThemeSubtitleSystem => 'निम्नलिखित सिस्टम सेटिंग्स';

  @override
  String get settingsThemeSubtitleLight => 'रोशनी';

  @override
  String get settingsThemeSubtitleDark => 'अँधेरा';

  @override
  String get settingsThemePickerTitle => 'विषय';

  @override
  String get settingsThemeOptionSystem => 'प्रणालीगत चूक';

  @override
  String get settingsThemeOptionLight => 'रोशनी';

  @override
  String get settingsThemeOptionDark => 'अँधेरा';

  @override
  String get archivedAccountsTitle => 'संग्रहीत खाते';

  @override
  String get archivedAccountsEmptyTitle => 'कोई संग्रहीत खाते नहीं';

  @override
  String get archivedAccountsEmptyBody =>
      'बुक बैलेंस और ओवरड्राफ्ट शून्य होना चाहिए। समीक्षा में खाता विकल्पों में से संग्रहित करें।';

  @override
  String get categoriesTitle => 'श्रेणियाँ';

  @override
  String get newCategoryTitle => 'नई श्रेणी';

  @override
  String get categoryNameLabel => 'श्रेणी नाम';

  @override
  String get deleteCategoryTitle => 'श्रेणी हटाएँ?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" को सूची से हटा दिया जाएगा।';
  }

  @override
  String get categoryIncome => 'आय';

  @override
  String get categoryExpense => 'व्यय';

  @override
  String get categoryAdd => 'जोड़ना';

  @override
  String get searchCurrencies => 'मुद्राएँ खोजें…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3एम';

  @override
  String get period6M => '6';

  @override
  String get period1Y => '1 वर्ष';

  @override
  String get periodAll => 'सभी';

  @override
  String get categoryLabel => 'वर्ग';

  @override
  String get categoriesLabel => 'श्रेणियाँ';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type सहेजा गया • $amount';
  }

  @override
  String get tooltipSettings => 'सेटिंग्स';

  @override
  String get tooltipAddAccount => 'खाता जोड़ें';

  @override
  String get tooltipRemoveAccount => 'खाता हटाएँ';

  @override
  String get accountNameTaken =>
      'आपके पास पहले से ही इस नाम और पहचानकर्ता (सक्रिय या संग्रहीत) के साथ एक खाता है। नाम या पहचानकर्ता बदलें.';

  @override
  String get groupDescPersonal => 'आपके अपने बटुए और बैंक खाते';

  @override
  String get groupDescIndividuals => 'परिवार, दोस्त, व्यक्ति';

  @override
  String get groupDescEntities => 'संस्थाएँ, उपयोगिताएँ, संगठन';

  @override
  String get cannotArchiveTitle => 'अभी तक संग्रहित नहीं किया जा सकता';

  @override
  String get cannotArchiveBody =>
      'पुरालेख केवल तभी उपलब्ध होता है जब बुक बैलेंस और ओवरड्राफ्ट सीमा दोनों प्रभावी रूप से शून्य हों।';

  @override
  String get cannotArchiveBodyAdjust =>
      'पुरालेख केवल तभी उपलब्ध होता है जब बुक बैलेंस और ओवरड्राफ्ट सीमा दोनों प्रभावी रूप से शून्य हों। पहले बहीखाता या सुविधा को समायोजित करें.';

  @override
  String get archiveAccountTitle => 'पुरालेख खाता?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नियोजित लेनदेन इस खाते को संदर्भित करते हैं।',
      one: '1 नियोजित लेनदेन इस खाते को संदर्भित करता है।',
    );
    return '$_temp0 संग्रहीत खाते के साथ अपनी योजना सुसंगत रखने के लिए उन्हें हटाएँ।';
  }

  @override
  String get removeAndArchive => 'नियोजित एवं संग्रहित हटाएँ';

  @override
  String get archiveBody =>
      'खाता समीक्षा, ट्रैक और योजना चुनने वालों से छिपा रहेगा। आप इसे सेटिंग्स से पुनर्स्थापित कर सकते हैं।';

  @override
  String get archiveAction => 'पुरालेख';

  @override
  String get archiveInstead => 'इसके बजाय संग्रहित करें';

  @override
  String get cannotDeleteTitle => 'खाता हटाया नहीं जा सकता';

  @override
  String get cannotDeleteBodyShort =>
      'यह खाता आपके ट्रैक इतिहास में दिखाई देता है. पहले उन लेन-देन को हटाएँ या पुन: असाइन करें, या यदि शेष राशि साफ़ हो गई है तो खाते को संग्रहीत करें।';

  @override
  String get cannotDeleteBodyHistory =>
      'यह खाता आपके ट्रैक इतिहास में दिखाई देता है. हटाने से वह इतिहास टूट जाएगा—पहले उन लेन-देन को हटाएँ या पुन: असाइन करें।';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'यह खाता आपके ट्रैक इतिहास में दिखाई देता है, इसलिए इसे हटाया नहीं जा सकता। यदि बुक बैलेंस और ओवरड्राफ्ट साफ हो गया है तो आप इसे संग्रहीत कर सकते हैं - यह सूचियों से छिपा रहेगा लेकिन इतिहास बरकरार रहेगा।';

  @override
  String get deleteAccountTitle => 'खाता हटा दो?';

  @override
  String get deleteAccountBodyPermanent =>
      'यह खाता स्थायी रूप से हटा दिया जाएगा.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count नियोजित लेनदेन इस खाते को संदर्भित करते हैं और हटा दिए जाएँगे।',
      one: '1 नियोजित लेनदेन इस खाते को संदर्भित करता है और हटा दिया जाएगा।',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'सभी हटा दो';

  @override
  String get editAccountTitle => 'खाता संपादित करें';

  @override
  String get newAccountTitle => 'नया खाता';

  @override
  String get labelAccountName => 'खाता नाम';

  @override
  String get labelAccountIdentifier => 'पहचानकर्ता (वैकल्पिक)';

  @override
  String get accountAppearanceSection => 'चिह्न एवं रंग';

  @override
  String get accountPickIcon => 'आइकन चुनें';

  @override
  String get accountPickColor => 'रंग पसंद करो';

  @override
  String get accountIconSheetTitle => 'खाता चिह्न';

  @override
  String get accountColorSheetTitle => 'खाते का रंग';

  @override
  String get searchAccountIcons => 'नाम से आइकन खोजें…';

  @override
  String get accountIconSearchNoMatches => 'उस खोज से कोई आइकन मेल नहीं खाता।';

  @override
  String get accountUseInitialLetter => 'प्रारंभिक पत्र';

  @override
  String get accountUseDefaultColor => 'मिलान समूह';

  @override
  String get labelRealBalance => 'वास्तविक संतुलन';

  @override
  String get labelOverdraftLimit => 'ओवरड्राफ्ट/अग्रिम सीमा';

  @override
  String get labelCurrency => 'मुद्रा';

  @override
  String get saveChanges => 'परिवर्तनों को सुरक्षित करें';

  @override
  String get addAccountAction => 'खाता जोड़ें';

  @override
  String get removeAccountSheetTitle => 'खाता हटाएँ';

  @override
  String get deletePermanently => 'स्थायी रूप से हटाएँ';

  @override
  String get deletePermanentlySubtitle =>
      'केवल तभी संभव है जब इस खाते का उपयोग ट्रैक में नहीं किया जाता है। नियोजित आइटम को डिलीट के भाग के रूप में हटाया जा सकता है।';

  @override
  String get archiveOptionSubtitle =>
      'समीक्षा और चयनकर्ताओं से छिपाएँ। सेटिंग्स से किसी भी समय पुनर्स्थापित करें। शून्य बैलेंस और ओवरड्राफ्ट की आवश्यकता है।';

  @override
  String get archivedBannerText =>
      'यह खाता संग्रहीत है. यह आपके डेटा में रहता है लेकिन सूचियों और पिकर से छिपा रहता है।';

  @override
  String get balanceAdjustedTitle => 'ट्रैक में संतुलन समायोजित किया गया';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'वास्तविक शेष को $previous से $current $symbol तक अद्यतन किया गया था।\n\nखाता बही को सुसंगत बनाए रखने के लिए ट्रैक (इतिहास) में एक संतुलन समायोजन लेनदेन बनाया गया था।\n\n• वास्तविक शेष इस खाते में वास्तविक राशि को दर्शाता है।\n• समायोजन प्रविष्टि के लिए इतिहास की जाँच करें।';
  }

  @override
  String get ok => 'ठीक है';

  @override
  String get categoryBalanceAdjustment => 'संतुलन समायोजन';

  @override
  String get descriptionBalanceCorrection => 'संतुलन सुधार';

  @override
  String get descriptionOpeningBalance => 'प्रारंभिक जमा';

  @override
  String get reviewStatsModeStatistics => 'आंकड़े';

  @override
  String get reviewStatsModeComparison => 'तुलना';

  @override
  String get statsUncategorized => 'अवर्गीकृत';

  @override
  String get statsNoCategories =>
      'तुलना के लिए चयनित अवधियों में कोई श्रेणियां नहीं।';

  @override
  String get statsNoTransactions => 'कोई लेनदेन नहीं';

  @override
  String get statsSpendingInCategory => 'इस श्रेणी में खर्च';

  @override
  String get statsIncomeInCategory => 'इस श्रेणी में आय';

  @override
  String get statsDifference => 'अंतर (बी बनाम ए):';

  @override
  String get statsNoExpensesMonth => 'इस महीने कोई खर्च नहीं';

  @override
  String get statsNoExpensesAll => 'कोई खर्च दर्ज नहीं किया गया';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'आखिरी में कोई खर्च नहीं $period';
  }

  @override
  String get statsTotalSpent => 'कुल व्यय';

  @override
  String get statsNoExpensesThisPeriod => 'इस अवधि में कोई खर्च नहीं';

  @override
  String get statsNoIncomeMonth => 'इस महीने कोई आय नहीं';

  @override
  String get statsNoIncomeAll => 'कोई आय दर्ज नहीं की गई';

  @override
  String statsNoIncomePeriod(String period) {
    return 'पिछले $period में कोई आय नहीं';
  }

  @override
  String get statsTotalReceived => 'कुल प्राप्त हुआ';

  @override
  String get statsNoIncomeThisPeriod => 'इस अवधि में कोई आय नहीं';

  @override
  String get catSalary => 'वेतन';

  @override
  String get catFreelance => 'फ्रीलांस';

  @override
  String get catConsulting => 'CONSULTING';

  @override
  String get catGift => 'उपहार';

  @override
  String get catRental => 'किराये';

  @override
  String get catDividends => 'लाभांश';

  @override
  String get catRefund => 'धनवापसी';

  @override
  String get catBonus => 'बोनस';

  @override
  String get catInterest => 'दिलचस्पी';

  @override
  String get catSideHustle => 'पार्श्व ऊधम';

  @override
  String get catSaleOfGoods => 'माल की बिक्री';

  @override
  String get catOther => 'अन्य';

  @override
  String get catGroceries => 'किराने का सामान';

  @override
  String get catDining => 'भोजन';

  @override
  String get catTransport => 'परिवहन';

  @override
  String get catUtilities => 'उपयोगिताओं';

  @override
  String get catHousing => 'आवास';

  @override
  String get catHealthcare => 'स्वास्थ्य देखभाल';

  @override
  String get catEntertainment => 'मनोरंजन';

  @override
  String get catShopping => 'खरीदारी';

  @override
  String get catTravel => 'यात्रा';

  @override
  String get catEducation => 'शिक्षा';

  @override
  String get catSubscriptions => 'सदस्यता';

  @override
  String get catInsurance => 'बीमा';

  @override
  String get catFuel => 'ईंधन';

  @override
  String get catGym => 'जिम';

  @override
  String get catPets => 'पालतू जानवर';

  @override
  String get catKids => 'बच्चे';

  @override
  String get catCharity => 'दान';

  @override
  String get catCoffee => 'कॉफी';

  @override
  String get catGifts => 'उपहार';

  @override
  String semanticsProjectionDate(String date) {
    return 'प्रक्षेपण तिथि $date. तारीख चुनने के लिए दो बार टैप करें';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'अनुमानित व्यक्तिगत संतुलन $amount';
  }

  @override
  String get statsEmptyTitle => 'अभी तक कोई लेन-देन नहीं';

  @override
  String get statsEmptySubtitle => 'चयनित सीमा के लिए कोई व्यय डेटा नहीं।';

  @override
  String get semanticsShowProjections => 'खाते के अनुसार अनुमानित शेष दिखाएं';

  @override
  String get semanticsHideProjections => 'खाते द्वारा अनुमानित शेष छिपाएँ';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Show account balances for this day';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Hide account balances for this day';

  @override
  String get semanticsDateAllTime =>
      'दिनांक: हर समय - मोड बदलने के लिए टैप करें';

  @override
  String semanticsDateMode(String mode) {
    return 'दिनांक: $mode - मोड बदलने के लिए टैप करें';
  }

  @override
  String get semanticsDateThisMonth =>
      'दिनांक: इस महीने - महीने, सप्ताह, वर्ष या सभी समय के लिए टैप करें';

  @override
  String get semanticsTxTypeCycle =>
      'लेन-देन का प्रकार: चक्र सभी, आय, व्यय, स्थानांतरण';

  @override
  String get semanticsAccountFilter => 'खाता फ़िल्टर';

  @override
  String get semanticsAlreadyFiltered =>
      'इस खाते पर पहले ही फ़िल्टर कर दिया गया है';

  @override
  String get semanticsCategoryFilter => 'श्रेणी फ़िल्टर';

  @override
  String get semanticsSortToggle =>
      'क्रमबद्ध करें: सबसे पहले नवीनतम या सबसे पुराना टॉगल करें';

  @override
  String get semanticsFiltersDisabled =>
      'भविष्य की प्रक्षेपण तिथि देखते समय सूची फ़िल्टर अक्षम कर दिए गए। फ़िल्टर का उपयोग करने के लिए स्पष्ट अनुमान।';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'सूची फ़िल्टर अक्षम. पहले एक खाता जोड़ें.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'सूची फ़िल्टर अक्षम. पहले एक नियोजित लेनदेन जोड़ें.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'सूची फ़िल्टर अक्षम. पहले लेन-देन रिकॉर्ड करें.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'अनुभाग और मुद्रा नियंत्रण अक्षम किया गया. पहले एक खाता जोड़ें.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'प्रक्षेपण तिथि और शेष राशि विच्छेद अक्षम। पहले एक खाता और एक नियोजित लेनदेन जोड़ें।';

  @override
  String get semanticsReorderAccountHint =>
      'देर तक दबाएँ, फिर इस समूह में पुनः व्यवस्थित करने के लिए खींचें';

  @override
  String get semanticsChartStyle => 'चार्ट शैली';

  @override
  String get semanticsChartStyleUnavailable =>
      'चार्ट शैली (तुलना मोड में अनुपलब्ध)';

  @override
  String semanticsPeriod(String label) {
    return 'अवधि: $label';
  }

  @override
  String get trackSearchHint => 'विवरण, श्रेणी, खाता खोजें...';

  @override
  String get trackSearchClear => 'स्पष्ट खोज';

  @override
  String get settingsExchangeRatesTitle => 'विनिमय दरें';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'अंतिम अद्यतन: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'ऑफ़लाइन या बंडल दरों का उपयोग करना - ताज़ा करने के लिए टैप करें';

  @override
  String get settingsExchangeRatesSource => 'ईसीबी';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'विनिमय दरें अद्यतन की गईं';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'विनिमय दरें अपडेट नहीं की जा सकीं. अपना कनेक्शन जांचें.';

  @override
  String get settingsClearData => 'स्पष्ट डेटा';

  @override
  String get settingsClearDataSubtitle => 'चयनित डेटा को स्थायी रूप से हटा दें';

  @override
  String get clearDataTitle => 'स्पष्ट डेटा';

  @override
  String get clearDataTransactions => 'ट्रांजेक्शन इतिहास';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count लेनदेन · खाता शेष शून्य पर रीसेट हो गया';
  }

  @override
  String get clearDataPlanned => 'नियोजित लेनदेन';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count नियोजित आइटम';
  }

  @override
  String get clearDataAccounts => 'हिसाब किताब';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count खाते · इतिहास और योजना को भी साफ़ करता है';
  }

  @override
  String get clearDataCategories => 'श्रेणियाँ';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count श्रेणियां · डिफ़ॉल्ट के साथ बदल दी गईं';
  }

  @override
  String get clearDataPreferences => 'प्राथमिकताएँ';

  @override
  String get clearDataPreferencesSubtitle =>
      'मुद्रा, थीम और भाषा को डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get clearDataSecurity => 'ऐप लॉक और पिन';

  @override
  String get clearDataSecuritySubtitle => 'ऐप लॉक अक्षम करें और पिन हटा दें';

  @override
  String get clearDataConfirmButton => 'चयनित साफ़ करें';

  @override
  String get clearDataConfirmTitle => 'इसे असंपादित नहीं किया जा सकता है';

  @override
  String get clearDataConfirmBody =>
      'चयनित डेटा स्थायी रूप से हटा दिया जाएगा. यदि आपको बाद में इसकी आवश्यकता हो तो पहले बैकअप निर्यात करें।';

  @override
  String get clearDataTypeConfirm => 'पुष्टि करने के लिए DELETE टाइप करें';

  @override
  String get clearDataTypeConfirmError =>
      'जारी रखने के लिए बिल्कुल DELETE टाइप करें';

  @override
  String get clearDataPinTitle => 'पिन से पुष्टि करें';

  @override
  String get clearDataPinBody =>
      'इस कार्रवाई को अधिकृत करने के लिए अपना ऐप पिन दर्ज करें।';

  @override
  String get clearDataPinIncorrect => 'ग़लत पिन';

  @override
  String get clearDataDone => 'चयनित डेटा साफ़ किया गया';

  @override
  String get autoBackupTitle => 'स्वचालित दैनिक बैकअप';

  @override
  String autoBackupLastAt(String date) {
    return 'अंतिम बैकअप $date';
  }

  @override
  String get autoBackupNeverRun => 'अभी तक कोई बैकअप नहीं है';

  @override
  String get autoBackupShareTitle => 'क्लाउड में सहेजें';

  @override
  String get autoBackupShareSubtitle =>
      'iCloud Drive, Google Drive या किसी ऐप पर नवीनतम बैकअप अपलोड करें';

  @override
  String get autoBackupCloudReminder =>
      'ऑटो-बैकअप तैयार - ऑफ-डिवाइस सुरक्षा के लिए इसे क्लाउड पर सहेजें';

  @override
  String get autoBackupCloudReminderAction => 'शेयर करें';

  @override
  String get settingsBackupReminderTitle => 'बैकअप अनुस्मारक';

  @override
  String get settingsBackupReminderSubtitle =>
      'इन-ऐप बैनर यदि आप मैन्युअल बैकअप एक्सपोर्ट किए बिना कई लेनदेन जोड़ते हैं।';

  @override
  String get settingsBackupReminderThresholdTitle => 'लेनदेन थ्रेशोल्ड';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return 'आपके अंतिम मैन्युअल एक्सपोर्ट के बाद $count नए लेनदेन के बाद याद दिलाएं।';
  }

  @override
  String get settingsBackupReminderThresholdInvalid =>
      '1 से 500 तक एक पूर्ण संख्या दर्ज करें।';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '\"बाद में याद दिलाएं\" बैनर को तब तक छुपाता है जब तक आप $n और लेनदेन नहीं जोड़ते।';
  }

  @override
  String get backupReminderBannerTitle => 'बैकअप एक्सपोर्ट करें?';

  @override
  String backupReminderBannerBody(int count) {
    return 'आपने अपने अंतिम मैन्युअल एक्सपोर्ट के बाद $count लेनदेन जोड़े हैं।';
  }

  @override
  String get backupReminderRemindLater => 'बाद में याद दिलाएं';

  @override
  String get backupExportLedgerVerifyTitle => 'Ledger check before backup';

  @override
  String get backupExportLedgerVerifyInfo =>
      'This compares each account’s stored balance to a full replay of your history. You can export a backup either way; mismatches are informational.';

  @override
  String get backupExportLedgerVerifyContinue => 'Continue to backup';

  @override
  String get persistenceErrorReloaded =>
      'परिवर्तन सहेजे नहीं जा सके. डेटा को स्टोरेज से पुनः लोड किया गया था।';
}
