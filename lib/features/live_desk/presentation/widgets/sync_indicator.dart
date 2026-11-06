import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/live_match_state.dart';

/// ✓ synced · ⟳ pending · ⚠ offline / error.
class SyncIndicator extends StatelessWidget {
  const SyncIndicator({super.key, required this.status, this.onRetry});

  final SyncStatus status;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (icon, color, label) = switch (status) {
      SyncStatus.synced => ('✓', AppColors.positive, l10n.syncSynced),
      SyncStatus.pending => ('⟳', AppColors.accentSecondary, l10n.syncPending),
      SyncStatus.offline => ('⚠', AppColors.warning, l10n.syncOffline),
      SyncStatus.error => ('⚠', AppColors.negative, l10n.syncError),
    };
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: status == SyncStatus.synced ? null : onRetry,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            '$icon $label',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
