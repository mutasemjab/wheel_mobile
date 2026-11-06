import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheel_mobile/core/entities/clock_snapshot.dart';
import 'package:wheel_mobile/core/result/result.dart';
import 'package:wheel_mobile/core/utils/match_clock.dart';
import 'package:wheel_mobile/features/live_viewer/data/models/live_match_model.dart';
import 'package:wheel_mobile/features/live_viewer/domain/entities/live_match.dart';
import 'package:wheel_mobile/features/live_viewer/domain/usecases/get_live_match.dart';
import 'package:wheel_mobile/features/live_viewer/presentation/bloc/live_viewer_cubit.dart';

import '../../helpers/fixtures.dart';

class _MockGetLive extends Mock implements GetLiveMatch {}

void main() {
  late _MockGetLive getLive;
  final paused = LiveMatchModel.fromJson(fixtureData('live')).toEntity();

  setUp(() => getLive = _MockGetLive());

  blocTest<LiveViewerCubit, LiveViewerState>(
    'no live match → idle',
    setUp: () =>
        when(() => getLive()).thenAnswer((_) async => const Success(null)),
    build: () => LiveViewerCubit(getLive, now: () => 1000),
    act: (c) => c.refresh(),
    expect: () => [
      const LiveViewerState(status: LiveViewerStatus.idle, nowMs: 1000),
    ],
  );

  blocTest<LiveViewerCubit, LiveViewerState>(
    'paused live match reads as a break with the server offset',
    setUp: () => when(() => getLive()).thenAnswer((_) async => Success(paused)),
    build: () => LiveViewerCubit(getLive, now: () => 1793441966000),
    act: (c) => c.refresh(),
    verify: (c) {
      expect(c.state.status, LiveViewerStatus.live);
      expect(c.state.offsetMs, 448);
      expect(c.state.clock?.phase, ClockPhase.paused);
    },
  );

  group('ticking clock', () {
    var now = 0;
    const serverNow = 1000000;
    // Started 60 s before the server's "now".
    const running = LiveMatch(
      code: 'm',
      opponent: 'X',
      clock: ClockSnapshot(runAtMs: serverNow - 60000, serverNowMs: serverNow),
    );

    blocTest<LiveViewerCubit, LiveViewerState>(
      'advances every tick while running',
      setUp: () {
        now = serverNow;
        when(() => getLive()).thenAnswer((_) async => const Success(running));
      },
      build: () => LiveViewerCubit(
        getLive,
        now: () => now += 1000,
        pollInterval: const Duration(hours: 1),
        tickInterval: const Duration(milliseconds: 20),
      ),
      act: (c) => c.start(),
      wait: const Duration(milliseconds: 90),
      verify: (c) {
        expect(c.state.clock?.phase, ClockPhase.running);
        // Several ticks of +1 s each after the first response.
        expect(c.state.clock!.elapsedMs, greaterThanOrEqualTo(62000));
      },
    );
  });
}
