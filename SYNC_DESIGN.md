# Multi-device sync design (Phase 4)

Direction chosen by the owner on 2026-09-05: **own backend, end-to-end encrypted**. The server stores
ciphertext it cannot read; sync is the paid tier. This document is the plan a new session should
implement from, in the order given. Nothing here is built yet.

## Goals and non-goals

Goals
- One person, several devices (iPhone, Android phone, later macOS/Windows) see the same ledger.
- Offline first stays true: every device works without the server and reconciles later.
- The privacy promise survives: the server never holds a readable balance, name or amount.
- The people-and-entities classification stays deterministic across devices.

Non-goals (for the first release of sync)
- Sharing a ledger between two people.
- Real-time collaboration; a few seconds of lag after resume is fine.
- Web.

## Why the current schema cannot sync (from RELEASE_AUDIT.md)

Stored balances (mutable running totals), physical deletes, seconds-resolution local timestamps,
name-keyed categories, absolute attachment paths, and "replace all" backup restore. Each is fixed
below.

## 1. Schema v5 (local, drift)

| Change | Detail |
|---|---|
| Tombstones | `deleted_at INTEGER NULL` on `db_accounts`, `db_transactions`, `db_planned_transactions`, `db_categories`. Reads filter `deleted_at IS NULL`. `loadIntoMemory` skips tombstones. Hard delete only from a housekeeping job after the row is known to be synced everywhere (or never, initially). |
| Row version | `rev TEXT NOT NULL` = hybrid logical clock `"<millis 13 digits>-<counter 4 digits>-<deviceId>"`. Lexicographic order is causal order. Every write bumps it through one helper (`Hlc.next()`), never by hand. |
| Timestamps | New columns `created_ms`, `updated_ms` (UTC epoch milliseconds). Old `created_at`/`updated_at` stay until v6 and are backfilled from them. Drift `DateTime` columns store unix seconds, which lost sub-second ordering; the new columns are plain `INTEGER`. |
| Category identity | `db_categories.id` becomes stable; `db_transactions.category_id` and `db_planned_transactions.category_id` reference it. Migration resolves existing `category` names to ids (creating rows if missing); the `category` name column stays as a denormalised label for display and for old backups. Rename becomes a one-row update. Two devices adding "Groceries" merge by `(name, kind)` at apply time. |
| Opening-row backfill | For every account whose stored balance differs from the replay of its log, insert a synthetic `__opening_balance__` transaction dated at `created_at` with the difference. After this, `replayBalances` reproduces every stored balance and balances can be **derived**. This is the prerequisite RELEASE_PROGRESS.md Phase 3 step 3 is waiting on. |
| Change log | New table `db_changes(id TEXT PK, entity TEXT, row_id TEXT, op TEXT('upsert'|'delete'), payload TEXT(JSON), rev TEXT, device_id TEXT, created_ms INTEGER, pushed INTEGER DEFAULT 0)`. Written **inside the same `transaction()`** as the row write by `PlatrareDatabase`, never by screens. |
| Device identity | `device_id` (UUID v4) in SharedPreferences, generated once. |
| Attachments | `db_attachments(hash TEXT PK, bytes INTEGER, mime TEXT, local_path TEXT NULL, uploaded INTEGER)`. Transactions reference hashes; the local file lives at `platrare_attachments/<hash>`. Existing files are hashed and renamed by the migration. |

Migration tests: extend `test/schema_migration_test.dart` with v3 → v5 fixtures, including an account
with a stale balance (must gain an opening row) and two categories with the same name in different
kinds.

## 2. Balances become derived

After v5, `Account.balance` is a cache:
- `LedgerService` still shifts it in memory for immediate UI feedback (unchanged).
- After applying a remote batch, `LedgerService.rebalanceFromLog()` runs for the affected accounts.
- On startup, `verifyLedger` mismatches are repaired automatically (safe now, because the backfill
  made every log complete). The debug invariant stays.
- Sync never transmits `balance`; the account payload omits it.

## 3. Conflict policy (one sentence each)

- Transactions and planned rows: last writer wins per row by `rev`; a tombstone with a newer `rev`
  wins over an edit; an edit with a newer `rev` resurrects.
- Accounts: field-level last writer wins by `rev` for name, institution, group, icon, colour,
  overdraft, archived, sort order. `balance` is never merged; it is recomputed.
- Categories: merge by `(name, kind)`; the older `rev` keeps the id, transactions that referenced the
  loser are re-pointed.
- Preferences (base currency, secondary currency) are **not** synced in v1 of sync; they stay per
  device. Base currency affects only display.

Classification (`classifyTransaction`) depends on the counterparty's prior balance. Because the log
replays in `(date, created_ms, rev)` order on every device, the same rows produce the same balances
and the stored `txType` (written at posting time) is kept as an immutable fact of the row, not
re-derived. This avoids two devices disagreeing about advance vs settlement.

## 4. Protocol

Server model (Postgres, Supabase):

```sql
create table sync_changes (
  user_id    uuid not null references auth.users(id) on delete cascade,
  seq        bigserial primary key,
  device_id  uuid not null,
  change_id  uuid not null unique,      -- idempotent push
  nonce      bytea not null,
  cipher     bytea not null,            -- AES-256-GCM(payload JSON batch)
  created_at timestamptz not null default now()
);
create table sync_devices (
  user_id uuid not null references auth.users(id) on delete cascade,
  device_id uuid primary key,
  name text, platform text, last_seen timestamptz
);
-- RLS: user_id = auth.uid() on every table.
```

Client loop (`SyncService`):
1. **Push**: batch unpushed `db_changes` (≤ 200 rows), encrypt as one blob, POST; on 2xx mark pushed.
   Retries are safe because `change_id` is unique server-side.
2. **Pull**: `GET /sync_changes?seq=gt.<lastSeq>&device_id=neq.<me>` in pages; decrypt; apply each
   change through `PlatrareDatabase.applyRemote(change)` inside one transaction per page; then
   `rebalanceFromLog()`; store `lastSeq`.
3. Triggers: after every `ledgerRevision` bump (debounced 2 s), on app resume, and every 15 minutes
   while foregrounded. No background fetch in v1.
4. A brand-new device with an empty ledger pulls from `seq = 0`; a device that already has local data
   and signs in performs a **merge**, not a replace: its local rows are appended to `db_changes` as
   upserts and pushed, then it pulls.

The existing backup restore stays "replace all" locally **and** writes tombstones + upserts to the
change log for every difference, so a restore on one device propagates.

## 5. Encryption

- One **ledger key** (256-bit, random) per user, generated on the first device.
- The ledger key is wrapped with a **passphrase key** derived by Argon2id (memory 64 MiB, 3 passes,
  parallelism 1) from a user passphrase of at least 8 characters; the wrapped key + Argon2 params are
  stored on the server (`sync_keys` table). A new device enters the passphrase, unwraps, and keeps
  the ledger key in the OS keystore (`flutter_secure_storage`, new dependency).
- Batches are AES-256-GCM with a random 12-byte nonce, using the already-audited primitives from
  `lib/data/backup/backup_crypto.dart`. The batch header (device id, seq range) is authenticated as
  associated data.
- Attachments: encrypted with the same key, stored in a Supabase Storage bucket at
  `<user_id>/<sha256>`; the JSON only carries the hash and size.
- Lost passphrase = the server copy is unreadable. The user still has full local data on every
  device and can export a backup; Settings explains this before enabling sync. No recovery key in v1.

## 6. Accounts and store compliance

- Supabase Auth: email magic link, Sign in with Apple, Google. Sign in with Apple is mandatory on
  iOS the moment another third-party login exists.
- **In-app account deletion** (App Store 5.1.1(v)): Settings → Sync → Delete sync account calls an
  RPC that deletes `sync_changes`, `sync_devices`, `sync_keys`, the storage folder and the auth user.
  Local data is untouched.
- Privacy policy: new section "Sync (optional)" listing what the server stores (email, device ids,
  timestamps, ciphertext), that the developer cannot read ledger content, the processor (Supabase,
  region chosen by the owner, EU recommended), retention, and deletion. App Privacy label becomes
  "Data linked to you: contact info (email)"; ledger content stays "not collected" because it is
  ciphertext, but this wording must be checked against Apple's current guidance at submission time.
- Monetisation: sync is the Pro subscription (`in_app_purchase`, no third-party SDK). Free tier keeps
  everything local. Entitlement is checked client-side and enforced server-side by a `sync_enabled`
  flag set from receipt validation (Edge Function).

## 7. Client architecture

```
lib/data/sync/
  hlc.dart              // hybrid logical clock
  change_log.dart       // write/read db_changes, payload codecs (reuse backup JSON codecs)
  sync_crypto.dart      // key wrap/unwrap, batch seal/open
  sync_client.dart      // HTTP to Supabase (supabase_flutter or plain http + PostgREST)
  sync_service.dart     // push/pull loop, triggers, status ValueNotifier
  remote_apply.dart     // conflict policy, applies to PlatrareDatabase in one transaction
```

`PlatrareDatabase` gains `applyRemote(List<Change>)`; `DataRepository` is unchanged for callers.
Screens read `syncStatus` (idle / syncing / error / off) for a Settings row and a small indicator.

## 8. Test plan (all runnable in `flutter test`, no server)

- HLC monotonicity across clock skew.
- Change log: every repository write appends exactly the expected change inside the same transaction
  (extend `data_repository_test.dart`).
- Two in-memory databases (already supported by `PlatrareDatabase.useForTesting`) exchanging change
  logs in both orders converge to identical rows and identical `replayBalances`.
- Conflict cases: concurrent edit vs delete, concurrent account renames, duplicate category names,
  restore-on-one-device.
- Crypto: seal/open round trip, wrong passphrase, tampered associated data.
- Fake `SyncClient` for the service loop: retries, idempotent push, paging.

## 9. Order of work and estimates (solo)

| Step | Estimate | Blocked by |
|---|---|---|
| Schema v5 migration + opening-row backfill + tests | 1 week | owner device pass on the current branch |
| Change log written by every repository write | 3 days | v5 |
| Balances derived on startup (Phase 3 step 3 completion) | 2 days | backfill |
| Local two-database convergence engine + conflict tests | 2 weeks | change log |
| Crypto layer | 3 days | – |
| Supabase project, tables, RLS, auth, deletion RPC | 1 week | owner creates the project |
| SyncService loop, Settings UI, status indicator | 1.5 weeks | all above |
| Attachments upload/download | 1 week | storage bucket |
| Privacy policy + 20 translations, App Privacy label, IAP entitlement | 1 week | product copy from owner |
| macOS / Windows targets re-added | 2 weeks | sync working |

Total: roughly one quarter, matching the audit's estimate.

## 10. Owner decisions still open

1. Supabase region (EU recommended for GDPR simplicity) and project name.
2. Passphrase model as above, or a device-to-device key transfer (QR) in v1.
3. Pro price points for the subscription and whether a lifetime unlock exists.
4. Whether preferences (base currency) should sync in v1 (this design says no).
