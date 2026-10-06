import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand.dart';
import '../../providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    final wait = ref.read(demoTimingProvider).splash;
    Future<void>.delayed(wait, () {
      if (!mounted) return;
      context.go(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.jewelDepth),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  const Spacer(),
                  const BrandMark(size: 84, onDark: true),
                  const SizedBox(height: AppSpacing.lg),
                  const Wordmark(color: Colors.white, size: 40),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppCopy.tagline,
                    style: brandStyle(
                      size: 18,
                      color: AppColors.goldOnDark,
                      weight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(width: 42, height: 1, color: AppColors.goldOnDark),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppCopy.regulatedLine,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      color: AppColors.goldOnDark,
                      backgroundColor: AppColors.greenMid,
                      minHeight: 2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
