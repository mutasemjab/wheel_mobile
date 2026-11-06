import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/event_icon.dart';
import '../../domain/entities/live_match_state.dart';

/// Event log, newest first. Tap a row to edit it.
class EventLogList extends StatelessWidget {
  const EventLogList({
    super.key,
    required this.events,
    required this.nameOf,
    required this.onTap,
  });

  final List<LiveEvent> events;
  final String Function(String slug) nameOf;
  final ValueChanged<LiveEvent> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final newestFirst = events.reversed.toList();
    if (newestFirst.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.emptyList, textAlign: TextAlign.center),
      );
    }
    return Column(
      children: [
        for (final e in newestFirst)
          ListTile(
            key: ValueKey(e.uuid),
            dense: true,
            onTap: () => onTap(e),
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
                : Text(l10n.assistBy(nameOf(e.assist!))),
            trailing: Text(
              e.minute == null ? l10n.noMinute : l10n.minuteLabel(e.minute!),
            ),
          ),
      ],
    );
  }
}
