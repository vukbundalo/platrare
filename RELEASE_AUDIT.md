# Platrare pre-release audit (3 Sep 2026)

Reviewed at `main` @ `a4e1439`, Flutter 3.47.2 stable. `flutter analyze`: no issues. `flutter test`: 124 passed.
Kept at repo root on purpose: `docs/` is bundled into the app binary (`pubspec.yaml` assets).

## Scorecard

| Area | Score | Reason |
|---|---|---|
| Feature set | 7/10 | Planning with projections, debt classification, multi-currency, encrypted backups, CSV, widgets, Siri, reminders. |
| Data & ledger integrity | 6/10 | Balances stored not derived, money is `double`, three non-atomic write paths. |
| UI code & UX | 5/10 | Good empty states / confirmations / dark mode. ~2,000 lines of copy-paste, logic in widgets, no locale number formatting, no onboarding, portrait-only. |
| Release configuration | 5/10 | Entitlements, privacy manifest, App Group done. Missing R8 rules, backup rules, store assets, support contact; policy stale. |
| Tests & CI | 4/10 | No tests on repository writes, migrations, or planned-confirm. CI never compiles iOS or a release Android build. |
| **Overall** | **5.5/10** | Serious, capable beta. Not yet professional; the distance is weeks, not months. |

## Verified findings

Severity: **Blocker** = store rejection or user data-loss path. **High** = visible unprofessionalism or latent bug.

### Store and legal
- **Blocker** Privacy policy and `docs/STORE_DATA_DISCLOSURES.md` do not mention notifications, widgets, App Group snapshot, or Siri (added in the last three commits). All 20 translations stale.
- **Blocker** No support email/URL anywhere; policy says "see the store listing". Apple requires a Support URL; GDPR requires controller contact in the policy.
- **Blocker** No store assets: screenshots, Play feature graphic, 512 px icon, adaptive/monochrome Android icon, listing copy.
- **Blocker** Play closed-testing gate (12 testers, 14 days) not planned. Start it first.

### Data safety
- **Blocker** PIN verifier (PBKDF2 hash) is exported inside plaintext backups and the unencrypted daily auto-backup. A 4-digit PIN is recoverable offline in seconds. `lib/data/data_transfer.dart:228,259,660`, `lib/data/auto_backup_service.dart:27,155`.
- **High** Confirming a planned transaction is three separate commits (`addTransaction` → `removePlanned` → `addPlanned`); a failure after the first double-posts on retry. `lib/screens/plan_screen.dart:555-627`.
- **High** Clear-transactions and account-with-opening-balance are two commits each. `lib/data/data_repository.dart:117-129,286-287`.
- **High** Restoring an archived account from Settings only does `setState`, never persists. `lib/screens/settings_screen.dart:1981-1986`.
- **High** CSV import commits absolute balances snapshotted at preview time. `lib/data/csv/csv_import.dart:376-378,537-541`.
- **Medium** Backup header `iterations` unbounded → DoS on import. `lib/data/backup/backup_crypto.dart:37,136-139`.

### Android / iOS build
- **Blocker** R8 is on (Flutter default) with no `proguard-rules.pro` / `proguardFiles`. Verify `flutter_local_notifications` after reboot on a real release build.
- **Blocker** No `data_extraction_rules.xml` / `backup_rules.xml` while README promises Auto Backup; attachments will exceed the 25 MB quota and PIN state restores to new devices.
- **High** Flutter SDK unpinned (`.github/workflows/flutter.yml:16`); targetSdk delegated to the plugin. Play needs targetSdk 36 for updates from 31 Aug 2026.
- **High** `tool/setup_ios_widget_target.rb:23` hard-codes Team `XSM926WBNS`; project uses `XAU336YV25`.
- **High** `NSLocalNetworkUsageDescription` / `NSBonjourServices` (debug tooling) ship in release `ios/Runner/Info.plist:69-78`.
- **Medium** Privacy manifests need `1C8F.1` for App Group `UserDefaults(suiteName:)` in both targets.
- **Medium** `web/ linux/ macos/ windows/` are `com.example` boilerplate; delete until desktop is real.
- **Medium** All of `docs/` is bundled as assets (`pubspec.yaml:99`).
- **Medium** `sqlite3_flutter_libs` 0.5.x is EOL; `flutter_markdown` discontinued; `share_plus` held at 10.x; `path_provider_foundation` overridden.

### Product polish
- **High** No locale number formatting: `formatBalanceAmount` is `toStringAsFixed(2)` (`lib/utils/app_format.dart:16-17`) plus ~35 direct calls in screens.
- **High** BAM is the default base currency for everyone (`lib/data/user_settings.dart:6`, 7 UI fallbacks).
- **High** Typed `'DELETE'` confirmation is English-only (`lib/screens/settings_screen.dart:1658,1676`).
- **High** `app_pt.arb` / `app_zh.arb` are 519/613 identical to English; `nl` 76, `bs` 38, `fr` 29 untranslated (incl. transaction-type labels).
- **Medium** Accessibility: 30 px gesture-detector chips, icon-only Review/stats chips without Semantics, fixed-height hero clips at 1.3× text scale.
- **Medium** Earliest pickable date is 2020. Wrong string on planned-delete dialog (`transaction_detail_screen.dart:207-208`).

## Release plan

### Phase 1 · Unblock the stores (2–3 weeks; start Play closed test on day one)
1. Support email + hosted policy page; contact inside the policy; update `AppUrls`.
2. Rewrite policy/disclosures for notifications, widgets, App Group, Siri; regenerate translations.
3. Stop exporting the PIN hash in unencrypted backups (prefer a fresh PIN on restore).
4. One repository method, one SQLite transaction for confirm-planned, clear-transactions, account-with-opening-balance.
5. Fix archived-account restore in Settings.
6. `proguard-rules.pro` + Gradle wiring; backup/data-extraction rules excluding attachments.
7. Pin Flutter (FVM + CI `flutter-version`); set `targetSdk = 36` explicitly.
8. Remove local-network plist keys from release; add `1C8F.1`; fix widget script Team ID.
9. Delete desktop/web dirs; bundle only policy files.
10. CI: signed Android release build + iOS compile job on macOS runner.
11. Store assets: adaptive/monochrome icon, 512 px icon, 1024×500 feature graphic, 6.9"/6.5" screenshots, copy.
12. Physical-device release checklist: cold start, lock, reboot with pending reminder, export/import, widget, FX offline.

### Phase 2 · A 1.0 people keep (≈3 weeks)
1. One money formatter on `NumberFormat.currency`; delete `toStringAsFixed` in screens.
2. First-run onboarding: currency from device locale, Plan/Track/Review explainer, offer help tour, persist "seen".
3. Localise or replace the typed-word confirmation.
4. Finish nl/bs/fr; remove or complete pt/zh stubs.
5. Cache projections per expanded day; debounce search; memoise filtered lists.
6. Lift 2020 date floor; fix dialog string; cap backup iterations.
7. Material ink + 44 px targets + Semantics on chips; test at 1.5×/2× text scale.
8. Tests: repository writes, migrations v1→v3, backup round-trip with real rows, planned-confirm flow.

### Phase 3 · Professional codebase (4–6 weeks; prerequisite for sync)
1. Extract a ledger service (post, reverse, realise, archive, delete) out of `State` classes.
2. Observable repository (`Listenable` or drift `watch()`); remove `onChanged` chain and 87 bare `setState`.
3. Derive balances from the log (reuse `verifyLedger`); stop treating `Account.balance` as truth.
4. Integer minor units (schema v4).
5. Merge the two account forms, two currency pickers, three date-filter machines, four discard dialogs.
6. Enums for section/stats/period/type-group state.
7. Theme-driven typography; landscape + max-width column + two-pane Review.
8. Stricter lints; `flutter analyze --fatal-infos`.

### Phase 4 · Multi-device (8–10 weeks after Phase 3)
1. Schema v5: tombstones, HLC per row + device id, UTC ms timestamps, category ids, `changes` log written in every transaction.
2. Local sync engine proven against a second in-memory DB (balances must match) before any server.
3. E2E-encrypted op-log transport (Supabase storing blobs it cannot read) or user-owned iCloud Drive / Google Drive folder if no subscriptions.
4. Auth (magic link + Sign in with Apple) and in-app account deletion.
5. Convert backup restore to "import as changes".
6. macOS + Windows targets with widgets/biometrics/notifications gated per platform. Skip web.

## Monetisation verdict

Real but small, and only with sync. Do not run ads (breaks the privacy positioning).
- 1.0: free + one-time Pro unlock ($9.99–14.99) for attachments, CSV, widgets, via `in_app_purchase` (no third-party SDK in the policy).
- Phase 4: sync as the subscription tier ($19.99–29.99/yr, lifetime ≈ $60).
- Expect side-income unless distribution is invested in. Market the people-and-entities model, not "another expense tracker".

## Rating
5.5/10 today. 7.5 reachable after Phase 3. 8.5 with sync and desktop done well. Do not add features before Phases 1–2 are done.
