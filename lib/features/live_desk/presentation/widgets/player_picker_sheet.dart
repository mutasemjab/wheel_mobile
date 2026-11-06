import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// A pick result; `slug == null` means the "none" option was chosen.
typedef PlayerPick = ({String? slug});

/// Bottom sheet listing players (big tap targets). Resolves to null when
/// dismissed, or to a [PlayerPick].
Future<PlayerPick?> showPlayerPicker(
  BuildContext context, {
  required String title,
  required List<(String slug, String name)> options,
  String? noneLabel,
  String? selected,
}) => showModalBottomSheet<PlayerPick>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (sheetContext) => SafeArea(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.75,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(sheetContext).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Flexible(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3.2,
              padding: const EdgeInsets.all(AppSpacing.md),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              children: [
                if (noneLabel != null)
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(sheetContext).pop((slug: null)),
                    child: Text(noneLabel),
                  ),
                for (final (slug, name) in options)
                  FilledButton.tonal(
                    style: slug == selected
                        ? FilledButton.styleFrom(
                            backgroundColor: Theme.of(
                              sheetContext,
                            ).colorScheme.primary,
                            foregroundColor: Theme.of(
                              sheetContext,
                            ).colorScheme.onPrimary,
                          )
                        : null,
                    onPressed: () =>
                        Navigator.of(sheetContext).pop((slug: slug)),
                    child: Text(name, overflow: TextOverflow.ellipsis),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);
