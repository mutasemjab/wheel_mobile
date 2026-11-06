import '../../../../core/result/result.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class SaveRatingConfig {
  const SaveRatingConfig(this._repository);

  final SettingsRepository _repository;

  Future<Result<void>> call(RatingConfig config) =>
      _repository.saveConfig(config);
}
