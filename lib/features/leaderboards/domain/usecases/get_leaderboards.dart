import '../../../../core/result/result.dart';
import '../entities/leaderboards.dart';
import '../repositories/leaderboards_repository.dart';

class GetLeaderboards {
  const GetLeaderboards(this._repository);

  final LeaderboardsRepository _repository;

  Future<Result<Leaderboards>> call({bool fromCache = false}) =>
      _repository.getLeaderboards(fromCache: fromCache);
}
