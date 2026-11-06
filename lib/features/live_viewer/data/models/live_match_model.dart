import '../../../../core/entities/enums.dart';
import '../../../../core/models/clock_snapshot_model.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/live_match.dart';

class LiveFeedEventModel {
  const LiveFeedEventModel(this.json);

  final Json json;

  LiveFeedEvent? toEntity() {
    final type = LiveEventType.tryParse(asStringOrNull(json['type']));
    if (type == null) return null;
    return LiveFeedEvent(
      uuid: asString(json['uuid']),
      type: type,
      player: asNonEmptyStringOrNull(json['player']),
      assist: asNonEmptyStringOrNull(json['assist']),
      minute: asIntOrNull(json['minute']),
    );
  }
}

class LiveMatchModel {
  const LiveMatchModel({
    required this.code,
    this.date,
    required this.opponent,
    required this.scoreUs,
    required this.scoreThem,
    required this.clock,
    required this.events,
    required this.playerStats,
    this.motm,
    this.updatedAt,
  });

  factory LiveMatchModel.fromJson(Json json) {
    final score = asMap(json['score']);
    return LiveMatchModel(
      code: asString(json['code']),
      date: parseMatchDateOrNull(json['date']),
      opponent: asString(json['opponent']),
      scoreUs: asInt(score['us']),
      scoreThem: asInt(score['them']),
      clock: ClockSnapshotModel.fromJson(json['clock']),
      events: asMapList(json['events']).map(LiveFeedEventModel.new).toList(),
      // `player_stats` may arrive as `[]` when empty.
      playerStats: {
        for (final entry in asMap(json['player_stats']).entries)
          if (entry.key.isNotEmpty) entry.key: _stat(asMap(entry.value)),
      },
      motm: asNonEmptyStringOrNull(json['motm']),
      updatedAt: asNonEmptyStringOrNull(json['updated_at']),
    );
  }

  static LivePlayerStat _stat(Json json) => LivePlayerStat(
    g: asInt(json['g']),
    a: asInt(json['a']),
    t: asInt(json['t']),
    s: asInt(json['s']),
  );

  final String code;
  final DateTime? date;
  final String opponent;
  final int scoreUs;
  final int scoreThem;
  final ClockSnapshotModel clock;
  final List<LiveFeedEventModel> events;
  final Map<String, LivePlayerStat> playerStats;
  final String? motm;
  final String? updatedAt;

  LiveMatch toEntity() => LiveMatch(
    code: code,
    date: date,
    opponent: opponent,
    scoreUs: scoreUs,
    scoreThem: scoreThem,
    clock: clock.toEntity(),
    events: events.map((e) => e.toEntity()).whereType<LiveFeedEvent>().toList(),
    playerStats: playerStats,
    motm: motm,
    updatedAt: updatedAt,
  );
}
