import 'package:flutter/material.dart';

import '../../shared/models/business_opportunity.dart';
import '../theme/app_colors.dart';

class IllustratedCover extends StatelessWidget {
  const IllustratedCover({
    required this.business,
    this.height = 180,
    this.radius = 0,
    super.key,
  });

  final BusinessOpportunity business;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = switch (business.category) {
      BusinessCategory.restaurants => const [AppColors.forest, AppColors.teal],
      BusinessCategory.retail => const [AppColors.navy, AppColors.emerald],
      BusinessCategory.agriculture => const [
        Color(0xFF14532D),
        Color(0xFF65A30D),
      ],
      BusinessCategory.logistics => const [AppColors.navy, Color(0xFF0F766E)],
    };
    final icon = switch (business.category) {
      BusinessCategory.restaurants => Icons.restaurant_rounded,
      BusinessCategory.retail => Icons.checkroom_rounded,
      BusinessCategory.agriculture => Icons.grass_rounded,
      BusinessCategory.logistics => Icons.local_shipping_outlined,
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: _CoverPattern()),
              Center(
                child: Icon(icon, color: AppColors.gold, size: height * 0.34),
              ),
              Positioned(
                left: 12,
                bottom: 10,
                child: Text(
                  'Illustration',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.86),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverPattern extends StatelessWidget {
  const _CoverPattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CoverPainter());
  }
}

class _CoverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.white.withValues(alpha: 0.08);
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.15 + i * 0.28), size.height * 0.2),
        18,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
