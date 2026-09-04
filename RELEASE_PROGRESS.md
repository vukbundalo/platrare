# Release progress tracker

Working log for the plan in [RELEASE_AUDIT.md](RELEASE_AUDIT.md). Update this file after every completed step
so a new session can resume from it. Branch: `claude/app-review-release-plan-9aj2as`.

Legend: `[x]` done · `[~]` in progress · `[ ]` not started · `[!]` needs the owner (decision, credentials, device)

## How to resume in a new session

1. Read RELEASE_AUDIT.md (why) and this file (where we are).
2. `git log --oneline -20` on the branch shows one commit per step below.
3. Toolchain: `flutter` is not preinstalled in the remote container. Clone stable into the scratchpad
   (`git clone --depth 1 -b stable https://github.com/flutter/flutter.git`) and add `flutter/bin` to PATH.
   `flutter pub get` rewrites `pubspec.lock` and `analysis_options.yaml`; revert those before committing
   unless the step intends to change them.
4. Run `flutter analyze` and `flutter test` before every commit.

## Phase 1 · Unblock the stores

| # | Step | Status | Notes |
|---|------|--------|-------|
| 1a | Support email + hosted policy URL in `AppUrls` and in the policy text | [!] | Owner must choose the address and enable GitHub Pages (Settings → Pages → branch `main`, folder `/docs`). Code side prepared in step 1b. |
| 1b | Add `AppUrls.supportEmail` / `supportUrl` and wire About screen "Contact support" | [ ] | |
| 2 | Privacy policy + store disclosures cover notifications, widgets, App Group snapshot, Siri | [ ] | English first, then the 20 translations. |
| 3 | PIN verifier no longer leaves the device in unencrypted backups | [x] | Only encrypted `.platrare` exports carry it; restore without it keeps the device PIN. Test: `test/backup_pin_hash_test.dart`. |
| 4 | Atomic repository ops: confirm-planned, clear-transactions, account-with-opening-balance | [x] | `DataRepository.realizePlanned` / `replacePlanned` (skip + undo) / `addAccount` / `clearSelectiveData` each one SQLite commit. Tests: `test/data_repository_test.dart`; `PlatrareDatabase.useForTesting` installs an in-memory DB. |
| 5 | Archived-account restore in Settings persists | [x] | |
| 6 | `proguard-rules.pro` + Gradle wiring; `backup_rules.xml` + `data_extraction_rules.xml` | [x] | Not build-verified here (no Android SDK in the container); first CI/local release build must confirm. |
| 7 | Pin Flutter (`.fvmrc`, CI `flutter-version`); `targetSdk = 36` explicit | [x] | Pinned 3.47.2; pubspec.lock and analysis_options.yaml refreshed under that SDK. Owner: run `fvm install` or match locally. |
| 8 | iOS: strip local-network plist keys in Release; `1C8F.1` in both privacy manifests; fix Team ID in widget script | [ ] | |
| 9 | Delete `web/ linux/ macos/ windows/`; bundle only policy files, not all of `docs/` | [x] | Re-add macOS/Windows deliberately in Phase 4. |
| 10 | CI: signed Android release build (skips signing when secrets absent) + iOS compile job | [ ] | Secrets `UPLOAD_KEYSTORE_B64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD` are the owner's to add. |
| 11 | Store assets: adaptive + monochrome icon, 512 icon, feature graphic, listing copy | [ ] | Screenshots need a device: owner. |
| 12 | Play closed test (12 testers, 14 days) | [!] | Owner. Start as soon as an internal build exists. |
| 13 | Physical-device release checklist run | [!] | Owner. |

## Phase 2 · A 1.0 people keep

Not started. See RELEASE_AUDIT.md for the list.

## Phase 3 · Professional codebase

Not started.

## Phase 4 · Multi-device

Not started.

## Session log

- 2026-09-03 · Audit written and published; RELEASE_AUDIT.md committed.
- 2026-09-04 · Started Phase 1 execution.
