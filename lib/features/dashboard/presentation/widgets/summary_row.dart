import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/neumorphic_card.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.totalFixed,
    required this.totalVariable,
    required this.currency,
  });

  final double totalFixed;
  final double totalVariable;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryChip(
            label: 'Fixed Bills',
            amount: totalFixed,
            currency: currency,
            icon: Icons.receipt_long_outlined,
            color: AppColors.warningAmber,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryChip(
            label: 'Variable',
            amount: totalVariable,
            currency: currency,
            icon: Icons.shopping_bag_outlined,
            color: AppColors.errorRed,
          ),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.currency,
    required this.icon,
    required this.color,
  });

  final String label;
  final double amount;
  final String currency;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            CurrencyFormatter.format(amount, currency),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
