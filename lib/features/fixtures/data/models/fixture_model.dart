import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/fixture.dart';

abstract final class FixtureModel {
  static Fixture fromJson(dynamic json) {
    final m = asMap(json);
    return Fixture(
      id: asInt(m['id']),
      opponent: asString(m['opponent']),
      kickoffAt:
          parseDateTimeOrNull(m['kickoff_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      date: asString(m['date']),
      time: asString(m['time']),
      status: FixtureStatus.parse(asStringOrNull(m['status'])),
      statusLabel: asString(m['status_label']),
      competition: asNonEmptyStringOrNull(m['competition']),
      location: asNonEmptyStringOrNull(m['location']),
      mapUrl: asNonEmptyStringOrNull(m['map_url']),
      notes: asNonEmptyStringOrNull(m['notes']),
      isUpcoming: asBool(m['is_upcoming']),
    );
  }

  static Fixture? fromJsonOrNull(dynamic json) =>
      asMapOrNull(json) == null ? null : fromJson(json);

  static FixturesData dataFromJson(dynamic json) {
    final m = asMap(json);
    return FixturesData(
      upcoming: asMapList(m['upcoming']).map(fromJson).toList(growable: false),
      recent: asMapList(m['recent']).map(fromJson).toList(growable: false),
    );
  }
}
