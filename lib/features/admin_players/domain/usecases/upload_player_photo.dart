import '../../../../core/result/result.dart';
import '../repositories/admin_players_repository.dart';

class UploadPlayerPhoto {
  const UploadPlayerPhoto(this._repository);

  final AdminPlayersRepository _repository;

  Future<Result<void>> call(String slug, String filePath) =>
      _repository.uploadPhoto(slug, filePath);
}
