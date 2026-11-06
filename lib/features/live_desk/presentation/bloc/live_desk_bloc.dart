import 'dart:async';
import 'dart:math';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/entities/clock_snapshot.dart';
import '../../../../core/entities/enums.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../players/domain/entities/player.dart';
import '../../../players/domain/usecases/get_players.dart';
import '../../domain/entities/live_match_rules.dart';
import '../../domain/entities/live_match_state.dart';
import '../../domain/entities/match_code.dart';
import '../../domain/entities/server_live_match.dart';
import '../../domain/usecases/clear_local_live_match.dart';
import '../../domain/usecases/discard_live_match.dart';
import '../../domain/usecases/finish_live_match.dart';
import '../../domain/usecases/get_server_live_match.dart';
import '../../domain/usecases/load_local_live_match.dart';
import '../../domain/usecases/publish_live_match.dart';
import '../../domain/usecases/save_local_live_match.dart';
import '../../domain/usecases/send_clock_hint.dart';
import '../../domain/usecases/sync_live_match.dart';

part 'live_desk_event.dart';
part 'live_desk_state.dart';

/// Use cases needed by the desk, grouped to keep the constructor readable.
final class LiveDeskUseCases {
  const LiveDeskUseCases({
    required this.getServerMatch,
    required this.syncMatch,
    required this.sendClock,
    required this.finishMatch,
    required this.publishMatch,
    required this.discardMatch,
    required this.loadLocal,
    required this.saveLocal,
    required this.clearLocal,
    required this.getPlayers,
  });

  final GetServerLiveMatch getServerMatch;
  final SyncLiveMatch syncMatch;
  final SendClockHint sendClock;
  final FinishLiveMatch finishMatch;
  final PublishLiveMatch publishMatch;
  final DiscardLiveMatch discardMatch;
  final LoadLocalLiveMatch loadLocal;
  final SaveLocalLiveMatch saveLocal;
  final ClearLocalLiveMatch clearLocal;
  final GetPlayers getPlayers;
}

/// Offline-first live match desk. The phone is the source of truth; every
/// local change is persisted, then pushed with a debounced full-state
/// `PUT /admin/live/sync` (which also creates the live match). Syncs never
/// overlap and are retried every 4 s.
class LiveDeskBloc extends Bloc<LiveDeskEvent, LiveDeskState> {
  LiveDeskBloc(
    this._uc, {
    Stream<bool>? connectivity,
    Future<void> Function()? onPublished,
    void Function(String message)? onServerDiff,
    String Function()? newId,
    int Function()? now,
    Random? random,
    this.syncDebounce = defaultSyncDebounce,
    this.retryDelay = defaultRetryDelay,
  }) : _onPublished = onPublished,
       _onServerDiff = onServerDiff,
       _newId = newId ?? const Uuid().v4,
       _now = now ?? _deviceNow,
       _random = random,
       super(const LiveDeskState()) {
    on<LiveDeskOpened>(_onOpened, transformer: droppable());
    on<LiveDeskSetupSubmitted>(_onSetup, transformer: droppable());
    on<LiveDeskConflictResumed>(_onConflictResumed, transformer: droppable());
    on<LiveDeskConflictDiscarded>(
      _onConflictDiscarded,
      transformer: droppable(),
    );
    on<LiveDeskClockToggled>(_onClockToggled, transformer: sequential());
    on<LiveDeskServerTimeReceived>(_onServerTime);
    on<LiveDeskEventAdded>(_onEventAdded, transformer: sequential());
    on<LiveDeskEventEdited>(
      (e, emit) => _mutate(emit, (m) => m.updateEvent(e.event)),
    );
    on<LiveDeskEventRemoved>(
      (e, emit) => _mutate(emit, (m) => m.removeEvent(e.uuid)),
    );
    on<LiveDeskUndoRequested>(_onUndo, transformer: sequential());
    on<LiveDeskRedoRequested>(_onRedo, transformer: sequential());
    on<LiveDeskMotmChanged>(
      (e, emit) => _mutate(emit, (m) => m.setMotm(e.slug)),
    );
    on<LiveDeskValuesChanged>(
      (e, emit) => _mutate(emit, (m) => m.changeValues(e.slug, e.delta)),
    );
    on<LiveDeskUnfairToggled>(
      (e, emit) => _mutate(emit, (m) => m.toggleUnfair(e.slug)),
    );
    on<LiveDeskLateToggled>(
      (e, emit) => _mutate(emit, (m) => m.toggleLate(e.slug)),
    );
    on<LiveDeskEmergencyPlayerAdded>(
      (e, emit) => _mutate(emit, (m) => m.addEmergencyPlayer(e.slug)),
    );
    on<LiveDeskSyncRequested>(_onSync, transformer: _debounced(syncDebounce));
    on<LiveDeskConnectivityChanged>(_onConnectivity);
    on<LiveDeskFinishRequested>(_onFinish, transformer: droppable());
    on<LiveDeskPublishRequested>(_onPublish, transformer: droppable());
    on<LiveDeskDiscardRequested>(_onDiscard, transformer: droppable());
    _connectivity = connectivity?.listen(
      (online) => add(LiveDeskConnectivityChanged(online: online)),
    );
  }

  static const Duration defaultSyncDebounce = Duration(milliseconds: 350);
  static const Duration defaultRetryDelay = Duration(seconds: 4);
  static const int _finishSyncAttempts = 3;

  static int _deviceNow() => DateTime.now().millisecondsSinceEpoch;

  /// Debounce, then handle one at a time (a sync never overlaps another).
  static EventTransformer<E> _debounced<E>(Duration duration) =>
      (events, mapper) => events.debounce(duration).asyncExpand(mapper);

  final LiveDeskUseCases _uc;
  final Future<void> Function()? _onPublished;
  final void Function(String message)? _onServerDiff;
  final String Function() _newId;
  final int Function() _now;
  final Random? _random;
  final Duration syncDebounce;
  final Duration retryDelay;

  StreamSubscription<bool>? _connectivity;
  Timer? _retryTimer;
  Future<void> _syncQueue = Future.value();
  Failure? _lastSyncFailure;

  int get _serverNow => _now() + state.offsetMs;

  // ───────────────────────── lifecycle ─────────────────────────

  Future<void> _onOpened(
    LiveDeskOpened event,
    Emitter<LiveDeskState> emit,
  ) async {
    emit(state.copyWith(status: LiveDeskStatus.loading));
    final roster = await _loadRoster();
    final local = await _uc.loadLocal();
    final server = await _uc.getServerMatch();
    if (local == null) {
      emit(switch (server) {
        Success(value: final s?) => state.copyWith(
          status: LiveDeskStatus.conflict,
          conflict: s,
          roster: roster,
          offsetMs: _offsetFrom(s.clock),
        ),
        _ => state.copyWith(status: LiveDeskStatus.setup, roster: roster),
      });
      return;
    }
    // Local state wins: show it immediately, then reconcile.
    emit(
      state.copyWith(
        status: local.finished
            ? LiveDeskStatus.finished
            : LiveDeskStatus.active,
        match: local,
        roster: roster,
      ),
    );
    switch (server) {
      case Success(value: final s?) when s.code == local.code:
        final known = local.copyWith(serverCreated: true);
        emit(state.copyWith(match: known, offsetMs: _offsetFrom(s.clock)));
        await _uc.saveLocal(known);
        if (known.syncStatus != SyncStatus.synced) {
          add(const LiveDeskSyncRequested());
        }
      case Success(value: final s?):
        emit(state.copyWith(status: LiveDeskStatus.conflict, conflict: s));
      case Success():
        if (!local.finished) {
          // Nothing live on the server: the next sync re-creates it.
          final pending = local.copyWith(
            serverCreated: false,
            syncStatus: SyncStatus.pending,
          );
          emit(state.copyWith(match: pending));
          await _uc.saveLocal(pending);
          add(const LiveDeskSyncRequested());
        }
      case Err():
        add(const LiveDeskSyncRequested());
    }
  }

  Future<List<Player>> _loadRoster() async {
    final remote = await _uc.getPlayers();
    if (remote case Success(:final value)) return value;
    return (await _uc.getPlayers(fromCache: true)).valueOrNull ?? const [];
  }

  int _offsetFrom(ClockSnapshot? clock) {
    final serverNow = clock?.serverNowMs;
    if (serverNow == null || serverNow <= 0) return state.offsetMs;
    return serverNow - _now();
  }

  /// Setup → save locally → sync (the sync creates the live match).
  Future<void> _onSetup(
    LiveDeskSetupSubmitted event,
    Emitter<LiveDeskState> emit,
  ) async {
    if (event.played.toSet().length < 2) return;
    final match = LiveMatchState(
      code: MatchCode.generate(event.date, _random),
      opponent: event.opponent.trim(),
      date: event.date,
      played: event.played,
      excused: event.excused,
    ).sanitized();
    emit(
      state.copyWith(
        status: LiveDeskStatus.active,
        match: match,
        redo: const [],
        revision: state.revision + 1,
      ),
    );
    await _uc.saveLocal(match);
    add(const LiveDeskSyncRequested());
  }

  /// "تكمل عليها؟" → replace local state with the server's.
  Future<void> _onConflictResumed(
    LiveDeskConflictResumed event,
    Emitter<LiveDeskState> emit,
  ) async {
    final server = state.conflict;
    if (server == null) return;
    final local = server.toLocal();
    emit(
      state.copyWith(
        status: LiveDeskStatus.active,
        match: local,
        clearConflict: true,
        redo: const [],
        offsetMs: _offsetFrom(server.clock),
        revision: state.revision + 1,
      ),
    );
    await _uc.saveLocal(local);
  }

  /// Discard: with a different live match on the server, delete it and sync
  /// ours again. When our code was already published (no server match),
  /// the local copy is dropped.
  Future<void> _onConflictDiscarded(
    LiveDeskConflictDiscarded event,
    Emitter<LiveDeskState> emit,
  ) async {
    final pending = state.match;
    if (state.conflict == null) {
      await _uc.clearLocal();
      emit(
        state.copyWith(
          status: LiveDeskStatus.setup,
          clearMatch: true,
          redo: const [],
          revision: state.revision + 1,
        ),
      );
      return;
    }
    final result = await _uc.discardMatch();
    if (result case Err(:final failure) when failure is! NotFoundFailure) {
      emit(state.copyWith(failure: failure));
      return;
    }
    if (pending == null) {
      emit(state.copyWith(status: LiveDeskStatus.setup, clearConflict: true));
      return;
    }
    final resend = pending.copyWith(
      serverCreated: false,
      syncStatus: SyncStatus.pending,
    );
    emit(
      state.copyWith(
        status: LiveDeskStatus.active,
        match: resend,
        clearConflict: true,
      ),
    );
    await _uc.saveLocal(resend);
    add(const LiveDeskSyncRequested());
  }

  // ───────────────────────── local edits ─────────────────────────

  /// Applies a pure change, persists it, and schedules a sync.
  Future<void> _mutate(
    Emitter<LiveDeskState> emit,
    LiveMatchState Function(LiveMatchState match) change, {
    List<LiveEvent>? redo,
    LiveEvent? lastUndone,
  }) async {
    final current = state.match;
    if (current == null ||
        current.finished ||
        state.status != LiveDeskStatus.active) {
      return;
    }
    final changed = change(current);
    if (changed == current) return;
    final next = changed.copyWith(
      syncStatus: current.syncStatus == SyncStatus.offline
          ? SyncStatus.offline
          : SyncStatus.pending,
    );
    emit(
      state.copyWith(
        match: next,
        redo: redo ?? state.redo,
        revision: state.revision + 1,
        lastUndone: lastUndone,
      ),
    );
    await _uc.saveLocal(next);
    add(const LiveDeskSyncRequested());
  }

  Future<void> _onClockToggled(
    LiveDeskClockToggled event,
    Emitter<LiveDeskState> emit,
  ) async {
    final match = state.match;
    if (match == null) return;
    final start = !match.clock.isRunning;
    final serverNow = _serverNow;
    await _mutate(
      emit,
      (m) => start ? m.startClock(serverNow) : m.pauseClock(serverNow),
    );
    // Hint only (the sync carries the clock); its reply refreshes the offset.
    if (match.serverCreated) {
      unawaited(
        _uc.sendClock(start: start).then((result) {
          final serverNowMs = result.valueOrNull?.serverNowMs;
          if (serverNowMs != null && !isClosed) {
            add(LiveDeskServerTimeReceived(serverNowMs));
          }
        }),
      );
    }
  }

  void _onServerTime(
    LiveDeskServerTimeReceived event,
    Emitter<LiveDeskState> emit,
  ) {
    if (event.serverNowMs <= 0) return;
    emit(state.copyWith(offsetMs: event.serverNowMs - _now()));
  }

  Future<void> _onEventAdded(
    LiveDeskEventAdded event,
    Emitter<LiveDeskState> emit,
  ) async {
    final match = state.match;
    if (match == null || !match.canAddEvent) return;
    final live = LiveEvent(
      uuid: _newId(),
      type: event.type,
      player: event.player,
      assist: event.assist,
      minute: match.minuteAt(_serverNow),
    );
    await _mutate(emit, (m) => m.addEvent(live), redo: const []);
  }

  Future<void> _onUndo(
    LiveDeskUndoRequested event,
    Emitter<LiveDeskState> emit,
  ) async {
    final match = state.match;
    if (match == null) return;
    final (next, removed) = match.undo();
    if (removed == null) return;
    await _mutate(
      emit,
      (_) => next,
      redo: [...state.redo, removed],
      lastUndone: removed,
    );
  }

  Future<void> _onRedo(
    LiveDeskRedoRequested event,
    Emitter<LiveDeskState> emit,
  ) async {
    if (state.redo.isEmpty) return;
    final restored = state.redo.last;
    await _mutate(
      emit,
      (m) => m.addEvent(restored),
      redo: state.redo.sublist(0, state.redo.length - 1),
    );
  }

  // ───────────────────────── sync ─────────────────────────

  Future<void> _onSync(
    LiveDeskSyncRequested event,
    Emitter<LiveDeskState> emit,
  ) => _exclusive(() => _syncOnce(emit));

  void _onConnectivity(
    LiveDeskConnectivityChanged event,
    Emitter<LiveDeskState> emit,
  ) {
    final match = state.match;
    if (event.online &&
        match != null &&
        match.syncStatus != SyncStatus.synced) {
      add(const LiveDeskSyncRequested());
    }
  }

  /// Serialises sync work so two requests never overlap.
  Future<T> _exclusive<T>(Future<T> Function() body) {
    final result = _syncQueue.then((_) => body());
    _syncQueue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  /// One full-state sync. Returns true when fully synced.
  Future<bool> _syncOnce(Emitter<LiveDeskState> emit) async {
    _retryTimer?.cancel();
    final match = state.match;
    if (match == null || isClosed || state.status == LiveDeskStatus.conflict) {
      return false;
    }
    if (match.syncStatus == SyncStatus.synced) return true;
    final revision = state.revision;
    final result = await _uc.syncMatch(match);
    if (isClosed) return false;
    switch (result) {
      case Success(:final value):
        _lastSyncFailure = null;
        _reportDifferences(value, match);
        final latest = state.match;
        if (latest == null) return false;
        final offsetMs = _offsetFrom(value?.clock);
        if (state.revision != revision) {
          emit(
            state.copyWith(
              match: latest.copyWith(serverCreated: true),
              offsetMs: offsetMs,
            ),
          );
          add(const LiveDeskSyncRequested());
          return false;
        }
        final synced = latest.copyWith(
          serverCreated: true,
          syncStatus: SyncStatus.synced,
          lastSyncedAt: DateTime.now(),
        );
        emit(state.copyWith(match: synced, offsetMs: offsetMs));
        await _uc.saveLocal(synced);
        return true;
      case Err(failure: ConflictFailure() && final conflict):
        await _resolveConflict(emit, match, conflict);
        return false;
      case Err(:final failure):
        await _markSyncFailure(emit, failure);
        return false;
    }
  }

  /// 409: another live match is running, or our code is already published.
  Future<void> _resolveConflict(
    Emitter<LiveDeskState> emit,
    LiveMatchState match,
    ConflictFailure conflict,
  ) async {
    final server = await _uc.getServerMatch();
    switch (server) {
      case Success(value: final s?) when s.code == match.code:
        await _markSyncFailure(emit, conflict);
      case Success(value: final s?):
        emit(state.copyWith(status: LiveDeskStatus.conflict, conflict: s));
      case Success():
        emit(
          state.copyWith(status: LiveDeskStatus.conflict, clearConflict: true),
        );
      case Err(:final failure):
        await _markSyncFailure(emit, failure);
    }
  }

  void _reportDifferences(ServerLiveMatch? server, LiveMatchState sent) {
    final report = _onServerDiff;
    if (server == null || report == null) return;
    for (final diff in server.differencesFrom(sent.sanitized())) {
      report('live sync: server differs — $diff');
    }
  }

  Future<void> _markSyncFailure(
    Emitter<LiveDeskState> emit,
    Failure failure,
  ) async {
    _lastSyncFailure = failure;
    final match = state.match;
    if (match == null) return;
    final failed = match.copyWith(
      syncStatus: failure is NetworkFailure
          ? SyncStatus.offline
          : SyncStatus.error,
    );
    emit(state.copyWith(match: failed));
    await _uc.saveLocal(failed);
    final retryable = switch (failure) {
      NetworkFailure() ||
      ServerFailure() ||
      RateLimitFailure() ||
      ParsingFailure() ||
      ConflictFailure() => true,
      _ => false,
    };
    if (retryable && !isClosed) {
      _retryTimer = Timer(retryDelay, () {
        if (!isClosed) add(const LiveDeskSyncRequested());
      });
    }
  }

  // ───────────────────────── finish / publish / discard ─────────────────────────

  Future<void> _onFinish(
    LiveDeskFinishRequested event,
    Emitter<LiveDeskState> emit,
  ) async {
    final match = state.match;
    if (match == null || match.finished) return;
    final motm = event.motm ?? match.motm;
    var current = match;
    if (motm != match.motm) {
      current = match.setMotm(motm).copyWith(syncStatus: SyncStatus.pending);
      await _uc.saveLocal(current);
    }
    emit(
      state.copyWith(
        status: LiveDeskStatus.finishing,
        match: current,
        revision: state.revision + 1,
      ),
    );
    var synced = false;
    for (var i = 0; i < _finishSyncAttempts && !synced; i++) {
      synced = await _exclusive(() => _syncOnce(emit));
      if (state.status == LiveDeskStatus.conflict) return;
    }
    if (!synced) {
      emit(
        state.copyWith(
          status: LiveDeskStatus.active,
          failure: _lastSyncFailure ?? const NetworkFailure(),
        ),
      );
      return;
    }
    final result = await _uc.finishMatch(motm: motm);
    switch (result) {
      case Success(:final value):
        // The summary already starts with the real score.
        final finished = state.match!.copyWith(
          finished: true,
          summary: value.summary,
          motm: value.motm ?? motm,
        );
        emit(state.copyWith(status: LiveDeskStatus.finished, match: finished));
        await _uc.saveLocal(finished);
      case Err(:final failure):
        emit(state.copyWith(status: LiveDeskStatus.active, failure: failure));
    }
  }

  Future<void> _onPublish(
    LiveDeskPublishRequested event,
    Emitter<LiveDeskState> emit,
  ) async {
    final match = state.match;
    if (match == null || !match.finished) return;
    emit(state.copyWith(status: LiveDeskStatus.publishing));
    final result = await _uc.publishMatch(motm: match.motm);
    switch (result) {
      case Err(:final failure):
        emit(state.copyWith(status: LiveDeskStatus.finished, failure: failure));
      case Success(:final value):
        _retryTimer?.cancel();
        await _uc.clearLocal();
        await _onPublished?.call();
        emit(
          LiveDeskState(
            status: LiveDeskStatus.published,
            roster: state.roster,
            offsetMs: state.offsetMs,
            publishedCode: value.code.isEmpty ? match.code : value.code,
            finalSummary: match.summary,
            revision: state.revision + 1,
          ),
        );
    }
  }

  Future<void> _onDiscard(
    LiveDeskDiscardRequested event,
    Emitter<LiveDeskState> emit,
  ) async {
    final match = state.match;
    if (match != null && match.serverCreated) {
      final result = await _uc.discardMatch();
      // 404: nothing live on the server any more — fine.
      if (result case Err(:final failure) when failure is! NotFoundFailure) {
        emit(state.copyWith(failure: failure));
        return;
      }
    }
    _retryTimer?.cancel();
    await _uc.clearLocal();
    emit(
      state.copyWith(
        status: LiveDeskStatus.setup,
        clearMatch: true,
        redo: const [],
        revision: state.revision + 1,
      ),
    );
  }

  @override
  Future<void> close() async {
    _retryTimer?.cancel();
    await _connectivity?.cancel();
    return super.close();
  }
}
