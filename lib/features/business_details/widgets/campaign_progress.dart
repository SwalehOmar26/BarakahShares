import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../models/business.dart';
import '../../../models/enums.dart';

class CampaignProgressSection extends StatelessWidget {
  const CampaignProgressSection({
    super.key,
    required this.business,
    required this.onInvest,
    required this.onChain,
  });

  final Business business;
  final VoidCallback onInvest;
  final VoidCallback onChain;

  @override
  Widget build(BuildContext context) {
    final campaign = business.campaign;
    final open = campaign.status == CampaignStatus.funding;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Campaign Progress'),
        AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${formatPercent(campaign.equityOfferedPercent, digits: 0)} equity offered',
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '${formatKes(campaign.targetKes)} target · ${formatKes(campaign.sharePriceKes)} per share',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppProgressBar(value: campaign.progress),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${formatKes(campaign.raisedKes)} raised · ${campaign.filledShares} / ${campaign.totalShares} shares filled',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text('${campaign.availableShares} shares still available'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          key: const Key('invest-cta'),
          label: open
              ? 'Invest ${formatKes(campaign.sharePriceKes)}'
              : 'Funding soon',
          onPressed: open ? onInvest : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(label: 'View Blockchain Record', onPressed: onChain),
      ],
    );
  }
}
