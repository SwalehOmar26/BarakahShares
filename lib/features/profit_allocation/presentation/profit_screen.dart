import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/providers/providers.dart';
import 'donut_chart.dart';

class ProfitScreen extends ConsumerWidget {
  const ProfitScreen({required this.businessId, super.key});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(profitProvider(businessId));
    final requested = ref.watch(distributionProvider).contains(businessId);
    final business = ref.watch(campaignProvider(businessId)).asData?.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Profit allocation')),
      body: snapshot.when(
        loading: () => const LoadingView(label: 'Loading the period'),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(profitProvider(businessId)),
        ),
        data: (profit) {
          final text = Theme.of(context).textTheme;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Text(business?.name ?? businessId, style: text.headlineSmall),
              Text(profit.periodLabel, style: text.bodySmall),
              const SizedBox(height: 12),
              const DemoNotice(message: AppConstants.disclaimerReturns),
              const SizedBox(height: 16),
              DonutChart(
                centerLabel: 'Net profit',
                centerValue: formatKes(profit.netProfit),
                slices: [
                  DonutSlice(
                    label: 'Expenses',
                    value: profit.expenses,
                    color: AppColors.navy,
                  ),
                  DonutSlice(
                    label: 'Net profit',
                    value: profit.netProfit,
                    color: AppColors.emerald,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SurfaceCard(
                child: Column(
                  children: [
                    InfoRow(
                      label: 'Gross sales',
                      value: formatKes(profit.grossSales),
                    ),
                    InfoRow(
                      label: 'Expenses',
                      value: formatKes(profit.expenses),
                    ),
                    InfoRow(
                      label: 'Net profit',
                      value: formatKes(profit.netProfit),
                    ),
                    InfoRow(
                      label: 'Your illustrative allocation',
                      value: formatKes(profit.investorAllocation),
                    ),
                    InfoRow(
                      label: 'Share of net profit',
                      value: formatRatio(
                        profit.investorAllocation,
                        profit.netProfit,
                      ),
                    ),
                    InfoRow(
                      label: 'Distribution status',
                      value: requested
                          ? 'Requested (demonstration)'
                          : profit.distributionStatus,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'The allocation is a sample figure for this period. It is not a declared dividend and it is not calculated as a guaranteed percentage of your contribution.',
                style: text.bodyMedium,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: requested
                    ? 'Distribution requested'
                    : 'Request distribution',
                onPressed: requested
                    ? null
                    : () {
                        ref
                            .read(distributionProvider.notifier)
                            .request(businessId);
                        showInfoDialog(
                          context,
                          title: 'No transfer was made',
                          message: 'The request is stored only in this session. Distribution status stays illustrative, and no withdrawal was sent to M-Pesa or a bank.',
                        );
                      },
              ),
            ],
          );
        },
      ),
    );
  }
}
