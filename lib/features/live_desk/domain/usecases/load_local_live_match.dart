import '../entities/live_match_state.dart';
import '../repositories/live_desk_repository.dart';

class LoadLocalLiveMatch {
  const LoadLocalLiveMatch(this._repository);

  final LiveDeskRepository _repository;

  Future<LiveMatchState?> call() => _repository.loadLocal();
}
