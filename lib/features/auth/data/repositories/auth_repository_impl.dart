import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/admin_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required Future<String> Function() deviceName,
    required Stream<void> sessionExpired,
  }) : _remote = remote,
       _local = local,
       _deviceName = deviceName,
       _sessionExpired = sessionExpired;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final Future<String> Function() _deviceName;
  final Stream<void> _sessionExpired;

  @override
  Stream<void> get sessionExpired => _sessionExpired;

  @override
  Future<Result<AdminUser>> login({
    required String email,
    required String password,
  }) => _completeLogin(
    () async => _remote.login(
      email: email,
      password: password,
      deviceName: await _deviceName(),
    ),
  );

  @override
  Future<Result<AdminUser>> loginWithPin(String pin) => _completeLogin(
    () async => _remote.loginWithPin(pin: pin, deviceName: await _deviceName()),
  );

  /// Stores the token and the user; `data.user` already has `permissions`.
  Future<Result<AdminUser>> _completeLogin(
    Future<LoginResponseModel> Function() request,
  ) => guard(() async {
    final response = await request();
    await _local.saveToken(response.token);
    await _local.saveUser(response.user);
    return response.user.toEntity();
  });

  @override
  Future<Result<AdminUser?>> restore() async {
    final token = await _local.readToken();
    if (token == null || token.isEmpty) return const Success(null);
    try {
      final user = await _remote.me();
      await _local.saveUser(user);
      return Success(user.toEntity());
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      return switch (failure) {
        UnauthorizedFailure() => await _expire(),
        NetworkFailure() ||
        ServerFailure() => Success(_local.readUser()?.toEntity()),
        _ => Err(failure),
      };
    }
  }

  Future<Result<AdminUser?>> _expire() async {
    await _local.clear();
    return const Success(null);
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } on Exception {
      // Best effort: the token is cleared locally regardless.
    }
    await _local.clear();
  }
}
