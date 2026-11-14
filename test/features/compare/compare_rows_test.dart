import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/features/compare/presentation/bloc/compare_cubit.dart';
import 'package:wheel_mobile/features/players/domain/entities/player.dart';

Player _player(String slug, PlayerStats stats, double rating) => Player(
  slug: slug,
  name: slug,
  rating: rating.round(),
  ratingExact: rating,
  rank: 1,
  stats: stats,
);

List<CompareRow> _rows(Player a, Player b) => compareRows(
  a,
  b,
  rating: 'rating',
  matches: 'mp',
  goals: 'g',
  assists: 'a',
  goalsAssists: 'ga',
  goalsPerMatch: 'gpm',
  saves: 's',
  tackles: 't',
  motm: 'motm',
  wins: 'w',
);

void main() {
  final hassan = _player(
    'hassan',
    const PlayerStats(mp: 4, g: 6, a: 2, w: 3, motm: 2),
    81.5,
  );
  final hazem = _player('hazem', const PlayerStats(mp: 2, s: 9, w: 1), 35.8);

  test('builds every comparison row with both values', () {
    final rows = {for (final r in _rows(hassan, hazem)) r.label: r};

    expect(rows.keys, [
      'rating',
      'mp',
      'g',
      'a',
      'ga',
      'gpm',
      's',
      't',
      'motm',
      'w',
    ]);
    expect(rows['ga']!.left, 8);
    expect(rows['gpm']!.left, 1.5);
    expect(rows['gpm']!.decimals, 2);
    expect(rows['s']!.right, 9);
  });

  test(
    'a player with no matches has 0 goals per match (no division by zero)',
    () {
      final rookie = _player('new', const PlayerStats(), 30);
      final gpm = _rows(rookie, hassan).firstWhere((r) => r.label == 'gpm');

      expect(gpm.left, 0);
    },
  );

  test('bar shares are relative to the larger value', () {
    expect(const CompareRow('x', 6, 3).shares, (1.0, 0.5));
    expect(const CompareRow('x', 0, 0).shares, (0.0, 0.0));
  });
}
