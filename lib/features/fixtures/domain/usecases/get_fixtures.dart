import '../../../../core/result/result.dart';
import '../entities/fixture.dart';
import '../repositories/fixtures_repository.dart';

class GetFixtures {
  const GetFixtures(this._repository);

  final FixturesRepository _repository;

  Future<Result<FixturesData>> call({bool fromCache = false}) =>
      _repository.getFixtures(fromCache: fromCache);
}
