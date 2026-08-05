import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const brand = Color(0xFFFF3B5C);
  static const brandDark = Color(0xFFE0264A);
  static const amber = Color(0xFFFFB300);
  static const add = Color(0xFF2878E8);
  static const success = Color(0xFF2ECC71);
  static const softBrand = Color(0xFFFFE8ED);
  static const softAmber = Color(0xFFFFF4D6);
  static const softGreen = Color(0xFFE7F8EE);

  static AppThemeColors of(BuildContext context) {
    return Theme.of(context).extension<AppThemeColors>() ??
        AppThemeColors.light;
  }
}

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color bg;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color line;
  final Color dark;

  const AppThemeColors({
    required this.bg,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.dark,
  });

  static const light = AppThemeColors(
    bg: Color(0xFFF6F6F9),
    surface: Color(0xFFFFFFFF),
    ink: Color(0xFF23232B),
    muted: Color(0xFF8E8E96),
    line: Color(0xFFEDEDF2),
    dark: Color(0xFF17171C),
  );

  static const dark_ = AppThemeColors(
    bg: Color(0xFF121216),
    surface: Color(0xFF1C1C22),
    ink: Color(0xFFF1F1F4),
    muted: Color(0xFF9A9AA4),
    line: Color(0xFF2C2C34),
    dark: Color(0xFF0B0B0E),
  );

  @override
  AppThemeColors copyWith({
    Color? bg,
    Color? surface,
    Color? ink,
    Color? muted,
    Color? line,
    Color? dark,
  }) {
    return AppThemeColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      dark: dark ?? this.dark,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      dark: Color.lerp(dark, other.dark, t)!,
    );
  }
}

class AppText {
  static TextStyle heading = GoogleFonts.baloo2(
    fontWeight: FontWeight.w700,
  );
  static TextStyle body = GoogleFonts.nunito(
    height: 1.4,
  );
  static TextStyle label = GoogleFonts.nunito(
    fontWeight: FontWeight.w700,
    fontSize: 11.5,
  );
  static TextStyle price = GoogleFonts.nunito(
    color: AppColors.brand,
    fontWeight: FontWeight.w900,
    fontSize: 17,
  );
  static TextStyle smallPrice = GoogleFonts.nunito(
    color: AppColors.brand,
    fontWeight: FontWeight.w800,
    fontSize: 14,
  );
  static TextStyle oldPrice = GoogleFonts.nunito(
    fontWeight: FontWeight.w600,
    fontSize: 11.5,
    decoration: TextDecoration.lineThrough,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
  const colors = AppThemeColors.light;

  return base.copyWith(
    scaffoldBackgroundColor: colors.bg,
    extensions: const [colors],

    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.brand,
      onPrimary: Colors.white,
      secondary: AppColors.amber,
      onSecondary: colors.ink,
      surface: colors.surface,
      onSurface: colors.ink,
    ),

    textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).apply(
      bodyColor: colors.ink,
      displayColor: colors.ink,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: colors.bg,
      foregroundColor: colors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: AppText.heading.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: colors.ink,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        disabledBackgroundColor: colors.line,
        disabledForegroundColor: colors.muted,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brand,
        side: const BorderSide(color: AppColors.brand, width: 1.2),
        minimumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      hintStyle: GoogleFonts.nunito(
        color: colors.muted,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      labelStyle: GoogleFonts.nunito(
        color: colors.muted,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: AppColors.brand, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    ),

    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    dividerTheme: DividerThemeData(color: colors.line, thickness: 1, space: 1),
    dividerColor: colors.line,

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colors.ink,
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    chipTheme: base.chipTheme.copyWith(
      backgroundColor: colors.surface,
      selectedColor: AppColors.brand,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      labelStyle: AppText.label.copyWith(color: colors.muted),
      secondaryLabelStyle: AppText.label.copyWith(color: Colors.white),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.dark,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentTextStyle: GoogleFonts.nunito(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: colors.line,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brand,
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

ThemeData buildAppDarkTheme() {
  final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);
  const colors = AppThemeColors.dark_;

  return base.copyWith(
    scaffoldBackgroundColor: colors.bg,
    extensions: const [colors],

    colorScheme: base.colorScheme.copyWith(
      brightness: Brightness.dark,
      primary: AppColors.brand,
      onPrimary: Colors.white,
      secondary: AppColors.amber,
      onSecondary: colors.ink,
      surface: colors.surface,
      onSurface: colors.ink,
    ),

    textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).apply(
      bodyColor: colors.ink,
      displayColor: colors.ink,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: colors.bg,
      foregroundColor: colors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: AppText.heading.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: colors.ink,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        disabledBackgroundColor: colors.line,
        disabledForegroundColor: colors.muted,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brand,
        side: const BorderSide(color: AppColors.brand, width: 1.2),
        minimumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      hintStyle: GoogleFonts.nunito(
        color: colors.muted,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      labelStyle: GoogleFonts.nunito(
        color: colors.muted,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: AppColors.brand, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    ),

    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    dividerTheme: DividerThemeData(color: colors.line, thickness: 1, space: 1),
    dividerColor: colors.line,

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colors.ink,
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    chipTheme: base.chipTheme.copyWith(
      backgroundColor: colors.surface,
      selectedColor: AppColors.brand,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      labelStyle: AppText.label.copyWith(color: colors.muted),
      secondaryLabelStyle: AppText.label.copyWith(color: Colors.white),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.surface,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentTextStyle: GoogleFonts.nunito(
        color: colors.ink,
        fontWeight: FontWeight.w700,
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: colors.line,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brand,
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}