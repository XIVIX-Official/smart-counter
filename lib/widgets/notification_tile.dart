import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismiss?.call(),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: _buildNotificationIcon(context),
        title: Text(
          notification.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              notification.relativeTime,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                  ),
            ),
          ],
        ),
        tileColor: notification.isRead
            ? null
            : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    IconData icon;
    Color backgroundColor;

    switch (notification.type) {
      case NotificationType.counterRoom:
        icon = Icons.dashboard;
        backgroundColor = Colors.blue;
        break;
      case NotificationType.item:
        icon = Icons.inventory_2;
        backgroundColor = Colors.green;
        break;
      case NotificationType.user:
        icon = Icons.person;
        backgroundColor = Colors.orange;
        break;
      default:
        icon = Icons.notifications;
        backgroundColor = Colors.grey;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: backgroundColor,
        size: 20,
      ),
    );
  }

}