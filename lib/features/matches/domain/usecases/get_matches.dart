import '../../../../core/result/result.dart';
import '../entities/match.dart';
import '../repositories/matches_repository.dart';

class GetMatches {
  const GetMatches(this._repository);

  final MatchesRepository _repository;

  Future<Result<MatchesPage>> call({int page = 1, bool fromCache = false}) =>
      _repository.getMatches(page: page, fromCache: fromCache);
}
