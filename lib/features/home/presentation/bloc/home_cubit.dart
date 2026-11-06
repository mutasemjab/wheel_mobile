import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/usecases/get_home.dart';

class HomeCubit extends DataCubit<HomeData> {
  HomeCubit(this._getHome, {super.refreshTrigger});

  final GetHome _getHome;

  @override
  Future<Result<HomeData>> fetch({required bool fromCache}) =>
      _getHome(fromCache: fromCache);
}
