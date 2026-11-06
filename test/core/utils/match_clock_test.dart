import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/utils/match_clock.dart';

void main() {
  const device = 1_000_000;

  group('MatchClock', () {
    test('before start: no accumulated time and not running', () {
      final r = MatchClock.read(
        accMs: null,
        runAtMs: null,
        deviceNowMs: device,
      );
      expect(r.phase, ClockPhase.notStarted);
      expect(r.elapsedMs, 0);
      expect(r.minute, 1);
    });

    test('paused (break) keeps accumulated time', () {
      final r = MatchClock.read(
        accMs: 125000,
        runAtMs: null,
        deviceNowMs: device,
      );
      expect(r.phase, ClockPhase.paused);
      expect(r.elapsedMs, 125000);
      expect(r.minute, 3);
    });

    test('running adds time since run_at in server time', () {
      final r = MatchClock.read(
        accMs: 60000,
        runAtMs: device - 30000,
        deviceNowMs: device,
      );
      expect(r.phase, ClockPhase.running);
      expect(r.elapsedMs, 90000);
      expect(r.minute, 2);
    });

    test('server offset is applied to device time', () {
      // Server clock is 10 s ahead of the device.
      final offset = MatchClock.offset(
        serverNowMs: device + 10000,
        deviceNowMs: device,
      );
      expect(offset, 10000);
      final r = MatchClock.read(
        accMs: 0,
        runAtMs: device,
        deviceNowMs: device,
        offsetMs: offset,
      );
      expect(r.elapsedMs, 10000);
    });

    test('negative running time (clock skew) is clamped to zero', () {
      final elapsed = MatchClock.elapsedMs(
        accMs: 5000,
        runAtMs: device + 999,
        deviceNowMs: device,
      );
      expect(elapsed, 5000);
    });

    test('minute boundaries: 0–59.999 s is minute 1, 60 s is minute 2', () {
      expect(MatchClock.minuteFor(59999), 1);
      expect(MatchClock.minuteFor(60000), 2);
    });

    test('mm:ss formatting', () {
      expect(MatchClock.mmss(437), '00:00');
      expect(MatchClock.mmss(754000), '12:34');
    });
  });
}
