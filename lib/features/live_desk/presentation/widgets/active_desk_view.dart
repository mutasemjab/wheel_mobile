import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/live_match_state.dart';
import '../bloc/live_desk_bloc.dart';
import 'desk_header.dart';
import 'match_board.dart';
import 'match_edit_actions.dart';
import 'player_picker_sheet.dart';

/// The running match: header, board and the finish button.
class ActiveDeskView extends StatelessWidget {
  const ActiveDeskView({super.key, required this.state});

  final LiveDeskState state;

  Future<void> _finish(BuildContext context, LiveMatchState match) async {
    final l10n = context.l10n;
    final bloc = context.read<LiveDeskBloc>();
    if (!await confirmDialog(context, message: l10n.finishConfirm)) return;
    var motm = match.motm;
    if (motm == null && context.mounted) {
      final pick = await showPlayerPicker(
        context,
        title: l10n.pickMotm,
        options: [for (final s in match.played) (s, state.nameOf(s))],
        noneLabel: l10n.nobody,
      );
      if (pick == null) return;
      motm = pick.slug;
    }
    bloc.add(LiveDeskFinishRequested(motm: motm));
  }

  @override
  Widget build(BuildContext context) {
    final match = state.match!;
    final bloc = context.read<LiveDeskBloc>();
    final finishing = state.status == LiveDeskStatus.finishing;
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            DeskHeader(
              match: match,
              offsetMs: state.offsetMs,
              onToggleClock: finishing
                  ? null
                  : () => bloc.add(const LiveDeskClockToggled()),
            ),
            const SizedBox(height: AppSpacing.md),
            MatchBoard(
              match: match,
              nameOf: state.nameOf,
              squadPool: [for (final p in state.roster) p.slug],
              actions: _BlocActions(bloc),
              enabled: !finishing,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              onPressed: finishing ? null : () => _finish(context, match),
              icon: const Icon(Icons.flag_rounded),
              label: Text(context.l10n.finishMatch),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
        if (finishing)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      context.l10n.waitingSync,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BlocActions implements MatchEditActions {
  const _BlocActions(this._bloc);

  final LiveDeskBloc _bloc;

  @override
  void addEvent(LiveEventType type, {String? player, String? assist}) =>
      _bloc.add(LiveDeskEventAdded(type, player: player, assist: assist));

  @override
  void editEvent(LiveEvent event) => _bloc.add(LiveDeskEventEdited(event));

  @override
  void removeEvent(String uuid) => _bloc.add(LiveDeskEventRemoved(uuid));

  @override
  void setMotm(String? slug) => _bloc.add(LiveDeskMotmChanged(slug));

  @override
  void changeValues(String slug, int delta) =>
      _bloc.add(LiveDeskValuesChanged(slug, delta));

  @override
  void toggleUnfair(String slug) => _bloc.add(LiveDeskUnfairToggled(slug));

  @override
  void toggleLate(String slug) => _bloc.add(LiveDeskLateToggled(slug));

  @override
  void addEmergencyPlayer(String slug) =>
      _bloc.add(LiveDeskEmergencyPlayerAdded(slug));
}
