import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

const Map<String, IconData> categoryIcons = {
  'All': Icons.apps_rounded,
  'Electronics': Icons.headphones_rounded,
  'Footwear': Icons.directions_run_rounded,
  'Accessories': Icons.watch_rounded,
  'Home': Icons.chair_rounded,
  'Fitness': Icons.fitness_center_rounded,
};
final productListProvider = Provider<List<Product>>((ref) {
  return const [
    Product(
      id: 'p1',
      name: 'Wireless Headphones',
      description:
          'Over-ear headphones with active noise cancellation, 30-hour battery life, and plush memory-foam ear cups for all-day comfort.',
      price: 49.99,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=85',
      category: 'Electronics',
      rating: 4.6,
      discountPercent: 15,
    ),

    Product(
      id: 'p2',
      name: 'Running Shoes',
      description:
          'Lightweight breathable mesh shoes built for daily running, with responsive cushioning and a durable rubber outsole.',
      price: 65.00,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=85',
      category: 'Footwear',
      rating: 4.3,
    ),

    Product(
      id: 'p3',
      name: 'Smart Watch',
      description:
          'Fitness tracking smart watch with heart rate sensor, sleep tracking, and 7-day battery life. Water resistant up to 50m.',
      price: 89.99,
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=85',
      category: 'Electronics',
      rating: 4.8,
      discountPercent: 10,
    ),

    Product(
      id: 'p4',
      name: 'Backpack',
      description:
          'Water-resistant backpack with a padded 15" laptop compartment, USB charging port, and anti-theft zippers.',
      price: 34.50,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=800&q=85',
      category: 'Accessories',
      rating: 4.4,
    ),

    Product(
      id: 'p5',
      name: 'Sunglasses',
      description:
          'UV400-protection polarized sunglasses with a lightweight titanium frame and scratch-resistant lenses.',
      price: 19.99,
      imageUrl:
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=800&q=85',
      category: 'Accessories',
      rating: 4.1,
      discountPercent: 20,
    ),

    Product(
      id: 'p6',
      name: 'Coffee Maker',
      description:
          'Compact drip coffee maker with a reusable filter, 10-cup capacity, and auto shut-off for home or office use.',
      price: 42.00,
      imageUrl:
          'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?auto=format&fit=crop&w=800&q=85',
      category: 'Home',
      rating: 4.5,
    ),

    Product(
      id: 'p7',
      name: 'Desk Lamp',
      description:
          'Adjustable LED desk lamp with 5 brightness levels, touch control, and a built-in USB charging port.',
      price: 27.99,
      imageUrl:
          'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=85',
      category: 'Home',
      rating: 4.2,
    ),

    Product(
      id: 'p8',
      name: 'Yoga Mat',
      description:
          'Non-slip extra-thick yoga mat with carrying strap, made from eco-friendly TPE material.',
      price: 24.99,
      imageUrl:
          'https://images.unsplash.com/photo-1601925228186-3d3d5a5e5c4e?auto=format&fit=crop&w=800&q=85',
      category: 'Fitness',
      rating: 4.7,
      discountPercent: 12,
    ),
  ];
});

/// All distinct categories, with "All" prepended.
final categoryListProvider = Provider<List<String>>((ref) {
  final products = ref.watch(productListProvider);
  final categories = products.map((p) => p.category).toSet().toList()..sort();
  return ['All', ...categories];
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductListProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productListProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final category = ref.watch(selectedCategoryProvider);

  return products.where((p) {
    final matchesCategory = category == 'All' || p.category == category;
    final matchesQuery = query.isEmpty ||
        p.name.toLowerCase().contains(query) ||
        p.category.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }).toList();
});
