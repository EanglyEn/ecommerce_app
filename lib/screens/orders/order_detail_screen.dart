import 'package:flutter/material.dart';

import 'package:ecommerce_app/widgets/common/app_back_button.dart';

import '../../theme.dart';
import '../../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

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
        return 'On the way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _statusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'Your order has been received and is being prepared.';
      case OrderStatus.shipped:
        return 'Your package is on the way to your delivery address.';
      case OrderStatus.delivered:
        return 'Your package has been successfully delivered.';
      case OrderStatus.cancelled:
        return 'This order has been cancelled and will not be delivered.';
    }
  }

  int _statusStepIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 0;
      case OrderStatus.shipped:
        return 1;
      case OrderStatus.delivered:
        return 2;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final statusColor = _statusColor(order.status);
    final isCancelled = order.status == OrderStatus.cancelled;
    final currentStep = _statusStepIndex(order.status);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ===============================================================
            // APP BAR
            // ===============================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 16, 12),
              child: Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order details',
                          style: AppText.heading.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '#${order.id}',
                          style: AppText.label.copyWith(
                            color: colors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _SmallStatusBadge(
                    label: _statusLabel(order.status),
                    color: statusColor,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                children: [
                  // =========================================================
                  // STATUS HERO
                  // =========================================================
                  _StatusHero(
                    status: order.status,
                    color: statusColor,
                    title: _statusLabel(order.status),
                    description: _statusDescription(order.status),
                    date: order.date,
                  ),

                  const SizedBox(height: 16),

                  // =========================================================
                  // TRACKING PROGRESS
                  // =========================================================
                  if (!isCancelled)
                    _TrackingCard(
                      currentStep: currentStep,
                      color: statusColor,
                    )
                  else
                    _CancelledCard(
                      color: statusColor,
                    ),

                  const SizedBox(height: 22),

                  // =========================================================
                  // ORDER ITEMS HEADER
                  // =========================================================
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Order items',
                          style: AppText.heading.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                        style: AppText.label.copyWith(
                          color: colors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // =========================================================
                  // ITEMS
                  // =========================================================
                  ...order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _OrderItemCard(
                        item: item,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // =========================================================
                  // PRICE SUMMARY
                  // =========================================================
                  _PriceSummary(
                    order: order,
                  ),

                  const SizedBox(height: 14),

                  // =========================================================
                  // ORDER INFORMATION
                  // =========================================================
                  _OrderInformation(
                    order: order,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// STATUS HERO
// =============================================================================

class _StatusHero extends StatelessWidget {
  final OrderStatus status;
  final Color color;
  final String title;
  final String description;
  final DateTime date;

  const _StatusHero({
    required this.status,
    required this.color,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isCancelled = status == OrderStatus.cancelled;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.line.withOpacity(.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(.11),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCancelled
                  ? Icons.close_rounded
                  : status == OrderStatus.delivered
                      ? Icons.check_rounded
                      : Icons.local_shipping_rounded,
              color: color,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.heading.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: AppText.body.copyWith(
                    fontSize: 12,
                    height: 1.45,
                    color: colors.muted,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: colors.muted,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _formatDate(date),
                      style: AppText.label.copyWith(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: colors.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// =============================================================================
// SMALL STATUS BADGE
// =============================================================================

class _SmallStatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SmallStatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppText.label.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TRACKING CARD
// =============================================================================

class _TrackingCard extends StatelessWidget {
  final int currentStep;
  final Color color;

  const _TrackingCard({
    required this.currentStep,
    required this.color,
  });

  static const _steps = [
    _TrackingStep(
      icon: Icons.receipt_long_rounded,
      title: 'Order placed',
      subtitle: 'We received your order',
    ),
    _TrackingStep(
      icon: Icons.inventory_2_rounded,
      title: 'Preparing',
      subtitle: 'Your items are being prepared',
    ),
    _TrackingStep(
      icon: Icons.local_shipping_rounded,
      title: 'On the way',
      subtitle: 'Your package is on the way',
    ),
    _TrackingStep(
      icon: Icons.home_rounded,
      title: 'Delivered',
      subtitle: 'Package delivered successfully',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // The existing model has:
    // processing -> step 1
    // shipped    -> step 3
    // delivered  -> step 4
    final activeIndex = currentStep == 0
        ? 1
        : currentStep == 1
            ? 2
            : 3;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.line.withOpacity(.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tracking',
                  style: AppText.heading.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${((activeIndex + 1) / _steps.length * 100).round()}%',
                style: AppText.label.copyWith(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: (activeIndex + 1) / _steps.length,
                backgroundColor: colors.bg,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Timeline
          Column(
            children: List.generate(
              _steps.length,
              (index) {
                final step = _steps[index];

                final isDone = index <= activeIndex;
                final isCurrent = index == activeIndex;
                final isLast = index == _steps.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline column
                      SizedBox(
                        width: 38,
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isCurrent ? 34 : 30,
                              height: isCurrent ? 34 : 30,
                              decoration: BoxDecoration(
                                color: isDone
                                    ? color
                                    : colors.bg,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDone
                                      ? color
                                      : colors.line,
                                  width: isCurrent ? 3 : 1.5,
                                ),
                                boxShadow: isCurrent
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(.20),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                isDone
                                    ? Icons.check_rounded
                                    : step.icon,
                                size: isCurrent ? 16 : 14,
                                color: isDone
                                    ? Colors.white
                                    : colors.muted,
                              ),
                            ),

                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: index < activeIndex
                                        ? color
                                        : colors.line,
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Step information
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 2,
                            bottom: 20,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      step.title,
                                      style: AppText.body.copyWith(
                                        fontSize: 13,
                                        fontWeight: isDone
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                        color: isDone
                                            ? colors.ink
                                            : colors.muted,
                                      ),
                                    ),
                                  ),

                                  if (isCurrent)
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(.10),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'CURRENT',
                                        style: AppText.label.copyWith(
                                          color: color,
                                          fontSize: 8,
                                          fontWeight:
                                              FontWeight.w900,
                                          letterSpacing: .3,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              Text(
                                step.subtitle,
                                style: AppText.label.copyWith(
                                  fontSize: 10.5,
                                  color: colors.muted,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TRACKING STEP MODEL
// =============================================================================

class _TrackingStep {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrackingStep({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// =============================================================================
// CANCELLED CARD
// =============================================================================

class _CancelledCard extends StatelessWidget {
  final Color color;

  const _CancelledCard({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(.07),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(.20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(.11),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order cancelled',
                  style: AppText.body.copyWith(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'This order is no longer being processed or tracked.',
                  style: AppText.label.copyWith(
                    color: colors.muted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ORDER ITEM CARD
// =============================================================================

class _OrderItemCard extends StatelessWidget {
  final dynamic item;

  const _OrderItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final total =
        item.product.discountedPrice * item.quantity;

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.line.withOpacity(.55),
        ),
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              item.product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Icon(
                  Icons.image_not_supported_outlined,
                  color: colors.muted,
                  size: 20,
                );
              },
              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }

                return Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.8,
                      color: colors.muted,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          // Product information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.bg,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Qty ${item.quantity}',
                        style: AppText.label.copyWith(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: colors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '\$${item.product.discountedPrice.toStringAsFixed(2)}',
                      style: AppText.label.copyWith(
                        fontSize: 10,
                        color: colors.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Total
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: AppText.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PRICE SUMMARY
// =============================================================================

class _PriceSummary extends StatelessWidget {
  final Order order;

  const _PriceSummary({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.line.withOpacity(.55),
        ),
      ),
      child: Column(
        children: [
          _PriceRow(
            label: 'Subtotal',
            value: '\$${order.total.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 11),

          _PriceRow(
            label: 'Shipping',
            value: 'Free',
            valueColor: const Color(0xFF2CB673),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              height: 1,
              color: colors.line.withOpacity(.55),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: AppText.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: AppText.heading.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brand,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PRICE ROW
// =============================================================================

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppText.label.copyWith(
              color: colors.muted,
              fontSize: 11,
            ),
          ),
        ),
        Text(
          value,
          style: AppText.body.copyWith(
            color: valueColor ?? colors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ORDER INFORMATION
// =============================================================================

class _OrderInformation extends StatelessWidget {
  final Order order;

  const _OrderInformation({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.line.withOpacity(.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order information',
            style: AppText.heading.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          _InfoRow(
            icon: Icons.receipt_long_outlined,
            label: 'Order ID',
            value: '#${order.id}',
          ),

          const SizedBox(height: 12),

          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Order date',
            value: _formatDate(order.date),
          ),

          const SizedBox(height: 12),

          _InfoRow(
            icon: Icons.inventory_2_outlined,
            label: 'Items',
            value: '${order.items.length}',
          ),

          const SizedBox(height: 12),

          _InfoRow(
            icon: Icons.payments_outlined,
            label: 'Order total',
            value: '\$${order.total.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// =============================================================================
// INFO ROW
// =============================================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colors.bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 16,
            color: colors.muted,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            label,
            style: AppText.label.copyWith(
              color: colors.muted,
              fontSize: 10.5,
            ),
          ),
        ),

        Text(
          value,
          style: AppText.body.copyWith(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}