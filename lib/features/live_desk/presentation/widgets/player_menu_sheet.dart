import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';

/// ⋯ menu for a played player: MOTM, company values ±, fair play, late.
Future<void> showPlayerMenu(
  BuildContext context, {
  required String name,
  required bool isMotm,
  required bool isUnfair,
  required bool isLate,
  required int values,
  required VoidCallback onToggleMotm,
  required ValueChanged<int> onValues,
  required VoidCallback onToggleUnfair,
  required VoidCallback onToggleLate,
}) {
  final l10n = context.l10n;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      void run(VoidCallback action) {
        action();
        Navigator.of(sheetContext).pop();
      }

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: Theme.of(sheetContext).textTheme.titleLarge),
            ListTile(
              leading: const Text('⭐', style: TextStyle(fontSize: 22)),
              title: Text(isMotm ? l10n.removeMotm : l10n.makeMotm),
              onTap: () => run(onToggleMotm),
            ),
            ListTile(
              leading: const Text('🏢', style: TextStyle(fontSize: 22)),
              title: Text('${l10n.valuesTitle}: $values'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.filledTonal(
                    tooltip: l10n.valuesMinus,
                    onPressed: values > 0
                        ? () => run(() => onValues(-1))
                        : null,
                    icon: const Icon(Icons.remove_rounded),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    tooltip: l10n.valuesPlus,
                    onPressed: () => run(() => onValues(1)),
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              secondary: const Text('🟨', style: TextStyle(fontSize: 22)),
              title: Text(l10n.toggleUnfair),
              value: isUnfair,
              onChanged: (_) => run(onToggleUnfair),
            ),
            SwitchListTile(
              secondary: const Text('⏰', style: TextStyle(fontSize: 22)),
              title: Text(l10n.toggleLate),
              value: isLate,
              onChanged: (_) => run(onToggleLate),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      );
    },
  );
}
