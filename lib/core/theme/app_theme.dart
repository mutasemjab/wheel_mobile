import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';

/// Spacing / radius tokens.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double radius = 16;
  static const double radiusSm = 10;
}

/// Material 3 themes, dark-first.
abstract final class AppTheme {
  static ThemeData dark({bool useGoogleFonts = true}) => _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.dark,
      primary: AppColors.accent,
      secondary: AppColors.accentSecondary,
      surface: AppColors.darkSurface,
    ),
    scaffold: AppColors.darkBackground,
    card: AppColors.darkSurface,
    useGoogleFonts: useGoogleFonts,
  );

  static ThemeData light({bool useGoogleFonts = true}) => _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      primary: AppColors.accent,
      secondary: AppColors.accentSecondary,
      surface: AppColors.lightSurface,
    ),
    scaffold: AppColors.lightBackground,
    card: AppColors.lightSurface,
    useGoogleFonts: useGoogleFonts,
  );

  static ThemeData _build(
    ColorScheme scheme, {
    required Color scaffold,
    required Color card,
    required bool useGoogleFonts,
  }) {
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    return base.copyWith(
      scaffoldBackgroundColor: scaffold,
      textTheme: AppTypography.textTheme(
        base.textTheme,
        useGoogleFonts: useGoogleFonts,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        indicatorColor: scheme.primary.withValues(alpha: 0.2),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
