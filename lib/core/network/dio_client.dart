import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'api_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/etag_interceptor.dart';
import 'interceptors/locale_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'network_status.dart';

/// Builds the single [Dio] instance used by every remote data source.
abstract final class DioClient {
  static const Duration connectTimeout = Duration(seconds: 6);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 30);

  static Dio create({
    required ApiConfig config,
    required AuthInterceptor auth,
    required NetworkStatusCubit networkStatus,
    required Logger logger,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
        // Public GETs answer 304 to a matching If-None-Match.
        validateStatus: EtagInterceptor.acceptsStatus,
      ),
    );
    dio.interceptors.addAll([
      LocaleInterceptor(),
      auth,
      EtagInterceptor(),
      NetworkStatusInterceptor(networkStatus),
      if (kDebugMode) LoggingInterceptor(logger),
    ]);
    return dio;
  }
}
