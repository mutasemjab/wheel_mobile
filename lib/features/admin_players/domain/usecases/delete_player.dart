import '../../../../core/result/result.dart';
import '../repositories/admin_players_repository.dart';

class DeletePlayer {
  const DeletePlayer(this._repository);

  final AdminPlayersRepository _repository;

  Future<Result<void>> call(String slug) => _repository.delete(slug);
}
