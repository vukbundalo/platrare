# Platrare

Local-first personal finance app (Flutter, drift/SQLite, iOS + Android). See README.md for features.

## Release work in progress

- `RELEASE_AUDIT.md` — the pre-release audit: verified findings, four-phase plan, monetisation and sync roadmap.
- `RELEASE_PROGRESS.md` — live tracker of which steps are done, in progress, or waiting on the owner.
  **Read it first and update it after every completed step.** One commit per step.

## Conventions

- `docs/` is bundled into the app binary for the in-app privacy policy screen. Keep release notes,
  checklists and audits at the repo root, not in `docs/`.
- Money is currently `double`; balances are stored on `Account` and mutated through `DataRepository`.
  Every multi-row write must go through one SQLite `transaction()` in `PlatrareDatabase`.
- Run `flutter analyze` and `flutter test` before committing. `flutter pub get` on a newer SDK rewrites
  `pubspec.lock` and `analysis_options.yaml`; revert those unless intended.
- Commit messages: short imperative subject, body listing scope, e.g. `Plan: hide timeline for future snapshot projections`.
