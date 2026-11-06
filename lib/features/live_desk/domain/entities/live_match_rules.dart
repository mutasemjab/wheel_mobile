import 'package:equatable/equatable.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/utils/match_clock.dart';
import 'live_match_state.dart';

/// Per-player tallies derived from events.
final class PlayerTally extends Equatable {
  const PlayerTally({
    this.g = 0,
    this.a = 0,
    this.s = 0,
    this.t = 0,
    this.c = 0,
  });

  final int g, a, s, t, c;

  PlayerTally add({int g = 0, int a = 0, int s = 0, int t = 0, int c = 0}) =>
      PlayerTally(
        g: this.g + g,
        a: this.a + a,
        s: this.s + s,
        t: this.t + t,
        c: this.c + c,
      );

  @override
  List<Object?> get props => [g, a, s, t, c];
}

/// Pure state transitions for the live desk (and the finished-match editor).
/// Every transition returns a sanitised state; the bloc only orchestrates.
extension LiveMatchRules on LiveMatchState {
  static const int maxPlayers = 40;
  static const int maxEvents = 300;

  Map<String, PlayerTally> get tallies {
    final out = <String, PlayerTally>{};
    void bump(String? slug, PlayerTally Function(PlayerTally t) f) {
      if (slug == null) return;
      out[slug] = f(out[slug] ?? const PlayerTally());
    }

    for (final e in events) {
      switch (e.type) {
        case LiveEventType.goal:
          bump(e.player, (t) => t.add(g: 1));
          bump(e.assist, (t) => t.add(a: 1));
        case LiveEventType.save:
          bump(e.player, (t) => t.add(s: 1));
        case LiveEventType.tackle:
          bump(e.player, (t) => t.add(t: 1));
        case LiveEventType.against:
          bump(e.player, (t) => t.add(c: 1));
        case LiveEventType.og:
          break;
      }
    }
    return out;
  }

  bool get canAddEvent => events.length < maxEvents;

  /// Same rules as the server:
  /// excused ∩ played removed from excused; flags/values only for played;
  /// scorer/assist must be in played; assist ≠ scorer; `og` has no player;
  /// at most [maxPlayers] players and [maxEvents] events.
  LiveMatchState sanitized() {
    final playedList = _unique(played).take(maxPlayers).toList();
    final playedSet = playedList.toSet();
    final excusedList = _unique(excused)
        .where((s) => !playedSet.contains(s))
        .take(maxPlayers - playedList.length)
        .toList();
    String? inPlayed(String? slug) =>
        slug != null && playedSet.contains(slug) ? slug : null;

    final cleanEvents = <LiveEvent>[];
    for (final e in events) {
      final player = inPlayed(e.player);
      switch (e.type) {
        case LiveEventType.og:
          cleanEvents.add(e.copyWith(player: null, assist: null));
        case LiveEventType.against:
          cleanEvents.add(e.copyWith(player: player, assist: null));
        case LiveEventType.goal:
          if (player == null) continue;
          final assist = inPlayed(e.assist);
          cleanEvents.add(
            e.copyWith(
              player: player,
              assist: assist == player ? null : assist,
            ),
          );
        case LiveEventType.save:
        case LiveEventType.tackle:
          if (player == null) continue;
          cleanEvents.add(e.copyWith(player: player, assist: null));
      }
      if (cleanEvents.length >= maxEvents) break;
    }

    return copyWith(
      played: playedList,
      excused: excusedList,
      unfair: unfair.where(playedSet.contains).toSet(),
      late: late.where(playedSet.contains).toSet(),
      values: {
        for (final entry in values.entries)
          if (playedSet.contains(entry.key) && entry.value > 0)
            entry.key: entry.value,
      },
      motm: inPlayed(motm),
      events: cleanEvents,
    );
  }

  LiveMatchState addEvent(LiveEvent event) =>
      canAddEvent ? copyWith(events: [...events, event]).sanitized() : this;

  LiveMatchState updateEvent(LiveEvent event) => copyWith(
    events: [for (final e in events) e.uuid == event.uuid ? event : e],
  ).sanitized();

  LiveMatchState removeEvent(String uuid) =>
      copyWith(events: events.where((e) => e.uuid != uuid).toList());

  /// Removes the newest event; returns the new state and the removed event.
  (LiveMatchState, LiveEvent?) undo() => events.isEmpty
      ? (this, null)
      : (copyWith(events: events.sublist(0, events.length - 1)), events.last);

  LiveMatchState setMotm(String? slug) => copyWith(motm: slug).sanitized();

  LiveMatchState changeValues(String slug, int delta) {
    final next = (values[slug] ?? 0) + delta;
    return copyWith(values: {...values, slug: next < 0 ? 0 : next}).sanitized();
  }

  LiveMatchState toggleUnfair(String slug) =>
      copyWith(unfair: _toggle(unfair, slug)).sanitized();

  LiveMatchState toggleLate(String slug) =>
      copyWith(late: _toggle(late, slug)).sanitized();

  /// Emergency player: moves a not-called/excused player into played.
  LiveMatchState addEmergencyPlayer(String slug) => played.contains(slug)
      ? this
      : copyWith(
          played: [...played, slug],
          excused: excused.where((s) => s != slug).toList(),
        ).sanitized();

  /// Elapsed running time at [serverNowMs].
  int elapsedMs(int serverNowMs) => MatchClock.elapsedMs(
    accMs: clock.accMs,
    runAtMs: clock.runAtMs,
    deviceNowMs: serverNowMs,
  );

  /// Minute for a new event; null when the clock never started.
  int? minuteAt(int serverNowMs) =>
      clock.everStarted ? MatchClock.minuteFor(elapsedMs(serverNowMs)) : null;

  LiveMatchState startClock(int serverNowMs) => clock.isRunning
      ? this
      : copyWith(clock: clock.copyWith(runAtMs: serverNowMs));

  LiveMatchState pauseClock(int serverNowMs) => clock.isRunning
      ? copyWith(clock: LiveClock(accMs: elapsedMs(serverNowMs)))
      : this;

  static Set<String> _toggle(Set<String> set, String slug) =>
      set.contains(slug) ? ({...set}..remove(slug)) : {...set, slug};

  static Iterable<String> _unique(List<String> list) => list.toSet();
}
