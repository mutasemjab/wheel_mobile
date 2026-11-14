import '../../../../core/result/result.dart';
import '../entities/post.dart';

abstract interface class NewsRepository {
  Future<Result<PostsPage>> getPosts({
    int page = 1,
    String? category,
    bool fromCache = false,
  });

  Future<Result<List<PostCategory>>> getCategories({bool fromCache = false});

  Future<Result<PostDetail>> getPost(String slug, {bool fromCache = false});
}
