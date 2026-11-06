/// Display helpers for numbers coming from the API.
abstract final class NumberFormatX {
  static const int _scale = 10;

  /// Rounds to one decimal and drops `.0`
  /// (`2.0` → `2`, `1.8000000000000007` → `1.8`).
  static String compact(double v) {
    final rounded = (v * _scale).round() / _scale;
    return rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(1);
  }

  /// Up to two decimals without trailing zeros (`81.5`, `1.25`, `3`).
  static String upTo2(double v) {
    var s = v.toStringAsFixed(2);
    while (s.endsWith('0')) {
      s = s.substring(0, s.length - 1);
    }
    return s.endsWith('.') ? s.substring(0, s.length - 1) : s;
  }

  /// One decimal, always (`81.5`, `80.0`).
  static String oneDecimal(double v) => v.toStringAsFixed(1);

  /// Signed value with one decimal: `+1.5`, `-0.3`.
  static String signed(double v) {
    final sign = v > 0 ? '+' : '';
    return '$sign${v.toStringAsFixed(1)}';
  }
}
