// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '플라트라레';

  @override
  String get navPlan => '계획';

  @override
  String get navTrack => '길';

  @override
  String get navReview => '검토';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get close => '닫다';

  @override
  String get add => '추가하다';

  @override
  String get undo => '끄르다';

  @override
  String get confirm => '확인하다';

  @override
  String get restore => '복원하다';

  @override
  String get heroIn => '~ 안에';

  @override
  String get heroOut => '밖으로';

  @override
  String get heroNet => '그물';

  @override
  String get heroBalance => '균형';

  @override
  String get realBalance => '실제 균형';

  @override
  String get settingsHideHeroBalancesTitle => '요약 카드에서 잔액 숨기기';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      '켜져 있으면 각 탭의 눈 아이콘을 탭할 때까지 계획, 추적, 검토의 금액이 가려집니다. 꺼져 있으면 잔액이 항상 표시됩니다.';

  @override
  String get heroBalancesShow => '잔액 표시';

  @override
  String get heroBalancesHide => '잔액 숨기기';

  @override
  String get semanticsHeroBalanceHidden => '개인 정보 보호를 위해 잔액 숨김';

  @override
  String get heroResetButton => '다시 놓기';

  @override
  String get fabScrollToTop => '맨 위로';

  @override
  String get filterAll => '모두';

  @override
  String get filterAllAccounts => '모든 계정';

  @override
  String get filterAllCategories => '모든 카테고리';

  @override
  String get txLabelIncome => '소득';

  @override
  String get txLabelExpense => '비용';

  @override
  String get txLabelInvoice => '송장';

  @override
  String get txLabelBill => '청구서';

  @override
  String get txLabelAdvance => '전진';

  @override
  String get txLabelSettlement => '합의';

  @override
  String get txLabelLoan => '대출';

  @override
  String get txLabelCollection => '수집';

  @override
  String get txLabelOffset => '오프셋';

  @override
  String get txLabelTransfer => '옮기다';

  @override
  String get txLabelTransaction => '거래';

  @override
  String get repeatNone => '반복 없음';

  @override
  String get repeatDaily => '일일';

  @override
  String get repeatWeekly => '주간';

  @override
  String get repeatMonthly => '월간 간행물';

  @override
  String get repeatYearly => '매년';

  @override
  String get repeatEveryLabel => '모든';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 일',
      one: '일',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 주',
      one: '주',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 개월',
      one: '개월',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 년',
      one: '년',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => '종료';

  @override
  String get repeatEndNever => '절대';

  @override
  String get repeatEndOnDate => '날짜에';

  @override
  String repeatEndAfterCount(int count) {
    return '$count회 후';
  }

  @override
  String get repeatEndAfterChoice => '일정 횟수 후';

  @override
  String get repeatEndPickDate => '종료일 선택';

  @override
  String get repeatEndTimes => '타임스';

  @override
  String repeatSummaryEvery(String unit) {
    return '$unit마다';
  }

  @override
  String repeatSummaryUntil(String date) {
    return '$date까지';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count회';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return '$remaining/$total 남음';
  }

  @override
  String get detailRepeatEvery => '반복 간격';

  @override
  String get detailEnds => '종료';

  @override
  String get detailEndsNever => '절대';

  @override
  String detailEndsOnDate(String date) {
    return '$date에';
  }

  @override
  String detailEndsAfterCount(int count) {
    return '$count회 후';
  }

  @override
  String get detailProgress => '진전';

  @override
  String get weekendNoChange => '변화 없음';

  @override
  String get weekendFriday => '금요일로 이동';

  @override
  String get weekendMonday => '월요일로 이동';

  @override
  String weekendQuestion(String day) {
    return '$day가 주말에 해당한다면?';
  }

  @override
  String get dateToday => '오늘';

  @override
  String get dateTomorrow => '내일';

  @override
  String get dateYesterday => '어제';

  @override
  String get statsAllTime => '모든 시간';

  @override
  String get accountGroupPersonal => '개인의';

  @override
  String get accountGroupIndividual => '개인';

  @override
  String get accountGroupEntity => '실재';

  @override
  String get accountSectionIndividuals => '개인';

  @override
  String get accountSectionEntities => '엔터티';

  @override
  String get emptyNoTransactionsYet => '아직 거래가 없습니다.';

  @override
  String get emptyNoAccountsYet => '아직 계정이 없습니다';

  @override
  String get emptyRecordFirstTransaction => '첫 번째 거래를 기록하려면 아래 버튼을 누르세요.';

  @override
  String get emptyAddFirstAccountTx => '거래를 기록하기 전에 첫 번째 계정을 추가하세요.';

  @override
  String get emptyAddFirstAccountPlan => '거래를 계획하기 전에 첫 번째 계정을 추가하세요.';

  @override
  String get emptyAddFirstAccountReview => '재정 추적을 시작하려면 첫 번째 계정을 추가하세요.';

  @override
  String get emptyAddTransaction => '거래 추가';

  @override
  String get emptyAddAccount => '계정 추가';

  @override
  String get reviewEmptyGroupPersonalTitle => '아직 개인 계정이 없습니다.';

  @override
  String get reviewEmptyGroupPersonalBody =>
      '개인계좌는 본인의 지갑이자 은행계좌입니다. 일일 수입과 지출을 추적하려면 하나를 추가하세요.';

  @override
  String get reviewEmptyGroupIndividualsTitle => '아직 개인 계정이 없습니다.';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      '개인 계정은 비용 공유, 대출, IOU 등 특정 사람들과의 자금을 추적합니다. 합의한 각 사람에 대한 계정을 추가하십시오.';

  @override
  String get reviewEmptyGroupEntitiesTitle => '아직 법인 계정이 없습니다.';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      '엔터티 계정은 비즈니스, 프로젝트 또는 조직을 위한 것입니다. 이를 사용하여 비즈니스 현금 흐름을 개인 재정과 별도로 유지하십시오.';

  @override
  String get emptyNoTransactionsForFilters => '적용된 필터에 대한 거래가 없습니다.';

  @override
  String get emptyNoTransactionsInHistory => '내역에 거래가 없습니다.';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return '$month에 대한 거래가 없습니다.';
  }

  @override
  String get emptyNoTransactionsForAccount => '이 계정에 거래가 없습니다.';

  @override
  String get trackTransactionDeleted => '거래가 삭제되었습니다.';

  @override
  String get trackDeleteTitle => '거래를 삭제하시겠습니까?';

  @override
  String get trackDeleteBody => '이렇게 하면 계정 잔액 변경 사항이 취소됩니다.';

  @override
  String get trackTransaction => '거래';

  @override
  String get planConfirmTitle => '거래를 확인하시겠습니까?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return '이 사건은 $date에 예정되어 있습니다. 오늘 날짜($todayDate)로 히스토리에 기록됩니다. 다음 발생은 $nextDate에 남아 있습니다.';
  }

  @override
  String get planConfirmBodyNormal => '그러면 거래가 실제 계좌 잔액에 적용되어 내역으로 이동됩니다.';

  @override
  String get planTransactionConfirmed => '거래 확인 및 적용';

  @override
  String get planTransactionRemoved => '계획된 거래가 삭제되었습니다.';

  @override
  String get planRepeatingTitle => '반복 거래';

  @override
  String get planRepeatingBody =>
      '이 날짜만 건너뛰거나 다음 항목으로 시리즈가 계속되거나 계획에서 나머지 항목을 모두 삭제하세요.';

  @override
  String get planDeleteAll => '모두 삭제';

  @override
  String get planSkipThisOnly => '이것만 건너뛰기';

  @override
  String get planOccurrenceSkipped => '이 항목을 건너뛰었습니다. 다음 항목이 예정되어 있습니다.';

  @override
  String get planNothingPlanned => '지금은 계획된 것이 없습니다.';

  @override
  String get planPlanBody => '다가오는 거래를 계획하십시오.';

  @override
  String get planAddPlan => '계획 추가';

  @override
  String get planNoPlannedForFilters => '적용된 필터에 대해 계획된 거래가 없습니다.';

  @override
  String planNoPlannedInMonth(String month) {
    return '$month에는 계획된 거래가 없습니다.';
  }

  @override
  String get planOverdue => '기한이 지난';

  @override
  String get planPlannedTransaction => '계획된 거래';

  @override
  String get discardTitle => '변경사항을 취소하시겠습니까?';

  @override
  String get discardBody => '저장되지 않은 변경사항이 있습니다. 지금 떠나면 그것들은 사라질 것입니다.';

  @override
  String get keepEditing => '계속 수정하세요';

  @override
  String get discard => '취소';

  @override
  String get newTransactionTitle => '새로운 거래';

  @override
  String get editTransactionTitle => '거래 편집';

  @override
  String get transactionUpdated => '거래가 업데이트되었습니다.';

  @override
  String get sectionAccounts => '계정';

  @override
  String get labelFrom => '에서';

  @override
  String get labelTo => '에게';

  @override
  String get sectionCategory => '범주';

  @override
  String get sectionAttachments => '첨부파일';

  @override
  String get labelNote => '메모';

  @override
  String get hintOptionalDescription => '선택적 설명';

  @override
  String get updateTransaction => '거래 업데이트';

  @override
  String get saveTransaction => '거래 저장';

  @override
  String get selectAccount => '계정 선택';

  @override
  String get selectAccountTitle => '계정 선택';

  @override
  String get noAccountsAvailable => '사용 가능한 계정이 없습니다.';

  @override
  String amountReceivedBy(String name, String currency) {
    return '$name($currency)님이 받은 금액';
  }

  @override
  String get amountReceivedHelper =>
      '대상 계정이 받는 정확한 금액을 입력하세요. 이렇게 하면 사용된 실제 환율이 잠깁니다.';

  @override
  String get attachTakePhoto => '사진 찍기';

  @override
  String get attachTakePhotoSub => '카메라를 사용하여 영수증 캡처';

  @override
  String get attachChooseGallery => '갤러리에서 선택';

  @override
  String get attachChooseGallerySub => '라이브러리에서 사진을 선택하세요.';

  @override
  String get attachBrowseFiles => '파일 찾아보기';

  @override
  String get attachBrowseFilesSub => 'PDF, 문서 또는 기타 파일 첨부';

  @override
  String get attachButton => '붙이다';

  @override
  String get editPlanTitle => '계획 편집';

  @override
  String get planTransactionTitle => '계획 거래';

  @override
  String get tapToSelect => '선택하려면 탭하세요.';

  @override
  String get updatePlan => '업데이트 계획';

  @override
  String get addToPlan => '계획에 추가';

  @override
  String get labelRepeat => '반복하다';

  @override
  String get selectPlannedDate => '예정일 선택';

  @override
  String get balancesAsOfToday => '오늘 기준 잔액';

  @override
  String get projectedBalancesForTomorrow => '내일 예상 잔액';

  @override
  String projectedBalancesForDate(String date) {
    return '$date의 예상 잔액';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name 수신($currency)';
  }

  @override
  String get destHelper => '예상 목적지 금액. 정확한 환율은 확인 시 고정됩니다.';

  @override
  String get descriptionOptional => '설명(선택사항)';

  @override
  String get detailTransactionTitle => '거래';

  @override
  String get detailPlannedTitle => '예정';

  @override
  String get detailConfirmTransaction => '거래 확인';

  @override
  String get detailDate => '날짜';

  @override
  String get detailFrom => '에서';

  @override
  String get detailTo => '에게';

  @override
  String get detailCategory => '범주';

  @override
  String get detailNote => '메모';

  @override
  String get detailDestinationAmount => '목적지 금액';

  @override
  String get detailExchangeRate => '환율';

  @override
  String get detailRepeats => '반복';

  @override
  String get detailDayOfMonth => '날짜';

  @override
  String get detailWeekends => '주말';

  @override
  String get detailAttachments => '첨부파일';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 파일',
      one: '1개 파일',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsSectionDisplay => '표시하다';

  @override
  String get settingsSectionLanguage => '언어';

  @override
  String get settingsSectionCategories => '카테고리';

  @override
  String get settingsSectionAccounts => '계정';

  @override
  String get settingsSectionPreferences => '환경설정';

  @override
  String get settingsSectionManage => '관리하다';

  @override
  String get settingsBaseCurrency => '자국 통화';

  @override
  String get settingsSecondaryCurrency => '보조 통화';

  @override
  String get settingsCategories => '카테고리';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount 수입 · $expenseCount 지출';
  }

  @override
  String get settingsArchivedAccounts => '보관된 계정';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      '현재는 없음 — 잔액이 정상화되면 계정 수정에서 보관처리됩니다.';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count 리뷰 및 선택기에서 숨겨짐';
  }

  @override
  String get settingsSectionData => '데이터';

  @override
  String get settingsSectionPrivacy => '에 대한';

  @override
  String get settingsPrivacyPolicyTitle => '개인 정보 보호 정책';

  @override
  String get settingsPrivacyPolicySubtitle => 'Platrare가 귀하의 데이터를 처리하는 방법.';

  @override
  String get settingsPrivacyFxDisclosure =>
      '환율: 앱은 인터넷을 통해 공개 환율을 가져옵니다. 귀하의 계정과 거래는 전송되지 않습니다.';

  @override
  String get settingsPrivacyOpenFailed => '개인정보취급방침을 로드할 수 없습니다.';

  @override
  String get settingsPrivacyRetry => '다시 시도하세요';

  @override
  String get settingsSoftwareVersionTitle => '소프트웨어 버전';

  @override
  String get settingsSoftwareVersionSubtitle => '릴리스, 진단 및 법률';

  @override
  String get aboutScreenTitle => '에 대한';

  @override
  String get aboutAppTagline => '하나의 작업 공간에서 원장, 현금 흐름 및 계획을 관리하세요.';

  @override
  String get aboutDescriptionBody =>
      'Platrare는 귀하의 장치에 계정, 거래 및 계획을 보관합니다. 다른 곳에 복사본이 필요할 때 암호화된 백업을 내보냅니다. 환율은 공개 시장 데이터만 사용합니다. 귀하의 원장이 업로드되지 않았습니다.';

  @override
  String get aboutVersionLabel => '버전';

  @override
  String get aboutBuildLabel => '짓다';

  @override
  String get aboutCopySupportDetails => '지원 세부정보 복사';

  @override
  String get aboutOpenPrivacySubtitle => '전체 인앱 정책 문서를 엽니다.';

  @override
  String get aboutSupportBundleLocaleLabel => '장소';

  @override
  String get settingsSupportInfoCopied => '클립보드에 복사됨';

  @override
  String get settingsVerifyLedger => '데이터 확인';

  @override
  String get settingsVerifyLedgerSubtitle => '계좌 잔액이 거래 내역과 일치하는지 확인하세요.';

  @override
  String get settingsDataExportTitle => '백업 내보내기';

  @override
  String get settingsDataExportSubtitle =>
      '모든 데이터 및 첨부 파일과 함께 .zip 또는 암호화된 .platrare로 저장';

  @override
  String get settingsDataImportTitle => '백업에서 복원';

  @override
  String get settingsDataImportSubtitle =>
      'Platrare .zip 또는 .platrare 백업에서 현재 데이터 교체';

  @override
  String get backupExportDialogTitle => '이 백업을 보호하세요';

  @override
  String get backupExportDialogBody =>
      '특히 파일을 클라우드에 저장하는 경우 강력한 비밀번호를 사용하는 것이 좋습니다. 가져오려면 동일한 비밀번호가 필요합니다.';

  @override
  String get backupExportPasswordLabel => '비밀번호';

  @override
  String get backupExportPasswordConfirmLabel => '비밀번호 확인';

  @override
  String get backupExportPasswordMismatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get backupExportPasswordEmpty =>
      '일치하는 비밀번호를 입력하거나 아래에서 암호화하지 않고 내보내세요.';

  @override
  String get backupExportPasswordTooShort => '비밀번호는 8자 이상이어야 합니다.';

  @override
  String get backupExportSaveToDevice => '장치에 저장';

  @override
  String get backupExportShareToCloud => '공유(iCloud, 드라이브…)';

  @override
  String get backupExportWithoutEncryption => '암호화하지 않고 내보내기';

  @override
  String get backupExportSkipWarningTitle => '암호화하지 않고 내보내시겠습니까?';

  @override
  String get backupExportSkipWarningBody =>
      '파일에 액세스할 수 있는 사람은 누구나 귀하의 데이터를 읽을 수 있습니다. 귀하가 제어하는 ​​로컬 복사본에만 이 옵션을 사용하십시오.';

  @override
  String get backupExportSkipWarningConfirm => '암호화되지 않은 상태로 내보내기';

  @override
  String get backupImportPasswordTitle => '암호화된 백업';

  @override
  String get backupImportPasswordBody => '내보낼 때 사용한 비밀번호를 입력하세요.';

  @override
  String get backupImportPasswordLabel => '비밀번호';

  @override
  String get backupImportPreviewTitle => '백업 요약';

  @override
  String backupImportPreviewVersion(String version) {
    return '앱 버전: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return '내보낸 날짜: $date';
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
    return '$accounts 계정 · $transactions 거래 · $planned 계획됨 · $attachments 첨부 파일 · $income 소득 범주 · $expense 비용 범주';
  }

  @override
  String get backupImportPreviewContinue => '계속하다';

  @override
  String get settingsBackupWrongPassword => '잘못된 비밀번호';

  @override
  String get settingsBackupChecksumMismatch => '백업 무결성 검사 실패';

  @override
  String get settingsBackupCorruptFile => '유효하지 않거나 손상된 백업 파일';

  @override
  String get settingsBackupUnsupportedVersion => '백업에는 최신 앱 버전이 필요합니다.';

  @override
  String get settingsDataImportConfirmTitle => '현재 데이터를 바꾸시겠습니까?';

  @override
  String get settingsDataImportConfirmBody =>
      '그러면 현재 계정, 거래, 계획된 거래, 카테고리 및 가져온 첨부 파일이 선택한 백업의 내용으로 대체됩니다. 이 작업은 취소할 수 없습니다.';

  @override
  String get settingsDataImportConfirmAction => '데이터 교체';

  @override
  String get settingsDataImportDone => '데이터가 성공적으로 복원되었습니다.';

  @override
  String get settingsDataImportInvalidFile => '이 파일은 유효한 Platrare 백업이 아닙니다.';

  @override
  String get settingsDataImportFailed => '가져오기 실패';

  @override
  String get settingsDataExportDoneTitle => '백업을 내보냈습니다.';

  @override
  String settingsDataExportDoneBody(String path) {
    return '백업 저장 위치:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => '파일 열기';

  @override
  String get settingsDataExportFailed => '내보내기 실패';

  @override
  String get ledgerVerifyDialogTitle => '원장 검증';

  @override
  String get ledgerVerifyAllMatch => '모든 계정이 일치합니다.';

  @override
  String get ledgerVerifyMismatchesTitle => '불일치';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\n저장됨: $stored\n재생: $replayed\n차이점: $diff';
  }

  @override
  String get settingsLanguage => '앱 언어';

  @override
  String get settingsLanguageSubtitleSystem => '다음 시스템 설정';

  @override
  String get settingsLanguageSubtitleEnglish => '영어';

  @override
  String get settingsLanguageSubtitleSerbianLatin => '세르비아어(라틴어)';

  @override
  String get settingsLanguagePickerTitle => '앱 언어';

  @override
  String get settingsLanguageOptionSystem => '시스템 기본값';

  @override
  String get settingsLanguageOptionEnglish => '영어';

  @override
  String get settingsLanguageOptionSerbianLatin => '세르비아어(라틴어)';

  @override
  String get settingsSectionAppearance => '모습';

  @override
  String get settingsSectionSecurity => '보안';

  @override
  String get settingsSecurityEnableLock => '열 때 앱 잠금';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      '앱이 열릴 때 생체 인식 잠금 해제 또는 PIN 요구';

  @override
  String get settingsSecurityLockDelayTitle => 'Re-lock after background';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      'How long the app can stay off-screen before requiring unlock again. Immediately is the strongest.';

  @override
  String get settingsSecurityLockDelayImmediate => 'Immediately';

  @override
  String get settingsSecurityLockDelay30s => '30 seconds';

  @override
  String get settingsSecurityLockDelay1m => '1 minute';

  @override
  String get settingsSecurityLockDelay5m => '5 minutes';

  @override
  String get settingsSecuritySetPin => 'PIN 설정';

  @override
  String get settingsSecurityChangePin => 'PIN 변경';

  @override
  String get settingsSecurityPinSubtitle =>
      '생체 인식을 사용할 수 없는 경우 대체 수단으로 PIN을 사용하세요.';

  @override
  String get settingsSecurityRemovePin => 'PIN 삭제';

  @override
  String get securitySetPinTitle => '앱 PIN 설정';

  @override
  String get securityPinLabel => '핀코드';

  @override
  String get securityConfirmPinLabel => 'PIN 코드 확인';

  @override
  String get securityPinMustBe4Digits => 'PIN은 4자리 이상이어야 합니다.';

  @override
  String get securityPinMismatch => 'PIN 코드가 일치하지 않습니다.';

  @override
  String get securityRemovePinTitle => 'PIN을 삭제하시겠습니까?';

  @override
  String get securityRemovePinBody => '가능한 경우 생체 인식 잠금 해제를 계속 사용할 수 있습니다.';

  @override
  String get securityUnlockTitle => '앱이 잠겼습니다.';

  @override
  String get securityUnlockSubtitle => 'Face ID, 지문 또는 PIN으로 잠금을 해제하세요.';

  @override
  String get securityUnlockWithPin => 'PIN으로 잠금 해제';

  @override
  String get securityTryBiometric => '생체 인식 잠금 해제를 사용해 보세요';

  @override
  String get securityPinIncorrect => 'PIN이 잘못되었습니다. 다시 시도해 주세요.';

  @override
  String get securityBiometricReason => '앱을 열려면 인증하세요.';

  @override
  String get settingsTheme => '주제';

  @override
  String get settingsThemeSubtitleSystem => '다음 시스템 설정';

  @override
  String get settingsThemeSubtitleLight => '빛';

  @override
  String get settingsThemeSubtitleDark => '어두운';

  @override
  String get settingsThemePickerTitle => '주제';

  @override
  String get settingsThemeOptionSystem => '시스템 기본값';

  @override
  String get settingsThemeOptionLight => '빛';

  @override
  String get settingsThemeOptionDark => '어두운';

  @override
  String get archivedAccountsTitle => '보관된 계정';

  @override
  String get archivedAccountsEmptyTitle => '보관된 계정 없음';

  @override
  String get archivedAccountsEmptyBody =>
      '장부 잔액과 당좌 대월은 0이어야 합니다. 검토의 계정 옵션에서 보관하세요.';

  @override
  String get categoriesTitle => '카테고리';

  @override
  String get newCategoryTitle => '새 카테고리';

  @override
  String get categoryNameLabel => '카테고리 이름';

  @override
  String get deleteCategoryTitle => '카테고리를 삭제하시겠습니까?';

  @override
  String deleteCategoryBody(String category) {
    return '\'$category\'이 목록에서 제거됩니다.';
  }

  @override
  String get categoryIncome => '소득';

  @override
  String get categoryExpense => '비용';

  @override
  String get categoryAdd => '추가하다';

  @override
  String get searchCurrencies => '통화 검색…';

  @override
  String get period1M => '100만';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1년';

  @override
  String get periodAll => '모두';

  @override
  String get categoryLabel => '범주';

  @override
  String get categoriesLabel => '카테고리';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type 저장됨 • $amount';
  }

  @override
  String get tooltipSettings => '설정';

  @override
  String get tooltipAddAccount => '계정 추가';

  @override
  String get tooltipRemoveAccount => '계정 삭제';

  @override
  String get accountNameTaken =>
      '이 이름과 식별자(활성 또는 보관됨)를 가진 계정이 이미 있습니다. 이름이나 식별자를 변경하세요.';

  @override
  String get groupDescPersonal => '나만의 지갑과 은행 계좌';

  @override
  String get groupDescIndividuals => '가족, 친구, 개인';

  @override
  String get groupDescEntities => '법인, 유틸리티, 조직';

  @override
  String get cannotArchiveTitle => '아직 보관할 수 없습니다.';

  @override
  String get cannotArchiveBody =>
      '보관은 장부 잔액과 당좌 대월 한도가 모두 사실상 0인 경우에만 사용할 수 있습니다.';

  @override
  String get cannotArchiveBodyAdjust =>
      '보관은 장부 잔액과 당좌 대월 한도가 모두 사실상 0인 경우에만 사용할 수 있습니다. 원장이나 시설을 먼저 조정하세요.';

  @override
  String get archiveAccountTitle => '계정을 보관하시겠습니까?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count건이 이 계정을 참조하는 예정 거래가 더 있습니다.',
      one: '예정 거래 1건이 이 계정을 참조합니다.',
    );
    return '$_temp0 보관된 계정과 계획의 일관성을 유지하려면 삭제하세요.';
  }

  @override
  String get removeAndArchive => '계획된 아카이브 및 아카이브 제거';

  @override
  String get archiveBody => '검토, 추적 및 계획 선택기에서 계정이 숨겨집니다. 설정에서 복원할 수 있습니다.';

  @override
  String get archiveAction => '보관소';

  @override
  String get archiveInstead => '대신 보관처리';

  @override
  String get cannotDeleteTitle => '계정을 삭제할 수 없습니다';

  @override
  String get cannotDeleteBodyShort =>
      '이 계정은 귀하의 운동기록에 나타납니다. 해당 거래를 먼저 제거하거나 재할당하거나, 잔액이 삭제된 경우 계정을 보관하세요.';

  @override
  String get cannotDeleteBodyHistory =>
      '이 계정은 귀하의 운동기록에 나타납니다. 삭제하면 해당 기록이 손상됩니다. 먼저 해당 거래를 제거하거나 재할당하세요.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      '이 계정은 운동기록에 나타나므로 삭제할 수 없습니다. 장부 잔액과 당좌 대월이 삭제된 경우 대신 보관할 수 있습니다. 목록에서는 숨겨지지만 내역은 그대로 유지됩니다.';

  @override
  String get deleteAccountTitle => '계정을 삭제하시겠습니까?';

  @override
  String get deleteAccountBodyPermanent => '이 계정은 영구적으로 제거됩니다.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count건의 예정 거래가 이 계정을 참조하며 삭제됩니다.',
      one: '예정 거래 1건이 이 계정을 참조하며 삭제됩니다.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => '모두 삭제';

  @override
  String get editAccountTitle => '계정 편집';

  @override
  String get newAccountTitle => '새 계정';

  @override
  String get labelAccountName => '계정 이름';

  @override
  String get labelAccountIdentifier => '식별자(선택사항)';

  @override
  String get accountAppearanceSection => '아이콘 및 색상';

  @override
  String get accountPickIcon => '아이콘 선택';

  @override
  String get accountPickColor => '색상을 선택하세요';

  @override
  String get accountIconSheetTitle => '계정 아이콘';

  @override
  String get accountColorSheetTitle => '계정 색상';

  @override
  String get searchAccountIcons => 'Search icons by name…';

  @override
  String get accountIconSearchNoMatches => 'No icons match that search.';

  @override
  String get accountUseInitialLetter => '첫 글자';

  @override
  String get accountUseDefaultColor => '경기 그룹';

  @override
  String get labelRealBalance => '실제 균형';

  @override
  String get labelOverdraftLimit => '당좌 대월 / 대출 한도';

  @override
  String get labelCurrency => '통화';

  @override
  String get saveChanges => '변경 사항 저장';

  @override
  String get addAccountAction => '계정 추가';

  @override
  String get removeAccountSheetTitle => '계정 삭제';

  @override
  String get deletePermanently => '영구 삭제';

  @override
  String get deletePermanentlySubtitle =>
      '이 계정이 추적에서 사용되지 않는 경우에만 가능합니다. 계획된 항목은 삭제의 일부로 제거될 수 있습니다.';

  @override
  String get archiveOptionSubtitle =>
      '검토 및 선택기에서 숨깁니다. 언제든지 설정에서 복원하세요. 제로 잔액과 당좌 대월이 필요합니다.';

  @override
  String get archivedBannerText =>
      '이 계정은 보관되었습니다. 이는 데이터에 유지되지만 목록 및 선택기에서는 숨겨집니다.';

  @override
  String get balanceAdjustedTitle => '트랙에서 밸런스 조정됨';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return '실제 잔액이 $previous에서 $current $symbol로 업데이트되었습니다.\n\n원장의 일관성을 유지하기 위해 추적(내역)에 잔액 조정 거래가 생성되었습니다.\n\n• 실제 잔액은 이 계좌의 실제 금액을 반영합니다.\n• 조정 항목에 대한 기록을 확인합니다.';
  }

  @override
  String get ok => '좋아요';

  @override
  String get categoryBalanceAdjustment => '밸런스 조정';

  @override
  String get descriptionBalanceCorrection => '밸런스 수정';

  @override
  String get descriptionOpeningBalance => '기초 잔액';

  @override
  String get reviewStatsModeStatistics => '통계';

  @override
  String get reviewStatsModeComparison => '비교';

  @override
  String get statsUncategorized => '분류되지 않음';

  @override
  String get statsNoCategories => '선택한 기간에는 비교를 위해 카테고리가 없습니다.';

  @override
  String get statsNoTransactions => '거래 없음';

  @override
  String get statsSpendingInCategory => '이 카테고리의 지출';

  @override
  String get statsIncomeInCategory => '이 카테고리의 소득';

  @override
  String get statsDifference => '차이점(B 대 A):';

  @override
  String get statsNoExpensesMonth => '이번 달에는 지출이 없습니다';

  @override
  String get statsNoExpensesAll => '기록된 비용이 없습니다.';

  @override
  String statsNoExpensesPeriod(String period) {
    return '지난번에는 비용이 발생하지 않았습니다 $period';
  }

  @override
  String get statsTotalSpent => '총 지출액';

  @override
  String get statsNoExpensesThisPeriod => '이 기간에는 비용이 발생하지 않습니다.';

  @override
  String get statsNoIncomeMonth => '이번 달에는 수입이 없습니다';

  @override
  String get statsNoIncomeAll => '소득이 기록되지 않았습니다.';

  @override
  String statsNoIncomePeriod(String period) {
    return '최근 수입이 없습니다 $period';
  }

  @override
  String get statsTotalReceived => '총 수령액';

  @override
  String get statsNoIncomeThisPeriod => '이 기간에는 수입이 없습니다.';

  @override
  String get catSalary => '샐러리';

  @override
  String get catFreelance => '프리랜서';

  @override
  String get catConsulting => '컨설팅';

  @override
  String get catGift => '선물';

  @override
  String get catRental => '렌탈';

  @override
  String get catDividends => '배당금';

  @override
  String get catRefund => '환불하다';

  @override
  String get catBonus => '보너스';

  @override
  String get catInterest => '관심';

  @override
  String get catSideHustle => '부업';

  @override
  String get catSaleOfGoods => '상품 판매';

  @override
  String get catOther => '다른';

  @override
  String get catGroceries => '식료 잡화류';

  @override
  String get catDining => '다이닝';

  @override
  String get catTransport => '수송';

  @override
  String get catUtilities => '유용';

  @override
  String get catHousing => '주택';

  @override
  String get catHealthcare => '헬스케어';

  @override
  String get catEntertainment => '오락';

  @override
  String get catShopping => '쇼핑';

  @override
  String get catTravel => '여행하다';

  @override
  String get catEducation => '교육';

  @override
  String get catSubscriptions => '구독';

  @override
  String get catInsurance => '보험';

  @override
  String get catFuel => '연료';

  @override
  String get catGym => '체육관';

  @override
  String get catPets => '애완동물';

  @override
  String get catKids => '어린이';

  @override
  String get catCharity => '자선 단체';

  @override
  String get catCoffee => '커피';

  @override
  String get catGifts => '선물';

  @override
  String semanticsProjectionDate(String date) {
    return '투사일 $date. 날짜를 선택하려면 두 번 탭하세요.';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return '예상 개인 잔액 $amount';
  }

  @override
  String get statsEmptyTitle => '아직 거래가 없습니다.';

  @override
  String get statsEmptySubtitle => '선택한 범위에 대한 지출 데이터가 없습니다.';

  @override
  String get semanticsShowProjections => '계정별 예상 잔액 표시';

  @override
  String get semanticsHideProjections => '계정별 예상 잔액 숨기기';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Show account balances for this day';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Hide account balances for this day';

  @override
  String get semanticsDateAllTime => '날짜: 항상 — 모드를 변경하려면 탭하세요.';

  @override
  String semanticsDateMode(String mode) {
    return '날짜: $mode — 탭하여 모드 변경';
  }

  @override
  String get semanticsDateThisMonth =>
      '날짜: 이번 달 — 탭하여 월, 주, 연도 또는 전체 기간을 확인하세요.';

  @override
  String get semanticsTxTypeCycle => '거래형태 : 순환전체, 수입, 지출, 이체';

  @override
  String get semanticsAccountFilter => '계정 필터';

  @override
  String get semanticsAlreadyFiltered => '이 계정으로 이미 필터링되었습니다.';

  @override
  String get semanticsCategoryFilter => '카테고리 필터';

  @override
  String get semanticsSortToggle => '정렬: 최신 항목 또는 오래된 항목부터 전환';

  @override
  String get semanticsFiltersDisabled =>
      '미래의 예상 날짜를 보는 동안 목록 필터가 비활성화되었습니다. 필터를 사용하려면 투영을 지우세요.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      '목록 필터가 비활성화되었습니다. 먼저 계정을 추가하세요.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      '목록 필터가 비활성화되었습니다. 먼저 계획된 거래를 추가하세요.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      '목록 필터가 비활성화되었습니다. 먼저 거래를 기록하세요.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      '섹션 및 통화 제어가 비활성화되었습니다. 먼저 계정을 추가하세요.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      '예상 날짜 및 잔액 분석이 비활성화되었습니다. 먼저 계정과 계획된 거래를 추가하세요.';

  @override
  String get semanticsReorderAccountHint =>
      '이 그룹 내에서 순서를 변경하려면 길게 누른 다음 드래그하세요.';

  @override
  String get semanticsChartStyle => '차트 스타일';

  @override
  String get semanticsChartStyleUnavailable => '차트 스타일(비교 모드에서는 사용할 수 없음)';

  @override
  String semanticsPeriod(String label) {
    return '기간: $label';
  }

  @override
  String get trackSearchHint => '검색 설명, 카테고리, 계정…';

  @override
  String get trackSearchClear => '검색 지우기';

  @override
  String get settingsExchangeRatesTitle => '환율';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return '최종 업데이트: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      '오프라인 또는 묶음 요금 사용 - 새로고침하려면 탭하세요.';

  @override
  String get settingsExchangeRatesSource => 'ECB';

  @override
  String get settingsExchangeRatesUpdatedSnack => '환율이 업데이트되었습니다.';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      '환율을 업데이트할 수 없습니다. 연결을 확인하세요.';

  @override
  String get settingsClearData => '데이터 지우기';

  @override
  String get settingsClearDataSubtitle => '선택한 데이터를 영구적으로 제거';

  @override
  String get clearDataTitle => '데이터 지우기';

  @override
  String get clearDataTransactions => '거래 내역';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count 거래 · 계정 잔액이 0으로 재설정됨';
  }

  @override
  String get clearDataPlanned => '계획된 거래';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count 예정상품';
  }

  @override
  String get clearDataAccounts => '계정';

  @override
  String clearDataAccountsSubtitle(int count) {
    return '$count 계정 · 기록 및 계획도 삭제';
  }

  @override
  String get clearDataCategories => '카테고리';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return '$count 카테고리 · 기본값으로 대체됨';
  }

  @override
  String get clearDataPreferences => '환경설정';

  @override
  String get clearDataPreferencesSubtitle => '통화, 테마, 언어를 기본값으로 재설정';

  @override
  String get clearDataSecurity => '앱 잠금 및 PIN';

  @override
  String get clearDataSecuritySubtitle => '앱 잠금을 비활성화하고 PIN을 제거합니다.';

  @override
  String get clearDataConfirmButton => '선택 항목 지우기';

  @override
  String get clearDataConfirmTitle => '이 작업은 취소할 수 없습니다.';

  @override
  String get clearDataConfirmBody =>
      '선택한 데이터가 영구적으로 삭제됩니다. 나중에 필요할 경우 먼저 백업을 내보내십시오.';

  @override
  String get clearDataTypeConfirm => '확인하려면 DELETE를 입력하세요.';

  @override
  String get clearDataTypeConfirmError => '계속하려면 DELETE를 정확히 입력하세요.';

  @override
  String get clearDataPinTitle => 'PIN으로 확인';

  @override
  String get clearDataPinBody => '이 작업을 승인하려면 앱 PIN을 입력하세요.';

  @override
  String get clearDataPinIncorrect => '잘못된 PIN';

  @override
  String get clearDataDone => '선택한 데이터가 삭제되었습니다.';

  @override
  String get autoBackupTitle => '매일 자동 백업';

  @override
  String autoBackupLastAt(String date) {
    return '마지막 백업 $date';
  }

  @override
  String get autoBackupNeverRun => '아직 백업이 없습니다';

  @override
  String get autoBackupShareTitle => '클라우드에 저장';

  @override
  String get autoBackupShareSubtitle =>
      'iCloud Drive, Google Drive 또는 모든 앱에 최신 백업 업로드';

  @override
  String get autoBackupCloudReminder => '자동 백업 준비 - 기기 외부 보호를 위해 클라우드에 저장';

  @override
  String get autoBackupCloudReminderAction => '공유';

  @override
  String get persistenceErrorReloaded =>
      '변경사항을 저장할 수 없습니다. 데이터가 저장소에서 다시 로드되었습니다.';
}
