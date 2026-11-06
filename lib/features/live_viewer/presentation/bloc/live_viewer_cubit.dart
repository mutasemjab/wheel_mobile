import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/match_clock.dart';
import '../../../players/domain/usecases/get_players.dart';
import '../../domain/entities/live_match.dart';
import '../../domain/usecases/get_live_match.dart';

enum LiveViewerStatus { loading, live, idle, failure }

final class LiveViewerState extends Equatable {
  const LiveViewerState({
    this.status = LiveViewerStatus.loading,
    this.match,
    this.offsetMs = 0,
    this.nowMs = 0,
    this.names = const {},
    this.failure,
  });

  final LiveViewerStatus status;
  final LiveMatch? match;

  /// `server_now_ms - deviceNowMs` from the latest response.
  final int offsetMs;

  /// Device time of the last tick; drives the on-device clock.
  final int nowMs;

  /// slug → display name.
  final Map<String, String> names;
  final Failure? failure;

  String nameOf(String slug) => names[slug] ?? slug;

  MatchClockReading? get clock {
    final m = match;
    if (m == null) return null;
    return MatchClock.read(
      accMs: m.clock.accMs,
      runAtMs: m.clock.runAtMs,
      deviceNowMs: nowMs,
      offsetMs: offsetMs,
    );
  }

  LiveViewerState copyWith({
    LiveViewerStatus? status,
    LiveMatch? match,
    bool clearMatch = false,
    int? offsetMs,
    int? nowMs,
    Map<String, String>? names,
    Failure? failure,
    bool clearFailure = false,
  }) => LiveViewerState(
    status: status ?? this.status,
    match: clearMatch ? null : match ?? this.match,
    offsetMs: offsetMs ?? this.offsetMs,
    nowMs: nowMs ?? this.nowMs,
    names: names ?? this.names,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [status, match, offsetMs, nowMs, names, failure];
}

/// Public live match: polls `/live` every 5 s (and on `live_updated_at`
/// changes) and ticks the clock every second on device.
class LiveViewerCubit extends Cubit<LiveViewerState> {
  LiveViewerCubit(
    this._getLive, {
    GetPlayers? getPlayers,
    Stream<void>? liveChanges,
    int Function()? now,
    this.pollInterval = defaultPollInterval,
    this.tickInterval = defaultTickInterval,
  }) : _getPlayers = getPlayers,
       _now = now ?? _deviceNow,
       super(const LiveViewerState()) {
    _changes = liveChanges?.listen((_) => refresh());
  }

  static const Duration defaultPollInterval = Duration(seconds: 5);
  static const Duration defaultTickInterval = Duration(seconds: 1);

  static int _deviceNow() => DateTime.now().millisecondsSinceEpoch;

  final GetLiveMatch _getLive;
  final GetPlayers? _getPlayers;
  final int Function() _now;
  final Duration pollInterval;
  final Duration tickInterval;

  StreamSubscription<void>? _changes;
  Timer? _poll;
  Timer? _tick;

  Future<void> start() async {
    _poll ??= Timer.periodic(pollInterval, (_) => refresh());
    _tick ??= Timer.periodic(tickInterval, (_) => _onTick());
    await Future.wait([refresh(), _loadNames()]);
  }

  void stop() {
    _poll?.cancel();
    _tick?.cancel();
    _poll = null;
    _tick = null;
  }

  Future<void> _loadNames() async {
    final getPlayers = _getPlayers;
    if (getPlayers == null) return;
    final directory = await getPlayers.directory();
    if (isClosed || directory.isEmpty) return;
    emit(state.copyWith(names: directory.map((k, v) => MapEntry(k, v.name))));
  }

  Future<void> refresh() async {
    final result = await _getLive();
    if (isClosed) return;
    final deviceNow = _now();
    switch (result) {
      case Success(value: final match?):
        final serverNow = match.clock.serverNowMs;
        emit(
          state.copyWith(
            status: LiveViewerStatus.live,
            match: match,
            offsetMs: serverNow == null
                ? state.offsetMs
                : MatchClock.offset(
                    serverNowMs: serverNow,
                    deviceNowMs: deviceNow,
                  ),
            nowMs: deviceNow,
            clearFailure: true,
          ),
        );
      case Success():
        emit(
          state.copyWith(
            status: LiveViewerStatus.idle,
            clearMatch: true,
            nowMs: deviceNow,
            clearFailure: true,
          ),
        );
      case Err(:final failure):
        emit(
          state.copyWith(
            status: state.match == null
                ? LiveViewerStatus.failure
                : state.status,
            failure: failure,
          ),
        );
    }
  }

  void _onTick() {
    if (isClosed || state.match == null) return;
    emit(state.copyWith(nowMs: _now()));
  }

  @override
  Future<void> close() async {
    stop();
    await _changes?.cancel();
    return super.close();
  }
}
