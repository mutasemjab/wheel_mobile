import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../domain/entities/post.dart';

/// Post cover image, or a category-coloured gradient with the category icon
/// when the post has no cover.
class PostCover extends StatelessWidget {
  const PostCover({super.key, required this.post, this.iconSize = 40});

  final PostSummary post;
  final double iconSize;

  static Color _tint(String category) => switch (category) {
    'company' => AppColors.accent,
    'football' => AppColors.positive,
    'fitness' => AppColors.accentSecondary,
    'match_report' => AppColors.tierGold,
    _ => AppColors.neutral,
  };

  @override
  Widget build(BuildContext context) {
    final tint = _tint(post.category.key);
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [tint.withValues(alpha: 0.85), tint.withValues(alpha: 0.35)],
        ),
      ),
      child: Center(
        child: Text(post.category.icon, style: TextStyle(fontSize: iconSize)),
      ),
    );
    final url = post.coverUrl;
    if (url == null) return placeholder;
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}
