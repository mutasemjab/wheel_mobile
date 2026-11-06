import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/number_format.dart';
import '../../domain/entities/player_profile.dart';

/// Rating line chart from `rating_chart`.
class RatingChart extends StatelessWidget {
  const RatingChart({super.key, required this.points});

  static const double _height = 200;
  static const double _padding = 5;

  final List<ChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    final values = points.map((p) => p.value);
    final minY = values.reduce((a, b) => a < b ? a : b) - _padding;
    final maxY = values.reduce((a, b) => a > b ? a : b) + _padding;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: _height,
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (spots) => [
                  for (final s in spots)
                    LineTooltipItem(
                      '${points[s.x.toInt()].label}\n${NumberFormatX.oneDecimal(s.y)}',
                      const TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, _) =>
                      Text(value.toStringAsFixed(0), style: labelStyle),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) {
                    final i = value.toInt();
                    if (i < 0 || i >= points.length || value != i.toDouble()) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(points[i].label, style: labelStyle),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < points.length; i++)
                    FlSpot(i.toDouble(), points[i].value),
                ],
                isCurved: true,
                preventCurveOverShooting: true,
                color: AppColors.accent,
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.accent.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
