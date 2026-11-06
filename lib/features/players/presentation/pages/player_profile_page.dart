import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/insights_list.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/player_profile.dart';
import '../bloc/player_profile_cubit.dart';
import '../widgets/history_tile.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/profile_header.dart';
import '../widgets/rating_chart.dart';

class PlayerProfilePage extends StatelessWidget {
  const PlayerProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: DataStateView<PlayerProfileCubit, PlayerProfile>(
      builder: (context, profile) => _ProfileContent(profile: profile),
    ),
  );
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    const gap = SizedBox(height: AppSpacing.md);
    final nextTarget = profile.nextTarget;
    final gapToNext = profile.gapToNextTier;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ProfileHeader(player: profile.player),
        gap,
        SectionCard(child: KpiGrid(player: profile.player)),
        if (nextTarget != null || gapToNext != null) ...[
          gap,
          SectionCard(
            title: l10n.nextTarget,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (nextTarget != null)
                  Text(
                    l10n.pointsValue(NumberFormatX.compact(nextTarget)),
                    style: text.headlineMedium?.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                if (gapToNext != null)
                  Text(l10n.gapToNextTier(NumberFormatX.compact(gapToNext))),
              ],
            ),
          ),
        ],
        if (profile.ratingChart.length > 1) ...[
          gap,
          SectionCard(
            title: l10n.ratingChart,
            child: RatingChart(points: profile.ratingChart),
          ),
        ],
        if (profile.insights.isNotEmpty) ...[
          gap,
          SectionCard(
            title: l10n.insights,
            child: InsightsList(insights: profile.insights),
          ),
        ],
        if (profile.history.isNotEmpty) ...[
          gap,
          SectionCard(
            title: l10n.matchLog,
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                for (final entry in profile.history) HistoryTile(entry: entry),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
