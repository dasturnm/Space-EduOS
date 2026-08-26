import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class InboxTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const InboxTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'payment':
        return Icons.payments_outlined;
      case 'exam':
        return Icons.assignment_outlined;
      case 'system':
        return Icons.settings_suggest_outlined;
      case 'general':
      default:
        return Icons.notifications_none_outlined;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'payment':
        return Colors.green;
      case 'exam':
        return Colors.orange;
      case 'system':
        return Colors.purple;
      case 'general':
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getNotificationColor(notification.type);

    return Card(
      elevation: notification.isRead ? 0 : 1,
      color: notification.isRead ? Colors.white : Colors.blue.shade50.withOpacity(0.4),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: notification.isRead ? Colors.grey.shade200 : Colors.blue.shade200,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: iconColor,
              ),
            ),
            if (!notification.isRead)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              notification.sentAt.toLocal().toString().substring(0, 16),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}