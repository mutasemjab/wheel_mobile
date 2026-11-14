import '../../../../core/result/result.dart';
import '../entities/fixture.dart';

abstract interface class FixturesRepository {
  Future<Result<FixturesData>> getFixtures({bool fromCache = false});
}
