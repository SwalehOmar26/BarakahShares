import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/business_card.dart';
import '../../../core/widgets/illustrated_cover.dart';
import '../../../core/widgets/page_body.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/verification_badge.dart';
import '../../../shared/models/business_opportunity.dart';
import '../../../shared/models/kyc_state.dart';
import '../../../shared/providers/providers.dart';

class BusinessDetailsScreen extends ConsumerWidget {
  const BusinessDetailsScreen({required this.businessId, super.key});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaign = ref.watch(campaignProvider(businessId));
    final kyc = ref.watch(kycControllerProvider);
    return campaign.when(
      loading: () =>
          const Scaffold(body: LoadingView(label: 'Loading campaign')),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(campaignProvider(businessId)),
        ),
      ),
      data: (business) => _Details(business: business, kyc: kyc),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.business, required this.kyc});

  final BusinessOpportunity business;
  final KycState kyc;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final blockedReason = switch (business.campaignStatus) {
      CampaignStatus.funded => 'This demonstration round is fully allocated.',
      CampaignStatus.inReview =>
        'This campaign is not open for contributions in the demonstration.',
      CampaignStatus.raising => null,
    };
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.forest,
            foregroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: IllustratedCover(business: business, height: 220),
            ),
          ),
          SliverToBoxAdapter(
            child: PageBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(business.name, style: text.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    business.location,
                    style: text.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
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
                      VerificationBadge(label: business.statusLabel),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const DemoNotice(message: AppConstants.disclaimerMarketplace),
                  const SizedBox(height: 14),
                  Text(business.description, style: text.bodyLarge),
                  const SizedBox(height: 16),
                  SurfaceCard(
                    child: Column(
                      children: [
                        InfoRow(
                          label: 'Registration',
                          value: business.registrationNumber,
                        ),
                        InfoRow(
                          label: 'KRA documentation',
                          value: business.kraStatus,
                        ),
                        InfoRow(
                          label: 'Halal verification',
                          value: business.halalStatus,
                        ),
                        InfoRow(
                          label: 'Funding target',
                          value: formatKes(business.fundingTarget),
                        ),
                        InfoRow(
                          label: 'Amount raised',
                          value: formatKes(business.amountRaised),
                        ),
                        InfoRow(
                          label: 'Ownership offered',
                          value:
                              '${business.ownershipOfferedPercent.toStringAsFixed(0)}%',
                        ),
                        InfoRow(
                          label: 'Minimum',
                          value: formatKes(business.minInvestment),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FundingProgress(
                    progress: business.fundingProgress,
                    label:
                        '${formatPercent(business.fundingProgress)} of the illustrative target',
                  ),
                  const SizedBox(height: 18),
                  Text('Historical financial summary', style: text.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Illustrative monthly profit ${formatKes(business.historicalMonthlyProfit)}.',
                    style: text.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  for (final month in business.history)
                    InfoRow(label: month.label, value: formatKes(month.profit)),
                  const SizedBox(height: 8),
                  Text('Investment risks', style: text.titleLarge),
                  const SizedBox(height: 8),
                  for (final risk in business.risks)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.goldDeep,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(risk)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text('Document notes', style: text.titleLarge),
                  const SizedBox(height: 8),
                  for (final document in business.documents)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(document.title),
                      subtitle: Text(document.status),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push(AppRoutes.document(document.id)),
                    ),
                  if (kyc.overall != KycStepStatus.verified) ...[
                    const SizedBox(height: 8),
                    const DemoNotice(
                      message: 'Your identity check is not verified. A mock contribution will not create a regulated investment.',
                    ),
                  ],
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Ask Barakah AI',
                    icon: Icons.auto_awesome,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.push(
                      '${AppRoutes.assistant}?businessId=${business.id}',
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (blockedReason != null) ...[
                Text(
                  blockedReason,
                  textAlign: TextAlign.center,
                  style: text.bodySmall,
                ),
                const SizedBox(height: 8),
              ],
              AppButton(
                label: 'Invest Now',
                onPressed: business.canInvest
                    ? () => context.push(AppRoutes.invest(business.id))
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
