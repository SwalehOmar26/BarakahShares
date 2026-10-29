import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Gold Islamic skyline used on the splash screen.
class GoldSkyline extends StatelessWidget {
  const GoldSkyline({this.height = 108, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _SkylinePainter()),
    );
  }
}

class _SkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final wash = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final base = size.height * 0.78;
    canvas.drawLine(Offset(0, base), Offset(size.width, base), line);

    void arch(double center, double width, double rise) {
      final path = Path()
        ..moveTo(center - width / 2, base)
        ..lineTo(center - width / 2, base - rise * 0.42)
        ..quadraticBezierTo(
          center,
          base - rise,
          center + width / 2,
          base - rise * 0.42,
        )
        ..lineTo(center + width / 2, base)
        ..close();
      canvas.drawPath(path, wash);
      canvas.drawPath(path, line);
    }

    void minaret(double center, double width, double rise) {
      final left = center - width / 2;
      final right = center + width / 2;
      final top = base - rise;
      final path = Path()
        ..moveTo(left, base)
        ..lineTo(left, top + width)
        ..lineTo(left - width * 0.25, top + width)
        ..lineTo(left - width * 0.25, top + width * 0.45)
        ..lineTo(center, top)
        ..lineTo(right + width * 0.25, top + width * 0.45)
        ..lineTo(right + width * 0.25, top + width)
        ..lineTo(right, top + width)
        ..lineTo(right, base);
      canvas.drawPath(path, wash);
      canvas.drawPath(path, line);
    }

    final unit = size.width / 12;
    minaret(unit * 1.1, unit * 0.34, size.height * 0.42);
    arch(unit * 2.5, unit * 1.5, size.height * 0.34);
    minaret(unit * 4.15, unit * 0.42, size.height * 0.62);
    arch(unit * 6, unit * 2.15, size.height * 0.5);
    minaret(unit * 7.9, unit * 0.38, size.height * 0.55);
    arch(unit * 9.6, unit * 1.7, size.height * 0.36);
    minaret(unit * 11.1, unit * 0.32, size.height * 0.4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
