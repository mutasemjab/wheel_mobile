import '../../../../core/result/result.dart';
import '../entities/award.dart';
import '../repositories/awards_repository.dart';

class GetAwards {
  const GetAwards(this._repository);

  final AwardsRepository _repository;

  Future<Result<List<Award>>> call({bool fromCache = false}) =>
      _repository.getAwards(fromCache: fromCache);
}
