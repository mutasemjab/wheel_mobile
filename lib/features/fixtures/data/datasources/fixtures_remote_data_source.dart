import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/cached_api.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/fixture.dart';
import '../models/fixture_model.dart';

class FixturesRemoteDataSource {
  FixturesRemoteDataSource(this._api);

  final CachedApi _api;

  Future<FixturesData> getFixtures({bool fromCache = false}) async {
    final body = await _api.get(ApiEndpoints.fixtures, fromCache: fromCache);
    return FixtureModel.dataFromJson(dataOf(body));
  }
}
