import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/live_match_model.dart';

/// `/live` is never cached: stale live data would be misleading.
class LiveViewerRemoteDataSource {
  LiveViewerRemoteDataSource(this._dio);

  final Dio _dio;

  Future<LiveMatchModel?> getLive() async {
    final response = await _dio.get<Object?>(ApiEndpoints.live);
    final data = asMapOrNull(dataOf(response.data));
    return data == null ? null : LiveMatchModel.fromJson(data);
  }
}
