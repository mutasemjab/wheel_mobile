import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/home_data.dart';

/// Red "مباشر هلأ" banner; tap opens the live viewer.
class LiveBannerCard extends StatelessWidget {
  const LiveBannerCard({super.key, required this.live});

  final LiveBanner live;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      color: AppColors.live,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.live),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              const Icon(Icons.sensors_rounded, color: Colors.white),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.liveNow,
                      style: text.labelLarge?.copyWith(color: Colors.white),
                    ),
                    Text(
                      context.l10n.liveVs(live.opponent),
                      style: text.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${live.scoreUs} – ${live.scoreThem}',
                    style: text.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    context.l10n.tapToWatch,
                    style: text.labelSmall?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
