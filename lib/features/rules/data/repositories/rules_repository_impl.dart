import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/rules.dart';
import '../../domain/repositories/rules_repository.dart';
import '../datasources/rules_remote_data_source.dart';

class RulesRepositoryImpl implements RulesRepository {
  RulesRepositoryImpl(this._remote);

  final RulesRemoteDataSource _remote;

  @override
  Future<Result<Rules>> getRules({bool fromCache = false}) => guard(
    () async => (await _remote.getRules(fromCache: fromCache)).toEntity(),
  );
}
