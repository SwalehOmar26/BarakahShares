import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72, this.onDark = false});

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'BarakahShares mark',
      child: CustomPaint(
        size: Size.square(size),
        painter: _MarkPainter(onDark: onDark),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter({required this.onDark});

  final bool onDark;

  @override
  void paint(Canvas canvas, Size size) {
    final gold = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045;
    final fill = Paint()
      ..color = onDark ? AppColors.gold : AppColors.deepGreen
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.06,
        size.height * 0.06,
        size.width * 0.88,
        size.height * 0.88,
      ),
      Radius.circular(size.width * 0.22),
    );
    canvas.drawRRect(rect, gold);

    final barW = size.width * 0.12;
    final left = size.width * 0.28;
    final bottoms = [0.72, 0.72, 0.72];
    final heights = [0.22, 0.34, 0.46];
    for (var i = 0; i < 3; i++) {
      final h = size.height * heights[i];
      final top = size.height * bottoms[i] - h;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left + i * (barW + size.width * 0.06), top, barW, h),
          Radius.circular(barW / 3),
        ),
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MarkPainter oldDelegate) =>
      oldDelegate.onDark != onDark;
}

class BusinessArtwork extends StatelessWidget {
  const BusinessArtwork({
    super.key,
    required this.artworkKey,
    this.height = 148,
    this.borderRadius,
  });

  final String artworkKey;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final visual = _visuals[artworkKey] ?? _visuals['dining']!;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(color: visual.base),
          child: CustomPaint(
            painter: _ArtworkPainter(visual),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Icon(visual.icon, color: AppColors.gold, size: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArtVisual {
  const _ArtVisual(this.base, this.icon);
  final Color base;
  final IconData icon;
}

const _visuals = {
  'dining': _ArtVisual(AppColors.deepGreen, Icons.restaurant_outlined),
  'retail': _ArtVisual(Color(0xFF163E46), Icons.storefront_outlined),
  'agriculture': _ArtVisual(Color(0xFF1A4534), Icons.yard_outlined),
  'logistics': _ArtVisual(Color(0xFF1C3346), Icons.local_shipping_outlined),
};

class _ArtworkPainter extends CustomPainter {
  const _ArtworkPainter(this.visual);
  final _ArtVisual visual;

  @override
  void paint(Canvas canvas, Size size) {
    final gold = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final soft = Paint()..color = Colors.white.withValues(alpha: 0.06);
    canvas.drawCircle(Offset(size.width * 0.86, size.height * 0.18), 54, soft);
    canvas.drawCircle(Offset(size.width * 0.12, size.height * 0.9), 40, soft);
    final path = Path()
      ..moveTo(0, size.height * 0.72)
      ..lineTo(size.width * 0.35, size.height * 0.42)
      ..lineTo(size.width * 0.62, size.height * 0.58)
      ..lineTo(size.width, size.height * 0.28);
    canvas.drawPath(path, gold);
  }

  @override
  bool shouldRepaint(covariant _ArtworkPainter oldDelegate) => false;
}

class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: child,
      ),
    );
  }
}

class Wordmark extends StatelessWidget {
  const Wordmark({super.key, required this.color, this.size = 36});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'BarakahShares',
      style: brandStyle(size: size, color: color, weight: FontWeight.w600),
    );
  }
}
