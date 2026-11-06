import '../../../../core/network/api_config.dart';
import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/admin_player.dart';
import '../../domain/repositories/admin_players_repository.dart';
import '../datasources/admin_players_remote_data_source.dart';

class AdminPlayersRepositoryImpl implements AdminPlayersRepository {
  AdminPlayersRepositoryImpl(this._remote, this._config);

  final AdminPlayersRemoteDataSource _remote;
  final ApiConfig _config;

  @override
  Future<Result<List<AdminPlayer>>> getPlayers() => guard(() async {
    final players =
        (await _remote.getPlayers()).map((m) => m.toEntity(_config)).toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return players;
  });

  @override
  Future<Result<void>> create(PlayerDraft draft) =>
      guard(() => _remote.create(draft));

  @override
  Future<Result<void>> update(String slug, PlayerDraft draft) =>
      guard(() => _remote.update(slug, draft));

  @override
  Future<Result<void>> delete(String slug) => guard(() => _remote.delete(slug));

  @override
  Future<Result<void>> uploadPhoto(String slug, String filePath) =>
      guard(() => _remote.uploadPhoto(slug, filePath));

  @override
  Future<Result<void>> reorder(List<String> slugs) =>
      guard(() => _remote.reorder(slugs));
}
