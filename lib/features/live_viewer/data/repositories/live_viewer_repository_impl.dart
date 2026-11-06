import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/live_match.dart';
import '../../domain/repositories/live_viewer_repository.dart';
import '../datasources/live_viewer_remote_data_source.dart';

class LiveViewerRepositoryImpl implements LiveViewerRepository {
  LiveViewerRepositoryImpl(this._remote);

  final LiveViewerRemoteDataSource _remote;

  @override
  Future<Result<LiveMatch?>> getLive() =>
      guard(() async => (await _remote.getLive())?.toEntity());
}
