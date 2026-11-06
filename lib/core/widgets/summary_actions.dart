import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'state_views.dart';

/// WhatsApp summary text with Copy / Share buttons.
class SummaryActions extends StatelessWidget {
  const SummaryActions({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: SelectableText(text),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: text));
                  if (context.mounted) showMessageSnack(context, l10n.copied);
                },
                icon: const Icon(Icons.copy_rounded),
                label: Text(l10n.copy),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FilledButton.icon(
                onPressed: () =>
                    SharePlus.instance.share(ShareParams(text: text)),
                icon: const Icon(Icons.share_rounded),
                label: Text(l10n.share),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
