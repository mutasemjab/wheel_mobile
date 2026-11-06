import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/summary_actions.dart';
import '../../domain/entities/live_match_state.dart';
import '../bloc/live_desk_bloc.dart';

/// After finish: score from local state, server WhatsApp text, publish.
class FinishedView extends StatelessWidget {
  const FinishedView({
    super.key,
    required this.match,
    required this.nameOf,
    required this.publishing,
  });

  final LiveMatchState match;
  final String Function(String slug) nameOf;
  final bool publishing;

  Future<void> _publish(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      message: context.l10n.publishConfirm,
    );
    if (ok && context.mounted) {
      context.read<LiveDeskBloc>().add(const LiveDeskPublishRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final summary = match.summary;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        SectionCard(
          child: Column(
            children: [
              Text(l10n.summaryTitle, style: text.titleMedium),
              if (match.motm != null)
                Text('⭐ ${l10n.motm}: ${nameOf(match.motm!)}'),
            ],
          ),
        ),
        if (summary != null && summary.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          SummaryActions(text: summary),
        ],
        const SizedBox(height: AppSpacing.xl),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          onPressed: publishing ? null : () => _publish(context),
          icon: publishing
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.publish_rounded),
          label: Text(l10n.publish),
        ),
      ],
    );
  }
}
