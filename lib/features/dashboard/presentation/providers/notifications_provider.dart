import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/app_notification.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../variable_expenses/presentation/providers/variable_expenses_provider.dart';
import 'dashboard_provider.dart';

part 'notifications_provider.g.dart';

@riverpod
List<AppNotification> dashboardNotifications(Ref ref) {
  final summary = ref.watch(dashboardSummaryProvider);
  final variableAsync = ref.watch(variableExpensesStreamProvider);
  final notifications = <AppNotification>[];

  if (summary == null) return notifications;

  // 1. Overspent alert
  if (summary.isOverspent) {
    notifications.add(const AppNotification(
      id: 'overspent',
      type: NotificationType.overspent,
      title: 'Over Budget',
      message: 'You have exceeded your monthly budget. Review your expenses.',
      severity: NotificationSeverity.danger,
    ));
  }

  // 2. Bill due in ≤3 days
  for (final bill in summary.upcomingBills) {
    final days = BudgetDateUtils.daysUntilDue(bill.dueDay);
    if (days <= 3) {
      final dayLabel = days == 0 ? 'today' : days == 1 ? 'tomorrow' : 'in $days days';
      notifications.add(AppNotification(
        id: 'bill_${bill.id}',
        type: NotificationType.billDue,
        title: 'Bill Due ${days == 0 ? 'Today' : days == 1 ? 'Tomorrow' : 'Soon'}',
        message: '${bill.name} (${_formatAmount(bill.amount, summary.currency)}) is due $dayLabel.',
        severity: days == 0 ? NotificationSeverity.danger : NotificationSeverity.warning,
      ));
    }
  }

  // 3. Daily log reminder — no expense logged today
  final expenses = variableAsync.valueOrNull ?? [];
  final today = DateTime.now();
  final loggedToday = expenses.any((e) =>
      e.expenseDate.year == today.year &&
      e.expenseDate.month == today.month &&
      e.expenseDate.day == today.day);

  if (!loggedToday && today.hour >= 18) {
    notifications.add(const AppNotification(
      id: 'daily_reminder',
      type: NotificationType.dailyReminder,
      title: 'Daily Reminder',
      message: 'You haven\'t logged any expenses today. Keep your budget accurate!',
      severity: NotificationSeverity.info,
    ));
  }

  return notifications;
}

String _formatAmount(double amount, String currency) {
  final symbol = currency == 'PHP' ? '₱' : currency;
  return '$symbol${amount.toStringAsFixed(0)}';
}
