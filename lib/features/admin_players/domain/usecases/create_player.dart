import '../../../../core/result/result.dart';
import '../entities/admin_player.dart';
import '../repositories/admin_players_repository.dart';

class CreatePlayer {
  const CreatePlayer(this._repository);

  final AdminPlayersRepository _repository;

  Future<Result<void>> call(PlayerDraft draft) => _repository.create(draft);
}
