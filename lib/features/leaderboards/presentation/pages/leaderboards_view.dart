import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/stat_chip.dart';
import '../../domain/entities/leaderboards.dart';
import '../bloc/leaderboards_cubit.dart';
import '../widgets/board_card.dart';
import '../widgets/goals_bar_chart.dart';

/// Leaderboards tab of the Stats screen.
class LeaderboardsView extends StatelessWidget {
  const LeaderboardsView({super.key});

  @override
  Widget build(BuildContext context) =>
      DataStateView<LeaderboardsCubit, Leaderboards>(
        builder: (context, data) {
          final l10n = context.l10n;
          final avg = data.averages;
          const gap = SizedBox(height: AppSpacing.md);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              SectionCard(
                title: l10n.teamAverages,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StatChip(
                      label: l10n.goalsPerMatch,
                      value: NumberFormatX.compact(avg.goalsPerMatch),
                    ),
                    StatChip(
                      label: l10n.concededPerMatch,
                      value: NumberFormatX.compact(avg.concededPerMatch),
                    ),
                    StatChip(
                      label: l10n.appsPerPlayer,
                      value: NumberFormatX.compact(avg.appsPerPlayer),
                    ),
                  ],
                ),
              ),
              if (data.goalsChart.isNotEmpty) ...[
                gap,
                SectionCard(
                  title: l10n.goalsChart,
                  child: GoalsBarChart(points: data.goalsChart),
                ),
              ],
              for (final kind in BoardKind.values)
                if (data.boards[kind]?.isNotEmpty ?? false) ...[
                  gap,
                  BoardCard(kind: kind, entries: data.boards[kind]!),
                ],
            ],
          );
        },
      );
}
