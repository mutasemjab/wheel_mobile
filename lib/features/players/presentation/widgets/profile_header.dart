import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/player_avatar.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/tier_badge.dart';
import '../../../../core/widgets/trend_arrow.dart';
import '../../domain/entities/player.dart';

/// Photo, number, role, tier and rating. Long-press the rating for `rating_exact`.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final tier = player.tierNow;
    final color = tier == null ? AppColors.accent : AppColors.tier(tier);
    final subtitle = [
      if (player.number != null) l10n.shirtNumber(player.number!),
      if (player.isGoalkeeper) l10n.goalkeeper else ?player.role,
      ?player.nameEn,
    ].join(' · ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            PlayerAvatar(
              name: player.name,
              photoUrl: player.photoUrl,
              tier: tier,
              size: 84,
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(player.name, style: text.headlineMedium),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: text.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      if (tier != null) TierBadge(tier: tier),
                      const SizedBox(width: AppSpacing.sm),
                      Text(l10n.rankLabel(player.rank), style: text.labelLarge),
                      const SizedBox(width: AppSpacing.sm),
                      MovedBadge(moved: player.moved),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onLongPress: () => showMessageSnack(
                context,
                l10n.ratingExact(NumberFormatX.oneDecimal(player.ratingExact)),
              ),
              child: Column(
                children: [
                  Text(
                    '${player.rating}',
                    style: text.displaySmall?.copyWith(color: color),
                  ),
                  TrendArrow(trend: player.trend),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
