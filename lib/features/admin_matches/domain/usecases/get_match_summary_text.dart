import '../../../../core/result/result.dart';
import '../repositories/admin_matches_repository.dart';

class GetMatchSummaryText {
  const GetMatchSummaryText(this._repository);

  final AdminMatchesRepository _repository;

  Future<Result<String>> call(String code) => _repository.getSummary(code);
}
