import 'package:dio/dio.dart';

/// Sends `Accept: application/json` and `Accept-Language` on every request.
class LocaleInterceptor extends Interceptor {
  LocaleInterceptor({this.languageCode = 'ar'});

  final String languageCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[Headers.acceptHeader] = Headers.jsonContentType;
    options.headers['Accept-Language'] = languageCode;
    handler.next(options);
  }
}
