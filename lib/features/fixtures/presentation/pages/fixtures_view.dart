import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/fixture.dart';
import '../bloc/fixtures_cubit.dart';
import '../widgets/fixture_card.dart';

/// "المواعيد" tab of the Matches screen: upcoming fixtures, then recent ones.
class FixturesView extends StatelessWidget {
  const FixturesView({super.key});

  @override
  Widget build(BuildContext context) =>
      DataStateView<FixturesCubit, FixturesData>(
        builder: (context, data) {
          final l10n = context.l10n;
          final text = Theme.of(context).textTheme;
          Widget header(String label) => Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: Text(label, style: text.titleMedium),
          );
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              header(l10n.fixturesUpcoming),
              if (data.upcoming.isEmpty)
                EmptyView(
                  message: l10n.noFixtures,
                  icon: Icons.event_busy_rounded,
                )
              else
                for (final f in data.upcoming)
                  FixtureCard(key: ValueKey(f.id), fixture: f),
              if (data.recent.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                header(l10n.fixturesRecent),
                for (final f in data.recent)
                  FixtureCard(key: ValueKey(f.id), fixture: f),
              ],
            ],
          );
        },
      );
}
