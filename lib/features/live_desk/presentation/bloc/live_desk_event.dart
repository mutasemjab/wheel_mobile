part of 'live_desk_bloc.dart';

sealed class LiveDeskEvent extends Equatable {
  const LiveDeskEvent();

  @override
  List<Object?> get props => [];
}

/// Desk opened: restore local state, then reconcile with the server.
final class LiveDeskOpened extends LiveDeskEvent {
  const LiveDeskOpened();
}

final class LiveDeskSetupSubmitted extends LiveDeskEvent {
  const LiveDeskSetupSubmitted({
    required this.opponent,
    required this.date,
    required this.played,
    required this.excused,
  });

  final String opponent;
  final DateTime date;
  final List<String> played;
  final List<String> excused;

  @override
  List<Object?> get props => [opponent, date, played, excused];
}

/// "في مباراة شغالة — تكمل عليها؟" → resume the server match.
final class LiveDeskConflictResumed extends LiveDeskEvent {
  const LiveDeskConflictResumed();
}

/// … → discard the server match (`DELETE /admin/live`).
final class LiveDeskConflictDiscarded extends LiveDeskEvent {
  const LiveDeskConflictDiscarded();
}

final class LiveDeskClockToggled extends LiveDeskEvent {
  const LiveDeskClockToggled();
}

/// `server_now_ms` from a clock reply; refreshes the device↔server offset.
final class LiveDeskServerTimeReceived extends LiveDeskEvent {
  const LiveDeskServerTimeReceived(this.serverNowMs);

  final int serverNowMs;

  @override
  List<Object?> get props => [serverNowMs];
}

final class LiveDeskEventAdded extends LiveDeskEvent {
  const LiveDeskEventAdded(this.type, {this.player, this.assist});

  final LiveEventType type;
  final String? player;
  final String? assist;

  @override
  List<Object?> get props => [type, player, assist];
}

final class LiveDeskEventEdited extends LiveDeskEvent {
  const LiveDeskEventEdited(this.event);

  final LiveEvent event;

  @override
  List<Object?> get props => [event];
}

final class LiveDeskEventRemoved extends LiveDeskEvent {
  const LiveDeskEventRemoved(this.uuid);

  final String uuid;

  @override
  List<Object?> get props => [uuid];
}

final class LiveDeskUndoRequested extends LiveDeskEvent {
  const LiveDeskUndoRequested();
}

final class LiveDeskRedoRequested extends LiveDeskEvent {
  const LiveDeskRedoRequested();
}

final class LiveDeskMotmChanged extends LiveDeskEvent {
  const LiveDeskMotmChanged(this.slug);

  final String? slug;

  @override
  List<Object?> get props => [slug];
}

final class LiveDeskValuesChanged extends LiveDeskEvent {
  const LiveDeskValuesChanged(this.slug, this.delta);

  final String slug;
  final int delta;

  @override
  List<Object?> get props => [slug, delta];
}

final class LiveDeskUnfairToggled extends LiveDeskEvent {
  const LiveDeskUnfairToggled(this.slug);

  final String slug;

  @override
  List<Object?> get props => [slug];
}

final class LiveDeskLateToggled extends LiveDeskEvent {
  const LiveDeskLateToggled(this.slug);

  final String slug;

  @override
  List<Object?> get props => [slug];
}

final class LiveDeskEmergencyPlayerAdded extends LiveDeskEvent {
  const LiveDeskEmergencyPlayerAdded(this.slug);

  final String slug;

  @override
  List<Object?> get props => [slug];
}

/// Debounced full-state sync (also used for retries).
final class LiveDeskSyncRequested extends LiveDeskEvent {
  const LiveDeskSyncRequested();
}

final class LiveDeskConnectivityChanged extends LiveDeskEvent {
  const LiveDeskConnectivityChanged({required this.online});

  final bool online;

  @override
  List<Object?> get props => [online];
}

final class LiveDeskFinishRequested extends LiveDeskEvent {
  const LiveDeskFinishRequested({this.motm});

  final String? motm;

  @override
  List<Object?> get props => [motm];
}

final class LiveDeskPublishRequested extends LiveDeskEvent {
  const LiveDeskPublishRequested();
}

final class LiveDeskDiscardRequested extends LiveDeskEvent {
  const LiveDeskDiscardRequested();
}
