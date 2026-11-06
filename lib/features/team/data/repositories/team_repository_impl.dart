import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/team.dart';
import '../../domain/repositories/team_repository.dart';
import '../datasources/team_remote_data_source.dart';

class TeamRepositoryImpl implements TeamRepository {
  TeamRepositoryImpl(this._remote);

  final TeamRemoteDataSource _remote;

  @override
  Future<Result<TeamOverview>> getTeam({bool fromCache = false}) => guard(
    () async => (await _remote.getTeam(fromCache: fromCache)).toEntity(),
  );
}
