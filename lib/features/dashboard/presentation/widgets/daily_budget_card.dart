import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/neumorphic_card.dart';
import '../../../../core/extensions/datetime_extensions.dart';

class DailyBudgetCard extends StatelessWidget {
  const DailyBudgetCard({
    super.key,
    required this.dailyBudget,
    required this.daysLeft,
    required this.currency,
    required this.isOverspent,
  });

  final double dailyBudget;
  final int daysLeft;
  final String currency;
  final bool isOverspent;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final color = isOverspent ? AppColors.errorRed : AppColors.deepGreen;

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Budget',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$daysLeft days left in ${now.shortMonthName}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.today_outlined, color: color, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isOverspent
                    ? 'Over budget'
                    : CurrencyFormatter.format(dailyBudget, currency),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: isOverspent ? AppColors.errorRed : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isOverspent
                ? 'You\'ve exceeded your budget this month'
                : 'to spend each day',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
