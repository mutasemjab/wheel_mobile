part of 'live_desk_bloc.dart';

enum LiveDeskStatus {
  initial,
  loading,

  /// No match yet: show the setup form.
  setup,

  /// A different live match exists on the server: ask resume / discard.
  conflict,
  active,

  /// Waiting for the last sync + `POST /finish`.
  finishing,
  finished,
  publishing,
  published,
}

final class LiveDeskState extends Equatable {
  const LiveDeskState({
    this.status = LiveDeskStatus.initial,
    this.match,
    this.roster = const [],
    this.redo = const [],
    this.offsetMs = 0,
    this.conflict,
    this.failure,
    this.publishedCode,
    this.finalSummary,
    this.revision = 0,
    this.lastUndone,
  });

  final LiveDeskStatus status;
  final LiveMatchState? match;

  /// Players available for the squad (names, photos, GK flag).
  final List<Player> roster;

  /// Undone events, most recent last.
  final List<LiveEvent> redo;

  /// `serverNow - deviceNow`.
  final int offsetMs;
  final ServerLiveMatch? conflict;

  /// Transient: shown once as a SnackBar, cleared by the next state.
  final Failure? failure;
  final String? publishedCode;
  final String? finalSummary;

  /// Bumped on every local change; lets the sync detect newer edits.
  final int revision;

  /// Set right after an undo so the UI can offer "رجّعها".
  final LiveEvent? lastUndone;

  Map<String, Player> get rosterBySlug => {for (final p in roster) p.slug: p};

  String nameOf(String slug) => rosterBySlug[slug]?.name ?? slug;

  LiveDeskState copyWith({
    LiveDeskStatus? status,
    LiveMatchState? match,
    bool clearMatch = false,
    List<Player>? roster,
    List<LiveEvent>? redo,
    int? offsetMs,
    ServerLiveMatch? conflict,
    bool clearConflict = false,
    Failure? failure,
    String? publishedCode,
    String? finalSummary,
    int? revision,
    LiveEvent? lastUndone,
  }) => LiveDeskState(
    status: status ?? this.status,
    match: clearMatch ? null : match ?? this.match,
    roster: roster ?? this.roster,
    redo: redo ?? this.redo,
    offsetMs: offsetMs ?? this.offsetMs,
    conflict: clearConflict ? null : conflict ?? this.conflict,
    failure: failure,
    publishedCode: publishedCode ?? this.publishedCode,
    finalSummary: finalSummary ?? this.finalSummary,
    revision: revision ?? this.revision,
    lastUndone: lastUndone,
  );

  @override
  List<Object?> get props => [
    status,
    match,
    roster,
    redo,
    offsetMs,
    conflict,
    failure,
    publishedCode,
    finalSummary,
    revision,
    lastUndone,
  ];
}
