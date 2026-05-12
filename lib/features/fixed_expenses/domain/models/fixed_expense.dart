class FixedExpense {
  const FixedExpense({
    required this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.category,
    required this.dueDay,
    this.isActive = true,
    this.iconName = 'receipt',
    this.createdAt,
  });

  final String id;
  final String userId;
  final String name;
  final double amount;
  final String category;
  final int dueDay;
  final bool isActive;
  final String iconName;
  final DateTime? createdAt;

  FixedExpense copyWith({
    String? name,
    double? amount,
    String? category,
    int? dueDay,
    bool? isActive,
    String? iconName,
  }) =>
      FixedExpense(
        id: id,
        userId: userId,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        dueDay: dueDay ?? this.dueDay,
        isActive: isActive ?? this.isActive,
        iconName: iconName ?? this.iconName,
        createdAt: createdAt,
      );

  factory FixedExpense.fromMap(Map<String, dynamic> map) => FixedExpense(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        name: map['name'] as String,
        amount: double.parse(map['amount'].toString()),
        category: map['category'] as String? ?? 'other',
        dueDay: map['due_day'] as int,
        isActive: map['is_active'] as bool? ?? true,
        iconName: map['icon_name'] as String? ?? 'receipt',
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : null,
      );

  Map<String, dynamic> toInsertMap() => {
        'user_id': userId,
        'name': name,
        'amount': amount,
        'category': category,
        'due_day': dueDay,
        'is_active': isActive,
        'icon_name': iconName,
      };
}

enum ExpenseCategory {
  rent('rent', 'Rent/Mortgage'),
  utilities('utilities', 'Utilities'),
  insurance('insurance', 'Insurance'),
  subscription('subscription', 'Subscription'),
  loan('loan', 'Loan Payment'),
  transport('transport', 'Transport'),
  food('food', 'Food & Groceries'),
  education('education', 'Education'),
  health('health', 'Health'),
  other('other', 'Other');

  const ExpenseCategory(this.value, this.label);
  final String value;
  final String label;

  static ExpenseCategory fromValue(String value) =>
      ExpenseCategory.values.firstWhere((e) => e.value == value, orElse: () => ExpenseCategory.other);
}
