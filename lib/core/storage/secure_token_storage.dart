import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Sanctum token storage.
abstract interface class TokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _key = 'auth_token';

  final FlutterSecureStorage _storage;
  String? _memory;
  bool _loaded = false;

  @override
  Future<String?> read() async {
    if (_loaded) return _memory;
    _memory = await _storage.read(key: _key);
    _loaded = true;
    return _memory;
  }

  @override
  Future<void> write(String token) async {
    _memory = token;
    _loaded = true;
    await _storage.write(key: _key, value: token);
  }

  @override
  Future<void> clear() async {
    _memory = null;
    _loaded = true;
    await _storage.delete(key: _key);
  }
}
