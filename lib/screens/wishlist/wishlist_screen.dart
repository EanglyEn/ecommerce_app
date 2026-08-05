import 'package:ecommerce_app/app_router.dart';
import 'package:ecommerce_app/widgets/common/app_back_button.dart';
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

    return Scaffold(
      backgroundColor: AppColors.of(context).bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Row(
                children: [
                  const AppBackButton(
                    overlay: true,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Wishlist',
                    style: AppText.heading.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: wishlist.isEmpty
                  ? Center(
                      child: Text(
                        'Your wishlist is empty',
                        style: AppText.body.copyWith(color: AppColors.of(context).muted),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
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