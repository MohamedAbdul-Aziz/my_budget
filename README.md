# My Budget

An offline personal expense tracker built with Flutter. Everything is stored in
a local SQLite database on the device — no account, no backend, no network
calls anywhere in the codebase.

## What it does

- **Home** — the current month's total, a category breakdown bar, and the
  month's expenses grouped by day. Swipe a row to delete it, with undo.
- **Add expense** — amount, category, date and an optional note. The amount
  field is focused on open, a category is preselected and the date defaults to
  today, so the fast path is: type a number, tap Add.
- **Categories** — eight built-in categories, plus your own with a custom icon
  and color. Deleting a category moves its expenses to *Other* instead of
  deleting them.
- **Months** — every month with spending is listed with its total; tap the
  month name in the app bar to switch.
- **Budgets** — an optional monthly limit and optional per-category limits,
  repeating every month. The home screen card shows what is left, with a bar
  that turns from green to orange at 70% and red past 90%. Logging an expense
  that passes 80% or 100% of a limit shows a warning right away. Limits are
  stored as `budget.*` rows in the `settings` table, so they travel with the
  cloud backup and backup files without any schema change.
- **Recurring payments** — rent, bills and subscriptions, each with an
  amount, a category and a schedule: weekly on a weekday, monthly on a day
  (the 31st falls on the last day of shorter months), or yearly on a date.
  Each one either **auto-deducts** (the app logs it as an expense on its due
  date, catching up on any missed while the app was closed) or **reminds**
  (the home screen asks you to confirm it once it is due). The recurring page
  (the repeat icon on the home screen) shows each one as *Paid*, *Upcoming*
  or *Overdue* for the current period, what they cost in an average month,
  and a **Mark as paid** button that logs the payment into this month's
  transactions, with undo. A payment gets the same transaction id on every
  phone, so syncing never counts it twice. Needs the
  `supabase/migrations/20260930150000_recurring_expenses.sql` migration for
  cloud backup.
- **People & debts** — the People tab lists everyone you share costs with
  and where you stand: green when they owe you, red when you owe them, grey
  when settled, filterable by *All*, *Owed to me*, *I owe* and *Settled*.
  Each person's ledger shows the net balance (what you paid for them minus
  what they paid for you, over open transactions), the active transactions,
  and the settled history grouped by settle-up. **Settle up** shows the exact
  amount to clear, moves every open transaction into the history, then asks
  whether to log the money in your monthly budget (as income in *Other
  income*, or an expense in *Other*). Every transaction keeps an audit trail:
  when it was created, last edited and settled, and a change log of the
  values each edit replaced. Settled transactions are locked. People travel
  with the cloud backup, backup files (format 4) and the CSV/PDF exports;
  needs the `supabase/migrations/20260930180000_people_and_debts.sql`
  migration for cloud backup.
- **Settings** — light/dark/system theme, the language, and the currency
  symbol. The app is translated into 20 languages (English, Arabic, Chinese,
  Spanish, French, Portuguese, Russian, German, Japanese, Korean, Turkish,
  Indonesian, Italian, Persian, Urdu, Vietnamese, Polish, Dutch, Ukrainian and
  Malay), with full right-to-left layout for Arabic, Persian and Urdu. The
  picker offers the device setting, English and the phone's own language.
  PDF reports embed their fonts, so Chinese, Japanese and Korean reports are
  written in English rather than bundling multi-megabyte fonts; the app
  itself and CSV exports stay in those languages.
- **Quick Expense widget (Android)** — a home screen widget showing this
  month's total and shortcuts to the categories you use most.

## The Android home screen widget

An Android app widget cannot host a text field — `RemoteViews` has no
`EditText` — so the widget collects the part it can and hands off the rest:

1. Tap a category on the widget (or the Add button).
2. `QuickAddActivity` opens: a transparent, dialog-style window showing only
   the amount card, with the tapped category already selected and the keyboard
   up. The app's home screen is never built.
3. Type the amount, tap Add. The date is today and the note is skipped.
4. The widget redraws and the dialog closes, returning to the home screen.

The widget's `PendingIntent` targets `QuickAddActivity`, never `MainActivity`,
so a tap never turns into "launch the app". The activity runs the app's own
Dart code on its own Flutter engine, booted onto the `/quick-add?category=…`
route — which keeps the local SQLite database the single source of truth. No
expense is ever written from Kotlin.

Everything the widget draws — the title, the month, the total, the category
names — is rendered by the app as JSON and stored for the widget to read, so
it always matches the language and currency chosen in the app, including
Arabic. The widget itself has no access to the app's localizations or
formatters.

| Piece | Where |
| --- | --- |
| Widget layout, drawables, colors, dialog theme | `android/app/src/main/res/` |
| `RemoteViews` rendering and click intents | `QuickExpenseWidgetProvider.kt` |
| The widget's entry point | `QuickAddActivity.kt` |
| The publish channel, shared by both activities | `QuickExpenseChannel.kt` |
| Route parsing and the quick-add UI | `features/quick_expense/presentation/` |
| Ranking, snapshot, publish | `features/quick_expense/domain/` |
| Dart side of the channel | `features/quick_expense/data/` |


## Architecture

Feature-first clean architecture, following [CLAUDE.md](CLAUDE.md):

```
lib/
  core/            database, DI, errors, theme, localization, formatters
  features/
    expenses/      data · domain · presentation
    categories/    data · domain · presentation
    budgets/       data · domain · presentation
    recurring/     data · domain · presentation
    people/        data · domain · presentation
    settings/      data · domain · presentation
    quick_expense/ data · domain · presentation
```

- **State** — Cubit/Bloc with `sealed` state classes and exhaustive `switch`.
  Cubits depend only on use cases.
- **No code generation** — no Freezed, no build_runner, no `flutter gen-l10n`.
  Dart 3 sealed classes, pattern matching and records instead; localization is
  a hand-written `AppStrings` delegate.
- **Domain purity** — nothing under any `domain/` imports Flutter.
- **Errors** — the data layer maps exceptions to typed `Failure`s carrying a
  `FailureCode`; use cases return `ApiResult<T>`; the presentation layer turns
  a code into a translated sentence.
- **DI** — `get_it`, wired in `core/di/injection.dart`.

## Running

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```

- `test/domain` — month arithmetic, totals and breakdown, validation rules.
- `test/core` — number and date formatting in English and Arabic.
- `test/data` — the real SQLite schema against an in-memory database.
- `test/presentation` — the app booted over in-memory repositories, including
  the add-expense flow, the Arabic/RTL switch, every language on a small
  phone, the home screen widget's contents, and the quick-add dialog the
  widget opens.
