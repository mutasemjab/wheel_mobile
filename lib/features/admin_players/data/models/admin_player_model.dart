import '../../../../core/entities/enums.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/admin_player.dart';

class AdminPlayerModel {
  const AdminPlayerModel(this.json);

  final Json json;

  AdminPlayer toEntity(ApiConfig config) => AdminPlayer(
    slug: asString(json['slug']),
    name: asString(json['name']),
    nameEn: asNonEmptyStringOrNull(json['name_en']),
    number: asIntOrNull(json['number']),
    role: asNonEmptyStringOrNull(json['role']),
    isGoalkeeper: asBool(json['is_goalkeeper']),
    photoUrl:
        asNonEmptyStringOrNull(json['photo_url']) ??
        config.storageUrl(asNonEmptyStringOrNull(json['photo_path'])),
    startTier: Tier.tryParse(asStringOrNull(json['start_tier'])) ?? Tier.c,
    sortOrder: asInt(json['sort_order']),
    isActive: asBool(json['is_active'], fallback: true),
  );

  /// Request body for create / update.
  static Json body(PlayerDraft d) {
    final nameEn = d.nameEn.trim();
    final role = d.role.trim();
    return {
      'slug': d.slug.trim(),
      'name': d.name.trim(),
      'name_en': nameEn.isEmpty ? null : nameEn,
      'number': int.tryParse(d.number.trim()),
      'role': role.isEmpty ? null : role,
      'is_goalkeeper': d.isGoalkeeper,
      'start_tier': d.startTier.code,
      'is_active': d.isActive,
    };
  }
}
