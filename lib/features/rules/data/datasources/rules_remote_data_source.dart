import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/rules_model.dart';

class RulesRemoteDataSource {
  RulesRemoteDataSource(this._api);

  final CachedApi _api;

  Future<RulesModel> getRules({bool fromCache = false}) async {
    final body = await _api.get(ApiEndpoints.rules, fromCache: fromCache);
    return RulesModel.fromJson(asMap(dataOf(body)));
  }
}
