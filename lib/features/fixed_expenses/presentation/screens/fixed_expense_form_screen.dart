import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/neumorphic_button.dart';
import '../../../../core/widgets/neumorphic_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/fixed_expense.dart';
import '../providers/fixed_expenses_provider.dart';

class FixedExpenseFormScreen extends ConsumerStatefulWidget {
  const FixedExpenseFormScreen({super.key, this.expenseId});

  final String? expenseId;

  @override
  ConsumerState<FixedExpenseFormScreen> createState() => _FixedExpenseFormScreenState();
}

class _FixedExpenseFormScreenState extends ConsumerState<FixedExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _dueDayCtrl = TextEditingController();
  String _category = 'other';

  FixedExpense? _existing;

  @override
  void initState() {
    super.initState();
    if (widget.expenseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    }
  }

  void _loadExisting() {
    final expenses = ref.read(fixedExpensesStreamProvider).valueOrNull;
    _existing = expenses?.firstWhere((e) => e.id == widget.expenseId);
    if (_existing != null) {
      _nameCtrl.text = _existing!.name;
      _amountCtrl.text = _existing!.amount.toStringAsFixed(2);
      _dueDayCtrl.text = _existing!.dueDay.toString();
      setState(() => _category = _existing!.category);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _dueDayCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final notifier = ref.read(fixedExpensesNotifierProvider.notifier);

    if (_existing != null) {
      await notifier.updateExpense(widget.expenseId!, {
        'name': _nameCtrl.text.trim(),
        'amount': double.parse(_amountCtrl.text.replaceAll(',', '')),
        'category': _category,
        'due_day': int.parse(_dueDayCtrl.text),
      });
    } else {
      await notifier.add(FixedExpense(
        id: '',
        userId: user.id,
        name: _nameCtrl.text.trim(),
        amount: double.parse(_amountCtrl.text.replaceAll(',', '')),
        category: _category,
        dueDay: int.parse(_dueDayCtrl.text),
      ));
    }

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.expenseId != null;
    final notifierState = ref.watch(fixedExpensesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Bill' : 'Add Fixed Bill'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeumorphicTextField(
                controller: _nameCtrl,
                label: 'Bill Name',
                hint: 'e.g. Netflix, Rent, Internet',
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.required(v, field: 'Bill name'),
              ),
              const SizedBox(height: AppSpacing.md),
              NeumorphicTextField(
                controller: _amountCtrl,
                label: 'Amount',
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                textInputAction: TextInputAction.next,
                validator: Validators.amount,
              ),
              const SizedBox(height: AppSpacing.md),
              NeumorphicTextField(
                controller: _dueDayCtrl,
                label: 'Due Day (1–31)',
                hint: '1',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validators.dueDay,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                items: ExpenseCategory.values
                    .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                    .toList(),
                onChanged: (v) { if (v != null) setState(() => _category = v); },
              ),
              const SizedBox(height: AppSpacing.xl),
              NeumorphicButton(
                label: isEdit ? 'Save Changes' : 'Add Bill',
                onPressed: notifierState.isLoading ? null : _submit,
                isLoading: notifierState.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
