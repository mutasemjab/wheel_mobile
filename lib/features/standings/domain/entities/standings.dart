import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';
import '../../../players/domain/entities/player.dart';

final class StandingsTier extends Equatable {
  const StandingsTier({
    required this.tier,
    required this.title,
    this.labelEn,
    this.min,
    this.max,
    required this.range,
    this.players = const [],
  });

  final Tier tier;
  final String title;
  final String? labelEn;

  /// Rating bounds from the server config — never hard-coded.
  final int? min;
  final int? max;
  final String range;
  final List<Player> players;

  @override
  List<Object?> get props => [tier, title, labelEn, min, max, range, players];
}

enum StandingsSort { rating, goals, assists, matches }

/// `GET /standings`, tiers in A → C order.
final class Standings extends Equatable {
  const Standings({this.tiers = const []});

  final List<StandingsTier> tiers;

  List<Player> get allPlayers => [for (final t in tiers) ...t.players];

  /// All players sorted by [sort] (descending), rating as tie-breaker.
  List<Player> sorted(StandingsSort sort) {
    int key(Player p) => switch (sort) {
      StandingsSort.rating => p.rating,
      StandingsSort.goals => p.stats.g,
      StandingsSort.assists => p.stats.a,
      StandingsSort.matches => p.stats.mp,
    };
    return [...allPlayers]..sort((a, b) {
      final byKey = key(b).compareTo(key(a));
      return byKey != 0 ? byKey : b.ratingExact.compareTo(a.ratingExact);
    });
  }

  @override
  List<Object?> get props => [tiers];
}
