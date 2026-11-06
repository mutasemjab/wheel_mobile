import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Wheel logo on a white plate: its dark lettering and transparent
/// background would disappear on the dark theme without one.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = 56});

  static const String assetPath = 'assets/icon.png';

  final double height;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xs,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
    ),
    child: Image.asset(assetPath, fit: BoxFit.contain),
  );
}
