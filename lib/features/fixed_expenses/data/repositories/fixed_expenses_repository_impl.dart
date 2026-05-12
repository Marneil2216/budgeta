import '../../domain/models/fixed_expense.dart';
import '../../domain/repositories/fixed_expenses_repository.dart';
import '../datasources/fixed_expenses_remote_datasource.dart';

class FixedExpensesRepositoryImpl implements FixedExpensesRepository {
  const FixedExpensesRepositoryImpl(this._datasource);

  final FixedExpensesRemoteDatasource _datasource;

  @override
  Stream<List<FixedExpense>> watchFixedExpenses(String userId) =>
      _datasource.watchFixedExpenses(userId);

  @override
  Future<void> add(FixedExpense expense) => _datasource.add(expense);

  @override
  Future<void> update(String id, Map<String, dynamic> data) =>
      _datasource.update(id, data);

  @override
  Future<void> delete(String id) => _datasource.delete(id);
}
