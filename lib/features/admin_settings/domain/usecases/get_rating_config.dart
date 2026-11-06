import '../../../../core/result/result.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class GetRatingConfig {
  const GetRatingConfig(this._repository);

  final SettingsRepository _repository;

  Future<Result<RatingConfig>> call() => _repository.getConfig();
}
