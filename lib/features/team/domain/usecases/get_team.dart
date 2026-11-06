import '../../../../core/result/result.dart';
import '../entities/team.dart';
import '../repositories/team_repository.dart';

class GetTeam {
  const GetTeam(this._repository);

  final TeamRepository _repository;

  Future<Result<TeamOverview>> call({bool fromCache = false}) =>
      _repository.getTeam(fromCache: fromCache);
}
