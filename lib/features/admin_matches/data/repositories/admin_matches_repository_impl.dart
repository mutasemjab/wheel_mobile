import '../../../../core/error/failures.dart';
import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../../live_desk/domain/entities/live_match_state.dart';
import '../../../matches/domain/entities/match.dart';
import '../../domain/entities/editable_match.dart';
import '../../domain/repositories/admin_matches_repository.dart';
import '../datasources/admin_matches_remote_data_source.dart';

class AdminMatchesRepositoryImpl implements AdminMatchesRepository {
  AdminMatchesRepositoryImpl(this._remote);

  final AdminMatchesRemoteDataSource _remote;

  @override
  Future<Result<MatchesPage>> getMatches({
    int page = 1,
    bool fromCache = false,
  }) async => fromCache
      ? const Err(CacheFailure())
      : guard(() async => (await _remote.getMatches(page: page)).toEntity());

  @override
  Future<Result<EditableMatch>> getForEdit(String code) =>
      guard(() async => (await _remote.getForEdit(code)).toEntity());

  @override
  Future<Result<String>> getSummary(String code) =>
      guard(() => _remote.getSummary(code));

  @override
  Future<Result<EditableMatch>> update(LiveMatchState match, {String? note}) =>
      guard(() async => (await _remote.update(match, note: note)).toEntity());

  @override
  Future<Result<void>> delete(String code) => guard(() => _remote.delete(code));
}
