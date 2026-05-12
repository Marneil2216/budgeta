---
name: supabase-datasource
description: Scaffold a Supabase datasource following Budgeta data layer conventions
model: claude-sonnet-4-5
---

## When to use
- Adding CRUD operations for a new feature
- Adding real-time stream for a table
- Updating an existing datasource with a new query

## Single row fetch (nullable)
```dart
Future<UserProfile?> getProfile(String userId) async {
  final response = await _client
      .from('user_profiles')
      .select()
      .eq('id', userId)
      .maybeSingle();
  if (response == null) return null;
  return UserProfile.fromMap(response);
}
```

## Real-time stream
```dart
Stream<List<FixedExpense>> watchFixedExpenses(String userId) {
  return _client
      .from('fixed_expenses')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .order('due_day')
      .map((rows) => rows.map(FixedExpense.fromMap).toList());
}
```

## Insert
```dart
Future<void> add(FixedExpense expense) async {
  await _client.from('fixed_expenses').insert(expense.toInsertMap());
}
```

## Update
```dart
Future<void> update(String id, Map<String, dynamic> data) async {
  await _client.from('fixed_expenses').update(data).eq('id', id);
}
```

## Delete
```dart
Future<void> delete(String id) async {
  await _client.from('fixed_expenses').delete().eq('id', id);
}
```

## Date-filtered stream (client-side, variable_expenses pattern)
```dart
Stream<List<VariableExpense>> watchVariableExpenses(String userId, DateTime month) {
  final startDate = DateTime(month.year, month.month, 1).toIso8601String().split('T').first;
  final endDate = DateTime(month.year, month.month + 1, 0).toIso8601String().split('T').first;
  return _client
      .from('variable_expenses')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .order('expense_date', ascending: false)
      .map((rows) => rows
          .map(VariableExpense.fromMap)
          .where((e) {
            final d = e.expenseDate.toIso8601String().split('T').first;
            return d.compareTo(startDate) >= 0 && d.compareTo(endDate) <= 0;
          })
          .toList());
}
```

## File placement
- `lib/features/<name>/data/datasources/<name>_remote_datasource.dart`
