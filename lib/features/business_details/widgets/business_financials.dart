import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_copy.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../models/business.dart';

class BusinessFinancials extends StatelessWidget {
  const BusinessFinancials({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkMuted
        : AppColors.darkMuted;
    final campaign = business.campaign;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Financial Snapshot'),
        AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _row(
                context,
                'Monthly profit',
                formatKes(business.monthlyProfitKes),
              ),
              _row(
                context,
                'Equity offered',
                formatPercent(campaign.equityOfferedPercent, digits: 0),
              ),
              _row(
                context,
                'Investor profit pool',
                formatPercent(campaign.investorPoolPercent, digits: 0),
              ),
              _row(context, 'Share price', formatKes(campaign.sharePriceKes)),
              if (business.illustrativePerShareKes != null)
                _row(
                  context,
                  'Illustrative per share',
                  '${formatKes(business.illustrativePerShareKes!)} / month',
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppCopy.illustrativeFigure,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: muted),
        ),
        const SizedBox(height: AppSpacing.md),
        const SectionHeader(title: 'Monthly profit trend'),
        MiniLineChart(
          values: [for (final point in business.trend) point.primary],
          labels: [for (final point in business.trend) point.label],
        ),
        Text(
          'Profit trend from the example operating history. ${AppCopy.illustrativeAnnualized}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: muted),
        ),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
