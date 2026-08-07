import 'package:ecommerce_app/widgets/common/app_empty_state.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import '../../models/notification.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/app_back_button.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                10,
                16,
                10,
              ),
              child: Row(
                children: [
                  const AppBackButton(),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: AppText.heading.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: colors.ink,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          unreadCount == 0
                              ? 'You are all caught up'
                              : '$unreadCount unread '
                                  '${unreadCount == 1 ? 'notification' : 'notifications'}',
                          style: AppText.label.copyWith(
                            color: colors.muted,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (unreadCount > 0)
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(notificationProvider.notifier)
                            .markAllAsRead();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.brand.withOpacity(.09),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          'Mark all read',
                          style: AppText.label.copyWith(
                            color: AppColors.brand,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: notifications.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.notifications_none_rounded,
                      title: 'No notifications',
                      message:
                          'You are all caught up. New notifications will appear here.',
                    )
                  : _buildNotificationList(
                      context,
                      ref,
                      notifications,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    WidgetRef ref,
    List<Notification> notifications,
  ) {
    final grouped = <String, List<Notification>>{};

    for (final notification in notifications) {
      grouped
          .putIfAbsent(
            notification.dateGroup,
            () => [],
          )
          .add(notification);
    }

    final sections = grouped.entries.map((entry) {
      return NotificationSection(
        title: entry.key,
        notifications: entry.value,
      );
    }).toList();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        30,
      ),
      itemCount: sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = sections[sectionIndex];

        return Padding(
          padding: const EdgeInsets.only(
            bottom: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 3,
                  bottom: 9,
                ),
                child: Text(
                  section.title,
                  style: AppText.label.copyWith(
                    color: AppColors.of(context).muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ...section.notifications.map(
                (notification) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 9,
                    ),
                    child: _NotificationCard(
                      notification: notification,

                      onTap: () {
                        ref
                            .read(
                              notificationProvider.notifier,
                            )
                            .markAsRead(notification.id);

                        // _openNotification(
                        //   context,
                        //   notification,
                        // );
                      },

                      onDelete: () {
                        ref
                            .read(
                              notificationProvider.notifier,
                            )
                            .removeNotification(
                              notification.id,
                            );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // void _openNotification(
  //   BuildContext context,
  //   Notification notification,
  // ) {
  //   // Add navigation based on notification type here.
  //   //
  //   // Example:
  //   //
  //   // if (notification.type == NotificationType.shipping) {
  //   //   Navigator.of(context).pushNamed(
  //   //     AppRoutes.orderDetail,
  //   //   );
  //   // }
  // }
}

// =============================================================================
// NOTIFICATION CARD
// =============================================================================

class _NotificationCard extends StatelessWidget {
  final Notification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Uses the extension from notification.dart
    final notificationColor = notification.type.color;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,

      onDismissed: (_) {
        onDelete();
      },

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 20,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE05A5A),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 220,
            ),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? colors.surface
                  : AppColors.brand.withOpacity(.045),

              borderRadius: BorderRadius.circular(18),

              border: Border.all(
                color: notification.isRead
                    ? colors.line.withOpacity(.55)
                    : AppColors.brand.withOpacity(.18),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.025),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================================================
                // ICON
                // =========================================================
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: notificationColor.withOpacity(.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    notification.type.icon,
                    color: notificationColor,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                // =========================================================
                // CONTENT
                // =========================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.body.copyWith(
                                fontSize: 13,
                                fontWeight: notification.isRead
                                    ? FontWeight.w700
                                    : FontWeight.w800,
                                color: colors.ink,
                              ),
                            ),
                          ),

                          // =================================================
                          // UNREAD DOT
                          // =================================================
                          if (!notification.isRead)
                            Container(
                              margin: const EdgeInsets.only(
                                left: 7,
                                top: 4,
                              ),
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.brand,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Text(
                        notification.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.label.copyWith(
                          color: colors.muted,
                          fontSize: 10.5,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // =====================================================
                      // TIME
                      // =====================================================
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 12,
                            color: colors.muted,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            notification.time,
                            style: AppText.label.copyWith(
                              color: colors.muted,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}