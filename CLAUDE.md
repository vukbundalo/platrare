# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # Install dependencies
flutter analyze          # Run static analysis (flutter_lints)
flutter test             # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter run              # Run in debug mode
flutter build apk        # Build for Android
flutter build macos      # Build for macOS
```

## Architecture

**Platrare** is a personal finance Flutter app (Material 3, indigo theme) for tracking transactions and planning future spending.

### Persistence

SQLite via **Drift** (`lib/data/local/platrare_database.dart`). On startup, `main()` opens the database and calls `PlatrareDatabase.instance.loadIntoMemory()` so in-app state mirrors the DB. Writes go through `DataRepository` (`lib/data/data_repository.dart`).

### State Management

There is no state management library. `HomePage` holds the shared `AppData` (loaded from the DB) and passes `onChanged` callbacks so child screens trigger `setState` on the home shell. `lib/data/app_data.dart` holds `accounts`, `transactions`, `plannedTransactions`, and `categories`.

### Navigation

- **Bottom nav**: `NavigationBar` in `HomePage` with **3** tabs — **Plan**, **Track**, **Review** — rendered with `IndexedStack` to preserve state (`lib/main.dart`).
- **Push routes**: e.g. `NewPlannedTransactionScreen` from Plan, `NewTransactionScreen`, `TransactionDetailScreen`, `AccountTransactionsScreen`, `SettingsScreen` via `MaterialPageRoute`.
- **Modals**: sheets and dialogs as needed (account flows, pickers).

### Screens

Active UI lives under **`lib/screens/`**: main tab screens and flows listed above, plus **`lib/screens/review/account_form_widgets.dart`** (`AccountFormSheet` / `AccountFormScreen`, re-exported from `review_screen.dart`). There are no `lib/screens/track/` or other parallel subpackages in this tree.

### Models

- `Account` — `id`, `name`, `balance`, `AccountGroup` (personal | partner), etc.
- `Transaction` — `fromAccount` / `toAccount`, `amount`, `date`, optional `category` / `description`
- `PlannedTransaction` — same general shape, kept separate until realized
- Ledger integrity: `lib/data/ledger_verify.dart`; opening balances for new accounts via `DataRepository.addAccount`

### Key Utilities

- `lib/utils/projections.dart` — `projectBalances(date)` for planned cashflow; used by plan flows.
- `lib/data/fx_service.dart` — FX rates (Frankfurter v2 + fallback), cached.
- `lib/theme/ledger_colors.dart` / `lib/utils/tx_display.dart` — consistent money colors in the UI.
