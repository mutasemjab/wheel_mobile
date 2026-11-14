import 'package:equatable/equatable.dart';

/// News category (`company`, `football`, `fitness`, `match_report`).
final class PostCategory extends Equatable {
  const PostCategory({
    required this.key,
    required this.title,
    this.icon = '',
    this.count,
  });

  final String key;
  final String title;
  final String icon;

  /// Number of published posts (only from `GET /posts/categories`).
  final int? count;

  @override
  List<Object?> get props => [key, title, icon, count];
}

/// A news item as listed in the feed.
final class PostSummary extends Equatable {
  const PostSummary({
    required this.slug,
    required this.category,
    required this.title,
    this.excerpt = '',
    this.coverUrl,
    this.isPinned = false,
    this.publishedAt,
    this.readMinutes = 1,
    this.views = 0,
  });

  final String slug;
  final PostCategory category;
  final String title;
  final String excerpt;
  final String? coverUrl;
  final bool isPinned;
  final DateTime? publishedAt;
  final int readMinutes;
  final int views;

  @override
  List<Object?> get props => [
    slug,
    category,
    title,
    excerpt,
    coverUrl,
    isPinned,
    publishedAt,
    readMinutes,
    views,
  ];
}

/// One display block of a post body, already parsed by the server.
sealed class PostBlock extends Equatable {
  const PostBlock();
}

final class HeadingBlock extends PostBlock {
  const HeadingBlock(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

final class ParagraphBlock extends PostBlock {
  const ParagraphBlock(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

final class BulletsBlock extends PostBlock {
  const BulletsBlock(this.items);
  final List<String> items;

  @override
  List<Object?> get props => [items];
}

/// Full article: `GET /posts/{slug}`.
final class PostDetail extends Equatable {
  const PostDetail({
    required this.summary,
    this.body = '',
    this.blocks = const [],
    this.related = const [],
  });

  final PostSummary summary;

  /// Raw text (used for sharing).
  final String body;
  final List<PostBlock> blocks;
  final List<PostSummary> related;

  @override
  List<Object?> get props => [summary, body, blocks, related];
}

final class PostsPage extends Equatable {
  const PostsPage({
    this.items = const [],
    this.currentPage = 1,
    this.lastPage = 1,
  });

  final List<PostSummary> items;
  final int currentPage;
  final int lastPage;

  @override
  List<Object?> get props => [items, currentPage, lastPage];
}
