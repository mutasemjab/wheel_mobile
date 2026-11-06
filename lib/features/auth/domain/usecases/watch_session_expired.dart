import '../repositories/auth_repository.dart';

class WatchSessionExpired {
  const WatchSessionExpired(this._repository);

  final AuthRepository _repository;

  Stream<void> call() => _repository.sessionExpired;
}
