import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  static const Color _baseColor = Color(0xFFE9E9ED);
  static const Color _highlightColor = Color(0xFFF7F7F8);

  Widget _skeleton({
    double? width,
    required double height,
    double radius = 12,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _baseColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      period: const Duration(milliseconds: 1500),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ============================================================
          // HEADER
          // ============================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                0,
              ),
              child: Row(
                children: [
                  _skeleton(
                    width: 44,
                    height: 44,
                    radius: 22,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _skeleton(
                          width: 60,
                          height: 9,
                          radius: 5,
                        ),
                        const SizedBox(height: 7),
                        _skeleton(
                          width: 145,
                          height: 13,
                          radius: 6,
                        ),
                      ],
                    ),
                  ),

                  _skeleton(
                    width: 44,
                    height: 44,
                    radius: 15,
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // SEARCH
          // ============================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                0,
              ),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: _baseColor,
                  borderRadius:
                      BorderRadius.circular(17),
                ),
              ),
            ),
          ),

          // ============================================================
          // PROMO CARD
          // ============================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                0,
              ),
              child: Container(
                height: 158,
                decoration: BoxDecoration(
                  color: _baseColor,
                  borderRadius:
                      BorderRadius.circular(23),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 18,
                      child: _skeleton(
                        width: 82,
                        height: 20,
                        radius: 10,
                      ),
                    ),

                    Positioned(
                      left: 20,
                      bottom: 50,
                      child: _skeleton(
                        width: 125,
                        height: 20,
                        radius: 7,
                      ),
                    ),

                    Positioned(
                      left: 20,
                      bottom: 28,
                      child: _skeleton(
                        width: 175,
                        height: 11,
                        radius: 6,
                      ),
                    ),

                    Positioned(
                      left: 20,
                      bottom: 12,
                      child: _skeleton(
                        width: 65,
                        height: 8,
                        radius: 5,
                      ),
                    ),

                    Positioned(
                      right: 22,
                      bottom: 18,
                      child: _skeleton(
                        width: 85,
                        height: 85,
                        radius: 42,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ============================================================
          // PAGE INDICATOR
          // ============================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 11,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  _skeleton(
                    width: 20,
                    height: 5,
                    radius: 4,
                  ),
                  const SizedBox(width: 5),
                  _skeleton(
                    width: 6,
                    height: 5,
                    radius: 4,
                  ),
                  const SizedBox(width: 5),
                  _skeleton(
                    width: 6,
                    height: 5,
                    radius: 4,
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // CATEGORIES
          // ============================================================

          SliverToBoxAdapter(
            child: SizedBox(
              height: 125,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  22,
                  16,
                  0,
                ),
                scrollDirection: Axis.horizontal,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: 6,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  return SizedBox(
                    width: 68,
                    child: Column(
                      children: [
                        _skeleton(
                          width: 58,
                          height: 58,
                          radius: 19,
                        ),
                        const SizedBox(height: 8),
                        _skeleton(
                          width: index.isEven
                              ? 48
                              : 38,
                          height: 9,
                          radius: 5,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // ============================================================
          // SECTION HEADER
          // ============================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                15,
              ),
              child: Row(
                children: [
                  _skeleton(
                    width: 34,
                    height: 34,
                    radius: 11,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _skeleton(
                          width: 145,
                          height: 16,
                          radius: 7,
                        ),
                        const SizedBox(height: 6),
                        _skeleton(
                          width: 90,
                          height: 9,
                          radius: 5,
                        ),
                      ],
                    ),
                  ),

                  _skeleton(
                    width: 48,
                    height: 11,
                    radius: 5,
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // PRODUCTS
          // ============================================================

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              30,
            ),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 14,
                childAspectRatio: 0.60,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  return const _IOSProductSkeleton();
                },
                childCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IOSProductSkeleton extends StatelessWidget {
  const _IOSProductSkeleton();

  Widget _box({
    double? width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: HomeSkeleton._baseColor,
        borderRadius:
            BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // Product image
        AspectRatio(
          aspectRatio: 0.86,
          child: Container(
            decoration: BoxDecoration(
              color: HomeSkeleton._baseColor,
              borderRadius:
                  BorderRadius.circular(18),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Product name
        _box(
          width: double.infinity,
          height: 13,
          radius: 6,
        ),

        const SizedBox(height: 7),

        // Product name second line
        _box(
          width: 95,
          height: 11,
          radius: 6,
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            // Price
            _box(
              width: 60,
              height: 15,
              radius: 6,
            ),

            const Spacer(),

            // Rating
            _box(
              width: 34,
              height: 12,
              radius: 6,
            ),
          ],
        ),
      ],
    );
  }
}
