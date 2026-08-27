# CLAUDE.md

Architecture and coding rules for this Flutter project.

## 1) State Management
- Use **Cubit/Bloc** for feature and application state — not Riverpod, Provider, or GetX
- Cubits depend ONLY on use cases — never directly on repositories or data sources
- `setState` is allowed ONLY for local UI state (e.g., toggles, form focus) — never for business logic
- Keep `setState` scoped to the smallest widget possible to avoid redundant rebuilds up the tree

## 2) No Code Generation
- **No Freezed. No build_runner.** Use Dart 3+ native features instead:
  - `sealed class` for state unions with exhaustive pattern matching
  - `switch` expressions and records for lightweight data

## 3) Domain Layer Purity
- Domain layer must have ZERO Flutter imports
- No `package:flutter/...` in any file under `domain/`

## 4) Feature Folder Structure
- `features/{feature_name}/data/`
- `features/{feature_name}/domain/`
- `features/{feature_name}/presentation/`

## 5) Error Handling Contract
- Data layer: catch exceptions and map to typed `Failure` classes
- Domain layer: return `ApiResult<T>` from use cases and repositories
- Presentation layer: map failures to user-friendly messages and UI states

## 6) Dependency Injection
- Use **`get_it`** as the service locator — not `Provider` or constructor-only injection
- Register dependencies in a single `core/di/` setup file
- Cubits, use cases, and repositories are resolved via `get_it`, not instantiated manually

## 7) Build Method Discipline (IMPORTANT)
- Prefer `const` constructors wherever possible
- NEVER create `TextEditingController`, `AnimationController`, `FocusNode`, or other expensive objects inside `build()`
- Avoid heavy work inside `build()` methods
- Dispose controllers and focus nodes in `StatefulWidget.dispose()`
- Prefer small, composed widgets to minimize rebuild scope
- Use `BlocBuilder`/`BlocSelector` on the smallest widget that needs the state — never at the top of the tree
