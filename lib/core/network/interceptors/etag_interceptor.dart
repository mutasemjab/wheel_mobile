import 'package:dio/dio.dart';

/// Conditional GETs: remembers `ETag` + body per URL, sends `If-None-Match`,
/// and turns a `304` (empty body) into the cached body with status 200.
/// Requires Dio to accept 304 (see [acceptsStatus]).
class EtagInterceptor extends Interceptor {
  static const int notModified = 304;
  static const int _ok = 200;
  static const String _etag = 'etag';
  static const String _ifNoneMatch = 'If-None-Match';

  final Map<String, ({String etag, Object? body})> _entries = {};

  /// `validateStatus` for Dio: 2xx plus 304.
  static bool acceptsStatus(int? status) =>
      status != null &&
      ((status >= 200 && status < 300) || status == notModified);

  static String _key(RequestOptions o) => o.uri.toString();

  static bool _isGet(RequestOptions o) => o.method.toUpperCase() == 'GET';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_isGet(options)) {
      final entry = _entries[_key(options)];
      if (entry != null) options.headers[_ifNoneMatch] = entry.etag;
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final options = response.requestOptions;
    if (!_isGet(options)) return handler.next(response);
    final key = _key(options);
    if (response.statusCode == notModified) {
      final cached = _entries[key];
      if (cached != null) {
        return handler.next(
          Response<dynamic>(
            requestOptions: options,
            data: cached.body,
            statusCode: _ok,
            headers: response.headers,
          ),
        );
      }
      // A 304 we cannot answer from memory: surface it as an error so the
      // caller falls back to its own cache instead of parsing an empty body.
      return handler.reject(
        DioException.badResponse(
          statusCode: notModified,
          requestOptions: options,
          response: response,
        ),
        true,
      );
    }
    final etag = response.headers.value(_etag);
    if (etag != null && etag.isNotEmpty) {
      _entries[key] = (etag: etag, body: response.data);
    }
    handler.next(response);
  }
}
