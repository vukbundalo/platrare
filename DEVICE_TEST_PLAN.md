# Device test plan (before merging PR #1 / before the first store build)

CI proves the release builds compile and the unit tests pass. It cannot prove what a phone shows.
Run this once on Android and once on iOS. Tick what passes; anything else goes back to the tracker.

## Installing

**Android** — download the `android-test-apk` artifact from the latest green CI run on the PR
(Actions → Flutter CI → run → Artifacts), unzip, and install `app-release.apk` on the phone
(allow "install unknown apps" for your file manager). It is debug-signed, so uninstall any
previous Platrare build first or Android will refuse the signature change.

**iOS** — from your Mac on this branch:

```sh
git fetch origin && git checkout claude/app-review-release-plan-9aj2as
flutter pub get
flutter run --release -d <your-iphone>      # needs your Team ID in Xcode signing
```

## 1. First run (fresh install, no backup)
- [ ] Splash, then the onboarding screen appears once. Base currency suggested matches your phone language/region; changing it works.
- [ ] "Show me around" starts the Plan tour on the first screen; "Get started" lands on Plan.
- [ ] Kill and reopen: onboarding does not appear again.

## 2. Accounts
- [ ] Add a personal account with an opening balance; the balance shows, an `Opening balance` row exists in Track.
- [ ] Edit the balance in the account form; a correction row is added and a dialog explains it.
- [ ] Archive an account with zero balance; restore it from Settings → Archived accounts; kill the app; it is still restored.
- [ ] Pick an icon and a colour; the avatar shows that icon (not a box or the letter).

## 3. Transactions
- [ ] Add income, expense, and a transfer between two personal accounts. Balances move correctly.
- [ ] Amounts are formatted for your language (thousands separator, decimal comma where applicable) on Track, Plan, Review, account history and the transaction detail.
- [ ] Delete a transaction, then Undo from the snackbar; balance returns.
- [ ] Edit a transaction and retarget it to another account; both accounts end up right.
- [ ] Search in Track while typing quickly; the list stays responsive.

## 4. Plan
- [ ] Add a monthly planned expense; confirm it. A transaction appears, the planned row moves to next month, balance moves once.
- [ ] Skip an occurrence, then Undo.
- [ ] Expand a day's projection panel; collapse it.
- [ ] Date chip cycles all time → day → week → month → year; arrows navigate and stop at the horizon.

## 5. Review
- [ ] Section chips (Personal / Individuals / Entities / Statistics) and the currency toggle work and show tooltips on long-press.
- [ ] Statistics: Spent / Received, period chip, chart style, compare mode.
- [ ] Settings → Verify ledger reports "All accounts match". (Then, optionally, edit the database with a tampered balance is not possible from the UI, so just confirm the button exists.)

## 6. Settings and data
- [ ] Export an encrypted backup and an unencrypted one; import each; data returns intact; app lock stays as it was.
- [ ] CSV export opens in a spreadsheet; CSV import previews and applies.
- [ ] Clear data asks for the localized word (e.g. LÖSCHEN in German) and accepts it.
- [ ] About → Contact support is hidden until `AppUrls.supportEmail` is set (expected on this build).

## 7. Lock, reminders, widgets
- [ ] Enable app lock with PIN and biometrics; lock/unlock; wrong PIN five times triggers the lockout.
- [ ] Enable planned reminders; schedule one for a few minutes ahead; background the app; the notification arrives.
- [ ] **Android only**: with a reminder pending, reboot the phone; the reminder still arrives (this is what the R8 keep rules protect).
- [ ] **iOS only**: add the Balance and Quick add widgets; figures match the app; quick-add opens the right screen; masked amounts when app lock is on.

## 8. Accessibility and appearance
- [ ] System text size at the largest setting: onboarding, all three tabs and the hero cards render without clipping.
- [ ] Dark mode on every screen.
- [ ] VoiceOver / TalkBack reads the hero chips and period arrows with meaningful labels.

## 9. Upgrade path (existing users)
- [ ] Install the *previous* build (main), create accounts and transactions, then install this build over it: no onboarding, data intact, Verify ledger matches.
