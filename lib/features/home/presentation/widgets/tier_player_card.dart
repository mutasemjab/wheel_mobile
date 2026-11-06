import 'package:flutter/material.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/player_avatar.dart';
import '../../../../core/widgets/trend_arrow.dart';
import '../../domain/entities/home_data.dart';

/// Player card in a home tier section: rank, photo, name, big rating,
/// trend arrow and "صعد/نزل" badge.
class TierPlayerCard extends StatelessWidget {
  const TierPlayerCard({
    super.key,
    required this.player,
    required this.tier,
    this.onTap,
  });

  static const double width = 128;

  final TierPlayer player;
  final Tier tier;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = AppColors.tier(tier);
    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          side: BorderSide(color: color.withValues(alpha: 0.5)),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      context.l10n.rankLabel(player.rank),
                      style: text.labelMedium?.copyWith(color: color),
                    ),
                    const Spacer(),
                    MovedBadge(moved: player.moved),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                PlayerAvatar(
                  name: player.name,
                  photoUrl: player.photoUrl,
                  tier: tier,
                  size: 52,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall,
                ),
                Text(
                  '${player.rating}',
                  style: text.headlineMedium?.copyWith(color: color),
                ),
                TrendArrow(trend: player.trend),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
