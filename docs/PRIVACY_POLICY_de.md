# Datenschutzrichtlinie — Platrare

**Gültig ab:** 12. April 2026

Platrare ist eine lokal-orientierte App zur persönlichen Finanzverwaltung. Diese Richtlinie beschreibt, auf welche Daten die App zugreift, wie sie verwendet werden und welche Rechte Sie haben.

---

## 1. Wer wir sind

Platrare wird von einem einzelnen Entwickler veröffentlicht. Kontaktdaten finden Sie im App Store oder bei Google Play sowie über **Einstellungen → Über → Support-Details kopieren** in der App.

---

## 2. Auf Ihrem Gerät gespeicherte Daten

Alle Daten, die Sie in Platrare erstellen, verbleiben **ausschließlich auf Ihrem Gerät**. Wir betreiben keinen Server, der Ihre Finanzdaten empfängt oder speichert.

**Was lokal gespeichert wird:**

| Kategorie | Details |
|---|---|
| Finanzbuch | Konten, Guthaben, Überziehungslimits, Transaktionshistorie, geplante Transaktionen und Kategorien |
| Anhänge | Fotos von Belegen und Dokumenten, die Sie Transaktionen hinzufügen |
| Einstellungen | Basiswährung, Sekundärwährung, Design, Sprache, Guthabenanzeige |
| Sicherheit | App-Sperrstatus; kryptografischer Einweg-Hash Ihrer PIN (die rohe PIN wird niemals gespeichert) |
| Wechselkurs-Cache | Öffentliche Wechselkursdaten, die von einer Drittanbieter-API heruntergeladen und lokal zwischengespeichert werden |

---

## 3. Über das Internet übertragene Daten

### 3.1 Wechselkurse

Die App ruft regelmäßig öffentlich verfügbare Wechselkursdaten von der **Frankfurter API** (api.frankfurter.dev / api.frankfurter.app) ab, die Daten der **Europäischen Zentralbank (EZB)** veröffentlicht. Diese Anfragen enthalten **keine personenbezogenen Daten** — nur einen standardmäßigen anonymen HTTP-Aufruf. Ihre Konten, Guthaben und Transaktionen werden niemals übertragen. Daten werden bis zu **6 Stunden** zwischengespeichert.

### 3.2 Keine Analysen, keine Werbung

Platrare enthält **kein Analyse-SDK, keinen Absturzbericht-Dienst und kein Werbenetzwerk**. Es werden keine Nutzungsdaten, Gerätekennungen oder Verhaltenstelemetrie erfasst.

---

## 4. Geräteberechtigungen

| Berechtigung | Zweck | Wann angefordert |
|---|---|---|
| Kamera | Belegfotos aufnehmen | Nur beim Tippen auf „Foto aufnehmen" |
| Fotomediathek | Bilder für Anhänge auswählen | Nur beim Tippen auf „Aus Galerie wählen" |
| Dateien | PDFs und Dokumente anhängen | Nur beim Tippen auf „Dateien durchsuchen" |
| Biometrie / Face ID | App entsperren | Nur wenn der Sperrbildschirm angezeigt wird |
| Netzwerk | Wechselkurse abrufen | Automatisch; keine personenbezogenen Daten werden gesendet |

Die App fordert keinen Zugriff auf Standort, Kontakte, Mikrofon, Kalender oder andere oben nicht genannte Berechtigungen an.

---

## 5. App-Sperre und biometrische Authentifizierung

Wenn Sie **App beim Öffnen sperren** aktivieren:

- Die App verwendet das sichere biometrische Framework des Betriebssystems (iOS LocalAuthentication / Android BiometricPrompt). Ihre biometrischen Daten werden vollständig in der sicheren Enklave des Betriebssystems verarbeitet — die App greift niemals darauf zu, speichert oder überträgt sie.
- Wenn Sie eine PIN festlegen, wird nur ein **kryptografischer Einweg-Hash** dieser PIN im geräteinternen Speicher abgelegt. Die rohe PIN wird niemals auf den Datenträger geschrieben.

---

## 6. Sicherungen

**Exportieren** erstellt eine `.zip`-Datei (unverschlüsselt) oder `.platrare`-Datei (AES-256-passwortgeschützt). Sie wählen den Speicherort. **Wir erhalten Ihre Sicherung niemals.**

**Die automatische tägliche Sicherung** speichert eine Datei nur im geräteeigenen App-Speicher. Sie lädt nichts automatisch in die Cloud hoch. Sie können die neueste Sicherung manuell über **Einstellungen → Automatische Sicherung → In der Cloud speichern** teilen.

**Importieren** ersetzt alle Gerätedaten durch den Inhalt der Sicherung. Importieren Sie nur Sicherungen aus vertrauenswürdigen Quellen.

---

## 7. Kinder

Platrare richtet sich nicht an Kinder unter 13 Jahren. Wir erfassen wissentlich keine Informationen von Kindern.

---

## 8. Datenspeicherung und -löschung

Daten bleiben auf Ihrem Gerät, bis Sie sie in der App löschen, **Einstellungen → Daten löschen** verwenden, eine Ersatzsicherung importieren oder die App deinstallieren. Da wir keine Kopie Ihrer Daten auf unseren Servern aufbewahren, gibt es unsererseits nichts zu löschen.

---

## 9. Ihre Rechte

- **Zugang und Portabilität** — Alle Daten sind in der App sichtbar. Nutzen Sie **Sicherung exportieren** für eine portable Kopie.
- **Berichtigung** — Bearbeiten Sie jeden Eintrag jederzeit.
- **Löschung** — Nutzen Sie die Löschfunktionen in der App, **Daten löschen** oder deinstallieren Sie die App.

**EWR/UK-Nutzer:** Die DSGVO und der UK GDPR können Ihnen zusätzliche Rechte gewähren, einschließlich des Rechts, eine Beschwerde bei Ihrer lokalen Datenschutzaufsichtsbehörde einzureichen.

**Einwohner Kaliforniens:** Der CCPA/CPRA kann Anwendung finden. Da wir keine personenbezogenen Daten im Sinne des CCPA verkaufen oder weitergeben, gelten die Widerspruchsrechte in den meisten Fällen nicht.

---

## 10. Sicherheit

- Daten in einer **App-isolierten** SQLite-Datenbank, für andere Apps nicht zugänglich.
- Sicherungen können mit **AES-256-Verschlüsselung** geschützt werden.
- PINs werden ausschließlich als **kryptografischer Einweg-Hash** gespeichert.
- Netzwerkverkehr ausschließlich über **HTTPS**.

---

## 11. Änderungen

Wir können diese Richtlinie bei Funktionsänderungen aktualisieren. Das **Gültigkeitsdatum** spiegelt die letzte Überarbeitung wider. Die weitere Nutzung gilt als Zustimmung zu Änderungen.

---

## 12. Kontakt

Nutzen Sie den Kontaktweg im App Store oder bei Google Play oder **Einstellungen → Über → Support-Details kopieren** in der App.
