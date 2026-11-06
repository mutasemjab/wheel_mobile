import '../../../../core/result/result.dart';
import '../repositories/admin_players_repository.dart';

class ReorderPlayers {
  const ReorderPlayers(this._repository);

  final AdminPlayersRepository _repository;

  Future<Result<void>> call(List<String> slugs) => _repository.reorder(slugs);
}
