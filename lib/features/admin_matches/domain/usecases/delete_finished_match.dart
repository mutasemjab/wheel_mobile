import '../../../../core/result/result.dart';
import '../repositories/admin_matches_repository.dart';

class DeleteFinishedMatch {
  const DeleteFinishedMatch(this._repository);

  final AdminMatchesRepository _repository;

  Future<Result<void>> call(String code) => _repository.delete(code);
}
