class BudgetDateUtils {
  BudgetDateUtils._();

  static int daysLeftInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    final remaining = lastDay - date.day;
    return remaining < 1 ? 1 : remaining;
  }

  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1);

  static DateTime endOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0, 23, 59, 59);

  static String formatDueDay(int day) {
    if (day == 1 || day == 21 || day == 31) return '${day}st';
    if (day == 2 || day == 22) return '${day}nd';
    if (day == 3 || day == 23) return '${day}rd';
    return '${day}th';
  }

  static int daysUntilDue(int dueDay) {
    final today = DateTime.now();
    final thisMonth = DateTime(today.year, today.month, dueDay);
    if (thisMonth.isBefore(today)) {
      final nextMonth = DateTime(today.year, today.month + 1, dueDay);
      return nextMonth.difference(today).inDays;
    }
    return thisMonth.difference(today).inDays;
  }
}
