import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/live_match_state.dart';
import '../models/live_match_state_dto.dart';

/// Persists the live match on every change. Never cleared by logout or 401.
class LiveDeskLocalDataSource {
  LiveDeskLocalDataSource(this._prefs);

  static const String _key = 'live_desk_state_v1';

  final SharedPreferences _prefs;

  LiveMatchState? load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return LiveMatchStateDto.fromJson(asMap(jsonDecode(raw))).toEntity();
    } on Object {
      return null;
    }
  }

  Future<void> save(LiveMatchState state) => _prefs.setString(
    _key,
    jsonEncode(LiveMatchStateDto.fromEntity(state).toJson()),
  );

  Future<void> clear() => _prefs.remove(_key);
}
