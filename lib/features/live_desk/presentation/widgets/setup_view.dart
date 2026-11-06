import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../players/domain/entities/player.dart';
import '../bloc/live_desk_bloc.dart';
import '../bloc/live_setup_cubit.dart';

/// New match: opponent, date and squad (tap cycles played → excused → not called).
class SetupView extends StatelessWidget {
  const SetupView({super.key, required this.roster});

  final List<Player> roster;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => LiveSetupCubit(),
    child: _SetupForm(roster: roster),
  );
}

class _SetupForm extends StatelessWidget {
  const _SetupForm({required this.roster});

  final List<Player> roster;

  Future<void> _pickDate(BuildContext context, LiveSetupCubit cubit) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) cubit.setDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<LiveSetupCubit>();
    final state = context.watch<LiveSetupCubit>().state;
    final locale = Localizations.localeOf(context).languageCode;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        TextField(
          decoration: InputDecoration(labelText: l10n.opponent),
          textInputAction: TextInputAction.done,
          onChanged: cubit.setOpponent,
        ),
        const SizedBox(height: AppSpacing.md),
        ListTile(
          leading: const Icon(Icons.calendar_today_rounded),
          title: Text(l10n.date),
          subtitle: Text(DateUtilsX.display(state.date, locale)),
          onTap: () => _pickDate(context, cubit),
        ),
        const SizedBox(height: AppSpacing.md),
        SectionCard(
          title: l10n.squad,
          trailing: Text(l10n.playedCount(state.played.length)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.squadHint,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final p in roster)
                    _SquadChip(player: p, choice: state.choiceOf(p.slug)),
                ],
              ),
              if (!state.hasEnoughPlayers)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    l10n.minPlayed,
                    style: const TextStyle(color: AppColors.warning),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          onPressed: state.canSubmit
              ? () => context.read<LiveDeskBloc>().add(
                  LiveDeskSetupSubmitted(
                    opponent: state.opponent,
                    date: state.date,
                    played: state.played,
                    excused: state.excused,
                  ),
                )
              : null,
          icon: const Icon(Icons.sports_soccer_rounded),
          label: Text(l10n.startMatch),
        ),
      ],
    );
  }
}

class _SquadChip extends StatelessWidget {
  const _SquadChip({required this.player, required this.choice});

  final Player player;
  final SquadChoice choice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (color, label) = switch (choice) {
      SquadChoice.played => (AppColors.positive, l10n.statusPlayed),
      SquadChoice.excused => (AppColors.warning, l10n.statusExcused),
      SquadChoice.notCalled => (AppColors.neutral, l10n.statusNotCalled),
    };
    return ActionChip(
      onPressed: () => context.read<LiveSetupCubit>().cycle(player.slug),
      backgroundColor: color.withValues(
        alpha: choice == SquadChoice.notCalled ? 0.08 : 0.25,
      ),
      side: BorderSide(color: color),
      label: Text('${player.name} · $label'),
    );
  }
}
