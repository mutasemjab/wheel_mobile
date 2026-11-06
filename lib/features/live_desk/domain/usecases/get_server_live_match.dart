import '../../../../core/result/result.dart';
import '../entities/server_live_match.dart';
import '../repositories/live_desk_repository.dart';

class GetServerLiveMatch {
  const GetServerLiveMatch(this._repository);

  final LiveDeskRepository _repository;

  Future<Result<ServerLiveMatch?>> call() => _repository.fetchServerMatch();
}
