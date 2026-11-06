import '../../../../core/result/result.dart';
import '../repositories/settings_repository.dart';

class ExportBackup {
  const ExportBackup(this._repository);

  final SettingsRepository _repository;

  Future<Result<String>> call() => _repository.exportBackup();
}
