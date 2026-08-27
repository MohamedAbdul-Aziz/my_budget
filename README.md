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

## Architecture

Feature-first clean architecture, following [CLAUDE.md](CLAUDE.md):

```
lib/
  core/            database, DI, errors, theme, localization, formatters
  features/
    expenses/      data · domain · presentation
    categories/    data · domain · presentation
    settings/      data · domain · presentation
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
  the add-expense flow and the Arabic/RTL switch.
