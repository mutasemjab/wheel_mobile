import 'dart:math';

/// Device-generated match code: `m-<yyyymmdd>-<6 random [a-z0-9]>`.
abstract final class MatchCode {
  static const String _alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
  static const int _suffixLength = 6;
  static const int maxLength = 60;
  static final RegExp pattern = RegExp(r'^m-\d{8}-[a-z0-9]{6}$');

  static String generate(DateTime date, [Random? random]) {
    final rnd = random ?? Random.secure();
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final suffix = List.generate(
      _suffixLength,
      (_) => _alphabet[rnd.nextInt(_alphabet.length)],
    ).join();
    return 'm-$y$m$d-$suffix';
  }
}
