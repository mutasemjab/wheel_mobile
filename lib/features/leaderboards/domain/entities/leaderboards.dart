import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';

enum BoardKind {
  goals('goals'),
  assists('assists'),
  ga('ga'),
  saves('saves'),
  tackles('tackles'),
  appearances('appearances');

  const BoardKind(this.apiKey);

  final String apiKey;
}

final class BoardEntry extends Equatable {
  const BoardEntry({
    required this.slug,
    required this.name,
    required this.value,
    required this.rank,
    this.tier,
  });

  final String slug;
  final String name;
  final double value;
  final int rank;
  final Tier? tier;

  @override
  List<Object?> get props => [slug, name, value, rank, tier];
}

final class TeamAverages extends Equatable {
  const TeamAverages({
    this.goalsPerMatch = 0,
    this.concededPerMatch = 0,
    this.appsPerPlayer = 0,
  });

  final double goalsPerMatch;
  final double concededPerMatch;
  final double appsPerPlayer;

  @override
  List<Object?> get props => [goalsPerMatch, concededPerMatch, appsPerPlayer];
}

final class GoalsChartPoint extends Equatable {
  const GoalsChartPoint({
    this.date,
    required this.opponent,
    required this.us,
    required this.them,
  });

  final DateTime? date;
  final String opponent;
  final int us;
  final int them;

  @override
  List<Object?> get props => [date, opponent, us, them];
}

/// `GET /leaderboards`.
final class Leaderboards extends Equatable {
  const Leaderboards({
    this.boards = const {},
    this.averages = const TeamAverages(),
    this.goalsChart = const [],
  });

  final Map<BoardKind, List<BoardEntry>> boards;
  final TeamAverages averages;
  final List<GoalsChartPoint> goalsChart;

  @override
  List<Object?> get props => [boards, averages, goalsChart];
}
