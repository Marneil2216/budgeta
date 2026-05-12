import '../models/variable_expense.dart';

abstract class VariableExpensesRepository {
  Stream<List<VariableExpense>> watchVariableExpenses(String userId, DateTime month);
  Future<void> add(VariableExpense expense);
  Future<void> update(String id, Map<String, dynamic> data);
  Future<void> delete(String id);
}
