import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GeometricBackground extends StatelessWidget {
  const GeometricBackground({
    this.color = AppColors.gold,
    this.opacity = 0.14,
    super.key,
  });

  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PatternPainter(color.withValues(alpha: opacity)),
      child: const SizedBox.expand(),
    );
  }
}

class _PatternPainter extends CustomPainter {
  const _PatternPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const step = 92.0;
    for (var y = 16.0; y < size.height + step; y += step) {
      for (var x = 8.0; x < size.width + step; x += step) {
        canvas.save();
        canvas.translate(x, y);
        canvas.drawRect(const Rect.fromLTWH(-8, -8, 16, 16), paint);
        canvas.rotate(0.785398);
        canvas.drawRect(const Rect.fromLTWH(-8, -8, 16, 16), paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) =>
      oldDelegate.color != color;
}

class SuccessMark extends StatelessWidget {
  const SuccessMark({this.size = 112, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _SuccessPainter(),
    );
  }
}

class _SuccessPainter extends CustomPainter {
  const _SuccessPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final ring = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 2, ring);
    canvas.drawCircle(
      center,
      radius - 14,
      Paint()..color = AppColors.gold.withValues(alpha: 0.16),
    );
    final check = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(size.width * 0.30, size.height * 0.52)
      ..lineTo(size.width * 0.44, size.height * 0.66)
      ..lineTo(size.width * 0.72, size.height * 0.36);
    canvas.drawPath(path, check);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
