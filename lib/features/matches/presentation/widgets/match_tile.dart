import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/form_dots.dart';
import '../../domain/entities/match.dart';

/// Date, opponent, score, result chip and MOTM.
class MatchTile extends StatelessWidget {
  const MatchTile({super.key, required this.match, this.motmName, this.onTap});

  final FootballMatch match;
  final String? motmName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        title: Text(match.opponent, style: text.titleMedium),
        subtitle: Text(
          [
            if (match.date != null) DateUtilsX.display(match.date!, locale),
            if (motmName != null) '⭐ ${context.l10n.motm}: $motmName',
          ].join(' · '),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${match.scoreUs}–${match.scoreThem}', style: text.titleLarge),
            const SizedBox(width: AppSpacing.sm),
            ResultChip(result: match.result),
          ],
        ),
      ),
    );
  }
}
