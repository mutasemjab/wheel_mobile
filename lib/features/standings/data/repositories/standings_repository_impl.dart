import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/standings.dart';
import '../../domain/repositories/standings_repository.dart';
import '../datasources/standings_remote_data_source.dart';

class StandingsRepositoryImpl implements StandingsRepository {
  StandingsRepositoryImpl(this._remote);

  final StandingsRemoteDataSource _remote;

  @override
  Future<Result<Standings>> getStandings({bool fromCache = false}) => guard(
    () async => (await _remote.getStandings(fromCache: fromCache)).toEntity(),
  );
}
