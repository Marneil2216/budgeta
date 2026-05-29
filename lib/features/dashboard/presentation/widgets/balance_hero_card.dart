import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/neumorphism_theme.dart';
import '../../../../core/utils/currency_formatter.dart';

class BalanceHeroCard extends StatelessWidget {
  const BalanceHeroCard({
    super.key,
    required this.remainingBalance,
    required this.monthlyBudget,
    required this.totalExpenses,
    required this.currency,
    required this.isOverspent,
  });

  final double remainingBalance;
  final double monthlyBudget;
  final double totalExpenses;
  final String currency;
  final bool isOverspent;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final totalDays = DateTime(today.year, today.month + 1, 0).day;
    final spentPercent = monthlyBudget > 0 ? (totalExpenses / monthlyBudget).clamp(0.0, 1.0) : 0.0;
    final dayPercent = ((today.day - 1) / totalDays).clamp(0.0, 1.0);
    final isOnTrack = !isOverspent && spentPercent <= dayPercent + 0.05;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: isOverspent ? NeumorphismTheme.overspentCard : NeumorphismTheme.heroCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REMAINING BALANCE',
            style: AppTextStyles.labelOnDark.copyWith(
              color: isOverspent ? Colors.red[100] : AppColors.softMint,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            CurrencyFormatter.format(remainingBalance.abs(), currency),
            style: AppTextStyles.heroBalance,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: spentPercent,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverspent ? Colors.red[300]! : AppColors.softMint,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(spentPercent * 100).toStringAsFixed(1)}% spent',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
              ),
              if (isOverspent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.white, size: 12),
                      SizedBox(width: 3),
                      Text('OVERSPENT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1500.ms)
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isOnTrack ? 0.2 : 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOnTrack ? Icons.check_circle_outline_rounded : Icons.trending_up_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        isOnTrack ? 'On track' : 'Over pace',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Budget',
                  value: CurrencyFormatter.format(monthlyBudget, currency),
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.softMint,
                ),
              ),
              Container(width: 1, height: 36, color: Colors.white.withOpacity(0.2)),
              Expanded(
                child: _MiniStat(
                  label: 'Spent',
                  value: CurrencyFormatter.format(totalExpenses, currency),
                  icon: Icons.arrow_upward_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.icon, required this.color});

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
