import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cairo for Arabic text. [useGoogleFonts] is off in tests (no network).
abstract final class AppTypography {
  static TextTheme textTheme(TextTheme base, {bool useGoogleFonts = true}) {
    final themed = useGoogleFonts ? GoogleFonts.cairoTextTheme(base) : base;
    return themed.copyWith(
      displaySmall: themed.displaySmall?.copyWith(fontWeight: FontWeight.w800),
      headlineMedium: themed.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
      ),
      titleLarge: themed.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: themed.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
