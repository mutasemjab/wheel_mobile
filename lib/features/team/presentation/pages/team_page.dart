import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/form_dots.dart';
import '../../../../core/widgets/insights_list.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/stat_chip.dart';
import '../../domain/entities/team.dart';
import '../bloc/team_cubit.dart';
import '../widgets/record_strip.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.teamTitle)),
    body: DataStateView<TeamCubit, TeamOverview>(
      builder: (context, team) {
        final l10n = context.l10n;
        const gap = SizedBox(height: AppSpacing.md);
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            SectionCard(
              title: team.info.name,
              trailing: team.info.slogan == null
                  ? null
                  : Text(team.info.slogan!),
              child: RecordStrip(record: team.record),
            ),
            gap,
            SectionCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatChip(
                    label: l10n.winPct,
                    value: '${NumberFormatX.compact(team.winPct)}%',
                  ),
                  StatChip(
                    label: l10n.goalsPerMatch,
                    value: NumberFormatX.compact(team.gfPerMatch),
                  ),
                  StatChip(
                    label: l10n.concededPerMatch,
                    value: NumberFormatX.compact(team.gaPerMatch),
                  ),
                ],
              ),
            ),
            if (team.last5.isNotEmpty) ...[
              gap,
              SectionCard(
                title: l10n.last5,
                child: Center(child: FormDots(results: team.last5)),
              ),
            ],
            if (team.insights.isNotEmpty) ...[
              gap,
              SectionCard(
                title: l10n.insights,
                child: InsightsList(insights: team.insights),
              ),
            ],
          ],
        );
      },
    ),
  );
}
