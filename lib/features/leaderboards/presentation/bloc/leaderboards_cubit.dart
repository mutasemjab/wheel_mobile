import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/leaderboards.dart';
import '../../domain/usecases/get_leaderboards.dart';

class LeaderboardsCubit extends DataCubit<Leaderboards> {
  LeaderboardsCubit(this._getLeaderboards, {super.refreshTrigger});

  final GetLeaderboards _getLeaderboards;

  @override
  Future<Result<Leaderboards>> fetch({required bool fromCache}) =>
      _getLeaderboards(fromCache: fromCache);
}
