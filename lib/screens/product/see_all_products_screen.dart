import 'package:ecommerce_app/app_router.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/widgets/common/app_back_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/product_card.dart';

class SeeAllProductsScreen extends StatelessWidget {
  final String title;
  final List<Product> products;

  const SeeAllProductsScreen({
    super.key,
    required this.title,
    required this.products,
  });

  bool _isDesktop(BuildContext context) {
    return kIsWeb || MediaQuery.sizeOf(context).width >= 1024;
  }

  int _gridColumns(double width) {
    if (width >= 1400) return 5;
    if (width >= 1100) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = _isDesktop(context);
    final crossAxisCount = _gridColumns(screenWidth);

    return Scaffold(
      backgroundColor: AppColors.of(context).bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const AppBackButton(
                    overlay: true,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: AppText.heading.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Text(
                        'No products found',
                        style: AppText.body.copyWith(
                          color: AppColors.of(context).muted,
                        ),
                      ),
                    )
                  : Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isDesktop ? 1400 : double.infinity,
                        ),
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 14,
                            childAspectRatio: isDesktop ? 0.72 : 0.60,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];

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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}