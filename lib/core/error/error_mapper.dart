import 'dart:io';

import 'package:dio/dio.dart';

import '../utils/json_parsing.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Maps any error raised in the data layer to a [Failure].
abstract final class ErrorMapper {
  static const int _unauthorized = 401;
  static const int _forbidden = 403;
  static const int _notFound = 404;
  static const int _conflict = 409;
  static const int _validation = 422;
  static const int _tooMany = 429;
  static const int _serverMin = 500;

  static Failure map(Object error) => switch (error) {
    DioException() => fromDio(error),
    ParsingException() ||
    FormatException() ||
    TypeError() => const ParsingFailure(),
    CacheMissException() => const CacheFailure(),
    SocketException() => const NetworkFailure(),
    _ => const ServerFailure(),
  };

  static Failure fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.unknown:
        if (e.error is SocketException) return const NetworkFailure();
        final status = e.response?.statusCode;
        if (status == null) return const NetworkFailure();
        return fromStatus(status, e.response?.data);
      case DioExceptionType.badResponse:
        return fromStatus(
          e.response?.statusCode ?? _serverMin,
          e.response?.data,
        );
      case DioExceptionType.transformTimeout:
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return const ServerFailure();
    }
  }

  static Failure fromStatus(int status, Object? body) {
    final message = _message(body);
    return switch (status) {
      _unauthorized => UnauthorizedFailure(serverMessage: message),
      _forbidden => ForbiddenFailure(serverMessage: message),
      _notFound => NotFoundFailure(serverMessage: message),
      _conflict => ConflictFailure(serverMessage: message),
      _validation => ValidationFailure(
        serverMessage: message,
        fieldErrors: _fieldErrors(body),
      ),
      _tooMany => RateLimitFailure(serverMessage: message),
      _ => ServerFailure(serverMessage: message, statusCode: status),
    };
  }

  static String? _message(Object? body) {
    if (body is! Map) return null;
    final message = body['message'];
    return message is String && message.isNotEmpty ? message : null;
  }

  static Map<String, List<String>> _fieldErrors(Object? body) {
    if (body is! Map) return const {};
    final errors = body['errors'];
    if (errors is! Map) return const {};
    return {
      for (final entry in errors.entries)
        entry.key.toString(): asStringList(entry.value),
    };
  }
}
