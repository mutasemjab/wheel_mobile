import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/entities/insight.dart';

final class TeamInfo extends Equatable {
  const TeamInfo({
    required this.name,
    this.slogan,
    this.crestUrl,
    this.groupPhotoUrl,
    this.publicSiteUrl,
  });

  final String name;
  final String? slogan;
  final String? crestUrl;
  final String? groupPhotoUrl;
  final String? publicSiteUrl;

  @override
  List<Object?> get props => [
    name,
    slogan,
    crestUrl,
    groupPhotoUrl,
    publicSiteUrl,
  ];
}

final class TeamRecord extends Equatable {
  const TeamRecord({
    this.mp = 0,
    this.w = 0,
    this.d = 0,
    this.l = 0,
    this.gf = 0,
    this.ga = 0,
    this.cs = 0,
  });

  final int mp, w, d, l, gf, ga, cs;

  @override
  List<Object?> get props => [mp, w, d, l, gf, ga, cs];
}

/// `GET /team`.
final class TeamOverview extends Equatable {
  const TeamOverview({
    required this.info,
    required this.record,
    this.winPct = 0,
    this.gfPerMatch = 0,
    this.gaPerMatch = 0,
    this.last5 = const [],
    this.insights = const [],
  });

  final TeamInfo info;
  final TeamRecord record;
  final double winPct;
  final double gfPerMatch;
  final double gaPerMatch;

  /// Oldest → newest.
  final List<MatchResult> last5;
  final List<Insight> insights;

  @override
  List<Object?> get props => [
    info,
    record,
    winPct,
    gfPerMatch,
    gaPerMatch,
    last5,
    insights,
  ];
}
