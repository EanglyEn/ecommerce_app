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
      id: 'p9',
      name: 'Bluetooth Speaker',
      description:
          'Portable wireless Bluetooth speaker with powerful stereo sound, deep bass, and up to 18 hours of battery life.',
      price: 39.99,
      imageUrl:
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=800&q=85',
      category: 'Electronics',
      rating: 4.5,
      discountPercent: 12,
    ),

    Product(
      id: 'p10',
      name: 'Wireless Keyboard',
      description:
          'Slim wireless keyboard with quiet low-profile keys, comfortable typing experience, and long-lasting battery.',
      price: 35.99,
      imageUrl:
          'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=85',
      category: 'Electronics',
      rating: 4.4,
    ),

    Product(
      id: 'p11',
      name: 'Wireless Mouse',
      description:
          'Ergonomic wireless mouse with adjustable DPI, silent clicks, precise tracking, and comfortable all-day use.',
      price: 22.99,
      imageUrl:
          'https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=800&q=85',
      category: 'Electronics',
      rating: 4.3,
      discountPercent: 8,
    ),

    Product(
      id: 'p12',
      name: 'Portable Power Bank',
      description:
          'Compact 20,000mAh power bank with fast USB-C charging and multiple ports for phones, tablets, and accessories.',
      price: 29.99,
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1674761263682-2a11ae45744c?q=80&w=735&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      category: 'Electronics',
      rating: 4.6,
      discountPercent: 15,
    ),

    Product(
      id: 'p13',
      name: 'Tablet',
      description:
          'Slim 10-inch tablet designed for entertainment, browsing, reading, video calls, and everyday productivity.',
      price: 159.99,
      imageUrl:
          'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=85',
      category: 'Electronics',
      rating: 4.7,
    ),

    // ========================================================================
    // FOOTWEAR
    // ========================================================================

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
      id: 'p14',
      name: 'Classic Sneakers',
      description:
          'Minimal everyday sneakers with a clean silhouette, cushioned footbed, and durable rubber sole.',
      price: 55.00,
      imageUrl:
          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=800&q=85',
      category: 'Footwear',
      rating: 4.5,
      discountPercent: 10,
    ),

    Product(
      id: 'p15',
      name: 'Training Shoes',
      description:
          'Stable training shoes designed for gym workouts, strength training, cardio, and daily movement.',
      price: 72.50,
      imageUrl:
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=800&q=85',
      category: 'Footwear',
      rating: 4.6,
    ),

    Product(
      id: 'p16',
      name: 'Casual Canvas Shoes',
      description:
          'Lightweight canvas shoes with a comfortable padded insole and flexible outsole for everyday wear.',
      price: 39.99,
      imageUrl:
          'https://images.unsplash.com/photo-1495555961986-6d4c1ecb7be3?auto=format&fit=crop&w=800&q=85',
      category: 'Footwear',
      rating: 4.2,
      discountPercent: 18,
    ),

    // ========================================================================
    // ACCESSORIES
    // ========================================================================

    Product(
      id: 'p4',
      name: 'Backpack',
      description:
          'Water-resistant backpack with a padded 15-inch laptop compartment, USB charging port, and anti-theft zippers.',
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
      id: 'p17',
      name: 'Leather Wallet',
      description:
          'Slim genuine leather wallet with multiple card slots, a cash compartment, and a compact everyday design.',
      price: 24.99,
      imageUrl:
          'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=800&q=85',
      category: 'Accessories',
      rating: 4.5,
      discountPercent: 10,
    ),

    Product(
      id: 'p18',
      name: 'Classic Wrist Watch',
      description:
          'Elegant everyday wrist watch with a minimalist dial, stainless steel case, and comfortable leather strap.',
      price: 79.99,
      imageUrl:
          'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&w=800&q=85',
      category: 'Accessories',
      rating: 4.7,
    ),

    // ========================================================================
    // HOME
    // ========================================================================

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
      id: 'p19',
      name: 'Modern Chair',
      description:
          'Comfortable modern accent chair with a supportive backrest and soft upholstery for living rooms and bedrooms.',
      price: 119.99,
      imageUrl:
          'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=800&q=85',
      category: 'Home',
      rating: 4.6,
      discountPercent: 12,
    ),

    Product(
      id: 'p20',
      name: 'Ceramic Vase',
      description:
          'Minimal ceramic decorative vase with a modern finish, perfect for flowers, shelves, tables, and home decoration.',
      price: 18.99,
      imageUrl:
          'https://images.unsplash.com/photo-1581783898377-1c85bf937427?auto=format&fit=crop&w=800&q=85',
      category: 'Home',
      rating: 4.3,
    ),

    // ========================================================================
    // FITNESS
    // ========================================================================

    Product(
      id: 'p8',
      name: 'Yoga Mat',
      description:
          'Non-slip extra-thick yoga mat with carrying strap, made from eco-friendly TPE material.',
      price: 24.99,
      imageUrl:
          'https://images.unsplash.com/photo-1599447421416-3414500d18a5?auto=format&fit=crop&w=800&q=85',
      category: 'Fitness',
      rating: 4.7,
      discountPercent: 12,
    ),

    Product(
      id: 'p21',
      name: 'Dumbbell Set',
      description:
          'Adjustable dumbbell set suitable for strength training, home workouts, and full-body fitness routines.',
      price: 59.99,
      imageUrl:
          'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?auto=format&fit=crop&w=800&q=85',
      category: 'Fitness',
      rating: 4.6,
      discountPercent: 10,
    ),

    Product(
      id: 'p22',
      name: 'Resistance Bands',
      description:
          'Set of durable resistance bands with different tension levels for strength training, stretching, and mobility.',
      price: 16.99,
      imageUrl:
          'https://images.unsplash.com/photo-1598289431512-b97b0917affc?auto=format&fit=crop&w=800&q=85',
      category: 'Fitness',
      rating: 4.4,
    ),

    Product(
      id: 'p23',
      name: 'Fitness Bottle',
      description:
          'Large reusable sports water bottle with leak-resistant lid, measurement markings, and easy-carry handle.',
      price: 14.99,
      imageUrl:
          'https://images.unsplash.com/photo-1602143407151-7111542de6e8?auto=format&fit=crop&w=800&q=85',
      category: 'Fitness',
      rating: 4.5,
      discountPercent: 15,
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
        p.category.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query);

    return matchesCategory && matchesQuery;
  }).toList();
});
