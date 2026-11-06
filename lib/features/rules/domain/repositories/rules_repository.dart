import '../../../../core/result/result.dart';
import '../entities/rules.dart';

abstract interface class RulesRepository {
  Future<Result<Rules>> getRules({bool fromCache = false});
}
