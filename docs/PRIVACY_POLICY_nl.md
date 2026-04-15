# Privacybeleid — Platrare

**Ingangsdatum:** 12 april 2026

Platrare is een persoonlijke financiën-app met een local-first architectuur. Dit beleid beschrijft welke gegevens de app gebruikt, hoe ze worden gebruikt en uw rechten.

---

## 1. Wie wij zijn

Platrare wordt gepubliceerd door een individuele ontwikkelaar. Contactgegevens zijn beschikbaar in de App Store of Google Play en via **Instellingen → Over → Ondersteuningsgegevens kopiëren** in de app.

---

## 2. Gegevens opgeslagen op uw apparaat

Alle gegevens die u in Platrare aanmaakt, blijven **uitsluitend op uw apparaat**. Wij beheren geen server die uw financiële informatie ontvangt of opslaat.

**Wat lokaal wordt opgeslagen:**

| Categorie | Details |
|---|---|
| Financieel grootboek | Rekeningen, saldi, roodstandlimieten, transactiegeschiedenis, geplande transacties en categorieën |
| Bijlagen | Foto's van bonnen en documenten die u aan transacties toevoegt |
| Voorkeuren | Basisvaluta, secundaire valuta, thema, taal, saldozichtbaarheid |
| Beveiliging | App-vergrendelingsstatus; eenrichtings cryptografische hash van uw pincode (de pincode zelf wordt nooit opgeslagen) |
| Wisselkoerscache | Openbare wisselkoersgegevens gedownload van een externe API en lokaal gecached |

---

## 3. Gegevens verzonden via internet

### 3.1 Wisselkoersen

De app haalt periodiek openbaar beschikbare wisselkoersgegevens op van de **Frankfurter API** (api.frankfurter.dev / api.frankfurter.app), die gegevens van de **Europese Centrale Bank (ECB)** publiceert. Deze verzoeken bevatten **geen persoonsgegevens** — alleen een standaard anoniem HTTP-verzoek. Uw rekeningen, saldi en transacties worden nooit verzonden. Gegevens worden maximaal **6 uur** gecached.

### 3.2 Geen analyses of reclame

Platrare bevat **geen analytics-SDK, crashrapportageservice of advertentienetwerk**. Er worden geen gebruiksgegevens, apparaat-ID's of gedragstelemetrie verzameld.

---

## 4. Apparaatmachtigingen

| Machtiging | Doel | Wanneer gevraagd |
|---|---|---|
| Camera | Foto's van bonnen maken | Alleen bij tikken op "Foto maken" |
| Fotobibliotheek | Afbeeldingen selecteren voor bijlagen | Alleen bij tikken op "Kiezen uit galerij" |
| Bestanden | PDF's en documenten bijvoegen | Alleen bij tikken op "Bestanden bladeren" |
| Biometrie / Face ID | App ontgrendelen | Alleen wanneer het vergrendelingsscherm wordt weergegeven |
| Netwerk | Wisselkoersen ophalen | Automatisch; er worden geen persoonsgegevens verzonden |

De app vraagt geen toegang tot locatie, contacten, microfoon, agenda of andere machtigingen die niet hierboven worden vermeld.

---

## 5. App-vergrendeling en biometrie

Bij het inschakelen van **App vergrendelen bij openen**:

- De app gebruikt het beveiligde biometrische framework van het besturingssysteem (iOS LocalAuthentication / Android BiometricPrompt). Uw biometrische gegevens worden volledig verwerkt in de beveiligde enclave van het OS — de app heeft er nooit toegang toe, slaat ze niet op en verzendt ze niet.
- Als u een pincode instelt, wordt alleen een **eenrichtings cryptografische hash** van die pincode opgeslagen. De pincode zelf wordt nooit op schijf geschreven.

---

## 6. Back-ups

**Exporteren** maakt een `.zip`-bestand (niet versleuteld) of `.platrare`-bestand (AES-256 wachtwoordversleuteld). U kiest zelf waar u het opslaat. **Wij ontvangen uw back-up nooit.**

**De automatische dagelijkse back-up** slaat een bestand op in de privéopslag van het apparaat. Er wordt niets automatisch geüpload naar een cloudservice. U kunt de laatste back-up handmatig delen via **Instellingen → Automatische back-up → Opslaan in cloud**.

**Importeren** vervangt alle apparaatgegevens door de inhoud van de back-up. Importeer alleen van vertrouwde bronnen.

---

## 7. Kinderen

Platrare is niet bedoeld voor kinderen onder de 13 jaar. Wij verzamelen niet bewust informatie van kinderen.

---

## 8. Gegevensbewaring en -verwijdering

Gegevens blijven op uw apparaat totdat u ze verwijdert in de app, **Instellingen → Gegevens wissen** gebruikt, een vervangende back-up importeert of de app verwijdert. Omdat wij geen kopie van uw gegevens op onze servers bewaren, is er aan onze kant niets te verwijderen.

---

## 9. Uw rechten

- **Toegang en overdraagbaarheid** — Alle gegevens zijn zichtbaar in de app. Gebruik **Back-up exporteren** voor een draagbare kopie.
- **Rectificatie** — Bewerk elk record op elk moment.
- **Verwijdering** — Gebruik de verwijderfuncties in de app, **Gegevens wissen** of verwijder de app.

**EER/VK-gebruikers:** De AVG en UK GDPR kunnen u aanvullende rechten verlenen, waaronder het recht om een klacht in te dienen bij uw lokale toezichthoudende autoriteit.

**Californische inwoners:** De CCPA/CPRA kan van toepassing zijn. Omdat wij geen persoonsgegevens verkopen of delen, zijn opt-outrechten in de meeste gevallen niet van toepassing.

---

## 10. Beveiliging

- Gegevens in een **app-gesandboxte** database, niet toegankelijk voor andere apps.
- Back-ups optioneel beveiligd met **AES-256-versleuteling**.
- Pincodes opgeslagen als **eenrichtings cryptografische hash**.
- Netwerkverkeer uitsluitend via **HTTPS**.

---

## 11. Wijzigingen

Wij kunnen dit beleid bijwerken als functies evolueren. De **ingangsdatum** geeft de laatste revisie weer. Voortgezet gebruik geldt als aanvaarding van wijzigingen.

---

## 12. Contact

Gebruik de contactmethode in de App Store of Google Play, of **Instellingen → Over → Ondersteuningsgegevens kopiëren** in de app.
