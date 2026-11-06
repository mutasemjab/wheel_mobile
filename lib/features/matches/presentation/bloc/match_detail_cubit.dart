import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/match.dart';
import '../../domain/usecases/get_match_detail.dart';

class MatchDetailCubit extends DataCubit<MatchDetail> {
  MatchDetailCubit(this._getDetail, this.code, {super.refreshTrigger});

  final GetMatchDetail _getDetail;
  final String code;

  @override
  Future<Result<MatchDetail>> fetch({required bool fromCache}) =>
      _getDetail(code, fromCache: fromCache);
}
