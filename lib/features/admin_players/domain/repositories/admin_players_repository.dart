import '../../../../core/result/result.dart';
import '../entities/admin_player.dart';

abstract interface class AdminPlayersRepository {
  Future<Result<List<AdminPlayer>>> getPlayers();

  Future<Result<void>> create(PlayerDraft draft);

  Future<Result<void>> update(String slug, PlayerDraft draft);

  Future<Result<void>> delete(String slug);

  /// Multipart field `photo`.
  Future<Result<void>> uploadPhoto(String slug, String filePath);

  Future<Result<void>> reorder(List<String> slugs);
}
