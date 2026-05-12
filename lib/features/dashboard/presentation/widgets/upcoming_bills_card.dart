import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/neumorphic_card.dart';
import '../../../fixed_expenses/domain/models/fixed_expense.dart';

class UpcomingBillsCard extends StatelessWidget {
  const UpcomingBillsCard({super.key, required this.bills, required this.currency});

  final List<FixedExpense> bills;
  final String currency;

  @override
  Widget build(BuildContext context) {
    if (bills.isEmpty) return const SizedBox.shrink();

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.upcoming_outlined, color: AppColors.deepGreen, size: 18),
              SizedBox(width: AppSpacing.xs),
              Text('Upcoming Bills', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...bills.map((bill) {
            final daysUntil = BudgetDateUtils.daysUntilDue(bill.dueDay);
            final isUrgent = daysUntil <= 3;
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(bill.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                  Text(
                    CurrencyFormatter.format(bill.amount, currency),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? AppColors.errorRed.withOpacity(0.12)
                          : AppColors.softMint.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      daysUntil == 0 ? 'Today' : '${daysUntil}d',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isUrgent ? AppColors.errorRed : AppColors.deepGreen,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
