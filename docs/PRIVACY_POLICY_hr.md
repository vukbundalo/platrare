# Pravila privatnosti — Platrare

**Datum stupanja na snagu:** 12. travnja 2026.

Platrare je aplikacija za osobne financije s lokalnim pohranjivanjem podataka. Ovim pravilima opisujemo kojim podacima aplikacija pristupa, kako se koriste te koja su vaša prava.

---

## 1. Tko smo

Platrare objavljuje individualni razvojni programer. Kontaktni podaci dostupni su na stranici App Store ili Google Play te putem opcije **Postavke → O aplikaciji → Kopiraj detalje podrške** unutar aplikacije.

---

## 2. Podaci pohranjeni na vašem uređaju

Svi podaci koje kreirate u Platrare ostaju **isključivo na vašem uređaju**. Ne upravljamo serverom koji prima ili pohranjuje vaše financijske podatke.

**Što se pohranjuje lokalno:**

| Kategorija | Detalji |
|---|---|
| Financijska knjiga | Računi, stvarni salda, limiti prekoračenja, povijest transakcija, planirane transakcije i kategorije |
| Privici | Fotografije računa i dokumenata koje odlučite dodati transakcijama |
| Postavke | Osnovna valuta, sekundarna valuta, tema, jezik, postavka vidljivosti stanja |
| Sigurnost | Status zaključavanja aplikacije; jednosmjerni kriptografski hash PIN-a (neobrađeni PIN nikada se ne pohranjuje) |
| Predmemorija tečajeva | Javno dostupni podaci o tečajevima valuta preuzeti s API-ja treće strane i lokalno predmemorirani |

---

## 3. Podaci koji se šalju putem interneta

### 3.1 Tečajevi valuta

Za prikazivanje iznosa u više valuta, aplikacija povremeno dohvaća javno dostupne podatke o tečajevima od **Frankfurter API-ja** (api.frankfurter.dev / api.frankfurter.app), koji objavljuje podatke **Europske središnje banke (ESB)**. Ti zahtjevi:

- **Ne sadrže osobne podatke** — samo standardni anonimni HTTP poziv.
- **Ne uključuju** nazive vaših računa, stanja, transakcije ni bilo koji drugi sadržaj knjige.
- Predmemorirani su na uređaju do **6 sati** kako bi se smanjila mrežna aktivnost.

Frankfurterova vlastita pravila privatnosti uređuju sve podatke koje njihovi poslužitelji mogu evidentirati (npr. IP adrese u standardnim HTTP zapisnicima pristupa).

### 3.2 Bez analitike i oglašavanja

Platrare **ne sadrži analitički SDK, uslugu izvješćivanja o rušenjima ni oglasnu mrežu**. Nikakvi podaci o korištenju, identifikatori uređaja ni bihevioralna telemetrija ne prikupljaju se niti prenose.

---

## 4. Dozvole uređaja

| Dozvola | Svrha | Kada se traži |
|---|---|---|
| Kamera | Snimanje fotografija računa | Samo kada dodirnete "Snimi fotografiju" u listu privitaka |
| Foto knjižnica | Odabir slika ili datoteka za prilaganje | Samo kada dodirnete "Odaberi iz galerije" |
| Datoteke | Prilaganje PDF-ova i drugih dokumenata | Samo kada dodirnete "Pregledaj datoteke" |
| Biometrija / Face ID | Otključavanje aplikacije kada je zaključavanje uključeno | Samo kada se prikazuje zaslon zaključavanja |
| Mreža | Dohvaćanje tečajeva valuta | Automatski u pozadini; ne šalju se osobni podaci |

Aplikacija **ne traži** pristup vašoj lokaciji, kontaktima, mikrofonu, kalendaru ni bilo kojoj dozvoli koja nije navedena gore.

---

## 5. Zaključavanje aplikacije i biometrijska provjera autentičnosti

Kada u Postavkama omogućite **Zaključaj aplikaciju pri otvaranju**:

- Aplikacija koristi sigurni biometrijski okvir operativnog sustava (iOS LocalAuthentication / Android BiometricPrompt). Vaš otisak prsta ili podaci lica obrađuju se u potpunosti unutar **sigurne enklave OS-a** — aplikacija nikada ne vidi, pohranjuje ni prenosi biometrijske podatke.
- Ako postavite PIN, samo se **jednosmjerni kriptografski hash** tog PIN-a pohranjuje u privatnoj pohrani uređaja aplikacije. Neobrađeni PIN nikada se ne zapisuje na disk.

---

## 6. Sigurnosne kopije

**Izvoz** stvara `.zip` (nekriptiranu) ili `.platrare` (AES-256 lozinkom kriptiranu) datoteku. Vi birate gdje je pohraniti — aplikacija Datoteke, iCloud Drive, Google Drive, AirDrop, lokalna pohrana itd. **Nikada ne primamo vašu sigurnosnu kopiju.**

**Automatska dnevna sigurnosna kopija** sprema datoteku samo u privatnu pohranu uređaja aplikacije. **Ne** prenosi se automatski ni u jednu uslugu u oblaku. Najnoviju sigurnosnu kopiju možete ručno dijeliti na lokaciju u oblaku putem **Postavke → Automatska dnevna sigurnosna kopija → Spremi u oblak**.

**Uvoz** zamjenjuje sve podatke na uređaju sadržajem odabrane sigurnosne kopije. Uvozite samo iz sigurnosnih kopija kojima vjerujete i koje ste provjerili.

---

## 7. Djeca

Platrare nije namijenjen djeci mlađoj od 13 godina (ili primjenjive minimalne dobi u vašoj nadležnosti). Ne prikupljamo namjerno podatke od djece. Ako smatrate da je dijete neprikladno koristilo aplikaciju, obratite nam se putem podataka za podršku dostupnih u aplikaciji.

---

## 8. Čuvanje i brisanje podataka

- Podaci na uređaju ostaju sve dok ih ne izbrišete unutar aplikacije, koristite **Postavke → Obriši podatke**, uvezete zamjensku sigurnosnu kopiju ili deinstalirate aplikaciju.
- Deinstalacijom aplikacije uklanja se lokalna pohrana aplikacije, ovisno o ponašanju OS-a (npr. iCloud sigurnosne kopije uređaja mogu zadržati snimku dok je OS ne prepiše).
- Budući da **ne čuvamo kopiju vaših podataka na našim serverima**, s naše strane nema ničega za brisanje.

---

## 9. Vaša prava

Budući da svi podaci leže na vašem uređaju, svoja prava ostvarujete izravno putem aplikacije:

- **Pristup i prenosivost** — Svi vaši podaci vidljivi su unutar aplikacije. Koristite **Izvezi sigurnosnu kopiju** za prenosivi, strojno čitljiv primjerak.
- **Ispravak** — Uredite bilo koji račun, transakciju ili kategoriju u bilo koje vrijeme.
- **Brisanje** — Koristite funkcije brisanja unutar aplikacije, **Postavke → Obriši podatke** ili deinstalirajte aplikaciju.

**Korisnici iz EEA i Ujedinjenog Kraljevstva:** Opća uredba o zaštiti podataka (GDPR) i UK GDPR mogu vam dodijeliti dodatna prava, uključujući pravo na podnošenje pritužbe lokalnom nadzornom tijelu za zaštitu podataka.

**Stanovnici Kalifornije:** Može se primjenjivati Kalifornijski zakon o zaštiti privatnosti potrošača (CCPA / CPRA). Budući da ne prodajemo ni ne dijelimo osobne podatke prema definiciji CCPA-e, pravo na odjavu u većini slučajeva ne primjenjuje se. Možete nas kontaktirati za potvrdu.

---

## 10. Sigurnost

- Svi financijski podaci pohranjeni su u **SQLite bazi podataka zaštićenoj u sandboxu aplikacije** kojoj druge aplikacije na uređaju ne mogu pristupiti.
- Datoteke sigurnosnih kopija mogu biti zaštićene **AES-256 enkripcijom** i lozinkom po vašem izboru.
- PIN-ovi se pohranjuju samo kao **jednosmjerni kriptografski hash** — ne mogu se oporaviti ni obrnuti.
- Sav mrežni promet koristi **isključivo HTTPS**.

---

## 11. Promjene ove politike

Možemo ažurirati ova pravila kako se značajke razvijaju. **Datum stupanja na snagu** na vrhu odražavat će najnoviju reviziju. Nastavak korištenja aplikacije nakon ažuriranja smatra se prihvaćanjem izmijenjenih pravila. Značajne promjene bit će navedene u bilješkama o izdanju App Store i Google Play.

---

## 12. Kontakt

Za pitanja ili zahtjeve vezane uz privatnost koristite kontaktni način na App Store ili Google Play stranici ili dodirnite **Postavke → O aplikaciji → Kopiraj detalje podrške** unutar aplikacije za dobivanje kontaktnih podataka.
