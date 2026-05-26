import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/models/app_notification.dart';

class NotificationBanners extends StatefulWidget {
  const NotificationBanners({super.key, required this.notifications});

  final List<AppNotification> notifications;

  @override
  State<NotificationBanners> createState() => _NotificationBannersState();
}

class _NotificationBannersState extends State<NotificationBanners> {
  final Set<String> _dismissed = {};

  @override
  Widget build(BuildContext context) {
    final visible = widget.notifications.where((n) => !_dismissed.contains(n.id)).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Column(
      children: visible.asMap().entries.map((entry) {
        final n = entry.value;
        return _NotificationBanner(
          key: ValueKey(n.id),
          notification: n,
          onDismiss: () => setState(() => _dismissed.add(n.id)),
        ).animate(delay: Duration(milliseconds: entry.key * 80))
            .fadeIn(duration: 300.ms)
            .slideY(begin: -0.1);
      }).toList(),
    );
  }
}

class _NotificationBanner extends StatelessWidget {
  const _NotificationBanner({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  final AppNotification notification;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(notification.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_iconFor(notification.type), color: colors.icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.message,
                  style: TextStyle(fontSize: 12, color: colors.text.withOpacity(0.85)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(Icons.close_rounded, size: 16, color: colors.icon.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  _BannerColors _colorsFor(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.danger:
        return _BannerColors(
          background: AppColors.errorRed.withOpacity(0.08),
          border: AppColors.errorRed.withOpacity(0.25),
          icon: AppColors.errorRed,
          text: const Color(0xFF7F1D1D),
        );
      case NotificationSeverity.warning:
        return _BannerColors(
          background: AppColors.warningAmber.withOpacity(0.08),
          border: AppColors.warningAmber.withOpacity(0.3),
          icon: AppColors.warningAmber,
          text: const Color(0xFF78350F),
        );
      case NotificationSeverity.info:
        return _BannerColors(
          background: AppColors.deepGreen.withOpacity(0.07),
          border: AppColors.deepGreen.withOpacity(0.2),
          icon: AppColors.deepGreen,
          text: const Color(0xFF14532D),
        );
    }
  }

  IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.overspent:
        return Icons.warning_amber_rounded;
      case NotificationType.billDue:
        return Icons.receipt_long_outlined;
      case NotificationType.dailyReminder:
        return Icons.edit_note_rounded;
    }
  }
}

class _BannerColors {
  const _BannerColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.text,
  });
  final Color background;
  final Color border;
  final Color icon;
  final Color text;
}
