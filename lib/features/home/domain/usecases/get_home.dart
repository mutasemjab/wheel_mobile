import '../../../../core/result/result.dart';
import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

/// `/home` already carries photos and numbers for every tier player.
class GetHome {
  const GetHome(this._repository);

  final HomeRepository _repository;

  Future<Result<HomeData>> call({bool fromCache = false}) =>
      _repository.getHome(fromCache: fromCache);
}
