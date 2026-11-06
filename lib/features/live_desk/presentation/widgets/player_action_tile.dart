import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/live_match_rules.dart';

/// Player tile on the desk: name, live tallies, flags and one-tap buttons
/// (⚽ goal, 🧤 save, 🛡️ tackle) plus a ⋯ menu.
class PlayerActionTile extends StatelessWidget {
  const PlayerActionTile({
    super.key,
    required this.name,
    required this.tally,
    this.isMotm = false,
    this.isLate = false,
    this.isUnfair = false,
    this.values = 0,
    this.enabled = true,
    required this.onGoal,
    required this.onSave,
    required this.onTackle,
    required this.onMenu,
  });

  final String name;
  final PlayerTally tally;
  final bool isMotm;
  final bool isLate;
  final bool isUnfair;
  final int values;
  final bool enabled;
  final VoidCallback onGoal;
  final VoidCallback onSave;
  final VoidCallback onTackle;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final badges = [
      if (isMotm) '⭐',
      if (isLate) '⏰',
      if (isUnfair) '🟨',
      if (values > 0) '🏢$values',
    ].join(' ');
    final tallies = [
      if (tally.g > 0) '⚽${tally.g}',
      if (tally.a > 0) '🎯${tally.a}',
      if (tally.s > 0) '🧤${tally.s}',
      if (tally.t > 0) '🛡️${tally.t}',
      if (tally.c > 0) '⚠️${tally.c}',
    ].join(' ');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        side: isMotm
            ? const BorderSide(color: AppColors.tierGold, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleSmall,
                  ),
                ),
                if (badges.isNotEmpty) Text(badges, style: text.labelSmall),
                SizedBox.square(
                  dimension: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: enabled ? onMenu : null,
                    icon: const Icon(Icons.more_vert_rounded, size: 20),
                  ),
                ),
              ],
            ),
            Text(tallies.isEmpty ? '—' : tallies, style: text.labelMedium),
            Row(
              children: [
                _ActionButton(emoji: '⚽', onTap: enabled ? onGoal : null),
                _ActionButton(emoji: '🧤', onTap: enabled ? onSave : null),
                _ActionButton(emoji: '🛡️', onTap: enabled ? onTackle : null),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.emoji, this.onTap});

  final String emoji;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size.fromHeight(44),
        ),
        onPressed: onTap,
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      ),
    ),
  );
}
