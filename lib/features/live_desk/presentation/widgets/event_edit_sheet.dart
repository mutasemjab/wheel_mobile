import 'package:flutter/material.dart';

import '../../../../core/entities/enums.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/event_icon.dart';
import '../../domain/entities/live_match_state.dart';
import 'player_picker_sheet.dart';

sealed class EventEditResult {
  const EventEditResult();
}

final class EventEditSaved extends EventEditResult {
  const EventEditSaved(this.event);

  final LiveEvent event;
}

final class EventEditDeleted extends EventEditResult {
  const EventEditDeleted();
}

/// Edit an event: player / assist / minute, swap save ↔ tackle, or delete.
Future<EventEditResult?> showEventEditSheet(
  BuildContext context, {
  required LiveEvent event,
  required List<(String slug, String name)> played,
  required String Function(String slug) nameOf,
}) => showModalBottomSheet<EventEditResult>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _EventEditForm(event: event, played: played, nameOf: nameOf),
);

class _EventEditForm extends StatefulWidget {
  const _EventEditForm({
    required this.event,
    required this.played,
    required this.nameOf,
  });

  final LiveEvent event;
  final List<(String slug, String name)> played;
  final String Function(String slug) nameOf;

  @override
  State<_EventEditForm> createState() => _EventEditFormState();
}

class _EventEditFormState extends State<_EventEditForm> {
  late LiveEvent _draft = widget.event;
  late final TextEditingController _minute = TextEditingController(
    text: widget.event.minute?.toString() ?? '',
  );

  @override
  void dispose() {
    _minute.dispose();
    super.dispose();
  }

  Future<void> _pickPlayer({required bool assist}) async {
    final l10n = context.l10n;
    final options = assist
        ? widget.played.where((p) => p.$1 != _draft.player).toList()
        : widget.played;
    final pick = await showPlayerPicker(
      context,
      title: assist ? l10n.whoAssisted : l10n.scorer,
      options: options,
      noneLabel: assist
          ? l10n.noAssist
          : (_draft.type == LiveEventType.against ? l10n.nobody : null),
      selected: assist ? _draft.assist : _draft.player,
    );
    if (pick == null || !mounted) return;
    setState(() {
      _draft = assist
          ? _draft.copyWith(assist: pick.slug)
          : _draft.copyWith(
              player: pick.slug,
              assist: _draft.assist == pick.slug ? null : _draft.assist,
            );
    });
  }

  void _save() {
    final minute = int.tryParse(_minute.text.trim());
    Navigator.of(context).pop(EventEditSaved(_draft.copyWith(minute: minute)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final type = _draft.type;
    final swappable =
        type == LiveEventType.save || type == LiveEventType.tackle;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.editEvent, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            if (swappable)
              SegmentedButton<LiveEventType>(
                segments: [
                  for (final t in const [
                    LiveEventType.save,
                    LiveEventType.tackle,
                  ])
                    ButtonSegment(
                      value: t,
                      label: Text('${eventEmoji(t)} ${eventLabel(context, t)}'),
                    ),
                ],
                selected: {type},
                onSelectionChanged: (s) =>
                    setState(() => _draft = _draft.copyWith(type: s.first)),
              )
            else
              Text('${eventEmoji(type)} ${eventLabel(context, type)}'),
            if (type != LiveEventType.og)
              ListTile(
                title: Text(l10n.scorer),
                subtitle: Text(
                  _draft.player == null
                      ? l10n.nobody
                      : widget.nameOf(_draft.player!),
                ),
                trailing: const Icon(Icons.edit_rounded),
                onTap: () => _pickPlayer(assist: false),
              ),
            if (type == LiveEventType.goal)
              ListTile(
                title: Text(l10n.assistField),
                subtitle: Text(
                  _draft.assist == null
                      ? l10n.noAssist
                      : widget.nameOf(_draft.assist!),
                ),
                trailing: const Icon(Icons.edit_rounded),
                onTap: () => _pickPlayer(assist: true),
              ),
            TextField(
              controller: _minute,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.minuteField),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () =>
                      Navigator.of(context).pop(const EventEditDeleted()),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(l10n.deleteEvent),
                ),
                const Spacer(),
                FilledButton(onPressed: _save, child: Text(l10n.save)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
