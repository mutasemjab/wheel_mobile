import '../../../../core/result/result.dart';
import '../entities/admin_player.dart';
import '../repositories/admin_players_repository.dart';

class GetAdminPlayers {
  const GetAdminPlayers(this._repository);

  final AdminPlayersRepository _repository;

  Future<Result<List<AdminPlayer>>> call() => _repository.getPlayers();
}
