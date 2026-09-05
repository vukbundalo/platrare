# Store listing copy — data safety (reference)

Use this as a **starting point** when filling **App Store** “App Privacy” and **Google Play** “Data safety”. Adjust to match your final build and any future SDKs.

## Summary positioning

- **Account required**: No.
- **Data collection for ledger**: None by the developer’s servers in normal operation; data is **local**.
- **Internet**: Used only for **public exchange rates** (no transaction payload).

## Apple App Store — common answers

| Topic | Suggested answer |
|--------|------------------|
| **Tracking** | No |
| **Data linked to user** | Financial info, photos (if user attaches) — stored **on device**; not transmitted to you as developer via a Platrare backend |
| **Data used to track** | No |
| **Contact info** | Only if you offer support email on the listing (not collected by the app itself for “sign up”) |

Clarify with Apple’s current questionnaires: local-only storage may still require describing **types** of data the app **processes** on device (e.g. “Financial Info” for user-entered ledger). Follow the latest App Store Connect privacy form.

## Google Play — Data safety

- **Data collected**: Often **“No”** for data sent to developer servers, if you truly have no backend. If the form asks about **on-device** processing, disclose user-entered financial info and optional photos as **stored on device**.
- **Data shared**: None with third parties for ads/analytics if you did not integrate such SDKs.
- **Encryption**: Backups can be **password-protected** by the user; on-device DB is standard app sandbox (not E2E encrypted cloud).
- **Deletion**: User can uninstall; export available for portability.

## Exchange rates (both stores)

Short line for “why network”:

> The app downloads **public currency exchange rates** over the internet. It does **not** send your accounts, transactions, or balances to the rate provider.

## Permissions (already in app)

- **Camera / Photos**: Attachments to transactions (align with `Info.plist` / Play declarations).
- **Notifications** (`POST_NOTIFICATIONS` on Android 13+, `UNUserNotificationCenter` on iOS): local reminders for planned transactions. Scheduled fully offline; content is the planned row's date, description and amount.
- **Receive boot completed** (Android `RECEIVE_BOOT_COMPLETED`): re-schedules reminders after a reboot. Declare it under "other" permissions if the Play form asks; there is no background data transfer.
- **Biometrics** (`USE_BIOMETRIC` / Face ID): app lock. The app never sees biometric data.
- **Internet**: exchange rates only.

## Widgets, quick actions and Siri (iOS)

- Home-screen widgets read a precomputed JSON snapshot (projected balances + localized labels) from the App Group container `group.com.platrare.app`. Amounts are masked when app lock is on unless the user opts in. Nothing leaves the device.
- App Shortcuts / Siri intents and icon quick actions only deep-link into the app. Voice recognition is Apple's; the app receives the resolved intent.
- App Privacy answer stays **"Data Not Collected"**: the snapshot and reminders are on-device processing, not collection by the developer.

## Support contact

Both stores require a support URL or email, and the privacy policy names the controller's contact. Set `AppUrls.supportEmail` and replace `[support email]` in every `docs/PRIVACY_POLICY*.md` before submitting.

Host the full policy at a public **HTTPS** URL and link it from the store listing. The in-app **Privacy policy** button uses [`lib/config/app_urls.dart`](../lib/config/app_urls.dart); update `AppUrls.privacyPolicy` to that URL when you publish.
