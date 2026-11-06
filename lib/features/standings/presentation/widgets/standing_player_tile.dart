import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/entities/enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/player_avatar.dart';
import '../../../../core/widgets/stat_chip.dart';
import '../../../../core/widgets/trend_arrow.dart';
import '../../../players/domain/entities/player.dart';

/// Standings card: photo, rank, name, rating, trend, moved badge, mini stats.
class StandingPlayerTile extends StatelessWidget {
  const StandingPlayerTile({
    super.key,
    required this.player,
    required this.tier,
  });

  final Player player;
  final Tier tier;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final color = AppColors.tier(tier);
    final s = player.stats;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.player(player.slug)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    l10n.rankLabel(player.rank),
                    style: text.titleMedium?.copyWith(color: color),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  PlayerAvatar(
                    name: player.name,
                    photoUrl: player.photoUrl,
                    tier: tier,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                player.name,
                                overflow: TextOverflow.ellipsis,
                                style: text.titleMedium,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            MovedBadge(moved: player.moved),
                          ],
                        ),
                        TrendArrow(trend: player.trend),
                      ],
                    ),
                  ),
                  Text(
                    '${player.rating}',
                    style: text.headlineMedium?.copyWith(color: color),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatChip(
                    label: l10n.statMatches,
                    value: '${s.mp}',
                    dense: true,
                  ),
                  StatChip(label: l10n.statGoals, value: '${s.g}', dense: true),
                  StatChip(
                    label: l10n.statAssists,
                    value: '${s.a}',
                    dense: true,
                  ),
                  StatChip(label: l10n.statSaves, value: '${s.s}', dense: true),
                  StatChip(
                    label: l10n.statTackles,
                    value: '${s.t}',
                    dense: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
