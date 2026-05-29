import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/neumorphic_card.dart';

class BudgetInputCard extends StatelessWidget {
  const BudgetInputCard({
    super.key,
    required this.controller,
    required this.currency,
    required this.validator,
  });

  final TextEditingController controller;
  final String currency;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Salary / Budget',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: validator,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.deepGreen,
            ),
            decoration: InputDecoration(
              prefixText: '${CurrencyFormatter.symbol(currency)} ',
              prefixStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.deepGreen,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: '0.00',
              hintStyle: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.shadowDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
