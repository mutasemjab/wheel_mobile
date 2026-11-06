import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';

/// Season totals (`stats`). Missing keys default to 0.
final class PlayerStats extends Equatable {
  const PlayerStats({
    this.mp = 0,
    this.g = 0,
    this.a = 0,
    this.s = 0,
    this.t = 0,
    this.w = 0,
    this.d = 0,
    this.l = 0,
    this.motm = 0,
    this.cs = 0,
    this.fp = 0,
    this.val = 0,
    this.exc = 0,
    this.late = 0,
    this.cg = 0,
  });

  final int mp, g, a, s, t, w, d, l, motm, cs, fp, val, exc, late, cg;

  @override
  List<Object?> get props => [
    mp,
    g,
    a,
    s,
    t,
    w,
    d,
    l,
    motm,
    cs,
    fp,
    val,
    exc,
    late,
    cg,
  ];
}

/// A player as listed by `GET /players`.
final class Player extends Equatable {
  const Player({
    required this.slug,
    required this.name,
    this.nameEn,
    this.number,
    this.role,
    this.isGoalkeeper = false,
    this.photoUrl,
    this.startTier,
    required this.rating,
    required this.ratingExact,
    required this.rank,
    this.tierNow,
    this.tierPrev,
    this.moved = Movement.none,
    this.trend = 0,
    this.stats = const PlayerStats(),
  });

  final String slug;
  final String name;
  final String? nameEn;
  final int? number;
  final String? role;
  final bool isGoalkeeper;
  final String? photoUrl;
  final Tier? startTier;
  final int rating;
  final double ratingExact;
  final int rank;
  final Tier? tierNow;
  final Tier? tierPrev;
  final Movement moved;
  final double trend;
  final PlayerStats stats;

  @override
  List<Object?> get props => [
    slug,
    name,
    nameEn,
    number,
    role,
    isGoalkeeper,
    photoUrl,
    startTier,
    rating,
    ratingExact,
    rank,
    tierNow,
    tierPrev,
    moved,
    trend,
    stats,
  ];
}
