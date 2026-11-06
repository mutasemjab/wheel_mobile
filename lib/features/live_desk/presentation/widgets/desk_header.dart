import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/match_clock.dart';
import '../../../../core/widgets/live_scoreboard.dart';
import '../../../../core/widgets/ticker_builder.dart';
import '../../domain/entities/live_match_state.dart';

/// Scoreboard (score derived from local events) + start/pause button.
class DeskHeader extends StatelessWidget {
  const DeskHeader({
    super.key,
    required this.match,
    required this.offsetMs,
    required this.onToggleClock,
  });

  final LiveMatchState match;
  final int offsetMs;
  final VoidCallback? onToggleClock;

  @override
  Widget build(BuildContext context) {
    final running = match.clock.isRunning;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TickerBuilder(
          builder: (context, nowMs) => LiveScoreboard(
            opponent: match.opponent,
            us: match.scoreUs,
            them: match.scoreThem,
            clock: MatchClock.read(
              accMs: match.clock.accMs,
              runAtMs: match.clock.runAtMs,
              deviceNowMs: nowMs,
              offsetMs: offsetMs,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          onPressed: onToggleClock,
          icon: Icon(running ? Icons.pause_rounded : Icons.play_arrow_rounded),
          label: Text(
            running ? context.l10n.clockPause : context.l10n.clockStart,
          ),
        ),
      ],
    );
  }
}
