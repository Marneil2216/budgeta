import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/fixed_expenses_remote_datasource.dart';
import '../../data/repositories/fixed_expenses_repository_impl.dart';
import '../../domain/models/fixed_expense.dart';
import '../../domain/repositories/fixed_expenses_repository.dart';

part 'fixed_expenses_provider.g.dart';

@riverpod
FixedExpensesRepository fixedExpensesRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return FixedExpensesRepositoryImpl(FixedExpensesRemoteDatasource(client));
}

@riverpod
Stream<List<FixedExpense>> fixedExpensesStream(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return ref.watch(fixedExpensesRepositoryProvider).watchFixedExpenses(user.id);
}

@riverpod
class FixedExpensesNotifier extends _$FixedExpensesNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> add(FixedExpense expense) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(fixedExpensesRepositoryProvider).add(expense),
    );
  }

  Future<void> toggleActive(String id, bool isActive) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(fixedExpensesRepositoryProvider).update(id, {'is_active': isActive}),
    );
  }

  Future<void> updateExpense(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(fixedExpensesRepositoryProvider).update(id, data),
    );
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(fixedExpensesRepositoryProvider).delete(id),
    );
  }
}
