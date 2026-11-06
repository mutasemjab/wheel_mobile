/// Pure match-clock maths shared by the live viewer and the live desk.
///
/// The server sends `acc_ms` (accumulated running time), `run_at_ms` (server
/// timestamp when the clock last started, null when paused) and
/// `server_now_ms`. The device keeps an offset to the server clock.
enum ClockPhase { notStarted, paused, running }

final class MatchClockReading {
  const MatchClockReading({
    required this.phase,
    required this.elapsedMs,
    required this.minute,
  });

  final ClockPhase phase;
  final int elapsedMs;
  final int minute;
}

abstract final class MatchClock {
  static const int msPerMinute = 60000;
  static const int msPerSecond = 1000;
  static const int secondsPerMinute = 60;

  /// `server_now_ms - deviceNowMs`.
  static int offset({required int serverNowMs, required int deviceNowMs}) =>
      serverNowMs - deviceNowMs;

  /// `acc + (running ? deviceNow + offset - runAt : 0)`.
  static int elapsedMs({
    int? accMs,
    int? runAtMs,
    required int deviceNowMs,
    int offsetMs = 0,
  }) {
    final acc = accMs ?? 0;
    if (runAtMs == null) return acc;
    final running = deviceNowMs + offsetMs - runAtMs;
    return acc + (running < 0 ? 0 : running);
  }

  static int minuteFor(int elapsedMs) => elapsedMs ~/ msPerMinute + 1;

  static ClockPhase phase({int? accMs, int? runAtMs}) {
    if (runAtMs != null) return ClockPhase.running;
    return (accMs ?? 0) == 0 ? ClockPhase.notStarted : ClockPhase.paused;
  }

  static MatchClockReading read({
    int? accMs,
    int? runAtMs,
    required int deviceNowMs,
    int offsetMs = 0,
  }) {
    final elapsed = elapsedMs(
      accMs: accMs,
      runAtMs: runAtMs,
      deviceNowMs: deviceNowMs,
      offsetMs: offsetMs,
    );
    return MatchClockReading(
      phase: phase(accMs: accMs, runAtMs: runAtMs),
      elapsedMs: elapsed,
      minute: minuteFor(elapsed),
    );
  }

  /// `mm:ss` of the elapsed running time.
  static String mmss(int elapsedMs) {
    final totalSeconds = elapsedMs ~/ msPerSecond;
    final m = (totalSeconds ~/ secondsPerMinute).toString().padLeft(2, '0');
    final s = (totalSeconds % secondsPerMinute).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
