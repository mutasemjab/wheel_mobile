import '../../../../core/entities/clock_snapshot.dart';
import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../../matches/domain/entities/match.dart';
import '../../domain/entities/live_match_state.dart';
import '../../domain/entities/server_live_match.dart';
import '../../domain/repositories/live_desk_repository.dart';
import '../datasources/live_desk_local_data_source.dart';
import '../datasources/live_desk_remote_data_source.dart';

class LiveDeskRepositoryImpl implements LiveDeskRepository {
  LiveDeskRepositoryImpl(this._remote, this._local);

  final LiveDeskRemoteDataSource _remote;
  final LiveDeskLocalDataSource _local;

  @override
  Future<Result<ServerLiveMatch?>> fetchServerMatch() =>
      guard(() async => (await _remote.fetch())?.toEntity());

  @override
  Future<Result<ServerLiveMatch?>> sync(LiveMatchState state) =>
      guard(() async => (await _remote.sync(state))?.toEntity());

  @override
  Future<Result<ClockSnapshot>> sendClock({required bool start}) =>
      guard(() async => (await _remote.clock(start: start)).toEntity());

  @override
  Future<Result<LiveFinishResult>> finish({String? motm}) =>
      guard(() async => (await _remote.finish(motm: motm)).toEntity());

  @override
  Future<Result<FootballMatch>> publish({String? motm}) =>
      guard(() async => (await _remote.publish(motm: motm)).toEntity());

  @override
  Future<Result<void>> discard() => guard(_remote.discard);

  @override
  Future<LiveMatchState?> loadLocal() async => _local.load();

  @override
  Future<void> saveLocal(LiveMatchState state) => _local.save(state);

  @override
  Future<void> clearLocal() => _local.clear();
}
