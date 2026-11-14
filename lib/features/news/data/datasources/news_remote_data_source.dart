import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/post.dart';
import '../models/post_model.dart';

class NewsRemoteDataSource {
  NewsRemoteDataSource(this._api);

  final CachedApi _api;

  Future<PostsPage> getPosts({
    int page = 1,
    String? category,
    bool fromCache = false,
  }) async {
    final body = await _api.get(
      ApiEndpoints.posts,
      query: {'page': page, 'category': ?category},
      fromCache: fromCache,
    );
    return PostsPageModel.fromJson(body);
  }

  Future<List<PostCategory>> getCategories({bool fromCache = false}) async {
    final body = await _api.get(
      ApiEndpoints.postCategories,
      fromCache: fromCache,
    );
    return PostCategoryModel.listFromJson(dataOf(body));
  }

  Future<PostDetail> getPost(String slug, {bool fromCache = false}) async {
    final body = await _api.get(ApiEndpoints.post(slug), fromCache: fromCache);
    return PostDetailModel.fromJson(dataOf(body));
  }
}
