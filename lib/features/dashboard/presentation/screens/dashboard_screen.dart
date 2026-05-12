import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/balance_hero_card.dart';
import '../widgets/daily_budget_card.dart';
import '../widgets/summary_row.dart';
import '../widgets/upcoming_bills_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.valueOrNull;
    final now = DateTime.now();

    if (profileAsync.isLoading) {
      return const Scaffold(body: AppLoadingIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.deepGreen,
          onRefresh: () async {
            ref.invalidate(userProfileProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE3F4EC), Color(0xFFF7F9FB)],
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      profile?.firstName ?? 'Welcome',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    Text(
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: const TextStyle(fontSize: 13, color: AppColors.deepGreen, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                toolbarHeight: 90,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: InkWell(
                      onTap: () => context.go('/app/profile'),
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.deepGreen, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.deepGreen,
                          child: Text(
                            profile?.initials ?? '?',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (summary == null) ...[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            children: [
                              AppLoadingIndicator(),
                              SizedBox(height: AppSpacing.md),
                              Text('Loading your budget...', style: TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      BalanceHeroCard(
                        remainingBalance: summary.remainingBalance,
                        salary: summary.salary,
                        totalExpenses: summary.totalExpenses,
                        currency: summary.currency,
                        isOverspent: summary.isOverspent,
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05),
                      const SizedBox(height: AppSpacing.md),
                      DailyBudgetCard(
                        dailyBudget: summary.dailyBudget,
                        daysLeft: summary.daysLeftInMonth,
                        currency: summary.currency,
                        isOverspent: summary.isOverspent,
                      ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                      const SizedBox(height: AppSpacing.md),
                      SummaryRow(
                        totalFixed: summary.totalFixedExpenses,
                        totalVariable: summary.totalVariableExpenses,
                        currency: summary.currency,
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                      const SizedBox(height: AppSpacing.md),
                      UpcomingBillsCard(
                        bills: summary.upcomingBills,
                        currency: summary.currency,
                      ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                      const SizedBox(height: AppSpacing.md),
                      _QuickAddButton(month: now).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}

class _QuickAddButton extends ConsumerWidget {
  const _QuickAddButton({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => context.push('/app/expenses/add'),
      icon: const Icon(Icons.add_rounded),
      label: Text('Add Expense for ${month.shortMonthName} ${month.day}'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
