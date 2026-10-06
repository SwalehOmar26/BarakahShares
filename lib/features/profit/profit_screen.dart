import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/phone_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/charts.dart';
import '../../core/widgets/risk_notice.dart';
import '../../core/widgets/states.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/enums.dart';
import '../../models/profit_distribution.dart';
import '../../providers/providers.dart';

class ProfitScreen extends ConsumerWidget {
  const ProfitScreen({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profit = ref.watch(profitProvider(businessId));
    return AppScaffold(
      title: 'Profit Distribution',
      body: AsyncBody<ProfitDistribution?>(
        value: profit,
        onRetry: () => ref.invalidate(profitProvider(businessId)),
        data: (value) {
          if (value == null) {
            return const EmptyState(
              title: 'No distribution yet',
              message: 'An illustrative allocation appears after an approved profit period.',
            );
          }
          return _ProfitBody(distribution: value);
        },
      ),
    );
  }
}

class _ProfitBody extends ConsumerWidget {
  const _ProfitBody({required this.distribution});

  final ProfitDistribution distribution;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phone = ref.watch(authControllerProvider).user?.phone;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          distribution.periodLabel,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'Monthly Net Profit',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          formatKes(distribution.netProfitKes),
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.md),
        AllocationChart(
          ownerPercent: distribution.ownerPercent,
          investorPercent: distribution.investorPoolPercent,
        ),
        Row(
          children: const [
            _Legend(color: AppColors.deepGreen, label: 'Business Owner'),
            SizedBox(width: AppSpacing.md),
            _Legend(color: AppColors.gold, label: 'Investor Pool'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _row(
                context,
                'Business Owner',
                '${formatPercent(distribution.ownerPercent, digits: 0)} · ${formatKes(distribution.ownerShareKes)}',
              ),
              _row(
                context,
                'Investor Pool',
                '${formatPercent(distribution.investorPoolPercent, digits: 0)} · ${formatKes(distribution.investorPoolKes)}',
              ),
              _row(
                context,
                'Your Share',
                '${distribution.sharesOwned} / ${distribution.totalShares}',
              ),
              _row(
                context,
                'Your Distribution',
                formatKes(distribution.yourDistributionKes),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        StatusBadge(
          label: distribution.status.label,
          tone: distribution.status == DistributionStatus.disbursed
              ? BadgeTone.success
              : BadgeTone.warning,
          icon: distribution.status == DistributionStatus.disbursed
              ? Icons.check
              : Icons.schedule,
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Calculation', style: brandStyle(size: 22)),
        const SizedBox(height: AppSpacing.xs),
        _row(context, 'Gross Sales', formatKes(distribution.grossSalesKes)),
        _row(context, 'Expenses', formatKes(distribution.expensesKes)),
        _row(context, 'Net Profit', formatKes(distribution.netProfitKes)),
        _row(context, 'Owner Share', formatKes(distribution.ownerShareKes)),
        _row(context, 'Investor Pool', formatKes(distribution.investorPoolKes)),
        _row(
          context,
          'Your Distribution',
          formatKes(distribution.yourDistributionKes),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(AppCopy.illustrativeDistribution),
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          label: 'View Distribution Record',
          onPressed: () =>
              context.push(AppRoutes.chain(distribution.businessId)),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: 'Withdraw via M-PESA',
          onPressed: () => _withdraw(context, phone),
        ),
        const SizedBox(height: AppSpacing.md),
        const RiskNotice(),
      ],
    );
  }

  Future<void> _withdraw(BuildContext context, String? phone) async {
    final shown = phone == null
        ? 'your registered number'
        : formatKenyaPhone(phone);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw via M-PESA'),
        content: Text(
          'Demo withdrawal recorded for $shown. No Daraja request was sent, and no funds moved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
