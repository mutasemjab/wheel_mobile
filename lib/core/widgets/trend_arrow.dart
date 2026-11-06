import 'package:flutter/material.dart';

import '../entities/enums.dart';
import '../l10n/l10n.dart';
import '../theme/colors.dart';
import '../utils/number_format.dart';

/// ▲ green / ▼ red with one decimal; renders nothing for 0.
class TrendArrow extends StatelessWidget {
  const TrendArrow({super.key, required this.trend, this.style});

  final double trend;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (trend == 0) return const SizedBox.shrink();
    final up = trend > 0;
    final color = up ? AppColors.positive : AppColors.negative;
    final base = style ?? Theme.of(context).textTheme.labelMedium;
    return Text(
      '${up ? '▲' : '▼'} ${NumberFormatX.oneDecimal(trend.abs())}',
      style: base?.copyWith(color: color, fontWeight: FontWeight.w700),
    );
  }
}

/// "صعد" / "نزل" pill when the player changed tier.
class MovedBadge extends StatelessWidget {
  const MovedBadge({super.key, required this.moved});

  final Movement moved;

  @override
  Widget build(BuildContext context) {
    if (moved == Movement.none) return const SizedBox.shrink();
    final up = moved == Movement.up;
    final color = up ? AppColors.positive : AppColors.negative;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        up ? context.l10n.movedUp : context.l10n.movedDown,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
