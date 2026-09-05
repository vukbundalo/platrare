# Polityka prywatności — Platrare

**Data wejścia w życie:** 4 września 2026 r.

Platrare to aplikacja do zarządzania finansami osobistymi z architekturą local-first. Niniejsza polityka opisuje dane, do których dostęp ma aplikacja, sposób ich wykorzystania oraz przysługujące Ci prawa.

---

## 1. Kim jesteśmy

Platrare jest wydawana przez indywidualnego dewelopera, który jest administratorem danych w rozumieniu RODO. Z deweloperem możesz skontaktować się pod adresem **[support email]**, poprzez stronę aplikacji w App Store lub Google Play albo przez **Ustawienia → O aplikacji → Skontaktuj się z pomocą** w aplikacji.

---

## 2. Dane przechowywane na Twoim urządzeniu

Wszystkie dane tworzone w Platrare pozostają **wyłącznie na Twoim urządzeniu**. Nie obsługujemy żadnego serwera, który odbierałby lub przechowywał Twoje informacje finansowe.

**Co jest przechowywane lokalnie:**

| Kategoria | Szczegóły |
|---|---|
| Księga finansowa | Konta, salda, limity debetowe, historia transakcji, zaplanowane transakcje i kategorie |
| Załączniki | Zdjęcia paragonów i dokumentów dodanych do transakcji |
| Preferencje | Waluta bazowa, waluta pomocnicza, motyw, język, widoczność salda |
| Bezpieczeństwo | Status blokady aplikacji; jednokierunkowy skrót kryptograficzny PIN (sam PIN nigdy nie jest przechowywany) |
| Pamięć podręczna kursów | Publiczne dane o kursach walut pobrane z zewnętrznego API i zapisane lokalnie |
| Przypomnienia | Jeśli włączysz przypomnienia o zaplanowanych transakcjach, termin, opis i kwota każdej nadchodzącej zaplanowanej transakcji są przekazywane do lokalnego harmonogramu powiadomień systemu operacyjnego, aby mógł on wyświetlić przypomnienie nawet wtedy, gdy aplikacja jest zamknięta. Nigdy nie opuszczają one urządzenia. |
| Migawka widżetu na ekranie głównym (iOS) | Małe, wstępnie obliczone podsumowanie (prognozowane salda na nadchodzące dni oraz etykiety wyświetlane przez widżet), przechowywane w prywatnym współdzielonym kontenerze aplikacji, aby widżet mógł się wyświetlać bez otwierania aplikacji. Gdy blokada aplikacji jest włączona, kwoty w tej migawce są maskowane, chyba że w Ustawieniach zdecydujesz inaczej. |

---

## 3. Dane wysyłane przez Internet

### 3.1 Kursy walut

Aplikacja okresowo pobiera publiczne dane o kursach walut z **API Frankfurter** (api.frankfurter.dev / api.frankfurter.app), które publikuje dane **Europejskiego Banku Centralnego (EBC)**. Żądania te nie zawierają **żadnych danych osobowych** — to tylko standardowe, anonimowe wywołanie HTTP. Twoje konta, salda i transakcje nigdy nie są przesyłane. Dane są buforowane przez maksymalnie **6 godzin**.

### 3.2 Brak analityki i reklam

Platrare **nie zawiera żadnego SDK analitycznego, usługi raportowania awarii ani sieci reklamowej**. Dane użytkowania, identyfikatory urządzeń ani telemetria behawioralna nie są gromadzone. Przypomnienia, widżety na ekranie głównym i skróty działają całkowicie offline.

---

## 4. Uprawnienia urządzenia

| Uprawnienie | Cel | Kiedy jest wymagane |
|---|---|---|
| Aparat | Robienie zdjęć paragonów | Tylko po naciśnięciu „Zrób zdjęcie" |
| Biblioteka zdjęć | Wybieranie zdjęć do załączenia | Tylko po naciśnięciu „Wybierz z galerii" |
| Pliki | Załączanie plików PDF i dokumentów | Tylko po naciśnięciu „Przeglądaj pliki" |
| Biometria / Face ID | Odblokowywanie aplikacji | Tylko gdy wyświetlany jest ekran blokady |
| Powiadomienia | Przypominanie na krótko przed terminem zaplanowanej transakcji | Tylko gdy włączysz przypomnienia w Ustawieniach |
| Uruchamianie przy starcie (Android) | Ponowne zaplanowanie przypomnień po ponownym uruchomieniu urządzenia | Automatycznie, tylko jeśli przypomnienia są włączone |
| Sieć | Pobieranie kursów walut | Automatycznie; żadne dane osobowe nie są wysyłane |

Aplikacja nie żąda dostępu do lokalizacji, kontaktów, mikrofonu, kalendarza ani żadnych innych uprawnień niewymienionych powyżej.

---

## 5. Blokada aplikacji i biometria

Po włączeniu **Blokuj aplikację przy otwieraniu**:

- Aplikacja korzysta z bezpiecznego frameworka biometrycznego systemu operacyjnego (iOS LocalAuthentication / Android BiometricPrompt). Twoje dane biometryczne są przetwarzane wyłącznie w bezpiecznym enklawu systemu — aplikacja nigdy do nich nie sięga, nie przechowuje ich ani nie przesyła.
- Jeśli ustawisz PIN, na urządzeniu przechowywany jest wyłącznie **jednokierunkowy skrót kryptograficzny** tego kodu. Sam PIN nigdy nie jest zapisywany na dysku.

---

## 6. Kopie zapasowe

**Eksport** tworzy plik `.zip` (bez szyfrowania) lub `.platrare` (szyfrowany AES-256 hasłem). Ty decydujesz, gdzie go zapisać. **Nigdy nie otrzymujemy Twojej kopii zapasowej.**

**Automatyczna codzienna kopia zapasowa** zapisuje plik wyłącznie w prywatnym miejscu na urządzeniu. Nie przesyła niczego automatycznie do chmury. Możesz ją udostępnić ręcznie przez **Ustawienia → Automatyczna kopia zapasowa → Zapisz w chmurze**.

**Import** zastępuje wszystkie dane na urządzeniu zawartością kopii zapasowej. Importuj tylko z zaufanych źródeł.

Tylko eksporty `.platrare` zaszyfrowane hasłem zawierają skrót PIN-u blokady aplikacji; eksporty niezaszyfrowane i automatyczne codzienne kopie zapasowe nigdy go nie zawierają. Podczas przywracania kopii zapasowej bez PIN-u PIN ustawiony już na urządzeniu zostaje zachowany.

**Kopie zapasowe urządzenia tworzone przez system operacyjny.** Wbudowana funkcja kopii zapasowej Twojego telefonu (iCloud Backup w iOS, Google Auto Backup w Androidzie) może skopiować księgę aplikacji, automatyczne codzienne kopie zapasowe i preferencje na Twoje konto Apple lub Google w ramach kopii zapasowej urządzenia, na warunkach Apple lub Google. W Androidzie załączniki z paragonami są z tego wyłączone, aby zmieścić się w limicie systemowej kopii zapasowej. Kopiami zapasowymi urządzenia zarządzasz w ustawieniach systemu operacyjnego; deweloper nigdy ich nie otrzymuje.

---

## 7. Widżety, skróty i Siri (iOS)

- **Widżety na ekranie głównym** wyświetlają prognozowane salda z migawki opisanej w sekcji 2. Migawka znajduje się w prywatnym współdzielonym kontenerze aplikacji na Twoim urządzeniu i nigdy nie jest przesyłana. Gdy blokada aplikacji jest włączona, kwoty są domyślnie maskowane.
- **Szybkie akcje i App Shortcuts** (długie naciśnięcie ikony aplikacji, aplikacja Skróty lub Siri) jedynie otwierają aplikację na wybranym ekranie, np. „Dodaj transakcję". Rozpoznawanie mowy dla Siri wykonuje iOS na warunkach prywatności Apple; aplikacja otrzymuje wyłącznie rozpoznane polecenie i nigdy nie wysyła Twojej księgi do Apple.

---

## 8. Dzieci

Platrare nie jest przeznaczona dla dzieci poniżej 13 roku życia. Nie zbieramy świadomie informacji od dzieci.

---

## 9. Przechowywanie i usuwanie danych

Dane pozostają na urządzeniu, dopóki ich nie usuniesz w aplikacji, nie skorzystasz z **Ustawienia → Wyczyść dane**, nie zaimportujesz zastępczej kopii zapasowej lub nie odinstalowujesz aplikacji. Ponieważ nie przechowujemy żadnej kopii Twoich danych na naszych serwerach, nie mamy nic do usunięcia po naszej stronie.

---

## 10. Twoje prawa

- **Dostęp i przenoszalność** — Wszystkie dane są widoczne w aplikacji. Skorzystaj z **Eksportuj kopię zapasową**, aby uzyskać przenośną kopię.
- **Sprostowanie** — Edytuj dowolny rekord w dowolnym momencie.
- **Usunięcie** — Skorzystaj z funkcji usuwania w aplikacji, **Wyczyść dane** lub odinstaluj aplikację.

**Użytkownicy z EOG/Wielkiej Brytanii:** RODO i UK GDPR mogą przyznawać dodatkowe prawa, w tym prawo do wniesienia skargi do lokalnego organu nadzorczego.

**Mieszkańcy Kalifornii:** Może mieć zastosowanie CCPA/CPRA. Ponieważ nie sprzedajemy ani nie udostępniamy danych osobowych, prawa do rezygnacji zazwyczaj nie mają zastosowania.

---

## 11. Bezpieczeństwo

- Dane w **izolowanej** bazie danych aplikacji, niedostępnej dla innych aplikacji.
- Kopie zapasowe opcjonalnie chronione **szyfrowaniem AES-256**.
- Kody PIN przechowywane wyłącznie jako **jednokierunkowy skrót kryptograficzny**.
- Ruch sieciowy wyłącznie przez **HTTPS**.

---

## 12. Zmiany

Możemy aktualizować niniejszą politykę w miarę rozwoju funkcji. **Data wejścia w życie** będzie odzwierciedlać ostatnią wersję. Dalsze korzystanie oznacza akceptację zmian.

---

## 13. Kontakt

W sprawach dotyczących prywatności napisz na adres **[support email]**, skorzystaj z danych kontaktowych w App Store lub Google Play albo z **Ustawienia → O aplikacji → Skontaktuj się z pomocą** w aplikacji.
