import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum BadgeTone { neutral, verified, pending, rejected, gold }

class VerificationBadge extends StatelessWidget {
  const VerificationBadge({
    required this.label,
    this.tone = BadgeTone.neutral,
    super.key,
  });

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      BadgeTone.verified => (AppColors.successSurface, AppColors.emerald),
      BadgeTone.pending => (AppColors.goldSurface, AppColors.goldDeep),
      BadgeTone.rejected => (AppColors.dangerSurface, AppColors.danger),
      BadgeTone.gold => (AppColors.goldSurface, AppColors.goldDeep),
      BadgeTone.neutral => (const Color(0xFFEEF2F6), AppColors.navy),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: foreground, fontWeight: FontWeight.w700),
      ),
    );
  }
}
