import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/models/variable_expense.dart';

class VariableExpenseTile extends StatelessWidget {
  const VariableExpenseTile({
    super.key,
    required this.expense,
    required this.currency,
    required this.onEdit,
    required this.onDelete,
  });

  final VariableExpense expense;
  final String currency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const _categoryIcons = <String, IconData>{
    'food': Icons.restaurant_outlined,
    'transport': Icons.directions_car_outlined,
    'shopping': Icons.shopping_bag_outlined,
    'health': Icons.local_hospital_outlined,
    'entertainment': Icons.movie_outlined,
    'education': Icons.school_outlined,
    'personal': Icons.person_outlined,
    'other': Icons.receipt_outlined,
  };

  static const _categoryColors = <String, Color>{
    'food': Color(0xFF66BB6A),
    'transport': Color(0xFF26A69A),
    'shopping': Color(0xFFAB47BC),
    'health': Color(0xFFEC407A),
    'entertainment': Color(0xFFFF7043),
    'education': Color(0xFF5C6BC0),
    'personal': Color(0xFF42A5F5),
    'other': Color(0xFF78909C),
  };

  @override
  Widget build(BuildContext context) {
    final icon = _categoryIcons[expense.category] ?? Icons.receipt_outlined;
    final color = _categoryColors[expense.category] ?? AppColors.textSecondary;
    final dateLabel = DateFormat('MMM d').format(expense.expenseDate);

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
        title: Text(expense.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: expense.note != null && expense.note!.isNotEmpty
            ? Text(expense.note!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))
            : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.format(expense.amount, currency),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            Text(dateLabel, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
