import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/settings.dart';

class RatingConfigModel {
  const RatingConfigModel(this.json);

  /// Members never sent back on `PUT /admin/config`.
  static const Set<String> _readOnly = {'tiers'};

  final Json json;

  RatingConfig toEntity() {
    final sectionKeys = {for (final s in ConfigSection.values) s.apiKey};
    return RatingConfig(
      sections: {
        for (final s in ConfigSection.values)
          s: {
            for (final entry in asMap(json[s.apiKey]).entries)
              entry.key: ?asDoubleOrNull(entry.value),
          },
      },
      extra: {
        for (final entry in json.entries)
          if (!sectionKeys.contains(entry.key) &&
              !_readOnly.contains(entry.key))
            entry.key: entry.value,
      },
    );
  }

  /// Integers go back as ints so the server sees the same types.
  static Json body(RatingConfig config) => {
    for (final entry in config.sections.entries)
      entry.key.apiKey: {
        for (final v in entry.value.entries)
          v.key: v.value == v.value.roundToDouble() ? v.value.toInt() : v.value,
      },
    ...config.extra,
  };
}

class TeamSettingsModel {
  const TeamSettingsModel(this.json);

  final Json json;

  TeamSettings toEntity() => TeamSettings(
    name: asString(json['name']),
    slogan: asString(json['slogan']),
    publicSiteUrl: asString(json['public_site_url']),
  );

  static Json body(TeamSettings t) => {
    'name': t.name.trim(),
    'slogan': t.slogan.trim(),
    'public_site_url': t.publicSiteUrl.trim().isEmpty
        ? null
        : t.publicSiteUrl.trim(),
  };
}
