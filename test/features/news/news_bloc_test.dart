import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheel_mobile/core/entities/data_state.dart';
import 'package:wheel_mobile/core/error/failures.dart';
import 'package:wheel_mobile/core/result/result.dart';
import 'package:wheel_mobile/features/news/domain/entities/post.dart';
import 'package:wheel_mobile/features/news/domain/usecases/get_post_categories.dart';
import 'package:wheel_mobile/features/news/domain/usecases/get_posts.dart';
import 'package:wheel_mobile/features/news/presentation/bloc/news_bloc.dart';

class _MockGetPosts extends Mock implements GetPosts {}

class _MockGetCategories extends Mock implements GetPostCategories {}

const _football = PostCategory(key: 'football', title: 'عالم الكرة', count: 2);
const _empty = PostCategory(key: 'match_report', title: 'تقارير', count: 0);

PostSummary _p(String slug, [PostCategory c = _football]) =>
    PostSummary(slug: slug, category: c, title: slug);

void main() {
  late _MockGetPosts getPosts;
  late _MockGetCategories getCategories;
  final page1 = PostsPage(
    items: [_p('a'), _p('b')],
    currentPage: 1,
    lastPage: 2,
  );
  final page2 = PostsPage(
    items: [_p('b'), _p('c')],
    currentPage: 2,
    lastPage: 2,
  );
  final football = PostsPage(items: [_p('f')]);

  setUp(() {
    getPosts = _MockGetPosts();
    getCategories = _MockGetCategories();
    when(
      () => getCategories(fromCache: any(named: 'fromCache')),
    ).thenAnswer((_) async => const Success([_football, _empty]));
    when(
      () => getPosts(category: any(named: 'category'), fromCache: true),
    ).thenAnswer((_) async => const Err(CacheFailure()));
    when(() => getPosts()).thenAnswer((_) async => Success(page1));
    when(() => getPosts(page: 2)).thenAnswer((_) async => Success(page2));
    when(
      () => getPosts(category: 'football'),
    ).thenAnswer((_) async => Success(football));
  });

  NewsBloc build() => NewsBloc(getPosts, getCategories);

  blocTest<NewsBloc, NewsState>(
    'loads categories and the first page',
    build: build,
    act: (b) => b.add(const NewsStarted()),
    expect: () => [
      const NewsState(status: DataStatus.loading),
      NewsState(
        status: DataStatus.loaded,
        items: page1.items,
        categories: const [_football, _empty],
        page: 1,
        lastPage: 2,
      ),
    ],
    verify: (b) => expect(b.state.visibleCategories, const [_football]),
  );

  blocTest<NewsBloc, NewsState>(
    'load more appends the next page without duplicates',
    build: build,
    seed: () => NewsState(
      status: DataStatus.loaded,
      items: page1.items,
      page: 1,
      lastPage: 2,
    ),
    act: (b) => b.add(const NewsNextPageRequested()),
    skip: 1,
    expect: () => [
      NewsState(
        status: DataStatus.loaded,
        items: [_p('a'), _p('b'), _p('c')],
        page: 2,
        lastPage: 2,
      ),
    ],
  );

  blocTest<NewsBloc, NewsState>(
    'selecting a category clears the list and loads that category',
    build: build,
    seed: () => NewsState(
      status: DataStatus.loaded,
      items: page1.items,
      page: 1,
      lastPage: 2,
    ),
    act: (b) => b.add(const NewsCategorySelected('football')),
    expect: () => [
      const NewsState(status: DataStatus.loading, category: 'football'),
      NewsState(
        status: DataStatus.loaded,
        items: football.items,
        category: 'football',
        page: 1,
        lastPage: 1,
      ),
    ],
  );

  blocTest<NewsBloc, NewsState>(
    'a failure with nothing loaded shows the error state',
    build: () {
      when(
        () => getPosts(),
      ).thenAnswer((_) async => const Err(NetworkFailure()));
      return build();
    },
    act: (b) => b.add(const NewsStarted()),
    expect: () => [
      const NewsState(status: DataStatus.loading),
      const NewsState(
        status: DataStatus.failure,
        categories: [_football, _empty],
        failure: NetworkFailure(),
      ),
    ],
  );
}
