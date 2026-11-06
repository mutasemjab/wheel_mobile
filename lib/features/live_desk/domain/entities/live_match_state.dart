import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/enums.dart';

part 'live_match_state.freezed.dart';

enum SyncStatus { synced, pending, offline, error }

/// Local clock. [runAtMs] is in **server time** (deviceNow + offset).
@freezed
abstract class LiveClock with _$LiveClock {
  const factory LiveClock({@Default(0) int accMs, int? runAtMs}) = _LiveClock;

  const LiveClock._();

  bool get isRunning => runAtMs != null;

  bool get everStarted => accMs > 0 || runAtMs != null;
}

/// One live event with a device-generated UUID v4.
@freezed
abstract class LiveEvent with _$LiveEvent {
  const factory LiveEvent({
    required String uuid,
    required LiveEventType type,
    String? player,
    String? assist,
    int? minute,
  }) = _LiveEvent;
}

/// The live match as kept on the phone — the source of truth during the
/// match. Persisted on every change and pushed with `PUT /admin/live/sync`.
@freezed
abstract class LiveMatchState with _$LiveMatchState {
  const factory LiveMatchState({
    required String code,
    required String opponent,
    required DateTime date,
    @Default(<String>[]) List<String> played,
    @Default(<String>[]) List<String> excused,
    @Default(<String>{}) Set<String> unfair,
    @Default(<String>{}) Set<String> late,
    @Default(<String, int>{}) Map<String, int> values,
    String? motm,
    @Default(LiveClock()) LiveClock clock,

    /// Oldest → newest.
    @Default(<LiveEvent>[]) List<LiveEvent> events,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    DateTime? lastSyncedAt,

    /// A sync succeeded for [code]: the server holds this live match.
    @Default(false) bool serverCreated,

    /// `POST /admin/live/finish` succeeded; [summary] holds the WhatsApp text.
    @Default(false) bool finished,
    String? summary,
  }) = _LiveMatchState;

  const LiveMatchState._();

  /// `us = goals + opponent own goals`.
  int get scoreUs => events
      .where((e) => e.type == LiveEventType.goal || e.type == LiveEventType.og)
      .length;

  int get scoreThem =>
      events.where((e) => e.type == LiveEventType.against).length;
}
