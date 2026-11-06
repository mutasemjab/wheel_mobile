import 'package:flutter/material.dart';

import '../entities/enums.dart';
import '../l10n/l10n.dart';
import '../theme/colors.dart';

/// Localized label of a result letter.
String resultLabel(BuildContext context, MatchResult result) =>
    switch (result) {
      MatchResult.win => context.l10n.resultWin,
      MatchResult.draw => context.l10n.resultDraw,
      MatchResult.loss => context.l10n.resultLoss,
    };

/// Colored chip "فوز / تعادل / خسارة".
class ResultChip extends StatelessWidget {
  const ResultChip({super.key, required this.result});

  final MatchResult result;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.result(result);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        resultLabel(context, result),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

/// Last-N results as colored dots (oldest → newest, in reading order).
class FormDots extends StatelessWidget {
  const FormDots({super.key, required this.results, this.size = 28});

  final List<MatchResult> results;
  final double size;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    children: [
      for (final r in results)
        Tooltip(
          message: resultLabel(context, r),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.result(r),
              shape: BoxShape.circle,
            ),
            child: Text(
              r.code,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
    ],
  );
}
