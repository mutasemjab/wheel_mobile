import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import '../storage/json_cache.dart';
import 'network_status.dart';

/// Public GETs with an offline fallback: every successful body is cached,
/// and the cached body is returned when the network is unreachable.
class CachedApi {
  CachedApi(this._dio, this._cache);

  final Dio _dio;
  final JsonCache _cache;

  static String keyFor(String path, Map<String, dynamic>? query) {
    if (query == null || query.isEmpty) return path;
    final entries = query.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return '$path?${entries.map((e) => '${e.key}=${e.value}').join('&')}';
  }

  /// Returns the decoded body. With [fromCache] only the local copy is read
  /// (throws [CacheMissException] when absent).
  Future<Object?> get(
    String path, {
    Map<String, dynamic>? query,
    bool fromCache = false,
  }) async {
    final key = keyFor(path, query);
    if (fromCache) {
      if (!_cache.contains(key)) throw CacheMissException(key);
      return _cache.read(key);
    }
    try {
      final response = await _dio.get<Object?>(path, queryParameters: query);
      await _cache.write(key, response.data);
      return response.data;
    } on DioException catch (e) {
      if (NetworkStatusInterceptor.isConnectivityError(e) &&
          _cache.contains(key)) {
        return _cache.read(key);
      }
      rethrow;
    }
  }
}
