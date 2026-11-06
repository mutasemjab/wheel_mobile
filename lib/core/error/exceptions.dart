/// Thrown inside the data layer when a payload does not match the contract.
class ParsingException implements Exception {
  const ParsingException(this.message);

  final String message;

  @override
  String toString() => 'ParsingException: $message';
}

/// Thrown by local data sources when nothing is cached.
class CacheMissException implements Exception {
  const CacheMissException(this.key);

  final String key;

  @override
  String toString() => 'CacheMissException: $key';
}
