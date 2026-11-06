import '../../../../core/result/result.dart';
import '../entities/match.dart';

abstract interface class MatchesRepository {
  Future<Result<MatchesPage>> getMatches({
    int page = 1,
    bool fromCache = false,
  });

  Future<Result<FootballMatch>> getMatch(String code, {bool fromCache = false});
}
