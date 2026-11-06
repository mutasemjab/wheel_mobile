import '../../../../core/entities/enums.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../../live_desk/domain/entities/live_match_rules.dart';
import '../../../live_desk/domain/entities/live_match_state.dart';
import '../../domain/entities/editable_match.dart';

/// Editor shape of `GET` / `PUT /admin/matches/{code}`.
class EditableMatchModel {
  const EditableMatchModel(this.json);

  final Json json;

  EditableMatch toEntity() => EditableMatch(
    match: LiveMatchState(
      code: asString(json['code']),
      opponent: asString(json['opponent']),
      date: parseMatchDateOrNull(json['date']) ?? DateTime.now(),
      played: asStringList(json['played']),
      excused: asStringList(json['excused']),
      unfair: asStringList(json['unfair']).toSet(),
      late: asStringList(json['late']).toSet(),
      values: asIntMap(json['values']),
      motm: asNonEmptyStringOrNull(json['motm']),
      events: [
        for (final e in asMapList(json['events']))
          if (LiveEventType.tryParse(asStringOrNull(e['type'])) case final t?)
            LiveEvent(
              uuid: asString(e['uuid']),
              type: t,
              player: asNonEmptyStringOrNull(e['player']),
              assist: asNonEmptyStringOrNull(e['assist']),
              minute: asIntOrNull(e['minute']),
            ),
      ],
      syncStatus: SyncStatus.synced,
      serverCreated: true,
      finished: true,
    ).sanitized(),
    note: asString(json['note']),
    status: asNonEmptyStringOrNull(json['status']),
    publishedAt: asNonEmptyStringOrNull(json['published_at']),
  );
}
