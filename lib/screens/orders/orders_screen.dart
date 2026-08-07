import 'package:ecommerce_app/widgets/common/app_back_button.dart';
import 'package:ecommerce_app/widgets/common/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return const Color(0xFF2878E8);
      case OrderStatus.shipped:
        return const Color(0xFF8E4BD8);
      case OrderStatus.delivered:
        return const Color(0xFF2CB673);
      case OrderStatus.cancelled:
        return const Color(0xFFE05A5A);
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: AppColors.of(context).bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 12),
                  Text(
                    'My Orders',
                    style: AppText.heading.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: orders.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'No orders yet',
                      message:
                          'Your orders will appear here after you make a purchase.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final order = orders[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OrderDetailScreen(order: order),
                              ),
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.of(context).surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    AppColors.of(context).line.withOpacity(0.6),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.045),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order #${order.id}',
                                      style: AppText.body.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(order.status)
                                            .withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _statusLabel(order.status),
                                        style: AppText.label.copyWith(
                                          color: _statusColor(order.status),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${order.items.length} item(s) • ${order.date.day}/${order.date.month}/${order.date.year}',
                                  style: AppText.label.copyWith(
                                    color: AppColors.of(context).muted,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${order.total.toStringAsFixed(2)}',
                                      style: AppText.body.copyWith(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppColors.of(context).muted,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}