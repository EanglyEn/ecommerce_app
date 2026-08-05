import 'package:ecommerce_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  Widget _placeholder({
    required double height,
    double? width,
    double radius = 10,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.of(context).surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.black.withOpacity(0.035),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _placeholder(
              height: 175,
              width: double.infinity,
              radius: 14,
            ),

            const SizedBox(height: 12),

            _placeholder(
              height: 14,
              width: double.infinity,
              radius: 6,
            ),

            const SizedBox(height: 8),

            _placeholder(
              height: 12,
              width: 90,
              radius: 6,
            ),

            const Spacer(),

            _placeholder(
              height: 18,
              width: 65,
              radius: 6,
            ),
          ],
        ),
      ),
    );
  }
}