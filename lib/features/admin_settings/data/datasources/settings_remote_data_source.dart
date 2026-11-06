import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/settings.dart';
import '../models/settings_model.dart';

class SettingsRemoteDataSource {
  SettingsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<RatingConfigModel> getConfig() async {
    final response = await _dio.get<Object?>(ApiEndpoints.adminConfig);
    return RatingConfigModel(asMap(dataOf(response.data)));
  }

  Future<void> saveConfig(RatingConfig config) => _dio.put<Object?>(
    ApiEndpoints.adminConfig,
    data: RatingConfigModel.body(config),
  );

  Future<TeamSettingsModel> getTeam() async {
    final response = await _dio.get<Object?>(ApiEndpoints.adminTeam);
    return TeamSettingsModel(asMap(dataOf(response.data)));
  }

  Future<void> saveTeam(TeamSettings team) => _dio.put<Object?>(
    ApiEndpoints.adminTeam,
    data: TeamSettingsModel.body(team),
  );

  Future<int> recompute() async {
    final response = await _dio.post<Object?>(ApiEndpoints.adminRecompute);
    return asInt(asMap(dataOf(response.data))['version']);
  }

  /// `GET /admin/export` → full JSON backup, pretty-printed.
  Future<String> export() async {
    final response = await _dio.get<Object?>(ApiEndpoints.adminExport);
    return const JsonEncoder.withIndent('  ').convert(response.data);
  }
}
