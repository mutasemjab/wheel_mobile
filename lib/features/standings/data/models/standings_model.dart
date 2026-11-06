import '../../../../core/entities/enums.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../../players/data/models/player_model.dart';
import '../../domain/entities/standings.dart';

class StandingsTierModel {
  const StandingsTierModel({
    required this.tier,
    required this.title,
    this.labelEn,
    this.min,
    this.max,
    required this.range,
    required this.players,
  });

  factory StandingsTierModel.fromJson(Tier tier, Json json) =>
      StandingsTierModel(
        tier: tier,
        title: asString(json['title'], fallback: tier.code),
        labelEn: asNonEmptyStringOrNull(json['label_en']),
        min: asIntOrNull(json['min']),
        max: asIntOrNull(json['max']),
        range: asString(json['range']),
        players: asMapList(json['players']).map(PlayerModel.fromJson).toList(),
      );

  final Tier tier;
  final String title;
  final String? labelEn;
  final int? min;
  final int? max;
  final String range;
  final List<PlayerModel> players;

  StandingsTier toEntity() => StandingsTier(
    tier: tier,
    title: title,
    labelEn: labelEn,
    min: min,
    max: max,
    range: range,
    players: players.map((p) => p.toEntity()).toList(growable: false),
  );
}

class StandingsModel {
  const StandingsModel(this.tiers);

  factory StandingsModel.fromJson(Json json) => StandingsModel([
    for (final tier in Tier.values)
      if (json[tier.code] is Map)
        StandingsTierModel.fromJson(tier, asMap(json[tier.code])),
  ]);

  final List<StandingsTierModel> tiers;

  Standings toEntity() =>
      Standings(tiers: tiers.map((t) => t.toEntity()).toList(growable: false));
}
