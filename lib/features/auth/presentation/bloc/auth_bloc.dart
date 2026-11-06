import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/login_with_pin.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/restore_session.dart';
import '../../domain/usecases/watch_session_expired.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// App start: restore the session from a stored token.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class AuthPinRequested extends AuthEvent {
  const AuthPinRequested(this.pin);

  final String pin;

  @override
  List<Object?> get props => [pin];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}

sealed class AuthState extends Equatable {
  const AuthState();

  AdminUser? get user => null;

  @override
  List<Object?> get props => [];
}

final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.failure, this.expired = false});

  final Failure? failure;

  /// True when a 401 ended the session (login page explains why).
  final bool expired;

  @override
  List<Object?> get props => [failure, expired];
}

final class AuthSubmitting extends AuthState {
  const AuthSubmitting();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.admin);

  final AdminUser admin;

  @override
  AdminUser get user => admin;

  @override
  List<Object?> get props => [admin];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginWithEmail loginWithEmail,
    required LoginWithPin loginWithPin,
    required RestoreSession restoreSession,
    required Logout logout,
    required WatchSessionExpired watchSessionExpired,
  }) : _loginWithEmail = loginWithEmail,
       _loginWithPin = loginWithPin,
       _restoreSession = restoreSession,
       _logout = logout,
       super(const AuthUnknown()) {
    on<AuthStarted>(_onStarted, transformer: droppable());
    on<AuthLoginRequested>(_onLogin, transformer: droppable());
    on<AuthPinRequested>(_onPin, transformer: droppable());
    on<AuthLogoutRequested>(_onLogout, transformer: droppable());
    on<AuthSessionExpired>(_onExpired);
    _expiredSub = watchSessionExpired().listen(
      (_) => add(const AuthSessionExpired()),
    );
  }

  final LoginWithEmail _loginWithEmail;
  final LoginWithPin _loginWithPin;
  final RestoreSession _restoreSession;
  final Logout _logout;
  late final StreamSubscription<void> _expiredSub;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _restoreSession();
    emit(switch (result) {
      Success(value: final user?) => AuthAuthenticated(user),
      Success() => const AuthUnauthenticated(),
      Err(:final failure) => AuthUnauthenticated(failure: failure),
    });
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSubmitting());
    _emitLogin(
      await _loginWithEmail(
        email: event.email.trim(),
        password: event.password,
      ),
      emit,
    );
  }

  Future<void> _onPin(AuthPinRequested event, Emitter<AuthState> emit) async {
    emit(const AuthSubmitting());
    _emitLogin(await _loginWithPin(event.pin), emit);
  }

  void _emitLogin(Result<AdminUser> result, Emitter<AuthState> emit) =>
      emit(switch (result) {
        Success(:final value) => AuthAuthenticated(value),
        Err(:final failure) => AuthUnauthenticated(failure: failure),
      });

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout();
    emit(const AuthUnauthenticated());
  }

  /// Token is already cleared; local live-desk state is left untouched.
  void _onExpired(AuthSessionExpired event, Emitter<AuthState> emit) {
    if (state is AuthAuthenticated) {
      emit(const AuthUnauthenticated(expired: true));
    }
  }

  @override
  Future<void> close() async {
    await _expiredSub.cancel();
    return super.close();
  }
}
