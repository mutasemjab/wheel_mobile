import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/settings.dart';
import '../bloc/settings_cubit.dart';

class TeamSettingsCard extends StatelessWidget {
  const TeamSettingsCard({super.key, required this.team, required this.busy});

  final TeamSettings team;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();
    return SectionCard(
      title: l10n.teamSettings,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: team.name,
            decoration: InputDecoration(labelText: l10n.teamName),
            onChanged: (v) => cubit.setTeam(cubit.state.team.copyWith(name: v)),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            initialValue: team.slogan,
            decoration: InputDecoration(labelText: l10n.slogan),
            onChanged: (v) =>
                cubit.setTeam(cubit.state.team.copyWith(slogan: v)),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            initialValue: team.publicSiteUrl,
            keyboardType: TextInputType.url,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(labelText: l10n.publicSiteUrl),
            onChanged: (v) =>
                cubit.setTeam(cubit.state.team.copyWith(publicSiteUrl: v)),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: busy ? null : cubit.saveTeam,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
