import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../domain/entities/post.dart';
import '../bloc/post_detail_cubit.dart';
import '../widgets/post_blocks.dart';
import '../widgets/post_card.dart';
import '../widgets/post_cover.dart';

/// Full article: cover, title, body blocks, share, related posts.
class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  static const double _coverHeight = 220;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DataStateView<PostDetailCubit, PostDetail>(
      builder: (context, post) {
        final text = Theme.of(context).textTheme;
        final summary = post.summary;
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: _coverHeight,
              actions: [
                IconButton(
                  tooltip: context.l10n.share,
                  icon: const Icon(Icons.share_rounded),
                  onPressed: () => SharePlus.instance.share(
                    ShareParams(
                      subject: summary.title,
                      text: '${summary.title}\n\n${post.body}',
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: PostCover(post: summary, iconSize: 64),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList.list(
                children: [
                  Text(
                    '${summary.category.icon} ${summary.category.title}',
                    style: text.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(summary.title, style: text.headlineSmall),
                  const SizedBox(height: AppSpacing.sm),
                  PostMeta(post: summary),
                  const Divider(height: AppSpacing.xxl),
                  PostBlocks(blocks: post.blocks),
                  if (post.related.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(context.l10n.newsRelated, style: text.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    for (final r in post.related)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: PostCard(key: ValueKey(r.slug), post: r),
                      ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}
