import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/neumorphic_button.dart';
import '../../../../core/widgets/neumorphic_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/variable_expense.dart';
import '../providers/variable_expenses_provider.dart';

class VariableExpenseFormScreen extends ConsumerStatefulWidget {
  const VariableExpenseFormScreen({super.key, this.expenseId});

  final String? expenseId;

  @override
  ConsumerState<VariableExpenseFormScreen> createState() => _VariableExpenseFormScreenState();
}

class _VariableExpenseFormScreenState extends ConsumerState<VariableExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _category = 'other';
  DateTime _date = DateTime.now();

  VariableExpense? _existing;

  @override
  void initState() {
    super.initState();
    if (widget.expenseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    }
  }

  void _loadExisting() {
    final expenses = ref.read(variableExpensesStreamProvider).valueOrNull;
    _existing = expenses?.firstWhere((e) => e.id == widget.expenseId);
    if (_existing != null) {
      _nameCtrl.text = _existing!.name;
      _amountCtrl.text = _existing!.amount.toStringAsFixed(2);
      _noteCtrl.text = _existing!.note ?? '';
      setState(() {
        _category = _existing!.category;
        _date = _existing!.expenseDate;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final notifier = ref.read(variableExpensesNotifierProvider.notifier);

    if (_existing != null) {
      await notifier.updateExpense(widget.expenseId!, {
        'name': _nameCtrl.text.trim(),
        'amount': double.parse(_amountCtrl.text.replaceAll(',', '')),
        'category': _category,
        'expense_date': _date.toIso8601String().split('T').first,
        'note': _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      });
    } else {
      await notifier.add(VariableExpense(
        id: '',
        userId: user.id,
        name: _nameCtrl.text.trim(),
        amount: double.parse(_amountCtrl.text.replaceAll(',', '')),
        category: _category,
        expenseDate: _date,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      ));
    }

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.expenseId != null;
    final notifierState = ref.watch(variableExpensesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Expense' : 'Add Expense'),
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
                label: 'Expense Name',
                hint: 'e.g. Lunch, Grab, Groceries',
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.required(v, field: 'Expense name'),
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
              const Text('Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                items: VariableCategory.values
                    .map((c) => DropdownMenuItem(value: c.value, child: Text(c.label)))
                    .toList(),
                onChanged: (v) { if (v != null) setState(() => _category = v); },
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(DateFormat('MMMM d, yyyy').format(_date)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              NeumorphicTextField(
                controller: _noteCtrl,
                label: 'Note (optional)',
                hint: 'Add a note...',
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.xl),
              NeumorphicButton(
                label: isEdit ? 'Save Changes' : 'Add Expense',
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
