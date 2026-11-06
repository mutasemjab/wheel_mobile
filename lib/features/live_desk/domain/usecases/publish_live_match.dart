import '../../../../core/result/result.dart';
import '../../../matches/domain/entities/match.dart';
import '../repositories/live_desk_repository.dart';

class PublishLiveMatch {
  const PublishLiveMatch(this._repository);

  final LiveDeskRepository _repository;

  Future<Result<FootballMatch>> call({String? motm}) =>
      _repository.publish(motm: motm);
}
