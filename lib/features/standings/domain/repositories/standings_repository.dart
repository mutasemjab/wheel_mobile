import '../../../../core/result/result.dart';
import '../entities/standings.dart';

abstract interface class StandingsRepository {
  Future<Result<Standings>> getStandings({bool fromCache = false});
}
