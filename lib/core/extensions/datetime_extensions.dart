extension DateTimeExtensions on DateTime {
  bool isSameMonth(DateTime other) =>
      year == other.year && month == other.month;

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  String get monthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }

  String get shortMonthName => monthName.substring(0, 3);
}
