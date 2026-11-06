import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/live_desk_bloc.dart';
import '../widgets/active_desk_view.dart';
import '../widgets/finished_view.dart';
import '../widgets/setup_view.dart';
import '../widgets/sync_indicator.dart';

class LiveDeskPage extends StatelessWidget {
  const LiveDeskPage({super.key});

  Future<void> _onConflict(BuildContext context, LiveDeskState state) async {
    final l10n = context.l10n;
    final bloc = context.read<LiveDeskBloc>();
    if (state.conflict == null) {
      // Our code belongs to an already-published match: nothing to resume.
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          content: Text(l10n.alreadyPublished),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.confirm),
            ),
          ],
        ),
      );
      bloc.add(const LiveDeskConflictDiscarded());
      return;
    }
    final resume = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        content: Text(l10n.resumePrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.discard),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.resume),
          ),
        ],
      ),
    );
    if (resume ?? false) {
      bloc.add(const LiveDeskConflictResumed());
    } else if (context.mounted &&
        await confirmDialog(
          context,
          message: l10n.discardConfirm,
          destructive: true,
        )) {
      bloc.add(const LiveDeskConflictDiscarded());
    } else if (context.mounted) {
      await _onConflict(context, state);
    }
  }

  void _listener(BuildContext context, LiveDeskState state) {
    final l10n = context.l10n;
    if (state.status == LiveDeskStatus.conflict) {
      _onConflict(context, state);
      return;
    }
    if (state.status == LiveDeskStatus.published &&
        state.publishedCode != null) {
      showMessageSnack(context, l10n.published);
      context.go(AppRoutes.adminMatch(state.publishedCode!));
      return;
    }
    final failure = state.failure;
    if (failure != null) {
      // A failed finish lands back on the desk: the last sync did not go through.
      final prefix = state.status == LiveDeskStatus.active
          ? '${l10n.syncFailedRetry}\n'
          : '';
      showMessageSnack(context, '$prefix${failure.message(l10n)}');
    } else if (state.lastUndone != null) {
      showMessageSnack(
        context,
        l10n.undone,
        action: SnackBarAction(
          label: l10n.redo,
          onPressed: () =>
              context.read<LiveDeskBloc>().add(const LiveDeskRedoRequested()),
        ),
      );
    }
  }

  Future<void> _discard(BuildContext context) async {
    final bloc = context.read<LiveDeskBloc>();
    if (await confirmDialog(
      context,
      message: context.l10n.discardConfirm,
      destructive: true,
    )) {
      bloc.add(const LiveDeskDiscardRequested());
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<LiveDeskBloc, LiveDeskState>(
        listenWhen: (p, n) =>
            (n.status != p.status &&
                (n.status == LiveDeskStatus.conflict ||
                    n.status == LiveDeskStatus.published)) ||
            (n.failure != null && n.failure != p.failure) ||
            (n.lastUndone != null && n.lastUndone != p.lastUndone),
        listener: _listener,
        builder: (context, state) {
          final l10n = context.l10n;
          final match = state.match;
          final bloc = context.read<LiveDeskBloc>();
          final active = state.status == LiveDeskStatus.active;
          return Scaffold(
            appBar: AppBar(
              title: Text(match == null ? l10n.liveDesk : match.opponent),
              actions: [
                if (match != null)
                  SyncIndicator(
                    status: match.syncStatus,
                    onRetry: () => bloc.add(const LiveDeskSyncRequested()),
                  ),
                if (active && match!.events.isNotEmpty)
                  IconButton(
                    tooltip: l10n.undo,
                    onPressed: () => bloc.add(const LiveDeskUndoRequested()),
                    icon: const Icon(Icons.undo_rounded),
                  ),
                if (match != null &&
                    (active || state.status == LiveDeskStatus.finished))
                  PopupMenuButton<void>(
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        onTap: () => _discard(context),
                        child: Text(l10n.discardMatch),
                      ),
                    ],
                  ),
              ],
            ),
            body: switch (state.status) {
              LiveDeskStatus.initial ||
              LiveDeskStatus.loading => const LoadingView(),
              LiveDeskStatus.setup => SetupView(roster: state.roster),
              LiveDeskStatus.conflict when match == null => const LoadingView(),
              LiveDeskStatus.active ||
              LiveDeskStatus.finishing ||
              LiveDeskStatus.conflict => ActiveDeskView(state: state),
              LiveDeskStatus.finished ||
              LiveDeskStatus.publishing => FinishedView(
                match: match!,
                nameOf: state.nameOf,
                publishing: state.status == LiveDeskStatus.publishing,
              ),
              LiveDeskStatus.published => const LoadingView(),
            },
          );
        },
      );
}
