// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Platforma';

  @override
  String get navPlan => 'Plan';

  @override
  String get navTrack => 'Ścieżka';

  @override
  String get navReview => 'Recenzja';

  @override
  String get cancel => 'Anulować';

  @override
  String get delete => 'Usuwać';

  @override
  String get close => 'Zamknąć';

  @override
  String get add => 'Dodać';

  @override
  String get undo => 'Anulować';

  @override
  String get confirm => 'Potwierdzać';

  @override
  String get restore => 'Przywrócić';

  @override
  String get heroIn => 'W';

  @override
  String get heroOut => 'Na zewnątrz';

  @override
  String get heroNet => 'Internet';

  @override
  String get heroBalance => 'Balansować';

  @override
  String get realBalance => 'Prawdziwa równowaga';

  @override
  String get settingsHideHeroBalancesTitle =>
      'Ukryj salda w kartach podsumowania';

  @override
  String get settingsHideHeroBalancesSubtitle =>
      'Gdy włączone, kwoty w Planie, Śledzeniu i Przeglądzie pozostają zamaskowane, dopóki nie naciśniesz ikony oka na każdej karcie. Gdy wyłączone, salda są zawsze widoczne.';

  @override
  String get heroBalancesShow => 'Pokaż salda';

  @override
  String get heroBalancesHide => 'Ukryj salda';

  @override
  String get semanticsHeroBalanceHidden => 'Saldo ukryte dla prywatności';

  @override
  String get heroResetButton => 'Nastawić';

  @override
  String get fabScrollToTop => 'Na górę';

  @override
  String get fabPickProjectionDate => 'Wybierz datę projekcji';

  @override
  String get filterAll => 'Wszystko';

  @override
  String get filterAllAccounts => 'Wszystkie konta';

  @override
  String get filterAllCategories => 'Wszystkie kategorie';

  @override
  String get txLabelIncome => 'DOCHÓD';

  @override
  String get txLabelExpense => 'KOSZT';

  @override
  String get txLabelInvoice => 'FAKTURA';

  @override
  String get txLabelBill => 'RACHUNEK';

  @override
  String get txLabelAdvance => 'OSIĄGNIĘCIE';

  @override
  String get txLabelSettlement => 'OSADA';

  @override
  String get txLabelLoan => 'POŻYCZKA';

  @override
  String get txLabelCollection => 'KOLEKCJA';

  @override
  String get txLabelOffset => 'ZRÓWNOWAŻYĆ';

  @override
  String get txLabelTransfer => 'PRZENOSIĆ';

  @override
  String get txLabelTransaction => 'TRANSAKCJA';

  @override
  String get repeatNone => 'Żadnego powtórzenia';

  @override
  String get repeatDaily => 'Codziennie';

  @override
  String get repeatWeekly => 'Tygodnik';

  @override
  String get repeatMonthly => 'Miesięczny';

  @override
  String get repeatYearly => 'Rocznie';

  @override
  String get repeatEveryLabel => 'Każdy';

  @override
  String repeatEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dni',
      one: 'dzień',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tygodnie',
      one: 'tydzień',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miesiące',
      one: 'miesiąc',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lata',
      one: 'rok',
    );
    return '$_temp0';
  }

  @override
  String get repeatEndLabel => 'Kończy się';

  @override
  String get repeatEndNever => 'Nigdy';

  @override
  String get repeatEndOnDate => 'Na randce';

  @override
  String repeatEndAfterCount(int count) {
    return 'Po $count razy';
  }

  @override
  String get repeatEndAfterChoice => 'Po określonej liczbie razy';

  @override
  String get repeatEndPickDate => 'Wybierz datę zakończenia';

  @override
  String get repeatEndTimes => 'czasy';

  @override
  String repeatSummaryEvery(String unit) {
    return 'Co $unit';
  }

  @override
  String repeatSummaryUntil(String date) {
    return 'do $date';
  }

  @override
  String repeatSummaryTimes(int count) {
    return '$count razy';
  }

  @override
  String repeatSummaryTimesRemaining(int remaining, int total) {
    return 'Pozostało $remaining z $total';
  }

  @override
  String get detailRepeatEvery => 'Powtarzaj co';

  @override
  String get detailEnds => 'Kończy się';

  @override
  String get detailEndsNever => 'Nigdy';

  @override
  String detailEndsOnDate(String date) {
    return 'Na $date';
  }

  @override
  String detailEndsAfterCount(int count) {
    return 'Po $count razy';
  }

  @override
  String get detailProgress => 'Postęp';

  @override
  String get weekendNoChange => 'Bez zmian';

  @override
  String get weekendFriday => 'Przenieś na piątek';

  @override
  String get weekendMonday => 'Przenieś na poniedziałek';

  @override
  String weekendQuestion(String day) {
    return 'Jeśli $day wypada w weekend?';
  }

  @override
  String get dateToday => 'Dzisiaj';

  @override
  String get dateTomorrow => 'Jutro';

  @override
  String get dateYesterday => 'Wczoraj';

  @override
  String get statsAllTime => 'Cały czas';

  @override
  String get accountGroupPersonal => 'Osobisty';

  @override
  String get accountGroupIndividual => 'Indywidualny';

  @override
  String get accountGroupEntity => 'Podmiot';

  @override
  String get accountSectionIndividuals => 'Osoby';

  @override
  String get accountSectionEntities => 'Podmioty';

  @override
  String get emptyNoTransactionsYet => 'Nie ma jeszcze żadnych transakcji';

  @override
  String get emptyNoAccountsYet => 'Nie ma jeszcze kont';

  @override
  String get emptyRecordFirstTransaction =>
      'Naciśnij poniższy przycisk, aby zarejestrować swoją pierwszą transakcję.';

  @override
  String get emptyAddFirstAccountTx =>
      'Dodaj swoje pierwsze konto przed zarejestrowaniem transakcji.';

  @override
  String get emptyAddFirstAccountPlan =>
      'Dodaj swoje pierwsze konto przed planowaniem transakcji.';

  @override
  String get emptyAddFirstAccountReview =>
      'Dodaj swoje pierwsze konto, aby rozpocząć śledzenie swoich finansów.';

  @override
  String get emptyAddTransaction => 'Dodaj transakcję';

  @override
  String get emptyAddAccount => 'Dodaj konto';

  @override
  String get reviewEmptyGroupPersonalTitle => 'Nie ma jeszcze kont osobistych';

  @override
  String get reviewEmptyGroupPersonalBody =>
      'Konta osobiste to Twoje własne portfele i konta bankowe. Dodaj jeden, aby śledzić codzienne dochody i wydatki.';

  @override
  String get reviewEmptyGroupIndividualsTitle =>
      'Nie ma jeszcze kont indywidualnych';

  @override
  String get reviewEmptyGroupIndividualsBody =>
      'Konta indywidualne śledzą pieniądze konkretnych osób — wspólne koszty, pożyczki lub IOU. Dodaj konto dla każdej osoby, z którą się rozliczasz.';

  @override
  String get reviewEmptyGroupEntitiesTitle => 'Nie ma jeszcze kont podmiotów';

  @override
  String get reviewEmptyGroupEntitiesBody =>
      'Konta jednostek są przeznaczone dla firm, projektów i organizacji. Skorzystaj z nich, aby oddzielić przepływy pieniężne firmy od finansów osobistych.';

  @override
  String get emptyNoTransactionsForFilters =>
      'Brak transakcji dla zastosowanych filtrów';

  @override
  String get emptyNoTransactionsInHistory => 'Brak transakcji w historii';

  @override
  String emptyNoTransactionsForMonth(String month) {
    return 'Brak transakcji dla $month';
  }

  @override
  String get emptyNoTransactionsForAccount => 'Brak transakcji na tym koncie';

  @override
  String get trackTransactionDeleted => 'Transakcja usunięta';

  @override
  String get trackDeleteTitle => 'Usunąć transakcję?';

  @override
  String get trackDeleteBody =>
      'Spowoduje to odwrócenie zmian w saldzie konta.';

  @override
  String get trackTransaction => 'Transakcja';

  @override
  String get planConfirmTitle => 'Potwierdzić transakcję?';

  @override
  String planConfirmBodyEarly(String date, String todayDate, String nextDate) {
    return 'Wydarzenie to zaplanowano na $date. Zostanie on zapisany w Historii z dzisiejszą datą ($todayDate). Następne wystąpienie pozostaje na $nextDate.';
  }

  @override
  String get planConfirmBodyNormal =>
      'Spowoduje to zastosowanie transakcji do salda Twojego konta rzeczywistego i przeniesienie jej do Historii.';

  @override
  String get planTransactionConfirmed =>
      'Transakcja potwierdzona i zastosowana';

  @override
  String get planTransactionRemoved => 'Planowana transakcja została usunięta';

  @override
  String get planRepeatingTitle => 'Powtarzająca się transakcja';

  @override
  String get planRepeatingBody =>
      'Pomiń tylko tę datę — seria będzie kontynuowana od następnego wystąpienia — lub usuń wszystkie pozostałe zdarzenia ze swojego planu.';

  @override
  String get planDeleteAll => 'Usuń wszystko';

  @override
  String get planSkipThisOnly => 'Pomiń tylko to';

  @override
  String get planOccurrenceSkipped =>
      'To zdarzenie zostało pominięte — zaplanowano następne';

  @override
  String get planNothingPlanned => 'Na razie nic nie planuje';

  @override
  String get planPlanBody => 'Zaplanuj nadchodzące transakcje.';

  @override
  String get planAddPlan => 'Dodaj plan';

  @override
  String get planNoPlannedForFilters =>
      'Brak planowanych transakcji dla zastosowanych filtrów';

  @override
  String planNoPlannedInMonth(String month) {
    return 'Brak planowanych transakcji w $month';
  }

  @override
  String get planOverdue => 'zaległy';

  @override
  String get planPlannedTransaction => 'Planowana transakcja';

  @override
  String get discardTitle => 'Odrzucić zmiany?';

  @override
  String get discardBody =>
      'Masz niezapisane zmiany. Zginą, jeśli teraz odejdziesz.';

  @override
  String get keepEditing => 'Edytuj dalej';

  @override
  String get discard => 'Odrzuć';

  @override
  String get newTransactionTitle => 'Nowa transakcja';

  @override
  String get editTransactionTitle => 'Edytuj transakcję';

  @override
  String get transactionUpdated => 'Transakcja zaktualizowana';

  @override
  String get sectionAccounts => 'Konta';

  @override
  String get labelFrom => 'Z';

  @override
  String get labelTo => 'Do';

  @override
  String get sectionCategory => 'Kategoria';

  @override
  String get sectionAttachments => 'Załączniki';

  @override
  String get labelNote => 'Notatka';

  @override
  String get hintOptionalDescription => 'Opcjonalny opis';

  @override
  String get updateTransaction => 'Zaktualizuj transakcję';

  @override
  String get saveTransaction => 'Zapisz transakcję';

  @override
  String get selectAccount => 'Wybierz konto';

  @override
  String get selectAccountTitle => 'Wybierz Konto';

  @override
  String get noAccountsAvailable => 'Brak dostępnych kont';

  @override
  String amountReceivedBy(String name, String currency) {
    return 'Kwota otrzymana do $name ($currency)';
  }

  @override
  String get amountReceivedHelper =>
      'Wpisz dokładną kwotę, jaką otrzyma konto docelowe. Blokuje to zastosowany rzeczywisty kurs wymiany.';

  @override
  String get attachTakePhoto => 'Zrób zdjęcie';

  @override
  String get attachTakePhotoSub => 'Użyj aparatu, aby uchwycić paragon';

  @override
  String get attachChooseGallery => 'Wybierz z galerii';

  @override
  String get attachChooseGallerySub => 'Wybierz zdjęcia ze swojej biblioteki';

  @override
  String get attachBrowseFiles => 'Przeglądaj pliki';

  @override
  String get attachBrowseFilesSub =>
      'Dołącz pliki PDF, dokumenty lub inne pliki';

  @override
  String get attachButton => 'Przytwierdzać';

  @override
  String get editPlanTitle => 'Edytuj plan';

  @override
  String get planTransactionTitle => 'Zaplanuj transakcję';

  @override
  String get tapToSelect => 'Kliknij, aby wybrać';

  @override
  String get updatePlan => 'Aktualizuj plan';

  @override
  String get addToPlan => 'Dodaj do planu';

  @override
  String get labelRepeat => 'Powtarzać';

  @override
  String get selectPlannedDate => 'Wybierz planowaną datę';

  @override
  String get balancesAsOfToday => 'Salda na dzień dzisiejszy';

  @override
  String get projectedBalancesForTomorrow => 'Prognozowane salda na jutro';

  @override
  String projectedBalancesForDate(String date) {
    return 'Prognozowane salda dla $date';
  }

  @override
  String destReceivesLabel(String name, String currency) {
    return '$name odbiera ($currency)';
  }

  @override
  String get destHelper =>
      'Szacowana kwota docelowa. Dokładna stawka jest zablokowana po potwierdzeniu.';

  @override
  String get descriptionOptional => 'Opis (opcjonalnie)';

  @override
  String get detailTransactionTitle => 'Transakcja';

  @override
  String get detailPlannedTitle => 'Planowany';

  @override
  String get detailConfirmTransaction => 'Potwierdź transakcję';

  @override
  String get detailDate => 'Data';

  @override
  String get detailFrom => 'Z';

  @override
  String get detailTo => 'Do';

  @override
  String get detailCategory => 'Kategoria';

  @override
  String get detailNote => 'Notatka';

  @override
  String get detailDestinationAmount => 'Kwota docelowa';

  @override
  String get detailExchangeRate => 'Kurs wymiany';

  @override
  String get detailRepeats => 'Powtarza';

  @override
  String get detailDayOfMonth => 'Dzień miesiąca';

  @override
  String get detailWeekends => 'Weekendy';

  @override
  String get detailAttachments => 'Załączniki';

  @override
  String detailFileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pliki',
      one: '1 plik',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsSectionDisplay => 'Wyświetlacz';

  @override
  String get settingsSectionLanguage => 'Język';

  @override
  String get settingsSectionCategories => 'Kategorie';

  @override
  String get settingsSectionAccounts => 'Konta';

  @override
  String get settingsSectionPreferences => 'Preferencje';

  @override
  String get settingsSectionManage => 'Zarządzać';

  @override
  String get settingsBaseCurrency => 'Waluta krajowa';

  @override
  String get settingsSecondaryCurrency => 'Waluta wtórna';

  @override
  String get settingsCategories => 'Kategorie';

  @override
  String settingsCategoriesSubtitle(int incomeCount, int expenseCount) {
    return '$incomeCount dochód · $expenseCount wydatek';
  }

  @override
  String get settingsArchivedAccounts => 'Zarchiwizowane konta';

  @override
  String get settingsArchivedAccountsSubtitleZero =>
      'Brak w tej chwili — archiwum z edycji konta, gdy saldo zostanie wyczyszczone';

  @override
  String settingsArchivedAccountsSubtitleCount(int count) {
    return '$count ukryty przed recenzją i selektorami';
  }

  @override
  String get settingsSectionData => 'Dane';

  @override
  String get settingsSectionPrivacy => 'O';

  @override
  String get settingsPrivacyPolicyTitle => 'Polityka prywatności';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Jak Platrare obsługuje Twoje dane.';

  @override
  String get settingsPrivacyFxDisclosure =>
      'Kursy wymiany: aplikacja pobiera publiczne kursy walut przez Internet. Twoje konta i transakcje nigdy nie są wysyłane.';

  @override
  String get settingsPrivacyOpenFailed =>
      'Nie udało się wczytać polityki prywatności.';

  @override
  String get settingsPrivacyRetry => 'Spróbuj ponownie';

  @override
  String get settingsSoftwareVersionTitle => 'Wersja oprogramowania';

  @override
  String get settingsSoftwareVersionSubtitle =>
      'Wydanie, diagnostyka i legalność';

  @override
  String get aboutScreenTitle => 'O';

  @override
  String get aboutAppTagline =>
      'Księga, przepływ środków pieniężnych i planowanie w jednym obszarze roboczym.';

  @override
  String get aboutDescriptionBody =>
      'Platrare przechowuje konta, transakcje i plany na Twoim urządzeniu. Eksportuj zaszyfrowane kopie zapasowe, gdy potrzebujesz kopii w innym miejscu. Kursy wymiany wykorzystują wyłącznie publiczne dane rynkowe; Twoja księga nie została przesłana.';

  @override
  String get aboutVersionLabel => 'Wersja';

  @override
  String get aboutBuildLabel => 'Zbudować';

  @override
  String get aboutCopySupportDetails => 'Skopiuj szczegóły wsparcia';

  @override
  String get aboutOpenPrivacySubtitle =>
      'Otwiera pełny dokument zasad w aplikacji.';

  @override
  String get aboutSupportBundleLocaleLabel => 'Widownia';

  @override
  String get settingsSupportInfoCopied => 'Skopiowano do schowka';

  @override
  String get settingsVerifyLedger => 'Zweryfikuj dane';

  @override
  String get settingsVerifyLedgerSubtitle =>
      'Sprawdź, czy saldo konta jest zgodne z historią transakcji';

  @override
  String get settingsDataExportTitle => 'Eksportuj kopię zapasową';

  @override
  String get settingsDataExportSubtitle =>
      'Zapisz jako .zip lub zaszyfrowany .platrare ze wszystkimi danymi i załącznikami';

  @override
  String get settingsDataImportTitle => 'Przywróć z kopii zapasowej';

  @override
  String get settingsDataImportSubtitle =>
      'Zastąp bieżące dane z kopii zapasowej Platrare .zip lub .platrare';

  @override
  String get backupExportDialogTitle => 'Chroń tę kopię zapasową';

  @override
  String get backupExportDialogBody =>
      'Zalecane jest stosowanie silnego hasła, szczególnie jeśli przechowujesz plik w chmurze. Do importowania potrzebne jest to samo hasło.';

  @override
  String get backupExportPasswordLabel => 'Hasło';

  @override
  String get backupExportPasswordConfirmLabel => 'Potwierdź hasło';

  @override
  String get backupExportPasswordMismatch => 'Hasła nie pasują';

  @override
  String get backupExportPasswordEmpty =>
      'Wprowadź poniżej pasujące hasło lub wyeksportuj bez szyfrowania.';

  @override
  String get backupExportPasswordTooShort =>
      'Hasło musi mieć co najmniej 8 znaków.';

  @override
  String get backupExportSaveToDevice => 'Zapisz na urządzeniu';

  @override
  String get backupExportShareToCloud => 'Udostępnij (iCloud, Dysk…)';

  @override
  String get backupExportWithoutEncryption => 'Eksportuj bez szyfrowania';

  @override
  String get backupExportSkipWarningTitle => 'Eksportować bez szyfrowania?';

  @override
  String get backupExportSkipWarningBody =>
      'Każda osoba mająca dostęp do pliku może odczytać Twoje dane. Używaj tej opcji tylko w przypadku lokalnych kopii, które kontrolujesz.';

  @override
  String get backupExportSkipWarningConfirm => 'Eksportuj niezaszyfrowany';

  @override
  String get backupImportPasswordTitle => 'Szyfrowana kopia zapasowa';

  @override
  String get backupImportPasswordBody =>
      'Wprowadź hasło użyte podczas eksportowania.';

  @override
  String get backupImportPasswordLabel => 'Hasło';

  @override
  String get backupImportPreviewTitle => 'Podsumowanie kopii zapasowej';

  @override
  String backupImportPreviewVersion(String version) {
    return 'Wersja aplikacji: $version';
  }

  @override
  String backupImportPreviewExported(String date) {
    return 'Wyeksportowano: $date';
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
    return '$accounts rachunki · $transactions transakcje · $planned planowane · $attachments pliki załączników · $income kategorie dochodów · $expense kategorie wydatków';
  }

  @override
  String get backupImportPreviewContinue => 'Kontynuować';

  @override
  String get settingsBackupWrongPassword => 'Błędne hasło';

  @override
  String get settingsBackupChecksumMismatch =>
      'Nie udało się sprawdzić integralności kopii zapasowej';

  @override
  String get settingsBackupCorruptFile =>
      'Nieprawidłowy lub uszkodzony plik kopii zapasowej';

  @override
  String get settingsBackupUnsupportedVersion =>
      'Kopia zapasowa wymaga nowszej wersji aplikacji';

  @override
  String get settingsDataImportConfirmTitle => 'Zamienić bieżące dane?';

  @override
  String get settingsDataImportConfirmBody =>
      'Spowoduje to zastąpienie Twoich bieżących rachunków, transakcji, planowanych transakcji, kategorii i zaimportowanych załączników zawartością wybranej kopii zapasowej. Tej akcji nie można cofnąć.';

  @override
  String get settingsDataImportConfirmAction => 'Zamień dane';

  @override
  String get settingsDataImportDone => 'Dane zostały przywrócone pomyślnie';

  @override
  String get settingsDataImportInvalidFile =>
      'Ten plik nie jest prawidłową kopią zapasową Platrare';

  @override
  String get settingsDataImportFailed => 'Import nie powiódł się';

  @override
  String get settingsDataExportDoneTitle => 'Kopia zapasowa wyeksportowana';

  @override
  String settingsDataExportDoneBody(String path) {
    return 'Kopia zapasowa zapisana w:\n$path';
  }

  @override
  String get settingsDataOpenExportFile => 'Otwórz plik';

  @override
  String get settingsDataExportFailed => 'Eksport nie powiódł się';

  @override
  String get ledgerVerifyDialogTitle => 'Weryfikacja księgi';

  @override
  String get ledgerVerifyAllMatch => 'Wszystkie konta pasują.';

  @override
  String get ledgerVerifyMismatchesTitle => 'Niedopasowania';

  @override
  String ledgerVerifyMismatchDetails(
    String accountName,
    String stored,
    String replayed,
    String diff,
  ) {
    return '$accountName\nPrzechowywane: $stored\nPowtórka: $replayed\nRóżnica: $diff';
  }

  @override
  String get settingsLanguage => 'Język aplikacji';

  @override
  String get settingsLanguageSubtitleSystem =>
      'Następujące ustawienia systemowe';

  @override
  String get settingsLanguageSubtitleEnglish => 'angielski';

  @override
  String get settingsLanguageSubtitleSerbianLatin => 'serbski (łaciński)';

  @override
  String get settingsLanguagePickerTitle => 'Język aplikacji';

  @override
  String get settingsLanguageOptionSystem => 'Domyślne systemowe';

  @override
  String get settingsLanguageOptionEnglish => 'angielski';

  @override
  String get settingsLanguageOptionSerbianLatin => 'serbski (łaciński)';

  @override
  String get settingsSectionAppearance => 'Wygląd';

  @override
  String get settingsSectionSecurity => 'Bezpieczeństwo';

  @override
  String get settingsSecurityEnableLock => 'Zablokuj aplikację po otwarciu';

  @override
  String get settingsSecurityEnableLockSubtitle =>
      'Wymagaj odblokowania biometrycznego lub kodu PIN przy otwieraniu aplikacji';

  @override
  String get settingsSecurityLockDelayTitle => 'Ponowne blokowanie po tle';

  @override
  String get settingsSecurityLockDelaySubtitle =>
      'Jak długo aplikacja może pozostawać poza ekranem przed ponownym wymaganiem odblokowania. Natychmiast jest najbezpieczniejszą opcją.';

  @override
  String get settingsSecurityLockDelayImmediate => 'Natychmiast';

  @override
  String get settingsSecurityLockDelay30s => '30 sekund';

  @override
  String get settingsSecurityLockDelay1m => '1 minuta';

  @override
  String get settingsSecurityLockDelay5m => '5 minut';

  @override
  String get settingsSecuritySetPin => 'Ustaw PIN';

  @override
  String get settingsSecurityChangePin => 'Zmień PIN';

  @override
  String get settingsSecurityPinSubtitle =>
      'Użyj kodu PIN jako rozwiązania zastępczego, jeśli dane biometryczne są niedostępne';

  @override
  String get settingsSecurityRemovePin => 'Usuń PIN';

  @override
  String get securitySetPinTitle => 'Ustaw PIN aplikacji';

  @override
  String get securityPinLabel => 'Kod PIN';

  @override
  String get securityConfirmPinLabel => 'Potwierdź kod PIN';

  @override
  String get securityPinMustBe4Digits => 'PIN musi mieć co najmniej 4 cyfry';

  @override
  String get securityPinMismatch => 'Kody PIN nie pasują';

  @override
  String get securityRemovePinTitle => 'Usunąć PIN?';

  @override
  String get securityRemovePinBody =>
      'Jeśli jest to możliwe, nadal można korzystać z odblokowania biometrycznego.';

  @override
  String get securityUnlockTitle => 'Aplikacja zablokowana';

  @override
  String get securityUnlockSubtitle =>
      'Odblokuj za pomocą Face ID, odcisku palca lub PIN-u.';

  @override
  String get securityUnlockWithPin => 'Odblokuj za pomocą PIN-u';

  @override
  String get securityTryBiometric => 'Wypróbuj odblokowanie biometryczne';

  @override
  String get securityPinIncorrect => 'Nieprawidłowy PIN, spróbuj ponownie';

  @override
  String get securityBiometricReason => 'Uwierzytelnij, aby otworzyć aplikację';

  @override
  String get settingsTheme => 'Temat';

  @override
  String get settingsThemeSubtitleSystem => 'Następujące ustawienia systemowe';

  @override
  String get settingsThemeSubtitleLight => 'Światło';

  @override
  String get settingsThemeSubtitleDark => 'Ciemny';

  @override
  String get settingsThemePickerTitle => 'Temat';

  @override
  String get settingsThemeOptionSystem => 'Domyślne systemowe';

  @override
  String get settingsThemeOptionLight => 'Światło';

  @override
  String get settingsThemeOptionDark => 'Ciemny';

  @override
  String get archivedAccountsTitle => 'Zarchiwizowane konta';

  @override
  String get archivedAccountsEmptyTitle => 'Brak zarchiwizowanych kont';

  @override
  String get archivedAccountsEmptyBody =>
      'Saldo księgowe i debet muszą wynosić zero. Archiwizuj opcje konta w Przeglądzie.';

  @override
  String get categoriesTitle => 'Kategorie';

  @override
  String get newCategoryTitle => 'Nowa kategoria';

  @override
  String get categoryNameLabel => 'Nazwa kategorii';

  @override
  String get deleteCategoryTitle => 'Usunąć kategorię?';

  @override
  String deleteCategoryBody(String category) {
    return '„$category” zostanie usunięte z listy.';
  }

  @override
  String get categoryIncome => 'Dochód';

  @override
  String get categoryExpense => 'Koszt';

  @override
  String get categoryAdd => 'Dodać';

  @override
  String get searchCurrencies => 'Wyszukaj waluty…';

  @override
  String get period1M => '1M';

  @override
  String get period3M => '3M';

  @override
  String get period6M => '6M';

  @override
  String get period1Y => '1 rok';

  @override
  String get periodAll => 'WSZYSTKO';

  @override
  String get categoryLabel => 'kategoria';

  @override
  String get categoriesLabel => 'kategorie';

  @override
  String transactionSavedMessage(String type, String amount) {
    return '$type zapisane • $amount';
  }

  @override
  String get tooltipSettings => 'Ustawienia';

  @override
  String get tooltipAddAccount => 'Dodaj konto';

  @override
  String get tooltipRemoveAccount => 'Usuń konto';

  @override
  String get accountNameTaken =>
      'Masz już konto o tej nazwie i identyfikatorze (aktywne lub zarchiwizowane). Zmień nazwę lub identyfikator.';

  @override
  String get groupDescPersonal => 'Twoje własne portfele i konta bankowe';

  @override
  String get groupDescIndividuals => 'Rodzina, przyjaciele, pojedyncze osoby';

  @override
  String get groupDescEntities => 'Podmioty, narzędzia, organizacje';

  @override
  String get cannotArchiveTitle => 'Nie można jeszcze archiwizować';

  @override
  String get cannotArchiveBody =>
      'Archiwum jest dostępne tylko wtedy, gdy saldo księgowe i limit kredytu w rachunku bieżącym wynoszą faktycznie zero.';

  @override
  String get cannotArchiveBodyAdjust =>
      'Archiwum jest dostępne tylko wtedy, gdy saldo księgowe i limit kredytu w rachunku bieżącym wynoszą faktycznie zero. Najpierw dostosuj księgę lub obiekt.';

  @override
  String get archiveAccountTitle => 'Zarchiwizować konto?';

  @override
  String archiveWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zaplanowanych transakcji odnosi się do tego konta.',
      one: '1 zaplanowana transakcja odnosi się do tego konta.',
    );
    return '$_temp0 Usuń je, aby plan był spójny z zarchiwizowanym kontem.';
  }

  @override
  String get removeAndArchive => 'Usuń zaplanowane i zarchiwizuj';

  @override
  String get archiveBody =>
      'Konto zostanie ukryte przed selektorami recenzji, śledzenia i planowania. Możesz go przywrócić w Ustawieniach.';

  @override
  String get archiveAction => 'Archiwum';

  @override
  String get archiveInstead => 'Zamiast tego zarchiwizuj';

  @override
  String get cannotDeleteTitle => 'Nie można usunąć konta';

  @override
  String get cannotDeleteBodyShort =>
      'To konto pojawi się w Twojej historii śledzenia. Najpierw usuń lub przypisz ponownie te transakcje albo zarchiwizuj konto, jeśli saldo zostanie wyczyszczone.';

  @override
  String get cannotDeleteBodyHistory =>
      'To konto pojawi się w Twojej historii śledzenia. Usunięcie spowodowałoby przerwanie tej historii — najpierw usuń lub ponownie przypisz te transakcje.';

  @override
  String get cannotDeleteBodySuggestArchive =>
      'To konto pojawia się w Twojej historii śledzenia, więc nie można go usunąć. Zamiast tego możesz go zarchiwizować, jeśli saldo księgowe i debet zostaną wyczyszczone — zostanie ono ukryte na listach, ale historia pozostanie nienaruszona.';

  @override
  String get deleteAccountTitle => 'Usunąć konto?';

  @override
  String get deleteAccountBodyPermanent => 'To konto zostanie trwale usunięte.';

  @override
  String deleteWithPlannedBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count zaplanowanych transakcji odnosi się do tego konta i zostaną usunięte.',
      one:
          '1 zaplanowana transakcja odnosi się do tego konta i zostanie usunięta.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAllAndDelete => 'Usuń wszystko';

  @override
  String get editAccountTitle => 'Edytuj konto';

  @override
  String get newAccountTitle => 'Nowe konto';

  @override
  String get labelAccountName => 'Nazwa konta';

  @override
  String get labelAccountIdentifier => 'Identyfikator (opcjonalnie)';

  @override
  String get accountAppearanceSection => 'Ikona i kolor';

  @override
  String get accountPickIcon => 'Wybierz ikonę';

  @override
  String get accountPickColor => 'Wybierz kolor';

  @override
  String get accountIconSheetTitle => 'Ikona konta';

  @override
  String get accountColorSheetTitle => 'Kolor konta';

  @override
  String get searchAccountIcons => 'Wyszukaj ikony według nazwy…';

  @override
  String get accountIconSearchNoMatches =>
      'Żadne ikony nie pasują do tego wyszukiwania.';

  @override
  String get accountUseInitialLetter => 'List początkowy';

  @override
  String get accountUseDefaultColor => 'Grupa meczowa';

  @override
  String get labelRealBalance => 'Prawdziwa równowaga';

  @override
  String get labelOverdraftLimit => 'Limit kredytu/zaliczki';

  @override
  String get labelCurrency => 'Waluta';

  @override
  String get saveChanges => 'Zapisz zmiany';

  @override
  String get addAccountAction => 'Dodaj konto';

  @override
  String get removeAccountSheetTitle => 'Usuń konto';

  @override
  String get deletePermanently => 'Usuń trwale';

  @override
  String get deletePermanentlySubtitle =>
      'Możliwe tylko wtedy, gdy to konto nie jest używane w Track. Zaplanowane elementy można usunąć w ramach usuwania.';

  @override
  String get archiveOptionSubtitle =>
      'Ukryj przed recenzją i selektorami. Przywróć w dowolnym momencie w Ustawieniach. Wymaga zerowego salda i debetu.';

  @override
  String get archivedBannerText =>
      'To konto jest zarchiwizowane. Pozostaje w Twoich danych, ale jest ukryty przed listami i selektorami.';

  @override
  String get balanceAdjustedTitle => 'Saldo skorygowane w Track';

  @override
  String balanceAdjustedBody(String previous, String current, String symbol) {
    return 'Saldo rzeczywiste zostało zaktualizowane z $previous do $current $symbol.\n\nW Ścieżce (Historia) utworzono transakcję korekty salda, aby zachować spójność księgi.\n\n• Saldo rzeczywiste odzwierciedla rzeczywistą kwotę na tym koncie.\n• Sprawdź historię wpisu regulacji.';
  }

  @override
  String get ok => 'OK';

  @override
  String get categoryBalanceAdjustment => 'Regulacja balansu';

  @override
  String get descriptionBalanceCorrection => 'Korekta balansu';

  @override
  String get descriptionOpeningBalance => 'Bilans otwarcia';

  @override
  String get reviewStatsModeStatistics => 'Statystyka';

  @override
  String get reviewStatsModeComparison => 'Porównanie';

  @override
  String get statsUncategorized => 'Bez kategorii';

  @override
  String get statsNoCategories =>
      'Brak kategorii w wybranych okresach do porównania.';

  @override
  String get statsNoTransactions => 'Żadnych transakcji';

  @override
  String get statsSpendingInCategory => 'Wydatki w tej kategorii';

  @override
  String get statsIncomeInCategory => 'Dochód w tej kategorii';

  @override
  String get statsDifference => 'Różnica (B vs A):';

  @override
  String get statsNoExpensesMonth => 'Żadnych wydatków w tym miesiącu';

  @override
  String get statsNoExpensesAll => 'Nie odnotowano żadnych wydatków';

  @override
  String statsNoExpensesPeriod(String period) {
    return 'Brak wydatków w ciągu ostatniego $period';
  }

  @override
  String get statsTotalSpent => 'Razem wydane';

  @override
  String get statsNoExpensesThisPeriod => 'Żadnych wydatków w tym okresie';

  @override
  String get statsNoIncomeMonth => 'Brak dochodów w tym miesiącu';

  @override
  String get statsNoIncomeAll => 'Nie odnotowano żadnego dochodu';

  @override
  String statsNoIncomePeriod(String period) {
    return 'Brak dochodu w ciągu ostatniego $period';
  }

  @override
  String get statsTotalReceived => 'Razem otrzymano';

  @override
  String get statsNoIncomeThisPeriod => 'Brak dochodów w tym okresie';

  @override
  String get catSalary => 'Wynagrodzenie';

  @override
  String get catFreelance => 'Pracownik nieetatowy';

  @override
  String get catConsulting => 'Ordynacyjny';

  @override
  String get catGift => 'Prezent';

  @override
  String get catRental => 'Dzierżawa';

  @override
  String get catDividends => 'Dywidendy';

  @override
  String get catRefund => 'Refundacja';

  @override
  String get catBonus => 'Premia';

  @override
  String get catInterest => 'Odsetki';

  @override
  String get catSideHustle => 'Boczny zgiełk';

  @override
  String get catSaleOfGoods => 'Sprzedaż towarów';

  @override
  String get catOther => 'Inny';

  @override
  String get catGroceries => 'Artykuły spożywcze';

  @override
  String get catDining => 'Wyżywienie';

  @override
  String get catTransport => 'Transport';

  @override
  String get catUtilities => 'Narzędzia';

  @override
  String get catHousing => 'Mieszkania';

  @override
  String get catHealthcare => 'Opieka zdrowotna';

  @override
  String get catEntertainment => 'Rozrywka';

  @override
  String get catShopping => 'Zakupy';

  @override
  String get catTravel => 'Podróż';

  @override
  String get catEducation => 'Edukacja';

  @override
  String get catSubscriptions => 'Subskrypcje';

  @override
  String get catInsurance => 'Ubezpieczenie';

  @override
  String get catFuel => 'Paliwo';

  @override
  String get catGym => 'Sala gimnastyczna';

  @override
  String get catPets => 'Zwierzęta';

  @override
  String get catKids => 'Dzieci';

  @override
  String get catCharity => 'Organizacja pożytku publicznego';

  @override
  String get catCoffee => 'Kawa';

  @override
  String get catGifts => 'Prezenty';

  @override
  String semanticsProjectionDate(String date) {
    return 'Data projekcji $date. Kliknij dwukrotnie, aby wybrać datę';
  }

  @override
  String semanticsProjectedBalance(String amount) {
    return 'Prognozowane saldo osobiste $amount';
  }

  @override
  String get statsEmptyTitle => 'Nie ma jeszcze żadnych transakcji';

  @override
  String get statsEmptySubtitle =>
      'Brak danych o wydatkach dla wybranego zakresu.';

  @override
  String get semanticsShowProjections =>
      'Pokaż prognozowane salda według konta';

  @override
  String get semanticsHideProjections =>
      'Ukryj przewidywane salda według konta';

  @override
  String get semanticsShowDayBalanceBreakdown =>
      'Pokaż salda kont na ten dzień';

  @override
  String get semanticsHideDayBalanceBreakdown =>
      'Ukryj salda kont na ten dzień';

  @override
  String get semanticsDateAllTime =>
      'Data: cały czas — dotknij, aby zmienić tryb';

  @override
  String semanticsDateMode(String mode) {
    return 'Data: $mode — dotknij, aby zmienić tryb';
  }

  @override
  String get semanticsDateThisMonth =>
      'Data: ten miesiąc — dotknij miesiąca, tygodnia, roku lub całego okresu';

  @override
  String get semanticsTxTypeCycle =>
      'Typ transakcji: cykl wszystko, dochód, wydatek, transfer';

  @override
  String get semanticsAccountFilter => 'Filtr konta';

  @override
  String get semanticsAlreadyFiltered => 'Już przefiltrowano do tego konta';

  @override
  String get semanticsCategoryFilter => 'Filtr kategorii';

  @override
  String get semanticsSortToggle =>
      'Sortuj: przełączaj najpierw najnowsze lub najstarsze';

  @override
  String get semanticsFiltersDisabled =>
      'Filtry listy wyłączone podczas wyświetlania przyszłej daty projekcji. Wyczyść projekcje, aby użyć filtrów.';

  @override
  String get semanticsFiltersDisabledNeedAccount =>
      'Filtry listy wyłączone. Najpierw dodaj konto.';

  @override
  String get semanticsFiltersDisabledNeedPlannedTransaction =>
      'Filtry listy wyłączone. Najpierw dodaj planowaną transakcję.';

  @override
  String get semanticsFiltersDisabledNeedRecordedTransaction =>
      'Filtry listy wyłączone. Najpierw zarejestruj transakcję.';

  @override
  String get semanticsReviewSectionChipsDisabledNeedAccount =>
      'Wyłączono kontrolę sekcji i walut. Najpierw dodaj konto.';

  @override
  String get semanticsPlanProjectionControlsDisabled =>
      'Data projekcji i podział salda wyłączone. Najpierw dodaj konto i planowaną transakcję.';

  @override
  String get semanticsReorderAccountHint =>
      'Naciśnij długo, a następnie przeciągnij, aby zmienić kolejność w tej grupie';

  @override
  String get semanticsChartStyle => 'Styl wykresu';

  @override
  String get semanticsChartStyleUnavailable =>
      'Styl wykresu (niedostępny w trybie porównania)';

  @override
  String semanticsPeriod(String label) {
    return 'Okres: $label';
  }

  @override
  String get trackSearchHint => 'Wyszukaj opis, kategorię, konto…';

  @override
  String get trackSearchClear => 'Wyczyść wyszukiwanie';

  @override
  String get settingsExchangeRatesTitle => 'Kursy wymiany';

  @override
  String settingsExchangeRatesUpdated(String time) {
    return 'Ostatnia aktualizacja: $time';
  }

  @override
  String get settingsExchangeRatesNeverUpdated =>
      'Korzystanie z stawek offline lub pakietowych — dotknij, aby odświeżyć';

  @override
  String get settingsExchangeRatesSource => 'EBC';

  @override
  String get settingsExchangeRatesUpdatedSnack => 'Zaktualizowano kursy walut';

  @override
  String get settingsExchangeRatesUpdateFailed =>
      'Nie można zaktualizować kursów wymiany. Sprawdź swoje połączenie.';

  @override
  String get settingsClearData => 'Wyczyść dane';

  @override
  String get settingsClearDataSubtitle => 'Trwale usuń wybrane dane';

  @override
  String get clearDataTitle => 'Wyczyść dane';

  @override
  String get clearDataTransactions => 'Historia transakcji';

  @override
  String clearDataTransactionsSubtitle(int count) {
    return '$count transakcje · salda kont resetowane do zera';
  }

  @override
  String get clearDataPlanned => 'Planowane transakcje';

  @override
  String clearDataPlannedSubtitle(int count) {
    return '$count zaplanowane elementy';
  }

  @override
  String get clearDataAccounts => 'Konta';

  @override
  String clearDataAccountsSubtitle(int count) {
    return 'Konta $count · czyści także historię i plan';
  }

  @override
  String get clearDataCategories => 'Kategorie';

  @override
  String clearDataCategoriesSubtitle(int count) {
    return 'Kategorie $count · zastąpione wartościami domyślnymi';
  }

  @override
  String get clearDataPreferences => 'Preferencje';

  @override
  String get clearDataPreferencesSubtitle =>
      'Zresetuj walutę, motyw i język do ustawień domyślnych';

  @override
  String get clearDataSecurity => 'Blokada aplikacji i PIN';

  @override
  String get clearDataSecuritySubtitle => 'Wyłącz blokadę aplikacji i usuń PIN';

  @override
  String get clearDataConfirmButton => 'Wyczyść wybrane';

  @override
  String get clearDataConfirmTitle => 'Tego nie można cofnąć';

  @override
  String get clearDataConfirmBody =>
      'Wybrane dane zostaną trwale usunięte. Najpierw wyeksportuj kopię zapasową, jeśli może być potrzebna później.';

  @override
  String get clearDataTypeConfirm => 'Wpisz DELETE, aby potwierdzić';

  @override
  String get clearDataTypeConfirmError =>
      'Wpisz dokładnie DELETE, aby kontynuować';

  @override
  String get clearDataPinTitle => 'Potwierdź PINem';

  @override
  String get clearDataPinBody =>
      'Wprowadź kod PIN aplikacji, aby autoryzować tę akcję.';

  @override
  String get clearDataPinIncorrect => 'Nieprawidłowy PIN';

  @override
  String get clearDataDone => 'Wybrane dane zostały usunięte';

  @override
  String get autoBackupTitle => 'Automatyczna codzienna kopia zapasowa';

  @override
  String autoBackupLastAt(String date) {
    return 'Ostatnia kopia zapasowa $date';
  }

  @override
  String get autoBackupNeverRun => 'Nie ma jeszcze kopii zapasowej';

  @override
  String get autoBackupShareTitle => 'Zapisz w chmurze';

  @override
  String get autoBackupShareSubtitle =>
      'Prześlij najnowszą kopię zapasową na iCloud Drive, Google Drive lub dowolną aplikację';

  @override
  String get autoBackupCloudReminder =>
      'Gotowa do automatycznego tworzenia kopii zapasowych — zapisz ją w chmurze, aby chronić dane poza urządzeniem';

  @override
  String get autoBackupCloudReminderAction => 'Udostępnij';

  @override
  String get settingsBackupReminderTitle => 'Przypomnienie o kopii zapasowej';

  @override
  String get settingsBackupReminderSubtitle =>
      'Baner w aplikacji, jeśli dodasz wiele transakcji bez eksportu ręcznej kopii zapasowej.';

  @override
  String get settingsBackupReminderThresholdTitle => 'Próg transakcji';

  @override
  String settingsBackupReminderThresholdSubtitle(int count) {
    return 'Przypomnij po $count nowych transakcjach od ostatniego ręcznego eksportu.';
  }

  @override
  String get settingsBackupReminderThresholdInvalid =>
      'Wprowadź liczbę całkowitą od 1 do 500.';

  @override
  String settingsBackupReminderSnoozeHint(int n) {
    return '\"Przypomnij później\" ukrywa baner, dopóki nie dodasz kolejnych $n transakcji.';
  }

  @override
  String get backupReminderBannerTitle => 'Eksportować kopię zapasową?';

  @override
  String backupReminderBannerBody(int count) {
    return 'Dodałeś(-aś) $count transakcji od ostatniego ręcznego eksportu.';
  }

  @override
  String get backupReminderRemindLater => 'Przypomnij później';

  @override
  String get backupExportLedgerVerifyTitle =>
      'Weryfikacja księgi przed kopią zapasową';

  @override
  String get backupExportLedgerVerifyInfo =>
      'Porównuje zapisane saldo każdego konta z pełnym odtworzeniem historii. Możesz wyeksportować kopię zapasową w obu przypadkach; rozbieżności mają charakter informacyjny.';

  @override
  String get backupExportLedgerVerifyContinue => 'Kontynuuj do kopii zapasowej';

  @override
  String get persistenceErrorReloaded =>
      'Nie udało się zapisać zmian. Dane zostały ponownie załadowane z magazynu.';
}
