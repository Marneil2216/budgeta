# Budgeta

Flutter + Supabase budget tracking app. Multi-platform (Android, iOS, Web, Windows).

## Stack
- Flutter / Dart 3.5.3
- Riverpod 2.6.1 (codegen via build_runner)
- go_router (ShellRoute bottom nav)
- Supabase (auth + Postgres + real-time)
- flutter_animate

## Commands
```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter run -d chrome --dart-define=SUPABASE_URL=<url> --dart-define=SUPABASE_ANON_KEY=<key>
flutter test
```

## Conventions
- Feature folders: `lib/features/<name>/data|domain|presentation/`
- Providers use `@riverpod` annotation — must run build_runner after changes
- Color tokens in `lib/core/constants/app_colors.dart`
- Neumorphic styles in `lib/core/theme/neumorphism_theme.dart`
- Currency formatting via `CurrencyFormatter.format(amount, currency)`
- No `withValues()` — use `withOpacity()` (Dart 3.5.3 / Flutter < 3.27)
- Supabase credentials via `--dart-define` only, never in source

## Key Formulas
- Remaining Balance = salary - activeFixedExpenses - variableExpenses(this month)
- Daily Budget = remainingBalance > 0 ? remainingBalance / daysLeft : 0.0

## Schema
Tables: `user_profiles` (id, email, full_name, monthly_salary, currency)
        `fixed_expenses` (id, user_id, name, amount, category, due_day, is_active)
        `variable_expenses` (id, user_id, name, amount, category, expense_date, note)
RLS enabled on all tables. Trigger auto-creates `user_profiles` on auth signup.
