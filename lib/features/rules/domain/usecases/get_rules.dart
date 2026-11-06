import '../../../../core/result/result.dart';
import '../entities/rules.dart';
import '../repositories/rules_repository.dart';

class GetRules {
  const GetRules(this._repository);

  final RulesRepository _repository;

  Future<Result<Rules>> call({bool fromCache = false}) =>
      _repository.getRules(fromCache: fromCache);
}
