import '../../../../core/result/result.dart';
import '../entities/player_profile.dart';
import '../repositories/players_repository.dart';

class GetPlayerProfile {
  const GetPlayerProfile(this._repository);

  final PlayersRepository _repository;

  Future<Result<PlayerProfile>> call(String slug, {bool fromCache = false}) =>
      _repository.getProfile(slug, fromCache: fromCache);
}
