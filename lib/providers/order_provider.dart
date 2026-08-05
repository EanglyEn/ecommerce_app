import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/models/order.dart';

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);

  void addOrder(Order order) {
    state = [order, ...state];
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>(
  (ref) => OrderNotifier(),
);