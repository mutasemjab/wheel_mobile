import '../../../../core/result/result.dart';
import '../entities/admin_user.dart';

abstract interface class AuthRepository {
  Future<Result<AdminUser>> login({
    required String email,
    required String password,
  });

  Future<Result<AdminUser>> loginWithPin(String pin);

  /// Restores the session from a stored token. `null` when logged out.
  /// Offline, the cached user is trusted so the live desk still opens.
  Future<Result<AdminUser?>> restore();

  Future<void> logout();

  /// Fires when an admin call returned 401 (token already cleared).
  Stream<void> get sessionExpired;
}
