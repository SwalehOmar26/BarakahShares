import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkMuted
        : AppColors.darkMuted;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: muted),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: muted),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message = 'Loading'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final block = isLight ? AppColors.ivory : AppColors.darkSurface;
    return Semantics(
      label: message,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _bar(block, 22, 0.46),
            const SizedBox(height: AppSpacing.md),
            _bar(block, 120, 1),
            const SizedBox(height: AppSpacing.sm),
            _bar(block, 88, 1),
            const SizedBox(height: AppSpacing.sm),
            _bar(block, 88, 1),
            const SizedBox(height: AppSpacing.lg),
            const LinearProgressIndicator(minHeight: 2, color: AppColors.gold),
          ],
        ),
      ),
    );
  }

  Widget _bar(Color color, double height, double widthFactor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Something went wrong',
      message: message,
      actionLabel: onRetry == null ? null : 'Try again',
      onAction: onRetry,
    );
  }
}
