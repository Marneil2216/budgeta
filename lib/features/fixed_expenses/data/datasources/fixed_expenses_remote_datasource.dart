import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/fixed_expense.dart';

class FixedExpensesRemoteDatasource {
  const FixedExpensesRemoteDatasource(this._client);

  final SupabaseClient _client;

  Stream<List<FixedExpense>> watchFixedExpenses(String userId) {
    return _client
        .from('fixed_expenses')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('due_day')
        .map((rows) => rows.map(FixedExpense.fromMap).toList());
  }

  Future<void> add(FixedExpense expense) async {
    await _client.from('fixed_expenses').insert(expense.toInsertMap());
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _client.from('fixed_expenses').update(data).eq('id', id);
  }

  Future<void> delete(String id) async {
    await _client.from('fixed_expenses').delete().eq('id', id);
  }
}
