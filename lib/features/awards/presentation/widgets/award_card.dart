import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../domain/entities/award.dart';

/// Icon, Arabic title, English tag, value + unit, and winner (or "لسا مفتوح").
class AwardCard extends StatelessWidget {
  const AwardCard({super.key, required this.award});

  final Award award;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final player = award.player;
    final value = award.value;
    final tierColor = player?.tier == null
        ? null
        : AppColors.tier(player!.tier!);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: player == null
            ? null
            : () => context.push(AppRoutes.player(player.slug)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(award.icon, style: const TextStyle(fontSize: 30)),
              Text(
                award.ar,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.titleSmall,
              ),
              Text(
                award.en,
                style: text.labelSmall?.copyWith(letterSpacing: 1),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                player?.name ?? context.l10n.awardOpen,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.titleMedium?.copyWith(color: tierColor),
              ),
              if (value != null)
                Text(
                  '${NumberFormatX.upTo2(value)} ${award.unit}',
                  style: text.labelMedium?.copyWith(color: AppColors.accent),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
