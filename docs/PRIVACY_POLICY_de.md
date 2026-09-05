# Datenschutzrichtlinie — Platrare

**Gültig ab:** 4. September 2026

Platrare ist eine lokal-orientierte App zur persönlichen Finanzverwaltung. Diese Richtlinie beschreibt, auf welche Daten die App zugreift, wie sie verwendet werden und welche Rechte Sie haben.

---

## 1. Wer wir sind

Platrare wird von einem einzelnen Entwickler veröffentlicht, der Verantwortlicher im Sinne der DSGVO ist. Sie erreichen den Entwickler unter **[support email]**, über den App Store oder Google Play sowie über **Einstellungen → Über → Support kontaktieren** in der App.

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
| Erinnerungen | Wenn Sie Erinnerungen für geplante Transaktionen aktivieren, werden Fälligkeitsdatum, Beschreibung und Betrag jeder anstehenden geplanten Transaktion an den lokalen Benachrichtigungsplaner des Betriebssystems übergeben, damit die Erinnerung auch bei geschlossener App angezeigt werden kann. Sie verlassen das Gerät niemals. |
| Home-Bildschirm-Widget-Snapshot (iOS) | Eine kleine, vorberechnete Zusammenfassung (prognostizierte Guthaben für die kommenden Tage und die vom Widget angezeigten Beschriftungen), die im privaten gemeinsamen Container der App gespeichert wird, damit das Widget ohne Öffnen der App dargestellt werden kann. Bei aktivierter App-Sperre werden die Beträge in diesem Snapshot maskiert, sofern Sie in den Einstellungen nichts anderes wählen. |

---

## 3. Über das Internet übertragene Daten

### 3.1 Wechselkurse

Die App ruft regelmäßig öffentlich verfügbare Wechselkursdaten von der **Frankfurter API** (api.frankfurter.dev / api.frankfurter.app) ab, die Daten der **Europäischen Zentralbank (EZB)** veröffentlicht. Diese Anfragen enthalten **keine personenbezogenen Daten** — nur einen standardmäßigen anonymen HTTP-Aufruf. Ihre Konten, Guthaben und Transaktionen werden niemals übertragen. Daten werden bis zu **6 Stunden** zwischengespeichert.

### 3.2 Keine Analysen, keine Werbung

Platrare enthält **kein Analyse-SDK, keinen Absturzbericht-Dienst und kein Werbenetzwerk**. Es werden keine Nutzungsdaten, Gerätekennungen oder Verhaltenstelemetrie erfasst. Erinnerungen, Home-Bildschirm-Widgets und Kurzbefehle funktionieren vollständig offline.

---

## 4. Geräteberechtigungen

| Berechtigung | Zweck | Wann angefordert |
|---|---|---|
| Kamera | Belegfotos aufnehmen | Nur beim Tippen auf „Foto aufnehmen" |
| Fotomediathek | Bilder für Anhänge auswählen | Nur beim Tippen auf „Aus Galerie wählen" |
| Dateien | PDFs und Dokumente anhängen | Nur beim Tippen auf „Dateien durchsuchen" |
| Biometrie / Face ID | App entsperren | Nur wenn der Sperrbildschirm angezeigt wird |
| Benachrichtigungen | Kurz vor Fälligkeit einer geplanten Transaktion erinnern | Nur wenn Sie Erinnerungen in den Einstellungen aktivieren |
| Beim Start ausführen (Android) | Erinnerungen nach einem Geräteneustart neu planen | Automatisch, nur wenn Erinnerungen aktiviert sind |
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

Nur passwortverschlüsselte `.platrare`-Exporte enthalten die gehashte App-Sperr-PIN; unverschlüsselte Exporte und automatische tägliche Sicherungen niemals. Wenn Sie eine Sicherung ohne PIN wiederherstellen, bleibt die bereits auf dem Gerät festgelegte PIN erhalten.

**Gerätesicherungen des Betriebssystems.** Die Sicherungsfunktion Ihres Telefons (iCloud Backup unter iOS, Google Auto Backup unter Android) kann das Finanzbuch der App, automatische tägliche Sicherungen und Einstellungen als Teil der Gerätesicherung in Ihr Apple- oder Google-Konto kopieren, gemäß den Bedingungen von Apple bzw. Google. Unter Android sind Beleganhänge davon ausgenommen, um innerhalb des Limits der Systemsicherung zu bleiben. Gerätesicherungen steuern Sie in den Einstellungen des Betriebssystems; der Entwickler erhält sie niemals.

---

## 7. Widgets, Kurzbefehle und Siri (iOS)

- **Home-Bildschirm-Widgets** zeigen prognostizierte Guthaben aus dem in Abschnitt 2 beschriebenen Snapshot an. Der Snapshot liegt im privaten gemeinsamen Container der App auf Ihrem Gerät und wird niemals hochgeladen. Bei aktivierter App-Sperre werden Beträge standardmäßig maskiert.
- **Schnellaktionen und App Shortcuts** (langes Drücken auf das App-Symbol, die Kurzbefehle-App oder Siri) öffnen die App lediglich auf einem bestimmten Bildschirm, zum Beispiel „Transaktion hinzufügen". Die Spracherkennung für Siri erfolgt durch iOS gemäß den Datenschutzbestimmungen von Apple; die App erhält nur den aufgelösten Befehl und sendet Ihr Finanzbuch niemals an Apple.

---

## 8. Kinder

Platrare richtet sich nicht an Kinder unter 13 Jahren. Wir erfassen wissentlich keine Informationen von Kindern.

---

## 9. Datenspeicherung und -löschung

Daten bleiben auf Ihrem Gerät, bis Sie sie in der App löschen, **Einstellungen → Daten löschen** verwenden, eine Ersatzsicherung importieren oder die App deinstallieren. Da wir keine Kopie Ihrer Daten auf unseren Servern aufbewahren, gibt es unsererseits nichts zu löschen.

---

## 10. Ihre Rechte

- **Zugang und Portabilität** — Alle Daten sind in der App sichtbar. Nutzen Sie **Sicherung exportieren** für eine portable Kopie.
- **Berichtigung** — Bearbeiten Sie jeden Eintrag jederzeit.
- **Löschung** — Nutzen Sie die Löschfunktionen in der App, **Daten löschen** oder deinstallieren Sie die App.

**EWR/UK-Nutzer:** Die DSGVO und der UK GDPR können Ihnen zusätzliche Rechte gewähren, einschließlich des Rechts, eine Beschwerde bei Ihrer lokalen Datenschutzaufsichtsbehörde einzureichen.

**Einwohner Kaliforniens:** Der CCPA/CPRA kann Anwendung finden. Da wir keine personenbezogenen Daten im Sinne des CCPA verkaufen oder weitergeben, gelten die Widerspruchsrechte in den meisten Fällen nicht.

---

## 11. Sicherheit

- Daten in einer **App-isolierten** SQLite-Datenbank, für andere Apps nicht zugänglich.
- Sicherungen können mit **AES-256-Verschlüsselung** geschützt werden.
- PINs werden ausschließlich als **kryptografischer Einweg-Hash** gespeichert.
- Netzwerkverkehr ausschließlich über **HTTPS**.

---

## 12. Änderungen

Wir können diese Richtlinie bei Funktionsänderungen aktualisieren. Das **Gültigkeitsdatum** spiegelt die letzte Überarbeitung wider. Die weitere Nutzung gilt als Zustimmung zu Änderungen.

---

## 13. Kontakt

Bei Fragen oder Anliegen zum Datenschutz schreiben Sie an **[support email]**, nutzen Sie den Kontaktweg im App Store oder bei Google Play oder **Einstellungen → Über → Support kontaktieren** in der App.
