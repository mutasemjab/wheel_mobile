import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/error/error_mapper.dart';
import 'package:wheel_mobile/core/error/exceptions.dart';
import 'package:wheel_mobile/core/error/failures.dart';

DioException _response(int status, [Object? body]) {
  final options = RequestOptions(path: '/x');
  return DioException.badResponse(
    statusCode: status,
    requestOptions: options,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      data: body,
    ),
  );
}

void main() {
  group('ErrorMapper', () {
    test('timeouts and connection errors → NetworkFailure', () {
      final options = RequestOptions(path: '/x');
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.connectionError,
      ]) {
        expect(
          ErrorMapper.map(DioException(requestOptions: options, type: type)),
          isA<NetworkFailure>(),
        );
      }
    });

    test('401 → Unauthorized', () {
      expect(
        ErrorMapper.map(_response(401, {'message': 'Unauthenticated.'})),
        isA<UnauthorizedFailure>(),
      );
    });

    test(
      '403 → Forbidden',
      () => expect(ErrorMapper.map(_response(403)), isA<ForbiddenFailure>()),
    );

    test('404 → NotFound keeping the Arabic server message', () {
      expect(
        ErrorMapper.map(_response(404, {'message': 'ما في مباراة مباشرة'})),
        const NotFoundFailure(serverMessage: 'ما في مباراة مباشرة'),
      );
    });

    test('409 → Conflict with the server message', () {
      final f = ErrorMapper.map(_response(409, {'message': 'في مباراة شغالة'}));
      expect(f, const ConflictFailure(serverMessage: 'في مباراة شغالة'));
    });

    test('422 → Validation with field errors', () {
      final f = ErrorMapper.map(
        _response(422, {
          'message': 'بيانات غلط',
          'errors': {
            'email': ['الإيميل أو كلمة السر غلط'],
          },
        }),
      );
      expect(f, isA<ValidationFailure>());
      expect(
        (f as ValidationFailure).fieldError('email'),
        'الإيميل أو كلمة السر غلط',
      );
      expect(f.serverMessage, 'بيانات غلط');
    });

    test(
      '429 → RateLimit',
      () => expect(ErrorMapper.map(_response(429)), isA<RateLimitFailure>()),
    );

    test('5xx → Server', () {
      expect(ErrorMapper.map(_response(500)), isA<ServerFailure>());
      expect(ErrorMapper.map(_response(503)), isA<ServerFailure>());
    });

    test('parsing problems → ParsingFailure', () {
      expect(
        ErrorMapper.map(const ParsingException('x')),
        isA<ParsingFailure>(),
      );
      expect(
        ErrorMapper.map(const FormatException('x')),
        isA<ParsingFailure>(),
      );
    });

    test('cache miss → CacheFailure', () {
      expect(
        ErrorMapper.map(const CacheMissException('/home')),
        isA<CacheFailure>(),
      );
    });
  });
}
