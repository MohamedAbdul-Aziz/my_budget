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
- **Settings** — light/dark/system theme, English or Arabic (with full RTL),
  and the currency symbol.
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
- `test/core` — number and date formatting in both languages.
- `test/data` — the real SQLite schema against an in-memory database.
- `test/presentation` — the app booted over in-memory repositories, including
  the add-expense flow, the Arabic/RTL switch, the home screen widget's
  contents, and the quick-add dialog the widget opens.
