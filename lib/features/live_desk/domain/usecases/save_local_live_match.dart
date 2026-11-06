import '../entities/live_match_state.dart';
import '../repositories/live_desk_repository.dart';

class SaveLocalLiveMatch {
  const SaveLocalLiveMatch(this._repository);

  final LiveDeskRepository _repository;

  Future<void> call(LiveMatchState state) => _repository.saveLocal(state);
}
