// Tolerant JSON helpers (num/int/double, `[]` for empty maps in old cached
// responses). This is the only place where `dynamic` is accepted.

import 'date_utils.dart';

typedef Json = Map<String, dynamic>;

/// Returns the `data` member of a `{ data: ... }` envelope.
dynamic dataOf(dynamic body) => body is Map ? body['data'] : null;

/// Returns a JSON object; empty lists and null become `{}`.
Json asMap(dynamic v) {
  if (v is Map<String, dynamic>) return v;
  if (v is Map) return v.map((k, value) => MapEntry(k.toString(), value));
  return <String, dynamic>{};
}

Json? asMapOrNull(dynamic v) => v is Map ? asMap(v) : null;

List<dynamic> asList(dynamic v) => v is List ? v : const [];

List<Json> asMapList(dynamic v) =>
    asList(v).whereType<Map>().map(asMap).toList(growable: false);

int? asIntOrNull(dynamic v) => switch (v) {
  final int i => i,
  final num n => n.round(),
  final String s => num.tryParse(s)?.round(),
  _ => null,
};

int asInt(dynamic v, {int fallback = 0}) => asIntOrNull(v) ?? fallback;

double? asDoubleOrNull(dynamic v) => switch (v) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s),
  _ => null,
};

double asDouble(dynamic v, {double fallback = 0}) =>
    asDoubleOrNull(v) ?? fallback;

String? asStringOrNull(dynamic v) => switch (v) {
  null => null,
  final String s => s,
  final num n => n.toString(),
  final bool b => b.toString(),
  _ => null,
};

String asString(dynamic v, {String fallback = ''}) =>
    asStringOrNull(v) ?? fallback;

/// Non-empty string or null.
String? asNonEmptyStringOrNull(dynamic v) {
  final s = asStringOrNull(v);
  return s == null || s.isEmpty ? null : s;
}

bool asBool(dynamic v, {bool fallback = false}) => switch (v) {
  final bool b => b,
  final num n => n != 0,
  final String s => s == '1' || s.toLowerCase() == 'true',
  _ => fallback,
};

List<String> asStringList(dynamic v) => asList(
  v,
).map(asNonEmptyStringOrNull).whereType<String>().toList(growable: false);

/// `{slug: count}` maps. Accepts `[]` (empty PHP array) and drops `""` keys.
Map<String, int> asIntMap(dynamic v) {
  if (v is! Map) return const {};
  final out = <String, int>{};
  for (final entry in v.entries) {
    final key = entry.key.toString();
    if (key.isEmpty) continue;
    final value = asIntOrNull(entry.value);
    if (value != null) out[key] = value;
  }
  return out;
}

/// Match dates are calendar days (`YYYY-MM-DD`); no time zone is involved.
DateTime parseMatchDate(String s) {
  final trimmed = s.trim();
  final day = trimmed.length > DateUtilsX.isoDateLength
      ? trimmed.substring(0, DateUtilsX.isoDateLength)
      : trimmed;
  final d = DateTime.parse(day);
  return DateTime(d.year, d.month, d.day);
}

DateTime? parseMatchDateOrNull(dynamic v) {
  final s = asNonEmptyStringOrNull(v);
  if (s == null) return null;
  try {
    return parseMatchDate(s);
  } on FormatException {
    return null;
  }
}

DateTime? parseDateTimeOrNull(dynamic v) {
  final s = asNonEmptyStringOrNull(v);
  return s == null ? null : DateTime.tryParse(s);
}
