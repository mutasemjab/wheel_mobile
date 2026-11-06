/// Rating tiers. Titles and ranges always come from the API.
enum Tier {
  a('A'),
  b('B'),
  c('C');

  const Tier(this.code);

  final String code;

  static Tier? tryParse(String? code) {
    final upper = code?.toUpperCase();
    for (final tier in values) {
      if (tier.code == upper) return tier;
    }
    return null;
  }
}

/// Tier movement after the last match (`moved`).
enum Movement {
  up,
  down,
  none;

  static Movement parse(String? v) => switch (v) {
    'up' => up,
    'down' => down,
    _ => none,
  };
}

/// Live event types (`goal | og | against | save | tackle`).
enum LiveEventType {
  goal('goal'),
  og('og'),
  against('against'),
  save('save'),
  tackle('tackle');

  const LiveEventType(this.apiName);

  final String apiName;

  static LiveEventType? tryParse(String? v) {
    for (final type in values) {
      if (type.apiName == v) return type;
    }
    return null;
  }

  /// Types that carry a player (`og` never does; `against` optionally).
  bool get requiresPlayer => this == goal || this == save || this == tackle;
}

/// Match result letters `W` / `D` / `L`.
enum MatchResult {
  win('W'),
  draw('D'),
  loss('L');

  const MatchResult(this.code);

  final String code;

  static MatchResult? tryParse(String? v) => switch (v?.toUpperCase()) {
    'W' => win,
    'D' => draw,
    'L' => loss,
    _ => null,
  };

  static MatchResult fromScore(int us, int them) => us > them
      ? win
      : us == them
      ? draw
      : loss;
}
