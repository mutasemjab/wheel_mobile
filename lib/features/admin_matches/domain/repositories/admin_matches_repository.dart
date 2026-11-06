import '../../../../core/result/result.dart';
import '../../../live_desk/domain/entities/live_match_state.dart';
import '../../../matches/domain/entities/match.dart';
import '../entities/editable_match.dart';

abstract interface class AdminMatchesRepository {
  /// `GET /admin/matches?page=`; never cached ([fromCache] → `CacheFailure`).
  Future<Result<MatchesPage>> getMatches({
    int page = 1,
    bool fromCache = false,
  });

  /// `GET /admin/matches/{code}` in the editor shape.
  Future<Result<EditableMatch>> getForEdit(String code);

  /// `GET /admin/matches/{code}/summary` → WhatsApp text.
  Future<Result<String>> getSummary(String code);

  /// `PUT /admin/matches/{code}`; the server recomputes the score.
  Future<Result<EditableMatch>> update(LiveMatchState match, {String? note});

  Future<Result<void>> delete(String code);
}
