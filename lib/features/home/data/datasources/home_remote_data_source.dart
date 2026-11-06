import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/home_model.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource(this._api);

  final CachedApi _api;

  Future<HomeModel> getHome({bool fromCache = false}) async {
    final body = await _api.get(ApiEndpoints.home, fromCache: fromCache);
    return HomeModel.fromJson(asMap(dataOf(body)));
  }
}
