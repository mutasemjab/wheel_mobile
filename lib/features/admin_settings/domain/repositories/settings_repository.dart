import '../../../../core/result/result.dart';
import '../entities/settings.dart';

abstract interface class SettingsRepository {
  Future<Result<RatingConfig>> getConfig();

  /// Saving recomputes every rating on the server.
  Future<Result<void>> saveConfig(RatingConfig config);

  Future<Result<TeamSettings>> getTeam();

  Future<Result<void>> saveTeam(TeamSettings team);

  /// `POST /admin/recompute` → new data version.
  Future<Result<int>> recompute();

  /// `GET /admin/export` → JSON backup text.
  Future<Result<String>> exportBackup();
}
