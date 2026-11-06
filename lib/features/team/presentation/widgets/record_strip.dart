import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/stat_chip.dart';
import '../../domain/entities/team.dart';

/// W / D / L · GF / GA strip.
class RecordStrip extends StatelessWidget {
  const RecordStrip({super.key, required this.record});

  final TeamRecord record;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StatChip(
          label: l10n.recordWins,
          value: '${record.w}',
          color: AppColors.positive,
        ),
        StatChip(
          label: l10n.recordDraws,
          value: '${record.d}',
          color: AppColors.neutral,
        ),
        StatChip(
          label: l10n.recordLosses,
          value: '${record.l}',
          color: AppColors.negative,
        ),
        StatChip(label: l10n.recordGoalsFor, value: '${record.gf}'),
        StatChip(label: l10n.recordGoalsAgainst, value: '${record.ga}'),
      ],
    );
  }
}
