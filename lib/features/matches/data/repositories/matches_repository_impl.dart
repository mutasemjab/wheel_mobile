import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/match.dart';
import '../../domain/repositories/matches_repository.dart';
import '../datasources/matches_remote_data_source.dart';

class MatchesRepositoryImpl implements MatchesRepository {
  MatchesRepositoryImpl(this._remote);

  final MatchesRemoteDataSource _remote;

  @override
  Future<Result<MatchesPage>> getMatches({
    int page = 1,
    bool fromCache = false,
  }) => guard(
    () async =>
        (await _remote.getMatches(page: page, fromCache: fromCache)).toEntity(),
  );

  @override
  Future<Result<FootballMatch>> getMatch(
    String code, {
    bool fromCache = false,
  }) => guard(
    () async => (await _remote.getMatch(code, fromCache: fromCache)).toEntity(),
  );
}
