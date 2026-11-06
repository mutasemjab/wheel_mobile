import '../../../../core/result/result.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class GetTeamSettings {
  const GetTeamSettings(this._repository);

  final SettingsRepository _repository;

  Future<Result<TeamSettings>> call() => _repository.getTeam();
}
