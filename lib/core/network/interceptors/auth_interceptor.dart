import 'dart:async';

import 'package:dio/dio.dart';

import '../../storage/secure_token_storage.dart';
import '../api_endpoints.dart';

/// Adds the Bearer token to `/admin/*` requests and reports expired sessions.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  static const int _unauthorized = 401;

  final TokenStorage _tokens;
  final StreamController<void> _expired = StreamController<void>.broadcast();

  /// Fires when an admin request returns 401 (token already cleared).
  Stream<void> get sessionExpired => _expired.stream;

  static bool isAdminPath(String path) =>
      path.startsWith(ApiEndpoints.adminPrefix);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (isAdminPath(options.path)) {
      final token = await _tokens.read();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final path = err.requestOptions.path;
    final isSessionCall =
        isAdminPath(path) && !ApiEndpoints.credentialEndpoints.contains(path);
    if (err.response?.statusCode == _unauthorized && isSessionCall) {
      await _tokens.clear();
      _expired.add(null);
    }
    handler.next(err);
  }

  Future<void> dispose() => _expired.close();
}
