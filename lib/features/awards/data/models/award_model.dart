import '../../../../core/entities/enums.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/award.dart';

class AwardModel {
  const AwardModel({
    required this.key,
    required this.icon,
    required this.ar,
    required this.en,
    required this.unit,
    this.value,
    this.player,
  });

  factory AwardModel.fromJson(Json json) {
    final player = asMapOrNull(json['player']);
    return AwardModel(
      key: asString(json['key'], fallback: asString(json['en'])),
      icon: asString(json['icon']),
      ar: asString(json['ar']),
      en: asString(json['en']),
      unit: asString(json['unit']),
      value: asDoubleOrNull(json['val']),
      player: player == null || asNonEmptyStringOrNull(player['slug']) == null
          ? null
          : AwardPlayer(
              slug: asString(player['slug']),
              name: asString(player['name']),
              rank: asIntOrNull(player['rank']),
              tier: Tier.tryParse(asStringOrNull(player['tier'])),
            ),
    );
  }

  static List<AwardModel> listFromJson(dynamic json) =>
      asMapList(json).map(AwardModel.fromJson).toList(growable: false);

  final String key;
  final String icon;
  final String ar;
  final String en;
  final String unit;
  final double? value;
  final AwardPlayer? player;

  Award toEntity() => Award(
    key: key,
    icon: icon,
    ar: ar,
    en: en,
    unit: unit,
    value: value,
    player: player,
  );
}
