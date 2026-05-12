import '../../domain/models/variable_expense.dart';
import '../../domain/repositories/variable_expenses_repository.dart';
import '../datasources/variable_expenses_remote_datasource.dart';

class VariableExpensesRepositoryImpl implements VariableExpensesRepository {
  const VariableExpensesRepositoryImpl(this._datasource);

  final VariableExpensesRemoteDatasource _datasource;

  @override
  Stream<List<VariableExpense>> watchVariableExpenses(String userId, DateTime month) =>
      _datasource.watchVariableExpenses(userId, month);

  @override
  Future<void> add(VariableExpense expense) => _datasource.add(expense);

  @override
  Future<void> update(String id, Map<String, dynamic> data) => _datasource.update(id, data);

  @override
  Future<void> delete(String id) => _datasource.delete(id);
}
