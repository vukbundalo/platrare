# Platrare

Local-first personal finance for Android and iOS. Plan upcoming transactions, track everyday income and spending, and review your accounts — including money you share, lend, or owe to specific people and businesses.

**Your data never leaves your device.** Platrare has no server, no account sign-up, no analytics, and no ads. The only network traffic is fetching public currency exchange rates. See the full [privacy policy](docs/PRIVACY_POLICY.md) (available in 21 languages).

## Features

- **Plan** — schedule one-off and repeating transactions (daily/weekly/monthly/yearly, with weekend adjustment) and see projected account balances.
- **Track** — record income, expenses, transfers, and debt movements with categories, search, filters, and receipt-photo attachments.
- **Review** — statistics, comparisons, and per-account history across three account groups: your own accounts (*personal*), people you settle with (*individuals*), and businesses or projects (*entities*). Loans, IOUs, advances, and settlements are classified automatically.
- **Multi-currency** — base + secondary display currency with ECB exchange rates via the [Frankfurter API](https://frankfurter.dev), cached offline.
- **Security** — optional app lock with biometrics or PIN (PBKDF2-hashed, attempt throttling).
- **Backups** — encrypted manual export/import plus silent daily auto-backups that ride iCloud Backup (iOS) and Google Auto Backup (Android).
- **21 languages** including RTL (Arabic) and script variants (Serbian Cyrillic/Latin, Simplified Chinese).

## Development

Standard Flutter workflow:

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

Release process: see [docs/RELEASE_CHECKLIST.md](docs/RELEASE_CHECKLIST.md). Android release signing expects `android/key.properties` (copy from [`android/key.properties.example`](android/key.properties.example)); without it, release builds fall back to debug signing for local testing.

The Inter font is bundled under `assets/fonts/` (SIL Open Font License — see `assets/fonts/OFL.txt`) so no fonts are fetched at runtime.
