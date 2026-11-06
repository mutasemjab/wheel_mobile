import '../../../../core/entities/clock_snapshot.dart';
import '../../../../core/result/result.dart';
import '../../../matches/domain/entities/match.dart';
import '../entities/live_match_state.dart';
import '../entities/server_live_match.dart';

abstract interface class LiveDeskRepository {
  /// `GET /admin/live`; `null` when nothing is live.
  Future<Result<ServerLiveMatch?>> fetchServerMatch();

  /// `PUT /admin/live/sync` with the full state; creates the live match if
  /// none exists. 409 = another live match, or [state]'s code is published.
  Future<Result<ServerLiveMatch?>> sync(LiveMatchState state);

  /// `POST /admin/live/clock` → the server clock (used for the time offset).
  Future<Result<ClockSnapshot>> sendClock({required bool start});

  Future<Result<LiveFinishResult>> finish({String? motm});

  /// `POST /admin/live/publish` → the published public match.
  Future<Result<FootballMatch>> publish({String? motm});

  /// `DELETE /admin/live`.
  Future<Result<void>> discard();

  Future<LiveMatchState?> loadLocal();

  Future<void> saveLocal(LiveMatchState state);

  Future<void> clearLocal();
}
