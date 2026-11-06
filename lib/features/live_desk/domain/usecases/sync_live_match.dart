import '../../../../core/result/result.dart';
import '../entities/live_match_state.dart';
import '../entities/server_live_match.dart';
import '../repositories/live_desk_repository.dart';

class SyncLiveMatch {
  const SyncLiveMatch(this._repository);

  final LiveDeskRepository _repository;

  Future<Result<ServerLiveMatch?>> call(LiveMatchState state) =>
      _repository.sync(state);
}
