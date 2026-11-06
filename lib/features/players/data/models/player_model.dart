import '../../../../core/entities/enums.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/player.dart';

class PlayerStatsModel {
  const PlayerStatsModel(this.values);

  factory PlayerStatsModel.fromJson(dynamic json) =>
      PlayerStatsModel(asIntMap(json));

  final Map<String, int> values;

  int _v(String key) => values[key] ?? 0;

  PlayerStats toEntity() => PlayerStats(
    mp: _v('mp'),
    g: _v('g'),
    a: _v('a'),
    s: _v('s'),
    t: _v('t'),
    w: _v('w'),
    d: _v('d'),
    l: _v('l'),
    motm: _v('motm'),
    cs: _v('cs'),
    fp: _v('fp'),
    val: _v('val'),
    exc: _v('exc'),
    late: _v('late'),
    cg: _v('cg'),
  );
}

/// `GET /players` item (also the base of `/players/{slug}` and standings rows).
class PlayerModel {
  const PlayerModel({
    required this.slug,
    required this.name,
    this.nameEn,
    this.number,
    this.role,
    required this.isGoalkeeper,
    this.photoUrl,
    this.startTier,
    required this.rating,
    required this.ratingExact,
    required this.rank,
    this.tierNow,
    this.tierPrev,
    this.moved,
    required this.trend,
    required this.stats,
  });

  factory PlayerModel.fromJson(Json json) => PlayerModel(
    slug: asString(json['slug']),
    name: asString(json['name']),
    nameEn: asNonEmptyStringOrNull(json['name_en']),
    number: asIntOrNull(json['number']),
    role: asNonEmptyStringOrNull(json['role']),
    isGoalkeeper: asBool(json['is_goalkeeper']),
    photoUrl: asNonEmptyStringOrNull(json['photo_url']),
    startTier: asNonEmptyStringOrNull(json['start_tier']),
    rating: asInt(json['rating']),
    ratingExact: asDouble(
      json['rating_exact'],
      fallback: asDouble(json['rating']),
    ),
    rank: asInt(json['rank']),
    tierNow: asNonEmptyStringOrNull(json['tier_now']),
    tierPrev: asNonEmptyStringOrNull(json['tier_prev']),
    moved: asNonEmptyStringOrNull(json['moved']),
    trend: asDouble(json['trend']),
    stats: PlayerStatsModel.fromJson(json['stats']),
  );

  final String slug;
  final String name;
  final String? nameEn;
  final int? number;
  final String? role;
  final bool isGoalkeeper;
  final String? photoUrl;
  final String? startTier;
  final int rating;
  final double ratingExact;
  final int rank;
  final String? tierNow;
  final String? tierPrev;
  final String? moved;
  final double trend;
  final PlayerStatsModel stats;

  Player toEntity() => Player(
    slug: slug,
    name: name,
    nameEn: nameEn,
    number: number,
    role: role,
    isGoalkeeper: isGoalkeeper,
    photoUrl: photoUrl,
    startTier: Tier.tryParse(startTier),
    rating: rating,
    ratingExact: ratingExact,
    rank: rank,
    tierNow: Tier.tryParse(tierNow),
    tierPrev: Tier.tryParse(tierPrev),
    moved: Movement.parse(moved),
    trend: trend,
    stats: stats.toEntity(),
  );
}
