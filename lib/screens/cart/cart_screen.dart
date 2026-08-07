// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/order.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../theme.dart';
import '../../widgets/common/app_dialog.dart';
import '../../widgets/common/app_snack_bar.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: AppColors.of(context).bg,
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: AppColors.of(context).bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: cartItems.isEmpty
          ? const _EmptyCart()
          : ListView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                160,
              ),

              children: [
                // -------------------------------------------------------------
                // CART HEADER
                // -------------------------------------------------------------

                _CartHeader(
                  itemCount: cartItems.length,
                ),

                const SizedBox(height: 14),

                // -------------------------------------------------------------
                // CART ITEMS
                // -------------------------------------------------------------

                ...cartItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CartItemCard(
                      item: item,

                      onIncrement: () {
                        ref
                            .read(cartProvider.notifier)
                            .incrementQuantity(
                              item.product.id,
                            );
                      },

                      onDecrement: () async {
                        // -----------------------------------------------------
                        // More than 1
                        // -----------------------------------------------------

                        if (item.quantity > 1) {
                          ref
                              .read(cartProvider.notifier)
                              .decrementQuantity(
                                item.product.id,
                              );

                          return;
                        }

                        // -----------------------------------------------------
                        // Quantity == 1
                        // Ask before removing
                        // -----------------------------------------------------

                        final shouldRemove =
                            await AppDialog.showConfirm(
                          context,
                          title: 'Remove item?',
                          message:
                              'This is the last item in your cart. '
                              'Do you want to remove "${item.product.name}"?',
                          confirmText: 'Remove',
                          cancelText: 'Keep',
                          destructive: true,
                        );

                        if (!shouldRemove) return;

                        ref
                            .read(cartProvider.notifier)
                            .removeProduct(
                              item.product.id,
                            );

                        if (!context.mounted) return;

                        AppSnackBar.success(
                          context,
                          'Item removed from your cart',
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

      // =======================================================================
      // CHECKOUT BAR
      // =======================================================================

      bottomNavigationBar: cartItems.isEmpty
          ? null
          : _CheckoutBar(
              total: total,
              itemCount: cartItems.length,
              onCheckout: () {
                _checkout(
                  context,
                  ref,
                  total,
                );
              },
            ),
    );
  }

  // ===========================================================================
  // CHECKOUT
  // ===========================================================================

  Future<void> _checkout(
    BuildContext context,
    WidgetRef ref,
    double total,
  ) async {
    final shouldCheckout = await AppDialog.showConfirm(
      context,
      title: 'Place order?',
      message:
          'Your total is \$${total.toStringAsFixed(2)}. '
          'Would you like to place this order?',
      confirmText: 'Place Order',
      cancelText: 'Cancel',
    );

    if (!shouldCheckout) return;

    final cartItems = ref.read(cartProvider);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      status: OrderStatus.processing,
      items: cartItems
          .map(
            (item) => OrderItem(
              product: item.product,
              quantity: item.quantity,
            ),
          )
          .toList(),
      total: total,
    );

    ref.read(orderProvider.notifier).addOrder(order);

    ref.read(cartProvider.notifier).clearCart();

    if (!context.mounted) return;

    AppSnackBar.success(
      context,
      'Order placed successfully!',
    );
  }
}

// =============================================================================
// EMPTY CART
// =============================================================================

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.brand.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 42,
                color: AppColors.brand,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Your cart is empty',
              style: AppText.heading.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Add some products to your cart '
              'and they will appear here.',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(
                color: AppColors.of(context).muted,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// CART HEADER
// =============================================================================

class _CartHeader extends StatelessWidget {
  final int itemCount;

  const _CartHeader({
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
          style: AppText.label.copyWith(
            color: AppColors.of(context).muted,
            fontSize: 12,
          ),
        ),

        const Spacer(),

        Text(
          'Adjust quantity below',
          style: AppText.label.copyWith(
            color: AppColors.of(context).muted,
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// CART ITEM
// =============================================================================

class _CartItemCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.of(context).line.withOpacity(0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===================================================================
          // PRODUCT IMAGE
          // ===================================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 82,
              height: 82,
              color: AppColors.of(context).bg,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.of(context).muted,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 13),

          // ===================================================================
          // PRODUCT INFO
          // ===================================================================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  product.category.toUpperCase(),
                  style: AppText.label.copyWith(
                    color: AppColors.brand,
                    fontSize: 9.5,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                // Product name
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                // Price
                Row(
                  children: [
                    Text(
                      '\$${product.discountedPrice.toStringAsFixed(2)}',
                      style: AppText.body.copyWith(
                        color: AppColors.brand,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      'each',
                      style: AppText.body.copyWith(
                        color: AppColors.of(context).muted,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 9),

                // Quantity + subtotal
                Row(
                  children: [
                    _QuantityControl(
                      quantity: item.quantity,
                      onDecrement: onDecrement,
                      onIncrement: onIncrement,
                    ),

                    const Spacer(),

                    Text(
                      '\$${(
                        product.discountedPrice *
                        item.quantity
                      ).toStringAsFixed(2)}',
                      style: AppText.heading.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
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
}

// =============================================================================
// QUANTITY CONTROL
// =============================================================================

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.of(context).bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.of(context).line,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MiniButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
          ),

          SizedBox(
            width: 30,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          _MiniButton(
            icon: Icons.add_rounded,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// MINI BUTTON
// =============================================================================

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            icon,
            size: 15,
            color: AppColors.brand,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// CHECKOUT BAR
// =============================================================================

class _CheckoutBar extends StatelessWidget {
  final double total;
  final int itemCount;
  final VoidCallback onCheckout;

  const _CheckoutBar({
    required this.total,
    required this.itemCount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          14,
          20,
          16,
        ),
        decoration: BoxDecoration(
          color: AppColors.of(context).surface,
          border: Border(
            top: BorderSide(
              color: AppColors.of(context).line.withOpacity(0.7),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: AppText.label.copyWith(
                        color: AppColors.of(context).muted,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '$itemCount '
                      '${itemCount == 1 ? 'item' : 'items'}',
                      style: AppText.body.copyWith(
                        color: AppColors.of(context).muted,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: AppText.heading.copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brand,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onCheckout,
                icon: const Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                ),
                label: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}