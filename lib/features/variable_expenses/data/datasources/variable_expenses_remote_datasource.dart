import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/variable_expense.dart';

class VariableExpensesRemoteDatasource {
  const VariableExpensesRemoteDatasource(this._client);

  final SupabaseClient _client;

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
              final dateStr = e.expenseDate.toIso8601String().split('T').first;
              return dateStr.compareTo(startDate) >= 0 && dateStr.compareTo(endDate) <= 0;
            })
            .toList());
  }

  Future<void> add(VariableExpense expense) async {
    await _client.from('variable_expenses').insert(expense.toInsertMap());
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    await _client.from('variable_expenses').update(data).eq('id', id);
  }

  Future<void> delete(String id) async {
    await _client.from('variable_expenses').delete().eq('id', id);
  }
}
