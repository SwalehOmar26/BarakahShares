import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/business_card.dart';
import '../../core/widgets/risk_notice.dart';
import '../../core/widgets/states.dart';
import '../../models/business.dart';
import '../../models/enums.dart';
import '../../providers/providers.dart';

enum DiscoverFilter { all, halal, audited, cma, fundingSoon }

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _search = TextEditingController();
  DiscoverFilter _filter = DiscoverFilter.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businesses = ref.watch(businessesProvider);
    return AppScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text('Regulated Businesses', style: brandStyle(size: 32)),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Invest in vetted halal businesses.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search name or location',
              prefixIcon: Icon(Icons.search),
              labelText: 'Search',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              for (final filter in DiscoverFilter.values)
                FilterChip(
                  label: Text(_label(filter)),
                  selected: _filter == filter,
                  onSelected: (_) => setState(() => _filter = filter),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AsyncBody<List<Business>>(
            value: businesses,
            onRetry: () => ref.invalidate(businessesProvider),
            data: (items) {
              final visible = _apply(items);
              if (visible.isEmpty) {
                return const EmptyState(
                  title: 'No businesses match',
                  message: 'Try another filter or clear the search.',
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final business in visible) ...[
                    BusinessCard(
                      key: Key('business-card-${business.id}'),
                      business: business,
                      onView: () =>
                          context.push(AppRoutes.business(business.id)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  const RiskNotice(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<Business> _apply(List<Business> items) {
    final query = _search.text.trim().toLowerCase();
    return items.where((business) {
      final matchesQuery =
          query.isEmpty ||
          business.name.toLowerCase().contains(query) ||
          business.location.toLowerCase().contains(query);
      final matchesFilter = switch (_filter) {
        DiscoverFilter.all => true,
        DiscoverFilter.halal => business.halalCertified,
        DiscoverFilter.audited => business.audited,
        DiscoverFilter.cma => business.cmaVerified,
        DiscoverFilter.fundingSoon =>
          business.campaign.status == CampaignStatus.fundingSoon,
      };
      return matchesQuery && matchesFilter;
    }).toList();
  }

  String _label(DiscoverFilter filter) {
    return switch (filter) {
      DiscoverFilter.all => 'All',
      DiscoverFilter.halal => 'Halal Certified',
      DiscoverFilter.audited => 'Audited',
      DiscoverFilter.cma => 'CMA Verified',
      DiscoverFilter.fundingSoon => 'Funding Soon',
    };
  }
}
