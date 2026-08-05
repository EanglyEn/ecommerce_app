import 'package:ecommerce_app/models/product.dart';

enum OrderStatus { processing, shipped, delivered, cancelled }

class OrderItem {
  final Product product;
  final int quantity;

  const OrderItem({
    required this.product,
    required this.quantity,
  });
}

class Order {
  final String id;
  final DateTime date;
  final OrderStatus status;
  final List<OrderItem> items;
  final double total;

  const Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.total,
  });
}