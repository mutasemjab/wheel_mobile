import 'package:flutter/material.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/live_match_rules.dart';
import '../../domain/entities/live_match_state.dart';
import 'event_edit_sheet.dart';
import 'event_log_list.dart';
import 'match_edit_actions.dart';
import 'player_action_tile.dart';
import 'player_menu_sheet.dart';
import 'player_picker_sheet.dart';

/// Global goal buttons, player tiles and the event log. Shared by the live
/// desk and the finished-match editor via [MatchEditActions].
class MatchBoard extends StatelessWidget {
  const MatchBoard({
    super.key,
    required this.match,
    required this.nameOf,
    required this.squadPool,
    required this.actions,
    this.enabled = true,
  });

  static const double _tileExtent = 132;
  static const double _maxTileWidth = 220;

  final LiveMatchState match;
  final String Function(String slug) nameOf;

  /// Every active player slug (for emergency additions).
  final List<String> squadPool;
  final MatchEditActions actions;
  final bool enabled;

  List<(String, String)> get _played => [
    for (final s in match.played) (s, nameOf(s)),
  ];

  Future<void> _goal(BuildContext context, String scorer) async {
    final l10n = context.l10n;
    final pick = await showPlayerPicker(
      context,
      title: l10n.whoAssisted,
      options: _played.where((p) => p.$1 != scorer).toList(),
      noneLabel: l10n.noAssist,
    );
    if (pick == null) return;
    actions.addEvent(LiveEventType.goal, player: scorer, assist: pick.slug);
  }

  Future<void> _goalForUs(BuildContext context) async {
    final pick = await showPlayerPicker(
      context,
      title: context.l10n.whoScored,
      options: _played,
    );
    final scorer = pick?.slug;
    if (scorer == null || !context.mounted) return;
    await _goal(context, scorer);
  }

  Future<void> _goalAgainst(BuildContext context) async {
    final l10n = context.l10n;
    final pick = await showPlayerPicker(
      context,
      title: l10n.whoCaused,
      options: _played,
      noneLabel: l10n.nobody,
    );
    if (pick == null) return;
    actions.addEvent(LiveEventType.against, player: pick.slug);
  }

  Future<void> _emergency(BuildContext context) async {
    final l10n = context.l10n;
    final available = [
      for (final s in squadPool)
        if (!match.played.contains(s)) (s, nameOf(s)),
    ];
    if (available.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.noEmergencyPlayers)));
      return;
    }
    final pick = await showPlayerPicker(
      context,
      title: l10n.addEmergency,
      options: available,
    );
    final slug = pick?.slug;
    if (slug != null) actions.addEmergencyPlayer(slug);
  }

  Future<void> _edit(BuildContext context, LiveEvent event) async {
    final result = await showEventEditSheet(
      context,
      event: event,
      played: _played,
      nameOf: nameOf,
    );
    switch (result) {
      case EventEditSaved(:final event):
        actions.editEvent(event);
      case EventEditDeleted():
        actions.removeEvent(event.uuid);
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tallies = match.tallies;
    final canAdd = enabled && match.canAddEvent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: canAdd ? () => _goalForUs(context) : null,
              icon: const Text('⚽'),
              label: Text(l10n.goalForUs),
            ),
            FilledButton.tonalIcon(
              onPressed: canAdd
                  ? () => actions.addEvent(LiveEventType.og)
                  : null,
              icon: const Text('🎁'),
              label: Text(l10n.ownGoalOpponent),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.negative,
              ),
              onPressed: canAdd ? () => _goalAgainst(context) : null,
              icon: const Text('🥅'),
              label: Text(l10n.goalAgainstUs),
            ),
            OutlinedButton.icon(
              onPressed: enabled ? () => _emergency(context) : null,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: Text(l10n.addEmergency),
            ),
          ],
        ),
        if (!match.canAddEvent)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(l10n.eventsLimit, textAlign: TextAlign.center),
          ),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: _maxTileWidth,
            mainAxisExtent: _tileExtent,
            crossAxisSpacing: AppSpacing.xs,
            mainAxisSpacing: AppSpacing.xs,
          ),
          itemCount: match.played.length,
          itemBuilder: (context, i) {
            final slug = match.played[i];
            return PlayerActionTile(
              name: nameOf(slug),
              tally: tallies[slug] ?? const PlayerTally(),
              isMotm: match.motm == slug,
              isLate: match.late.contains(slug),
              isUnfair: match.unfair.contains(slug),
              values: match.values[slug] ?? 0,
              enabled: canAdd,
              onGoal: () => _goal(context, slug),
              onSave: () => actions.addEvent(LiveEventType.save, player: slug),
              onTackle: () =>
                  actions.addEvent(LiveEventType.tackle, player: slug),
              onMenu: () => showPlayerMenu(
                context,
                name: nameOf(slug),
                isMotm: match.motm == slug,
                isUnfair: match.unfair.contains(slug),
                isLate: match.late.contains(slug),
                values: match.values[slug] ?? 0,
                onToggleMotm: () =>
                    actions.setMotm(match.motm == slug ? null : slug),
                onValues: (delta) => actions.changeValues(slug, delta),
                onToggleUnfair: () => actions.toggleUnfair(slug),
                onToggleLate: () => actions.toggleLate(slug),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SectionCard(
          title: l10n.eventLog,
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: EventLogList(
            events: match.events,
            nameOf: nameOf,
            onTap: (e) => enabled ? _edit(context, e) : null,
          ),
        ),
      ],
    );
  }
}
