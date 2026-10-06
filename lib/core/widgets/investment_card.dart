import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/investment.dart';

class InvestmentCard extends StatelessWidget {
  const InvestmentCard({super.key, required this.investment, this.onTap});

  final Investment investment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkMuted
        : AppColors.darkMuted;
    return AppCard(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  investment.businessName,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const StatusBadge(
                label: 'Active',
                tone: BadgeTone.success,
                icon: Icons.check,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Investment ${formatKes(investment.amountKes)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Ownership ${formatPercent(investment.ownershipPercent)} · ${formatKes(investment.illustrativeMonthlyKes)} / month illustrative',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: muted),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            investment.certificateCode,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(letterSpacing: 0.4),
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkMuted
        : AppColors.darkMuted;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            trailing,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
