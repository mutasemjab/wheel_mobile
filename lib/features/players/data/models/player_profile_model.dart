import '../../../../core/entities/enums.dart';
import '../../../../core/models/insight_model.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/player_profile.dart';
import 'player_model.dart';

class HistoryEntryModel {
  const HistoryEntryModel(this.json);

  factory HistoryEntryModel.fromJson(Json json) => HistoryEntryModel(json);

  final Json json;

  HistoryEntry toEntity() {
    final score = asList(json['score']);
    return HistoryEntry(
      matchCode: asString(json['match_code']),
      date: parseMatchDateOrNull(json['date']),
      opponent: asString(json['opponent']),
      result: MatchResult.tryParse(asStringOrNull(json['res'])),
      scoreUs: score.isNotEmpty ? asInt(score[0]) : 0,
      scoreThem: score.length > 1 ? asInt(score[1]) : 0,
      g: asInt(json['g']),
      a: asInt(json['a']),
      s: asInt(json['s']),
      t: asInt(json['t']),
      v: asInt(json['v']),
      c: asInt(json['c']),
      fair: asBool(json['fair']),
      star: asBool(json['star']),
      late: asBool(json['late']),
      excused: asBool(json['excused']),
      pts: asDouble(json['pts']),
      need: asDouble(json['need']),
      before: asDouble(json['before']),
      after: asDouble(json['after']),
      delta: asDouble(json['delta']),
    );
  }
}

class ChartPointModel {
  const ChartPointModel({required this.label, required this.value});

  factory ChartPointModel.fromJson(Json json) => ChartPointModel(
    label: asString(json['label']),
    value: asDouble(json['value']),
  );

  final String label;
  final double value;

  ChartPoint toEntity() => ChartPoint(label: label, value: value);
}

/// `GET /players/{slug}` → `data`.
class PlayerProfileModel {
  const PlayerProfileModel({
    required this.player,
    required this.history,
    required this.ratingChart,
    required this.insights,
    this.nextTarget,
    this.gapToNextTier,
  });

  factory PlayerProfileModel.fromJson(Json json) => PlayerProfileModel(
    player: PlayerModel.fromJson(json),
    history: asMapList(
      json['history'],
    ).map(HistoryEntryModel.fromJson).toList(),
    ratingChart: asMapList(
      json['rating_chart'],
    ).map(ChartPointModel.fromJson).toList(),
    insights: InsightModel.listFromJson(json['insights']),
    nextTarget: asDoubleOrNull(json['next_target']),
    gapToNextTier: asDoubleOrNull(json['gap_to_next_tier']),
  );

  final PlayerModel player;
  final List<HistoryEntryModel> history;
  final List<ChartPointModel> ratingChart;
  final List<InsightModel> insights;
  final double? nextTarget;
  final double? gapToNextTier;

  PlayerProfile toEntity() => PlayerProfile(
    player: player.toEntity(),
    history: history.map((h) => h.toEntity()).toList(growable: false),
    ratingChart: ratingChart.map((c) => c.toEntity()).toList(growable: false),
    insights: insights.map((i) => i.toEntity()).toList(growable: false),
    nextTarget: nextTarget,
    gapToNextTier: gapToNextTier,
  );
}
