import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/standings_model.dart';

class StandingsRemoteDataSource {
  StandingsRemoteDataSource(this._api);

  final CachedApi _api;

  Future<StandingsModel> getStandings({bool fromCache = false}) async {
    final body = await _api.get(ApiEndpoints.standings, fromCache: fromCache);
    return StandingsModel.fromJson(asMap(dataOf(body)));
  }
}
