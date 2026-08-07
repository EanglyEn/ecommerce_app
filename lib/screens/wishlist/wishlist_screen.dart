import 'package:ecommerce_app/app_router.dart';
import 'package:ecommerce_app/widgets/common/app_back_button.dart';
import 'package:ecommerce_app/widgets/common/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // =============================================================
            // HEADER
            // =============================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                14,
              ),
              child: Row(
                children: [
                  const AppBackButton(
                    overlay: true,
                  ),

                  const SizedBox(width: 12),

                  Text(
                    'Wishlist',
                    style: AppText.heading.copyWith(
                      color: colors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // =============================================================
            // CONTENT
            // =============================================================
            Expanded(
              child: wishlist.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.favorite_border_rounded,
                      title: 'Your wishlist is empty',
                      message:
                          'Products you love will appear here.',
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        30,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.60,
                      ),
                      itemCount: wishlist.length,
                      itemBuilder: (context, index) {
                        final product = wishlist[index];

                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.productDetail,
                              arguments: product,
                            );
                          },
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