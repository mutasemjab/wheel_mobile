import '../../../../core/result/result.dart';
import '../entities/standings.dart';
import '../repositories/standings_repository.dart';

class GetStandings {
  const GetStandings(this._repository);

  final StandingsRepository _repository;

  Future<Result<Standings>> call({bool fromCache = false}) =>
      _repository.getStandings(fromCache: fromCache);
}
