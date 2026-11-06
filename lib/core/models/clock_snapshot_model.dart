import '../entities/clock_snapshot.dart';
import '../utils/json_parsing.dart';

class ClockSnapshotModel {
  const ClockSnapshotModel({
    required this.accMs,
    this.runAtMs,
    this.serverNowMs,
  });

  /// `acc_ms` may be null right after creating a match → 0.
  factory ClockSnapshotModel.fromJson(dynamic json) {
    final map = asMap(json);
    return ClockSnapshotModel(
      accMs: asInt(map['acc_ms']),
      runAtMs: asIntOrNull(map['run_at_ms']),
      serverNowMs: asIntOrNull(map['server_now_ms']),
    );
  }

  final int accMs;
  final int? runAtMs;
  final int? serverNowMs;

  ClockSnapshot toEntity() =>
      ClockSnapshot(accMs: accMs, runAtMs: runAtMs, serverNowMs: serverNowMs);
}
