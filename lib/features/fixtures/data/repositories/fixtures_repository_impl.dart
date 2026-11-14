import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/fixture.dart';
import '../../domain/repositories/fixtures_repository.dart';
import '../datasources/fixtures_remote_data_source.dart';

class FixturesRepositoryImpl implements FixturesRepository {
  FixturesRepositoryImpl(this._remote);

  final FixturesRemoteDataSource _remote;

  @override
  Future<Result<FixturesData>> getFixtures({bool fromCache = false}) =>
      guard(() => _remote.getFixtures(fromCache: fromCache));
}
