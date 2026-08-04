import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/product_provider.dart';
import '../../theme.dart';

class CategoriesScreen extends ConsumerWidget {
  final ValueChanged<int> onGoToHome;

  const CategoriesScreen({super.key, required this.onGoToHome});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.3,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final icon = categoryIcons[category] ?? Icons.category_rounded;
          return GestureDetector(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = category;
              onGoToHome(0);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.brand.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: AppColors.brand, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(category, style: AppText.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
