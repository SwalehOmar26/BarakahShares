import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/widgets/business_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/models/business_opportunity.dart';
import '../../../shared/providers/providers.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _search = TextEditingController();
  BusinessCategory? _category;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businesses = ref.watch(businessesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: businesses.when(
        loading: () => const LoadingView(label: 'Loading businesses'),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(businessesProvider),
        ),
        data: (items) {
          final query = _search.text.trim().toLowerCase();
          final filtered = items.where((business) {
            final categoryMatches =
                _category == null || business.category == _category;
            final textMatches =
                query.isEmpty ||
                business.name.toLowerCase().contains(query) ||
                business.location.toLowerCase().contains(query);
            return categoryMatches && textMatches;
          }).toList();
          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              ref.invalidate(businessesProvider);
              await ref.read(businessesProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                const DemoNotice(message: AppConstants.disclaimerMarketplace),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('discover-search'),
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Search businesses or locations',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _category == null,
                      onSelected: (_) => setState(() => _category = null),
                    ),
                    for (final category in BusinessCategory.values)
                      FilterChip(
                        label: Text(_label(category)),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (filtered.isEmpty)
                  const EmptyView(
                    title: 'No businesses match',
                    message: 'Try another category or clear the search.',
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth > 700;
                      if (!wide) {
                        return Column(
                          children: [
                            for (final business in filtered) ...[
                              BusinessCard(
                                key: ValueKey('discover-${business.id}'),
                                business: business,
                                onTap: () => context.push(
                                  AppRoutes.business(business.id),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                          ],
                        );
                      }
                      return Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          for (final business in filtered)
                            SizedBox(
                              width: (constraints.maxWidth - 14) / 2,
                              child: BusinessCard(
                                business: business,
                                onTap: () => context.push(
                                  AppRoutes.business(business.id),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _label(BusinessCategory category) => switch (category) {
    BusinessCategory.restaurants => 'Restaurants',
    BusinessCategory.retail => 'Retail',
    BusinessCategory.agriculture => 'Agriculture',
    BusinessCategory.logistics => 'Logistics',
  };
}
