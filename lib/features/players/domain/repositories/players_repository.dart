import '../../../../core/result/result.dart';
import '../entities/player.dart';
import '../entities/player_profile.dart';

abstract interface class PlayersRepository {
  /// `GET /players`, memoised in memory for slug → name/photo lookups.
  Future<Result<List<Player>>> getPlayers({bool fromCache = false});

  Future<Result<PlayerProfile>> getProfile(
    String slug, {
    bool fromCache = false,
  });
}
