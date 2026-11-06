import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._remote);

  final SettingsRemoteDataSource _remote;

  @override
  Future<Result<RatingConfig>> getConfig() =>
      guard(() async => (await _remote.getConfig()).toEntity());

  @override
  Future<Result<void>> saveConfig(RatingConfig config) =>
      guard(() => _remote.saveConfig(config));

  @override
  Future<Result<TeamSettings>> getTeam() =>
      guard(() async => (await _remote.getTeam()).toEntity());

  @override
  Future<Result<void>> saveTeam(TeamSettings team) =>
      guard(() => _remote.saveTeam(team));

  @override
  Future<Result<int>> recompute() => guard(_remote.recompute);

  @override
  Future<Result<String>> exportBackup() => guard(_remote.export);
}
