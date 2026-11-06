import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../network/api_endpoints.dart';
import '../utils/json_parsing.dart';

/// `GET /version` payload.
final class AppVersion extends Equatable {
  const AppVersion({required this.version, this.liveUpdatedAt});

  factory AppVersion.fromJson(Json json) => AppVersion(
    version: asInt(json['version']),
    liveUpdatedAt: asNonEmptyStringOrNull(json['live_updated_at']),
  );

  final int version;
  final String? liveUpdatedAt;

  @override
  List<Object?> get props => [version, liveUpdatedAt];
}

abstract interface class VersionSource {
  Future<AppVersion> fetch();
}

class RemoteVersionSource implements VersionSource {
  RemoteVersionSource(this._dio);

  final Dio _dio;

  @override
  Future<AppVersion> fetch() async {
    final response = await _dio.get<Object?>(ApiEndpoints.version);
    return AppVersion.fromJson(asMap(dataOf(response.data)));
  }
}

/// Polls `/version` while the app is in the foreground and tells listeners
/// when public data or the live match changed.
class VersionPoller {
  VersionPoller(this._source, {this.interval = defaultInterval});

  static const Duration defaultInterval = Duration(seconds: 10);

  final VersionSource _source;
  final Duration interval;

  final StreamController<void> _data = StreamController<void>.broadcast();
  final StreamController<void> _live = StreamController<void>.broadcast();

  Timer? _timer;
  AppVersion? _last;
  bool _inFlight = false;

  /// Public data version changed → refetch viewer screens silently.
  Stream<void> get dataChanges => _data.stream;

  /// `live_updated_at` changed → refetch `/live`.
  Stream<void> get liveChanges => _live.stream;

  /// Either of the above (home shows data and the live banner).
  Stream<void> get anyChanges {
    late final StreamController<void> controller;
    final subscriptions = <StreamSubscription<void>>[];
    controller = StreamController<void>.broadcast(
      onListen: () => subscriptions
        ..add(_data.stream.listen(controller.add))
        ..add(_live.stream.listen(controller.add)),
      onCancel: () async {
        for (final s in subscriptions) {
          await s.cancel();
        }
        subscriptions.clear();
      },
    );
    return controller.stream;
  }

  bool get isRunning => _timer != null;

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(interval, (_) => pollNow());
    pollNow();
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
  }

  void resume() => start();

  /// Polls immediately. When [forceDataRefresh] is set, listeners are
  /// notified even if the version did not change yet.
  Future<void> pollNow({bool forceDataRefresh = false}) async {
    if (forceDataRefresh) {
      _data.add(null);
      _live.add(null);
    }
    if (_inFlight) return;
    _inFlight = true;
    try {
      final next = await _source.fetch();
      final previous = _last;
      _last = next;
      if (previous == null) return;
      if (next.version != previous.version) _data.add(null);
      if (next.liveUpdatedAt != previous.liveUpdatedAt) _live.add(null);
    } on Object {
      // Offline or server error: try again on the next tick.
    } finally {
      _inFlight = false;
    }
  }

  Future<void> dispose() async {
    pause();
    await _data.close();
    await _live.close();
  }
}
