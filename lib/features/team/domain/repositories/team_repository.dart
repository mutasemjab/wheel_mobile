import '../../../../core/result/result.dart';
import '../entities/team.dart';

abstract interface class TeamRepository {
  Future<Result<TeamOverview>> getTeam({bool fromCache = false});
}
