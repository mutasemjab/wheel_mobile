import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/form_dots.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/match.dart';
import 'match_ratings_card.dart';

/// Full match breakdown; shared by the public and admin detail pages.
class MatchDetailView extends StatelessWidget {
  const MatchDetailView({super.key, required this.detail, this.header});

  final MatchDetail detail;

  /// Optional widget shown above the scoreboard (admin actions).
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final m = detail.match;
    const gap = SizedBox(height: AppSpacing.md);
    String counts(Map<String, int> map) => map.entries
        .map((e) => '${detail.nameOf(e.key)} ×${e.value}')
        .join('، ');
    String names(List<String> slugs) => slugs.map(detail.nameOf).join('، ');
    final sections = <(String, String)>[
      if (m.saves.isNotEmpty) (l10n.savesTitle, counts(m.saves)),
      if (m.tackles.isNotEmpty) (l10n.tacklesTitle, counts(m.tackles)),
      if (m.og > 0) (l10n.opponentOwnGoals, '${m.og}'),
      if (m.caused.isNotEmpty) (l10n.causedGoals, counts(m.caused)),
      if (m.late.isNotEmpty) (l10n.lateTitle, names(m.late)),
      if (m.excused.isNotEmpty) (l10n.excusedTitle, names(m.excused)),
      if (m.unfair.isNotEmpty) (l10n.unfairTitle, names(m.unfair)),
      if (m.values.isNotEmpty) (l10n.valuesTitle, counts(m.values)),
      if (m.note != null) (l10n.noteTitle, m.note!),
      (
        l10n.playedTitle,
        m.everyonePlayed
            ? l10n.everyonePlayed
            : m.played.map((p) => p.name).join('، '),
      ),
    ];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ?header,
        _Scoreboard(
          match: m,
          motmName: m.motm == null ? null : detail.nameOf(m.motm!),
        ),
        if (m.goals.isNotEmpty) ...[
          gap,
          SectionCard(
            title: l10n.scorers,
            child: Column(
              children: [
                for (final g in m.goals)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Text('⚽', style: TextStyle(fontSize: 18)),
                    title: Text(detail.nameOf(g.by)),
                    subtitle: g.assist == null
                        ? null
                        : Text(l10n.assistBy(detail.nameOf(g.assist!))),
                    trailing: g.minute == null
                        ? null
                        : Text(l10n.minuteLabel(g.minute!)),
                  ),
              ],
            ),
          ),
        ],
        if (m.ratings.isNotEmpty) ...[
          gap,
          MatchRatingsCard(ratings: m.ratings),
        ],
        for (final (title, body) in sections) ...[
          gap,
          SectionCard(title: title, child: Text(body)),
        ],
      ],
    );
  }
}

class _Scoreboard extends StatelessWidget {
  const _Scoreboard({required this.match, this.motmName});

  final FootballMatch match;
  final String? motmName;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    return SectionCard(
      child: Column(
        children: [
          if (match.date != null) Text(DateUtilsX.display(match.date!, locale)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'WHEEL FC',
                  textAlign: TextAlign.center,
                  style: text.titleMedium,
                ),
              ),
              Text(
                '${match.scoreUs} – ${match.scoreThem}',
                style: text.displaySmall,
              ),
              Expanded(
                child: Text(
                  match.opponent,
                  textAlign: TextAlign.center,
                  style: text.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ResultChip(result: match.result),
          if (motmName != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('⭐ ${context.l10n.motm}: $motmName', style: text.titleSmall),
          ],
        ],
      ),
    );
  }
}
