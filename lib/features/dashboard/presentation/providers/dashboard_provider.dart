import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../fixed_expenses/presentation/providers/fixed_expenses_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../variable_expenses/presentation/providers/variable_expenses_provider.dart';
import '../../domain/models/dashboard_summary.dart';

part 'dashboard_provider.g.dart';

@riverpod
DashboardSummary? dashboardSummary(Ref ref) {
  final profileAsync = ref.watch(userProfileProvider);
  final fixedAsync = ref.watch(fixedExpensesStreamProvider);
  final variableAsync = ref.watch(variableExpensesStreamProvider);

  final profile = profileAsync.valueOrNull;
  if (profile == null || profile.monthlyBudget == null) return null;

  final fixedExpenses = fixedAsync.valueOrNull ?? [];
  final variableExpenses = variableAsync.valueOrNull ?? [];

  final totalFixed = fixedExpenses
      .where((e) => e.isActive)
      .fold(0.0, (sum, e) => sum + e.amount);
  final totalVariable = variableExpenses.fold(0.0, (sum, e) => sum + e.amount);
  final daysLeft = BudgetDateUtils.daysLeftInMonth(DateTime.now());

  return DashboardSummary.compute(
    monthlyBudget: profile.monthlyBudget!,
    currency: profile.currency,
    totalFixed: totalFixed,
    totalVariable: totalVariable,
    daysLeft: daysLeft,
    allFixedExpenses: fixedExpenses.where((e) => e.isActive).toList(),
  );
}
