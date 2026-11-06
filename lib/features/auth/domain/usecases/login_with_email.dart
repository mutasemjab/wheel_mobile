import '../../../../core/result/result.dart';
import '../entities/admin_user.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmail {
  const LoginWithEmail(this._repository);

  final AuthRepository _repository;

  Future<Result<AdminUser>> call({
    required String email,
    required String password,
  }) => _repository.login(email: email, password: password);
}
