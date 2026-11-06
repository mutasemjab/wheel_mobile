import '../../../../core/result/result.dart';
import '../entities/admin_user.dart';
import '../repositories/auth_repository.dart';

class RestoreSession {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  Future<Result<AdminUser?>> call() => _repository.restore();
}
