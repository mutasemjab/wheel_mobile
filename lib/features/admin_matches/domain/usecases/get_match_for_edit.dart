import '../../../../core/result/result.dart';
import '../entities/editable_match.dart';
import '../repositories/admin_matches_repository.dart';

class GetMatchForEdit {
  const GetMatchForEdit(this._repository);

  final AdminMatchesRepository _repository;

  Future<Result<EditableMatch>> call(String code) =>
      _repository.getForEdit(code);
}
