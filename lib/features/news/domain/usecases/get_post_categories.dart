import '../../../../core/result/result.dart';
import '../entities/post.dart';
import '../repositories/news_repository.dart';

class GetPostCategories {
  const GetPostCategories(this._repository);

  final NewsRepository _repository;

  Future<Result<List<PostCategory>>> call({bool fromCache = false}) =>
      _repository.getCategories(fromCache: fromCache);
}
