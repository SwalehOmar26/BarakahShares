import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/progress_bar.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/business.dart';
import '../../models/enums.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({super.key, required this.business, required this.onView});

  final Business business;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkMuted
        : AppColors.darkMuted;
    final campaign = business.campaign;
    return Semantics(
      container: true,
      label: business.name,
      child: Material(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.line
                  : AppColors.darkLine,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BusinessArtwork(
                artworkKey: business.artworkKey,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      business.location,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: muted),
                    ),
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
                        if (business.cmaVerified)
                          const StatusBadge(
                            label: 'CMA Verified',
                            tone: BadgeTone.info,
                            icon: Icons.account_balance_outlined,
                          ),
                        StatusBadge(
                          label: campaign.status.label,
                          tone: campaign.status == CampaignStatus.fundingSoon
                              ? BadgeTone.warning
                              : BadgeTone.neutral,
                          icon: Icons.schedule,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _metric(
                      context,
                      'Monthly profit',
                      formatKes(business.monthlyProfitKes),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _metric(
                      context,
                      'Funding target',
                      formatKes(campaign.targetKes),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppProgressBar(
                      value: campaign.progress,
                      label:
                          '${campaign.filledShares} of ${campaign.totalShares} slots filled',
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${formatKes(campaign.raisedKes)} raised',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${campaign.filledShares} / ${campaign.totalShares} slots · ${formatKes(campaign.sharePriceKes)} per share',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: muted),
                    ),
                    if (business.illustrativePerShareKes != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Illustrative investor distribution',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${formatKes(business.illustrativePerShareKes!)} per share / month',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        AppCopy.illustrativeFigure,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: muted),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(label: 'View Business', onPressed: onView),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(BuildContext context, String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.inkMuted
                  : AppColors.darkMuted,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
