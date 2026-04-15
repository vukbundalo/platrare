# Polityka prywatności — Platrare

**Data wejścia w życie:** 12 kwietnia 2026 r.

Platrare to aplikacja do zarządzania finansami osobistymi z architekturą local-first. Niniejsza polityka opisuje dane, do których dostęp ma aplikacja, sposób ich wykorzystania oraz przysługujące Ci prawa.

---

## 1. Kim jesteśmy

Platrare jest wydawana przez indywidualnego dewelopera. Dane kontaktowe są dostępne w App Store lub Google Play oraz poprzez **Ustawienia → O aplikacji → Kopiuj dane wsparcia** w aplikacji.

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

---

## 3. Dane wysyłane przez Internet

### 3.1 Kursy walut

Aplikacja okresowo pobiera publiczne dane o kursach walut z **API Frankfurter** (api.frankfurter.dev / api.frankfurter.app), które publikuje dane **Europejskiego Banku Centralnego (EBC)**. Żądania te nie zawierają **żadnych danych osobowych** — to tylko standardowe, anonimowe wywołanie HTTP. Twoje konta, salda i transakcje nigdy nie są przesyłane. Dane są buforowane przez maksymalnie **6 godzin**.

### 3.2 Brak analityki i reklam

Platrare **nie zawiera żadnego SDK analitycznego, usługi raportowania awarii ani sieci reklamowej**. Dane użytkowania, identyfikatory urządzeń ani telemetria behawioralna nie są gromadzone.

---

## 4. Uprawnienia urządzenia

| Uprawnienie | Cel | Kiedy jest wymagane |
|---|---|---|
| Aparat | Robienie zdjęć paragonów | Tylko po naciśnięciu „Zrób zdjęcie" |
| Biblioteka zdjęć | Wybieranie zdjęć do załączenia | Tylko po naciśnięciu „Wybierz z galerii" |
| Pliki | Załączanie plików PDF i dokumentów | Tylko po naciśnięciu „Przeglądaj pliki" |
| Biometria / Face ID | Odblokowywanie aplikacji | Tylko gdy wyświetlany jest ekran blokady |
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

---

## 7. Dzieci

Platrare nie jest przeznaczona dla dzieci poniżej 13 roku życia. Nie zbieramy świadomie informacji od dzieci.

---

## 8. Przechowywanie i usuwanie danych

Dane pozostają na urządzeniu, dopóki ich nie usuniesz w aplikacji, nie skorzystasz z **Ustawienia → Wyczyść dane**, nie zaimportujesz zastępczej kopii zapasowej lub nie odinstalowujesz aplikacji. Ponieważ nie przechowujemy żadnej kopii Twoich danych na naszych serwerach, nie mamy nic do usunięcia po naszej stronie.

---

## 9. Twoje prawa

- **Dostęp i przenoszalność** — Wszystkie dane są widoczne w aplikacji. Skorzystaj z **Eksportuj kopię zapasową**, aby uzyskać przenośną kopię.
- **Sprostowanie** — Edytuj dowolny rekord w dowolnym momencie.
- **Usunięcie** — Skorzystaj z funkcji usuwania w aplikacji, **Wyczyść dane** lub odinstaluj aplikację.

**Użytkownicy z EOG/Wielkiej Brytanii:** RODO i UK GDPR mogą przyznawać dodatkowe prawa, w tym prawo do wniesienia skargi do lokalnego organu nadzorczego.

**Mieszkańcy Kalifornii:** Może mieć zastosowanie CCPA/CPRA. Ponieważ nie sprzedajemy ani nie udostępniamy danych osobowych, prawa do rezygnacji zazwyczaj nie mają zastosowania.

---

## 10. Bezpieczeństwo

- Dane w **izolowanej** bazie danych aplikacji, niedostępnej dla innych aplikacji.
- Kopie zapasowe opcjonalnie chronione **szyfrowaniem AES-256**.
- Kody PIN przechowywane wyłącznie jako **jednokierunkowy skrót kryptograficzny**.
- Ruch sieciowy wyłącznie przez **HTTPS**.

---

## 11. Zmiany

Możemy aktualizować niniejszą politykę w miarę rozwoju funkcji. **Data wejścia w życie** będzie odzwierciedlać ostatnią wersję. Dalsze korzystanie oznacza akceptację zmian.

---

## 12. Kontakt

Skorzystaj z danych kontaktowych w App Store lub Google Play albo z **Ustawienia → O aplikacji → Kopiuj dane wsparcia** w aplikacji.
