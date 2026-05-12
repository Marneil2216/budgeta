import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/models/fixed_expense.dart';

class FixedExpenseTile extends StatelessWidget {
  const FixedExpenseTile({
    super.key,
    required this.expense,
    required this.currency,
    required this.onToggleActive,
    required this.onEdit,
    required this.onDelete,
  });

  final FixedExpense expense;
  final String currency;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const _categoryIcons = <String, IconData>{
    'rent': Icons.home_outlined,
    'utilities': Icons.bolt_outlined,
    'insurance': Icons.shield_outlined,
    'subscription': Icons.subscriptions_outlined,
    'loan': Icons.account_balance_outlined,
    'transport': Icons.directions_car_outlined,
    'food': Icons.restaurant_outlined,
    'education': Icons.school_outlined,
    'health': Icons.local_hospital_outlined,
    'other': Icons.receipt_outlined,
  };

  static const _categoryColors = <String, Color>{
    'rent': Color(0xFF1E7F5C),
    'utilities': Color(0xFFFFA726),
    'insurance': Color(0xFF42A5F5),
    'subscription': Color(0xFFAB47BC),
    'loan': Color(0xFFEF5350),
    'transport': Color(0xFF26A69A),
    'food': Color(0xFF66BB6A),
    'education': Color(0xFF5C6BC0),
    'health': Color(0xFFEC407A),
    'other': Color(0xFF78909C),
  };

  @override
  Widget build(BuildContext context) {
    final icon = _categoryIcons[expense.category] ?? Icons.receipt_outlined;
    final color = _categoryColors[expense.category] ?? AppColors.textSecondary;

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.errorRed,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Opacity(
        opacity: expense.isActive ? 1.0 : 0.5,
        child: ListTile(
          onTap: onEdit,
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            expense.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          subtitle: Text(
            'Due ${BudgetDateUtils.formatDueDay(expense.dueDay)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                CurrencyFormatter.format(expense.amount, currency),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(width: AppSpacing.sm),
              Switch.adaptive(
                value: expense.isActive,
                onChanged: onToggleActive,
                activeColor: AppColors.deepGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
