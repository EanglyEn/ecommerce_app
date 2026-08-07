import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<Notification>>(
  (ref) {
    return NotificationNotifier();
  },
);

class NotificationNotifier extends StateNotifier<List<Notification>> {
  NotificationNotifier()
      : super(
          const [
            Notification(
              id: 'n1',
              title: 'Order confirmed',
              message: 'Your order #ORD-1024 has been confirmed successfully.',
              time: '10 min ago',
              type: NotificationType.order,
              isRead: false,
              dateGroup: 'Today',
            ),
            Notification(
              id: 'n2',
              title: 'Your order is on the way',
              message:
                  'Your package has been shipped and is on its way to you.',
              time: '1 hour ago',
              type: NotificationType.shipping,
              isRead: false,
              dateGroup: 'Today',
            ),
            Notification(
              id: 'n3',
              title: 'Payment successful',
              message: 'Your payment of \$129.99 was completed successfully.',
              time: '3 hours ago',
              type: NotificationType.payment,
              isRead: true,
              dateGroup: 'Today',
            ),
            Notification(
              id: 'n4',
              title: '20% off electronics',
              message:
                  'Flash sale is live. Get up to 20% off selected electronics.',
              time: 'Yesterday',
              type: NotificationType.promotion,
              isRead: false,
              dateGroup: 'Yesterday',
            ),
            Notification(
              id: 'n5',
              title: 'Welcome to our store',
              message:
                  'Thanks for joining us. Start exploring our latest products.',
              time: '2 days ago',
              type: NotificationType.system,
              isRead: true,
              dateGroup: 'Earlier',
            ),
          ],
        );

  void markAsRead(String id) {
    state = [
      for (final notification in state)
        notification.id == id
            ? notification.copyWith(
                isRead: true,
              )
            : notification,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final notification in state)
        notification.copyWith(
          isRead: true,
        ),
    ];
  }

  void removeNotification(String id) {
    state = state
        .where(
          (notification) => notification.id != id,
        )
        .toList();
  }

  void clearAll() {
    state = [];
  }

  void addNotification(
    Notification notification,
  ) {
    state = [
      notification,
      ...state,
    ];
  }
}

final notificationSectionsProvider = Provider<List<NotificationSection>>((ref) {
  final notifications = ref.watch(notificationProvider);

  final Map<String, List<Notification>> grouped = {};

  for (final notification in notifications) {
    grouped
        .putIfAbsent(
          notification.dateGroup,
          () => [],
        )
        .add(notification);
  }

  return grouped.entries.map(
    (entry) {
      return NotificationSection(
        title: entry.key,
        notifications: entry.value,
      );
    },
  ).toList();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider);

  return notifications
      .where(
        (notification) => !notification.isRead,
      )
      .length;
});

final hasUnreadNotificationProvider = Provider<bool>((ref) {
  final count = ref.watch(
    unreadNotificationCountProvider,
  );

  return count > 0;
});
