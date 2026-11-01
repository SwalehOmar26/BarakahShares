import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DonutSlice {
  const DonutSlice({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;
}

class DonutChart extends StatelessWidget {
  const DonutChart({
    required this.slices,
    required this.centerLabel,
    required this.centerValue,
    super.key,
  });

  final List<DonutSlice> slices;
  final String centerLabel;
  final String centerValue;

  @override
  Widget build(BuildContext context) {
    final total = slices.fold<double>(0, (sum, slice) => sum + slice.value);
    return Column(
      children: [
        SizedBox(
          height: 220,
          width: 220,
          child: CustomPaint(
            painter: _DonutPainter(slices: slices, total: total),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    centerLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    centerValue,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (final slice in slices)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: slice.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    slice.label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.slices, required this.total});

  final List<DonutSlice> slices;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius - 14);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.butt;
    if (total <= 0) {
      paint.color = AppColors.line;
      canvas.drawArc(rect, 0, math.pi * 2, false, paint);
      return;
    }
    var start = -math.pi / 2;
    for (final slice in slices) {
      final sweep = (slice.value / total) * math.pi * 2;
      paint.color = slice.color;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.total != total || oldDelegate.slices != slices;
}
