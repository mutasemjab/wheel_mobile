import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/storage/secure_token_storage.dart';
import '../../../../core/utils/json_parsing.dart';
import '../models/admin_user_model.dart';

/// Token (secure storage) + last known user (for offline restore).
class AuthLocalDataSource {
  AuthLocalDataSource(this._tokens, this._prefs);

  static const String _userKey = 'auth_user';

  final TokenStorage _tokens;
  final SharedPreferences _prefs;

  Future<String?> readToken() => _tokens.read();

  Future<void> saveToken(String token) => _tokens.write(token);

  Future<void> saveUser(AdminUserModel user) =>
      _prefs.setString(_userKey, jsonEncode(user.toJson()));

  AdminUserModel? readUser() {
    final raw = _prefs.getString(_userKey);
    if (raw == null) return null;
    try {
      return AdminUserModel.fromJson(asMap(jsonDecode(raw)));
    } on FormatException {
      return null;
    }
  }

  Future<void> clear() async {
    await _tokens.clear();
    await _prefs.remove(_userKey);
  }
}
