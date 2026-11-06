import 'package:equatable/equatable.dart';

/// Server clock state (`clock: { acc_ms, run_at_ms, server_now_ms }`).
final class ClockSnapshot extends Equatable {
  const ClockSnapshot({this.accMs = 0, this.runAtMs, this.serverNowMs});

  final int accMs;
  final int? runAtMs;
  final int? serverNowMs;

  bool get isRunning => runAtMs != null;

  @override
  List<Object?> get props => [accMs, runAtMs, serverNowMs];
}
