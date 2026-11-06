// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_match_state_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveMatchStateDto _$LiveMatchStateDtoFromJson(
  Map<String, dynamic> json,
) => LiveMatchStateDto(
  code: json['code'] as String,
  opponent: json['opponent'] as String,
  date: DateTime.parse(json['date'] as String),
  played:
      (json['played'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  excused:
      (json['excused'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  unfair:
      (json['unfair'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  late:
      (json['late'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  values:
      (json['values'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  motm: json['motm'] as String?,
  accMs: (json['accMs'] as num?)?.toInt() ?? 0,
  runAtMs: (json['runAtMs'] as num?)?.toInt(),
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => LiveEventDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  syncStatus:
      $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
      SyncStatus.pending,
  lastSyncedAt: json['lastSyncedAt'] == null
      ? null
      : DateTime.parse(json['lastSyncedAt'] as String),
  serverCreated: json['serverCreated'] as bool? ?? false,
  finished: json['finished'] as bool? ?? false,
  summary: json['summary'] as String?,
);

Map<String, dynamic> _$LiveMatchStateDtoToJson(LiveMatchStateDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'opponent': instance.opponent,
      'date': instance.date.toIso8601String(),
      'played': instance.played,
      'excused': instance.excused,
      'unfair': instance.unfair,
      'late': instance.late,
      'values': instance.values,
      'motm': instance.motm,
      'accMs': instance.accMs,
      'runAtMs': instance.runAtMs,
      'events': instance.events.map((e) => e.toJson()).toList(),
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'serverCreated': instance.serverCreated,
      'finished': instance.finished,
      'summary': instance.summary,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pending: 'pending',
  SyncStatus.offline: 'offline',
  SyncStatus.error: 'error',
};

LiveEventDto _$LiveEventDtoFromJson(Map<String, dynamic> json) => LiveEventDto(
  uuid: json['uuid'] as String,
  type: $enumDecode(_$LiveEventTypeEnumMap, json['type']),
  player: json['player'] as String?,
  assist: json['assist'] as String?,
  minute: (json['minute'] as num?)?.toInt(),
);

Map<String, dynamic> _$LiveEventDtoToJson(LiveEventDto instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'type': _$LiveEventTypeEnumMap[instance.type]!,
      'player': instance.player,
      'assist': instance.assist,
      'minute': instance.minute,
    };

const _$LiveEventTypeEnumMap = {
  LiveEventType.goal: 'goal',
  LiveEventType.og: 'og',
  LiveEventType.against: 'against',
  LiveEventType.save: 'save',
  LiveEventType.tackle: 'tackle',
};
