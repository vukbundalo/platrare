# Politika privatnosti — Platrare

**Datum stupanja na snagu:** 12. april 2026.

Platrare je aplikacija za lične finansije s lokalnim čuvanjem podataka. Ovom politikom opisujemo kojim podacima aplikacija pristupa, kako se koriste i koja su vaša prava.

---

## 1. Ko smo

Platrare objavljuje individualni programer. Podaci za kontakt dostupni su na App Store ili Google Play stranici i putem opcije **Podešavanja → O aplikaciji → Kopiraj detalje podrške** unutar aplikacije.

---

## 2. Podaci sačuvani na vašem uređaju

Svi podaci koje kreirate u Platrare ostaju **isključivo na vašem uređaju**. Ne upravljamo serverom koji prima ili čuva vaše finansijske podatke.

**Šta se čuva lokalno:**

| Kategorija | Detalji |
|---|---|
| Finansijska knjiga | Računi, stvarna stanja, limiti prekoračenja, istorija transakcija, planirane transakcije i kategorije |
| Prilozi | Fotografije računa i dokumenata koje odlučite da dodate transakcijama |
| Podešavanja | Osnovna valuta, sekundarna valuta, tema, jezik, podešavanje vidljivosti stanja |
| Bezbednost | Status zaključavanja aplikacije; jednosmerni kriptografski heš PIN-a (neobrađeni PIN se nikada ne čuva) |
| Keš kursnih lista | Javno dostupni podaci o kursevima valuta preuzeti sa API-ja treće strane i lokalno keširani |

---

## 3. Podaci koji se šalju putem interneta

### 3.1 Kursevi valuta

Za prikazivanje iznosa u više valuta, aplikacija povremeno preuzima javno dostupne podatke o kursevima od **Frankfurter API-ja** (api.frankfurter.dev / api.frankfurter.app), koji objavljuje podatke **Evropske centralne banke (ECB)**. Ti zahtevi:

- **Ne sadrže lične podatke** — samo standardni anonimni HTTP poziv.
- **Ne uključuju** nazive vaših računa, stanja, transakcije ni bilo koji drugi sadržaj knjige.
- Keširani su na uređaju do **6 sati** radi smanjenja mrežne aktivnosti.

Frankfurterova sopstvena pravila privatnosti uređuju sve podatke koje njihovi serveri mogu da evidentiraju (npr. IP adrese u standardnim HTTP zapisnicima pristupa).

### 3.2 Bez analitike i oglašavanja

Platrare **ne sadrži analitički SDK, uslugu izveštavanja o greškama ni oglasnu mrežu**. Nikakvi podaci o korišćenju, identifikatori uređaja ni bihejvioralna telemetrija se ne prikupljaju niti prenose.

---

## 4. Dozvole uređaja

| Dozvola | Svrha | Kada se traži |
|---|---|---|
| Kamera | Snimanje fotografija računa | Samo kada dodirnete "Snimi fotografiju" u listu priloga |
| Foto biblioteka | Izbor slika ili fajlova za prilaganje | Samo kada dodirnete "Izaberi iz galerije" |
| Fajlovi | Prilaganje PDF-ova i drugih dokumenata | Samo kada dodirnete "Pretraži fajlove" |
| Biometrija / Face ID | Otključavanje aplikacije kada je zaključavanje uključeno | Samo kada se prikazuje ekran zaključavanja |
| Mreža | Preuzimanje kurseva valuta | Automatski u pozadini; ne šalju se lični podaci |

Aplikacija **ne traži** pristup vašoj lokaciji, kontaktima, mikrofonu, kalendaru ni bilo kojoj dozvoli koja nije navedena gore.

---

## 5. Zaključavanje aplikacije i biometrijska autentifikacija

Kada u Podešavanjima omogućite **Zaključaj aplikaciju pri otvaranju**:

- Aplikacija koristi bezbedni biometrijski okvir operativnog sistema (iOS LocalAuthentication / Android BiometricPrompt). Vaš otisak prsta ili podaci lica obrađuju se u potpunosti unutar **bezbedne enklave OS-a** — aplikacija nikada ne vidi, ne čuva ni ne prenosi biometrijske podatke.
- Ako postavite PIN, samo se **jednosmerni kriptografski heš** tog PIN-a čuva u privatnoj pohrani uređaja aplikacije. Neobrađeni PIN se nikada ne zapisuje na disk.

---

## 6. Rezervne kopije

**Izvoz** kreira `.zip` (nekriptovanu) ili `.platrare` (AES-256 lozinkom kriptovanu) datoteku. Vi birate gde je sačuvati — aplikacija Files, iCloud Drive, Google Drive, AirDrop, lokalno skladište itd. **Nikada ne primamo vašu rezervnu kopiju.**

**Automatska dnevna rezervna kopija** čuva datoteku samo u privatnoj pohrani uređaja aplikacije. **Ne** prenosi se automatski ni u jednu uslugu u oblaku. Najnoviju rezervnu kopiju možete ručno podeliti na lokaciju u oblaku putem **Podešavanja → Automatska dnevna rezervna kopija → Sačuvaj u oblak**.

**Uvoz** zamenjuje sve podatke na uređaju sadržajem izabrane rezervne kopije. Uvozite samo iz rezervnih kopija kojima verujete i koje ste proverili.

---

## 7. Deca

Platrare nije namenjen deci mlađoj od 13 godina (ili primenjive minimalne starosti u vašoj nadležnosti). Ne prikupljamo namerno podatke od dece. Ako smatrate da je dete neprikladno koristilo aplikaciju, obratite nam se putem podataka za podršku dostupnih u aplikaciji.

---

## 8. Čuvanje i brisanje podataka

- Podaci na uređaju ostaju sve dok ih ne izbrišete unutar aplikacije, koristite **Podešavanja → Obriši podatke**, uvezete zamjensku rezervnu kopiju ili deinstalirate aplikaciju.
- Deinstalacijom aplikacije uklanja se lokalno skladište aplikacije, u zavisnosti od ponašanja OS-a (npr. iCloud rezervne kopije uređaja mogu zadržati snimak dok ih OS ne prepiše).
- Budući da **ne čuvamo kopiju vaših podataka na našim serverima**, s naše strane nema ničega za brisanje.

---

## 9. Vaša prava

Budući da svi podaci leže na vašem uređaju, svoja prava ostvarujete direktno putem aplikacije:

- **Pristup i prenosivost** — Svi vaši podaci vidljivi su unutar aplikacije. Koristite **Izvezi rezervnu kopiju** za prenosivi, mašinski čitljiv primerak.
- **Ispravka** — Uredite bilo koji račun, transakciju ili kategoriju u bilo koje vreme.
- **Brisanje** — Koristite funkcije brisanja unutar aplikacije, **Podešavanja → Obriši podatke** ili deinstalirajte aplikaciju.

**Korisnici iz EEA i Ujedinjenog Kraljevstva:** Opšta uredba o zaštiti podataka (GDPR) i UK GDPR mogu vam dodeliti dodatna prava, uključujući pravo na podnošenje pritužbe lokalnom nadzornom telu za zaštitu podataka.

**Stanovnici Kalifornije:** Može se primenjivati Kalifornijski zakon o zaštiti privatnosti potrošača (CCPA / CPRA). Budući da ne prodajemo ni ne delimo lične podatke prema definiciji CCPA-e, pravo na odjavu se u većini slučajeva ne primenjuje. Možete nas kontaktirati za potvrdu.

---

## 10. Bezbednost

- Svi finansijski podaci čuvaju se u **SQLite bazi podataka zaštićenoj u sandboxu aplikacije** kojoj druge aplikacije na uređaju ne mogu pristupiti.
- Datoteke rezervnih kopija mogu biti zaštićene **AES-256 enkripcijom** i lozinkom po vašem izboru.
- PIN-ovi se čuvaju samo kao **jednosmerni kriptografski heš** — ne mogu se povratiti ni reversno izračunati.
- Sav mrežni saobraćaj koristi **isključivo HTTPS**.

---

## 11. Izmene ove politike

Možemo ažurirati ovu politiku kako se funkcionalnosti razvijaju. **Datum stupanja na snagu** na vrhu će odražavati najnoviju reviziju. Nastavak korišćenja aplikacije nakon ažuriranja smatra se prihvatanjem izmenjene politike. Značajne izmene biće navedene u beleškama o izdanju App Store i Google Play.

---

## 12. Kontakt

Za pitanja ili zahteve vezane za privatnost koristite kontaktni način na App Store ili Google Play stranici ili dodirnite **Podešavanja → O aplikaciji → Kopiraj detalje podrške** unutar aplikacije za dobijanje kontakt podataka.
