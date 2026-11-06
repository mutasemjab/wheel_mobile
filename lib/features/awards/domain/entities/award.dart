import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';

final class AwardPlayer extends Equatable {
  const AwardPlayer({
    required this.slug,
    required this.name,
    this.rank,
    this.tier,
  });

  final String slug;
  final String name;
  final int? rank;
  final Tier? tier;

  @override
  List<Object?> get props => [slug, name, rank, tier];
}

/// Award card. [key] is the stable identifier (`top_rated`, `the_wall`, …); [player] null means "لسا مفتوح".
final class Award extends Equatable {
  const Award({
    required this.key,
    required this.icon,
    required this.ar,
    required this.en,
    required this.unit,
    this.value,
    this.player,
  });

  final String key;
  final String icon;
  final String ar;
  final String en;
  final String unit;
  final double? value;
  final AwardPlayer? player;

  @override
  List<Object?> get props => [key, icon, ar, en, unit, value, player];
}
