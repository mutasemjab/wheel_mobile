import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/match_model.dart';

class MatchesRemoteDataSource {
  MatchesRemoteDataSource(this._api);

  final CachedApi _api;

  Future<MatchesPageModel> getMatches({
    int page = 1,
    bool fromCache = false,
  }) async {
    final body = await _api.get(
      ApiEndpoints.matches,
      query: {'page': page},
      fromCache: fromCache,
    );
    return MatchesPageModel.fromJson(body);
  }

  Future<MatchModel> getMatch(String code, {bool fromCache = false}) async {
    final body = await _api.get(ApiEndpoints.match(code), fromCache: fromCache);
    return MatchModel.fromJson(asMap(dataOf(body)));
  }
}
