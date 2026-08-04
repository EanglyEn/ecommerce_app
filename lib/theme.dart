import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {

  static const brand = Color(0xFFFF3B5C);
  static const brandDark = Color(0xFFE0264A);

  static const amber = Color(0xFFFFB300);
  static const success = Color(0xFF2ECC71);

  static const bg = Color(0xFFF6F6F9);
  static const surface = Color(0xFFFFFFFF);

  static const ink = Color(0xFF23232B);
  static const muted = Color(0xFF8E8E96);
  static const mutedDark = Color(0xFF66666F);

  static const line = Color(0xFFEDEDF2);
  static const softBrand = Color(0xFFFFE8ED);
  static const softAmber = Color(0xFFFFF4D6);
  static const softGreen = Color(0xFFE7F8EE);
  static const dark = Color(0xFF17171C);
}

class AppText {
  static TextStyle heading = GoogleFonts.baloo2(
    color: AppColors.ink,
    fontWeight: FontWeight.w700,
  );
  static TextStyle body = GoogleFonts.nunito(
    color: AppColors.ink,
    height: 1.4,
  );

  static TextStyle label = GoogleFonts.nunito(
    color: AppColors.muted,
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
    color: AppColors.muted,
    fontWeight: FontWeight.w600,
    fontSize: 11.5,
    decoration: TextDecoration.lineThrough,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
  );

  return base.copyWith(

    scaffoldBackgroundColor: AppColors.bg,

    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.brand,
      onPrimary: Colors.white,
      secondary: AppColors.amber,
      onSecondary: AppColors.ink,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
    ),

    textTheme: GoogleFonts.nunitoTextTheme(
      base.textTheme,
    ).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: AppText.heading.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.line,
        disabledForegroundColor: AppColors.muted,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        textStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.brand,
        side: const BorderSide(
          color: AppColors.brand,
          width: 1.2,
        ),
        minimumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        textStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
      ),
    ),


    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 15,
      ),

      hintStyle: GoogleFonts.nunito(
        color: AppColors.muted,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),

      labelStyle: GoogleFonts.nunito(
        color: AppColors.muted,
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
        borderSide: const BorderSide(
          color: AppColors.brand,
          width: 1.4,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.4,
        ),
      ),
    ),

    // -------------------------------------------------------------------------
    // CARDS
    // -------------------------------------------------------------------------

    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      thickness: 1,
      space: 1,
    ),

    dividerColor: AppColors.line,
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.ink,
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    chipTheme: base.chipTheme.copyWith(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.brand,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      labelStyle: AppText.label,
      secondaryLabelStyle: AppText.label.copyWith(
        color: Colors.white,
      ),
    ),

    // -------------------------------------------------------------------------
    // SNACKBAR
    // -------------------------------------------------------------------------

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.dark,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentTextStyle: GoogleFonts.nunito(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    ),

    // -------------------------------------------------------------------------
    // BOTTOM SHEET
    // -------------------------------------------------------------------------

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: AppColors.line,
    ),

    // -------------------------------------------------------------------------
    // PROGRESS
    // -------------------------------------------------------------------------

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brand,
    ),

    // -------------------------------------------------------------------------
    // PAGE TRANSITIONS
    // -------------------------------------------------------------------------

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
