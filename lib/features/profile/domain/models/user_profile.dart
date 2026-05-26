class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.monthlySalary,
    this.currency = 'PHP',
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? fullName;
  final double? monthlySalary;
  final String currency;
  final String? avatarUrl;

  UserProfile copyWith({
    String? fullName,
    double? monthlySalary,
    String? currency,
    String? avatarUrl,
  }) =>
      UserProfile(
        id: id,
        email: email,
        fullName: fullName ?? this.fullName,
        monthlySalary: monthlySalary ?? this.monthlySalary,
        currency: currency ?? this.currency,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'] as String,
        email: map['email'] as String,
        fullName: map['full_name'] as String?,
        monthlySalary: map['monthly_salary'] != null
            ? double.parse(map['monthly_salary'].toString())
            : null,
        currency: map['currency'] as String? ?? 'PHP',
        avatarUrl: map['avatar_url'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'full_name': fullName,
        'monthly_salary': monthlySalary,
        'currency': currency,
        'avatar_url': avatarUrl,
      };

  String get displayName =>
      fullName?.isNotEmpty == true ? fullName! : email.split('@').first;

  String get firstName {
    if (fullName != null && fullName!.isNotEmpty) {
      return fullName!.trim().split(' ').first;
    }
    return email.split('@').first;
  }

  String get initials {
    if (fullName == null || fullName!.isEmpty) return email[0].toUpperCase();
    final parts = fullName!.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }
}
