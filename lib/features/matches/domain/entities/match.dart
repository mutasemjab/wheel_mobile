import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';
import '../../../players/domain/entities/player.dart';

final class PlayerRef extends Equatable {
  const PlayerRef({required this.slug, required this.name});

  final String slug;
  final String name;

  @override
  List<Object?> get props => [slug, name];
}

final class MatchGoal extends Equatable {
  const MatchGoal({required this.by, this.assist, this.minute});

  final String by;
  final String? assist;
  final int? minute;

  @override
  List<Object?> get props => [by, assist, minute];
}

/// One row of `ratings` on the match detail (points and rating change).
final class MatchRating extends Equatable {
  const MatchRating({
    required this.slug,
    required this.name,
    this.pts = 0,
    this.need = 0,
    this.before = 0,
    this.after = 0,
    this.delta = 0,
    this.late = false,
    this.excused = false,
    this.star = false,
  });

  final String slug;
  final String name;
  final double pts, need, before, after, delta;
  final bool late, excused, star;

  @override
  List<Object?> get props => [
    slug,
    name,
    pts,
    need,
    before,
    after,
    delta,
    late,
    excused,
    star,
  ];
}

/// A finished match (`GET /matches` item / `GET /matches/{code}`).
final class FootballMatch extends Equatable {
  const FootballMatch({
    required this.code,
    this.date,
    required this.opponent,
    this.scoreUs = 0,
    this.scoreThem = 0,
    required this.result,
    this.played = const [],
    this.goals = const [],
    this.saves = const {},
    this.tackles = const {},
    this.og = 0,
    this.caused = const {},
    this.late = const [],
    this.excused = const [],
    this.unfair = const [],
    this.values = const {},
    this.motm,
    this.note,
    this.ratings = const [],
  });

  final String code;
  final DateTime? date;
  final String opponent;
  final int scoreUs;
  final int scoreThem;
  final MatchResult result;

  /// Empty means "everyone played" (legacy data).
  final List<PlayerRef> played;
  final List<MatchGoal> goals;
  final Map<String, int> saves;
  final Map<String, int> tackles;
  final int og;
  final Map<String, int> caused;
  final List<String> late;
  final List<String> excused;
  final List<String> unfair;
  final Map<String, int> values;
  final String? motm;
  final String? note;

  /// Only on `GET /matches/{code}`.
  final List<MatchRating> ratings;

  bool get everyonePlayed => played.isEmpty;

  @override
  List<Object?> get props => [
    code,
    date,
    opponent,
    scoreUs,
    scoreThem,
    result,
    played,
    goals,
    saves,
    tackles,
    og,
    caused,
    late,
    excused,
    unfair,
    values,
    motm,
    note,
    ratings,
  ];
}

final class MatchesPage extends Equatable {
  const MatchesPage({
    this.items = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  final List<FootballMatch> items;
  final int currentPage;
  final int lastPage;
  final int total;

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [items, currentPage, lastPage, total];
}

/// Match detail plus the players directory to resolve slugs.
final class MatchDetail extends Equatable {
  const MatchDetail({required this.match, this.players = const {}});

  final FootballMatch match;
  final Map<String, Player> players;

  String nameOf(String slug) {
    final fromPlayed = match.played.where((p) => p.slug == slug).firstOrNull;
    return players[slug]?.name ?? fromPlayed?.name ?? slug;
  }

  @override
  List<Object?> get props => [match, players];
}
