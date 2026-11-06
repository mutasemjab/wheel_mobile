import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/data_state_view.dart';
import '../../domain/entities/award.dart';
import '../bloc/awards_cubit.dart';
import '../widgets/award_card.dart';

/// Awards tab of the Stats screen.
class AwardsView extends StatelessWidget {
  const AwardsView({super.key});

  static const double _maxTileWidth = 200;

  @override
  Widget build(BuildContext context) => DataStateView<AwardsCubit, List<Award>>(
    isEmpty: (awards) => awards.isEmpty,
    builder: (context, awards) => GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: _maxTileWidth,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.9,
      ),
      itemCount: awards.length,
      itemBuilder: (_, i) =>
          AwardCard(key: ValueKey(awards[i].key), award: awards[i]),
    ),
  );
}
