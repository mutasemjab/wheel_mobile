import '../../../../core/result/result.dart';
import '../entities/player.dart';
import '../repositories/players_repository.dart';

class GetPlayers {
  const GetPlayers(this._repository);

  final PlayersRepository _repository;

  Future<Result<List<Player>>> call({bool fromCache = false}) =>
      _repository.getPlayers(fromCache: fromCache);

  /// Players keyed by slug; an empty map when the list is unavailable.
  Future<Map<String, Player>> directory({bool fromCache = false}) async {
    final result = await call(fromCache: fromCache);
    final players =
        result.valueOrNull ??
        (fromCache ? null : (await call(fromCache: true)).valueOrNull) ??
        const <Player>[];
    return {for (final p in players) p.slug: p};
  }
}
