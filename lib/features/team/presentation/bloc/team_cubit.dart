import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/team.dart';
import '../../domain/usecases/get_team.dart';

class TeamCubit extends DataCubit<TeamOverview> {
  TeamCubit(this._getTeam, {super.refreshTrigger});

  final GetTeam _getTeam;

  @override
  Future<Result<TeamOverview>> fetch({required bool fromCache}) =>
      _getTeam(fromCache: fromCache);
}
