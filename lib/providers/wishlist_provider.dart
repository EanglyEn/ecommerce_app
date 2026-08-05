import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/models/product.dart';

class WishlistNotifier extends StateNotifier<List<Product>> {
  WishlistNotifier() : super([]);

  bool isWishlisted(Product product) {
    return state.any((p) => p.id == product.id);
  }

  void toggle(Product product) {
    if (isWishlisted(product)) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  void remove(Product product) {
    state = state.where((p) => p.id != product.id).toList();
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<Product>>(
  (ref) => WishlistNotifier(),
);