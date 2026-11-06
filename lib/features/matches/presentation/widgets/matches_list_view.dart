import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/entities/data_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/matches_bloc.dart';
import 'match_tile.dart';

/// Infinite, pull-to-refresh match list driven by a [MatchesBloc]; shared by
/// the public matches tab and the admin finished-matches screen.
class MatchesListView extends StatelessWidget {
  const MatchesListView({super.key, required this.routeFor});

  static const double _loadMoreThreshold = 300;

  /// Detail route for a match code.
  final String Function(String code) routeFor;

  @override
  Widget build(BuildContext context) => BlocConsumer<MatchesBloc, MatchesState>(
    listenWhen: (p, n) =>
        n.failure != null && n.items.isNotEmpty && p.failure != n.failure,
    listener: (context, state) => showFailureSnack(context, state.failure!),
    builder: (context, state) {
      final bloc = context.read<MatchesBloc>();
      if (state.items.isEmpty) {
        return switch (state.status) {
          DataStatus.failure => ErrorView(
            failure: state.failure!,
            onRetry: () => bloc.add(const MatchesStarted()),
          ),
          DataStatus.loaded => const EmptyView(),
          _ => const LoadingView(),
        };
      }
      return RefreshIndicator(
        onRefresh: () async {
          bloc.add(const MatchesRefreshed());
          await bloc.stream.firstWhere((s) => !s.isBusy);
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.extentAfter < _loadMoreThreshold) {
              bloc.add(const MatchesNextPageRequested());
            }
            return false;
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: state.items.length + (state.hasMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              if (i >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: LoadingView(),
                );
              }
              final match = state.items[i];
              return MatchTile(
                match: match,
                motmName: match.played
                    .where((p) => p.slug == match.motm)
                    .firstOrNull
                    ?.name,
                onTap: () => context.push(routeFor(match.code)),
              );
            },
          ),
        ),
      );
    },
  );
}

extension on MatchesState {
  bool get isBusy =>
      status == DataStatus.loading || status == DataStatus.refreshing;
}
