import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final background = color ?? (isLight ? AppColors.card : AppColors.darkCard);
    final radius = BorderRadius.circular(AppSpacing.radiusCard);
    return Material(
      color: background,
      elevation: 0,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius,
            border: Border.all(
              color: isLight ? AppColors.line : AppColors.darkLine,
            ),
            boxShadow: isLight
                ? const [
                    BoxShadow(
                      color: Color(0x100C3832),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.caption,
  });

  final String label;
  final String value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.bodySmall?.copyWith(color: _muted(context))),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              caption!,
              style: text.bodySmall?.copyWith(color: _muted(context)),
            ),
          ],
        ],
      ),
    );
  }
}

Color _muted(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? AppColors.inkMuted
      : AppColors.darkMuted;
}
