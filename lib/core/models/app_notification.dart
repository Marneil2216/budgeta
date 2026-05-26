enum NotificationType { billDue, overspent, dailyReminder }

enum NotificationSeverity { info, warning, danger }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.severity,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final NotificationSeverity severity;
}
