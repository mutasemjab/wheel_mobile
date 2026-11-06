import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../../live_desk/data/models/live_sync_payload.dart';
import '../../../live_desk/domain/entities/live_match_state.dart';
import '../../../matches/data/models/match_model.dart';
import '../models/editable_match_model.dart';

class AdminMatchesRemoteDataSource {
  AdminMatchesRemoteDataSource(this._dio);

  final Dio _dio;

  /// Public match objects + `meta`.
  Future<MatchesPageModel> getMatches({int page = 1}) async {
    final response = await _dio.get<Object?>(
      ApiEndpoints.adminMatches,
      queryParameters: {'page': page},
    );
    return MatchesPageModel.fromJson(response.data);
  }

  Future<EditableMatchModel> getForEdit(String code) async {
    final response = await _dio.get<Object?>(ApiEndpoints.adminMatch(code));
    return EditableMatchModel(asMap(dataOf(response.data)));
  }

  Future<String> getSummary(String code) async {
    final response = await _dio.get<Object?>(
      ApiEndpoints.adminMatchSummary(code),
    );
    return asString(asMap(dataOf(response.data))['text']);
  }

  /// Returns the saved editor shape (score recomputed from `events`).
  Future<EditableMatchModel> update(
    LiveMatchState match, {
    String? note,
  }) async {
    final response = await _dio.put<Object?>(
      ApiEndpoints.adminMatch(match.code),
      data: LiveSyncPayload.sync(match, includeClock: false, note: note),
    );
    return EditableMatchModel(asMap(dataOf(response.data)));
  }

  Future<void> delete(String code) =>
      _dio.delete<Object?>(ApiEndpoints.adminMatch(code));
}
