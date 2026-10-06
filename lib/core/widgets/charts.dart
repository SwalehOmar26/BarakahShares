import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class MiniLineChart extends StatelessWidget {
  const MiniLineChart({
    super.key,
    required this.values,
    required this.labels,
    this.color = AppColors.deepGreen,
  });

  final List<int> values;
  final List<String> labels;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkMuted
        : AppColors.darkMuted;
    final spots = [
      for (var i = 0; i < values.length; i++)
        FlSpot(i.toDouble(), values[i].toDouble()),
    ];
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minY: 0,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[index],
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: muted),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => [
                for (final spot in spots)
                  LineTooltipItem(
                    spot.y.round().toString(),
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 2.5,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 350),
      ),
    );
  }
}

class AllocationChart extends StatelessWidget {
  const AllocationChart({
    super.key,
    required this.ownerPercent,
    required this.investorPercent,
  });

  final double ownerPercent;
  final double investorPercent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 46,
          sections: [
            PieChartSectionData(
              value: ownerPercent,
              color: AppColors.deepGreen,
              title: '${ownerPercent.round()}%',
              radius: 28,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            PieChartSectionData(
              value: investorPercent,
              color: AppColors.gold,
              title: '${investorPercent.round()}%',
              radius: 28,
              titleStyle: const TextStyle(
                color: AppColors.deepGreen,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 350),
      ),
    );
  }
}
