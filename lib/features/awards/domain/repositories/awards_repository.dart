import '../../../../core/result/result.dart';
import '../entities/award.dart';

abstract interface class AwardsRepository {
  Future<Result<List<Award>>> getAwards({bool fromCache = false});
}
