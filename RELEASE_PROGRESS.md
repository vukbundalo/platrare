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
| 1a | Support email + hosted policy URL in `AppUrls` and in the policy text | [!] | Owner: (1) set `AppUrls.supportEmail` in `lib/config/app_urls.dart`; (2) replace `[support email]` in every `docs/PRIVACY_POLICY*.md`; (3) enable GitHub Pages (repo Settings → Pages → branch `main`, folder `/docs`) and point `AppUrls.privacyPolicy` at the Pages URL. |
| 1b | Add `AppUrls.supportEmail` and wire About screen "Contact support" | [x] | `AppUrls.supportEmail` is `''` on purpose; the About button appears once it is set. mailto opens the mail app, falls back to copying the address. |
| 2 | Privacy policy + store disclosures cover notifications, widgets, App Group snapshot, Siri | [x] | EN + disclosures (e679402) and all 20 translations. `[support email]` placeholder remains for the owner (step 1a). |
| 3 | PIN verifier no longer leaves the device in unencrypted backups | [x] | Only encrypted `.platrare` exports carry it; restore without it keeps the device PIN. Test: `test/backup_pin_hash_test.dart`. |
| 4 | Atomic repository ops: confirm-planned, clear-transactions, account-with-opening-balance | [x] | `DataRepository.realizePlanned` / `replacePlanned` (skip + undo) / `addAccount` / `clearSelectiveData` each one SQLite commit. Tests: `test/data_repository_test.dart`; `PlatrareDatabase.useForTesting` installs an in-memory DB. |
| 5 | Archived-account restore in Settings persists | [x] | |
| 6 | `proguard-rules.pro` + Gradle wiring; `backup_rules.xml` + `data_extraction_rules.xml` | [x] | Not build-verified here (no Android SDK in the container); first CI/local release build must confirm. |
| 7 | Pin Flutter (`.fvmrc`, CI `flutter-version`); `targetSdk = 36` explicit | [x] | Pinned 3.47.2; pubspec.lock and analysis_options.yaml refreshed under that SDK. Owner: run `fvm install` or match locally. |
| 8 | iOS: strip local-network plist keys in Release; `1C8F.1` in both privacy manifests; fix Team ID in widget script | [x] | New Xcode run-script phase "Strip Debug-Only Info.plist Keys" (Release only). Verify once in Xcode: archive, then inspect the built Info.plist. |
| 9 | Delete `web/ linux/ macos/ windows/`; bundle only policy files, not all of `docs/` | [x] | Re-add macOS/Windows deliberately in Phase 4. |
| 10 | CI: signed Android release build (skips signing when secrets absent) + iOS compile job | [x] | Three jobs: check (lockfile, generated-code drift, analyze --fatal-infos, tests), android (AAB + 16 KB zipalign check + artifacts), ios (build --no-codesign + asserts Release plist has no Bonjour keys). Owner adds secrets `UPLOAD_KEYSTORE_B64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`. First run happens when this branch is merged/PR'd to main. |
| 11 | Store assets: adaptive + monochrome icon, 512 icon, feature graphic, listing copy | [~] | Done: adaptive + monochrome launcher icon (`mipmap-anydpi-v26/platrare.xml`), `store/play/icon-512.png`, `store/play/feature-graphic-1024x500.png`, `store/listing/en-US/*` copy, `store/README.md`. Owner: screenshots (6.9" + 6.5" iPhone, Play phone) need a device; see `store/README.md` for the suggested set. |
| 12 | Play closed test (12 testers, 14 days) | [!] | Owner. Start as soon as an internal build exists. |
| 13 | Physical-device release checklist run | [!] | Owner. |

## Phase 2 · A 1.0 people keep

| # | Step | Status | Notes |
|---|------|--------|-------|
| 1 | Locale-aware money formatting in one place | [x] | `lib/utils/money_format.dart`; `formatBalanceAmount` and `fx.formatNative*` route through it; `setAppNumberLocale` is called from the MaterialApp locale resolution. Display sites no longer call `toStringAsFixed`. Text-field values (amount editors), CSV and backup stay invariant on purpose. iOS widget snapshot stays ungrouped until `AmountFormatter.swift` groups too. Tests: `test/money_format_test.dart`. |
| 2 | First-run onboarding: currency from device locale, Plan/Track/Review explainer, offer help tour, persist "seen" | [x] | `OnboardingScreen` overlays Home after the splash on first run only (installs with accounts or a lock are marked done in `main`). Base currency from `suggestedBaseCurrency(deviceLocale)` via intl. "Show me around" bumps `requestPlanHelpTour`; PlanScreen starts its tour. `CurrencyPickerSheet` extracted to `lib/widgets/` (Settings uses it; the account-form copy is Phase 3 dedupe). Not yet seen on a device: owner to check the first-run flow once. |
| 3 | Localise or replace the typed-word "DELETE" confirmation | [x] | New `clearDataConfirmWord` key (localized verb) used as hint and match; the two prompt strings no longer hard-code DELETE; English word still accepted. |
| 4 | Finish nl/bs/fr ARB translations; remove or complete pt/zh base stubs | [x] | 69 nl, 34 bs, 6 fr strings translated (the rest were legitimately identical: Plan, Net, Date, 1M…). `app_pt.arb` / `app_zh.arb` must exist for gen-l10n, so they now carry the pt_BR / zh_Hans text instead of English. |
| 5 | Cache projections per expanded day; debounce search; memoise filtered lists | [x] | Track: `historicalBalances` only for the expanded day, search debounced 220 ms, filtered list built once per frame, scroll handler reuses the last day count. Plan: `projectBalances` only for the expanded day. Planned form: projection memoised per date. |
| 6 | Lift 2020 date floor; fix planned-delete dialog string; cap backup PBKDF2 iterations | [x] | Date pickers accept 1970+. New `planDeleteTitle`/`planDeleteBody` keys (24 locales). Import rejects iteration counts outside 10k–2M (`test/backup_iterations_cap_test.dart`). |
| 7 | Chips: Material ink, 44 px targets, Semantics labels; test at 1.5×/2× text scale | [x] | `HeroTapChip` (ink, focus ring, tooltip, semantics) replaces GestureDetector chips in the hero rows, Review section/stats chips and all period arrows; every icon-only control now has a label (6 new keys × 24 locales). Chips are 34 dp (the fixed hero extent allows no more; gap reduced so height is unchanged). Hero content clamps text scale at 1.3× so 2× accessibility text no longer overflows the card. `test/text_scale_test.dart` pumps onboarding + all tabs at 1.5× and 2×. Full 44 dp targets and a fluid hero remain Phase 3. |
| 8 | Tests: migrations v1→v3, backup round-trip with real rows | [x] | `test/schema_migration_test.dart` builds a v1 SQLite file from the current DDL minus the added columns, lets drift upgrade, checks rows and the `updated_at` backfill. `test/backup_real_rows_test.dart` round-trips two accounts, a cross-currency advance, a categorised expense and a capped monthly plan; it exposed that the transaction encoder dropped account ids when only the object link was set (fixed). `sqlite3` added as a dev dependency. |

## Phase 3 · Professional codebase

| # | Step | Status | Notes |
|---|------|--------|-------|
| 1 | Extract a ledger service | [x] | `lib/data/ledger_service.dart`: post / remove / restoreAt / replace (classifies after reversing the old row) / realizePlanned / nextOccurrenceOf / setBookBalance. No screen mutates `Account.balance` any more (grep is clean). One credit rule `creditAmountOf` in `models/transaction.dart` shared by posting, `verifyLedger` and projections (three divergent copies before). Tests: `test/ledger_service_test.dart` checks memory, SQLite and a from-zero replay agree after every operation. |
| 2 | Observable repository; remove the `onChanged` chain and bare `setState` fan-out | [ ] | |
| 3 | Derive balances from the log instead of storing them as truth | [ ] | |
| 4 | Integer minor units (schema v4) | [ ] | |
| 5 | Deduplicate account forms, currency pickers (one done), date-filter machines, discard dialogs | [ ] | |
| 6 | Enums for section / stats / period / type-group state | [ ] | |
| 7 | Theme-driven typography; landscape + max-width column + two-pane Review | [ ] | |
| 8 | Stricter lints; analyze fatal on infos | [ ] | CI already runs `--fatal-infos`. |

## Phase 4 · Multi-device

Not started.

## Session log

- 2026-09-03 · Audit written and published; RELEASE_AUDIT.md committed.
- 2026-09-04 · Started Phase 1 execution.
- 2026-09-05 · Phase 1 code/doc steps complete (owner items 1a, 12, 13 and screenshots remain). Phase 2 steps 1–8 complete; owner should run the app once on a device to eyeball onboarding, the hero chips and large-text rendering.
