import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/player_profile.dart';
import '../../domain/repositories/players_repository.dart';
import '../datasources/players_remote_data_source.dart';

class PlayersRepositoryImpl implements PlayersRepository {
  PlayersRepositoryImpl(this._remote);

  final PlayersRemoteDataSource _remote;
  List<Player>? _memory;
  Future<Result<List<Player>>>? _inFlight;

  @override
  Future<Result<List<Player>>> getPlayers({bool fromCache = false}) {
    if (fromCache) {
      final memory = _memory;
      if (memory != null) return Future.value(Success(memory));
      return guard(() async {
        final models = await _remote.getPlayers(fromCache: true);
        return _memory = models
            .map((m) => m.toEntity())
            .toList(growable: false);
      });
    }
    // Home and match screens ask in parallel: share one request.
    return _inFlight ??= guard(() async {
      final models = await _remote.getPlayers();
      return _memory = models.map((m) => m.toEntity()).toList(growable: false);
    }).whenComplete(() => _inFlight = null);
  }

  @override
  Future<Result<PlayerProfile>> getProfile(
    String slug, {
    bool fromCache = false,
  }) => guard(() async {
    final model = await _remote.getProfile(slug, fromCache: fromCache);
    return model.toEntity();
  });
}
