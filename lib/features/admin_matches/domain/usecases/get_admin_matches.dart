import '../../../../core/result/result.dart';
import '../../../matches/domain/entities/match.dart';
import '../repositories/admin_matches_repository.dart';

class GetAdminMatches {
  const GetAdminMatches(this._repository);

  final AdminMatchesRepository _repository;

  Future<Result<MatchesPage>> call({int page = 1, bool fromCache = false}) =>
      _repository.getMatches(page: page, fromCache: fromCache);
}
