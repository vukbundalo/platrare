# Privacy Policy — Platrare

**Effective date:** September 4, 2026

Platrare is a local-first personal-finance application. This policy describes what data the app accesses, how it is used, and your rights as a user.

---

## 1. Who We Are

Platrare is published by an individual developer, who is the data controller for the purposes of the GDPR. You can reach the developer at **[support email]**, from the App Store or Google Play listing, or via **Settings → About → Contact support** within the app.

---

## 2. Data Stored on Your Device

All data you create in Platrare remains **exclusively on your device**. We do not operate a server that receives or stores your financial information.

**What is stored locally:**

| Category | Details |
|---|---|
| Financial ledger | Accounts, real balances, overdraft limits, transaction history, planned transactions, and categories |
| Attachments | Photos of receipts and documents you choose to add to transactions |
| Preferences | Base currency, secondary currency, theme, language, balance-visibility setting |
| Security | App-lock status; a one-way cryptographic hash of your PIN (the raw PIN is never stored) |
| Exchange-rate cache | Public currency-rate data downloaded from a third-party API and cached locally |
| Reminders | If you enable reminders for planned transactions, the due date, description and amount of each upcoming planned transaction are handed to the operating system's local notification scheduler so it can show the reminder even while the app is closed. They never leave the device. |
| Home-screen widget snapshot (iOS) | A small, precomputed summary (projected balances for the coming days and the labels the widget shows) stored in the app's private shared container so the widget can render without opening the app. When app lock is on, amounts in this snapshot are masked unless you choose otherwise in Settings. |

---

## 3. Data Sent Over the Internet

### 3.1 Exchange Rates

To display amounts in multiple currencies, the app periodically fetches publicly available exchange-rate data from the **Frankfurter API** (api.frankfurter.dev / api.frankfurter.app), which publishes data sourced from the **European Central Bank (ECB)**. These requests:

- Contain **no personal information** — only a standard anonymous HTTP call.
- Do **not** include your account names, balances, transactions, or any other ledger content.
- Are cached on-device for up to **6 hours** to minimise network activity.

Frankfurter's own privacy practices govern any data their servers may log (e.g. IP addresses in standard HTTP access logs).

### 3.2 No Analytics, No Advertising

Platrare contains **no analytics SDK, no crash-reporting service, and no advertising network**. No usage data, device identifiers, or behavioural telemetry are collected or transmitted. Reminders, home-screen widgets and shortcuts work entirely offline.

---

## 4. Device Permissions

| Permission | Purpose | When requested |
|---|---|---|
| Camera | Capture photos of receipts | Only when you tap "Take photo" in the attachment sheet |
| Photo library | Select images or files to attach | Only when you tap "Choose from gallery" |
| Files | Attach PDFs and other documents | Only when you tap "Browse files" |
| Biometrics / Face ID | Unlock the app when app lock is enabled | Only when the lock screen is displayed |
| Notifications | Remind you shortly before a planned transaction is due | Only when you enable reminders in Settings |
| Run at startup (Android) | Re-schedule your reminders after the device restarts | Automatically, only if reminders are enabled |
| Network | Fetch currency exchange rates | Automatically in background; no personal data is sent |

The app does **not** request access to your location, contacts, microphone, calendar, or any permission not listed above.

---

## 5. App Lock and Biometric Authentication

When you enable **Lock app on open** in Settings:

- The app uses the operating-system secure biometric framework (iOS LocalAuthentication / Android BiometricPrompt). Your fingerprint or facial data is processed entirely within the **OS secure enclave** — the app never sees, stores, or transmits biometric data.
- If you set a PIN, only a **one-way cryptographic hash** of that PIN is stored in app-private device storage. The raw PIN is never written to disk.

---

## 6. Backups

**Export** produces a `.zip` (unencrypted) or `.platrare` (AES-256 password-encrypted) file. You choose where to store it — Files app, iCloud Drive, Google Drive, AirDrop, local storage, etc. **We never receive your backup file.**

**Automatic daily backup** saves a file to app-private device storage only. It does **not** automatically upload to any cloud service. You can manually share the latest backup to a cloud location via **Settings → Automatic daily backup → Save to cloud**.

**Import** replaces all on-device data with the contents of the selected backup. Import only from backups you trust and have verified.

Only password-encrypted `.platrare` exports include the hashed app-lock PIN; unencrypted exports and automatic daily backups never do. When you restore a backup that has no PIN, the PIN already set on the device is kept.

**Operating-system device backups.** Your phone's own backup feature (iCloud Backup on iOS, Google Auto Backup on Android) may copy the app's ledger, automatic daily backups and preferences to your Apple or Google account as part of the device backup, under Apple's or Google's terms. On Android, receipt attachments are excluded from this to stay within the system backup limit. You control device backups in the operating-system settings; the developer never receives them.

---

## 7. Widgets, Shortcuts and Siri (iOS)

- **Home-screen widgets** display projected balances from the snapshot described in section 2. The snapshot lives in the app's private shared container on your device and is never uploaded. When app lock is on, amounts are masked by default.
- **Quick actions and App Shortcuts** (long-press on the app icon, the Shortcuts app, or Siri) only open the app at a chosen screen, for example "Add transaction". Voice recognition for Siri is performed by iOS under Apple's privacy terms; the app receives only the resolved command and never sends your ledger to Apple.

---

## 8. Children

Platrare is not directed at children under 13 years of age (or the applicable minimum age in your jurisdiction). We do not knowingly collect information from children. If you believe a child has used the app inappropriately, please contact us via the support details available in the app.

---

## 9. Data Retention and Deletion

- On-device data persists until you delete it within the app, use **Settings → Clear data**, import a replacement backup, or uninstall the app.
- Uninstalling the app removes app-local storage, subject to OS behaviour (e.g. iCloud device backups may retain a snapshot until overwritten by the OS).
- Because we hold **no copy of your data on our servers**, there is nothing to delete on our end.

---

## 10. Your Rights

Because all data resides on your device, you exercise your rights directly through the app:

- **Access & Portability** — All your data is visible within the app. Use **Export backup** to obtain a portable, machine-readable copy.
- **Correction** — Edit any account, transaction, or category at any time.
- **Deletion** — Use the in-app delete functions, **Settings → Clear data**, or uninstall the app.

**EEA and UK users:** The General Data Protection Regulation (GDPR) and UK GDPR may grant you additional rights, including the right to lodge a complaint with your local data-protection supervisory authority.

**California residents:** The California Consumer Privacy Act (CCPA / CPRA) may apply. Because we do not sell or share personal information as defined under the CCPA, opt-out rights do not apply in most cases. You may contact us to confirm.

---

## 11. Security

- All financial data is stored in an **app-sandboxed** SQLite database inaccessible to other apps on the device.
- Backup files can be protected with **AES-256 encryption** and a password you choose.
- PINs are stored as a **one-way cryptographic hash** only — they cannot be recovered or reversed.
- All network traffic uses **HTTPS** exclusively.

---

## 12. Changes to This Policy

We may update this policy as features evolve. The **Effective date** at the top will reflect the latest revision. Continued use of the app after an update constitutes acceptance of the revised policy. Significant changes will be noted in App Store and Google Play release notes.

---

## 13. Contact

For privacy-related questions or requests, email **[support email]**, use the contact method on the App Store or Google Play listing, or tap **Settings → About → Contact support** within the app.
