# CLAUDE.md

Guide for working on **My Budget**: an offline-first personal expense and income tracker built with Flutter.
Read this first in every new chat. It covers what the app is, where things live, and the rules to follow.

## 0) Project Snapshot
- **Local-first**: all data is stored in one on-device SQLite DB (`sqflite`; `sqflite_common_ffi` on desktop). The app only reads from the local DB.
- **Optional cloud backup**: a signed-in user can back up and restore to Supabase (`features/sync`, `features/auth`). Config lives in `lib/core/config/supabase_config.dart` (publishable key only; never add the service-role key).
- **Languages**: 20 (en, ar, zh, es, fr, pt, ru, de, ja, ko, tr, id, it, fa, ur, vi, pl, nl, uk, ms), with full RTL for ar/fa/ur. The picker offers only *System*, English and the device's own language. Settings cover theme, language, and currency symbol.
- **Android home-screen widget**: Quick Expense (Kotlin in `android/app/src/main/kotlin/com/mohamed/mybudget/`).
- Package name: `my_budget`. Android app id: `com.mohamed.mybudget`. Dart SDK `^3.9.2`.

## 1) Commands
```bash
flutter pub get
flutter run                 # desktop works too (FFI SQLite)
flutter analyze             # must stay clean
flutter test                # all tests
flutter test test/domain/add_expense_test.dart   # single file
./scripts/release_to_drive.sh   # builds the release appbundle and uploads it to Drive
```

## 2) Where Things Live
```
lib/
  main.dart        boot: Supabase.initialize → configureDependencies → open DB → load settings
                   → either QuickAddApp (widget route /quick-add?category=…) or MyBudgetApp
  app.dart         MultiBlocProvider (long-lived cubits via .value) + cross-cubit BlocListeners
  core/
    config/        Supabase URL + publishable key
    database/      app_database.dart (schema + migrations), local_records.dart / portable_records.dart
                   / record_batch.dart (bulk record moves shared by sync and file backups)
    di/injection.dart   the ONLY get_it setup (`sl`)
    error/         api_result.dart (ApiResult/Success/ResultFailure/guard), failures.dart (Failure + FailureCode)
    l10n/           app_strings.dart (abstract AppStrings + delegate), strings/app_strings_<code>.dart
                    (one complete class per language), plural.dart (CLDR plural forms)
    theme/         app_theme, status_colors, transaction_colors
    utils/         amount_input, app_formats (numbers and dates), category_icons, ui_notice
  features/
    expenses/        home screen, add/edit form, month overview and summaries, search across months
                     (HomeCubit, ExpenseFormCubit, SearchCubit per screen)
    categories/      built-in + custom categories, expense or income type (CategoriesCubit)
    budgets/         monthly + per-category limits and alerts (BudgetCubit)
    recurring/       recurring payments and income (type = category type): schedules,
                     Paid/Received/Upcoming/Overdue, auto-deduct/auto-add, mark as paid
                     (RecurringCubit app-wide, RecurringFormCubit per screen)
    people/          People tab, per-person ledger, settle up, audit trail
                     (PeopleCubit app-wide, PersonLedgerCubit per screen)
    analyses/        Analyses tab and charts (AnalysesCubit, domain + presentation only)
    settings/        theme, language, currency (SettingsCubit)
    reminders/       optional daily "log your spending" notification: on/off + time,
                     scheduled with flutter_local_notifications (ReminderCubit)
    auth/            Supabase email sign-up/sign-in, OTP confirm, password reset by code,
                     delete account (AccountCubit)
    app_lock/        optional lock screen (local_auth) at launch and after 1 min away
                     (AppLockCubit + AppLockGate above the navigator)
    sync/            cloud backup and restore (SyncCubit), optional automatic backup on leaving
                     the app (AutoBackupCubit for the switch, AutoBackupBridge for the trigger)
    data_management/ JSON backup, CSV and PDF export, import, share and save files (DataManagementCubit)
    quick_expense/   Android widget data publishing + quick-add dialog
    shell/           AppShell (tabs / navigation)
android/app/src/main/kotlin/.../  MainActivity (a FlutterFragmentActivity, for local_auth), QuickAddActivity,
                                  QuickExpenseWidgetProvider, QuickExpenseChannel
                                  (styles use AppCompat parents: local_auth needs them)
supabase/migrations/   server-side SQL
assets/pdf_fonts/      IBM Plex Sans Arabic for PDF export
test/{core,data,domain,presentation}/
```

## 3) Data Model Essentials
- Tables: `categories`, `expenses`, `settings` (key/value), `recurring_expenses`, and the people tables (`AppDatabase.peopleTables`). `_schemaVersion` is in `app_database.dart` (currently **6**).
- v2 added sync columns: `updated_at` (ms), `deleted_at` (soft delete; every read must skip these rows), `dirty` (1 = not yet synced). Stamp local writes with `AppDatabase.changed(row)`.
- v3 added `categories.type` (`expense` | `income`). A transaction's type is its category's type. The table stays named `expenses` for backup and cloud compatibility (`TransactionType.fromStorageKey`).
- v4 added `recurring_expenses`: a schedule (`frequency` weekly|monthly|yearly, `due_day`, `due_month` for yearly), `mode` (`auto` | `reminder`), and `starts_on` / `paid_through` as `yyyy-MM-dd` text (calendar days, timezone-free). A payment it logs is an ordinary `expenses` row whose id is `<recurringId>_<yyyymmdd>`, so two phones logging the same payment merge into one row. Paying settles the oldest unpaid due date (`paid_through`) in the same SQLite transaction as the expense insert.
- v5 added `people`, `settlements`, `person_transactions` and `person_transaction_edits` (the change log: values *before* each edit). A transaction is open until `settled_at` + `settlement_id` are set; the balance is summed in whole cents over open ones (`DebtBalance`). Settled transactions are locked. Deleting a person soft-deletes everything recorded with them; `LocalRecords` writes these tables parents first, skips orphans, and cascades a person deleted elsewhere. A settlement logged in the budget is an ordinary `expenses` row in Other / Other income, linked by `settlements.expense_id`.
- v6 added `device_settings` (key/value, **phone-only**): preferences that belong to this device (`app_lock`, `auto_backup`). Like `sync_meta`, it is not in `SyncedTables`, so it never syncs, is not in backup files, and a restore/import never touches it. No Data Parity work for it.
- `expenses.month_key` drives monthly queries. Deleting a category moves its transactions and recurring payments to *Other*.
- Budgets are stored as `budget.*` rows in `settings`, so they travel with backups without a schema change. The daily reminder is stored the same way, as `reminder.enabled` / `reminder.time` (`HH:mm`).
- For any schema change, follow the **Data Parity Rule** below.

## 3.1) Data Parity Rule (IMPORTANT)
Data lives in **three places**: the SQLite DB on the phone, the Supabase cloud tables, and the backup file (JSON) plus its exports (CSV/PDF).
**All three must stay in sync.** When a feature adds or changes a table, a column, or a stored value, update every item below in the same change. Never update just one.

| # | What | File |
|---|------|------|
| 1 | Local schema: bump `_schemaVersion`, add an `onUpgrade` step, and update `onCreate` | `lib/core/database/app_database.dart` |
| 2 | Local data source + model (`toMap`/`fromMap`), stamping writes with `AppDatabase.changed(row)` and skipping `deleted_at` rows in reads | `features/<x>/data/` |
| 3 | Portable form (SQLite ⇄ cloud/backup), both directions | `lib/core/database/portable_records.dart` |
| 4 | Bulk read/write shared by sync and import | `lib/core/database/local_records.dart`, `record_batch.dart` |
| 5 | Cloud sync: upload + download (a new table needs its own upsert and read, plus `dirty` handling) | `features/sync/data/datasources/sync_remote_data_source.dart`, `sync_local_data_source.dart` |
| 6 | **Supabase migration**: a new timestamped SQL file (`add column if not exists` / new table + RLS policies on `user_id`). Without it, uploads fail | `supabase/migrations/YYYYMMDDHHMMSS_<name>.sql` |
| 7 | Backup file: add the field or table, and bump `schemaVersion` if the format changed. Older files must still import (give missing fields defaults) | `features/data_management/data/codecs/backup_codec.dart` |
| 8 | CSV and PDF export, if the data is user-visible | `codecs/csv_export.dart`, `codecs/pdf_report.dart`, `models/export_texts.dart` |
| 9 | After a restore or import, reload the cubits that show this data | `_reloadData` in `lib/app.dart` |
| 10 | Tests | `test/data/migration_test.dart`, `sync_test.dart`, `data_management_test.dart`, `local_storage_test.dart` |

- **Backward compatibility is required.** An older app version, older backup file, or older cloud rows may lack the new field, so always read with a safe default (e.g. `TransactionType.fromStorageKey`).
- A simple app preference can often be stored as a row in the `settings` table (like `budget.*`). It then travels with sync and backup with no schema change, and only needs items 2, 9, and 10.
- `dirty` never leaves the phone. The cloud adds its own `user_id`.

## 4) State Management
- Use **Cubit/Bloc** for feature and application state — not Riverpod, Provider, or GetX
- Cubits depend ONLY on use cases — never directly on repositories or data sources
- States are `sealed class … extends Equatable` with `final class` variants (e.g. `XLoading` / `XReady` / `XLoadFailure(FailureCode)`); consume them with exhaustive `switch`
- Shared cubits are `registerLazySingleton` and provided with `BlocProvider.value` in `app.dart`; per-screen cubits (e.g. `ExpenseFormCubit`) use `registerFactory`
- Cross-feature refresh (restore/import → reload, HomeCubit month → Analyses/Budget) is wired with `BlocListener`s in `app.dart`. Add new cross-cubit reactions there, not inside cubits
- One-shot UI events (snackbars) go through `UiNotice` (`core/utils/ui_notice.dart`) with a `NoticeCode`, not strings
- `setState` is allowed ONLY for local UI state (e.g., toggles, form focus) — never for business logic
- Keep `setState` scoped to the smallest widget possible to avoid redundant rebuilds up the tree

## 5) No Code Generation
- **No Freezed. No build_runner. No `flutter gen-l10n`.** Use Dart 3+ native features instead:
  - `sealed class` for state unions with exhaustive pattern matching
  - `switch` expressions and records for lightweight data
  - `equatable` for value equality

## 6) Domain Layer Purity
- Domain layer must have ZERO Flutter imports
- No `package:flutter/...` in any file under `domain/`
- `core/error/` is pure Dart too, so the domain can import it

## 7) Feature Folder Structure
- `features/{feature_name}/data/` — `datasources/`, `models/`, `repositories/*_impl.dart` (plus `codecs/` where needed)
- `features/{feature_name}/domain/` — `entities/`, `repositories/` (abstract), `usecases/` (one class per file, callable via `call(...)`)
- `features/{feature_name}/presentation/` — `cubit/` (`x_cubit.dart` + `x_state.dart`), `pages/`, `widgets/`

## 8) Error Handling Contract
- Data layer: catch exceptions and map to typed `Failure` classes (`DatabaseFailure`, `NetworkFailure`, `AuthFailure`, `SyncFailure`, `FileFailure`, `ValidationFailure`, …). `ApiResult.guard(() async {...})` is the usual wrapper
- Domain layer: return `ApiResult<T>` from use cases and repositories. Input validation lives in use cases (e.g. `AddExpense.validate`) and returns `ValidationFailure(FailureCode.x)`
- Presentation layer: map failures to user-friendly messages and UI states
- **No user-facing text in data or domain.** Failures carry a `FailureCode`; `debugMessage` is for developers only
- New failure: add a `FailureCode` value, then add its message in **every** file under `core/l10n/strings/` (the `switch` is exhaustive, so the analyzer flags any missing case)

## 9) Localization
- All UI text goes through `context.strings.x` (`AppStrings`). Never hard-code UI strings
- Adding a string: declare the abstract getter/method in `AppStrings`, then implement it in **all 20** classes under `core/l10n/strings/` (the analyzer rejects a missing one). Keep button and tab labels short: `test/presentation/languages_test.dart` fails on any overflow on a 360-wide phone
- Counts go through `plural()` (`core/l10n/plural.dart`) so Russian/Polish/Ukrainian get their `few`/`many` forms; languages without plurals (zh, ja, ko, tr, id, ms, vi, fa) just use `'$count …'`
- Adding a language: a new `AppLanguage` value (stored by name, so never rename one) + a `strings/` class + a case in `AppStrings.forLanguageCode`. If its script needs a font the PDF report does not bundle, `ReportFontsDataSourceImpl.supports` leaves it out and the PDF falls back to English
- Numbers and dates are formatted with `core/utils/app_formats.dart` using the active locale. Test Arabic RTL (see `test/presentation/arabic_test.dart`) and every language on a small phone (`languages_test.dart`)
- Use directional-aware widgets and padding (`EdgeInsetsDirectional`, `start`/`end`) for RTL

## 10) Dependency Injection
- Use **`get_it`** (`sl`) as the service locator — not `Provider` or constructor-only injection
- Register everything in `lib/core/di/injection.dart`, in one `_registerFeature()` function per feature
- Register repositories with `_registerRepository<T>(...)`. It skips types that are already registered, which is how tests swap in fakes
- Cubits, use cases, and repositories are resolved via `get_it`, not instantiated manually

## 11) Build Method Discipline (IMPORTANT)
- Prefer `const` constructors wherever possible
- NEVER create `TextEditingController`, `AnimationController`, `FocusNode`, or other expensive objects inside `build()`
- Avoid heavy work inside `build()` methods
- Dispose controllers and focus nodes in `StatefulWidget.dispose()`
- Prefer small, composed widgets to minimize rebuild scope
- Use `BlocBuilder`/`BlocSelector` on the smallest widget that needs the state — never at the top of the tree

## 12) Quick Expense Android Widget
- `RemoteViews` cannot host a text field, so a widget tap opens `QuickAddActivity` (a transparent dialog), which boots its own Flutter engine on `/quick-add?category=<id>` (`QuickAddLaunch.tryParse`)
- **Kotlin never writes expenses.** Dart saves to SQLite, then publishes a JSON snapshot (already localized and formatted) over the `QuickExpenseChannel` method channel for the widget to draw
- `QuickExpenseBridge` / `QuickExpenseWidgetSync` republish the snapshot when data, language, or currency change

## 13) Testing
- `test/domain` — use cases (pure Dart). `test/data` — real SQLite schema against an in-memory DB (`AppDatabase(inMemory: true)`)
- `test/presentation` — the full app booted over in-memory fakes via `app_harness.dart` + `fakes.dart`. Add a fake there when adding a new repository
- `configureDependencies(database: ...)` accepts a test DB. Register fakes **before** calling it
- Add or update tests with every feature change, and run `flutter analyze && flutter test` before finishing

## 14) Adding a New Feature (Recipe)
1. `domain/`: entity → abstract repository → use cases returning `ApiResult<T>`
2. `data/`: data source (SQLite via `AppDatabase`) → model with map conversion → `RepositoryImpl` that maps exceptions to `Failure`s
3. `presentation/`: sealed state + cubit (use cases only) → pages and widgets
4. Register it in `core/di/injection.dart`. If the cubit is app-wide, provide it in `app.dart`
5. Add strings to every language in `core/l10n/strings/`, plus any new `FailureCode` messages
6. Tests, including a fake repository in `test/presentation/fakes.dart`
7. If the feature stores data, apply the full **Data Parity Rule (§3.1)**: local DB, Supabase migration + sync, backup file, and exports, all updated together

## 15) Style
- Match the surrounding code: doc comments (`///`) explain *why*, and cascades (`sl..register…`) are used in DI
- Prefer relative imports inside `lib/` (as in existing files)
- Keep README.md in sync when user-facing behavior changes
