import 'package:flutter/material.dart';

enum NotificationType {
  order,
  shipping,
  payment,
  promotion,
  system,
}

class Notification {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;
  final String dateGroup;

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
    required this.dateGroup,
  });

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    String? time,
    NotificationType? type,
    bool? isRead,
    String? dateGroup,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      dateGroup: dateGroup ?? this.dateGroup,
    );
  }
}

// =============================================================================
// NOTIFICATION SECTION
// =============================================================================

class NotificationSection {
  final String title;
  final List<Notification> notifications;

  const NotificationSection({
    required this.title,
    required this.notifications,
  });
}

// =============================================================================
// NOTIFICATION TYPE UI
// =============================================================================

extension NotificationTypeExtension on NotificationType {
  Color get color {
    switch (this) {
      case NotificationType.order:
        return const Color(0xFF2878E8);

      case NotificationType.shipping:
        return const Color(0xFF8E4BD8);

      case NotificationType.payment:
        return const Color(0xFF2CB673);

      case NotificationType.promotion:
        return const Color(0xFFF39C12);

      case NotificationType.system:
        return const Color(0xFF6C63FF);
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.order:
        return Icons.receipt_long_rounded;

      case NotificationType.shipping:
        return Icons.local_shipping_rounded;

      case NotificationType.payment:
        return Icons.payments_rounded;

      case NotificationType.promotion:
        return Icons.local_offer_rounded;

      case NotificationType.system:
        return Icons.notifications_rounded;
    }
  }
}