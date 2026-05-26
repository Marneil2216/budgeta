import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/variable_expenses_provider.dart';
import '../widgets/variable_expense_tile.dart';

class VariableExpensesListScreen extends ConsumerWidget {
  const VariableExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(variableExpensesStreamProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final currency = profileAsync.valueOrNull?.currency ?? 'PHP';
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push('/app/expenses/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          _MonthSelector(selected: selectedMonth, now: now),
          Expanded(
            child: expensesAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (expenses) {
                if (expenses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.shadowDark),
                        const SizedBox(height: AppSpacing.md),
                        const Text('No expenses yet', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                        const SizedBox(height: AppSpacing.md),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/app/expenses/add'),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Expense'),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
                final grouped = <String, List<_ExpenseItem>>{};
                for (var i = 0; i < expenses.length; i++) {
                  final e = expenses[i];
                  final key = DateFormat('yyyy-MM-dd').format(e.expenseDate);
                  grouped.putIfAbsent(key, () => []);
                  grouped[key]!.add(_ExpenseItem(expense: e, index: i));
                }
                final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${expenses.length} expense(s)', style: const TextStyle(color: AppColors.textSecondary)),
                          Text(
                            'Total: ${CurrencyFormatter.format(total, currency)}',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.errorRed),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: sortedKeys.length,
                        itemBuilder: (context, keyIndex) {
                          final key = sortedKeys[keyIndex];
                          final items = grouped[key]!;
                          final date = DateTime.parse(key);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                                color: AppColors.surfaceBase.withOpacity(0.5),
                                width: double.infinity,
                                child: Text(
                                  date.isSameDay(now) ? 'Today' : DateFormat('MMMM d, yyyy').format(date),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              ...items.map((item) => VariableExpenseTile(
                                    expense: item.expense,
                                    currency: currency,
                                    onEdit: () => context.push('/app/expenses/${item.expense.id}/edit'),
                                    onDelete: () => _confirmDelete(context, ref, item.expense.id, item.expense.name),
                                  ).animate(delay: Duration(milliseconds: item.index * 40)).fadeIn().slideX(begin: 0.05)),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/app/expenses/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Remove "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(variableExpensesNotifierProvider.notifier).delete(id);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ExpenseItem {
  const _ExpenseItem({required this.expense, required this.index});
  final dynamic expense;
  final int index;
}

class _MonthSelector extends ConsumerWidget {
  const _MonthSelector({required this.selected, required this.now});

  final DateTime selected;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () {
              final prev = DateTime(selected.year, selected.month - 1);
              ref.read(selectedMonthProvider.notifier).setMonth(prev);
            },
          ),
          Text(
            '${selected.monthName} ${selected.year}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: selected.isSameMonth(now) ? null : () {
              final next = DateTime(selected.year, selected.month + 1);
              ref.read(selectedMonthProvider.notifier).setMonth(next);
            },
          ),
        ],
      ),
    );
  }
}
