import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/leaderboards_model.dart';

class LeaderboardsRemoteDataSource {
  LeaderboardsRemoteDataSource(this._api);

  final CachedApi _api;

  Future<LeaderboardsModel> getLeaderboards({bool fromCache = false}) async {
    final body = await _api.get(
      ApiEndpoints.leaderboards,
      fromCache: fromCache,
    );
    return LeaderboardsModel.fromJson(asMap(dataOf(body)));
  }
}
