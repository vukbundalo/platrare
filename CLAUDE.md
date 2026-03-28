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

### State Management
There is no state management library. All state lives in `HomePage` (a `StatefulWidget`), which holds a single `AppData` instance and passes it down to child screens. Screens call `setState((){})` on `HomePage` by receiving a callback, or modify `data` directly and call `setState` themselves.

`lib/data/app_data.dart` is the single source of truth — a plain Dart class with three lists (`accounts`, `transactions`, `plannedTransactions`) and a `categories` list. Data is in-memory only; there is no persistence layer despite `shared_preferences` being available.

### Navigation
- **Bottom nav**: `NavigationBar` in `HomePage` with 4 tabs (New Transaction, History, Plan, Accounts). Tabs are rendered all at once with `IndexedStack` to preserve state.
- **Push navigation**: `NewPlannedTransactionScreen` is pushed via `MaterialPageRoute` from the Plan tab.
- **Modals**: Account picker and account form use `showModalBottomSheet`.

### Models
- `Account` — has `id`, `name`, `balance`, `AccountGroup` (personal | partner)
- `Transaction` — links `fromAccount`/`toAccount`, `amount`, `date`, optional `category`/`description`
- `PlannedTransaction` — same shape as `Transaction`, stored separately until confirmed
- `TransactionItem` — a richer model with `TransactionType` enum and `displayTitle`/`displayIcon` helpers; currently not wired into the main app screens (coexists with the simpler models)

### Key Utilities
- `lib/utils/projections.dart` — `projectBalances(date)` simulates planned transactions up to a date to compute projected account balances; used by `PlanScreen` and `NewPlannedTransactionScreen`.

### Ongoing Refactor
Several parallel screen implementations exist that are not yet connected to the main app:
- `lib/screens/track/` — alternate transaction entry screens
- `lib/screens/plan/` — alternate plan screens
- `lib/screens/accounts/` — alternate account management screens
- `lib/screens/review/` — review screens
- `lib/data/dummy_*.dart` — test data files

The files in `lib/screens/` (root level, not subdirectory) are the ones currently used by `main.dart`.
