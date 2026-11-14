import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../awards/presentation/widgets/award_card.dart';
import '../../../fixtures/presentation/widgets/fixture_card.dart';
import '../../../news/presentation/widgets/post_card.dart';
import '../../../team/presentation/widgets/record_strip.dart';
import '../../domain/entities/home_data.dart';
import '../bloc/home_cubit.dart';
import '../widgets/live_banner_card.dart';
import '../widgets/team_header.dart';
import '../widgets/tier_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: DataStateView<HomeCubit, HomeData>(
        builder: (context, data) => _HomeContent(data: data),
      ),
    ),
  );
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.data});

  static const double _awardsHeight = 170;
  static const double _awardWidth = 150;
  static const double _newsHeight = 250;
  static const double _newsWidth = 240;

  final HomeData data;

  @override
  Widget build(BuildContext context) {
    const pad = EdgeInsets.symmetric(horizontal: AppSpacing.lg);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      children: [
        Padding(
          padding: pad,
          child: TeamHeader(team: data.team, updated: data.updated),
        ),
        if (data.live != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: LiveBannerCard(live: data.live!),
          ),
        if (data.nextFixture != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: FixtureCard(
              fixture: data.nextFixture!,
              title: context.l10n.nextMatch,
            ),
          ),
        if (data.latestPosts.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: pad,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.latestNews,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.news),
                  child: Text(context.l10n.seeAll),
                ),
              ],
            ),
          ),
          SizedBox(
            height: _newsHeight,
            child: ListView.separated(
              padding: pad,
              scrollDirection: Axis.horizontal,
              itemCount: data.latestPosts.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) => SizedBox(
                width: _newsWidth,
                child: PostCard(
                  key: ValueKey(data.latestPosts[i].slug),
                  post: data.latestPosts[i],
                  compact: true,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        for (final group in data.tiers) ...[
          TierSection(group: group),
          const SizedBox(height: AppSpacing.lg),
        ],
        Padding(
          padding: pad,
          child: SectionCard(
            title: context.l10n.teamRecord,
            child: RecordStrip(record: data.record),
          ),
        ),
        if (data.awards.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: pad,
            child: Text(
              context.l10n.awards,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: _awardsHeight,
            child: ListView.separated(
              padding: pad,
              scrollDirection: Axis.horizontal,
              itemCount: data.awards.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) => SizedBox(
                width: _awardWidth,
                child: AwardCard(
                  key: ValueKey(data.awards[i].key),
                  award: data.awards[i],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
