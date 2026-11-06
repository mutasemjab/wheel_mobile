import '../../../../core/entities/enums.dart';
import '../../../../core/models/clock_snapshot_model.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/live_match_state.dart';
import '../../domain/entities/server_live_match.dart';

/// Parses `GET /admin/live` and `PUT /admin/live/sync` data.
class ServerLiveMatchModel {
  const ServerLiveMatchModel(this.json);

  final Json json;

  ServerLiveMatch toEntity() {
    // Events arrive newest first; order by `sort`, or reverse when absent.
    final raw = asMapList(json['events']);
    final events = raw.every((e) => e.containsKey('sort'))
        ? ([...raw]
            ..sort((a, b) => asInt(a['sort']).compareTo(asInt(b['sort']))))
        : raw.reversed.toList();
    return ServerLiveMatch(
      code: asString(json['code']),
      date: parseMatchDateOrNull(json['date']) ?? DateUtilsX.todayInAmman(),
      opponent: asString(json['opponent']),
      squad: [
        for (final s in asMapList(json['squad']))
          if (asNonEmptyStringOrNull(s['slug']) != null)
            SquadEntry(
              slug: asString(s['slug']),
              name: asString(s['name']),
              status: asString(s['status']) == 'excused'
                  ? SquadStatus.excused
                  : SquadStatus.played,
              unfair: asBool(s['unfair']),
              late: asBool(s['late']),
              valuesCount: asInt(s['values_count']),
            ),
      ],
      events: [
        for (final e in events)
          if (LiveEventType.tryParse(asStringOrNull(e['type']))
              case final type?)
            LiveEvent(
              uuid: asString(e['uuid']),
              type: type,
              player: asNonEmptyStringOrNull(e['player']),
              assist: asNonEmptyStringOrNull(e['assist']),
              minute: asIntOrNull(e['minute']),
            ),
      ],
      clock: ClockSnapshotModel.fromJson(json['clock']).toEntity(),
      motm: asNonEmptyStringOrNull(json['motm']),
    );
  }
}

class LiveFinishResultModel {
  const LiveFinishResultModel(this.json);

  final Json json;

  LiveFinishResult toEntity() {
    final score = asMap(json['score']);
    return LiveFinishResult(
      scoreUs: asInt(score['us']),
      scoreThem: asInt(score['them']),
      summary: asString(json['summary']),
      motm: asNonEmptyStringOrNull(json['motm']),
    );
  }
}
