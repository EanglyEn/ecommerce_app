import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../theme.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    dynamic cartItem;

    for (final item in cartItems) {
      if (item.product.id == product.id) {
        cartItem = item;
        break;
      }
    }

    final bool isInCart = cartItem != null;
    final int quantity = isInCart ? cartItem.quantity : 0;

    final bool isWishlisted = ref.watch(
      wishlistProvider.select(
        (wishlist) => wishlist.any((p) => p.id == product.id),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.of(context).surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.of(context).line.withOpacity(0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.of(context).bg,
                          AppColors.of(context).surface,
                        ],
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'product-image-${product.id}',
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (
                            context,
                            child,
                            progress,
                          ) {
                            if (progress == null) {
                              return child;
                            }

                            return Container(
                              color: AppColors.of(context).bg,
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.brand,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              color: AppColors.of(context).bg,
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 30,
                                  color: AppColors.of(context).muted,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.brand,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brand.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '-${product.discountPercent}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _PressableScale(
                      onTap: () {
                        ref.read(wishlistProvider.notifier).toggle(product);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.32),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWishlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isWishlisted ? Colors.red : Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                          alignment: Alignment.centerRight,
                          clipBehavior: Clip.none,
                          children: [
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },
                      transitionBuilder: (
                        child,
                        animation,
                      ) {
                        return ScaleTransition(
                          scale: animation,
                          alignment: Alignment.centerRight,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: isInCart
                          ? QuantityStepper(
                              key: ValueKey(
                                'quantity-${product.id}',
                              ),
                              quantity: quantity,
                              onDecrement: () {
                                if (quantity > 1) {
                                  ref
                                      .read(cartProvider.notifier)
                                      .decrementQuantity(product.id);
                                } else {
                                  ref
                                      .read(cartProvider.notifier)
                                      .removeProduct(product.id);
                                }
                              },
                              onIncrement: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .incrementQuantity(product.id);
                              },
                            )
                          : _AddButton(
                              key: ValueKey(
                                'add-${product.id}',
                              ),
                              onTap: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .addProduct(product);
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                12,
                9,
                12,
                11,
              ),
              decoration: BoxDecoration(
                color: AppColors.of(context).surface,
                border: Border(
                  top: BorderSide(
                    color: AppColors.of(context).line.withOpacity(0.35),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: AppText.label.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.of(context).muted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          product.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.label.copyWith(
                            color: AppColors.of(context).muted,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                        style: AppText.heading.copyWith(
                          fontSize: 16,
                          color: AppColors.brand,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppText.body.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.of(context).muted,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ],
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

class _PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableScale({
    required this.child,
    required this.onTap,
  });

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.86 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _PressableScale(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.brand,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.brand.withOpacity(0.35),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).bg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.of(context).line,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuantityStepButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (
              child,
              animation,
            ) {
              final slide = Tween<Offset>(
                begin: const Offset(0, 0.4),
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(
                position: slide,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: SizedBox(
              key: ValueKey(quantity),
              width: 36,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          QuantityStepButton(
            icon: Icons.add_rounded,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

class QuantityStepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const QuantityStepButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _PressableScale(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: AppColors.brand,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}