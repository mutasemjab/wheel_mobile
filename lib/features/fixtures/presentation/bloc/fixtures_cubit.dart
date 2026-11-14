import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/fixture.dart';
import '../../domain/usecases/get_fixtures.dart';

class FixturesCubit extends DataCubit<FixturesData> {
  FixturesCubit(this._getFixtures, {super.refreshTrigger});

  final GetFixtures _getFixtures;

  @override
  Future<Result<FixturesData>> fetch({required bool fromCache}) =>
      _getFixtures(fromCache: fromCache);
}
