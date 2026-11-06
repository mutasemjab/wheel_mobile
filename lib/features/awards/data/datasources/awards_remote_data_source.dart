import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/award_model.dart';

class AwardsRemoteDataSource {
  AwardsRemoteDataSource(this._api);

  final CachedApi _api;

  Future<List<AwardModel>> getAwards({bool fromCache = false}) async {
    final body = await _api.get(ApiEndpoints.awards, fromCache: fromCache);
    return AwardModel.listFromJson(dataOf(body));
  }
}
