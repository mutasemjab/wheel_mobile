import '../../../../core/result/result.dart';
import '../repositories/live_desk_repository.dart';

class DiscardLiveMatch {
  const DiscardLiveMatch(this._repository);

  final LiveDeskRepository _repository;

  Future<Result<void>> call() => _repository.discard();
}
