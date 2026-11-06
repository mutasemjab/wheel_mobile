import '../../../../core/result/result.dart';
import '../entities/leaderboards.dart';

abstract interface class LeaderboardsRepository {
  Future<Result<Leaderboards>> getLeaderboards({bool fromCache = false});
}
