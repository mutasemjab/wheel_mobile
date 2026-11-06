import '../../../../core/entities/enums.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/leaderboards.dart';

class BoardEntryModel {
  const BoardEntryModel({
    required this.slug,
    required this.name,
    required this.value,
    required this.rank,
    this.tier,
  });

  factory BoardEntryModel.fromJson(Json json) => BoardEntryModel(
    slug: asString(json['slug']),
    name: asString(json['name']),
    value: asDouble(json['value']),
    rank: asInt(json['rank']),
    tier: asNonEmptyStringOrNull(json['tier']),
  );

  final String slug;
  final String name;
  final double value;
  final int rank;
  final String? tier;

  BoardEntry toEntity() => BoardEntry(
    slug: slug,
    name: name,
    value: value,
    rank: rank,
    tier: Tier.tryParse(tier),
  );
}

class GoalsChartPointModel {
  const GoalsChartPointModel({
    this.date,
    required this.opponent,
    required this.us,
    required this.them,
  });

  factory GoalsChartPointModel.fromJson(Json json) => GoalsChartPointModel(
    date: parseMatchDateOrNull(json['date']),
    opponent: asString(json['opponent']),
    us: asInt(json['us']),
    them: asInt(json['them']),
  );

  final DateTime? date;
  final String opponent;
  final int us;
  final int them;

  GoalsChartPoint toEntity() =>
      GoalsChartPoint(date: date, opponent: opponent, us: us, them: them);
}

class LeaderboardsModel {
  const LeaderboardsModel({
    required this.boards,
    required this.averages,
    required this.goalsChart,
  });

  factory LeaderboardsModel.fromJson(Json json) {
    final boards = asMap(json['boards']);
    final averages = asMap(json['team_averages']);
    return LeaderboardsModel(
      boards: {
        for (final kind in BoardKind.values)
          kind: asMapList(
            boards[kind.apiKey],
          ).map(BoardEntryModel.fromJson).toList(),
      },
      averages: TeamAverages(
        goalsPerMatch: asDouble(averages['goals_per_match']),
        concededPerMatch: asDouble(averages['conceded_per_match']),
        appsPerPlayer: asDouble(averages['apps_per_player']),
      ),
      goalsChart: asMapList(
        json['goals_chart'],
      ).map(GoalsChartPointModel.fromJson).toList(),
    );
  }

  final Map<BoardKind, List<BoardEntryModel>> boards;
  final TeamAverages averages;
  final List<GoalsChartPointModel> goalsChart;

  Leaderboards toEntity() => Leaderboards(
    boards: boards.map(
      (k, v) => MapEntry(k, v.map((e) => e.toEntity()).toList(growable: false)),
    ),
    averages: averages,
    goalsChart: goalsChart.map((p) => p.toEntity()).toList(growable: false),
  );
}
