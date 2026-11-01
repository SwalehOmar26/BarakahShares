import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/arch_pattern.dart';
import '../../../core/widgets/brand_logo.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF02140F),
                            AppColors.forest,
                            Color(0xFF065F46),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Stack(
                        children: [
                          const Positioned.fill(child: ArchPattern()),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
                            child: Column(
                              children: [
                                const BrandLogo(size: 84),
                                const SizedBox(height: 16),
                                Text(
                                  'Grow Your Wealth.',
                                  textAlign: TextAlign.center,
                                  style: text.headlineLarge?.copyWith(
                                    color: AppColors.white,
                                    height: 1.05,
                                  ),
                                ),
                                Text(
                                  'Share the Barakah.',
                                  textAlign: TextAlign.center,
                                  style: text.headlineLarge?.copyWith(
                                    color: AppColors.gold,
                                    height: 1.05,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Invest in verified halal businesses, own real shares, and grow together through transparent, ethical investing.',
                                  textAlign: TextAlign.center,
                                  style: text.bodyMedium?.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.88,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 148,
                                  width: double.infinity,
                                  child: CustomPaint(
                                    painter: _ProsperityPainter(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              _Benefit(
                                icon: Icons.mosque_outlined,
                                label: 'Shariah-Conscious Investing',
                              ),
                              _Benefit(
                                icon: Icons.pie_chart_outline_rounded,
                                label: 'Real Business Ownership',
                              ),
                              _Benefit(
                                icon: Icons.trending_up_rounded,
                                label: 'Transparent Growth',
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: AppColors.forest,
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.forest,
                              ),
                            ),
                            onPressed: () => context.push(AppRoutes.register),
                            child: const Text('Get Started'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => context.push(AppRoutes.login),
                            child: const Text('I Already Have an Account'),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            AppConstants.tagline,
                            textAlign: TextAlign.center,
                            style: text.labelLarge?.copyWith(
                              color: AppColors.emerald,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.goldSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.7),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: AppColors.forest, size: 20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: AppColors.forest, height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProsperityPainter extends CustomPainter {
  const _ProsperityPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final gold = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final wash = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    final bar = Paint()..color = AppColors.teal.withValues(alpha: 0.9);

    final base = size.height * 0.78;
    final center = size.width / 2;

    final arch = Path()
      ..moveTo(center - 78, base)
      ..lineTo(center - 78, base - 36)
      ..quadraticBezierTo(center, base - 86, center + 78, base - 36)
      ..lineTo(center + 78, base);
    canvas.drawPath(arch, wash);
    canvas.drawPath(arch, gold);
    canvas.drawLine(
      Offset(center - 108, base),
      Offset(center + 108, base),
      gold,
    );

    const heights = [28.0, 46.0, 68.0];
    for (var index = 0; index < heights.length; index++) {
      final left = center - 36 + index * 26;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, base - heights[index], 16, heights[index]),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, bar);
      canvas.drawRRect(
        rect,
        Paint()
          ..color = AppColors.gold.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    void leaf(Offset origin, bool flip) {
      final path = Path()
        ..moveTo(origin.dx, origin.dy)
        ..quadraticBezierTo(
          origin.dx + (flip ? -28 : 28),
          origin.dy - 8,
          origin.dx + (flip ? -8 : 8),
          origin.dy - 26,
        )
        ..quadraticBezierTo(
          origin.dx + (flip ? 8 : -8),
          origin.dy - 8,
          origin.dx,
          origin.dy,
        );
      canvas.drawPath(
        path,
        Paint()..color = AppColors.emerald.withValues(alpha: 0.85),
      );
      canvas.drawPath(path, gold);
    }

    leaf(Offset(center - 92, base), true);
    leaf(Offset(center + 92, base), false);
    canvas.drawCircle(
      Offset(center, base - 78),
      6,
      Paint()..color = AppColors.gold,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
