import '../../../../core/result/result.dart';
import '../entities/post.dart';
import '../repositories/news_repository.dart';

class GetPosts {
  const GetPosts(this._repository);

  final NewsRepository _repository;

  Future<Result<PostsPage>> call({
    int page = 1,
    String? category,
    bool fromCache = false,
  }) => _repository.getPosts(
    page: page,
    category: category,
    fromCache: fromCache,
  );
}
