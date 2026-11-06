import '../../../../core/entities/enums.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/json_parsing.dart';
import '../../domain/entities/live_match_rules.dart';
import '../../domain/entities/live_match_state.dart';

/// Request bodies built from a (sanitised) [LiveMatchState].
abstract final class LiveSyncPayload {
  /// `PUT /admin/live/sync`: every key is required (arrays may be empty);
  /// `clock.run_at_ms` is in server time. Also `PUT /admin/matches/{code}`
  /// without the clock and with [note]. Events: full list, oldest → newest.
  static Json sync(
    LiveMatchState state, {
    bool includeClock = true,
    String? note,
  }) {
    final s = state.sanitized();
    return {
      'code': s.code,
      'opponent': s.opponent,
      'date': DateUtilsX.toApi(s.date),
      'played': s.played,
      'excused': s.excused,
      'unfair': s.unfair.toList(),
      'late': s.late.toList(),
      'values': s.values,
      'motm': s.motm,
      if (includeClock)
        'clock': {'acc_ms': s.clock.accMs, 'run_at_ms': s.clock.runAtMs},
      'note': ?note,
      'events': [for (final e in s.events) event(e)],
    };
  }

  static Json event(LiveEvent e) => {
    'uuid': e.uuid,
    'type': e.type.apiName,
    'player': e.type == LiveEventType.og ? null : e.player,
    'assist': e.type == LiveEventType.goal ? e.assist : null,
    'minute': e.minute,
  };
}
