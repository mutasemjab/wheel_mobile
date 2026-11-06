/// API base URL, injected with `--dart-define=API_BASE_URL=...`.
class ApiConfig {
  const ApiConfig(this.baseUrl);

  factory ApiConfig.fromEnvironment() => const ApiConfig(
    String.fromEnvironment('API_BASE_URL', defaultValue: defaultBaseUrl),
  );

  /// Android emulator → host machine XAMPP.
  static const String defaultBaseUrl = 'https://wheelfootball.net/api/v1';
  static const String _apiSuffix = '/api/v1';
  static const String _storageSuffix = '/storage';

  final String baseUrl;

  /// `<origin>/wheel/storage` derived from `<origin>/wheel/api/v1`.
  String get storageBase {
    final trimmed = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final root = trimmed.endsWith(_apiSuffix)
        ? trimmed.substring(0, trimmed.length - _apiSuffix.length)
        : trimmed;
    return '$root$_storageSuffix';
  }

  /// Full URL for a storage-relative path (admin `photo_path`); absolute URLs pass through.
  String? storageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final clean = path.startsWith('/') ? path.substring(1) : path;
    return '$storageBase/$clean';
  }
}
