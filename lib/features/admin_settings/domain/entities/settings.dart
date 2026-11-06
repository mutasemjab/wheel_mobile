import 'package:equatable/equatable.dart';

enum ConfigSection {
  points('points'),
  start('start'),
  bounds('bounds'),
  bands('bands'),
  move('move');

  const ConfigSection(this.apiKey);

  final String apiKey;
}

/// Rating configuration. Keys are server-driven; nothing is hard-coded
/// except the names the validation rules refer to.
final class RatingConfig extends Equatable {
  const RatingConfig({this.sections = const {}, this.extra = const {}});

  final Map<ConfigSection, Map<String, double>> sections;

  /// Other top-level members (e.g. `matchFixes`), sent back untouched.
  final Map<String, Object?> extra;

  double? value(ConfigSection section, String key) => sections[section]?[key];

  RatingConfig withValue(ConfigSection section, String key, double value) =>
      RatingConfig(
        sections: {
          ...sections,
          section: {...?sections[section], key: value},
        },
        extra: extra,
      );

  @override
  List<Object?> get props => [sections, extra];
}

enum ConfigError { bands, bounds, brakeBottom, brakeTop }

/// Mirrors the server: `bands.A > bands.B`, `bounds.min < bounds.max`,
/// `brakeBottom > bounds.min`, `brakeTop < 100`.
abstract final class RatingConfigValidator {
  static const double maxRating = 100;

  static Set<ConfigError> validate(RatingConfig c) {
    final bandA = c.value(ConfigSection.bands, 'A');
    final bandB = c.value(ConfigSection.bands, 'B');
    final min = c.value(ConfigSection.bounds, 'min');
    final max = c.value(ConfigSection.bounds, 'max');
    final brakeBottom = c.value(ConfigSection.move, 'brakeBottom');
    final brakeTop = c.value(ConfigSection.move, 'brakeTop');
    return {
      if (bandA != null && bandB != null && !(bandA > bandB)) ConfigError.bands,
      if (min != null && max != null && !(min < max)) ConfigError.bounds,
      if (brakeBottom != null && min != null && !(brakeBottom > min))
        ConfigError.brakeBottom,
      if (brakeTop != null && !(brakeTop < maxRating)) ConfigError.brakeTop,
    };
  }
}

final class TeamSettings extends Equatable {
  const TeamSettings({
    this.name = '',
    this.slogan = '',
    this.publicSiteUrl = '',
  });

  final String name;
  final String slogan;
  final String publicSiteUrl;

  TeamSettings copyWith({
    String? name,
    String? slogan,
    String? publicSiteUrl,
  }) => TeamSettings(
    name: name ?? this.name,
    slogan: slogan ?? this.slogan,
    publicSiteUrl: publicSiteUrl ?? this.publicSiteUrl,
  );

  @override
  List<Object?> get props => [name, slogan, publicSiteUrl];
}
