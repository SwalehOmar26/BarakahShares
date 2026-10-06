import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/states.dart';
import '../../providers/providers.dart';

class SuccessScreen extends ConsumerWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(lastContributionProvider);
    return AppScaffold(
      body: record == null
          ? const EmptyState(
              title: 'No contribution yet',
              message: 'Complete an investment to see the confirmation.',
              icon: Icons.task_alt,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppSpacing.xl),
                const Icon(
                  Icons.check_circle,
                  size: 72,
                  color: AppColors.success,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Contribution Successful',
                  style: brandStyle(size: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Your investment has been recorded.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.businessName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _row(context, 'Investment', formatKes(record.amountKes)),
                      _row(
                        context,
                        'Share',
                        formatPercent(record.ownershipPercent),
                      ),
                      _row(context, 'Certificate', record.certificateCode),
                      _row(
                        context,
                        'Transaction',
                        truncateMiddle(record.txHash),
                      ),
                      _row(context, 'Status', record.status),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Amanah as Code',
                  style: brandStyle(size: 20, color: AppColors.gold),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'View My Shares',
                  onPressed: () => context.go(AppRoutes.portfolio),
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: 'View Certificate',
                  onPressed: () =>
                      context.push(AppRoutes.holding(record.investmentId)),
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: 'View Blockchain Record',
                  onPressed: () =>
                      context.push(AppRoutes.chain(record.businessId)),
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
