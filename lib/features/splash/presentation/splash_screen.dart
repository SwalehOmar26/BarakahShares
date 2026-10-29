import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/arch_pattern.dart';
import '../../../core/widgets/brand_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _background;
  late final Animation<double> _logo;
  late final Animation<double> _logoScale;
  late final Animation<double> _name;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _tagline;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _background = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.35, curve: Curves.easeOut),
    );
    _logo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1).animate(_logo);
    _name = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.34, 0.72, curve: Curves.easeOutCubic),
    );
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(_name);
    _tagline = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.58, 1, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF02140F), AppColors.forest, Color(0xFF064E3B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(opacity: _background, child: const ArchPattern()),
            FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(_background),
              child: const ColoredBox(color: Color(0xFF010806)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _logo,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.28),
                                blurRadius: 42,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const BrandLogo(size: 156),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeTransition(
                      opacity: _name,
                      child: SlideTransition(
                        position: _nameSlide,
                        child: Column(
                          children: [
                            Text(
                              AppConstants.appName,
                              style: text.displayMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppConstants.subtitle,
                              style: text.labelLarge?.copyWith(
                                color: AppColors.gold,
                                letterSpacing: 2.6,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FadeTransition(
                      opacity: _tagline,
                      child: Column(
                        children: [
                          Container(
                            width: 42,
                            height: 1.5,
                            color: AppColors.gold.withValues(alpha: 0.7),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            AppConstants.tagline,
                            style: text.bodyLarge?.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
