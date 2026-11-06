import 'package:equatable/equatable.dart';

import '../../../../core/entities/clock_snapshot.dart';
import '../../../../core/entities/enums.dart';

final class LiveFeedEvent extends Equatable {
  const LiveFeedEvent({
    required this.uuid,
    required this.type,
    this.player,
    this.assist,
    this.minute,
  });

  final String uuid;
  final LiveEventType type;
  final String? player;
  final String? assist;
  final int? minute;

  @override
  List<Object?> get props => [uuid, type, player, assist, minute];
}

final class LivePlayerStat extends Equatable {
  const LivePlayerStat({this.g = 0, this.a = 0, this.t = 0, this.s = 0});

  final int g, a, t, s;

  @override
  List<Object?> get props => [g, a, t, s];
}

/// `GET /live` → `data` (public live match).
final class LiveMatch extends Equatable {
  const LiveMatch({
    required this.code,
    this.date,
    required this.opponent,
    this.scoreUs = 0,
    this.scoreThem = 0,
    this.clock = const ClockSnapshot(),
    this.events = const [],
    this.playerStats = const {},
    this.motm,
    this.updatedAt,
  });

  final String code;
  final DateTime? date;
  final String opponent;
  final int scoreUs;
  final int scoreThem;
  final ClockSnapshot clock;

  /// Newest first.
  final List<LiveFeedEvent> events;
  final Map<String, LivePlayerStat> playerStats;
  final String? motm;
  final String? updatedAt;

  @override
  List<Object?> get props => [
    code,
    date,
    opponent,
    scoreUs,
    scoreThem,
    clock,
    events,
    playerStats,
    motm,
    updatedAt,
  ];
}
