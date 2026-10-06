import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/business.dart';
import '../../../models/enums.dart';

class BusinessHeader extends StatelessWidget {
  const BusinessHeader({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkMuted
        : AppColors.darkMuted;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BusinessArtwork(
          artworkKey: business.artworkKey,
          height: 210,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(business.name, style: brandStyle(size: 32)),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          business.location,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: muted),
        ),
        if (business.operatingNote != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            business.operatingNote!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            if (business.shariahApproved)
              const StatusBadge(
                label: 'Shariah Approved',
                tone: BadgeTone.gold,
                icon: Icons.verified_outlined,
              ),
            if (business.audited)
              const StatusBadge(
                label: 'Audited',
                tone: BadgeTone.success,
                icon: Icons.check,
              ),
            if (business.halalCertified)
              const StatusBadge(
                label: 'Halal Certificate',
                tone: BadgeTone.success,
                icon: Icons.check,
              ),
            StatusBadge(
              label: business.campaign.status.label,
              tone: business.campaign.status == CampaignStatus.fundingSoon
                  ? BadgeTone.warning
                  : BadgeTone.info,
              icon: Icons.schedule,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.greenSoft,
              child: Icon(Icons.person_outline, color: AppColors.deepGreen),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Owner',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: muted),
                ),
                Text(
                  business.ownerName,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Spacer(),
            if (business.ownerVerified)
              const StatusBadge(
                label: 'Verified owner',
                tone: BadgeTone.success,
                icon: Icons.check,
              ),
          ],
        ),
      ],
    );
  }
}
