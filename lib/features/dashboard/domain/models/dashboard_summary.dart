import '../../../../core/utils/date_utils.dart';
import '../../../fixed_expenses/domain/models/fixed_expense.dart';

class DashboardSummary {
  const DashboardSummary._({
    required this.monthlyBudget,
    required this.currency,
    required this.totalFixedExpenses,
    required this.totalVariableExpenses,
    required this.totalExpenses,
    required this.remainingBalance,
    required this.dailyBudget,
    required this.isOverspent,
    required this.daysLeftInMonth,
    required this.upcomingBills,
  });

  final double monthlyBudget;
  final String currency;
  final double totalFixedExpenses;
  final double totalVariableExpenses;
  final double totalExpenses;
  final double remainingBalance;
  final double dailyBudget;
  final bool isOverspent;
  final int daysLeftInMonth;
  final List<FixedExpense> upcomingBills;

  factory DashboardSummary.compute({
    required double monthlyBudget,
    required String currency,
    required double totalFixed,
    required double totalVariable,
    required int daysLeft,
    required List<FixedExpense> allFixedExpenses,
  }) {
    final total = totalFixed + totalVariable;
    final remaining = monthlyBudget - total;
    final daily = remaining > 0 ? remaining / daysLeft : 0.0;
    final upcoming = allFixedExpenses
        .map((e) => MapEntry(e, BudgetDateUtils.daysUntilDue(e.dueDay)))
        .where((entry) => entry.value <= 14)
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return DashboardSummary._(
      monthlyBudget: monthlyBudget,
      currency: currency,
      totalFixedExpenses: totalFixed,
      totalVariableExpenses: totalVariable,
      totalExpenses: total,
      remainingBalance: remaining,
      dailyBudget: daily,
      isOverspent: remaining < 0,
      daysLeftInMonth: daysLeft,
      upcomingBills: upcoming.map((e) => e.key).toList(),
    );
  }
}
