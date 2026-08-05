import 'package:flutter/material.dart';
import '../../theme.dart';

class ThemeBottomSheet extends StatefulWidget {
  final ThemeMode selectedTheme;
  final ValueChanged<ThemeMode> onSelected;

  const ThemeBottomSheet({
    super.key,
    required this.selectedTheme,
    required this.onSelected,
  });

  static Future<void> show({
  required BuildContext context,
  required ThemeMode selectedTheme,
  required ValueChanged<ThemeMode> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.45),
    isScrollControlled: true,
    builder: (_) {
      return ThemeBottomSheet(
        selectedTheme: selectedTheme,
        onSelected: onSelected,
      );
    },
  );
}

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  late ThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.selectedTheme;
  }

  void _selectTheme(ThemeMode theme) {
    setState(() {
      _selectedTheme = theme;
    });

    // Change the actual app theme.
    widget.onSelected(theme);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            // Drag handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted.withOpacity(.25),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 22),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.brand.withOpacity(.10),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.palette_outlined,
                      color: AppColors.brand,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appearance',
                        style: AppText.heading.copyWith(
                          color: colors.ink,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Choose how the app looks',
                        style: AppText.label.copyWith(
                          color: colors.muted,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Theme preview cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: _ThemeCard(
                      themeMode: ThemeMode.light,
                      title: 'Light',
                      icon: Icons.light_mode_rounded,
                      selected:
                          _selectedTheme == ThemeMode.light,
                      onTap: () {
                        _selectTheme(ThemeMode.light);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ThemeCard(
                      themeMode: ThemeMode.dark,
                      title: 'Dark',
                      icon: Icons.dark_mode_rounded,
                      selected:
                          _selectedTheme == ThemeMode.dark,
                      onTap: () {
                        _selectTheme(ThemeMode.dark);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ThemeCard(
                      themeMode: ThemeMode.system,
                      title: 'System',
                      icon: Icons.brightness_auto_rounded,
                      selected:
                          _selectedTheme == ThemeMode.system,
                      onTap: () {
                        _selectTheme(ThemeMode.system);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Current selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: colors.ink.withOpacity(.045),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 19,
                      color: AppColors.brand,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _themeName(_selectedTheme),
                      style: AppText.body.copyWith(
                        color: colors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedTheme == ThemeMode.system)
                      Text(
                        'Device',
                        style: AppText.label.copyWith(
                          color: colors.muted,
                          fontSize: 11,
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

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light appearance';

      case ThemeMode.dark:
        return 'Dark appearance';

      case ThemeMode.system:
        return 'Follow system settings';
    }
  }
}

class _ThemeCard extends StatelessWidget {
  final ThemeMode themeMode;
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.themeMode,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.brand.withOpacity(.08)
              : colors.ink.withOpacity(.035),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.brand
                : colors.ink.withOpacity(.06),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 82,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.black.withOpacity(.05),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 9,
                    right: 9,
                    top: 10,
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: _secondaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 9,
                    right: 9,
                    bottom: 10,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 25,
                            decoration: BoxDecoration(
                              color: _secondaryColor,
                              borderRadius:
                                  BorderRadius.circular(7),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: 25,
                            decoration: BoxDecoration(
                              color: _secondaryColor,
                              borderRadius:
                                  BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 9),

            Icon(
              icon,
              size: 19,
              color: selected
                  ? AppColors.brand
                  : colors.muted,
            ),

            const SizedBox(height: 5),

            Text(
              title,
              style: AppText.label.copyWith(
                color: selected
                    ? AppColors.brand
                    : colors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (themeMode) {
      case ThemeMode.light:
        return Colors.white;

      case ThemeMode.dark:
        return const Color(0xFF17181C);

      case ThemeMode.system:
        return const Color(0xFFEFEFEF);
    }
  }

  Color get _primaryColor {
    switch (themeMode) {
      case ThemeMode.light:
        return const Color(0xFF222222);

      case ThemeMode.dark:
        return Colors.white;

      case ThemeMode.system:
        return AppColors.brand;
    }
  }

  Color get _secondaryColor {
    switch (themeMode) {
      case ThemeMode.light:
        return const Color(0xFFE8E8E8);

      case ThemeMode.dark:
        return const Color(0xFF303138);

      case ThemeMode.system:
        return Colors.white;
    }
  }
}