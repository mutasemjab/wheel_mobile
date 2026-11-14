import '../../../../core/result/result.dart';
import '../entities/post.dart';
import '../repositories/news_repository.dart';

class GetPost {
  const GetPost(this._repository);

  final NewsRepository _repository;

  Future<Result<PostDetail>> call(String slug, {bool fromCache = false}) =>
      _repository.getPost(slug, fromCache: fromCache);
}
