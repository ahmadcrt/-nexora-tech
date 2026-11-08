import 'package:flutter/material.dart';

import 'brand_colors.dart';

/// Application theme built only from approved brand tokens.
abstract final class AppTheme {
  static const String fontFamily = 'Inter';

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: BrandColors.electricBlue,
      onPrimary: BrandColors.white,
      secondary: BrandColors.midnightNavy,
      onSecondary: BrandColors.white,
      // No approved error colour yet (TBD-026): errors use Graphite with text
      // and an icon, never colour alone.
      error: BrandColors.graphite,
      onError: BrandColors.white,
      surface: BrandColors.white,
      onSurface: BrandColors.graphite,
      outline: BrandColors.silver,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: BrandColors.white,
    );

    final text = base.textTheme
        .copyWith(
          displayLarge: const TextStyle(
              fontSize: 48, height: 56 / 48, fontWeight: FontWeight.w500),
          displayMedium: const TextStyle(
              fontSize: 36, height: 44 / 36, fontWeight: FontWeight.w500),
          headlineLarge: const TextStyle(
              fontSize: 36, height: 44 / 36, fontWeight: FontWeight.w500),
          headlineMedium: const TextStyle(
              fontSize: 30, height: 38 / 30, fontWeight: FontWeight.w500),
          headlineSmall: const TextStyle(
              fontSize: 28, height: 36 / 28, fontWeight: FontWeight.w500),
          titleLarge: const TextStyle(
              fontSize: 24, height: 32 / 24, fontWeight: FontWeight.w500),
          titleMedium: const TextStyle(
              fontSize: 22, height: 30 / 22, fontWeight: FontWeight.w500),
          bodyLarge: const TextStyle(
              fontSize: 18, height: 28 / 18, fontWeight: FontWeight.w400),
          bodyMedium: const TextStyle(
              fontSize: 16, height: 26 / 16, fontWeight: FontWeight.w400),
          bodySmall: const TextStyle(
              fontSize: 14, height: 22 / 14, fontWeight: FontWeight.w400),
          labelLarge: const TextStyle(
              fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w500),
        )
        .apply(
          bodyColor: BrandColors.graphite,
          displayColor: BrandColors.midnightNavy,
        );

    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(6));
    const minimumTarget = Size(44, 48);

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      textTheme: text,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BrandColors.electricBlue,
          foregroundColor: BrandColors.white,
          minimumSize: minimumTarget,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrandColors.midnightNavy,
          minimumSize: minimumTarget,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          side: const BorderSide(color: BrandColors.silver),
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BrandColors.electricBlue,
          minimumSize: const Size(44, 44),
          textStyle: text.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: border(BrandColors.silver, 1),
        enabledBorder: border(BrandColors.silver, 1),
        focusedBorder: border(BrandColors.electricBlue, 2),
        errorBorder: border(BrandColors.graphite, 2),
        focusedErrorBorder: border(BrandColors.graphite, 2),
        labelStyle: const TextStyle(color: BrandColors.graphite),
        helperStyle: const TextStyle(color: BrandColors.graphite),
        errorStyle: const TextStyle(
            color: BrandColors.graphite, fontWeight: FontWeight.w700),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dividerColor: BrandColors.silver,
    );
  }
}
