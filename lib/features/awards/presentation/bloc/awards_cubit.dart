import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/award.dart';
import '../../domain/usecases/get_awards.dart';

class AwardsCubit extends DataCubit<List<Award>> {
  AwardsCubit(this._getAwards, {super.refreshTrigger});

  final GetAwards _getAwards;

  @override
  Future<Result<List<Award>>> fetch({required bool fromCache}) =>
      _getAwards(fromCache: fromCache);
}
