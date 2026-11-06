import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/admin_player.dart';
import '../models/admin_player_model.dart';

class AdminPlayersRemoteDataSource {
  AdminPlayersRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<AdminPlayerModel>> getPlayers() async {
    final response = await _dio.get<Object?>(ApiEndpoints.adminPlayers);
    final data = dataOf(response.data);
    final list = data is List ? data : asMap(data)['data'];
    return asMapList(list).map(AdminPlayerModel.new).toList();
  }

  Future<void> create(PlayerDraft draft) => _dio.post<Object?>(
    ApiEndpoints.adminPlayers,
    data: AdminPlayerModel.body(draft),
  );

  Future<void> update(String slug, PlayerDraft draft) => _dio.put<Object?>(
    ApiEndpoints.adminPlayer(slug),
    data: AdminPlayerModel.body(draft),
  );

  Future<void> delete(String slug) =>
      _dio.delete<Object?>(ApiEndpoints.adminPlayer(slug));

  Future<void> uploadPhoto(String slug, String filePath) async {
    final form = FormData.fromMap({
      'photo': await MultipartFile.fromFile(filePath),
    });
    await _dio.post<Object?>(ApiEndpoints.adminPlayerPhoto(slug), data: form);
  }

  Future<void> reorder(List<String> slugs) => _dio.post<Object?>(
    ApiEndpoints.adminPlayersReorder,
    data: {'slugs': slugs},
  );
}
