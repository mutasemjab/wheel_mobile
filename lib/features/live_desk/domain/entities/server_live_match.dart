import 'package:equatable/equatable.dart';

import '../../../../core/entities/clock_snapshot.dart';
import 'live_match_state.dart';

enum SquadStatus { played, excused }

final class SquadEntry extends Equatable {
  const SquadEntry({
    required this.slug,
    required this.name,
    required this.status,
    this.unfair = false,
    this.late = false,
    this.valuesCount = 0,
  });

  final String slug;
  final String name;
  final SquadStatus status;
  final bool unfair;
  final bool late;
  final int valuesCount;

  @override
  List<Object?> get props => [slug, name, status, unfair, late, valuesCount];
}

/// `GET /admin/live` → `data` (also returned by `PUT /admin/live/sync`).
final class ServerLiveMatch extends Equatable {
  const ServerLiveMatch({
    required this.code,
    required this.date,
    required this.opponent,
    this.squad = const [],
    this.events = const [],
    this.clock = const ClockSnapshot(),
    this.motm,
  });

  final String code;
  final DateTime date;
  final String opponent;
  final List<SquadEntry> squad;

  /// Oldest → newest (already sorted by `sort`).
  final List<LiveEvent> events;
  final ClockSnapshot clock;
  final String? motm;

  /// Server state as a fresh local state (used when resuming).
  LiveMatchState toLocal() => LiveMatchState(
    code: code,
    opponent: opponent,
    date: date,
    played: [
      for (final s in squad)
        if (s.status == SquadStatus.played) s.slug,
    ],
    excused: [
      for (final s in squad)
        if (s.status == SquadStatus.excused) s.slug,
    ],
    unfair: {
      for (final s in squad)
        if (s.unfair) s.slug,
    },
    late: {
      for (final s in squad)
        if (s.late) s.slug,
    },
    values: {
      for (final s in squad)
        if (s.valuesCount > 0) s.slug: s.valuesCount,
    },
    motm: motm,
    clock: LiveClock(accMs: clock.accMs, runAtMs: clock.runAtMs),
    events: events,
    syncStatus: SyncStatus.synced,
    serverCreated: true,
  );

  /// Where the server's sanitised copy differs from [local] (for logging
  /// only — the phone stays the source of truth during the match).
  List<String> differencesFrom(LiveMatchState local) {
    final mine = toLocal();
    final localIds = {for (final e in local.events) e.uuid};
    final serverIds = {for (final e in events) e.uuid};
    return [
      if (code != local.code) 'code: ${local.code} → $code',
      if (!_sameSet(mine.played, local.played)) 'played differs',
      if (!_sameSet(mine.excused, local.excused)) 'excused differs',
      if (motm != local.motm) 'motm: ${local.motm} → $motm',
      if (localIds.difference(serverIds).isNotEmpty)
        'events dropped: ${localIds.difference(serverIds).join(', ')}',
      if (serverIds.difference(localIds).isNotEmpty)
        'events unknown locally: ${serverIds.difference(localIds).join(', ')}',
      for (final e in events)
        for (final l in local.events)
          if (l.uuid == e.uuid &&
              (l.player != e.player || l.assist != e.assist))
            'event ${e.uuid} changed',
    ];
  }

  static bool _sameSet(Iterable<String> a, Iterable<String> b) {
    final sa = a.toSet();
    final sb = b.toSet();
    return sa.length == sb.length && sa.containsAll(sb);
  }

  @override
  List<Object?> get props => [code, date, opponent, squad, events, clock, motm];
}

/// `POST /admin/live/finish` → `data`.
final class LiveFinishResult extends Equatable {
  const LiveFinishResult({
    required this.scoreUs,
    required this.scoreThem,
    required this.summary,
    this.motm,
  });

  final int scoreUs;
  final int scoreThem;
  final String summary;
  final String? motm;

  @override
  List<Object?> get props => [scoreUs, scoreThem, summary, motm];
}
