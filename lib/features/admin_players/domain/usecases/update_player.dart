import '../../../../core/result/result.dart';
import '../entities/admin_player.dart';
import '../repositories/admin_players_repository.dart';

class UpdatePlayer {
  const UpdatePlayer(this._repository);

  final AdminPlayersRepository _repository;

  Future<Result<void>> call(String slug, PlayerDraft draft) =>
      _repository.update(slug, draft);
}
