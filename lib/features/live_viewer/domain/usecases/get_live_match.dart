import '../../../../core/result/result.dart';
import '../entities/live_match.dart';
import '../repositories/live_viewer_repository.dart';

class GetLiveMatch {
  const GetLiveMatch(this._repository);

  final LiveViewerRepository _repository;

  Future<Result<LiveMatch?>> call() => _repository.getLive();
}
