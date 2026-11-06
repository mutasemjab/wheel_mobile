import '../../../../core/result/result.dart';
import '../../../live_desk/domain/entities/live_match_state.dart';
import '../entities/editable_match.dart';
import '../repositories/admin_matches_repository.dart';

class UpdateFinishedMatch {
  const UpdateFinishedMatch(this._repository);

  final AdminMatchesRepository _repository;

  Future<Result<EditableMatch>> call(LiveMatchState match, {String? note}) =>
      _repository.update(match, note: note);
}
