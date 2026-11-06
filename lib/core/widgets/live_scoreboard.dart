import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';
import '../utils/match_clock.dart';

/// "قبل البداية" / "استراحة" / `"12'"`.
String clockLabel(BuildContext context, MatchClockReading reading) =>
    switch (reading.phase) {
      ClockPhase.notStarted => context.l10n.clockNotStarted,
      ClockPhase.paused => context.l10n.clockBreak,
      ClockPhase.running => context.l10n.minuteLabel(reading.minute),
    };

/// Big WHEEL FC vs opponent scoreboard with the on-device clock.
class LiveScoreboard extends StatelessWidget {
  const LiveScoreboard({
    super.key,
    required this.opponent,
    required this.us,
    required this.them,
    required this.clock,
    this.teamName = 'WHEEL FC',
  });

  final String teamName;
  final String opponent;
  final int us;
  final int them;
  final MatchClockReading clock;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final running = clock.phase == ClockPhase.running;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: running ? AppColors.live : AppColors.neutral,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                clockLabel(context, clock),
                style: text.titleSmall?.copyWith(color: Colors.white),
              ),
            ),
            if (clock.phase != ClockPhase.notStarted)
              Text(MatchClock.mmss(clock.elapsedMs), style: text.labelMedium),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    teamName,
                    textAlign: TextAlign.center,
                    style: text.titleMedium,
                  ),
                ),
                Text('$us – $them', style: text.displaySmall),
                Expanded(
                  child: Text(
                    opponent,
                    textAlign: TextAlign.center,
                    style: text.titleMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
