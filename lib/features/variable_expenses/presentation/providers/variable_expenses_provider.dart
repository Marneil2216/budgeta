import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/variable_expenses_remote_datasource.dart';
import '../../data/repositories/variable_expenses_repository_impl.dart';
import '../../domain/models/variable_expense.dart';
import '../../domain/repositories/variable_expenses_repository.dart';

part 'variable_expenses_provider.g.dart';

@riverpod
VariableExpensesRepository variableExpensesRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return VariableExpensesRepositoryImpl(VariableExpensesRemoteDatasource(client));
}

@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() => DateTime.now();

  void setMonth(DateTime month) => state = month;
}

@riverpod
Stream<List<VariableExpense>> variableExpensesStream(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  final month = ref.watch(selectedMonthProvider);
  return ref.watch(variableExpensesRepositoryProvider).watchVariableExpenses(user.id, month);
}

@riverpod
class VariableExpensesNotifier extends _$VariableExpensesNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> add(VariableExpense expense) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(variableExpensesRepositoryProvider).add(expense),
    );
  }

  Future<void> updateExpense(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(variableExpensesRepositoryProvider).update(id, data),
    );
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(variableExpensesRepositoryProvider).delete(id),
    );
  }
}
