import '../../../../core/result/result.dart';
import '../entities/live_match.dart';

abstract interface class LiveViewerRepository {
  /// `null` when no match is live.
  Future<Result<LiveMatch?>> getLive();
}
