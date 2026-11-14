import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/features/home/data/models/home_model.dart';
import 'package:wheel_mobile/features/news/data/models/post_model.dart';
import 'package:wheel_mobile/features/news/domain/entities/post.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('posts page: pinned welcome post first, categories and meta', () {
    final page = PostsPageModel.fromJson(fixtureBody('posts'));

    expect(page.items, hasLength(12));
    expect(page.currentPage, 1);
    expect(page.lastPage, 1);
    final first = page.items.first;
    expect(first.slug, 'welcome-to-wheel-football');
    expect(first.isPinned, isTrue);
    expect(first.category.key, 'company');
    expect(first.category.title, 'أخبار الشركة');
    expect(first.publishedAt, isNotNull);
    expect(first.readMinutes, greaterThanOrEqualTo(1));
    expect(first.coverUrl, isNull);
  });

  test('post detail: parsed blocks and related posts', () {
    final post = PostDetailModel.fromJson(fixtureData('post'));

    expect(post.summary.slug, 'ten-minute-warm-up');
    expect(post.body, isNotEmpty);
    expect(post.blocks.first, isA<ParagraphBlock>());
    expect(post.blocks.whereType<HeadingBlock>(), isNotEmpty);
    final bullets = post.blocks.whereType<BulletsBlock>().first;
    expect(bullets.items, hasLength(4));
    expect(post.related, hasLength(3));
    expect(post.related.every((p) => p.category.key == 'fitness'), isTrue);
  });

  test('unknown block types from a newer server are skipped', () {
    final post = PostDetailModel.fromJson({
      'slug': 'x',
      'category': {'key': 'football', 'title': 'عالم الكرة'},
      'title': 'T',
      'blocks': [
        {'type': 'video', 'url': 'https://example.com'},
        {'type': 'paragraph', 'text': 'ok'},
      ],
    });

    expect(post.blocks, [const ParagraphBlock('ok')]);
  });

  test('categories with counts', () {
    final cats = PostCategoryModel.listFromJson(fixtureList('post_categories'));

    expect(cats.map((c) => c.key), [
      'company',
      'football',
      'fitness',
      'match_report',
    ]);
    expect(cats.firstWhere((c) => c.key == 'match_report').count, 0);
    expect(cats.firstWhere((c) => c.key == 'fitness').count, 4);
  });

  test('home includes the next fixture and the latest posts', () {
    final home = HomeModel.fromJson(fixtureData('home_content')).toEntity();

    expect(home.nextFixture?.opponent, 'زيزيا');
    expect(home.nextFixture?.time, '20:00');
    expect(home.latestPosts, hasLength(3));
    expect(home.latestPosts.first.isPinned, isTrue);
  });

  test('older home responses without the new fields still parse', () {
    final home = HomeModel.fromJson(fixtureData('home')).toEntity();

    expect(home.nextFixture, isNull);
    expect(home.latestPosts, isEmpty);
  });
}
