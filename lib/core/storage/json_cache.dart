import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Last successful JSON body per key, stored in SharedPreferences.
class JsonCache {
  JsonCache(this._prefs);

  static const String _prefix = 'json_cache:';

  final SharedPreferences _prefs;

  Future<void> write(String key, Object? body) =>
      _prefs.setString('$_prefix$key', jsonEncode(body));

  Object? read(String key) {
    final raw = _prefs.getString('$_prefix$key');
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }

  bool contains(String key) => _prefs.containsKey('$_prefix$key');

  Future<void> remove(String key) => _prefs.remove('$_prefix$key');
}
