import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/team_model.dart';

class TeamRemoteDataSource {
  TeamRemoteDataSource(this._api);

  final CachedApi _api;

  Future<TeamOverviewModel> getTeam({bool fromCache = false}) async {
    final body = await _api.get(ApiEndpoints.team, fromCache: fromCache);
    return TeamOverviewModel.fromJson(asMap(dataOf(body)));
  }
}
