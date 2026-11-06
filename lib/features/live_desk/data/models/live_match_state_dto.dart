import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/enums.dart';
import '../../domain/entities/live_match_state.dart';

part 'live_match_state_dto.g.dart';

/// Local persistence shape of [LiveMatchState] (SharedPreferences JSON).
@JsonSerializable(explicitToJson: true)
class LiveMatchStateDto {
  const LiveMatchStateDto({
    required this.code,
    required this.opponent,
    required this.date,
    this.played = const [],
    this.excused = const [],
    this.unfair = const [],
    this.late = const [],
    this.values = const {},
    this.motm,
    this.accMs = 0,
    this.runAtMs,
    this.events = const [],
    this.syncStatus = SyncStatus.pending,
    this.lastSyncedAt,
    this.serverCreated = false,
    this.finished = false,
    this.summary,
  });

  factory LiveMatchStateDto.fromJson(Map<String, dynamic> json) =>
      _$LiveMatchStateDtoFromJson(json);

  factory LiveMatchStateDto.fromEntity(LiveMatchState s) => LiveMatchStateDto(
    code: s.code,
    opponent: s.opponent,
    date: s.date,
    played: s.played,
    excused: s.excused,
    unfair: s.unfair.toList(),
    late: s.late.toList(),
    values: s.values,
    motm: s.motm,
    accMs: s.clock.accMs,
    runAtMs: s.clock.runAtMs,
    events: s.events.map(LiveEventDto.fromEntity).toList(),
    syncStatus: s.syncStatus,
    lastSyncedAt: s.lastSyncedAt,
    serverCreated: s.serverCreated,
    finished: s.finished,
    summary: s.summary,
  );

  final String code;
  final String opponent;
  final DateTime date;
  final List<String> played;
  final List<String> excused;
  final List<String> unfair;
  final List<String> late;
  final Map<String, int> values;
  final String? motm;
  final int accMs;
  final int? runAtMs;
  final List<LiveEventDto> events;
  final SyncStatus syncStatus;
  final DateTime? lastSyncedAt;
  final bool serverCreated;
  final bool finished;
  final String? summary;

  Map<String, dynamic> toJson() => _$LiveMatchStateDtoToJson(this);

  LiveMatchState toEntity() => LiveMatchState(
    code: code,
    opponent: opponent,
    date: DateTime(date.year, date.month, date.day),
    played: played,
    excused: excused,
    unfair: unfair.toSet(),
    late: late.toSet(),
    values: values,
    motm: motm,
    clock: LiveClock(accMs: accMs, runAtMs: runAtMs),
    events: events.map((e) => e.toEntity()).toList(),
    syncStatus: syncStatus,
    lastSyncedAt: lastSyncedAt,
    serverCreated: serverCreated,
    finished: finished,
    summary: summary,
  );
}

@JsonSerializable()
class LiveEventDto {
  const LiveEventDto({
    required this.uuid,
    required this.type,
    this.player,
    this.assist,
    this.minute,
  });

  factory LiveEventDto.fromJson(Map<String, dynamic> json) =>
      _$LiveEventDtoFromJson(json);

  factory LiveEventDto.fromEntity(LiveEvent e) => LiveEventDto(
    uuid: e.uuid,
    type: e.type,
    player: e.player,
    assist: e.assist,
    minute: e.minute,
  );

  final String uuid;
  final LiveEventType type;
  final String? player;
  final String? assist;
  final int? minute;

  Map<String, dynamic> toJson() => _$LiveEventDtoToJson(this);

  LiveEvent toEntity() => LiveEvent(
    uuid: uuid,
    type: type,
    player: player,
    assist: assist,
    minute: minute,
  );
}
