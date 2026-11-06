import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/tier_badge.dart';
import '../../domain/entities/standings.dart';
import '../bloc/standings_cubit.dart';
import '../widgets/standing_player_tile.dart';
import '../widgets/standings_table.dart';

class StandingsPage extends StatelessWidget {
  const StandingsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => StandingsViewCubit(),
    child: Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navStandings),
        actions: const [_LayoutToggle()],
      ),
      body: DataStateView<StandingsCubit, Standings>(
        isEmpty: (s) => s.allPlayers.isEmpty,
        builder: (context, standings) =>
            BlocBuilder<StandingsViewCubit, StandingsViewState>(
              builder: (context, view) => view.layout == StandingsLayout.table
                  ? StandingsTable(standings: standings)
                  : _TierTabs(standings: standings),
            ),
      ),
    ),
  );
}

class _LayoutToggle extends StatelessWidget {
  const _LayoutToggle();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StandingsViewCubit>();
    final isTable = cubit.state.layout == StandingsLayout.table;
    return IconButton(
      tooltip: isTable ? context.l10n.viewCards : context.l10n.viewTable,
      icon: Icon(
        isTable ? Icons.view_agenda_rounded : Icons.table_rows_rounded,
      ),
      onPressed: () => cubit.setLayout(
        isTable ? StandingsLayout.cards : StandingsLayout.table,
      ),
    );
  }
}

class _TierTabs extends StatelessWidget {
  const _TierTabs({required this.standings});

  final Standings standings;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: standings.tiers.length,
    child: Column(
      children: [
        TabBar(
          tabs: [
            for (final t in standings.tiers)
              Tab(
                child: TierBadge(tier: t.tier, title: t.title),
              ),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              for (final t in standings.tiers)
                t.players.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 200, child: EmptyView()),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: t.players.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (_, i) => StandingPlayerTile(
                          player: t.players[i],
                          tier: t.tier,
                        ),
                      ),
            ],
          ),
        ),
      ],
    ),
  );
}
