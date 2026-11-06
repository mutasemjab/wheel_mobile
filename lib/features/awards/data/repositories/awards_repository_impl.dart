import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/award.dart';
import '../../domain/repositories/awards_repository.dart';
import '../datasources/awards_remote_data_source.dart';

class AwardsRepositoryImpl implements AwardsRepository {
  AwardsRepositoryImpl(this._remote);

  final AwardsRemoteDataSource _remote;

  @override
  Future<Result<List<Award>>> getAwards({bool fromCache = false}) => guard(
    () async => (await _remote.getAwards(
      fromCache: fromCache,
    )).map((m) => m.toEntity()).toList(growable: false),
  );
}
