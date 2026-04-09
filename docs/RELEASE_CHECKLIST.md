# Release checklist (privacy-first, no third-party crash SDK)

Use this before each store submission.

## Builds

- [ ] Bump `version` / build number in [`pubspec.yaml`](../pubspec.yaml) and ship matching native build numbers.
- [ ] `flutter analyze` and `flutter test` pass (see CI workflow).
- [ ] Release build on a **physical device**: cold start, lock/unlock, export backup, import backup (test file), FX refresh on Wi‑Fi and offline.

## Crash monitoring (no SaaS crash reporter)

- [ ] **iOS**: After upload, confirm **dSYM** / symbols are processed in App Store Connect so crash logs symbolicate.
- [ ] **iOS**: Review **Crashes** in Xcode Organizer / App Store Connect after the first TestFlight or production rollout.
- [ ] **Android**: Use **Play Console** → **Android vitals** / **Pre-launch reports** for crashes ANRs.
- [ ] Do **not** rely on Firebase Crashlytics / Sentry unless you intentionally add them and update the privacy policy.

## Privacy & compliance

- [ ] Hosted **privacy policy** URL is live and matches [`docs/PRIVACY_POLICY.md`](PRIVACY_POLICY.md).
- [ ] [`lib/config/app_urls.dart`](../lib/config/app_urls.dart) `AppUrls.privacyPolicy` points to that URL.
- [ ] Store **data safety** / **App Privacy** forms filled using [`docs/STORE_DATA_DISCLOSURES.md`](STORE_DATA_DISCLOSURES.md) as reference.
- [ ] [`ios/Runner/PrivacyInfo.xcprivacy`](../ios/Runner/PrivacyInfo.xcprivacy) present and updated if you add APIs that require declared reasons.

## Backup UX

- [ ] Encrypted export (`.platrare`) and import with password tested.
- [ ] Unencrypted export warning flow tested once.

## Support

- [ ] In-app **Copy support info** (version + build) works if users email you.
