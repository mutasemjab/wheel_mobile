import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/summary_actions.dart';
import '../../../matches/domain/entities/match.dart';
import '../../../matches/presentation/bloc/match_detail_cubit.dart';
import '../../../matches/presentation/widgets/match_detail_view.dart';
import '../bloc/admin_match_actions_cubit.dart';

/// Public match breakdown + WhatsApp summary, edit and delete (by permission).
class AdminMatchDetailPage extends StatelessWidget {
  const AdminMatchDetailPage({
    super.key,
    required this.canEdit,
    required this.canDelete,
  });

  final bool canEdit;
  final bool canDelete;

  Future<void> _delete(BuildContext context) async {
    final cubit = context.read<AdminMatchActionsCubit>();
    final ok = await confirmDialog(
      context,
      message: context.l10n.deleteMatchConfirm,
      destructive: true,
    );
    if (ok) await cubit.delete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = context.read<AdminMatchActionsCubit>();
    return BlocListener<AdminMatchActionsCubit, AdminMatchActionsState>(
      listener: (context, state) {
        if (state.failure != null) showFailureSnack(context, state.failure!);
        if (state.status == MatchActionStatus.deleted) {
          showMessageSnack(context, l10n.deleted);
          context.go(AppRoutes.adminMatches);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.matchDetail),
          actions: [
            if (canEdit)
              IconButton(
                tooltip: l10n.editMatch,
                onPressed: () =>
                    context.push(AppRoutes.adminMatchEdit(actions.code)),
                icon: const Icon(Icons.edit_rounded),
              ),
            if (canDelete)
              IconButton(
                tooltip: l10n.deleteMatch,
                onPressed: () => _delete(context),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
          ],
        ),
        body: DataStateView<MatchDetailCubit, MatchDetail>(
          builder: (context, detail) => MatchDetailView(
            detail: detail,
            header: const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: _SummaryCard(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminMatchActionsCubit, AdminMatchActionsState>(
        builder: (context, state) {
          final summary = state.summary;
          return SectionCard(
            title: context.l10n.whatsappSummary,
            child: summary != null
                ? SummaryActions(text: summary)
                : OutlinedButton.icon(
                    onPressed: state.status == MatchActionStatus.loadingSummary
                        ? null
                        : context.read<AdminMatchActionsCubit>().loadSummary,
                    icon: const Icon(Icons.chat_rounded),
                    label: Text(context.l10n.whatsappSummary),
                  ),
          );
        },
      );
}
