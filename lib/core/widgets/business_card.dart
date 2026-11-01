import 'package:flutter/material.dart';

import '../../shared/models/business_opportunity.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import 'illustrated_cover.dart';
import 'verification_badge.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({required this.business, required this.onTap, super.key});

  final BusinessOpportunity business;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IllustratedCover(business: business, height: 132, radius: 22),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(business.name, style: text.titleMedium),
                    const SizedBox(height: 4),
                    Text(business.location, style: text.bodySmall),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        VerificationBadge(
                          label: business.verificationLabel,
                          tone: BadgeTone.verified,
                        ),
                        const VerificationBadge(
                          label: 'Shariah reviewed',
                          tone: BadgeTone.gold,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _metric(
                      context,
                      'Illustrative monthly profit',
                      formatKes(business.historicalMonthlyProfit),
                    ),
                    _metric(
                      context,
                      'Funding target',
                      formatKes(business.fundingTarget),
                    ),
                    const SizedBox(height: 8),
                    FundingProgress(
                      progress: business.fundingProgress,
                      label:
                          '${formatKes(business.amountRaised)} raised · ${formatPercent(business.fundingProgress)}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Minimum ${formatKes(business.minInvestment)}',
                      style: text.labelLarge?.copyWith(
                        color: AppColors.emerald,
                      ),
                    ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}

class FundingProgress extends StatelessWidget {
  const FundingProgress({
    required this.progress,
    required this.label,
    super.key,
  });

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 8,
              backgroundColor: AppColors.emerald.withValues(alpha: 0.12),
              color: AppColors.emerald,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
