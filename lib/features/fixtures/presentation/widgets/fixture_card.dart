import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/countdown.dart';
import '../../../../core/widgets/ticker_builder.dart';
import '../../domain/entities/fixture.dart';

/// Upcoming match: opponent, date/time, live countdown, venue with a maps link.
class FixtureCard extends StatelessWidget {
  const FixtureCard({super.key, required this.fixture, this.title});

  final Fixture fixture;

  /// Optional heading (e.g. "المباراة القادمة" on the home screen).
  final String? title;

  static const Duration _tick = Duration(seconds: 30);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final muted = text.bodySmall?.copyWith(color: scheme.onSurfaceVariant);
    final maps = fixture.mapsUri;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: text.labelLarge?.copyWith(color: scheme.primary),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Row(
              children: [
                const Icon(Icons.event_rounded),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.liveVs(fixture.opponent),
                        style: text.titleMedium,
                      ),
                      Text('${fixture.date} · ${fixture.time}', style: muted),
                      if (fixture.competition != null)
                        Text(fixture.competition!, style: muted),
                    ],
                  ),
                ),
                _StatusOrCountdown(fixture: fixture, tick: _tick),
              ],
            ),
            if (fixture.location != null || fixture.notes != null) ...[
              const SizedBox(height: AppSpacing.sm),
              if (fixture.location != null)
                Row(
                  children: [
                    Icon(
                      Icons.place_rounded,
                      size: 18,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(fixture.location!, style: muted)),
                  ],
                ),
              if (fixture.notes != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(fixture.notes!, style: muted),
                ),
            ],
            if (maps != null && fixture.isUpcoming) ...[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () =>
                      launchUrl(maps, mode: LaunchMode.externalApplication),
                  icon: const Icon(Icons.map_rounded),
                  label: Text(l10n.openInMaps),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusOrCountdown extends StatelessWidget {
  const _StatusOrCountdown({required this.fixture, required this.tick});

  final Fixture fixture;
  final Duration tick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (fixture.status != FixtureStatus.scheduled) {
      return Chip(
        label: Text(fixture.statusLabel),
        backgroundColor: fixture.status == FixtureStatus.cancelled
            ? AppColors.negative.withValues(alpha: 0.2)
            : AppColors.warning.withValues(alpha: 0.2),
      );
    }
    if (!fixture.isUpcoming) return const SizedBox.shrink();
    return TickerBuilder(
      interval: tick,
      builder: (context, nowMs) {
        final c = Countdown.until(
          fixture.kickoffAt,
          DateTime.fromMillisecondsSinceEpoch(nowMs),
        );
        final label = switch (c.unit) {
          CountdownUnit.started => l10n.countdownStarted,
          CountdownUnit.minutes => l10n.countdownMinutes(c.value),
          CountdownUnit.hours => l10n.countdownHours(c.value),
          CountdownUnit.days => l10n.countdownDays(c.value),
        };
        return Chip(
          label: Text(label),
          backgroundColor: AppColors.accent.withValues(alpha: 0.2),
        );
      },
    );
  }
}
