import '../../../../core/bloc/data_cubit.dart';
import '../../../../core/result/result.dart';
import '../../../players/domain/entities/player.dart';
import '../../../players/domain/usecases/get_players.dart';

/// Player list for the comparison screen (same data as `GET /players`).
class CompareCubit extends DataCubit<List<Player>> {
  CompareCubit(this._getPlayers, {super.refreshTrigger});

  final GetPlayers _getPlayers;

  @override
  Future<Result<List<Player>>> fetch({required bool fromCache}) =>
      _getPlayers(fromCache: fromCache);
}

/// One comparison row: a label and both players' values.
final class CompareRow {
  const CompareRow(this.label, this.left, this.right, {this.decimals = 0});

  final String label;
  final double left;
  final double right;
  final int decimals;

  /// Share of the larger value for the bar widths (0..1 each).
  (double, double) get shares {
    final max = left > right ? left : right;
    if (max <= 0) return (0, 0);
    return (left / max, right / max);
  }
}

/// Builds the rows shown for two players. Pure so it can be unit-tested.
List<CompareRow> compareRows(
  Player a,
  Player b, {
  required String rating,
  required String matches,
  required String goals,
  required String assists,
  required String goalsAssists,
  required String goalsPerMatch,
  required String saves,
  required String tackles,
  required String motm,
  required String wins,
}) {
  double perMatch(Player p) => p.stats.mp == 0 ? 0 : p.stats.g / p.stats.mp;
  return [
    CompareRow(rating, a.ratingExact, b.ratingExact, decimals: 1),
    CompareRow(matches, a.stats.mp.toDouble(), b.stats.mp.toDouble()),
    CompareRow(goals, a.stats.g.toDouble(), b.stats.g.toDouble()),
    CompareRow(assists, a.stats.a.toDouble(), b.stats.a.toDouble()),
    CompareRow(
      goalsAssists,
      (a.stats.g + a.stats.a).toDouble(),
      (b.stats.g + b.stats.a).toDouble(),
    ),
    CompareRow(goalsPerMatch, perMatch(a), perMatch(b), decimals: 2),
    CompareRow(saves, a.stats.s.toDouble(), b.stats.s.toDouble()),
    CompareRow(tackles, a.stats.t.toDouble(), b.stats.t.toDouble()),
    CompareRow(motm, a.stats.motm.toDouble(), b.stats.motm.toDouble()),
    CompareRow(wins, a.stats.w.toDouble(), b.stats.w.toDouble()),
  ];
}
