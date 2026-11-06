import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remote);

  final HomeRemoteDataSource _remote;

  @override
  Future<Result<HomeData>> getHome({bool fromCache = false}) => guard(
    () async => (await _remote.getHome(fromCache: fromCache)).toEntity(),
  );
}
