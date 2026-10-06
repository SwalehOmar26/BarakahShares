import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/progress_bar.dart';
import '../../core/widgets/risk_notice.dart';
import '../../core/widgets/states.dart';
import '../../models/business.dart';
import '../../providers/providers.dart';
import 'widgets/business_documents.dart';
import 'widgets/business_financials.dart';
import 'widgets/business_header.dart';
import 'widgets/campaign_progress.dart';

class BusinessDetailsScreen extends ConsumerWidget {
  const BusinessDetailsScreen({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(businessProvider(businessId));
    return AppScaffold(
      title: 'Business',
      body: AsyncBody<Business?>(
        value: business,
        onRetry: () => ref.invalidate(businessProvider(businessId)),
        data: (value) {
          if (value == null) {
            return const EmptyState(
              title: 'Business unavailable',
              message: 'This campaign is not in the demo catalogue.',
            );
          }
          return _Details(business: value);
        },
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BusinessHeader(business: business),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Business Overview'),
        Text(business.overview),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Why This Business'),
        Text(business.whyThisBusiness),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Funding Purpose'),
        Text(business.fundingPurpose),
        const SizedBox(height: AppSpacing.sm),
        Text(AppCopy.equityNotLoan),
        const SizedBox(height: AppSpacing.lg),
        BusinessFinancials(business: business),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Ownership Structure'),
        Text(
          '${formatEquity(business)} of the business is offered to investors. The owner retains the remainder and a separate profit share. Investors do not hold a debt claim.',
        ),
        const SizedBox(height: AppSpacing.lg),
        BusinessDocuments(businessId: business.id),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Blockchain Verification'),
        const Text(
          'The public record is a demo contract on Base Sepolia. It anchors hashes. It does not store IDs, selfies, or private statements.',
        ),
        const SizedBox(height: AppSpacing.lg),
        CampaignProgressSection(
          business: business,
          onInvest: () => context.push(AppRoutes.invest(business.id)),
          onChain: () => context.push(AppRoutes.chain(business.id)),
        ),
        const SizedBox(height: AppSpacing.md),
        const RiskNotice(),
      ],
    );
  }
}

String formatEquity(Business business) {
  final value = business.campaign.equityOfferedPercent;
  if (value == value.roundToDouble()) return '${value.round()}%';
  return '${value.toStringAsFixed(0)}%';
}
