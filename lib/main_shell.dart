// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:ecommerce_app/screens/explore/explore_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/cart_provider.dart';
import 'theme.dart';
import 'screens/account/account_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/home/home_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _index = 0;

  void _goTo(int index) {
    if (_index == index) return;

    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartItemCountProvider);

    final screenWidth = MediaQuery.sizeOf(context).width;

    final isDesktop = kIsWeb || screenWidth >= 1024;

    final screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const CartScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.of(context).bg,

      // ===============================================================
      // DESKTOP / WEB
      // ===============================================================
      body: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DesktopSidebar(
                  currentIndex: _index,
                  cartCount: cartCount,
                  onTap: _goTo,
                ),

                Expanded(
                  child: IndexedStack(
                    index: _index,
                    children: [
                      for (int i = 0; i < screens.length; i++)
                        HeroMode(
                          enabled: i == _index,
                          child: screens[i],
                        ),
                    ],
                  ),
                ),
              ],
            )

          // =============================================================
          // MOBILE / TABLET
          // =============================================================
          : IndexedStack(
              index: _index,
              children: [
                for (int i = 0; i < screens.length; i++)
                  HeroMode(
                    enabled: i == _index,
                    child: screens[i],
                  ),
              ],
            ),

      // ===============================================================
      // MOBILE / TABLET NAVIGATION
      // ===============================================================

      bottomNavigationBar: isDesktop
          ? null
          : _FloatingNavigationBar(
              currentIndex: _index,
              cartCount: cartCount,
              onTap: _goTo,
            ),
    );
  }
}

// =============================================================================
// DESKTOP SIDEBAR
// =============================================================================

class _DesktopSidebar extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  const _DesktopSidebar({
    required this.currentIndex,
    required this.cartCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          right: BorderSide(
            color: colors.line.withOpacity(0.55),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ===========================================================
            // LOGO
            // ===========================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                22,
                22,
                22,
                30,
              ),
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
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Eangly Store',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.heading.copyWith(
                        color: colors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===========================================================
            // NAVIGATION
            // ===========================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              child: Column(
                children: [
                  _DesktopNavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    selected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _DesktopNavItem(
                    icon: Icons.explore_rounded,
                    label: 'Explore',
                    selected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _DesktopNavItem(
                    icon: Icons.shopping_bag_rounded,
                    label: 'Cart',
                    selected: currentIndex == 2,
                    badgeCount: cartCount,
                    onTap: () => onTap(2),
                  ),
                  _DesktopNavItem(
                    icon: Icons.person_rounded,
                    label: 'Account',
                    selected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ===========================================================
            // USER CARD
            // ===========================================================

            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.bg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colors.line.withOpacity(0.55),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.brand.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.brand,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Morgan',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.label.copyWith(
                              color: colors.ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'View account',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.label.copyWith(
                              color: colors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// DESKTOP NAVIGATION ITEM
// =============================================================================

class _DesktopNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final int badgeCount;
  final VoidCallback onTap;

  const _DesktopNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 280,
            ),
            curve: Curves.easeOutCubic,
            height: 52,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.brand.withOpacity(0.10)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0.92,
                        end: selected ? 1.0 : 0.95,
                      ),
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                      curve: Curves.easeOutBack,
                      builder: (
                        context,
                        scale,
                        child,
                      ) {
                        return Transform.scale(
                          scale: scale,
                          child: Icon(
                            icon,
                            size: 22,
                            color: selected
                                ? AppColors.brand
                                : colors.muted,
                          ),
                        );
                      },
                    ),

                    if (badgeCount > 0)
                      Positioned(
                        right: -10,
                        top: -8,
                        child: _Badge(
                          count: badgeCount,
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(
                      milliseconds: 220,
                    ),
                    style: AppText.label.copyWith(
                      color: selected
                          ? AppColors.brand
                          : colors.ink,
                      fontSize: 13,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    child: Text(label),
                  ),
                ),

                if (selected)
                  Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.brand,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// FLOATING MOBILE / TABLET NAVIGATION
// =============================================================================

class _FloatingNavigationBar
    extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  const _FloatingNavigationBar({
    required this.currentIndex,
    required this.cartCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width < 600
        ? 12.0
        : 24.0;

    final bottomPadding = width < 600
        ? 12.0
        : 20.0;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          0,
          horizontalPadding,
          bottomPadding,
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _NavigationCapsule(
                currentIndex: currentIndex,
                cartCount: cartCount,
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// NAVIGATION CAPSULE
// =============================================================================

class _NavigationCapsule
    extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  const _NavigationCapsule({
    required this.currentIndex,
    required this.cartCount,
    required this.onTap,
  });

  static const double height = 65;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.25),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 25,
            sigmaY: 25,
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(40),
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment.topCenter,
                    end:
                        Alignment.bottomCenter,
                    colors: [
                      Colors.white
                          .withOpacity(0.16),
                      Colors.white
                          .withOpacity(0.07),
                      Colors.black
                          .withOpacity(0.28),
                    ],
                    stops: const [
                      0.0,
                      0.35,
                      1.0,
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white
                        .withOpacity(0.20),
                    width: 1,
                  ),
                ),
              ),

              LayoutBuilder(
                builder:
                    (context, constraints) {
                  final itemWidth =
                      constraints.maxWidth /
                          4;

                  return Stack(
                    children: [
                      // ===================================================
                      // ACTIVE INDICATOR
                      // ===================================================

                      AnimatedPositioned(
                        duration:
                            const Duration(
                          milliseconds: 500,
                        ),
                        curve:
                            Curves.easeOutCubic,
                        left: itemWidth *
                            currentIndex,
                        top: 5,
                        width: itemWidth,
                        height: height - 10,
                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 4,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              35,
                            ),
                            child:
                                BackdropFilter(
                              filter:
                                  ImageFilter
                                      .blur(
                                sigmaX: 8,
                                sigmaY: 8,
                              ),
                              child: Container(
                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    35,
                                  ),
                                  gradient:
                                      LinearGradient(
                                    begin:
                                        Alignment
                                            .topCenter,
                                    end:
                                        Alignment
                                            .bottomCenter,
                                    colors: [
                                      Colors.white
                                          .withOpacity(
                                        0.18,
                                      ),
                                      Colors.white
                                          .withOpacity(
                                        0.08,
                                      ),
                                      Colors.white
                                          .withOpacity(
                                        0.04,
                                      ),
                                    ],
                                  ),
                                  border:
                                      Border.all(
                                    color: Colors
                                        .white
                                        .withOpacity(
                                      0.14,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .white
                                          .withOpacity(
                                        0.05,
                                      ),
                                      blurRadius:
                                          10,
                                      spreadRadius:
                                          1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ===================================================
                      // ITEMS
                      // ===================================================

                      Row(
                        children: [
                          Expanded(
                            child:
                                _FloatingNavItem(
                              icon: Icons
                                  .home_rounded,
                              label: 'Home',
                              selected:
                                  currentIndex ==
                                      0,
                              onTap: () =>
                                  onTap(0),
                            ),
                          ),
                          Expanded(
                            child:
                                _FloatingNavItem(
                              icon: Icons
                                  .explore_rounded,
                              label: 'Explore',
                              selected:
                                  currentIndex ==
                                      1,
                              onTap: () =>
                                  onTap(1),
                            ),
                          ),
                          Expanded(
                            child:
                                _FloatingNavItem(
                              icon: Icons
                                  .shopping_bag_rounded,
                              label: 'Cart',
                              selected:
                                  currentIndex ==
                                      2,
                              badgeCount:
                                  cartCount,
                              onTap: () =>
                                  onTap(2),
                            ),
                          ),
                          Expanded(
                            child:
                                _FloatingNavItem(
                              icon: Icons
                                  .person_rounded,
                              label: 'Account',
                              selected:
                                  currentIndex ==
                                      3,
                              onTap: () =>
                                  onTap(3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// FLOATING NAV ITEM
// =============================================================================

class _FloatingNavItem
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badgeCount;

  const _FloatingNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppColors.brand
        : Colors.white.withOpacity(0.90);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height:
            _NavigationCapsule.height,
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                key: ValueKey(selected),
                tween: Tween<double>(
                  begin:
                      selected ? 0.75 : 1.0,
                  end: 1.0,
                ),
                duration:
                    const Duration(
                  milliseconds: 350,
                ),
                curve:
                    Curves.easeOutBack,
                builder: (
                  context,
                  value,
                  child,
                ) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      selected ? -1.5 : 0,
                    ),
                    child: Transform.scale(
                      scale:
                          selected ? value : 1,
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  clipBehavior:
                      Clip.none,
                  children: [
                    TweenAnimationBuilder<
                        Color?>(
                      tween: ColorTween(
                        begin: Colors.white
                            .withOpacity(
                          0.90,
                        ),
                        end: color,
                      ),
                      duration:
                          const Duration(
                        milliseconds: 250,
                      ),
                      builder: (
                        context,
                        animatedColor,
                        child,
                      ) {
                        return Icon(
                          icon,
                          size: 25,
                          color:
                              animatedColor,
                        );
                      },
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        right: -7,
                        top: -6,
                        child: _Badge(
                          count: badgeCount,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 3),

              AnimatedDefaultTextStyle(
                duration:
                    const Duration(
                  milliseconds: 250,
                ),
                curve:
                    Curves.easeOut,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// BADGE
// =============================================================================

class _Badge extends StatelessWidget {
  final int count;

  const _Badge({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0.5,
        end: 1.0,
      ),
      duration:
          const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (
        context,
        scale,
        child,
      ) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding:
            const EdgeInsets.all(3),
        constraints:
            const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        decoration:
            const BoxDecoration(
          color: AppColors.brand,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$count',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }
}