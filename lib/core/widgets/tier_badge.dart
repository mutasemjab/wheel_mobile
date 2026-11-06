import 'package:flutter/material.dart';

import '../entities/enums.dart';
import '../theme/colors.dart';

/// Small colored badge showing the tier letter (and optional title).
class TierBadge extends StatelessWidget {
  const TierBadge({super.key, required this.tier, this.title});

  final Tier tier;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.tier(tier);
    final label = title == null ? tier.code : '${tier.code} · $title';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
