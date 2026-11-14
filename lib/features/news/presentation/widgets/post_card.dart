import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/post.dart';
import 'post_cover.dart';

/// News item: cover, category, title, excerpt and meta line. Tap → article.
/// [compact] is the narrower card used in the home carousel.
class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, this.compact = false});

  final PostSummary post;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.post(post.slug)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: compact ? 16 / 8 : 16 / 9,
              child: PostCover(post: post, iconSize: compact ? 32 : 44),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${post.category.icon} ${post.category.title}',
                          style: text.labelMedium?.copyWith(
                            color: scheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (post.isPinned) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Icon(
                          Icons.push_pin_rounded,
                          size: 14,
                          color: scheme.primary,
                          semanticLabel: context.l10n.newsPinned,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    post.title,
                    style: compact ? text.titleSmall : text.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!compact && post.excerpt.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      post.excerpt,
                      style: text.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  PostMeta(post: post),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "12 Nov 2026 · 3 د قراءة".
class PostMeta extends StatelessWidget {
  const PostMeta({super.key, required this.post});

  final PostSummary post;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = post.publishedAt;
    final parts = [
      if (date != null)
        DateUtilsX.display(date, Localizations.localeOf(context).languageCode),
      l10n.newsReadMinutes(post.readMinutes),
    ];
    return Text(
      parts.join(' · '),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
