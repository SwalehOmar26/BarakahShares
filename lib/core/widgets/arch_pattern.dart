import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Faint Islamic arches for dark brand surfaces.
class ArchPattern extends StatelessWidget {
  const ArchPattern({this.opacity = 0.14, super.key});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArchPainter(AppColors.gold.withValues(alpha: opacity)),
      child: const SizedBox.expand(),
    );
  }
}

class _ArchPainter extends CustomPainter {
  const _ArchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    const step = 86.0;
    for (var y = 28.0; y < size.height + step; y += step) {
      for (var x = 18.0; x < size.width + step; x += step) {
        final path = Path()
          ..moveTo(x - 18, y + 16)
          ..lineTo(x - 18, y)
          ..quadraticBezierTo(x, y - 28, x + 18, y)
          ..lineTo(x + 18, y + 16);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ArchPainter oldDelegate) =>
      oldDelegate.color != color;
}
