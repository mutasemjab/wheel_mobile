import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/form_dots.dart';
import '../../domain/entities/player_profile.dart';

/// One match-log row: opponent, date, result, score, contributions, pts, delta.
class HistoryTile extends StatelessWidget {
  const HistoryTile({super.key, required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    final contributions = [
      if (entry.g > 0) '⚽ ${entry.g}',
      if (entry.a > 0) '🎯 ${entry.a}',
      if (entry.s > 0) '🧤 ${entry.s}',
      if (entry.t > 0) '🛡️ ${entry.t}',
      if (entry.v > 0) '🏢 ${entry.v}',
      if (entry.c > 0) '⚠️ ${entry.c}',
      if (entry.star) '⭐',
      if (entry.late) '⏰ ${l10n.lateRow}',
    ].join('  ');
    final result = entry.result;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      onTap: entry.matchCode.isEmpty
          ? null
          : () => context.push(AppRoutes.match(entry.matchCode)),
      title: Row(
        children: [
          Expanded(child: Text(entry.opponent, style: text.titleSmall)),
          if (result != null) ResultChip(result: result),
          const SizedBox(width: AppSpacing.sm),
          Text('${entry.scoreUs}–${entry.scoreThem}', style: text.titleSmall),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.date != null) Text(DateUtilsX.display(entry.date!, locale)),
          if (entry.excused)
            Text(
              l10n.excusedRow,
              style: const TextStyle(color: AppColors.warning),
            )
          else if (contributions.isNotEmpty)
            Text(contributions),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            l10n.pointsValue(NumberFormatX.compact(entry.pts)),
            style: text.labelMedium,
          ),
          Text(
            NumberFormatX.signed(entry.delta),
            style: text.titleSmall?.copyWith(
              color: AppColors.delta(entry.delta),
            ),
          ),
        ],
      ),
    );
  }
}
