import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/event_icon.dart';
import '../../domain/entities/live_match.dart';

/// Events feed, newest first.
class LiveFeed extends StatelessWidget {
  const LiveFeed({super.key, required this.events, required this.nameOf});

  final List<LiveFeedEvent> events;
  final String Function(String slug) nameOf;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final e in events)
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Text(
            eventEmoji(e.type),
            style: const TextStyle(fontSize: 22),
          ),
          title: Text(
            [
              eventLabel(context, e.type),
              if (e.player != null) nameOf(e.player!),
            ].join(' · '),
          ),
          subtitle: e.assist == null
              ? null
              : Text(context.l10n.assistBy(nameOf(e.assist!))),
          trailing: e.minute == null
              ? null
              : Text(context.l10n.minuteLabel(e.minute!)),
        ),
    ],
  );
}

/// Per-player live tallies.
class LivePlayerStatsTable extends StatelessWidget {
  const LivePlayerStatsTable({
    super.key,
    required this.stats,
    required this.nameOf,
  });

  final Map<String, LivePlayerStat> stats;
  final String Function(String slug) nameOf;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: [
          DataColumn(label: Text(l10n.playerColumn)),
          DataColumn(label: Text(l10n.statGoals), numeric: true),
          DataColumn(label: Text(l10n.statAssists), numeric: true),
          DataColumn(label: Text(l10n.statSaves), numeric: true),
          DataColumn(label: Text(l10n.statTackles), numeric: true),
        ],
        rows: [
          for (final entry in stats.entries)
            DataRow(
              cells: [
                DataCell(Text(nameOf(entry.key))),
                DataCell(Text('${entry.value.g}')),
                DataCell(Text('${entry.value.a}')),
                DataCell(Text('${entry.value.s}')),
                DataCell(Text('${entry.value.t}')),
              ],
            ),
        ],
      ),
    );
  }
}
