import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// `true` while the backend is reachable; drives the offline banner.
class NetworkStatusCubit extends Cubit<bool> {
  NetworkStatusCubit() : super(true);

  void markOnline() {
    if (!state) emit(true);
  }

  void markOffline() {
    if (state) emit(false);
  }
}

/// Feeds [NetworkStatusCubit] from every HTTP exchange.
class NetworkStatusInterceptor extends Interceptor {
  NetworkStatusInterceptor(this._status);

  final NetworkStatusCubit _status;

  static bool isConnectivityError(DioException e) => switch (e.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => true,
    DioExceptionType.unknown => e.response == null,
    _ => false,
  };

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _status.markOnline();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (isConnectivityError(err)) {
      _status.markOffline();
    } else if (err.response != null) {
      _status.markOnline();
    }
    handler.next(err);
  }
}
