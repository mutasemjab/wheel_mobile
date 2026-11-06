import '../../../../core/result/result.dart';
import '../../../players/domain/usecases/get_players.dart';
import '../entities/match.dart';
import '../repositories/matches_repository.dart';

/// Match + players directory (fetched in parallel) to resolve slugs.
class GetMatchDetail {
  const GetMatchDetail(this._repository, this._getPlayers);

  final MatchesRepository _repository;
  final GetPlayers _getPlayers;

  Future<Result<MatchDetail>> call(
    String code, {
    bool fromCache = false,
  }) async {
    final (match, players) = await (
      _repository.getMatch(code, fromCache: fromCache),
      _getPlayers.directory(fromCache: fromCache),
    ).wait;
    return match.map((m) => MatchDetail(match: m, players: players));
  }
}
