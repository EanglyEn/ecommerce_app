import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cart_provider.dart';
import '../../theme.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.brand.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined,
                        size: 40, color: AppColors.brand),
                  ),
                  const SizedBox(height: 16),
                  Text('Your cart is empty',
                      style: AppText.heading.copyWith(fontSize: 17)),
                  const SizedBox(height: 4),
                  Text('Add items to get started',
                      style:
                          AppText.body.copyWith(color: AppColors.muted, fontSize: 13)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Dismissible(
                  key: ValueKey(item.product.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => ref
                      .read(cartProvider.notifier)
                      .removeProduct(item.product.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                      color: AppColors.brand,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            item.product.imageUrl,
                            width: 68,
                            height: 68,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported_outlined,
                                    color: AppColors.muted),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.body.copyWith(
                                    fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.product.discountedPrice.toStringAsFixed(2)} each',
                                style: AppText.body.copyWith(
                                    color: AppColors.muted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _MiniButton(
                                icon: Icons.remove_rounded,
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .decrementQuantity(item.product.id),
                              ),
                              SizedBox(
                                width: 22,
                                child: Text(
                                  '${item.quantity}',
                                  textAlign: TextAlign.center,
                                  style: AppText.body
                                      .copyWith(fontWeight: FontWeight.w800, fontSize: 13),
                                ),
                              ),
                              _MiniButton(
                                icon: Icons.add_rounded,
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .incrementQuantity(item.product.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppText.label.copyWith(fontSize: 13)),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: AppText.heading.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.ink,
                              content: const Text('Order placed successfully!'),
                            ),
                          );
                        },
                        child: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MiniButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 28,
        height: 28,
        child: Icon(icon, size: 14, color: AppColors.brand),
      ),
    );
  }
}
