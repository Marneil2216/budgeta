import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/neumorphic_button.dart';
import '../../../../core/widgets/neumorphic_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) return const Center(child: Text('No profile found'));
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              const SizedBox(height: AppSpacing.md),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.deepGreen,
                  child: Text(
                    profile.initials,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textOnDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  profile.displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Center(
                child: Text(
                  profile.email,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              NeumorphicCard(
                child: Column(
                  children: [
                    _ProfileTile(
                      label: 'Monthly Salary',
                      value: profile.monthlySalary != null
                          ? CurrencyFormatter.format(profile.monthlySalary!, profile.currency)
                          : 'Not set',
                      icon: Icons.payments_outlined,
                      onEdit: () => _editSalary(context, ref, profile.currency),
                    ),
                    const Divider(height: 1),
                    _ProfileTile(
                      label: 'Currency',
                      value: '${profile.currency} — ${CurrencyFormatter.symbol(profile.currency)}',
                      icon: Icons.currency_exchange_outlined,
                      onEdit: () => _editCurrency(context, ref),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              NeumorphicButton(
                label: 'Sign Out',
                onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
                color: AppColors.errorRed.withOpacity(0.9),
                icon: Icons.logout_rounded,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        },
      ),
    );
  }

  void _editSalary(BuildContext context, WidgetRef ref, String currency) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Monthly Salary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '${CurrencyFormatter.symbol(currency)} ',
                hintText: '0.00',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(ctrl.text);
                if (val != null && val > 0) {
                  ref.read(profileNotifierProvider.notifier).updateSalary(val);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _editCurrency(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Select Currency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...CurrencyFormatter.supportedCurrencies.map((c) => ListTile(
                title: Text('$c — ${CurrencyFormatter.symbol(c)}'),
                onTap: () {
                  ref.read(profileNotifierProvider.notifier).updateCurrency(c);
                  Navigator.pop(ctx);
                },
              )),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onEdit,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.deepGreen),
      title: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      trailing: TextButton(onPressed: onEdit, child: const Text('Edit')),
    );
  }
}
