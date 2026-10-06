import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/investment.dart';

class PortfolioHero extends StatelessWidget {
  const PortfolioHero({super.key, required this.summary, this.compact = false});

  final PortfolioSummary summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.jewelDepth,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Investment',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            formatKes(summary.totalInvestedKes),
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _mini(
                  context,
                  'Total Dividends',
                  formatKes(summary.totalDividendsKes),
                ),
              ),
              Expanded(
                child: _mini(
                  context,
                  'Active Shares',
                  '${summary.activeBusinesses} Businesses',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mini(BuildContext context, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.goldOnDark),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
