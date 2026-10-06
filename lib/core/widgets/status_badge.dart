import 'package:flutter/material.dart';

import '../../models/enums.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

enum BadgeTone { success, warning, error, info, neutral, gold }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
  });

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  factory StatusBadge.verification(VerificationStatus status) {
    return switch (status) {
      VerificationStatus.verified => const StatusBadge(
        label: 'Verified',
        tone: BadgeTone.success,
        icon: Icons.check,
      ),
      VerificationStatus.pending => const StatusBadge(
        label: 'Pending',
        tone: BadgeTone.warning,
        icon: Icons.schedule,
      ),
      VerificationStatus.failed => const StatusBadge(
        label: 'Failed',
        tone: BadgeTone.error,
        icon: Icons.priority_high,
      ),
    };
  }

  factory StatusBadge.kyc(KycStatus status) {
    return switch (status) {
      KycStatus.verified => const StatusBadge(
        label: 'Verified',
        tone: BadgeTone.success,
        icon: Icons.check,
      ),
      KycStatus.pending => const StatusBadge(
        label: 'Pending',
        tone: BadgeTone.warning,
        icon: Icons.schedule,
      ),
      KycStatus.failed => const StatusBadge(
        label: 'Failed',
        tone: BadgeTone.error,
        icon: Icons.priority_high,
      ),
      KycStatus.notStarted => const StatusBadge(
        label: 'Not started',
        tone: BadgeTone.neutral,
        icon: Icons.schedule,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors(tone);
    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colors.$1,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.circle, size: 12, color: colors.$2),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: colors.$2, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) _colors(BadgeTone tone) {
    return switch (tone) {
      BadgeTone.success => (AppColors.successSoft, AppColors.success),
      BadgeTone.warning => (AppColors.warningSoft, AppColors.warning),
      BadgeTone.error => (AppColors.errorSoft, AppColors.error),
      BadgeTone.info => (AppColors.infoSoft, AppColors.info),
      BadgeTone.neutral => (AppColors.ivory, AppColors.inkMuted),
      BadgeTone.gold => (AppColors.goldMuted, AppColors.deepGreen),
    };
  }
}
