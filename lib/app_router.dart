import 'package:ecommerce_app/screens/addresses/addresses_screen.dart';
import 'package:ecommerce_app/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/product.dart';

import 'main_shell.dart';
import 'screens/product/product_detail_screen.dart';
import 'screens/product/see_all_products_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/orders/orders_screen.dart';

class AppRoutes {
  static const home = '/';
  static const productDetail = '/product-detail';
  static const seeAll = '/see-all';
  static const wishlist = '/wishlist';
  static const orders = '/orders';
  static const addresses = '/addresses';
  static const settings = '/settings';
}

class SeeAllArgs {
  final String title;
  final List<Product> products;

  const SeeAllArgs({required this.title, required this.products});
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainShell());

      case AppRoutes.productDetail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );

      case AppRoutes.seeAll:
        final args = settings.arguments as SeeAllArgs;
        return MaterialPageRoute(
          builder: (_) => SeeAllProductsScreen(
            title: args.title,
            products: args.products,
          ),
        );

      case AppRoutes.wishlist:
        return MaterialPageRoute(builder: (_) => const WishlistScreen());

      case AppRoutes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case AppRoutes.addresses:
        return MaterialPageRoute(builder: (_) => const AddressesScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}