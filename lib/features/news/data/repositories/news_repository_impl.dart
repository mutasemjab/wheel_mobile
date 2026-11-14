import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl(this._remote);

  final NewsRemoteDataSource _remote;

  @override
  Future<Result<PostsPage>> getPosts({
    int page = 1,
    String? category,
    bool fromCache = false,
  }) => guard(
    () =>
        _remote.getPosts(page: page, category: category, fromCache: fromCache),
  );

  @override
  Future<Result<List<PostCategory>>> getCategories({bool fromCache = false}) =>
      guard(() => _remote.getCategories(fromCache: fromCache));

  @override
  Future<Result<PostDetail>> getPost(String slug, {bool fromCache = false}) =>
      guard(() => _remote.getPost(slug, fromCache: fromCache));
}
