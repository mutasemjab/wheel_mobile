import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/stat_chip.dart';
import '../../domain/entities/player.dart';

/// Season KPIs. Goalkeepers show saves and clean sheets instead of tackles.
class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key, required this.player});

  static const int _columns = 4;

  final Player player;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = player.stats;
    final items = <(String, int)>[
      (l10n.statMatches, s.mp),
      (l10n.statGoals, s.g),
      (l10n.statAssists, s.a),
      if (player.isGoalkeeper) ...[
        (l10n.statSaves, s.s),
        (l10n.statCleanSheets, s.cs),
      ] else
        (l10n.statTackles, s.t),
      (l10n.statWins, s.w),
      (l10n.statDraws, s.d),
      (l10n.statLosses, s.l),
      (l10n.statMotm, s.motm),
      (l10n.statFairPlay, s.fp),
      (l10n.statValues, s.val),
      (l10n.statExcused, s.exc),
      (l10n.statLate, s.late),
      (l10n.statCaused, s.cg),
    ];
    return GridView.count(
      crossAxisCount: _columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.1,
      children: [
        for (final (label, value) in items)
          StatChip(label: label, value: '$value'),
      ],
    );
  }
}
