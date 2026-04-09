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

Host the full policy at a public **HTTPS** URL and link it from the store listing. The in-app **Privacy policy** button uses [`lib/config/app_urls.dart`](../lib/config/app_urls.dart); update `AppUrls.privacyPolicy` to that URL when you publish.
