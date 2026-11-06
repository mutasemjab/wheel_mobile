import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/tier_badge.dart';
import '../../domain/entities/home_data.dart';
import 'tier_player_card.dart';

/// Tier title + horizontally scrolling player cards.
class TierSection extends StatelessWidget {
  const TierSection({super.key, required this.group});

  static const double _listHeight = 200;

  final TierGroup group;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            TierBadge(tier: group.tier, title: group.title),
            const SizedBox(width: AppSpacing.sm),
            Text(group.range, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      SizedBox(
        height: _listHeight,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          scrollDirection: Axis.horizontal,
          itemCount: group.players.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, i) {
            final player = group.players[i];
            return TierPlayerCard(
              player: player,
              tier: group.tier,
              onTap: () => context.push(AppRoutes.player(player.slug)),
            );
          },
        ),
      ),
    ],
  );
}
