import 'package:ecommerce_app/screens/notification/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/product.dart';

import 'main_shell.dart';

import 'screens/product/product_detail_screen.dart';
import 'screens/product/see_all_products_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/addresses/addresses_screen.dart';
import 'screens/settings/settings_screen.dart';

class AppRoutes {
  static const home = '/';
  static const productDetail = '/product-detail';
  static const seeAll = '/see-all';
  static const wishlist = '/wishlist';
  static const orders = '/orders';
  static const addresses = '/addresses';
  static const settings = '/settings';
  static const notifications = '/notifications';
}

class SeeAllArgs {
  final String title;
  final List<Product> products;

  const SeeAllArgs({
    required this.title,
    required this.products,
  });
}

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ============================================================
      // HOME
      // ============================================================
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const MainShell(),
        );

      // ============================================================
      // PRODUCT DETAIL
      // ============================================================
      case AppRoutes.productDetail:
        final product = settings.arguments as Product;

        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(
            product: product,
          ),
        );

      // ============================================================
      // SEE ALL PRODUCTS
      // ============================================================
      case AppRoutes.seeAll:
        final args = settings.arguments as SeeAllArgs;

        return MaterialPageRoute(
          builder: (_) => SeeAllProductsScreen(
            title: args.title,
            products: args.products,
          ),
        );

      // ============================================================
      // WISHLIST
      // ============================================================
      case AppRoutes.wishlist:
        return MaterialPageRoute(
          builder: (_) => const WishlistScreen(),
        );

      // ============================================================
      // ORDERS
      // ============================================================
      case AppRoutes.orders:
        return MaterialPageRoute(
          builder: (_) => const OrdersScreen(),
        );

      // ============================================================
      // ADDRESSES
      // ============================================================
      case AppRoutes.addresses:
        return MaterialPageRoute(
          builder: (_) => const AddressesScreen(),
        );

      // ============================================================
      // SETTINGS
      // ============================================================
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      // ============================================================
      // NOTIFICATIONS
      // ============================================================
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        );

      // ============================================================
      // UNKNOWN ROUTE
      // ============================================================
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                'Route not found',
              ),
            ),
          ),
        );
    }
  }
}