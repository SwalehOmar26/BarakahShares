import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/models/app_user.dart';
import '../../../shared/models/business_opportunity.dart';
import '../../../shared/models/kyc_state.dart';
import '../../../shared/models/records.dart';
import '../../../shared/providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    if (user == null) {
      return const LoadingView(label: 'Preparing your dashboard');
    }
    if (user.role == UserRole.businessOwner) return OwnerHome(user: user);
    final portfolio = ref.watch(portfolioProvider);
    final businesses = ref.watch(businessesProvider);
    return Scaffold(
      body: SafeArea(
        child: portfolio.when(
          loading: () => const LoadingView(label: 'Loading your dashboard'),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(portfolioProvider),
          ),
          data: (holdings) => businesses.when(
            loading: () => const LoadingView(label: 'Loading campaigns'),
            error: (error, _) => ErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(businessesProvider),
            ),
            data: (catalog) => _InvestorHome(
              user: user,
              holdings: holdings,
              businesses: catalog,
            ),
          ),
        ),
      ),
    );
  }
}

class _InvestorHome extends ConsumerWidget {
  const _InvestorHome({
    required this.user,
    required this.holdings,
    required this.businesses,
  });

  final AppUser user;
  final List<PortfolioHolding> holdings;
  final List<BusinessOpportunity> businesses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = PortfolioTotals(holdings: holdings, businesses: businesses);
    final kyc = ref.watch(kycControllerProvider);
    final notes = ref.watch(notificationProvider);
    final unread = notes.where((item) => !item.read).length;
    final text = Theme.of(context).textTheme;
    final featured = <PortfolioHolding>[];
    for (final id in const ['alyusra', 'amani', 'ruai']) {
      final holding = _find(holdings, id);
      if (holding != null) {
        featured.add(holding);
      }
    }
    final firstName = user.fullName.trim().split(RegExp(r'\s+')).first;

    return ListView(
      key: const Key('home-scroll'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${greetingFor(DateTime.now())}, $firstName',
                    style: text.headlineSmall?.copyWith(
                      color: AppColors.forest,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your halal investments, your future',
                    style: text.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.white,
              shape: const CircleBorder(),
              elevation: 1,
              shadowColor: AppColors.navy.withValues(alpha: 0.12),
              child: IconButton(
                tooltip: 'Notifications',
                onPressed: () => context.push(AppRoutes.notifications),
                icon: Badge(
                  isLabelVisible: unread > 0,
                  label: Text('$unread'),
                  backgroundColor: AppColors.gold,
                  textColor: AppColors.forest,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.forest,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _PortfolioHero(totals: totals),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => context.push(AppRoutes.kyc),
            child: Text(
              kyc.overall == KycStepStatus.pending
                  ? 'Identity check pending — not verified'
                  : 'Review identity status',
            ),
          ),
        ),
        const SectionHeader(title: 'Your Investments'),
        const SizedBox(height: 10),
        for (final holding in featured) ...[
          _HoldingPreview(
            holding: holding,
            business: _business(businesses, holding.businessId),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        AppButton(
          label: 'Discover Businesses',
          onPressed: () => context.go(AppRoutes.discover),
        ),
        AppButton(
          label: 'Ask Barakah AI',
          icon: Icons.auto_awesome,
          variant: AppButtonVariant.text,
          onPressed: () => context.push(AppRoutes.assistant),
        ),
        Text(
          'Sample portfolio of ${totals.businessCount} businesses. Figures are illustrative and are not a guaranteed return.',
          style: text.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  PortfolioHolding? _find(List<PortfolioHolding> holdings, String id) {
    for (final holding in holdings) {
      if (holding.businessId == id) return holding;
    }
    return null;
  }

  BusinessOpportunity? _business(
    List<BusinessOpportunity> businesses,
    String id,
  ) {
    for (final business in businesses) {
      if (business.id == id) return business;
    }
    return null;
  }
}

class _PortfolioHero extends StatelessWidget {
  const _PortfolioHero({required this.totals});

  final PortfolioTotals totals;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final change = totals.illustrativeChange;
    final changeLabel = '${change >= 0 ? '+' : ''}${formatKes(change)}';
    final fraction = totals.invested == 0
        ? 0.0
        : totals.illustrativeChange / totals.invested;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF05382C), AppColors.emerald, Color(0xFF0A4A3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Total investment',
                style: text.bodyMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.82),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF145C45),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${change >= 0 ? '+' : ''}${formatPercent(fraction)} illustrative',
                  style: text.labelSmall?.copyWith(color: AppColors.teal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatKes(totals.invested),
            key: WidgetKeys.totalInvestment,
            style: text.displayMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Illustrative change $changeLabel. Not a realized or guaranteed return.',
            style: text.bodySmall?.copyWith(
              color: AppColors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _Stat(
                  label: 'Total shares',
                  value: '${totals.shares}',
                  valueKey: WidgetKeys.totalShares,
                ),
                _Stat(
                  label: 'Businesses',
                  value: '${totals.businessCount}',
                  valueKey: WidgetKeys.totalBusinesses,
                ),
                _Stat(
                  label: 'Active campaigns',
                  value: '${totals.activeCampaigns}',
                  valueKey: WidgetKeys.activeCampaigns,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.valueKey,
  });

  final String label;
  final String value;
  final Key valueKey;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            key: valueKey,
            style: text.titleLarge?.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: text.labelSmall?.copyWith(
              color: AppColors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoldingPreview extends StatelessWidget {
  const _HoldingPreview({required this.holding, required this.business});

  final PortfolioHolding holding;
  final BusinessOpportunity? business;

  @override
  Widget build(BuildContext context) {
    final name = business?.name ?? holding.businessId;
    final text = Theme.of(context).textTheme;
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        key: ValueKey('business-card-${holding.businessId}'),
        onTap: business == null
            ? null
            : () => context.push(AppRoutes.business(business!.id)),
        child: Row(
          children: [
            _HoldingThumb(business: business),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium,
                  ),
                  if (business != null)
                    Text(
                      business!.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatKes(holding.amountInvested)} · ${holding.shares} shares',
                    style: text.labelLarge?.copyWith(color: AppColors.forest),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class _HoldingThumb extends StatelessWidget {
  const _HoldingThumb({required this.business});

  final BusinessOpportunity? business;

  @override
  Widget build(BuildContext context) {
    final category = business?.category;
    final colors = switch (category) {
      BusinessCategory.retail => const [AppColors.navy, AppColors.emerald],
      BusinessCategory.agriculture => const [
        Color(0xFF14532D),
        Color(0xFF3F6212),
      ],
      BusinessCategory.logistics => const [AppColors.navy, Color(0xFF0F766E)],
      _ => const [AppColors.forest, AppColors.teal],
    };
    final icon = switch (category) {
      BusinessCategory.retail => Icons.checkroom_rounded,
      BusinessCategory.agriculture => Icons.grass_rounded,
      BusinessCategory.logistics => Icons.local_shipping_outlined,
      _ => Icons.restaurant_rounded,
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 58,
        height: 58,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(icon, color: AppColors.gold, size: 26),
        ),
      ),
    );
  }
}

class OwnerHome extends ConsumerStatefulWidget {
  const OwnerHome({required this.user, super.key});

  final AppUser user;

  @override
  ConsumerState<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends ConsumerState<OwnerHome> {
  final _pitch = TextEditingController();
  var _saved = false;

  @override
  void dispose() {
    _pitch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        Text(
          'Business owner workspace',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 6),
        Text(
          widget.user.businessName ?? widget.user.fullName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        const DemoNotice(
          message: 'Campaign management for the NestJS admin tools is not connected. Nothing on this page is submitted to a registry or Shariah board.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _pitch,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Expansion summary',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: _saved ? 'Summary saved on this device' : 'Save summary',
          onPressed: _pitch.text.trim().length < 12 && !_saved
              ? () {
                  setState(() {});
                  showAppMessage(
                    context,
                    'Write at least a short summary before saving.',
                  );
                }
              : () {
                  setState(() => _saved = _pitch.text.trim().length >= 12);
                  showAppMessage(
                    context,
                    _saved
                        ? 'Saved in this session only. It was not sent to a server.'
                        : 'Write at least a short summary before saving.',
                  );
                },
        ),
        const SizedBox(height: 16),
        _OwnerStep(
          title: 'Documents',
          body: 'Registration and KRA files will be collected later. No file is uploaded now.',
        ),
        _OwnerStep(
          title: 'Shariah review',
          body: 'A review request is not sent from this build. The app cannot issue a ruling.',
        ),
        _OwnerStep(
          title: 'Campaign status',
          body: 'Your business is not listed in the live marketplace. Browse Discover to see sample campaigns.',
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Browse sample businesses',
          variant: AppButtonVariant.secondary,
          onPressed: () => context.go(AppRoutes.discover),
        ),
      ],
    );
  }
}

class _OwnerStep extends StatelessWidget {
  const _OwnerStep({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(body),
          ],
        ),
      ),
    );
  }
}
