import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../live_desk/domain/entities/live_match_state.dart';
import '../../../live_desk/presentation/widgets/match_board.dart';
import '../../../live_desk/presentation/widgets/match_edit_actions.dart';
import '../bloc/match_editor_cubit.dart';

/// Edit a finished match with the same widgets as the live desk.
class MatchEditorPage extends StatelessWidget {
  const MatchEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<MatchEditorCubit, MatchEditorState>(
      listenWhen: (p, n) => n.status != p.status || n.failure != p.failure,
      listener: (context, state) {
        if (state.failure != null && state.match != null) {
          showFailureSnack(context, state.failure!);
        }
        if (state.status == EditorStatus.saved) {
          showMessageSnack(context, l10n.saved);
          context.pop();
        }
      },
      builder: (context, state) {
        final cubit = context.read<MatchEditorCubit>();
        final match = state.match;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.editMatch),
            actions: [
              if (match != null)
                TextButton(
                  onPressed: state.status == EditorStatus.saving
                      ? null
                      : cubit.save,
                  child: Text(l10n.save),
                ),
            ],
          ),
          body: switch (state.status) {
            EditorStatus.loading => const LoadingView(),
            EditorStatus.failure when match == null => ErrorView(
              failure: state.failure!,
              onRetry: cubit.load,
            ),
            _ => _EditorForm(match: match!, state: state),
          },
        );
      },
    );
  }
}

class _EditorForm extends StatelessWidget {
  const _EditorForm({required this.match, required this.state});

  final LiveMatchState match;
  final MatchEditorState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<MatchEditorCubit>();
    final locale = Localizations.localeOf(context).languageCode;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        TextFormField(
          initialValue: match.opponent,
          decoration: InputDecoration(labelText: l10n.opponent),
          onChanged: cubit.setOpponent,
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today_rounded),
          title: Text(l10n.date),
          subtitle: Text(DateUtilsX.display(match.date, locale)),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: match.date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) cubit.setDate(picked);
          },
        ),
        TextFormField(
          initialValue: state.note,
          decoration: InputDecoration(labelText: l10n.noteField),
          maxLines: 2,
          onChanged: cubit.setNote,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'WHEEL FC ${match.scoreUs} – ${match.scoreThem} ${match.opponent}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        MatchBoard(
          match: match,
          nameOf: state.nameOf,
          squadPool: state.names.keys.toList(),
          actions: _CubitActions(cubit),
          enabled: state.status != EditorStatus.saving,
        ),
      ],
    );
  }
}

class _CubitActions implements MatchEditActions {
  const _CubitActions(this._cubit);

  final MatchEditorCubit _cubit;

  @override
  void addEvent(LiveEventType type, {String? player, String? assist}) =>
      _cubit.addEvent(type, player: player, assist: assist);

  @override
  void editEvent(LiveEvent event) => _cubit.editEvent(event);

  @override
  void removeEvent(String uuid) => _cubit.removeEvent(uuid);

  @override
  void setMotm(String? slug) => _cubit.setMotm(slug);

  @override
  void changeValues(String slug, int delta) => _cubit.changeValues(slug, delta);

  @override
  void toggleUnfair(String slug) => _cubit.toggleUnfair(slug);

  @override
  void toggleLate(String slug) => _cubit.toggleLate(slug);

  @override
  void addEmergencyPlayer(String slug) => _cubit.addEmergencyPlayer(slug);
}
