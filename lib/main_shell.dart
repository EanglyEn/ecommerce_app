// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:ecommerce_app/screens/explore/explore_screen.dart';
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

    final screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const CartScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          for (int i = 0; i < screens.length; i++)
            HeroMode(
              enabled: i == _index,
              child: screens[i],
            ),
        ],
      ),
      bottomNavigationBar: _FloatingNavigationBar(
        currentIndex: _index,
        cartCount: cartCount,
        onTap: _goTo,
      ),
    );
  }
}

class _FloatingNavigationBar extends StatelessWidget {
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0,12, 12,),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
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

class _NavigationCapsule extends StatelessWidget {
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
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 25,
            sigmaY: 25,
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.16),
                      Colors.white.withOpacity(0.07),
                      Colors.black.withOpacity(0.28),
                    ],
                    stops: const [
                      0.0,
                      0.35,
                      1.0,
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.20),
                    width: 1,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / 4;

                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        curve: Curves.easeOutCubic,
                        left: itemWidth * currentIndex,
                        top: 5,
                        width: itemWidth,
                        height: height - 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 8,
                                sigmaY: 8,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.18),
                                      Colors.white.withOpacity(0.08),
                                      Colors.white.withOpacity(0.04),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.14),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.05),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _FloatingNavItem(
                              icon: Icons.home_rounded,
                              label: 'Home',
                              selected: currentIndex == 0,
                              onTap: () => onTap(0),
                            ),
                          ),
                          Expanded(
                            child: _FloatingNavItem(
                              icon: Icons.explore_rounded,
                              label: 'Explore',
                              selected: currentIndex == 1,
                              onTap: () => onTap(1),
                            ),
                          ),
                          Expanded(
                            child: _FloatingNavItem(
                              icon: Icons.shopping_bag_rounded,
                              label: 'Cart',
                              selected: currentIndex == 2,
                              badgeCount: cartCount,
                              onTap: () => onTap(2),
                            ),
                          ),
                          Expanded(
                            child: _FloatingNavItem(
                              icon: Icons.person_rounded,
                              label: 'Account',
                              selected: currentIndex == 3,
                              onTap: () => onTap(3),
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

class _FloatingNavItem extends StatelessWidget {
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
    final color = selected ? AppColors.brand : Colors.white.withOpacity(0.90);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: _NavigationCapsule.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                key: ValueKey(selected),
                tween: Tween<double>(
                  begin: selected ? 0.75 : 1.0,
                  end: 1.0,
                ),
                duration: const Duration(
                  milliseconds: 350,
                ),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      selected ? -1.5 : 0,
                    ),
                    child: Transform.scale(
                      scale: selected ? value : 1,
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    TweenAnimationBuilder<Color?>(
                      tween: ColorTween(
                        begin: Colors.white.withOpacity(0.90),
                        end: color,
                      ),
                      duration: const Duration(
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
                          color: animatedColor,
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
                duration: const Duration(
                  milliseconds: 250,
                ),
                curve: Curves.easeOut,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;

  const _Badge({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.5,
        end: 1.0,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(3),
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        decoration: const BoxDecoration(
          color: AppColors.brand,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$count',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
