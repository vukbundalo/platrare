// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Platrare';

  @override
  String get navPlan => 'Planı';

  @override
  String get navTrack => 'İzlemek';

  @override
  String get navReview => 'Gözden geçirmek';

  @override
  String get cancel => 'İptal etmek';

  @override
  String get delete => 'Silmek';

  @override
  String get close => 'Kapalı';

  @override
  String get add => 'Eklemek';

  @override
  String get undo => 'Geri al';

  @override
  String get confirm => 'Onaylamak';

  @override
  String get restore => 'Eski haline getirmek';

  @override
  String get heroIn => 'İçinde';

  @override
  String get heroOut => 'Dışarı';

  @override
  String get heroNet => 'Açık';

  @override
  String get heroBalance => 'Denge';

  @override
  String get realBalance => 'Gerçek denge';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Özet kartlardaki bakiyeleri gizle';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Açıkken, Plan, Takip ve İnceleme\'deki tutarlar her sekmedeki göz simgesine dokunana kadar maskeli kalır. Kapalıyken, bakiyeler her zaman görünürdür.';

  @override
  String get heroBalancesShow => 'Bakiyeleri göster';

  @override
  String get heroBalancesHide => 'Bakiyeleri gizle';

  @override
  String get semanticsHeroBalanceHidden => 'Gizlilik için bakiye gizlendi';

  @override
  String get heroResetButton => 'Sıfırla';

  @override
  String get fabScrollToTop => 'Başa dön';

  @override
  String get filterAll => 'Tüm';

  @override
  String get filterAllAccounts => 'Tüm hesaplar';

  @override
  String get filterAllCategories => 'Tüm kategoriler';

  @override
  String get txLabelIncome => 'GELİR';

  @override
  String get txLabelExpense => 'GİDER';

  @override
  String get txLabelInvoice => 'FATURA';

  @override
  String get txLabelBill => 'FATURA';

  @override
  String get txLabelAdvance => 'İLERLEMEK';

  @override
  String get txLabelSettlement => 'YERLEŞİM';

  @override
  String get txLabelLoan => 'BORÇ';

  @override
  String get txLabelCollection => 'KOLEKSİYON';

  @override
  String get txLabelOffset => 'TELAFİ ETMEK';

  @override
  String get txLabelTransfer => 'AKTARIM';

  @override
  String get txLabelTransaction => 'İŞLEM';

  @override
  String get repeatNone => 'Tekrar yok';

  @override
  String get repeatDaily => 'Günlük';

  @override
  String get repeatWeekly => 'Haftalık';

  @override
  String get repeatMonthly => 'Aylık';

  @override
  String get repeatYearly => 'Yıllık';

  @override
  String get repeatEveryLabel => 'Her';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: 'gün',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hafta',
      one: 'hafta',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ay',
      one: 'ay',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yıl',
      one: 'yıl',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'biter';

  @override
  String get repeatEndNever => 'Asla';

  @override
  String get repeatEndOnDate => 'Tarihte';

  @override
  String repeatEndAfterCount(int count) {
    return '$count kereden sonra';
  }

  @override
  String get repeatEndAfterChoice => 'Belirli sayıda tekrar sonrasında';

  @override
  String get repeatEndPickDate => 'Bitiş tarihini seç';

  @override
  String get repeatEndTimes => 'kez';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Her $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return '$date tarihine kadar';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count kez';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining / $total kaldı';
  }

  @override
  String get detailRepeatEvery => 'Her birini tekrarla';

  @override
  String get detailEnds => 'biter';

  @override
  String get detailEndsNever => 'Asla';

  @override
  String detailEndsOnDate(String date) {
    return '$date tarihinde';
  }

  @override
  String detailEndsAfterCount(int count) {
    return '$count kereden sonra';
  }

  @override
  String get detailProgress => 'İlerlemek';

  @override
  String get weekendNoChange => 'Değişiklik yok';

  @override
  String get weekendFriday => 'Cuma gününe taşın';

  @override
  String get weekendMonday => 'Pazartesi\'ye taşın';

  @override
  String weekendQuestion(String day) {
    return '$day hafta sonuna düşerse?';
  }

  @override
  String get dateToday => 'Bugün';

  @override
  String get dateTomorrow => 'Yarın';

  @override
  String get dateYesterday => 'Dün';

  @override
  String get statsAllTime => 'Tüm zamanlar';

  @override
  String get accountGroupPersonal => 'Kişisel';

  @override
  String get accountGroupIndividual => 'Bireysel';

  @override
  String get accountGroupEntity => 'Varlık';

  @override
  String get accountSectionIndividuals => 'Bireyler';

  @override
  String get accountSectionEntities => 'Varlıklar';

  @override
  String get emptyNoTransactionsYet => 'Henüz işlem yok';

  @override
  String get emptyNoAccountsYet => 'Henüz hesap yok';

  @override
  String get emptyRecordFirstTransaction =>
      'İlk işleminizi kaydetmek için aşağıdaki düğmeye dokunun.';

  @override
  String get emptyAddFirstAccountTx =>
      'İşlemleri kaydetmeden önce ilk hesabınızı ekleyin.';

  @override
  String get emptyAddFirstAccountPlan =>
      'İşlemleri planlamadan önce ilk hesabınızı ekleyin.';

  @override
  String get emptyAddFirstAccountReview =>
      'Mali durumunuzu izlemeye başlamak için ilk hesabınızı ekleyin.';

  @override
  String get emptyAddTransaction => 'İşlem ekle';

  @override
  String get emptyAddAccount => 'Hesap ekle';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Henüz kişisel hesap yok';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Kişisel hesaplar, kendi cüzdanlarınız ve banka hesaplarınızdır. Günlük gelir ve harcamaları takip etmek için bir tane ekleyin.';

  @override
  String get reviewEmptyGroupIndividualsTitle => 'Henüz bireysel hesap yok';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Bireysel hesaplar parayı belirli kişilerle (paylaşılan maliyetler, krediler veya borç senetleri) takip eder. Anlaştığınız her kişi için bir hesap ekleyin.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Henüz varlık hesabı yok';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Varlık hesapları işletmeler, projeler veya kuruluşlar içindir. İşletmenizin nakit akışını kişisel finansmanınızdan ayrı tutmak için bunları kullanın.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Uygulanan filtreler için işlem yok';

  @override
  String get emptyNoTransactionsInHistory => 'Geçmişte işlem yok';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return '$month için işlem yok';
  }

  @override
  String get emptyNoTransactionsForAccount => 'Bu hesapta işlem yok';

  @override
  String get trackTransactionDeleted => 'İşlem silindi';

  @override
  String get trackDeleteTitle => 'İşlem silinsin mi?';

  @override
  String get trackDeleteBody =>
      'Bu, hesap bakiyesindeki değişiklikleri tersine çevirecektir.';

  @override
  String get trackTransaction => 'İşlem';

  @override
  String get planConfirmTitle => 'İşlem onaylansın mı?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Bu olay $date için planlandı. Tarihe bugünün tarihiyle ($todayDate) kaydedilecek. Bir sonraki olay $nextDate\'de kalıyor.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Bu, işlemi gerçek hesap bakiyelerinize uygulayacak ve Geçmiş\'e taşıyacaktır.';

  @override
  String get planTransactionConfirmed => 'İşlem onaylandı ve uygulandı';

  @override
  String get planTransactionRemoved => 'Planlanan işlem kaldırıldı';

  @override
  String get planRepeatingTitle => 'Tekrarlanan işlem';

  @override
  String get planRepeatingBody =>
      'Yalnızca bu tarihi atlayın; dizi bir sonraki olayla devam eder veya kalan her olayı planınızdan silin.';

  @override
  String get planDeleteAll => 'Tümünü sil';

  @override
  String get planSkipThisOnly => 'Yalnızca bunu atla';

  @override
  String get planOccurrenceSkipped =>
      'Bu olay atlandı; bir sonraki olay planlandı';

  @override
  String get planNothingPlanned => 'Şimdilik planlanmış bir şey yok';

  @override
  String get planPlanBody => 'Yaklaşan işlemleri planlayın.';

  @override
  String get planAddPlan => 'Plan ekle';

  @override
  String get planNoPlannedForFilters =>
      'Uygulanan filtreler için planlanmış işlem yok';

  @override
  String planNoPlannedInMonth(String month) {
    return '$month\'da planlanmış işlem yok';
  }

  @override
  String get planOverdue => 'vadesi geçmiş';

  @override
  String get planPlannedTransaction => 'Planlanan işlem';

  @override
  String get discardTitle => 'Değişiklikler silinsin mi?';

  @override
  String get discardBody =>
      'Kaydedilmemiş değişiklikleriniz var. Şimdi gidersen kaybolurlar.';

  @override
  String get keepEditing => 'Düzenlemeye devam et';

  @override
  String get discard => 'Vazgeç';

  @override
  String get newTransactionTitle => 'Yeni İşlem';

  @override
  String get editTransactionTitle => 'İşlemi Düzenle';

  @override
  String get transactionUpdated => 'İşlem güncellendi';

  @override
  String get sectionAccounts => 'Hesaplar';

  @override
  String get labelFrom => 'İtibaren';

  @override
  String get labelTo => 'İle';

  @override
  String get sectionCategory => 'Kategori';

  @override
  String get sectionAttachments => 'Ekler';

  @override
  String get labelNote => 'Not';

  @override
  String get hintOptionalDescription => 'İsteğe bağlı açıklama';

  @override
  String get updateTransaction => 'İşlemi Güncelle';

  @override
  String get saveTransaction => 'İşlemi Kaydet';

  @override
  String get selectAccount => 'Hesap seçin';

  @override
  String get selectAccountTitle => 'Hesap Seçin';

  @override
  String get noAccountsAvailable => 'Kullanılabilir hesap yok';

  @override
  String amountReceivedBy(String name, String currency) {
    return '$name ($currency) tarafından alınan tutar';
  }

  @override
  String get amountReceivedHelper =>
      'Hedef hesabın alacağı tam tutarı girin. Bu, kullanılan reel döviz kurunu kilitler.';

  @override
  String get attachTakePhoto => 'Fotoğraf çek';

  @override
  String get attachTakePhotoSub => 'Makbuz yakalamak için kamerayı kullanın';

  @override
  String get attachChooseGallery => 'Galeriden seç';

  @override
  String get attachChooseGallerySub => 'Kitaplığınızdan fotoğraf seçin';

  @override
  String get attachBrowseFiles => 'Dosyalara göz atın';

  @override
  String get attachBrowseFilesSub =>
      'PDF\'leri, belgeleri veya diğer dosyaları ekleyin';

  @override
  String get attachButton => 'Eklemek';

  @override
  String get editPlanTitle => 'Planı Düzenle';

  @override
  String get planTransactionTitle => 'İşlemi Planla';

  @override
  String get tapToSelect => 'Seçmek için dokunun';

  @override
  String get updatePlan => 'Planı Güncelle';

  @override
  String get addToPlan => 'Plana Ekle';

  @override
  String get labelRepeat => 'Tekrarlamak';

  @override
  String get selectPlannedDate => 'Planlanan tarihi seçin';

  @override
  String get balancesAsOfToday => 'Bugün itibariyle bakiyeler';

  @override
  String get projectedBalancesForTomorrow => 'Yarın için öngörülen bakiyeler';

  @override
  String projectedBalancesForDate(String date) {
    return '$date için tahmini bakiyeler';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name alır ($currency)';
  }

  @override
  String get destHelper =>
      'Tahmini hedef miktarı. Kesin oran onay sırasında kilitlenir.';

  @override
  String get descriptionOptional => 'Açıklama (isteğe bağlı)';

  @override
  String get detailTransactionTitle => 'İşlem';

  @override
  String get detailPlannedTitle => 'Planlanan';

  @override
  String get detailConfirmTransaction => 'İşlemi onayla';

  @override
  String get detailDate => 'Tarih';

  @override
  String get detailFrom => 'İtibaren';

  @override
  String get detailTo => 'İle';

  @override
  String get detailCategory => 'Kategori';

  @override
  String get detailNote => 'Not';

  @override
  String get detailDestinationAmount => 'Hedef tutarı';

  @override
  String get detailExchangeRate => 'Döviz kuru';

  @override
  String get detailRepeats => 'Tekrarlar';

  @override
  String get detailDayOfMonth => 'Ayın günü';

  @override
  String get detailWeekends => 'Hafta sonları';

  @override
  String get detailAttachments => 'Ekler';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dosya',
      one: '1 dosya',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsSectionDisplay => 'Görüntülemek';

  @override
  String get settingsSectionLanguage => 'Dil';

  @override
  String get settingsSectionCategories => 'Kategoriler';

  @override
  String get settingsSectionAccounts => 'Hesaplar';

  @override
  String get settingsSectionPreferences => 'Tercihler';

  @override
  String get settingsSectionManage => 'Üstesinden gelmek';

  @override
  String get settingsBaseCurrency => 'Ev para birimi';

  @override
  String get settingsSecondaryCurrency => 'İkincil para birimi';

  @override
  String get settingsCategories => 'Kategoriler';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount gelir · $expenseCount gider';
  }

  @override
  String get settingsArchivedAccounts => 'Arşivlenmiş hesaplar';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Şu anda yok — bakiye temizlendiğinde hesap düzenlemeden arşivle';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count İnceleme ve seçicilerden gizlendi';
  }

  @override
  String get settingsSectionData => 'Veri';

  @override
  String get settingsSectionPrivacy => 'Hakkında';

  @override
  String get settingsPrivacyPolicyTitle => 'Gizlilik politikası';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Platrare verilerinizi nasıl işler?';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Döviz kurları: Uygulama, internet üzerinden genel döviz kurlarını getirir. Hesaplarınız ve işlemleriniz asla gönderilmez.';

  @override
  String get settingsPrivacyOpenFailed => 'Gizlilik politikası yüklenemedi.';

  @override
  String get settingsPrivacyRetry => 'Tekrar deneyin';

  @override
  String get settingsSoftwareVersionTitle => 'Yazılım sürümü';

  @override
  String get settingsSoftwareVersionSubtitle => 'Sürüm, teşhis ve yasal';

  @override
  String get aboutScreenTitle => 'Hakkında';

  @override
  String get aboutAppTagline =>
      'Tek bir çalışma alanında defter, nakit akışı ve planlama.';

  @override
  String get aboutDescriptionBody =>
      'Platrare hesapları, işlemleri ve planları cihazınızda tutar. Başka bir yerde bir kopyaya ihtiyaç duyduğunuzda şifrelenmiş yedekleri dışa aktarın. Döviz kurları yalnızca kamuya açık piyasa verilerini kullanır; defteriniz yüklenmedi.';

  @override
  String get aboutVersionLabel => 'Sürüm';

  @override
  String get aboutBuildLabel => 'İnşa etmek';

  @override
  String get aboutCopySupportDetails => 'Destek ayrıntılarını kopyala';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Tam uygulama içi politika belgesini açar.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Yerel ayar';

  @override
  String get settingsSupportInfoCopied => 'Panoya kopyalandı';

  @override
  String get settingsVerifyLedger => 'Verileri doğrulayın';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Hesap bakiyelerinin işlem geçmişinizle eşleşip eşleşmediğini kontrol edin';

  @override
  String get settingsDataExportTitle => 'Yedeği dışa aktar';

  @override
  String get settingsDataExportSubtitle =>
      'Tüm veriler ve eklerle birlikte .zip veya şifrelenmiş .platrare olarak kaydedin';

  @override
  String get settingsDataImportTitle => 'Yedeklemeden geri yükle';

  @override
  String get settingsDataImportSubtitle =>
      'Platrare .zip veya .platrare yedeklemesindeki mevcut verileri değiştirin';

  @override
  String get backupExportDialogTitle => 'Bu yedeği koruyun';

  @override
  String get backupExportDialogBody =>
      'Özellikle dosyayı bulutta saklıyorsanız güçlü bir parola önerilir. İçe aktarmak için aynı şifreye ihtiyacınız var.';

  @override
  String get backupExportPasswordLabel => 'Şifre';

  @override
  String get backupExportPasswordConfirmLabel => 'Şifreyi onayla';

  @override
  String get backupExportPasswordMismatch => 'Şifreler eşleşmiyor';

  @override
  String get backupExportPasswordEmpty =>
      'Eşleşen bir şifre girin veya aşağıya şifreleme olmadan aktarın.';

  @override
  String get backupExportPasswordTooShort =>
      'Şifre en az 8 karakter olmalıdır.';

  @override
  String get backupExportSaveToDevice => 'Cihaza kaydet';

  @override
  String get backupExportShareToCloud => 'Paylaş (iCloud, Drive…)';

  @override
  String get backupExportWithoutEncryption => 'Şifreleme olmadan dışa aktar';

  @override
  String get backupExportSkipWarningTitle =>
      'Şifreleme olmadan dışa aktarılsın mı?';

  @override
  String get backupExportSkipWarningBody =>
      'Dosyaya erişimi olan herkes verilerinizi okuyabilir. Bunu yalnızca kontrol ettiğiniz yerel kopyalar için kullanın.';

  @override
  String get backupExportSkipWarningConfirm =>
      'Şifrelenmemiş olarak dışa aktar';

  @override
  String get backupImportPasswordTitle => 'Şifreli yedekleme';

  @override
  String get backupImportPasswordBody =>
      'Dışa aktarırken kullandığınız şifreyi girin.';

  @override
  String get backupImportPasswordLabel => 'Şifre';

  @override
  String get backupImportPreviewTitle => 'Yedekleme özeti';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Uygulama sürümü: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Dışa aktarılan: $date';
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
    return '$accounts hesaplar · $transactions işlemler · $planned planlanan · $attachments ek dosyaları · $income gelir kategorileri · $expense gider kategorileri';
  }

  @override
  String get backupImportPreviewContinue => 'Devam etmek';

  @override
  String get settingsBackupWrongPassword => 'Yanlış şifre';

  @override
  String get settingsBackupChecksumMismatch =>
      'Yedekleme başarısız oldu bütünlük kontrolü';

  @override
  String get settingsBackupCorruptFile =>
      'Geçersiz veya hasarlı yedekleme dosyası';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Yedeklemenin daha yeni bir uygulama sürümüne ihtiyacı var';

  @override
  String get settingsDataImportConfirmTitle =>
      'Mevcut veriler değiştirilsin mi?';

  @override
  String get settingsDataImportConfirmBody =>
      'Bu, mevcut hesaplarınızı, işlemlerinizi, planlı işlemlerinizi, kategorilerinizi ve içe aktarılan eklerinizi seçilen yedeklemenin içeriğiyle değiştirecektir. Bu eylem geri alınamaz.';

  @override
  String get settingsDataImportConfirmAction => 'Verileri değiştir';

  @override
  String get settingsDataImportDone => 'Veriler başarıyla geri yüklendi';

  @override
  String get settingsDataImportInvalidFile =>
      'Bu dosya geçerli bir Platrare yedeği değil';

  @override
  String get settingsDataImportFailed => 'İçe aktarma başarısız oldu';

  @override
  String get settingsDataExportDoneTitle => 'Yedekleme dışa aktarıldı';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Yedekleme şuraya kaydedildi:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Dosyayı aç';

  @override
  String get settingsDataExportFailed => 'Dışa aktarma başarısız oldu';

  @override
  String get ledgerVerifyDialogTitle => 'Defter doğrulama';

  @override
  String get ledgerVerifyAllMatch => 'Tüm hesaplar eşleşiyor.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Uyuşmazlıklar';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nSaklanan: $stored\nTekrar: $replayed\nFark: $diff';
  }

  @override
  String get settingsLanguage => 'Uygulama dili';

  @override
  String get settingsLanguageSubtitleSystem => 'Sistem ayarlarını takip etmek';

  @override
  String get settingsLanguageSubtitleEnglish => 'İngilizce';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'Sırpça (Latince)';

  @override
  String get settingsLanguagePickerTitle => 'Uygulama dili';

  @override
  String get settingsLanguageOptionSystem => 'Sistem varsayılanı';

  @override
  String get settingsLanguageOptionEnglish => 'İngilizce';

  @override
  String get settingsLanguageOptionSerbianLatin => 'Sırpça (Latince)';

  @override
  String get settingsSectionAppearance => 'Dış görünüş';

  @override
  String get settingsSectionSecurity => 'Güvenlik';

  @override
  String get settingsSecurityEnableLock => 'Uygulamayı açıkken kilitle';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Uygulama açıldığında biyometrik kilit açma veya PIN iste';

  @override
  String get settingsSecuritySetPin => 'PIN\'i ayarla';

  @override
  String get settingsSecurityChangePin => 'PIN\'i değiştir';

  @override
  String get settingsSecurityPinSubtitle =>
      'Biyometri kullanılamıyorsa yedek olarak PIN kullanın';

  @override
  String get settingsSecurityRemovePin => 'PIN\'i kaldır';

  @override
  String get securitySetPinTitle => 'Uygulama PIN\'ini ayarla';

  @override
  String get securityPinLabel => 'PIN kodu';

  @override
  String get securityConfirmPinLabel => 'PIN kodunu onaylayın';

  @override
  String get securityPinMustBe4Digits => 'PIN en az 4 haneli olmalıdır';

  @override
  String get securityPinMismatch => 'PIN kodları eşleşmiyor';

  @override
  String get securityRemovePinTitle => 'PIN kaldırılsın mı?';

  @override
  String get securityRemovePinBody =>
      'Varsa biyometrik kilit açma hâlâ kullanılabilir.';

  @override
  String get securityUnlockTitle => 'Uygulama kilitlendi';

  @override
  String get securityUnlockSubtitle =>
      'Face ID, parmak izi veya PIN ile kilidi açın.';

  @override
  String get securityUnlockWithPin => 'PIN ile kilidi aç';

  @override
  String get securityTryBiometric => 'Biyometrik kilit açmayı deneyin';

  @override
  String get securityPinIncorrect => 'Yanlış PIN, tekrar deneyin';

  @override
  String get securityBiometricReason =>
      'Uygulamanızı açmak için kimlik doğrulaması yapın';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitleSystem => 'Sistem ayarlarını takip etmek';

  @override
  String get settingsThemeSubtitleLight => 'Işık';

  @override
  String get settingsThemeSubtitleDark => 'Karanlık';

  @override
  String get settingsThemePickerTitle => 'Tema';

  @override
  String get settingsThemeOptionSystem => 'Sistem varsayılanı';

  @override
  String get settingsThemeOptionLight => 'Işık';

  @override
  String get settingsThemeOptionDark => 'Karanlık';

  @override
  String get archivedAccountsTitle => 'Arşivlenmiş hesaplar';

  @override
  String get archivedAccountsEmptyTitle => 'Arşivlenmiş hesap yok';

  @override
  String get archivedAccountsEmptyBody =>
      'Defter bakiyesi ve kredili mevduat sıfır olmalıdır. İnceleme\'deki hesap seçeneklerinden arşivleyin.';

  @override
  String get categoriesTitle => 'Kategoriler';

  @override
  String get newCategoryTitle => 'Yeni Kategori';

  @override
  String get categoryNameLabel => 'Kategori adı';

  @override
  String get deleteCategoryTitle => 'Kategori silinsin mi?';

  @override
  String deleteCategoryBody(String category) {
    return '\"$category\" listeden kaldırılacaktır.';
  }

  @override
  String get categoryIncome => 'Gelir';

  @override
  String get categoryExpense => 'Gider';

  @override
  String get categoryAdd => 'Eklemek';

  @override
  String get searchCurrencies => 'Para birimlerini arayın…';

  @override
  String get period1M => '1 milyon';

  @override
  String get period3M => '3 milyon';

  @override
  String get period6M => '6 milyon';

  @override
  String get period1Y => '1Y';

  @override
  String get periodAll => 'TÜM';

  @override
  String get categoryLabel => 'kategori';

  @override
  String get categoriesLabel => 'kategoriler';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type kaydedildi • $amount';
  }

  @override
  String get tooltipSettings => 'Ayarlar';

  @override
  String get tooltipAddAccount => 'Hesap ekle';

  @override
  String get tooltipRemoveAccount => 'Hesabı kaldır';

  @override
  String get accountNameTaken =>
      'Bu ada ve tanımlayıcıya (etkin veya arşivlenmiş) sahip bir hesabınız zaten var. Adı veya tanımlayıcıyı değiştirin.';

  @override
  String get groupDescPersonal => 'Kendi cüzdanlarınız ve banka hesaplarınız';

  @override
  String get groupDescIndividuals => 'Aile, arkadaşlar, bireyler';

  @override
  String get groupDescEntities => 'Varlıklar, kamu hizmetleri, kuruluşlar';

  @override
  String get cannotArchiveTitle => 'Henüz arşivlenemiyor';

  @override
  String get cannotArchiveBody =>
      'Arşiv yalnızca defter bakiyesi ve kredili mevduat limitinin her ikisi de fiilen sıfır olduğunda kullanılabilir.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Arşiv yalnızca defter bakiyesi ve kredili mevduat limitinin her ikisi de fiilen sıfır olduğunda kullanılabilir. Önce defteri veya tesisi ayarlayın.';

  @override
  String get archiveAccountTitle => 'Hesabı arşivle?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planlanan işlem bu hesaba referans veriyor.',
      one: '1 planlanan işlem bu hesaba referans veriyor.',
    );
    return '$_temp0 Arşivlenmiş bir hesapla planınızın tutarlı kalması için bunları kaldırın.';
  }

  @override
  String get removeAndArchive => 'Planlananı kaldır ve arşivle';

  @override
  String get archiveBody =>
      'Hesap İnceleme, Takip ve Plan seçicilerden gizlenecektir. Ayarlar\'dan geri yükleyebilirsiniz.';

  @override
  String get archiveAction => 'Arşiv';

  @override
  String get archiveInstead => 'Bunun yerine arşivle';

  @override
  String get cannotDeleteTitle => 'Hesap silinemiyor';

  @override
  String get cannotDeleteBodyShort =>
      'Bu hesap Takip geçmişinizde görünür. Önce bu işlemleri kaldırın veya yeniden atayın ya da bakiye temizlendiyse hesabı arşivleyin.';

  @override
  String get cannotDeleteBodyHistory =>
      'Bu hesap Takip geçmişinizde görünür. Silmek, bu geçmişi bozacaktır; önce bu işlemleri kaldırın veya yeniden atayın.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'Bu hesap Takip geçmişinizde göründüğünden silinemez. Bunun yerine, defter bakiyesi ve kredili mevduat silinirse arşivleyebilirsiniz; listelerde gizlenir ancak geçmiş bozulmadan kalır.';

  @override
  String get deleteAccountTitle => 'Hesap silinsin mi?';

  @override
  String get deleteAccountBodyPermanent =>
      'Bu hesap kalıcı olarak kaldırılacaktır.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planlanan işlem bu hesaba referans veriyor ve silinecek.',
      one: '1 planlanan işlem bu hesaba referans veriyor ve silinecek.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Tümünü sil';

  @override
  String get editAccountTitle => 'Hesabı Düzenle';

  @override
  String get newAccountTitle => 'Yeni Hesap';

  @override
  String get labelAccountName => 'Hesap adı';

  @override
  String get labelAccountIdentifier => 'Tanımlayıcı (isteğe bağlı)';

  @override
  String get accountAppearanceSection => 'Simge ve renk';

  @override
  String get accountPickIcon => 'Simge seç';

  @override
  String get accountPickColor => 'Renk seç';

  @override
  String get accountIconSheetTitle => 'Hesap simgesi';

  @override
  String get accountColorSheetTitle => 'Hesap rengi';

  @override
  String get accountUseInitialLetter => 'İlk harf';

  @override
  String get accountUseDefaultColor => 'Maç grubu';

  @override
  String get labelRealBalance => 'Gerçek denge';

  @override
  String get labelOverdraftLimit => 'Kredili mevduat / avans limiti';

  @override
  String get labelCurrency => 'Para birimi';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get addAccountAction => 'Hesap Ekle';

  @override
  String get removeAccountSheetTitle => 'Hesabı kaldır';

  @override
  String get deletePermanently => 'Kalıcı olarak sil';

  @override
  String get deletePermanentlySubtitle =>
      'Yalnızca bu hesap Track\'te kullanılmadığında mümkündür. Planlanan öğeler, silme işleminin bir parçası olarak kaldırılabilir.';

  @override
  String get archiveOptionSubtitle =>
      'İncelemeden ve seçicilerden gizle. İstediğiniz zaman Ayarlar\'dan geri yükleyin. Sıfır bakiye ve kredili mevduat gerektirir.';

  @override
  String get archivedBannerText =>
      'Bu hesap arşivlendi. Verilerinizde kalır ancak listelerden ve seçicilerden gizlenir.';

  @override
  String get balanceAdjustedTitle => 'Parçada denge ayarlandı';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Gerçek bakiye $previous\'den $current $symbol\'ye güncellendi.\n\nDefterin tutarlı kalması için Takip (Geçmiş)\'te bir bakiye düzeltme işlemi oluşturuldu.\n\n• Gerçek bakiye bu hesaptaki gerçek tutarı yansıtır.\n• Ayar girişi için Geçmişi kontrol edin.';
  }

  @override
  String get ok => 'TAMAM';

  @override
  String get categoryBalanceAdjustment => 'Denge ayarı';

  @override
  String get descriptionBalanceCorrection => 'Denge düzeltmesi';

  @override
  String get descriptionOpeningBalance => 'Açılış bakiyesi';

  @override
  String get reviewStatsModeStatistics => 'İstatistikler';

  @override
  String get reviewStatsModeComparison => 'Karşılaştırmak';

  @override
  String get statsUncategorized => 'Kategorize edilmemiş';

  @override
  String get statsNoCategories =>
      'Seçilen dönemlerde karşılaştırma için kategori yok.';

  @override
  String get statsNoTransactions => 'İşlem yok';

  @override
  String get statsSpendingInCategory => 'Bu kategorideki harcamalar';

  @override
  String get statsIncomeInCategory => 'Bu kategorideki gelir';

  @override
  String get statsDifference => 'Fark (B ve A):';

  @override
  String get statsNoExpensesMonth => 'Bu ay masraf yok';

  @override
  String get statsNoExpensesAll => 'Hiçbir harcama kaydedilmedi';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Son dönemde masraf yok $period';
  }

  @override
  String get statsTotalSpent => 'Toplam harcanan';

  @override
  String get statsNoExpensesThisPeriod => 'Bu dönemde masraf yok';

  @override
  String get statsNoIncomeMonth => 'Bu ay gelir yok';

  @override
  String get statsNoIncomeAll => 'Gelir kaydedilmedi';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Son dönemde gelir yok $period';
  }

  @override
  String get statsTotalReceived => 'Toplam alınan';

  @override
  String get statsNoIncomeThisPeriod => 'Bu dönemde gelir yok';

  @override
  String get catSalary => 'Maaş';

  @override
  String get catFreelance => 'Serbest çalışan';

  @override
  String get catConsulting => 'Danışmanlık';

  @override
  String get catGift => 'Hediye';

  @override
  String get catRental => 'Kiralık';

  @override
  String get catDividends => 'Temettüler';

  @override
  String get catRefund => 'Geri ödemek';

  @override
  String get catBonus => 'Bonus';

  @override
  String get catInterest => 'Faiz';

  @override
  String get catSideHustle => 'Yan koşuşturma';

  @override
  String get catSaleOfGoods => 'Mal satışı';

  @override
  String get catOther => 'Diğer';

  @override
  String get catGroceries => 'Bakkaliye';

  @override
  String get catDining => 'Yemek';

  @override
  String get catTransport => 'Taşıma';

  @override
  String get catUtilities => 'Yardımcı programlar';

  @override
  String get catHousing => 'Konut';

  @override
  String get catHealthcare => 'Sağlık hizmeti';

  @override
  String get catEntertainment => 'Eğlence';

  @override
  String get catShopping => 'Alışveriş';

  @override
  String get catTravel => 'Seyahat';

  @override
  String get catEducation => 'Eğitim';

  @override
  String get catSubscriptions => 'Abonelikler';

  @override
  String get catInsurance => 'Sigorta';

  @override
  String get catFuel => 'Yakıt';

  @override
  String get catGym => 'Spor salonu';

  @override
  String get catPets => 'Evcil hayvanlar';

  @override
  String get catKids => 'Çocuklar';

  @override
  String get catCharity => 'Hayır kurumu';

  @override
  String get catCoffee => 'Kahve';

  @override
  String get catGifts => 'Hediyeler';

  @override
  String semanticsProjectionDate(String date) {
    return 'Projeksiyon tarihi $date. Tarihi seçmek için iki kez dokunun';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Tahmini kişisel denge $amount';
  }

  @override
  String get statsEmptyTitle => 'Henüz işlem yok';

  @override
  String get statsEmptySubtitle => 'Seçilen aralık için harcama verisi yok.';

  @override
  String get semanticsShowProjections =>
      'Tahmini bakiyeleri hesaba göre göster';

  @override
  String get semanticsHideProjections => 'Tahmini bakiyeleri hesaba göre gizle';

  @override
  String get semanticsDateAllTime =>
      'Tarih: tüm zamanlar — modu değiştirmek için dokunun';

  @override
  String semanticsDateMode(String mode) {
    return 'Tarih: $mode — modu değiştirmek için dokunun';
  }

  @override
  String get semanticsDateThisMonth =>
      'Tarih: bu ay — ay, hafta, yıl veya tüm zamanlar için dokunun';

  @override
  String get semanticsTxTypeCycle =>
      'İşlem türü: tümünü çevir, gelir, gider, transfer';

  @override
  String get semanticsAccountFilter => 'Hesap filtresi';

  @override
  String get semanticsAlreadyFiltered => 'Bu hesaba zaten filtre uygulandı';

  @override
  String get semanticsCategoryFilter => 'Kategori filtresi';

  @override
  String get semanticsSortToggle =>
      'Sırala: önce en yeniye veya en eskiye geçiş yap';

  @override
  String get semanticsFiltersDisabled =>
      'Gelecekteki bir projeksiyon tarihini görüntülerken liste filtreleri devre dışı bırakıldı. Filtreleri kullanmak için projeksiyonları temizleyin.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Liste filtreleri devre dışı bırakıldı. Önce bir hesap ekleyin.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Liste filtreleri devre dışı bırakıldı. Önce planlı bir işlem ekleyin.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Liste filtreleri devre dışı bırakıldı. Önce bir işlemi kaydedin.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Bölüm ve para birimi kontrolleri devre dışı bırakıldı. Önce bir hesap ekleyin.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Projeksiyon tarihi ve bakiye dökümü devre dışı bırakıldı. Önce bir hesap ve planlı bir işlem ekleyin.';

  @override
  String get semanticsReorderAccountHint =>
      'Bu grup içinde yeniden sıralamak için uzun basın, ardından sürükleyin';

  @override
  String get semanticsChartStyle => 'Grafik stili';

  @override
  String get semanticsChartStyleUnavailable =>
      'Grafik stili (karşılaştırma modunda kullanılamaz)';

  @override
  String semanticsPeriod(String label) {
    return 'Dönem: $label';
  }

  @override
  String get trackSearchHint => 'Arama açıklaması, kategori, hesap…';

  @override
  String get trackSearchClear => 'Aramayı temizle';

  @override
  String get settingsExchangeRatesTitle => 'Döviz kurları';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Son güncelleme: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Çevrimdışı veya paket fiyatları kullanılıyor; yenilemek için dokunun';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Döviz kurları güncellendi';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Döviz kurları güncellenemedi. Bağlantınızı kontrol edin.';

  @override
  String get settingsClearData => 'Verileri temizle';

  @override
  String get settingsClearDataSubtitle =>
      'Seçilen verileri kalıcı olarak kaldır';

  @override
  String get clearDataTitle => 'Verileri temizle';

  @override
  String get clearDataTransactions => 'İşlem geçmişi';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count işlemler · hesap bakiyeleri sıfıra sıfırlandı';
  }

  @override
  String get clearDataPlanned => 'Planlanan işlemler';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count planlanan öğeler';
  }

  @override
  String get clearDataAccounts => 'Hesaplar';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count hesaplar · aynı zamanda geçmişi ve planı da temizler';
  }

  @override
  String get clearDataCategories => 'Kategoriler';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count kategoriler · varsayılanlarla değiştirildi';
  }

  @override
  String get clearDataPreferences => 'Tercihler';

  @override
  String get clearDataPreferencesSubtitle =>
      'Para birimini, temayı ve dili varsayılanlara sıfırlayın';

  @override
  String get clearDataSecurity => 'Uygulama kilidi ve PIN';

  @override
  String get clearDataSecuritySubtitle =>
      'Uygulama kilidini devre dışı bırakın ve PIN\'i kaldırın';

  @override
  String get clearDataConfirmButton => 'Seçileni temizle';

  @override
  String get clearDataConfirmTitle => 'Bu geri alınamaz';

  @override
  String get clearDataConfirmBody =>
      'Seçilen veriler kalıcı olarak silinecek. Daha sonra ihtiyacınız olursa önce bir yedeği dışa aktarın.';

  @override
  String get clearDataTypeConfirm => 'Onaylamak için DELETE yazın';

  @override
  String get clearDataTypeConfirmError =>
      'Devam etmek için tam olarak DELETE yazın';

  @override
  String get clearDataPinTitle => 'PIN ile onayla';

  @override
  String get clearDataPinBody =>
      'Bu işlemi yetkilendirmek için uygulama PIN\'inizi girin.';

  @override
  String get clearDataPinIncorrect => 'Yanlış PIN';

  @override
  String get clearDataDone => 'Seçilen veriler temizlendi';

  @override
  String get autoBackupTitle => 'Otomatik günlük yedekleme';

  @override
  String autoBackupLastAt(String date) {
    return 'Son yedekleme $date';
  }

  @override
  String get autoBackupNeverRun => 'Henüz yedekleme yok';

  @override
  String get autoBackupShareTitle => 'Buluta kaydet';

  @override
  String get autoBackupShareSubtitle =>
      'En son yedeklemeyi iCloud Drive\'a, Google Drive\'a veya herhangi bir uygulamaya yükleyin';

  @override
  String get autoBackupCloudReminder =>
      'Otomatik yedeklemeye hazır; cihaz dışı koruma için buluta kaydedin';

  @override
  String get autoBackupCloudReminderAction => 'Paylaş';

  @override
  String get persistenceErrorReloaded =>
      'Değişiklikler kaydedilemedi. Veriler depolama alanından yeniden yüklendi.';
}
