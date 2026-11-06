import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/entities/enums.dart';
import 'package:wheel_mobile/features/live_desk/data/models/live_match_state_dto.dart';
import 'package:wheel_mobile/features/live_desk/data/models/live_sync_payload.dart';
import 'package:wheel_mobile/features/live_desk/domain/entities/live_match_rules.dart';
import 'package:wheel_mobile/features/live_desk/domain/entities/live_match_state.dart';
import 'package:wheel_mobile/features/live_desk/domain/entities/match_code.dart';

LiveMatchState _match({
  List<String> played = const ['a', 'b', 'c'],
  List<String> excused = const [],
  List<LiveEvent> events = const [],
}) => LiveMatchState(
  code: 'm-20261030-abc123',
  opponent: 'رجائي',
  date: DateTime(2026, 10, 30),
  played: played,
  excused: excused,
  events: events,
);

LiveEvent _e(String id, LiveEventType type, {String? player, String? assist}) =>
    LiveEvent(uuid: id, type: type, player: player, assist: assist);

void main() {
  group('score derivation', () {
    test('us = goals + own goals, them = goals against', () {
      final m = _match(
        events: [
          _e('1', LiveEventType.goal, player: 'a'),
          _e('2', LiveEventType.og),
          _e('3', LiveEventType.against),
          _e('4', LiveEventType.save, player: 'b'),
          _e('5', LiveEventType.tackle, player: 'c'),
        ],
      );
      expect(m.scoreUs, 2);
      expect(m.scoreThem, 1);
    });

    test('per-player tallies', () {
      final m = _match(
        events: [
          _e('1', LiveEventType.goal, player: 'a', assist: 'b'),
          _e('2', LiveEventType.goal, player: 'a'),
          _e('3', LiveEventType.save, player: 'c'),
          _e('4', LiveEventType.against, player: 'b'),
        ],
      );
      final t = m.tallies;
      expect(t['a'], const PlayerTally(g: 2));
      expect(t['b'], const PlayerTally(a: 1, c: 1));
      expect(t['c'], const PlayerTally(s: 1));
    });
  });

  group('sanitiser', () {
    test('excused ∩ played is removed from excused', () {
      final m = _match(played: ['a', 'b'], excused: ['b', 'x']).sanitized();
      expect(m.excused, ['x']);
    });

    test('flags and values only for played players', () {
      final m = _match(played: ['a', 'b'])
          .copyWith(
            unfair: {'a', 'z'},
            late: {'z'},
            values: {'a': 2, 'z': 1, 'b': 0},
            motm: 'z',
          )
          .sanitized();
      expect(m.unfair, {'a'});
      expect(m.late, isEmpty);
      expect(m.values, {'a': 2});
      expect(m.motm, isNull);
    });

    test('assist ≠ scorer and both must be in played', () {
      final m = _match(
        events: [
          _e('1', LiveEventType.goal, player: 'a', assist: 'a'),
          _e('2', LiveEventType.goal, player: 'a', assist: 'z'),
          _e('3', LiveEventType.goal, player: 'z', assist: 'a'),
          _e('4', LiveEventType.save, player: 'z'),
        ],
      ).sanitized();
      expect(m.events.map((e) => e.uuid), ['1', '2']);
      expect(m.events.every((e) => e.assist == null), isTrue);
    });

    test('og never carries a player; against keeps only a played player', () {
      final m = _match(
        events: [
          _e('1', LiveEventType.og, player: 'a', assist: 'b'),
          _e('2', LiveEventType.against, player: 'z'),
          _e('3', LiveEventType.against, player: 'b'),
        ],
      ).sanitized();
      expect(m.events[0].player, isNull);
      expect(m.events[0].assist, isNull);
      expect(m.events[1].player, isNull);
      expect(m.events[2].player, 'b');
    });

    test('limits: 40 players and 300 events', () {
      final many = [for (var i = 0; i < 50; i++) 'p$i'];
      final m = _match(played: many, excused: ['x']).sanitized();
      expect(m.played, hasLength(LiveMatchRules.maxPlayers));
      expect(m.excused, isEmpty);

      var full = _match(
        events: [for (var i = 0; i < 300; i++) _e('$i', LiveEventType.og)],
      );
      expect(full.canAddEvent, isFalse);
      full = full.addEvent(_e('extra', LiveEventType.og));
      expect(full.events, hasLength(LiveMatchRules.maxEvents));
    });
  });

  group('edits', () {
    test('undo removes the last event; redo re-adds it', () {
      final m = _match(
        events: [_e('1', LiveEventType.og), _e('2', LiveEventType.against)],
      );
      final (undone, removed) = m.undo();
      expect(removed?.uuid, '2');
      expect(undone.events.map((e) => e.uuid), ['1']);
      final redone = undone.addEvent(removed!);
      expect(redone.events.map((e) => e.uuid), ['1', '2']);
      expect(_match().undo().$2, isNull);
    });

    test('edit swaps save ↔ tackle and changes player', () {
      final m = _match(events: [_e('1', LiveEventType.save, player: 'a')]);
      final edited = m.updateEvent(_e('1', LiveEventType.tackle, player: 'b'));
      expect(edited.events.single.type, LiveEventType.tackle);
      expect(edited.events.single.player, 'b');
      expect(edited.removeEvent('1').events, isEmpty);
    });

    test('emergency player moves from excused to played', () {
      final m = _match(
        played: ['a', 'b'],
        excused: ['c'],
      ).addEmergencyPlayer('c');
      expect(m.played, ['a', 'b', 'c']);
      expect(m.excused, isEmpty);
      expect(m.addEmergencyPlayer('c'), m);
    });

    test('values never go below zero; toggles flip', () {
      var m = _match().changeValues('a', 1).changeValues('a', 1);
      expect(m.values['a'], 2);
      m = m.changeValues('a', -5);
      expect(m.values.containsKey('a'), isFalse);
      m = m.toggleLate('a').toggleUnfair('b');
      expect(m.late, {'a'});
      expect(m.unfair, {'b'});
      expect(m.toggleLate('a').late, isEmpty);
    });
  });

  group('clock', () {
    test('minute is null until the clock starts', () {
      expect(_match().minuteAt(1000), isNull);
    });

    test('start → pause accumulates server time', () {
      var m = _match().startClock(10000);
      expect(m.clock.runAtMs, 10000);
      expect(m.minuteAt(10000 + 61000), 2);
      m = m.pauseClock(10000 + 90000);
      expect(m.clock.runAtMs, isNull);
      expect(m.clock.accMs, 90000);
      expect(m.minuteAt(999999), 2);
    });
  });

  test('match code format', () {
    final code = MatchCode.generate(DateTime(2026, 10, 30));
    expect(MatchCode.pattern.hasMatch(code), isTrue);
    expect(code, startsWith('m-20261030-'));
    expect(code.length <= MatchCode.maxLength, isTrue);
  });

  test('sync payload: full events oldest → newest, og without player', () {
    final m = _match(
      events: [
        _e('1', LiveEventType.goal, player: 'a', assist: 'b'),
        _e('2', LiveEventType.og),
        _e('3', LiveEventType.against),
      ],
    ).copyWith(clock: const LiveClock(accMs: 120000, runAtMs: 5));
    final body = LiveSyncPayload.sync(m);
    expect(body['date'], '2026-10-30');
    expect(body['clock'], {'acc_ms': 120000, 'run_at_ms': 5});
    final events = body['events'] as List;
    expect(events.map((e) => (e as Map)['uuid']), ['1', '2', '3']);
    expect((events[1] as Map)['player'], isNull);
    expect(body.containsKey('note'), isFalse);
    expect(
      LiveSyncPayload.sync(m, includeClock: false, note: 'x')['note'],
      'x',
    );
  });

  test('local persistence round trip', () {
    final m = _match(events: [_e('1', LiveEventType.goal, player: 'a')])
        .copyWith(
          unfair: {'b'},
          values: {'a': 1},
          motm: 'a',
          serverCreated: true,
          syncStatus: SyncStatus.offline,
          clock: const LiveClock(accMs: 5, runAtMs: 10),
        );
    final restored = LiveMatchStateDto.fromJson(
      LiveMatchStateDto.fromEntity(m).toJson(),
    ).toEntity();
    expect(restored, m);
  });
}
