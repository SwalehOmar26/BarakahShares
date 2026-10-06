import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, required this.value, this.label});

  final double value;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 1).toDouble();
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Semantics(
      label: label ?? 'Progress ${(clamped * 100).round()} percent',
      value: '${(clamped * 100).round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: SizedBox(
          height: 8,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(
                color: isLight ? AppColors.ivory : AppColors.darkSurface,
              ),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: clamped,
                child: const ColoredBox(color: AppColors.gold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}
