import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/fixed_expenses_provider.dart';
import '../widgets/fixed_expense_tile.dart';

class FixedExpensesListScreen extends ConsumerWidget {
  const FixedExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(fixedExpensesStreamProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final currency = profileAsync.valueOrNull?.currency ?? 'PHP';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Bills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push('/app/fixed-expenses/add'),
          ),
        ],
      ),
      body: expensesAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (expenses) {
          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.shadowDark),
                  const SizedBox(height: AppSpacing.md),
                  const Text('No fixed bills yet', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/app/fixed-expenses/add'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Fixed Bill'),
                  ),
                ],
              ),
            );
          }

          final total = expenses.where((e) => e.isActive).fold(0.0, (sum, e) => sum + e.amount);

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${expenses.length} bill(s)', style: const TextStyle(color: AppColors.textSecondary)),
                    Text(
                      'Total: ${CurrencyFormatter.format(total, currency)}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.deepGreen),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: expenses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return FixedExpenseTile(
                      expense: expense,
                      currency: currency,
                      onToggleActive: (active) => ref
                          .read(fixedExpensesNotifierProvider.notifier)
                          .toggleActive(expense.id, active),
                      onEdit: () => context.push('/app/fixed-expenses/${expense.id}/edit'),
                      onDelete: () => _confirmDelete(context, ref, expense.id, expense.name),
                    ).animate(delay: Duration(milliseconds: index * 50)).fadeIn().slideX(begin: 0.05);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/app/fixed-expenses/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Fixed Bill'),
        content: Text('Remove "$name"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(fixedExpensesNotifierProvider.notifier).delete(id);
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
