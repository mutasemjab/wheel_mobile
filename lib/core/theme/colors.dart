import 'package:flutter/material.dart';

import '../entities/enums.dart';

/// Brand and semantic colors.
abstract final class AppColors {
  // Team accents
  static const Color accent = Color(0xFFFF6B1A);
  static const Color accentSecondary = Color(0xFF1FB6FF);

  // Dark surfaces
  static const Color darkBackground = Color(0xFF0A0F1C);
  static const Color darkSurface = Color(0xFF131B2E);
  static const Color darkSurfaceHigh = Color(0xFF1C2640);

  // Light surfaces
  static const Color lightBackground = Color(0xFFF4F6FA);
  static const Color lightSurface = Color(0xFFFFFFFF);

  // Tiers
  static const Color tierGold = Color(0xFFD4AF37);
  static const Color tierSilver = Color(0xFF8FA8C8);
  static const Color tierBronze = Color(0xFFCD7F32);

  // Semantics
  static const Color positive = Color(0xFF22C55E);
  static const Color negative = Color(0xFFEF4444);
  static const Color neutral = Color(0xFF9CA3AF);
  static const Color warning = Color(0xFFF59E0B);
  static const Color live = Color(0xFFE11D48);

  static Color tier(Tier tier) => switch (tier) {
    Tier.a => tierGold,
    Tier.b => tierSilver,
    Tier.c => tierBronze,
  };

  static Color result(MatchResult result) => switch (result) {
    MatchResult.win => positive,
    MatchResult.draw => neutral,
    MatchResult.loss => negative,
  };

  static Color delta(double v) => v > 0
      ? positive
      : v < 0
      ? negative
      : neutral;
}
