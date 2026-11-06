import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/live_scoreboard.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/live_viewer_cubit.dart';
import '../widgets/live_feed.dart';

class LiveViewerPage extends StatelessWidget {
  const LiveViewerPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.liveTitle)),
    body: BlocBuilder<LiveViewerCubit, LiveViewerState>(
      builder: (context, state) {
        final cubit = context.read<LiveViewerCubit>();
        final match = state.match;
        final clock = state.clock;
        if (match == null || clock == null) {
          return switch (state.status) {
            LiveViewerStatus.loading => const LoadingView(),
            LiveViewerStatus.failure => ErrorView(
              failure: state.failure!,
              onRetry: cubit.refresh,
            ),
            _ => RefreshIndicator(
              onRefresh: cubit.refresh,
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 2,
                    child: EmptyView(
                      message: context.l10n.noLiveMatch,
                      icon: Icons.sports_soccer_rounded,
                    ),
                  ),
                ],
              ),
            ),
          };
        }
        const gap = SizedBox(height: AppSpacing.md);
        return RefreshIndicator(
          onRefresh: cubit.refresh,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              LiveScoreboard(
                opponent: match.opponent,
                us: match.scoreUs,
                them: match.scoreThem,
                clock: clock,
              ),
              if (match.motm != null) ...[
                gap,
                SectionCard(
                  child: Text(
                    '⭐ ${context.l10n.motm}: ${state.nameOf(match.motm!)}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              if (match.events.isNotEmpty) ...[
                gap,
                SectionCard(
                  title: context.l10n.eventsFeed,
                  child: LiveFeed(events: match.events, nameOf: state.nameOf),
                ),
              ],
              if (match.playerStats.isNotEmpty) ...[
                gap,
                SectionCard(
                  title: context.l10n.playerStatsLive,
                  child: LivePlayerStatsTable(
                    stats: match.playerStats,
                    nameOf: state.nameOf,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    ),
  );
}
