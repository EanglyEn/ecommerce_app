import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../theme.dart';
import '../../widgets/common/app_back_button.dart';

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
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 340,
            backgroundColor: AppColors.bg,
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
                child: Hero(
                  tag: 'product-image-${product.id}',
                  child: Container(
                    color: AppColors.surface,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
                            color: AppColors.muted,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10
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
                              decoration:
                                  TextDecoration.lineThrough,
                              color: AppColors.muted,
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
                              borderRadius:
                                  BorderRadius.circular(8),
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
                        color: AppColors.ink.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Text(
                          'QUANTITY',
                          style: AppText.label.copyWith(
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const Spacer(),

                        QuantityStepper(
                          quantity: _quantity,
                          onDecrement: () {
                            if (_quantity > 1) {
                              setState(() {
                                _quantity--;
                              });
                            }
                          },
                          onIncrement: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            16,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
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
              icon: const Icon(
                Icons.add_shopping_cart_rounded,
                size: 20,
              ),

              onPressed: () {
                ref
                    .read(cartProvider.notifier)
                    .addProduct(
                      product,
                      quantity: _quantity,
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.ink,
                    margin: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${product.name} added to cart',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },

              label: Text(
                'Add to Cart · \$${(
                  product.discountedPrice * _quantity
                ).toStringAsFixed(2)}',
              ),
            ),
          ),
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
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.line,
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

  const QuantityStepButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.brand,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(
            icon,
            size: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}