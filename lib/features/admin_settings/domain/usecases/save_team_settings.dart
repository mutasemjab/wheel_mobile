import '../../../../core/result/result.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class SaveTeamSettings {
  const SaveTeamSettings(this._repository);

  final SettingsRepository _repository;

  Future<Result<void>> call(TeamSettings team) => _repository.saveTeam(team);
}
