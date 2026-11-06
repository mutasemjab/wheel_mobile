import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_mobile/core/error/failures.dart';
import 'package:wheel_mobile/core/network/api_config.dart';
import 'package:wheel_mobile/core/network/cached_api.dart';
import 'package:wheel_mobile/core/network/dio_client.dart';
import 'package:wheel_mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:wheel_mobile/core/network/network_status.dart';
import 'package:wheel_mobile/core/result/result.dart';
import 'package:wheel_mobile/core/storage/json_cache.dart';
import 'package:wheel_mobile/core/storage/secure_token_storage.dart';
import 'package:wheel_mobile/features/admin_settings/data/datasources/settings_remote_data_source.dart';
import 'package:wheel_mobile/features/admin_settings/data/repositories/settings_repository_impl.dart';
import 'package:wheel_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:wheel_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wheel_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wheel_mobile/features/home/data/datasources/home_remote_data_source.dart';
import 'package:wheel_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:wheel_mobile/features/live_desk/data/datasources/live_desk_local_data_source.dart';
import 'package:wheel_mobile/features/live_desk/data/datasources/live_desk_remote_data_source.dart';
import 'package:wheel_mobile/features/live_desk/data/repositories/live_desk_repository_impl.dart';
import 'package:wheel_mobile/features/live_desk/domain/entities/live_match_state.dart';

import '../helpers/fixtures.dart';

/// One canned reply.
typedef Reply = ({int status, Object? body, Map<String, String> headers});

/// Fake transport: records requests and answers from [handler].
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  Reply Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final reply = handler(options);
    if (reply.status == 0) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    return ResponseBody.fromString(
      reply.body == null ? '' : jsonEncode(reply.body),
      reply.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        for (final h in reply.headers.entries) h.key: [h.value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _MemoryTokens implements TokenStorage {
  String? token;

  @override
  Future<void> clear() async => token = null;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String value) async => token = value;
}

Reply _ok(Object? body, {Map<String, String> headers = const {}}) =>
    (status: 200, body: body, headers: headers);

Reply _status(int status, [Object? body]) =>
    (status: status, body: body, headers: const {});

void main() {
  const config = ApiConfig('http://test/wheel/api/v1');
  late _FakeAdapter adapter;
  late _MemoryTokens tokens;
  late AuthInterceptor auth;
  late Dio dio;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    tokens = _MemoryTokens()..token = '1|abc';
    auth = AuthInterceptor(tokens);
    adapter = _FakeAdapter((_) => _ok(null));
    dio = DioClient.create(
      config: config,
      auth: auth,
      networkStatus: NetworkStatusCubit(),
      logger: Logger(level: Level.off),
    )..httpClientAdapter = adapter;
  });

  HomeRepositoryImpl home() => HomeRepositoryImpl(
    HomeRemoteDataSource(CachedApi(dio, JsonCache(prefs))),
  );

  SettingsRepositoryImpl settings() =>
      SettingsRepositoryImpl(SettingsRemoteDataSource(dio));

  LiveDeskRepositoryImpl live() => LiveDeskRepositoryImpl(
    LiveDeskRemoteDataSource(dio),
    LiveDeskLocalDataSource(prefs),
  );

  final match = LiveMatchState(
    code: 'm-20261030-abc123',
    opponent: 'رجائي',
    date: DateTime(2026, 10, 30),
    played: const ['a', 'b'],
  );

  test(
    'success: parses data and sends Accept / Accept-Language, no token on public calls',
    () async {
      adapter.handler = (_) => _ok(fixtureBody('home'));
      final result = await home().getHome();
      expect(result.valueOrNull?.team.name, 'WHEEL FC');
      final request = adapter.requests.single;
      expect(request.headers['Accept'], Headers.jsonContentType);
      expect(request.headers['Accept-Language'], 'ar');
      expect(request.headers.containsKey('Authorization'), isFalse);
    },
  );

  test(
    '304 (accepted by validateStatus): sends If-None-Match, returns the cached body',
    () async {
      var first = true;
      adapter.handler = (o) {
        if (first) {
          first = false;
          return _ok(fixtureBody('home'), headers: {'etag': '"v22"'});
        }
        return _status(304);
      };
      final repo = home();
      await repo.getHome();
      final second = await repo.getHome();
      expect(adapter.requests.last.headers['If-None-Match'], '"v22"');
      expect(second.valueOrNull?.version, 22);
    },
  );

  test('without an ETag header nothing is sent back', () async {
    adapter.handler = (_) => _ok(fixtureBody('home'));
    final repo = home();
    await repo.getHome();
    await repo.getHome();
    expect(adapter.requests.last.headers.containsKey('If-None-Match'), isFalse);
  });

  test('offline: falls back to the last cached JSON', () async {
    adapter.handler = (_) => _ok(fixtureBody('home'));
    final repo = home();
    await repo.getHome();
    adapter.handler = (_) => (status: 0, body: null, headers: const {});
    final offline = await repo.getHome();
    expect(offline.valueOrNull?.team.name, 'WHEEL FC');
    final cacheOnly = await home().getHome(fromCache: true);
    expect(cacheOnly.isSuccess, isTrue);
  });

  test(
    '401 on an admin call: Unauthorized, token cleared, session expired fired',
    () async {
      adapter.handler = (_) => _status(401, {'message': 'Unauthenticated.'});
      final expired = expectLater(auth.sessionExpired, emits(null));
      final result = await live().sync(match);
      expect(result.failureOrNull, isA<UnauthorizedFailure>());
      expect(tokens.token, isNull);
      expect(adapter.requests.single.headers['Authorization'], 'Bearer 1|abc');
      await expired;
    },
  );

  test('sync sends every required key and parses the server state', () async {
    adapter.handler = (_) => _ok(fixtureBody('live_sync'));
    final result = await live().sync(match);
    expect(result.valueOrNull?.clock.serverNowMs, 1793441966448);
    expect(result.valueOrNull?.events.map((e) => e.uuid), ['e1', 'e2']);
    final request = adapter.requests.single;
    expect(request.method, 'PUT');
    expect(request.path, '/admin/live/sync');
    final body = request.data as Map;
    expect(body.keys.toSet(), {
      'code',
      'opponent',
      'date',
      'played',
      'excused',
      'unfair',
      'late',
      'values',
      'motm',
      'clock',
      'events',
    });
    expect(body['played'], ['a', 'b']);
    expect(body['date'], '2026-10-30');
    expect(body['clock'], {'acc_ms': 0, 'run_at_ms': null});
  });

  test('409 on sync → ConflictFailure with the Arabic message', () async {
    adapter.handler = (_) => _status(409, {'message': 'في مباراة شغالة'});
    final result = await live().sync(match);
    expect(
      result.failureOrNull,
      const ConflictFailure(serverMessage: 'في مباراة شغالة'),
    );
  });

  test('404 on a live-desk action keeps the server message', () async {
    adapter.handler = (_) => _status(404, {'message': 'ما في مباراة مباشرة'});
    final result = await live().discard();
    expect(
      result.failureOrNull,
      const NotFoundFailure(serverMessage: 'ما في مباراة مباشرة'),
    );
  });

  test('clock reply and publish reply are parsed', () async {
    adapter.handler = (o) => o.path.endsWith('/clock')
        ? _ok(fixtureBody('live_clock'))
        : _ok(fixtureBody('live_publish'));
    final clock = await live().sendClock(start: true);
    expect(clock.valueOrNull?.serverNowMs, 1793441966448);
    final published = await live().publish(motm: 'hassan');
    expect(published.valueOrNull?.code, 'm-20261030-abc123');
  });

  test('recompute reads data.version; export returns the JSON text', () async {
    adapter.handler = (o) => o.path.endsWith('/export')
        ? _ok(fixtureBody('export'))
        : _ok(fixtureBody('recompute'));
    expect((await settings().recompute()).valueOrNull, 24);
    final backup = (await settings().exportBackup()).valueOrNull!;
    expect(jsonDecode(backup), fixtureBody('export'));
    expect(adapter.requests.last.path, '/admin/export');
  });

  test(
    '422 on login → ValidationFailure with field errors; token untouched',
    () async {
      tokens.token = null;
      adapter.handler = (_) => _status(422, {
        'message': 'بيانات الدخول غلط',
        'errors': {
          'email': ['بيانات الدخول غلط'],
        },
      });
      final repo = AuthRepositoryImpl(
        remote: AuthRemoteDataSource(dio),
        local: AuthLocalDataSource(tokens, prefs),
        deviceName: () async => 'Pixel 7 · WHEEL FC',
        sessionExpired: auth.sessionExpired,
      );
      final result = await repo.login(email: 'x@y.z', password: 'bad');
      final failure = result.failureOrNull;
      expect(failure, isA<ValidationFailure>());
      expect(
        (failure! as ValidationFailure).fieldError('email'),
        'بيانات الدخول غلط',
      );
      expect(
        (adapter.requests.single.data as Map)['device_name'],
        'Pixel 7 · WHEEL FC',
      );
      expect(tokens.token, isNull);
    },
  );

  test('login ok stores the token; permissions come with the user', () async {
    tokens.token = null;
    adapter.handler = (_) => _ok(fixtureBody('login'));
    final repo = AuthRepositoryImpl(
      remote: AuthRemoteDataSource(dio),
      local: AuthLocalDataSource(tokens, prefs),
      deviceName: () async => 'Pixel 7 · WHEEL FC',
      sessionExpired: auth.sessionExpired,
    );
    final result = await repo.login(email: 'admin@wheel.fc', password: 'ok');
    expect(result, isA<Success<Object?>>());
    expect(result.valueOrNull?.canManageLive, isTrue);
    expect(result.valueOrNull?.canEditConfig, isFalse);
    expect(tokens.token, '1|abcdef');
    expect(adapter.requests, hasLength(1), reason: 'no /auth/me after login');
    expect(
      adapter.requests.single.headers.containsKey('Authorization'),
      isFalse,
    );
  });
}
