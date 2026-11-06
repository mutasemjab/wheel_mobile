import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheel_mobile/core/entities/clock_snapshot.dart';
import 'package:wheel_mobile/core/entities/enums.dart';
import 'package:wheel_mobile/core/error/failures.dart';
import 'package:wheel_mobile/core/result/result.dart';
import 'package:wheel_mobile/features/live_desk/domain/entities/live_match_state.dart';
import 'package:wheel_mobile/features/live_desk/domain/entities/server_live_match.dart';
import 'package:wheel_mobile/features/live_desk/domain/repositories/live_desk_repository.dart';
import 'package:wheel_mobile/features/live_desk/domain/usecases/clear_local_live_match.dart';
import 'package:wheel_mobile/features/live_desk/domain/usecases/discard_live_match.dart';
import 'package:wheel_mobile/features/live_desk/domain/usecases/finish_live_match.dart';
import 'package:wheel_mobile/features/live_desk/domain/usecases/get_server_live_match.dart';
import 'package:wheel_mobile/features/live_desk/domain/usecases/load_local_live_match.dart';
import 'package:wheel_mobile/features/live_desk/domain/usecases/publish_live_match.dart';
import 'package:wheel_mobile/features/live_desk/domain/usecases/save_local_live_match.dart';
import 'package:wheel_mobile/features/live_desk/domain/usecases/send_clock_hint.dart';
import 'package:wheel_mobile/features/live_desk/domain/usecases/sync_live_match.dart';
import 'package:wheel_mobile/features/live_desk/presentation/bloc/live_desk_bloc.dart';
import 'package:wheel_mobile/features/matches/domain/entities/match.dart';
import 'package:wheel_mobile/features/players/domain/entities/player.dart';
import 'package:wheel_mobile/features/players/domain/repositories/players_repository.dart';
import 'package:wheel_mobile/features/players/domain/usecases/get_players.dart';

class _MockLiveRepo extends Mock implements LiveDeskRepository {}

class _MockPlayersRepo extends Mock implements PlayersRepository {}

const _debounce = Duration(milliseconds: 20);
const _retry = Duration(milliseconds: 40);
const _settle = Duration(milliseconds: 120);
const _deviceNow = 1000000;

final _roster = [
  for (final slug in ['a', 'b', 'c', 'd'])
    Player(
      slug: slug,
      name: slug.toUpperCase(),
      rating: 50,
      ratingExact: 50,
      rank: 1,
    ),
];

LiveMatchState _active({
  bool onServer = true,
  SyncStatus sync = SyncStatus.synced,
}) => LiveMatchState(
  code: 'm-20261030-local1',
  opponent: 'رجائي',
  date: DateTime(2026, 10, 30),
  played: const ['a', 'b', 'c'],
  serverCreated: onServer,
  syncStatus: sync,
);

ServerLiveMatch _server(String code, {String opponent = 'سيرفر', int? now}) =>
    ServerLiveMatch(
      code: code,
      date: DateTime(2026, 10, 30),
      opponent: opponent,
      clock: ClockSnapshot(serverNowMs: now),
      squad: const [
        SquadEntry(slug: 'a', name: 'A', status: SquadStatus.played),
        SquadEntry(slug: 'b', name: 'B', status: SquadStatus.played),
      ],
    );

const _published = FootballMatch(
  code: 'm-20261030-local1',
  opponent: 'رجائي',
  result: MatchResult.win,
);

void main() {
  late _MockLiveRepo repo;
  late _MockPlayersRepo players;
  late int ids;
  late int published;
  late List<String> diffs;

  setUpAll(() => registerFallbackValue(_active()));

  setUp(() {
    repo = _MockLiveRepo();
    players = _MockPlayersRepo();
    ids = 0;
    published = 0;
    diffs = [];
    when(
      () => players.getPlayers(fromCache: any(named: 'fromCache')),
    ).thenAnswer((_) async => Success(_roster));
    when(() => repo.saveLocal(any())).thenAnswer((_) async {});
    when(() => repo.clearLocal()).thenAnswer((_) async {});
    when(() => repo.loadLocal()).thenAnswer((_) async => null);
    when(
      () => repo.fetchServerMatch(),
    ).thenAnswer((_) async => const Success(null));
    when(() => repo.sync(any())).thenAnswer((_) async => const Success(null));
    when(
      () => repo.sendClock(start: any(named: 'start')),
    ).thenAnswer((_) async => const Success(ClockSnapshot()));
    when(() => repo.discard()).thenAnswer((_) async => const Success(null));
  });

  LiveDeskBloc build() => LiveDeskBloc(
    LiveDeskUseCases(
      getServerMatch: GetServerLiveMatch(repo),
      syncMatch: SyncLiveMatch(repo),
      sendClock: SendClockHint(repo),
      finishMatch: FinishLiveMatch(repo),
      publishMatch: PublishLiveMatch(repo),
      discardMatch: DiscardLiveMatch(repo),
      loadLocal: LoadLocalLiveMatch(repo),
      saveLocal: SaveLocalLiveMatch(repo),
      clearLocal: ClearLocalLiveMatch(repo),
      getPlayers: GetPlayers(players),
    ),
    newId: () => 'uuid-${ids++}',
    now: () => _deviceNow,
    onPublished: () async => published++,
    onServerDiff: diffs.add,
    syncDebounce: _debounce,
    retryDelay: _retry,
  );

  final setup = LiveDeskSetupSubmitted(
    opponent: ' رجائي ',
    date: DateTime(2026, 10, 30),
    played: const ['a', 'b', 'c'],
    excused: const ['d'],
  );

  group('open', () {
    blocTest<LiveDeskBloc, LiveDeskState>(
      'nothing local or on the server → setup with the roster',
      build: build,
      act: (b) => b.add(const LiveDeskOpened()),
      verify: (b) {
        expect(b.state.status, LiveDeskStatus.setup);
        expect(b.state.roster, _roster);
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'local state is kept when the server has the same code, then synced',
      setUp: () {
        when(() => repo.loadLocal()).thenAnswer(
          (_) async => _active(sync: SyncStatus.pending, onServer: false),
        );
        when(() => repo.fetchServerMatch()).thenAnswer(
          (_) async => Success(_server('m-20261030-local1', opponent: 'x')),
        );
      },
      build: build,
      act: (b) => b.add(const LiveDeskOpened()),
      wait: _settle,
      verify: (b) {
        expect(b.state.status, LiveDeskStatus.active);
        expect(b.state.match?.opponent, 'رجائي', reason: 'local wins');
        expect(b.state.match?.syncStatus, SyncStatus.synced);
        verify(() => repo.sync(any())).called(1);
      },
    );
  });

  group('start', () {
    blocTest<LiveDeskBloc, LiveDeskState>(
      'setup → save locally → sync (sync creates the match; no POST)',
      build: build,
      act: (b) => b.add(setup),
      wait: _settle,
      verify: (b) {
        final m = b.state.match!;
        expect(b.state.status, LiveDeskStatus.active);
        expect(m.opponent, 'رجائي');
        expect(m.code, startsWith('m-20261030-'));
        expect(m.excused, ['d']);
        expect(m.serverCreated, isTrue);
        expect(m.syncStatus, SyncStatus.synced);
        verifyInOrder([() => repo.saveLocal(any()), () => repo.sync(any())]);
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'offline start needs no special path: sync is retried until it lands',
      setUp: () {
        var calls = 0;
        when(() => repo.sync(any())).thenAnswer(
          (_) async =>
              calls++ == 0 ? const Err(NetworkFailure()) : const Success(null),
        );
      },
      build: build,
      act: (b) => b.add(setup),
      wait: _retry * 4,
      expect: () => contains(
        isA<LiveDeskState>().having(
          (s) => s.match?.syncStatus,
          'sync',
          SyncStatus.offline,
        ),
      ),
      verify: (b) {
        expect(b.state.match?.serverCreated, isTrue);
        expect(b.state.match?.syncStatus, SyncStatus.synced);
        verify(() => repo.sync(any())).called(2);
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'the sync response refreshes the server-time offset and logs differences',
      setUp: () => when(() => repo.sync(any())).thenAnswer(
        (_) async =>
            Success(_server('m-20261030-local1', now: _deviceNow + 5000)),
      ),
      build: build,
      seed: () => LiveDeskState(
        status: LiveDeskStatus.active,
        match: _active(sync: SyncStatus.pending),
      ),
      act: (b) => b.add(const LiveDeskSyncRequested()),
      wait: _settle,
      verify: (b) {
        expect(b.state.offsetMs, 5000);
        expect(b.state.match?.syncStatus, SyncStatus.synced);
        expect(diffs, isNotEmpty, reason: 'server squad differs from local');
      },
    );
  });

  group('409', () {
    blocTest<LiveDeskBloc, LiveDeskState>(
      'another live match → conflict, resume replaces local with the server',
      setUp: () {
        when(() => repo.sync(any())).thenAnswer(
          (_) async => const Err(ConflictFailure(serverMessage: 'x')),
        );
        when(
          () => repo.fetchServerMatch(),
        ).thenAnswer((_) async => Success(_server('m-20261030-srv999')));
      },
      build: build,
      act: (b) async {
        b.add(setup);
        await Future<void>.delayed(_settle);
        expect(b.state.status, LiveDeskStatus.conflict);
        expect(b.state.conflict?.code, 'm-20261030-srv999');
        b.add(const LiveDeskConflictResumed());
      },
      wait: _settle,
      verify: (b) {
        expect(b.state.status, LiveDeskStatus.active);
        expect(b.state.match?.code, 'm-20261030-srv999');
        expect(b.state.match?.opponent, 'سيرفر');
        expect(b.state.conflict, isNull);
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'discard deletes the server match and syncs ours again',
      setUp: () {
        var calls = 0;
        when(() => repo.sync(any())).thenAnswer(
          (_) async =>
              calls++ == 0 ? const Err(ConflictFailure()) : const Success(null),
        );
        when(
          () => repo.fetchServerMatch(),
        ).thenAnswer((_) async => Success(_server('m-20261030-srv999')));
      },
      build: build,
      seed: () => LiveDeskState(
        status: LiveDeskStatus.active,
        match: _active(sync: SyncStatus.pending, onServer: false),
      ),
      act: (b) async {
        b.add(const LiveDeskSyncRequested());
        await Future<void>.delayed(_settle);
        expect(b.state.status, LiveDeskStatus.conflict);
        b.add(const LiveDeskConflictDiscarded());
      },
      wait: _settle,
      verify: (b) {
        verify(() => repo.discard()).called(1);
        verify(() => repo.sync(any())).called(2);
        expect(b.state.status, LiveDeskStatus.active);
        expect(b.state.match?.code, 'm-20261030-local1');
        expect(b.state.match?.syncStatus, SyncStatus.synced);
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'our code is already published (no live match) → local copy dropped',
      setUp: () => when(
        () => repo.sync(any()),
      ).thenAnswer((_) async => const Err(ConflictFailure())),
      build: build,
      seed: () => LiveDeskState(
        status: LiveDeskStatus.active,
        match: _active(sync: SyncStatus.pending),
      ),
      act: (b) async {
        b.add(const LiveDeskSyncRequested());
        await Future<void>.delayed(_settle);
        expect(b.state.status, LiveDeskStatus.conflict);
        expect(b.state.conflict, isNull);
        b.add(const LiveDeskConflictDiscarded());
      },
      wait: _settle,
      verify: (b) {
        expect(b.state.status, LiveDeskStatus.setup);
        expect(b.state.match, isNull);
        verify(() => repo.clearLocal()).called(1);
        verifyNever(() => repo.discard());
      },
    );
  });

  group('events', () {
    blocTest<LiveDeskBloc, LiveDeskState>(
      'every event type updates the derived score',
      build: build,
      seed: () =>
          LiveDeskState(status: LiveDeskStatus.active, match: _active()),
      act: (b) => b
        ..add(
          const LiveDeskEventAdded(
            LiveEventType.goal,
            player: 'a',
            assist: 'b',
          ),
        )
        ..add(const LiveDeskEventAdded(LiveEventType.og))
        ..add(const LiveDeskEventAdded(LiveEventType.against, player: 'c'))
        ..add(const LiveDeskEventAdded(LiveEventType.save, player: 'c'))
        ..add(const LiveDeskEventAdded(LiveEventType.tackle, player: 'b')),
      wait: _settle,
      verify: (b) {
        final m = b.state.match!;
        expect(m.events.map((e) => e.type), [
          LiveEventType.goal,
          LiveEventType.og,
          LiveEventType.against,
          LiveEventType.save,
          LiveEventType.tackle,
        ]);
        expect(m.events.map((e) => e.uuid).toSet(), hasLength(5));
        expect(m.events.first.minute, isNull, reason: 'clock never started');
        expect((m.scoreUs, m.scoreThem), (2, 1));
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'rapid taps are debounced into a single sync',
      build: build,
      seed: () =>
          LiveDeskState(status: LiveDeskStatus.active, match: _active()),
      act: (b) {
        for (var i = 0; i < 6; i++) {
          b.add(const LiveDeskEventAdded(LiveEventType.save, player: 'a'));
        }
      },
      wait: _settle,
      verify: (b) {
        verify(() => repo.sync(any())).called(1);
        expect(b.state.match?.events, hasLength(6));
        expect(b.state.match?.syncStatus, SyncStatus.synced);
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'undo removes the last event and redo restores it',
      build: build,
      seed: () =>
          LiveDeskState(status: LiveDeskStatus.active, match: _active()),
      act: (b) async {
        b.add(const LiveDeskEventAdded(LiveEventType.og));
        await Future<void>.delayed(Duration.zero);
        b.add(const LiveDeskUndoRequested());
        await Future<void>.delayed(Duration.zero);
        expect(b.state.match?.events, isEmpty);
        expect(b.state.lastUndone?.type, LiveEventType.og);
        b.add(const LiveDeskRedoRequested());
      },
      wait: _settle,
      verify: (b) {
        expect(b.state.match?.events.single.type, LiveEventType.og);
        expect(b.state.redo, isEmpty);
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'clock start stamps the minute; the clock reply updates the offset',
      setUp: () => when(() => repo.sendClock(start: true)).thenAnswer(
        (_) async => const Success(
          ClockSnapshot(accMs: 0, serverNowMs: _deviceNow + 2000),
        ),
      ),
      build: build,
      seed: () =>
          LiveDeskState(status: LiveDeskStatus.active, match: _active()),
      act: (b) async {
        b.add(const LiveDeskClockToggled());
        await Future<void>.delayed(Duration.zero);
        b.add(const LiveDeskEventAdded(LiveEventType.og));
      },
      wait: _settle,
      verify: (b) {
        expect(b.state.match?.clock.runAtMs, _deviceNow);
        expect(b.state.match?.events.single.minute, 1);
        expect(b.state.offsetMs, 2000);
        verify(() => repo.sendClock(start: true)).called(1);
      },
    );
  });

  group('finish & publish', () {
    blocTest<LiveDeskBloc, LiveDeskState>(
      'finish waits for a successful sync before calling /finish',
      setUp: () {
        var calls = 0;
        when(() => repo.sync(any())).thenAnswer(
          (_) async =>
              calls++ == 0 ? const Err(NetworkFailure()) : const Success(null),
        );
        when(() => repo.finish(motm: any(named: 'motm'))).thenAnswer(
          (_) async => const Success(
            LiveFinishResult(
              scoreUs: 0,
              scoreThem: 0,
              summary: 'WHEEL FC 0–0 رجائي',
              motm: 'a',
            ),
          ),
        );
      },
      build: build,
      seed: () => LiveDeskState(
        status: LiveDeskStatus.active,
        match: _active(sync: SyncStatus.pending),
      ),
      act: (b) => b.add(const LiveDeskFinishRequested(motm: 'a')),
      wait: _settle,
      verify: (b) {
        expect(b.state.status, LiveDeskStatus.finished);
        expect(b.state.match?.finished, isTrue);
        expect(b.state.match?.summary, startsWith('WHEEL FC 0–0'));
        expect(b.state.match?.motm, 'a');
        verifyInOrder([
          () => repo.sync(any()),
          () => repo.sync(any()),
          () => repo.finish(motm: 'a'),
        ]);
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'finish is blocked while the sync keeps failing',
      setUp: () => when(
        () => repo.sync(any()),
      ).thenAnswer((_) async => const Err(NetworkFailure())),
      build: build,
      seed: () => LiveDeskState(
        status: LiveDeskStatus.active,
        match: _active(sync: SyncStatus.pending),
      ),
      act: (b) => b.add(const LiveDeskFinishRequested(motm: 'a')),
      wait: _settle,
      verify: (b) {
        expect(b.state.status, LiveDeskStatus.active);
        expect(b.state.match?.finished, isFalse);
        verifyNever(() => repo.finish(motm: any(named: 'motm')));
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'publish uses the returned match, clears local state and refreshes',
      setUp: () => when(
        () => repo.publish(motm: any(named: 'motm')),
      ).thenAnswer((_) async => const Success(_published)),
      build: build,
      seed: () => LiveDeskState(
        status: LiveDeskStatus.finished,
        match: _active().copyWith(
          finished: true,
          motm: 'a',
          summary: 'WHEEL FC 2–1 رجائي',
        ),
      ),
      act: (b) => b.add(const LiveDeskPublishRequested()),
      verify: (b) {
        expect(b.state.status, LiveDeskStatus.published);
        expect(b.state.match, isNull);
        expect(b.state.publishedCode, 'm-20261030-local1');
        expect(b.state.finalSummary, 'WHEEL FC 2–1 رجائي');
        expect(published, 1);
        verify(() => repo.publish(motm: 'a')).called(1);
        verify(() => repo.clearLocal()).called(1);
      },
    );

    blocTest<LiveDeskBloc, LiveDeskState>(
      'discard: 404 (nothing live any more) still clears the desk',
      setUp: () => when(
        () => repo.discard(),
      ).thenAnswer((_) async => const Err(NotFoundFailure())),
      build: build,
      seed: () =>
          LiveDeskState(status: LiveDeskStatus.active, match: _active()),
      act: (b) => b.add(const LiveDeskDiscardRequested()),
      verify: (b) {
        expect(b.state.status, LiveDeskStatus.setup);
        expect(b.state.match, isNull);
        verify(() => repo.clearLocal()).called(1);
      },
    );
  });
}
