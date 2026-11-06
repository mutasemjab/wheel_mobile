import '../../../../core/result/result.dart';
import '../repositories/settings_repository.dart';

class RecomputeRatings {
  const RecomputeRatings(this._repository);

  final SettingsRepository _repository;

  Future<Result<int>> call() => _repository.recompute();
}
