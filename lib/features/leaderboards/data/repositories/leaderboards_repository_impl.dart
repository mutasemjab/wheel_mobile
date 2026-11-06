import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/leaderboards.dart';
import '../../domain/repositories/leaderboards_repository.dart';
import '../datasources/leaderboards_remote_data_source.dart';

class LeaderboardsRepositoryImpl implements LeaderboardsRepository {
  LeaderboardsRepositoryImpl(this._remote);

  final LeaderboardsRemoteDataSource _remote;

  @override
  Future<Result<Leaderboards>> getLeaderboards({bool fromCache = false}) =>
      guard(
        () async =>
            (await _remote.getLeaderboards(fromCache: fromCache)).toEntity(),
      );
}
