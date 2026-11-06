import '../repositories/live_desk_repository.dart';

class ClearLocalLiveMatch {
  const ClearLocalLiveMatch(this._repository);

  final LiveDeskRepository _repository;

  Future<void> call() => _repository.clearLocal();
}
