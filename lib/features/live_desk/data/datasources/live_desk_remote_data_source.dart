import 'package:dio/dio.dart';

import '../../../../core/models/clock_snapshot_model.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../../matches/data/models/match_model.dart';
import '../../domain/entities/live_match_state.dart';
import '../models/live_sync_payload.dart';
import '../models/server_live_match_model.dart';

class LiveDeskRemoteDataSource {
  LiveDeskRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ServerLiveMatchModel?> fetch() async {
    final response = await _dio.get<Object?>(ApiEndpoints.adminLive);
    return _liveState(response.data);
  }

  /// `PUT /admin/live/sync` — creates the live match when none exists.
  /// Returns the server's (sanitised) state.
  Future<ServerLiveMatchModel?> sync(LiveMatchState state) async {
    final response = await _dio.put<Object?>(
      ApiEndpoints.adminLiveSync,
      data: LiveSyncPayload.sync(state),
    );
    return _liveState(response.data);
  }

  /// Returns the server clock (`acc_ms`, `run_at_ms`, `server_now_ms`).
  Future<ClockSnapshotModel> clock({required bool start}) async {
    final response = await _dio.post<Object?>(
      ApiEndpoints.adminLiveClock,
      data: {'action': start ? 'start' : 'pause'},
    );
    return ClockSnapshotModel.fromJson(dataOf(response.data));
  }

  Future<LiveFinishResultModel> finish({String? motm}) async {
    final response = await _dio.post<Object?>(
      ApiEndpoints.adminLiveFinish,
      data: {'motm': ?motm},
    );
    return LiveFinishResultModel(asMap(dataOf(response.data)));
  }

  /// Returns the published match (public shape, plus `version`).
  Future<MatchModel> publish({String? motm}) async {
    final response = await _dio.post<Object?>(
      ApiEndpoints.adminLivePublish,
      data: {'motm': ?motm},
    );
    return MatchModel.fromJson(asMap(dataOf(response.data)));
  }

  Future<void> discard() => _dio.delete<Object?>(ApiEndpoints.adminLive);

  static ServerLiveMatchModel? _liveState(Object? body) {
    final data = asMapOrNull(dataOf(body));
    return data == null ? null : ServerLiveMatchModel(data);
  }
}
