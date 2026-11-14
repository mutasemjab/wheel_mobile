import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/data_state.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/news_bloc.dart';
import '../widgets/post_card.dart';

/// "الأخبار" tab: category filter chips + infinite news feed.
class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  static const double _loadMoreThreshold = 400;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.newsTitle)),
    body: BlocConsumer<NewsBloc, NewsState>(
      listenWhen: (p, n) =>
          n.failure != null && n.items.isNotEmpty && p.failure != n.failure,
      listener: (context, state) => showFailureSnack(context, state.failure!),
      builder: (context, state) {
        final bloc = context.read<NewsBloc>();
        return Column(
          children: [
            if (state.visibleCategories.isNotEmpty)
              _CategoryChips(state: state),
            Expanded(
              child: state.items.isEmpty
                  ? switch (state.status) {
                      DataStatus.failure => ErrorView(
                        failure: state.failure!,
                        onRetry: () => bloc.add(const NewsStarted()),
                      ),
                      DataStatus.loaded => EmptyView(
                        message: context.l10n.newsEmpty,
                        icon: Icons.newspaper_rounded,
                      ),
                      _ => const LoadingView(),
                    }
                  : RefreshIndicator(
                      onRefresh: () async {
                        bloc.add(const NewsRefreshed());
                        await bloc.stream.firstWhere((s) => !s.isBusy);
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (n) {
                          if (n.metrics.extentAfter < _loadMoreThreshold) {
                            bloc.add(const NewsNextPageRequested());
                          }
                          return false;
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          itemCount:
                              state.items.length + (state.hasMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (_, i) => i >= state.items.length
                              ? const Padding(
                                  padding: EdgeInsets.all(AppSpacing.lg),
                                  child: LoadingView(),
                                )
                              : PostCard(
                                  key: ValueKey(state.items[i].slug),
                                  post: state.items[i],
                                ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    ),
  );
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.state});

  final NewsState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NewsBloc>();
    Widget chip(String label, String? key) => Padding(
      padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: state.category == key,
        onSelected: (_) => bloc.add(NewsCategorySelected(key)),
      ),
    );
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        children: [
          chip(context.l10n.newsAll, null),
          for (final c in state.visibleCategories)
            chip('${c.icon} ${c.title}', c.key),
        ],
      ),
    );
  }
}
