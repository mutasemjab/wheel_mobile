import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheel_mobile/core/error/failures.dart';
import 'package:wheel_mobile/core/result/result.dart';
import 'package:wheel_mobile/features/auth/domain/entities/admin_user.dart';
import 'package:wheel_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:wheel_mobile/features/auth/domain/usecases/login_with_email.dart';
import 'package:wheel_mobile/features/auth/domain/usecases/login_with_pin.dart';
import 'package:wheel_mobile/features/auth/domain/usecases/logout.dart';
import 'package:wheel_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:wheel_mobile/features/auth/domain/usecases/watch_session_expired.dart';
import 'package:wheel_mobile/features/auth/presentation/bloc/auth_bloc.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

const _admin = AdminUser(
  id: 1,
  name: 'حمزة',
  email: 'admin@wheel.fc',
  permissions: {Permissions.liveManage},
);

void main() {
  late _MockAuthRepository repo;
  late StreamController<void> expired;

  setUp(() {
    repo = _MockAuthRepository();
    expired = StreamController<void>.broadcast();
    when(() => repo.sessionExpired).thenAnswer((_) => expired.stream);
    when(() => repo.logout()).thenAnswer((_) async {});
  });

  tearDown(() => expired.close());

  AuthBloc build() => AuthBloc(
    loginWithEmail: LoginWithEmail(repo),
    loginWithPin: LoginWithPin(repo),
    restoreSession: RestoreSession(repo),
    logout: Logout(repo),
    watchSessionExpired: WatchSessionExpired(repo),
  );

  blocTest<AuthBloc, AuthState>(
    'email login ok',
    setUp: () => when(
      () => repo.login(email: 'admin@wheel.fc', password: 'secret'),
    ).thenAnswer((_) async => const Success(_admin)),
    build: build,
    act: (b) => b.add(
      const AuthLoginRequested(email: ' admin@wheel.fc ', password: 'secret'),
    ),
    expect: () => [const AuthSubmitting(), const AuthAuthenticated(_admin)],
  );

  const wrong = ValidationFailure(
    serverMessage: 'بيانات الدخول غلط',
    fieldErrors: {
      'email': ['بيانات الدخول غلط'],
    },
  );

  blocTest<AuthBloc, AuthState>(
    'email login 422 → unauthenticated with field errors',
    setUp: () => when(
      () => repo.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Err(wrong)),
    build: build,
    act: (b) => b.add(const AuthLoginRequested(email: 'x', password: 'y')),
    expect: () => [
      const AuthSubmitting(),
      const AuthUnauthenticated(failure: wrong),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'PIN throttled (429)',
    setUp: () => when(
      () => repo.loginWithPin('1234'),
    ).thenAnswer((_) async => const Err(RateLimitFailure())),
    build: build,
    act: (b) => b.add(const AuthPinRequested('1234')),
    expect: () => [
      const AuthSubmitting(),
      const AuthUnauthenticated(failure: RateLimitFailure()),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'PIN login ok',
    setUp: () => when(
      () => repo.loginWithPin('2468'),
    ).thenAnswer((_) async => const Success(_admin)),
    build: build,
    act: (b) => b.add(const AuthPinRequested('2468')),
    expect: () => [const AuthSubmitting(), const AuthAuthenticated(_admin)],
  );

  blocTest<AuthBloc, AuthState>(
    'restores the session from a stored token',
    setUp: () => when(
      () => repo.restore(),
    ).thenAnswer((_) async => const Success(_admin)),
    build: build,
    act: (b) => b.add(const AuthStarted()),
    expect: () => [const AuthAuthenticated(_admin)],
  );

  blocTest<AuthBloc, AuthState>(
    'no token → unauthenticated',
    setUp: () =>
        when(() => repo.restore()).thenAnswer((_) async => const Success(null)),
    build: build,
    act: (b) => b.add(const AuthStarted()),
    expect: () => [const AuthUnauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    '401 on an admin call → logged out (expired)',
    build: build,
    seed: () => const AuthAuthenticated(_admin),
    act: (_) => expired.add(null),
    expect: () => [const AuthUnauthenticated(expired: true)],
  );

  blocTest<AuthBloc, AuthState>(
    'logout clears the session',
    build: build,
    seed: () => const AuthAuthenticated(_admin),
    act: (b) => b.add(const AuthLogoutRequested()),
    expect: () => [const AuthUnauthenticated()],
    verify: (_) => verify(() => repo.logout()).called(1),
  );
}
