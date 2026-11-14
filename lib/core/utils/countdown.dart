/// Coarse "time until kickoff" used by fixture cards.
enum CountdownUnit { started, minutes, hours, days }

final class Countdown {
  const Countdown(this.unit, this.value);

  /// Biggest whole unit until [target]: under an hour → minutes,
  /// under a day → hours, otherwise days. Past → [CountdownUnit.started].
  factory Countdown.until(DateTime target, DateTime now) {
    final left = target.difference(now);
    if (left <= Duration.zero) return const Countdown(CountdownUnit.started, 0);
    if (left < const Duration(hours: 1)) {
      return Countdown(CountdownUnit.minutes, left.inMinutes.clamp(1, 59));
    }
    if (left < const Duration(days: 1)) {
      return Countdown(CountdownUnit.hours, left.inHours);
    }
    return Countdown(CountdownUnit.days, left.inDays);
  }

  final CountdownUnit unit;
  final int value;

  @override
  bool operator ==(Object other) =>
      other is Countdown && other.unit == unit && other.value == value;

  @override
  int get hashCode => Object.hash(unit, value);

  @override
  String toString() => 'Countdown($unit, $value)';
}
