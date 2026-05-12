# Budgeta — Stack

**Project:** Budgeta
**Purpose:** Mobile/desktop budget tracking app. Users input salary, track fixed and variable expenses, and see remaining balance + daily budget in real time.
**Language:** Dart 3.5.3
**Framework:** Flutter (multi-platform: Android, iOS, Web, Windows)
**State Management:** Riverpod 2.6.1 (with riverpod_annotation + build_runner for codegen)
**Navigation:** go_router 14.x (ShellRoute for bottom nav)
**Backend:** Supabase (auth, PostgreSQL, real-time streams)
**Animations:** flutter_animate 4.5.x
**Formatting:** intl 0.19 (currency)

## Build / Run / Test
```
# Install deps
flutter pub get

# Generate Riverpod .g.dart files (required after any @riverpod change)
dart run build_runner build --delete-conflicting-outputs

# Analyze
flutter analyze

# Run (web)
flutter run -d chrome --dart-define=SUPABASE_URL=<url> --dart-define=SUPABASE_ANON_KEY=<key>

# Run (Windows)
flutter run -d windows --dart-define=SUPABASE_URL=<url> --dart-define=SUPABASE_ANON_KEY=<key>

# Test
flutter test
```

## Supabase Config
Supabase credentials are passed via `--dart-define` at run time (not stored in source).
Tables: `user_profiles`, `fixed_expenses`, `variable_expenses`
Migrations: `supabase/migrations/001_initial_schema.sql`, `002_rls_policies.sql`, `003_triggers.sql`

## Architecture
Feature-based clean architecture: each feature has `data/`, `domain/`, `presentation/` layers.
`dashboardSummaryProvider` is a pure synchronous derived provider — no async, computes from three upstream StreamProviders.
Router redirect logic enforces: unauthenticated → login, salary==null → salary setup, else dashboard.
