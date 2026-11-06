import '../../../../core/entities/enums.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../../awards/data/models/award_model.dart';
import '../../../team/data/models/team_model.dart';
import '../../domain/entities/home_data.dart';

class TierPlayerModel {
  const TierPlayerModel(this.json);

  final Json json;

  TierPlayer toEntity() => TierPlayer(
    slug: asString(json['slug']),
    name: asString(json['name']),
    rating: asInt(json['rating']),
    ratingExact: asDouble(
      json['rating_exact'],
      fallback: asDouble(json['rating']),
    ),
    rank: asInt(json['rank']),
    trend: asDouble(json['trend']),
    moved: Movement.parse(asNonEmptyStringOrNull(json['moved'])),
    photoUrl: asNonEmptyStringOrNull(json['photo_url']),
    number: asIntOrNull(json['number']),
    isGoalkeeper: asBool(json['is_goalkeeper']),
    tierNow: Tier.tryParse(asStringOrNull(json['tier_now'])),
    tierPrev: Tier.tryParse(asStringOrNull(json['tier_prev'])),
  );
}

class TierGroupModel {
  const TierGroupModel(this.tier, this.json);

  final Tier tier;
  final Json json;

  TierGroup toEntity() => TierGroup(
    tier: tier,
    title: asString(json['title'], fallback: tier.code),
    labelEn: asNonEmptyStringOrNull(json['label_en']),
    min: asIntOrNull(json['min']),
    max: asIntOrNull(json['max']),
    range: asString(json['range']),
    players: [
      for (final p in asMapList(json['players'])) TierPlayerModel(p).toEntity(),
    ],
  );
}

/// Parses `{ A: {...}, B: {...}, C: {...} }` in tier order.
List<TierGroupModel> tierGroupsFromJson(dynamic json) {
  final map = asMap(json);
  return [
    for (final tier in Tier.values)
      if (map[tier.code] is Map) TierGroupModel(tier, asMap(map[tier.code])),
  ];
}

class LiveBannerModel {
  const LiveBannerModel(this.json);

  final Json json;

  LiveBanner toEntity() {
    final score = asMap(json['score']);
    return LiveBanner(
      code: asString(json['code']),
      opponent: asString(json['opponent']),
      scoreUs: asInt(score['us']),
      scoreThem: asInt(score['them']),
      updatedAt: asNonEmptyStringOrNull(json['updated_at']),
    );
  }
}

class HomeModel {
  const HomeModel({
    required this.team,
    this.updated,
    required this.tiers,
    required this.record,
    required this.awards,
    this.live,
    required this.version,
  });

  factory HomeModel.fromJson(Json json) {
    final live = asMapOrNull(json['live']);
    return HomeModel(
      team: TeamInfoModel.fromJson(json['team']),
      updated: parseMatchDateOrNull(json['updated']),
      tiers: tierGroupsFromJson(json['tiers']),
      record: TeamRecordModel.fromJson(json['record']),
      awards: AwardModel.listFromJson(json['awards']),
      live: live == null || asNonEmptyStringOrNull(live['code']) == null
          ? null
          : LiveBannerModel(live),
      version: asInt(json['version']),
    );
  }

  final TeamInfoModel team;
  final DateTime? updated;
  final List<TierGroupModel> tiers;
  final TeamRecordModel record;
  final List<AwardModel> awards;
  final LiveBannerModel? live;
  final int version;

  HomeData toEntity() => HomeData(
    team: team.toEntity(),
    updated: updated,
    tiers: tiers.map((t) => t.toEntity()).toList(growable: false),
    record: record.toEntity(),
    awards: awards.map((a) => a.toEntity()).toList(growable: false),
    live: live?.toEntity(),
    version: version,
  );
}
