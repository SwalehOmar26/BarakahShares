import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/investment_card.dart';
import '../../core/widgets/risk_notice.dart';
import '../../providers/providers.dart';
import '../home/widgets/portfolio_hero.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(portfolioProvider);
    return AppScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text('My Portfolio', style: brandStyle(size: 32)),
          const SizedBox(height: AppSpacing.md),
          AsyncBody<PortfolioSnapshot>(
            value: portfolio,
            onRetry: () => ref.invalidate(portfolioProvider),
            data: (snapshot) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PortfolioHero(summary: snapshot.summary),
                const SizedBox(height: AppSpacing.lg),
                for (final investment in snapshot.investments) ...[
                  InvestmentCard(
                    investment: investment,
                    onTap: () => context.push(AppRoutes.holding(investment.id)),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                const SizedBox(height: AppSpacing.md),
                const RiskNotice(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
