class VariableExpense {
  const VariableExpense({
    required this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.category,
    required this.expenseDate,
    this.note,
    this.iconName = 'shopping_bag',
    this.createdAt,
  });

  final String id;
  final String userId;
  final String name;
  final double amount;
  final String category;
  final DateTime expenseDate;
  final String? note;
  final String iconName;
  final DateTime? createdAt;

  factory VariableExpense.fromMap(Map<String, dynamic> map) => VariableExpense(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        name: map['name'] as String,
        amount: double.parse(map['amount'].toString()),
        category: map['category'] as String? ?? 'other',
        expenseDate: DateTime.parse(map['expense_date'] as String),
        note: map['note'] as String?,
        iconName: map['icon_name'] as String? ?? 'shopping_bag',
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : null,
      );

  Map<String, dynamic> toInsertMap() => {
        'user_id': userId,
        'name': name,
        'amount': amount,
        'category': category,
        'expense_date': expenseDate.toIso8601String().split('T').first,
        'note': note,
        'icon_name': iconName,
      };
}

enum VariableCategory {
  food('food', 'Food & Drinks'),
  transport('transport', 'Transport'),
  shopping('shopping', 'Shopping'),
  health('health', 'Health'),
  entertainment('entertainment', 'Entertainment'),
  education('education', 'Education'),
  personal('personal', 'Personal Care'),
  other('other', 'Other');

  const VariableCategory(this.value, this.label);
  final String value;
  final String label;
}
