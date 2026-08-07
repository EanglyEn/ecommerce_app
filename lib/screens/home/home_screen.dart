// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:ecommerce_app/widgets/common/app_empty_state.dart';
import 'package:ecommerce_app/widgets/skeleton_view/home_skeleton.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/product_provider.dart';
import '../../theme.dart';
import '../../widgets/product_card.dart';
import '../../app_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final PageController _promoController;

  Timer? _promoTimer;

  int _currentPromo = 0;

  bool _isLoading = true;

  final List<_PromoData> _promos = const [
    _PromoData(
      title: 'Flash Sale',
      subtitle: 'Up to 20% off electronics',
      buttonText: 'Shop now',
      color: AppColors.brand,
      icon: Icons.bolt_rounded,
    ),
    _PromoData(
      title: 'Free Shipping',
      subtitle: 'On orders over \$50',
      buttonText: 'Explore',
      color: Color(0xFF2878E8),
      icon: Icons.local_shipping_rounded,
    ),
    _PromoData(
      title: 'New Arrivals',
      subtitle: 'Fresh picks every week',
      buttonText: 'Discover',
      color: Color(0xFF8E4BD8),
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _promoController = PageController(
      viewportFraction: 0.94,
      initialPage: 1000,
    );

    _startPromoAutoScroll();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    });
  }

  void _startPromoAutoScroll() {
    _promoTimer = Timer.periodic(
      const Duration(milliseconds: 3500),
      (_) {
        if (!_promoController.hasClients) return;

        _promoController.nextPage(
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
        );
      },
    );
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }

  void _onPromoChanged(int page) {
    setState(() {
      _currentPromo = page % _promos.length;
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 5) {
      return 'Good night';
    } else if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else if (hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  // ===========================================================================
  // RESPONSIVE HELPERS (web/desktop gets more columns + centered max width)
  // ===========================================================================

  bool _isDesktop(BuildContext context) {
    return kIsWeb || MediaQuery.sizeOf(context).width >= 1024;
  }

  int _gridColumns(double width) {
    if (width >= 1400) return 5;
    if (width >= 1100) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredProductListProvider);
    final categories = ref.watch(categoryListProvider);
    final selectedCategory = ref.watch(
      selectedCategoryProvider,
    );

    final colors = AppColors.of(context);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = _isDesktop(context);
    final crossAxisCount = _gridColumns(screenWidth);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const HomeSkeleton()
            : Center(
                child: ConstrainedBox(
                  // On web/desktop, cap content width so it doesn't
                  // stretch edge-to-edge on ultra-wide screens.
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1400 : double.infinity,
                  ),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildHeader(context),
                      ),
                      SliverToBoxAdapter(
                        child: _buildSearch(context),
                      ),
                      SliverToBoxAdapter(
                        child: _buildPromoCarousel(context),
                      ),
                      SliverToBoxAdapter(
                        child: _buildCategories(
                          context,
                          categories,
                          selectedCategory,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _buildProductsHeader(
                          context,
                          selectedCategory,
                        ),
                      ),
                      products.isEmpty
                          ? const SliverFillRemaining(
                              hasScrollBody: false,
                              child: AppEmptyState(
                                icon: Icons.search_off_rounded,
                                title: 'No products found',
                                message: 'Try another search or category',
                              ),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                0,
                                16,
                                30,
                              ),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: isDesktop ? 0.72 : 0.60,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final product = products[index];

                                    return _AnimatedProductItem(
                                      index: index,
                                      child: ProductCard(
                                        product: product,
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            AppRoutes.productDetail,
                                            arguments: product,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  childCount: products.length,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pushNamed(AppRoutes.profile);
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.brand,
                        AppColors.brand.withOpacity(0.75),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brand.withOpacity(0.20),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 11),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: AppText.label.copyWith(
                        color: colors.muted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Alex Morgan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: colors.ink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.notifications,
              );
            },
            showBadge: true,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SEARCH
  // ===========================================================================

  Widget _buildSearch(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        20,
        16,
        0,
      ),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          // IMPORTANT:
          // Do not use Colors.white here.
          // This allows dark theme to work.
          color: colors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: colors.line.withOpacity(0.55),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: TextField(
          textInputAction: TextInputAction.search,
          style: AppText.body.copyWith(
            fontSize: 14,
            color: colors.ink,
          ),
          decoration: InputDecoration(
            hintText: 'Search products, brands or categories',
            hintStyle: AppText.body.copyWith(
              fontSize: 13,
              color: colors.muted,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: colors.ink,
              size: 22,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.brand.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.brand,
                  size: 19,
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 14,
            ),
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // PROMO CAROUSEL
  // ===========================================================================

  Widget _buildPromoCarousel(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 158,
          child: PageView.builder(
            controller: _promoController,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            onPageChanged: _onPromoChanged,
            itemBuilder: (context, index) {
              final promo = _promos[index % _promos.length];

              return AnimatedBuilder(
                animation: _promoController,
                builder: (context, child) {
                  double scale = 1.0;

                  if (_promoController.hasClients &&
                      _promoController.position.haveDimensions) {
                    final page = _promoController.page ??
                        _promoController.initialPage.toDouble();

                    final distance = (page - index).abs();

                    scale = (1 - (distance * 0.025)).clamp(0.97, 1.0);
                  }

                  return Transform.scale(
                    scale: scale,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      child: child,
                    ),
                  );
                },
                child: _PromoBanner(
                  data: promo,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promos.length,
            (index) {
              final selected = index == _currentPromo;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: selected ? 20 : 6,
                height: 5,
                margin: const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.brand
                      : colors.muted.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // CATEGORIES
  // ===========================================================================

  Widget _buildCategories(
    BuildContext context,
    List<String> categories,
    String selectedCategory,
  ) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: SizedBox(
        height: 105,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(
            width: 12,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            final isSelected = category == selectedCategory;

            final icon = categoryIcons[category] ?? Icons.category_rounded;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref
                    .read(
                      selectedCategoryProvider.notifier,
                    )
                    .state = category;
              },
              child: SizedBox(
                width: 68,
                child: Column(
                  children: [
                    // =========================================================
                    // CATEGORY ICON
                    // =========================================================
                    AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 280,
                      ),
                      curve: Curves.easeOutBack,
                      width: isSelected ? 60 : 56,
                      height: isSelected ? 60 : 56,
                      decoration: BoxDecoration(
                        // FIX:
                        // Previously this was Colors.white.
                        color: isSelected ? AppColors.brand : colors.surface,

                        borderRadius: BorderRadius.circular(
                          isSelected ? 19 : 18,
                        ),

                        border: Border.all(
                          color: isSelected
                              ? AppColors.brand
                              : colors.line.withOpacity(0.55),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? AppColors.brand.withOpacity(0.22)
                                : Colors.black.withOpacity(0.025),
                            blurRadius: isSelected ? 14 : 8,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 220,
                        ),
                        transitionBuilder: (
                          child,
                          animation,
                        ) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          icon,
                          key: ValueKey(
                            '$category-$isSelected',
                          ),
                          color: isSelected ? Colors.white : AppColors.brand,
                          size: isSelected ? 25 : 23,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // =========================================================
                    // CATEGORY TEXT
                    // =========================================================
                    AnimatedDefaultTextStyle(
                      duration: const Duration(
                        milliseconds: 220,
                      ),
                      style: AppText.label.copyWith(
                        color: isSelected ? colors.ink : colors.muted,
                        fontSize: 10.5,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w500,
                      ),
                      child: Text(
                        category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // PRODUCTS HEADER
  // ===========================================================================

  Widget _buildProductsHeader(
    BuildContext context,
    String selectedCategory,
  ) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        22,
        16,
        14,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.brand.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.brand,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCategory == 'All'
                      ? 'Popular right now'
                      : selectedCategory,
                  style: AppText.heading.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Top picks for you',
                  style: AppText.label.copyWith(
                    color: colors.muted,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              final products = ref.read(
                filteredProductListProvider,
              );

              Navigator.of(context).pushNamed(
                AppRoutes.seeAll,
                arguments: SeeAllArgs(
                  title: selectedCategory == 'All'
                      ? 'Popular right now'
                      : selectedCategory,
                  products: products,
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  'See all',
                  style: AppText.label.copyWith(
                    color: AppColors.brand,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.brand,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState(BuildContext context) {
    final colors = AppColors.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.brand.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 32,
                color: AppColors.brand,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: AppText.heading.copyWith(
                fontSize: 17,
                color: colors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try another search or category',
              style: AppText.body.copyWith(
                color: colors.muted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PROMO DATA
// =============================================================================

class _PromoData {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color color;
  final IconData icon;

  const _PromoData({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.color,
    required this.icon,
  });
}

// =============================================================================
// PROMO BANNER
// =============================================================================

class _PromoBanner extends StatelessWidget {
  final _PromoData data;

  const _PromoBanner({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: data.color.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            top: -45,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 35,
            bottom: -65,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 0,
            child: Transform.rotate(
              angle: -0.10,
              child: Icon(
                data.icon,
                size: 110,
                color: Colors.white.withOpacity(0.13),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              17,
              20,
              17,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'LIMITED OFFER',
                    style: AppText.label.copyWith(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  data.title,
                  style: AppText.heading.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  style: AppText.body.copyWith(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    data.buttonText,
                    style: AppText.label.copyWith(
                      color: data.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// HEADER BUTTON
// =============================================================================

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showBadge;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colors.line.withOpacity(0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: colors.ink,
              size: 22,
            ),
          ),
          if (showBadge)
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.brand,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.surface,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
// PRODUCT ANIMATION
// =============================================================================

class _AnimatedProductItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedProductItem({
    required this.index,
    required this.child,
  });

  @override
  State<_AnimatedProductItem> createState() => _AnimatedProductItemState();
}

class _AnimatedProductItemState extends State<_AnimatedProductItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 400 + (widget.index.clamp(0, 5) * 50),
      ),
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _scale = Tween<double>(
      begin: 0.97,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    Future.delayed(
      Duration(
        milliseconds: widget.index.clamp(0, 6) * 45,
      ),
      () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: widget.child,
        ),
      ),
    );
  }
}