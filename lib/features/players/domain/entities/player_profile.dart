import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/entities/insight.dart';
import 'player.dart';

/// One row of the player's match log (`history`).
final class HistoryEntry extends Equatable {
  const HistoryEntry({
    required this.matchCode,
    this.date,
    required this.opponent,
    this.result,
    this.scoreUs = 0,
    this.scoreThem = 0,
    this.g = 0,
    this.a = 0,
    this.s = 0,
    this.t = 0,
    this.v = 0,
    this.c = 0,
    this.fair = false,
    this.star = false,
    this.late = false,
    this.excused = false,
    this.pts = 0,
    this.need = 0,
    this.before = 0,
    this.after = 0,
    this.delta = 0,
  });

  final String matchCode;
  final DateTime? date;
  final String opponent;
  final MatchResult? result;
  final int scoreUs, scoreThem;
  final int g, a, s, t, v, c;
  final bool fair, star, late, excused;
  final double pts, need, before, after, delta;

  @override
  List<Object?> get props => [
    matchCode,
    date,
    opponent,
    result,
    scoreUs,
    scoreThem,
    g,
    a,
    s,
    t,
    v,
    c,
    fair,
    star,
    late,
    excused,
    pts,
    need,
    before,
    after,
    delta,
  ];
}

final class ChartPoint extends Equatable {
  const ChartPoint({required this.label, required this.value});

  final String label;
  final double value;

  @override
  List<Object?> get props => [label, value];
}

/// `GET /players/{slug}`.
final class PlayerProfile extends Equatable {
  const PlayerProfile({
    required this.player,
    this.history = const [],
    this.ratingChart = const [],
    this.insights = const [],
    this.nextTarget,
    this.gapToNextTier,
  });

  final Player player;
  final List<HistoryEntry> history;
  final List<ChartPoint> ratingChart;
  final List<Insight> insights;
  final double? nextTarget;
  final double? gapToNextTier;

  @override
  List<Object?> get props => [
    player,
    history,
    ratingChart,
    insights,
    nextTarget,
    gapToNextTier,
  ];
}
