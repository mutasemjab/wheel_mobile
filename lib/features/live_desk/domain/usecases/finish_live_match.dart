import '../../../../core/result/result.dart';
import '../entities/server_live_match.dart';
import '../repositories/live_desk_repository.dart';

class FinishLiveMatch {
  const FinishLiveMatch(this._repository);

  final LiveDeskRepository _repository;

  Future<Result<LiveFinishResult>> call({String? motm}) =>
      _repository.finish(motm: motm);
}
