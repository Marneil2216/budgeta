import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/neumorphic_button.dart';
import '../providers/profile_provider.dart';
import '../widgets/salary_input_card.dart';

class SalarySetupScreen extends ConsumerStatefulWidget {
  const SalarySetupScreen({super.key});

  @override
  ConsumerState<SalarySetupScreen> createState() => _SalarySetupScreenState();
}

class _SalarySetupScreenState extends ConsumerState<SalarySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salaryCtrl = TextEditingController();
  String _currency = 'PHP';

  @override
  void dispose() {
    _salaryCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final salary = double.parse(_salaryCtrl.text.replaceAll(',', ''));
    await ref.read(profileNotifierProvider.notifier).updateCurrency(_currency);
    await ref.read(profileNotifierProvider.notifier).updateSalary(salary);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                const Icon(Icons.account_balance_wallet, color: AppColors.deepGreen, size: 48),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  "What's your monthly income?",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'This helps us calculate your daily budget and track your spending.',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                SalaryInputCard(
                  controller: _salaryCtrl,
                  currency: _currency,
                  validator: Validators.amount,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _currency,
                  decoration: InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: CurrencyFormatter.supportedCurrencies
                      .map((c) => DropdownMenuItem(value: c, child: Text('$c — ${CurrencyFormatter.symbol(c)}')))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _currency = value);
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                NeumorphicButton(
                  label: 'Get Started',
                  onPressed: profileState.isLoading ? null : _submit,
                  isLoading: profileState.isLoading,
                  icon: Icons.arrow_forward_rounded,
                ),
                if (profileState.hasError) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    profileState.error.toString(),
                    style: const TextStyle(color: AppColors.errorRed, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
