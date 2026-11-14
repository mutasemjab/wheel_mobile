import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';
import '../../../awards/domain/entities/award.dart';
import '../../../fixtures/domain/entities/fixture.dart';
import '../../../news/domain/entities/post.dart';
import '../../../team/domain/entities/team.dart';

/// Player card inside a home tier section (`/home` includes photo and number).
final class TierPlayer extends Equatable {
  const TierPlayer({
    required this.slug,
    required this.name,
    required this.rating,
    required this.ratingExact,
    required this.rank,
    this.trend = 0,
    this.moved = Movement.none,
    this.photoUrl,
    this.number,
    this.isGoalkeeper = false,
    this.tierNow,
    this.tierPrev,
  });

  final String slug;
  final String name;
  final int rating;
  final double ratingExact;
  final int rank;
  final double trend;
  final Movement moved;
  final String? photoUrl;
  final int? number;
  final bool isGoalkeeper;
  final Tier? tierNow;
  final Tier? tierPrev;

  @override
  List<Object?> get props => [
    slug,
    name,
    rating,
    ratingExact,
    rank,
    trend,
    moved,
    photoUrl,
    number,
    isGoalkeeper,
    tierNow,
    tierPrev,
  ];
}

final class TierGroup extends Equatable {
  const TierGroup({
    required this.tier,
    required this.title,
    this.labelEn,
    this.min,
    this.max,
    required this.range,
    this.players = const [],
  });

  final Tier tier;
  final String title;
  final String? labelEn;

  /// Rating bounds from the server config — never hard-coded.
  final int? min;
  final int? max;
  final String range;
  final List<TierPlayer> players;

  @override
  List<Object?> get props => [tier, title, labelEn, min, max, range, players];
}

final class LiveBanner extends Equatable {
  const LiveBanner({
    required this.code,
    required this.opponent,
    this.scoreUs = 0,
    this.scoreThem = 0,
    this.updatedAt,
  });

  final String code;
  final String opponent;
  final int scoreUs;
  final int scoreThem;
  final String? updatedAt;

  @override
  List<Object?> get props => [code, opponent, scoreUs, scoreThem, updatedAt];
}

/// `GET /home`.
final class HomeData extends Equatable {
  const HomeData({
    required this.team,
    this.updated,
    this.tiers = const [],
    this.record = const TeamRecord(),
    this.awards = const [],
    this.live,
    this.nextFixture,
    this.latestPosts = const [],
    this.version = 0,
  });

  final TeamInfo team;
  final DateTime? updated;
  final List<TierGroup> tiers;
  final TeamRecord record;
  final List<Award> awards;
  final LiveBanner? live;
  final Fixture? nextFixture;
  final List<PostSummary> latestPosts;
  final int version;

  @override
  List<Object?> get props => [
    team,
    updated,
    tiers,
    record,
    awards,
    live,
    nextFixture,
    latestPosts,
    version,
  ];
}
