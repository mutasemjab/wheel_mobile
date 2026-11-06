import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/match.dart';

/// "النقاط والتقييم": points earned and rating before → after per player.
class MatchRatingsCard extends StatelessWidget {
  const MatchRatingsCard({super.key, required this.ratings});

  final List<MatchRating> ratings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return SectionCard(
      title: l10n.ratingsTitle,
      child: Column(
        children: [
          for (final r in ratings)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text([r.name, if (r.star) '⭐', if (r.late) '⏰'].join(' ')),
              subtitle: Text(
                r.excused
                    ? l10n.excusedRow
                    : '${l10n.pointsValue(NumberFormatX.compact(r.pts))} · '
                          '${NumberFormatX.oneDecimal(r.before)} → '
                          '${NumberFormatX.oneDecimal(r.after)}',
              ),
              trailing: Text(
                NumberFormatX.signed(r.delta),
                style: text.titleSmall?.copyWith(
                  color: AppColors.delta(r.delta),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
