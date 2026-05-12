---
name: riverpod-provider
description: Scaffold a new @riverpod provider (function, stream, or notifier) following Budgeta conventions
model: claude-sonnet-4-5
---

## When to use
- Adding a new repository provider
- Adding a stream provider for real-time data
- Adding an AsyncNotifier for mutations

## Function provider (repository/datasource)
```dart
@riverpod
FixedExpensesRepository fixedExpensesRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return FixedExpensesRepositoryImpl(FixedExpensesRemoteDatasource(client));
}
```

## Stream provider (real-time list)
```dart
@riverpod
Stream<List<FixedExpense>> fixedExpensesStream(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return ref.watch(fixedExpensesRepositoryProvider).watchFixedExpenses(user.id);
}
```

## AsyncNotifier (mutations)
```dart
@riverpod
class FixedExpensesNotifier extends _$FixedExpensesNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> add(FixedExpense expense) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(fixedExpensesRepositoryProvider).add(expense);
    });
  }
}
```

## After writing any provider
```
dart run build_runner build --delete-conflicting-outputs
```

## File placement
- File: `lib/features/<name>/presentation/providers/<name>_provider.dart`
- Generated: `lib/features/<name>/presentation/providers/<name>_provider.g.dart` (auto)
