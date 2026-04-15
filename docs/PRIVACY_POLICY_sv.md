# Integritetspolicy — Platrare

**Giltighetsdatum:** 12 april 2026

Platrare är en app för personlig ekonomi med local-first-arkitektur. Denna policy beskriver vilka uppgifter appen använder, hur de används och dina rättigheter.

---

## 1. Vilka vi är

Platrare publiceras av en enskild utvecklare. Kontaktuppgifter finns i App Store eller Google Play och via **Inställningar → Om → Kopiera supportinformation** i appen.

---

## 2. Data som lagras på din enhet

All data du skapar i Platrare förblir **uteslutande på din enhet**. Vi driver ingen server som tar emot eller lagrar din finansiella information.

**Vad som lagras lokalt:**

| Kategori | Detaljer |
|---|---|
| Finansbok | Konton, saldon, övertrasseringsgränser, transaktionshistorik, planerade transaktioner och kategorier |
| Bilagor | Foton på kvitton och dokument du lägger till transaktioner |
| Inställningar | Basvaluta, sekundärvaluta, tema, språk, saldosynlighet |
| Säkerhet | App-låsstatus; envägs kryptografisk hash av din PIN (rå PIN lagras aldrig) |
| Valutakurscache | Offentliga valutakursdata hämtade från ett tredjeparts-API och cachade lokalt |

---

## 3. Data som skickas via internet

### 3.1 Valutakurser

Appen hämtar periodiskt offentliga valutakursdata från **Frankfurter API** (api.frankfurter.dev / api.frankfurter.app), som publicerar data från **Europeiska centralbanken (ECB)**. Dessa förfrågningar innehåller **ingen personlig information** — endast ett standardiserat anonymt HTTP-anrop. Dina konton, saldon och transaktioner överförs aldrig. Data cachas i upp till **6 timmar**.

### 3.2 Ingen analys eller reklam

Platrare innehåller **inget analys-SDK, ingen kraschrapporteringstjänst och inget annonsnätverk**. Ingen användningsdata, enhetsidentifierare eller beteendetelemetri samlas in.

---

## 4. Enhetsbehörigheter

| Behörighet | Syfte | När begärs |
|---|---|---|
| Kamera | Ta foto på kvitton | Bara vid "Ta foto" |
| Fotobibliotek | Välj bilder att bifoga | Bara vid "Välj från galleri" |
| Filer | Bifoga PDF och dokument | Bara vid "Bläddra bland filer" |
| Biometri / Face ID | Lås upp appen | Bara när låsskärmen visas |
| Nätverk | Hämta valutakurser | Automatiskt; ingen personlig data skickas |

Appen begär inte åtkomst till plats, kontakter, mikrofon, kalender eller andra behörigheter som inte anges ovan.

---

## 5. Applås och biometri

När du aktiverar **Lås app vid öppning**:

- Appen använder operativsystemets säkra biometriska ramverk (iOS LocalAuthentication / Android BiometricPrompt). Dina biometriska uppgifter behandlas helt inom OS:ets säkra enklave — appen ser, lagrar eller överför dem aldrig.
- Om du anger en PIN lagras bara en **envägs kryptografisk hash** av den PIN:en på enheten. Rå PIN skrivs aldrig till lagringen.

---

## 6. Säkerhetskopior

**Export** skapar en `.zip`-fil (okrypterad) eller `.platrare`-fil (AES-256 lösenordskrypterad). Du väljer var du sparar den. **Vi tar aldrig emot din säkerhetskopia.**

**Automatisk daglig säkerhetskopiering** sparar en fil bara i appens privata enhetslagring. Den laddar inte upp automatiskt till någon molntjänst. Du kan dela den senaste säkerhetskopian manuellt via **Inställningar → Automatisk säkerhetskopiering → Spara i molnet**.

**Import** ersätter all enhetsdata med säkerhetskopians innehåll. Importera bara från betrodda källor.

---

## 7. Barn

Platrare är inte avsedd för barn under 13 år. Vi samlar inte medvetet in information från barn.

---

## 8. Datalagring och radering

Data finns kvar på din enhet tills du tar bort den i appen, använder **Inställningar → Rensa data**, importerar en ersättningssäkerhetskopia eller avinstallerar appen. Eftersom vi inte har någon kopia av dina data på våra servrar finns det inget att radera från vår sida.

---

## 9. Dina rättigheter

- **Åtkomst och portabilitet** — All data är synlig i appen. Använd **Exportera säkerhetskopia** för en portabel kopia.
- **Rättelse** — Redigera valfri post när som helst.
- **Radering** — Använd borttagningsfunktionerna i appen, **Rensa data** eller avinstallera.

**EES/UK-användare:** GDPR och UK GDPR kan ge dig ytterligare rättigheter, inklusive rätten att lämna in ett klagomål till din lokala tillsynsmyndighet.

**Bosatta i Kalifornien:** CCPA/CPRA kan gälla. Eftersom vi inte säljer eller delar personuppgifter gäller vanligtvis inte opt-out-rättigheter.

---

## 10. Säkerhet

- Data i en **app-sandboxad** databas, otillgänglig för andra appar.
- Säkerhetskopior kan skyddas med valfri **AES-256-kryptering**.
- PIN-koder lagras bara som **envägs kryptografisk hash**.
- Nätverkstrafik uteslutande via **HTTPS**.

---

## 11. Ändringar

Vi kan uppdatera denna policy när funktioner förändras. **Giltighetsdatumet** återspeglar den senaste versionen. Fortsatt användning innebär godkännande av ändringar.

---

## 12. Kontakt

Använd kontaktmetoden i App Store eller Google Play, eller **Inställningar → Om → Kopiera supportinformation** i appen.
