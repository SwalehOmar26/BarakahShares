import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/models/business_opportunity.dart';
import '../../../shared/models/records.dart';
import '../../../shared/providers/providers.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdings = ref.watch(portfolioProvider);
    final businesses = ref.watch(businessesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Shares')),
      body: holdings.when(
        loading: () => const LoadingView(label: 'Loading shares'),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(portfolioProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyView(
              title: 'No demonstration holdings',
              message:
                  'Explore a raising campaign to record a mock contribution.',
              action: AppButton(
                label: 'Discover businesses',
                onPressed: () => context.go(AppRoutes.discover),
              ),
            );
          }
          final catalog =
              businesses.asData?.value ?? const <BusinessOpportunity>[];
          final invested = items.fold<double>(
            0,
            (sum, item) => sum + item.amountInvested,
          );
          final change = items.fold<double>(
            0,
            (sum, item) => sum + item.illustrativeValueChange,
          );
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              const DemoNotice(
                message: 'Demonstration portfolio. These holdings are sample data, not legally issued equity, and the change shown is not a guaranteed return.',
              ),
              const SizedBox(height: 12),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total invested',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      formatKes(invested),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.emerald),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Illustrative change ${change >= 0 ? '+' : ''}${formatKes(change)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final holding in items) ...[
                _HoldingTile(
                  holding: holding,
                  business: _match(catalog, holding.businessId),
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );
  }

  BusinessOpportunity? _match(List<BusinessOpportunity> businesses, String id) {
    for (final business in businesses) {
      if (business.id == id) return business;
    }
    return null;
  }
}

class _HoldingTile extends StatelessWidget {
  const _HoldingTile({required this.holding, required this.business});

  final PortfolioHolding holding;
  final BusinessOpportunity? business;

  @override
  Widget build(BuildContext context) {
    final ownership = business?.ownershipForShares(holding.shares) ?? 0;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            business?.name ?? holding.businessId,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            business?.location ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          InfoRow(label: 'Invested', value: formatKes(holding.amountInvested)),
          InfoRow(label: 'Units', value: '${holding.shares}'),
          InfoRow(
            label: 'Illustrative ownership',
            value: '${ownership.toStringAsFixed(2)}%',
          ),
          InfoRow(label: 'Invested on', value: formatDate(holding.investedOn)),
          InfoRow(label: 'Certificate', value: holding.certificateId),
          const SizedBox(height: 8),
          Center(
            child: QrImageView(
              data: 'barakahshares://certificate/${holding.certificateId}',
              size: 88,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.forest,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.emerald,
              ),
            ),
          ),
          Text(
            AppConstants.disclaimerCertificate,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () =>
                    context.push(AppRoutes.certificate(holding.certificateId)),
                child: const Text('Certificate'),
              ),
              OutlinedButton(
                onPressed: () =>
                    context.push(AppRoutes.receipts(holding.businessId)),
                child: const Text('View Receipts'),
              ),
              OutlinedButton(
                onPressed: () =>
                    context.push(AppRoutes.profit(holding.businessId)),
                child: const Text('View Profit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CertificateScreen extends ConsumerWidget {
  const CertificateScreen({required this.certificateId, super.key});

  final String certificateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holding = ref.watch(certificateProvider(certificateId));
    final user = ref.watch(authControllerProvider).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Share certificate')),
      body: holding.when(
        loading: () => const LoadingView(label: 'Opening certificate'),
        error: (error, _) => ErrorView(message: error.toString()),
        data: (item) {
          if (item == null) {
            return const EmptyView(
              title: 'Certificate not found',
              message: 'Check the number and try again.',
            );
          }
          final business = ref
              .watch(campaignProvider(item.businessId))
              .asData
              ?.value;
          final text = Theme.of(context).textTheme;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'BARAKAHSHARES',
                      style: text.labelLarge?.copyWith(
                        color: AppColors.goldDeep,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Demonstration share certificate',
                      style: text.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.certificateId,
                      style: text.headlineSmall?.copyWith(
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InfoRow(
                      label: 'Holder',
                      value: user?.fullName ?? 'Sample holder',
                    ),
                    InfoRow(
                      label: 'Business',
                      value: business?.name ?? item.businessId,
                    ),
                    InfoRow(label: 'Units', value: '${item.shares}'),
                    InfoRow(
                      label: 'Amount',
                      value: formatKes(item.amountInvested),
                    ),
                    InfoRow(label: 'Date', value: formatDate(item.investedOn)),
                    const SizedBox(height: 12),
                    QrImageView(
                      data: 'barakahshares://certificate/${item.certificateId}',
                      size: 180,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.forest,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.emerald,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const DemoNotice(message: AppConstants.disclaimerCertificate),
            ],
          );
        },
      ),
    );
  }
}

class CertificatesListScreen extends ConsumerWidget {
  const CertificatesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdings = ref.watch(portfolioProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My share certificates')),
      body: holdings.when(
        loading: () => const LoadingView(label: 'Loading certificates'),
        error: (error, _) => ErrorView(message: error.toString()),
        data: (items) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const DemoNotice(message: AppConstants.disclaimerCertificate),
            const SizedBox(height: 12),
            for (final item in items)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.certificateId),
                subtitle: Text(
                  '${item.shares} units · ${formatDate(item.investedOn)}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    context.push(AppRoutes.certificate(item.certificateId)),
              ),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final businesses =
        ref.watch(businessesProvider).asData?.value ??
        const <BusinessOpportunity>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Investment history')),
      body: transactions.when(
        loading: () => const LoadingView(label: 'Loading history'),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(transactionsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyView(
              title: 'No transactions',
              message: 'Demonstration contributions will appear here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final item = items[index];
              final name =
                  businesses
                      .where((business) => business.id == item.businessId)
                      .map((business) => business.name)
                      .firstOrNull ??
                  item.businessId;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(name),
                subtitle: Text(
                  '${item.reference}\n${item.statusLabel} · ${formatDate(item.date)}',
                ),
                isThreeLine: true,
                trailing: Text(formatKes(item.amount)),
              );
            },
          );
        },
      ),
    );
  }
}
