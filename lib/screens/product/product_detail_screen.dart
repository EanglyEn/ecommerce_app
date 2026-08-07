// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../theme.dart';
import '../../widgets/common/app_back_button.dart';
import '../../widgets/common/app_dialog.dart';
import '../../widgets/common/app_snack_bar.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends ConsumerState<ProductDetailScreen> {
  bool _isDesktop(BuildContext context) {
    return kIsWeb || MediaQuery.sizeOf(context).width >= 1024;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final cartItems = ref.watch(cartProvider);

    final existingItem = cartItems.cast<dynamic>().firstWhere(
          (item) => item.product.id == product.id,
          orElse: () => null,
        );

    final bool isInCart = existingItem != null;
    final int quantity = existingItem?.quantity ?? 0;

    final isDesktop = _isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.of(context).bg,
      body: isDesktop
          ? _buildDesktopLayout(context, product, quantity, isInCart)
          : _buildMobileLayout(context, product, quantity, isInCart),
      bottomNavigationBar: isDesktop
          ? null
          : _buildAddToCartBar(context, product, quantity, isInCart),
    );
  }

  // ===========================================================================
  // MOBILE / TABLET LAYOUT (unchanged)
  // ===========================================================================

  Widget _buildMobileLayout(
    BuildContext context,
    Product product,
    int quantity,
    bool isInCart,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 340,
          backgroundColor: AppColors.of(context).bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: const Padding(
            padding: EdgeInsets.all(10),
            child: AppBackButton(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              child: _ProductImage(product: product),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.of(context).surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                0,
              ),
              child: _ProductInfo(
                product: product,
                quantity: quantity,
                isInCart: isInCart,
                onDecrement: () => _decreaseQuantity(quantity),
                onIncrement: () => _increaseQuantity(quantity),
                trailingSpace: 120,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // DESKTOP / WEB LAYOUT — image left, details right, no bottom bar
  // ===========================================================================

  Widget _buildDesktopLayout(
    BuildContext context,
    Product product,
    int quantity,
    bool isInCart,
  ) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBackButton(),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===================================================
                      // IMAGE
                      // ===================================================
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: _ProductImage(product: product),
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),

                      // ===================================================
                      // DETAILS
                      // ===================================================
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          child: _ProductInfo(
                            product: product,
                            quantity: quantity,
                            isInCart: isInCart,
                            onDecrement: () =>
                                _decreaseQuantity(quantity),
                            onIncrement: () =>
                                _increaseQuantity(quantity),
                            trailingSpace: 28,
                            showAddToCartButton: true,
                            onAddToCart: quantity == 0
                                ? () => _increaseQuantity(0)
                                : null,
                          ),
                        ),
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

  // ===========================================================================
  // BOTTOM ADD-TO-CART BAR (mobile only)
  // ===========================================================================

  Widget _buildAddToCartBar(
    BuildContext context,
    Product product,
    int quantity,
    bool isInCart,
  ) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          16,
        ),
        decoration: BoxDecoration(
          color: AppColors.of(context).surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            icon: Icon(
              isInCart
                  ? Icons.shopping_cart_rounded
                  : Icons.add_shopping_cart_rounded,
              size: 20,
            ),
            onPressed: quantity == 0
                ? () => _increaseQuantity(0)
                : null,
            label: Text(
              quantity == 0
                  ? 'Add to Cart'
                  : isInCart
                      ? 'In Cart · \$${(
                          product.discountedPrice * quantity
                        ).toStringAsFixed(2)}'
                      : 'Add to Cart · \$${(
                          product.discountedPrice * quantity
                        ).toStringAsFixed(2)}',
            ),
          ),
        ),
      ),
    );
  }

  void _increaseQuantity(int currentQuantity) {
    final product = widget.product;

    if (currentQuantity == 0) {
      ref.read(cartProvider.notifier).addProduct(product);

      AppSnackBar.success(
        context,
        '${product.name} added to cart',
      );
      return;
    }

    ref.read(cartProvider.notifier).incrementQuantity(product.id);
  }

  Future<void> _decreaseQuantity(int currentQuantity) async {
    if (currentQuantity <= 0) return;

    if (currentQuantity > 1) {
      ref.read(cartProvider.notifier).decrementQuantity(widget.product.id);
      return;
    }

    final shouldRemove = await AppDialog.showConfirm(
      context,
      title: 'Remove item?',
      message:
          'This is the last item in your cart. Do you want to remove "${widget.product.name}"?',
      confirmText: 'Remove',
      cancelText: 'Keep',
    );

    if (!shouldRemove || !mounted) return;

    ref.read(cartProvider.notifier).removeProduct(widget.product.id);

    AppSnackBar.success(
      context,
      'Item removed from your cart',
    );
  }
}

// =============================================================================
// PRODUCT IMAGE (shared between mobile/desktop layouts)
// =============================================================================

class _ProductImage extends StatelessWidget {
  final Product product;

  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product-image-${product.id}',
      child: Container(
        color: AppColors.of(context).surface,
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 50,
                color: AppColors.of(context).muted,
              ),
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// PRODUCT INFO (shared between mobile/desktop layouts)
// =============================================================================

class _ProductInfo extends StatelessWidget {
  final Product product;
  final int quantity;
  final bool isInCart;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final double trailingSpace;
  final bool showAddToCartButton;
  final VoidCallback? onAddToCart;

  const _ProductInfo({
    required this.product,
    required this.quantity,
    required this.isInCart,
    required this.onDecrement,
    required this.onIncrement,
    this.trailingSpace = 0,
    this.showAddToCartButton = false,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.brand.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                product.category,
                style: AppText.label.copyWith(
                  color: AppColors.brand,
                  fontSize: 11.5,
                ),
              ),
            ),

            const Spacer(),

            const Icon(
              Icons.star_rounded,
              color: AppColors.amber,
              size: 18,
            ),

            const SizedBox(width: 3),

            Text(
              '${product.rating}',
              style: AppText.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Text(
          product.name,
          style: AppText.heading.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '\$${product.discountedPrice.toStringAsFixed(2)}',
              style: AppText.heading.copyWith(
                fontSize: 24,
                color: AppColors.brand,
                fontWeight: FontWeight.w800,
              ),
            ),

            if (product.hasDiscount) ...[
              const SizedBox(width: 10),

              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: AppText.body.copyWith(
                  fontSize: 15,
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.of(context).muted,
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brand,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '-${product.discountPercent}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 22),
        Text(
          'DESCRIPTION',
          style: AppText.label.copyWith(
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          product.description,
          style: AppText.body.copyWith(
            fontSize: 14,
            color: AppColors.of(context).ink.withOpacity(0.7),
            height: 1.5,
          ),
        ),

        const SizedBox(height: 28),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUANTITY',
                  style: AppText.label.copyWith(
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  isInCart ? 'In your cart' : 'Choose quantity',
                  style: AppText.body.copyWith(
                    color: AppColors.of(context).muted,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),

            const Spacer(),

            QuantityStepper(
              quantity: quantity,
              onDecrement: onDecrement,
              onIncrement: onIncrement,
            ),
          ],
        ),

        if (showAddToCartButton) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              icon: Icon(
                isInCart
                    ? Icons.shopping_cart_rounded
                    : Icons.add_shopping_cart_rounded,
                size: 20,
              ),
              onPressed: onAddToCart,
              label: Text(
                quantity == 0
                    ? 'Add to Cart'
                    : isInCart
                        ? 'In Cart · \$${(
                            product.discountedPrice * quantity
                          ).toStringAsFixed(2)}'
                        : 'Add to Cart · \$${(
                            product.discountedPrice * quantity
                          ).toStringAsFixed(2)}',
              ),
            ),
          ),
        ],

        SizedBox(height: trailingSpace),
      ],
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
            enabled: quantity > 0,
          ),

          SizedBox(
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
  final bool enabled;

  const QuantityStepButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? AppColors.brand
          : AppColors.of(context).line,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(
            icon,
            size: 15,
            color: enabled
                ? Colors.white
                : AppColors.of(context).muted,
          ),
        ),
      ),
    );
  }
}