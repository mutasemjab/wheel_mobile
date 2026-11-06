import '../../../../core/entities/enums.dart';
import '../../../../core/models/insight_model.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/team.dart';

class TeamInfoModel {
  const TeamInfoModel({
    required this.name,
    this.slogan,
    this.crestUrl,
    this.groupPhotoUrl,
    this.publicSiteUrl,
  });

  factory TeamInfoModel.fromJson(dynamic json) {
    final map = asMap(json);
    return TeamInfoModel(
      name: asString(map['name']),
      slogan: asNonEmptyStringOrNull(map['slogan']),
      crestUrl: asNonEmptyStringOrNull(map['crest_url']),
      groupPhotoUrl: asNonEmptyStringOrNull(map['group_photo_url']),
      publicSiteUrl: asNonEmptyStringOrNull(map['public_site_url']),
    );
  }

  final String name;
  final String? slogan;
  final String? crestUrl;
  final String? groupPhotoUrl;
  final String? publicSiteUrl;

  /// `crest_url` / `group_photo_url` are absolute URLs from the server.
  TeamInfo toEntity() => TeamInfo(
    name: name,
    slogan: slogan,
    crestUrl: crestUrl,
    groupPhotoUrl: groupPhotoUrl,
    publicSiteUrl: publicSiteUrl,
  );
}

class TeamRecordModel {
  const TeamRecordModel(this.values);

  factory TeamRecordModel.fromJson(dynamic json) =>
      TeamRecordModel(asIntMap(json));

  final Map<String, int> values;

  TeamRecord toEntity() => TeamRecord(
    mp: values['mp'] ?? 0,
    w: values['w'] ?? 0,
    d: values['d'] ?? 0,
    l: values['l'] ?? 0,
    gf: values['gf'] ?? 0,
    ga: values['ga'] ?? 0,
    cs: values['cs'] ?? 0,
  );
}

class TeamOverviewModel {
  const TeamOverviewModel({
    required this.info,
    required this.record,
    required this.winPct,
    required this.gfPerMatch,
    required this.gaPerMatch,
    required this.last5,
    required this.insights,
  });

  factory TeamOverviewModel.fromJson(Json json) => TeamOverviewModel(
    info: TeamInfoModel.fromJson(json['info']),
    record: TeamRecordModel.fromJson(json['record']),
    winPct: asDouble(json['win_pct']),
    gfPerMatch: asDouble(json['gf_per_match']),
    gaPerMatch: asDouble(json['ga_per_match']),
    last5: asStringList(json['last5']),
    insights: InsightModel.listFromJson(json['insights']),
  );

  final TeamInfoModel info;
  final TeamRecordModel record;
  final double winPct;
  final double gfPerMatch;
  final double gaPerMatch;
  final List<String> last5;
  final List<InsightModel> insights;

  TeamOverview toEntity() => TeamOverview(
    info: info.toEntity(),
    record: record.toEntity(),
    winPct: winPct,
    gfPerMatch: gfPerMatch,
    gaPerMatch: gaPerMatch,
    last5: last5.map(MatchResult.tryParse).whereType<MatchResult>().toList(),
    insights: insights.map((i) => i.toEntity()).toList(growable: false),
  );
}
