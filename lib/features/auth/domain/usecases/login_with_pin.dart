import '../../../../core/result/result.dart';
import '../entities/admin_user.dart';
import '../repositories/auth_repository.dart';

class LoginWithPin {
  const LoginWithPin(this._repository);

  final AuthRepository _repository;

  Future<Result<AdminUser>> call(String pin) => _repository.loginWithPin(pin);
}
