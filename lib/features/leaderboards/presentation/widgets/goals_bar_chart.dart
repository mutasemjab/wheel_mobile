import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/leaderboards.dart';

/// Us vs them goals for the last matches (oldest → newest).
class GoalsBarChart extends StatelessWidget {
  const GoalsBarChart({super.key, required this.points});

  static const double _height = 180;
  static const double _rodWidth = 8;

  final List<GoalsChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            height: _height,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 24,
                      getTitlesWidget: (v, _) =>
                          Text(v.toInt().toString(), style: labelStyle),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= points.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          points[i].opponent,
                          style: labelStyle,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < points.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: points[i].us.toDouble(),
                          color: AppColors.accent,
                          width: _rodWidth,
                        ),
                        BarChartRodData(
                          toY: points[i].them.toDouble(),
                          color: AppColors.neutral,
                          width: _rodWidth,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Legend(color: AppColors.accent, label: context.l10n.us),
            const SizedBox(width: AppSpacing.lg),
            _Legend(color: AppColors.neutral, label: context.l10n.them),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: AppSpacing.xs),
      Text(label),
    ],
  );
}
