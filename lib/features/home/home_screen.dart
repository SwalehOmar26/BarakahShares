import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/charts.dart';
import '../../core/widgets/investment_card.dart';
import '../../core/widgets/progress_bar.dart';
import '../../core/widgets/risk_notice.dart';
import '../../models/enums.dart';
import '../../models/investment.dart';
import '../../models/records.dart';
import '../../providers/providers.dart';
import 'widgets/portfolio_hero.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final portfolio = ref.watch(portfolioProvider);
    final activity = ref.watch(activitiesProvider);
    final name = user?.firstName ?? 'Investor';
    return AppScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Assalamu Alaikum',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.inkMuted),
          ),
          Text('${_greeting()}, $name', style: brandStyle(size: 30)),
          if (user?.role == UserRole.businessOwner) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Owner tools are not in this mobile release. You are viewing the investor experience.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AsyncBody<PortfolioSnapshot>(
            value: portfolio,
            onRetry: () => ref.invalidate(portfolioProvider),
            data: (snapshot) => _PortfolioBlock(snapshot: snapshot),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: 'Recent Activity'),
          AsyncBody<List<ActivityItem>>(
            value: activity,
            onRetry: () => ref.invalidate(activitiesProvider),
            data: (items) {
              final preview = items.take(3).toList();
              if (preview.isEmpty) {
                return const Text('No activity yet.');
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final item in preview) ...[
                    TransactionCard(
                      title: item.title,
                      subtitle: '${item.subtitle} · ${formatDate(item.date)}',
                      trailing: '',
                      onTap: () =>
                          context.push(AppRoutes.receipts(item.businessId)),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          const RiskNotice(),
        ],
      ),
    );
  }
}

class _PortfolioBlock extends StatelessWidget {
  const _PortfolioBlock({required this.snapshot});

  final PortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final summary = snapshot.summary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PortfolioHero(summary: summary),
        const SizedBox(height: AppSpacing.md),
        const SectionHeader(title: 'Monthly dividends'),
        MiniLineChart(
          values: summary.dividendHistory,
          labels: PortfolioSummary.historyLabels,
        ),
        Text(
          'Figures are illustrative distributions already recorded, not a forecast.',
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.inkMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: 'Discover Businesses',
          onPressed: () => context.go(AppRoutes.discover),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'My Investments'),
        for (final investment in snapshot.investments) ...[
          InvestmentCard(
            investment: investment,
            onTap: () => context.push(AppRoutes.holding(investment.id)),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}
