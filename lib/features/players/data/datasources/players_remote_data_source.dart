import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/player_model.dart';
import '../models/player_profile_model.dart';

class PlayersRemoteDataSource {
  PlayersRemoteDataSource(this._api);

  final CachedApi _api;

  Future<List<PlayerModel>> getPlayers({bool fromCache = false}) async {
    final body = await _api.get(ApiEndpoints.players, fromCache: fromCache);
    return asMapList(dataOf(body)).map(PlayerModel.fromJson).toList();
  }

  Future<PlayerProfileModel> getProfile(
    String slug, {
    bool fromCache = false,
  }) async {
    final body = await _api.get(
      ApiEndpoints.player(slug),
      fromCache: fromCache,
    );
    return PlayerProfileModel.fromJson(asMap(dataOf(body)));
  }
}
