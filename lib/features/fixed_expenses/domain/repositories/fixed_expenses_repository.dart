import '../models/fixed_expense.dart';

abstract class FixedExpensesRepository {
  Stream<List<FixedExpense>> watchFixedExpenses(String userId);
  Future<void> add(FixedExpense expense);
  Future<void> update(String id, Map<String, dynamic> data);
  Future<void> delete(String id);
}
