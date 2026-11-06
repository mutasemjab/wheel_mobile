import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../team/domain/entities/team.dart';

class TeamHeader extends StatelessWidget {
  const TeamHeader({super.key, required this.team, this.updated});

  static const double _crestSize = 56;

  final TeamInfo team;
  final DateTime? updated;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    final crest = team.crestUrl;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.35),
            Colors.transparent,
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Row(
        children: [
          if (crest != null) ...[
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: crest,
                width: _crestSize,
                height: _crestSize,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => const AppLogo(height: _crestSize),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ] else ...[
            const AppLogo(height: _crestSize),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(team.name, style: text.headlineMedium),
                if (team.slogan != null)
                  Text(
                    team.slogan!,
                    style: text.labelLarge?.copyWith(
                      letterSpacing: 2,
                      color: AppColors.accent,
                    ),
                  ),
                if (updated != null)
                  Text(
                    context.l10n.lastUpdated(
                      DateUtilsX.display(updated!, locale),
                    ),
                    style: text.labelSmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
