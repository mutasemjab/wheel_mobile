import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/post.dart';

abstract final class PostCategoryModel {
  static PostCategory fromJson(dynamic json) {
    final m = asMap(json);
    return PostCategory(
      key: asString(m['key']),
      title: asString(m['title'], fallback: asString(m['key'])),
      icon: asString(m['icon']),
      count: asIntOrNull(m['count']),
    );
  }

  static List<PostCategory> listFromJson(dynamic json) =>
      asMapList(json).map(fromJson).toList(growable: false);
}

abstract final class PostSummaryModel {
  static PostSummary fromJson(dynamic json) {
    final m = asMap(json);
    return PostSummary(
      slug: asString(m['slug']),
      category: PostCategoryModel.fromJson(m['category']),
      title: asString(m['title']),
      excerpt: asString(m['excerpt']),
      coverUrl: asNonEmptyStringOrNull(m['cover_url']),
      isPinned: asBool(m['is_pinned']),
      publishedAt: parseDateTimeOrNull(m['published_at'])?.toLocal(),
      readMinutes: asInt(m['read_minutes'], fallback: 1),
      views: asInt(m['views']),
    );
  }

  static List<PostSummary> listFromJson(dynamic json) =>
      asMapList(json).map(fromJson).toList(growable: false);
}

abstract final class PostDetailModel {
  static PostDetail fromJson(dynamic json) {
    final m = asMap(json);
    return PostDetail(
      summary: PostSummaryModel.fromJson(m),
      body: asString(m['body']),
      blocks: [for (final b in asMapList(m['blocks'])) ?_block(b)],
      related: PostSummaryModel.listFromJson(m['related']),
    );
  }

  /// Unknown block types are skipped so newer servers can't break the app.
  static PostBlock? _block(Json b) => switch (asString(b['type'])) {
    'heading' => HeadingBlock(asString(b['text'])),
    'paragraph' => ParagraphBlock(asString(b['text'])),
    'bullets' => BulletsBlock(asStringList(b['items'])),
    _ => null,
  };
}

abstract final class PostsPageModel {
  static PostsPage fromJson(dynamic body) {
    final meta = asMap(asMap(body)['meta']);
    return PostsPage(
      items: PostSummaryModel.listFromJson(dataOf(body)),
      currentPage: asInt(meta['current_page'], fallback: 1),
      lastPage: asInt(meta['last_page'], fallback: 1),
    );
  }
}
