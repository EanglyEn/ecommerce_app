import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProduct(Product product, {int quantity = 1}) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final updated = [...state];
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + quantity,
      );
      state = updated;
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void incrementQuantity(String productId) {
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ];
  }

  void decrementQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;
    final item = state[index];
    if (item.quantity <= 1) {
      removeProduct(productId);
    } else {
      final updated = [...state];
      updated[index] = item.copyWith(quantity: item.quantity - 1);
      state = updated;
    }
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, item) => sum + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, item) => sum + item.quantity);
});
